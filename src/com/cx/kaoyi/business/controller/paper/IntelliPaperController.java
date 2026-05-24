package com.cx.kaoyi.business.controller.paper;

import com.aspose.words.Document;
import com.aspose.words.MarkdownLoadOptions;
import com.aspose.words.SaveFormat;
import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.domain.exampaper.ExampaperQuestionType;
import com.cx.kaoyi.business.domain.exampaper.db.ExampaperAnswerDb;
import com.cx.kaoyi.business.domain.exampaper.db.ExampaperQuestionDb;
import com.cx.kaoyi.business.domain.exampaper.db.ExampaperQuestionTypeDb;
import com.cx.kaoyi.business.service.PaperService;
import com.cx.kaoyi.business.service.VerifyService;
import com.cx.kaoyi.framework.GPT.generateDTO.business.QuestionGeneratorConfig;
import com.cx.kaoyi.framework.GPT.utils.AIUtils;
import com.cx.kaoyi.framework.GPT.utils.normal.StringMessageCharger;
import com.cx.kaoyi.framework.base.BaseController;
import com.cx.kaoyi.framework.base.FileDownloadUtils;


import com.cx.kaoyi.framework.cache.LocalCache;
import com.cx.kaoyi.framework.handler.PaperObjBuilder;

import com.cx.kaoyi.framework.utils.WebFilePath;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/intelliPaper")
public class IntelliPaperController extends BaseController {
    @Autowired
    private PaperService paperService;
    @Autowired
    private VerifyService verifyService;

    @PostMapping("/testPaperByAI")
    public String testPaperByAI(@RequestParam("eid") String eid) {
        User u = getUserInfo();
        if(u==null){
            return "noRoot";
        }
        if(!getSubject().hasRole("administrator")) {
            Map map = new HashMap();
            map.put("uid", u.getId());
            map.put("eid", eid);
            map.put("permission", "paper:update");
            if (verifyService.checkPaperPermission(map) == 0) {
                return "noRoot";
            }
        }

        LocalCache cache = LocalCache.getInstance();
        if(cache.get("analysis_mission",eid+"_examPaperAIAnalysis")!=null){
            return "running";
        }

        List<ExampaperQuestionDb> questionRaw = paperService.getExampaperQuestionRaw(eid);
        List<ExampaperAnswerDb>  answerRaw = paperService.getExampaperAnswerRaw(eid);
        List<ExampaperQuestionTypeDb> questionTypeRaw = paperService.getExampaperQuestionTypeRaw(eid);
        List<ExampaperQuestionType> questionTypesWithQuestionList =
                PaperObjBuilder.buildExampaperQuestionTypesWithQuestionList(questionTypeRaw, questionRaw, answerRaw);
        String str = PaperObjBuilder.buildAllExampaperString(questionTypesWithQuestionList);
        String role = "你是一个试卷分析助手，我将会把试卷信息发送给你，你将会从错别字检测、试题重复率检测、题型题量分析检测"
                +"这3个维度去分析这份试卷，你返回给我的所有内容都是markdown格式的，是一份标准的报告格式。格式如下："+QuestionGeneratorConfig.getConfigMap().get("questionFromPaperCheck");
        boolean isTaskRunning = cache.getOrSet("analysis_mission",eid+"_examPaperAIAnalysis",1);
        if(!isTaskRunning){
            new Thread(() -> {
                try {
                    Path tmpAIDocxPath = Paths.get(WebFilePath.getProjectPath(), "tmpAIDocx", eid+".docx");
                    Files.createDirectories(tmpAIDocxPath.getParent());
                    String aiRtn = StringMessageCharger.sendMessage(role,"试卷内容："+str, 1, "ernie-x1-turbo-32k", QuestionGeneratorConfig.getAPIKeyV2());
                    if(StringUtils.isNotBlank(aiRtn)){
                        byte[] bytes = AIUtils.replaceMarkDownJson(aiRtn).getBytes(StandardCharsets.UTF_8);
                        ByteArrayInputStream mdStream = new ByteArrayInputStream(bytes);

                        // 3. 指定加载选项为 Markdown
                        MarkdownLoadOptions loadOptions = new MarkdownLoadOptions();

                        // 5. 保存成 DOCX
                        try (OutputStream fos = Files.newOutputStream(
                                tmpAIDocxPath,
                                StandardOpenOption.CREATE,
                                StandardOpenOption.TRUNCATE_EXISTING)) {
                            // 4. 用流 + 选项构造 Document
                            Document doc2 = new Document(mdStream, loadOptions);
                            doc2.save(fos, SaveFormat.DOCX);
                        } catch (Exception e) {
                            throw new RuntimeException(e);
                        }
                    }
                }catch (Exception ex){
                    logger.error("试卷内容分析失败 eid={}", eid, ex);
                }finally {
                    cache.evict("analysis_mission",eid+"_examPaperAIAnalysis");
                }
            }).start();
        }
        return "success";
    }

    @GetMapping("/downloadTestPaperDocxByAI")
    public ResponseEntity<Resource> downloadTestPaperDocx(@RequestParam("eid") String eid) throws IOException {
        User u = getUserInfo();
        if(u==null){
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        if(!getSubject().hasRole("administrator")) {
            Map map = new HashMap();
            map.put("uid", u.getId());
            map.put("eid", eid);
            map.put("permission", "paper:update");
            if (verifyService.checkPaperPermission(map) == 0) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }
        }
        Path tmpAIDocxPath = Paths.get(WebFilePath.getProjectPath(), "tmpAIDocx", eid+".docx");
        if (!Files.exists(tmpAIDocxPath) || !Files.isRegularFile(tmpAIDocxPath)) {
            Files.deleteIfExists(tmpAIDocxPath);
            return ResponseEntity.notFound().build();
        }
        return FileDownloadUtils.download(tmpAIDocxPath);
    }

    @GetMapping("/getTestPaperDocxByAIInfo")
    public ResponseEntity<Map<String,Object>> getTestPaperDocxByAIInfo(@RequestParam("eid") String eid) throws IOException {
        User u = getUserInfo();
        if (u == null) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
        }
        if (!getSubject().hasRole("administrator")) {
            Map map = new HashMap();
            map.put("uid", u.getId());
            map.put("eid", eid);
            map.put("permission", "paper:update");
            if (verifyService.checkPaperPermission(map) == 0) {
                return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
            }
        }

        Path docxPath = Paths.get(WebFilePath.getProjectPath(), "tmpAIDocx", eid + ".docx");

        boolean exists = Files.exists(docxPath) && Files.isRegularFile(docxPath);
        String lastModified = exists
                ? Files.getLastModifiedTime(docxPath).toInstant().toString() // 2025-07-18T10:08:15Z
                : null;

        // 是否有任务正在分析（和 /testPaperByAI 用同一把锁）
        boolean running = LocalCache.getInstance()
                .get("analysis_mission", eid + "_examPaperAIAnalysis") != null;

        Map<String,Object> rtn = new HashMap<>();
        rtn.put("exists", exists);
        rtn.put("lastModified", lastModified);
        rtn.put("running", running);
        return ResponseEntity.ok(rtn);
    }
}