package com.cx.kaoyi.framework.question.repeat;

import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.framework.base.BaseService;
import com.cx.kaoyi.framework.question.dto.DuplicatePairDTO;
import com.cx.kaoyi.framework.question.dto.ExampaperQuestionInRepeat;
import com.cx.kaoyi.framework.utils.DateFormatUtils;
import com.cx.kaoyi.framework.utils.result.GenerateWordUtils;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.DisposableBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;

import javax.annotation.PostConstruct;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.ThreadPoolExecutor;
import java.util.concurrent.TimeUnit;

@Service
public class PaperChangeRecorder extends BaseService implements DisposableBean {
    private static final Logger logger = LoggerFactory.getLogger(PaperChangeRecorder.class);

    @Value("${openFindRepeatSystem:0}")
    private Integer openFindRepeatSystem;

    @Autowired
    private StatsApiClient statsApiClient;

    private ExecutorService executor;

    @PostConstruct
    public void init() {
        if(openFindRepeatSystem==0){
            logger.info("PaperChangeRecorder closed: 查重系统线程未开启");
            return;
        }
        // 线程池：core=15, max=50, 阻塞队列不限制
        executor = new ThreadPoolExecutor(
                15, 50,
                0L, TimeUnit.MILLISECONDS,
                new LinkedBlockingQueue<>(),
                runnable -> {
                    Thread t = new Thread(runnable, "PaperChangeRecorder-Thread");
                    t.setDaemon(true);
                    return t;
                }
        );
        logger.info("PaperChangeRecorder initialized: 查重系统线程开启");
    }

    public void recordPaperChange(String eid){
        if(openFindRepeatSystem==0 || StringUtils.isBlank(eid)){
            return;
        }
        executor.submit(() -> {
            try{
                insert("resources.mappers.paper.recordPaperChange", eid);
            }catch (Exception e){
                logger.error("新增试卷变更记录异常", e);
            }
        });
    }

    public int recordPaperRepeatPdf(Map<String,Object> examinfo, String action, User user){
        if(openFindRepeatSystem==0 || examinfo.isEmpty() || examinfo.get("ID")==null){
            return 0;
        }
        final String eid = (String) examinfo.get("ID");
        executor.submit(() -> {
            try{
                Map<String,Object> model = new HashMap<>();
                Map<String,List<DuplicatePairDTO>> questionMap = statsApiClient.statsDetailByExam(
                        eid,
                        (String) examinfo.get("BID")
                );
                for (Map.Entry<?, List<DuplicatePairDTO>> entry : questionMap.entrySet()) {
                    List<DuplicatePairDTO> questionList = entry.getValue();
                    if (questionList == null) {
                        continue;
                    }
                    for (DuplicatePairDTO question : questionList) {
                        if (question == null) {
                            continue;
                        }
                        ExampaperQuestionInRepeat questionOrigin = question.getOrigin();
                        ExampaperQuestionInRepeat duplicate = question.getDuplicate();
                        if (questionOrigin != null && questionOrigin.getContentRaw() != null) {
                            questionOrigin.setContentRaw(HtmlImgSrcProcessor.process(questionOrigin.getContentRaw()));
                        }
                        if (duplicate != null && duplicate.getContentRaw() != null) {
                            duplicate.setContentRaw(HtmlImgSrcProcessor.process(duplicate.getContentRaw()));
                        }
                    }
                }
                model.put("repeatDetail", questionMap);
                model.put("checkTeacher", user.getRealname() + "（ " + user.getUsername() + " ）");
                model.put("checkTimeStr", DateFormatUtils.getNowTime4ZhCN());

                model.put("ename", examinfo.get("ENAME") + "（" +eid + "）");
                int rtn = statsApiClient.uploadHtmlAsPdf(eid, eid+"_"+action+".pdf",
                        GenerateWordUtils.getFtlStr("wenzhouPaper/examRepeatDetail.ftl", model));
                if(rtn==0){
                    logger.error("记录试卷查重PDF上传失败");
                }
            }catch (Exception e){
                logger.error("记录试卷查重PDF上传错误", e);
            }
        });
        return 1;
    }

    @Override
    public void destroy() throws Exception {
        if (executor != null) {
            executor.shutdown();
            if (!executor.awaitTermination(5, TimeUnit.SECONDS)) {
                executor.shutdownNow();
            }
            logger.info("PaperChangeRecorder 线程池已关闭");
        }
    }

}
