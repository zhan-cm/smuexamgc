package com.cx.kaoyi.business.controller.question;

import com.cx.kaoyi.business.component.ConvertVideo;
import com.cx.kaoyi.business.domain.Theme;
import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.service.CourseService;
import com.cx.kaoyi.business.service.QuestionService;
import com.cx.kaoyi.business.service.serviceImpl.IntelliQuestionService;
import com.cx.kaoyi.framework.GPT.generateDTO.GeneratedQuestion;
import com.cx.kaoyi.framework.GPT.generateDTO.MainGeneratedQuestion;
import com.cx.kaoyi.framework.GPT.generateDTO.QuestionGeneratedParam;
import com.cx.kaoyi.framework.GPT.generateDTO.business.GenerateAsyncTask;
import com.cx.kaoyi.framework.GPT.generateDTO.business.ImportQuestionAsyncTask;
import com.cx.kaoyi.framework.GPT.generateDTO.business.QuestionGenerateThreadPool;
import com.cx.kaoyi.framework.GPT.operationDTO.business.QuestionEditInfo;
import com.cx.kaoyi.framework.GPT.operationDTO.business.QuestionEditStatus;
import com.cx.kaoyi.framework.GPT.operationDTO.business.QuestionIntelliEditAction;
import com.cx.kaoyi.framework.GPT.utils.QuestionClassUtils;
import com.cx.kaoyi.framework.GPT.utils.operate.QuestionOperatorCharger;
import com.cx.kaoyi.framework.base.ApiResponse;
import com.cx.kaoyi.framework.base.BaseController;
import com.cx.kaoyi.framework.base.FileDownloadUtils;
import com.cx.kaoyi.framework.base.MyHttpStatus;


import com.cx.kaoyi.framework.cache.LocalCache;
import com.cx.kaoyi.framework.utils.PaperContentUtils;
import com.cx.kaoyi.framework.utils.ThemeUtils;
import com.cx.kaoyi.framework.utils.Utils;
import com.cx.kaoyi.framework.xunfei.dto.local.VoiceRoleParam;
import com.cx.kaoyi.framework.xunfei.dto.local.VoiceWantedParam;
import com.cx.kaoyi.framework.xunfei.utils.WebTtsWsService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.FileOutputStream;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.RejectedExecutionException;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Controller
@RequestMapping("/intelliQuestion")
public class IntelliQuestionController extends BaseController {

    @Autowired
    private QuestionService questionService;

    @Autowired
    private IntelliQuestionService intelliQuestionService;

    @Autowired
    private CourseService courseService;

    @RequestMapping("/EnglishTextToSound")
    public ResponseEntity<Resource> EnglishTextToSound(@RequestBody VoiceWantedParam voiceWantedParam) throws Exception {
        // 获取TTS的密钥信息
        Map<String, Object> keyForTTS = (Map<String, Object>) getApplication().getAttribute("AI_En_TTS");
        String appid = String.valueOf(keyForTTS.get("YL_2"));
        String apiSecret = String.valueOf(keyForTTS.get("YL_3"));
        String apiKey = String.valueOf(keyForTTS.get("YL_4"));
        String tempDir = String.valueOf(keyForTTS.get("YL_5"));

        // 权限验证逻辑
        if (getUserInfo() == null || !"1".equals(keyForTTS.get("YL_1"))
                || StringUtils.isBlank(appid) || StringUtils.isBlank(apiSecret)
                || StringUtils.isBlank(apiKey) || StringUtils.isBlank(tempDir)) {
            return ResponseEntity.status(HttpStatus.FORBIDDEN).build();
        }

        File dir = new File(tempDir);
        if(!dir.exists()){
            dir.mkdirs();
        }

        List<VoiceRoleParam> voiceRoleParams = voiceWantedParam.getVoiceRoleParam();
        int pitch = voiceWantedParam.getPitch();
        int speed = voiceWantedParam.getSpeed();
        String pause = "[p"+voiceWantedParam.getPause()+"]"; //[p500]就代表这个部位要停顿500ms
        WebTtsWsService webTtsWsService = new WebTtsWsService(appid, apiSecret, apiKey);
        List<String> mp3FilePaths = new ArrayList<>();
        String sessionId=getSession().getId().toString();
        // 循环合成每段语音并保存为临时MP3文件
        for (int i = 0; i < voiceRoleParams.size(); i++) {
            VoiceRoleParam voiceRoleParam = voiceRoleParams.get(i);
            String contentText = voiceRoleParam.getText();
            if(i<voiceRoleParams.size()-1){ //不是最后一段的话就加上一个对话停顿
                contentText += pause;
            }
            CompletableFuture<byte[]> res = webTtsWsService.sendMessage(contentText, voiceRoleParam.getVcn(), speed, pitch);
            byte[] soundFileBase64 = res.get();

            // 保存每段音频为临时MP3文件
            String tempFilePath = tempDir +  sessionId + System.currentTimeMillis() + ".mp3";  // 临时文件路径
            try (FileOutputStream fos = new FileOutputStream(tempFilePath)) {
                fos.write(soundFileBase64);
                mp3FilePaths.add(tempFilePath);  // 保存文件路径
            }
        }

        webTtsWsService.closeConnection();  // 关闭TTS连接

        // 使用FFmpeg合并所有生成的MP3文件
        String mergedFilePath = tempDir + sessionId + System.currentTimeMillis()+ "_merged.mp3";
        ConvertVideo.mergeMp3Files(mp3FilePaths, mergedFilePath);

        // 删除临时文件
        for (String path : mp3FilePaths) {
            Files.delete(Paths.get(path));  // 删除每个临时MP3文件
        }
        return FileDownloadUtils.download(mergedFilePath);
    }

    @RequestMapping("/checkIsGenerating")
    public @ResponseBody boolean checkIsGenerating(){
        String cid = getPara("cid");
        boolean batchGenerating = QuestionGenerateThreadPool.getInstance().isTaskRunning(cid);
        return batchGenerating;
    }

    @RequestMapping("/intoQuestionAIModule")
    public String intoQuestionAIModule(){
        if(getUserInfo()==null || !"1".equals(getApplication().getAttribute("AI_V2_switch"))){
            return "jsp/notTheRole";
        }
        String cid = getPara("cid");
        getRequest().setAttribute("cid",cid);
        getRequest().setAttribute("cname",getPara("cname"));
        return "jsp/question/questionAIModule";
    }

    @RequestMapping("/getGeneratedQuestionByCid")
    public @ResponseBody Map<String, Object> getGeneratedQuestionByCid(){
        Map<String,Object> param = new HashMap<>();
        param.put("cid",getPara("cid"));
        setMapParamSafe(param,"state");
        setMapParamSafe(param,"source");
        setMapParamSafe(param,"theme1id");
        setMapParamSafe(param,"theme2id");
        setMapParamSafe(param,"theme3id");
        setMapParamSafe(param,"qtid");
        setMapParamSafe(param,"teacher");
        setMapParamSafe(param,"question");
        return getRes(intelliQuestionService.getGeneratedQuestionByCid(param, getPageUtil()),intelliQuestionService.getGeneratedQuestionCountByCid(param));
    }

    @RequestMapping("/delSelectQuestion")
    public @ResponseBody int delSelectQuestion(@RequestBody List<Map<String,Object>> qidAndIsmain){
        if(getUserInfo()==null || qidAndIsmain==null || qidAndIsmain.isEmpty()){
            return -1;
        }
        return intelliQuestionService.deleteSelectedQuestionAI(qidAndIsmain);
    }

    @RequestMapping("/selectQidToUse")
    public @ResponseBody int selectQidToUse(){
        if(getUserInfo()==null){
            return -1;
        }
        Map<String,String> param = new HashMap<>();
        param.put("cid",getPara("cid"));
        param.put("qid",getPara("qid"));
        param.put("ismain", getPara("ismain"));
        param.put("answerid",getPara("answerid"));
        return intelliQuestionService.insertQuestionAIIntoFormal(param)+1;
    }

    @RequestMapping("/selectQidsToUse")
    public @ResponseBody int selectQidsToUse(@RequestBody List<Map<String,String>> list){
        if(getUserInfo()==null){
            return -1;
        }
        int rtn = 0;
        for(Map<String,String> map : list){
            rtn += intelliQuestionService.insertQuestionAIIntoFormal(map);
        }
        return rtn+1;
    }

    @RequestMapping("/delQuestionByQid")
    public @ResponseBody int delQuestionByQid(){
        String qid = getPara("qid");
        int ismain = Utils.changeObjToInt(getPara("ismain"));
        if(getUserInfo()==null || StringUtils.isBlank(qid)){
            return -1;
        }
        return intelliQuestionService.delQuestionByQid(qid, ismain);
    }

    @RequestMapping("/generateQuestionBatch")
    public @ResponseBody ApiResponse<?> generateQuestionBatch(@RequestBody Map<String,Object> params){
        User user = getUserInfo();
        if(getUserInfo()==null || !"1".equals(getApplication().getAttribute("AI_V2_switch"))){
            return ApiResponse.status(MyHttpStatus.UNAUTHORIZED).message("没有AI出题的权限").build();
        }

        String cid = (String) params.get("cid");
        String cname = (String) params.get("cname");
        if(QuestionGenerateThreadPool.getInstance().isTaskRunning(cid)){
            return ApiResponse.status(MyHttpStatus.FAIL).message("该课程已有一个AI任务运行中").build();
        }

        List<Map<String,Object>> questionList = (List<Map<String,Object>>) params.get("data");
        List<QuestionGeneratedParam> questionGeneratedParamList = new ArrayList<>();
        for (Map<String, Object> question : questionList) {
            String theme1Id = Objects.toString(question.get("theme1Id"),"");
            String theme2Id = Objects.toString(question.get("theme2Id"),"");
            String theme3Id = Objects.toString(question.get("theme3Id"),"");
            String theme1Name = Objects.toString(question.get("theme1Name"),"");
            String theme2Name = Objects.toString(question.get("theme2Name"),"");
            String theme3Name = Objects.toString(question.get("theme3Name"),"");
            String qtid = String.valueOf(question.get("qtid"));
            Integer atid = Integer.parseInt(String.valueOf(question.get("atid")));
            Integer iscon = Integer.parseInt(String.valueOf(question.get("iscon")));
            String qtname = String.valueOf(question.get("qtName"));
            Integer questionCount = Utils.changeObjToInt(question.get("questionCount"));

            String themePath = Stream.of(theme1Name, theme2Name, theme3Name)
                    .filter(s -> StringUtils.isNotBlank(s))
                    .collect(Collectors.joining("/"));
            for (int i = 0; i < questionCount; i++) {
                QuestionGeneratedParam questionGeneratedParam = new QuestionGeneratedParam(
                        user.getId(), user.getRealname(),
                        theme1Id, theme2Id, theme3Id, qtid, cname, themePath, atid, iscon, qtname);
                questionGeneratedParamList.add(questionGeneratedParam);
            }
        }
        if(!questionGeneratedParamList.isEmpty()){
            try {
                boolean submitSuccess = QuestionGenerateThreadPool.getInstance().submitTask(
                        cid, new GenerateAsyncTask(cid,questionGeneratedParamList,intelliQuestionService)
                );
                if(submitSuccess){
                    return ApiResponse.status(MyHttpStatus.SUCCESS).message("AI出题任务执行成功").build();
                }else{
                    return ApiResponse.status(MyHttpStatus.FAIL).message("AI出题线程队列已满，请排队").build();
                }
            } catch (RejectedExecutionException e) {
                return ApiResponse.status(MyHttpStatus.FAIL).message("AI出题线程队列已满，请排队").build();
            }
        }
        return ApiResponse.status(MyHttpStatus.PARTIAL_SUCCESS).message("未查询到需要生成的题目").build();
    }

    @RequestMapping("/generateAllCourseThemeRandomBatch")
    public @ResponseBody ApiResponse<?> generateAllCourseThemeRandomBatch(@RequestBody Map<String,Object> params){
        User user = getUserInfo();
        if(getUserInfo()==null || !"1".equals(getApplication().getAttribute("AI_V2_switch"))){
            return ApiResponse.status(MyHttpStatus.UNAUTHORIZED).message("没有AI出题的权限").build();
        }

        String cid = (String) params.get("cid");
        String cname = (String) params.get("cname");
        if(QuestionGenerateThreadPool.getInstance().isTaskRunning(cid)){
            return ApiResponse.status(MyHttpStatus.FAIL).message("该课程已有一个AI任务运行中").build();
        }

        List<Map<String,Object>> qtInfoList = (List<Map<String,Object>>) params.get("qtInfoList");
        if(qtInfoList==null || qtInfoList.isEmpty()){
            return ApiResponse.status(MyHttpStatus.FAIL).message("后台未正确接收题目信息").build();
        }
        List<Theme> themeTree = courseService.getThemeTree(cid, -1L);
        List<Map<String, String>> leafThemes = ThemeUtils.flattenLeafToMaps(themeTree);

        List<QuestionGeneratedParam> questionGeneratedParamList = new ArrayList<>();
        for(int i=0; i<qtInfoList.size();i++){
            int leafSize = leafThemes.size();
            if(leafSize==0){
                break;
            }
            Collections.shuffle(leafThemes);
            Map<String,Object> qtInfo = qtInfoList.get(i);
            Integer qtCount = Utils.changeObjToInt(qtInfo.get("qtCount"));
            String qtid = String.valueOf(qtInfo.get("qtid"));
            Integer atid = Utils.changeObjToInt(qtInfo.get("atid"));
            Integer iscon = Utils.changeObjToInt(qtInfo.get("iscon"));
            String qtname = String.valueOf(qtInfo.get("qtName"));
            int idx = 0; // 当前走到第几个叶子
            while (qtCount > 0) {
                Map<String, String> leaf = leafThemes.get(idx % leafSize); // 循环取

                String theme1Id   = leaf.get("theme1Id");
                String theme2Id   = leaf.get("theme2Id");
                String theme3Id   = leaf.get("theme3Id");
                String theme1Name = leaf.get("theme1Name");
                String theme2Name = leaf.get("theme2Name");
                String theme3Name = leaf.get("theme3Name");

                String themePath = Stream.of(theme1Name, theme2Name, theme3Name)
                        .filter(s -> StringUtils.isNotBlank(s))
                        .collect(Collectors.joining("/"));

                QuestionGeneratedParam questionGeneratedParam = new QuestionGeneratedParam(
                        user.getId(), user.getRealname(),
                        theme1Id, theme2Id, theme3Id, qtid, cname, themePath, atid, iscon, qtname);
                questionGeneratedParamList.add(questionGeneratedParam);

                qtCount--;
                idx++;// 下一个主题
            }
        }
        if(!questionGeneratedParamList.isEmpty()){
            try {
                boolean submitSuccess = QuestionGenerateThreadPool.getInstance().submitTask(
                        cid, new GenerateAsyncTask(cid,questionGeneratedParamList,intelliQuestionService)
                );
                if(submitSuccess){
                    return ApiResponse.status(MyHttpStatus.SUCCESS).message("AI出题任务执行成功").build();
                }else{
                    return ApiResponse.status(MyHttpStatus.FAIL).message("AI出题线程队列已满，请排队").build();
                }
            } catch (RejectedExecutionException e) {
                return ApiResponse.status(MyHttpStatus.FAIL).message("AI出题线程队列已满，请排队").build();
            }
        }
        return ApiResponse.status(MyHttpStatus.PARTIAL_SUCCESS).message("未查询到需要生成的题目").build();
    }

    @RequestMapping("/importWordQuestionByAI")
    public @ResponseBody ApiResponse<?> importWordQuestionByAI(@RequestParam(value="uploadFiles") MultipartFile[] mFiles,
                                                               @RequestParam String cid) {
        int fileLength = mFiles.length;
        if (fileLength == 0 || fileLength>10) {
            return ApiResponse.status(MyHttpStatus.FAIL).message("文件上传数量限制为1到10").build();
        }
        if(getUserInfo()==null || !"1".equals(getApplication().getAttribute("AI_V2_switch"))){
            return ApiResponse.status(MyHttpStatus.UNAUTHORIZED).message("没有AI导入word的权限").build();
        }

        if(QuestionGenerateThreadPool.getInstance().isTaskRunning(cid)){
            return ApiResponse.status(MyHttpStatus.FAIL).message("该课程已有一个AI任务运行中").build();
        }

        String[] wordContents = new String[mFiles.length];
        for(int i=0;i<fileLength;i++){
            wordContents[i] = intelliQuestionService.getImportWordStringWithFormula(mFiles[i] ,cid);
            if(StringUtils.isBlank(wordContents[i])){
                return ApiResponse.status(MyHttpStatus.FAIL).message("未读取到"+mFiles[i].getOriginalFilename()+"的任何内容").build();
            }
            if(wordContents[i].length()>40000){
                return ApiResponse.status(MyHttpStatus.FAIL).message(mFiles[i].getOriginalFilename()+"内容过长，上限为40000字").build();
            }
        }

        Map<String,Object> searchThemeParam = new HashMap<>();
        searchThemeParam.put("cid",cid);
        searchThemeParam.put("level",1);
        searchThemeParam.put("tname","智能word导入");
        Map<String, Object> themeParam =  questionService.getThemeIdByName(searchThemeParam);
        String themeId;
        if(themeParam==null){
            searchThemeParam.put("th_name",searchThemeParam.get("tname"));
            searchThemeParam.put("th_pid","-1");
            searchThemeParam.put("th_level",searchThemeParam.get("level"));
            searchThemeParam.put("th_cid",cid);
            questionService.insertTheme4ImportQuestion(searchThemeParam);
            themeId = (String) searchThemeParam.get("id");
        }else{
            themeId = (String) themeParam.get("ID");
        }

        QuestionGeneratedParam questionGeneratedParam = new QuestionGeneratedParam(getUserID(),
                getUsername(),themeId, "","","","","",0,0,"");
        questionGeneratedParam.setCid(cid);
        try {
            boolean submitSuccess = QuestionGenerateThreadPool.getInstance().submitTask(
                    cid, new ImportQuestionAsyncTask(questionGeneratedParam,wordContents,intelliQuestionService)
            );
            if(submitSuccess){
                return ApiResponse.status(MyHttpStatus.SUCCESS).message("AI导入任务执行成功").build();
            }else{
                return ApiResponse.status(MyHttpStatus.FAIL).message("AI导入线程队列已满，请排队").build();
            }
        } catch (RejectedExecutionException e) {
            return ApiResponse.status(MyHttpStatus.FAIL).message("AI导入线程队列已满，请排队").build();
        }
    }

    @PostMapping("/getAIQuestionUsedStatus")
    public @ResponseBody Map<String, BigDecimal> getAIQuestionUsedStatus(@RequestParam String cid){
        return intelliQuestionService.getAIQuestionUsedStatus(cid);
    }

    @RequestMapping("/editByAI")
    public String editByAI(){
        String cid = getPara("cid");
        String qid = getPara("qid");
        String mqid = getPara("mqid");
        if(!getSubject().hasRole("administrator")){
            Map param = new HashMap();
            param.put("uid", getUserID());
            param.put("cid", cid);
            param.put("permission", "question:view");
            if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0) {
                return null;
            }
        }
        Integer isMain = Utils.changeObjToInt(getPara("isMain"));
        Integer iscon = Utils.changeObjToInt(getPara("iscon"));

        getRequest().setAttribute("iscon", iscon);
        getRequest().setAttribute("isMain", isMain);
        getRequest().setAttribute("mqid", mqid);
        getRequest().setAttribute("cid", cid);

        Map m = new HashMap();
        m.put("c_id", cid);

        if(iscon == 0){
            m.put("id", qid);
            Map<String, Object> mainQuestion=questionService.getQuestion_AnswerByQID(m);
            getRequest().setAttribute("mainQuestion", mainQuestion);
        }else if(iscon == 1 && isMain == 1){//串题+主题干
            m.put("id", qid);
            Map<String, Object> mainQuestion = questionService.getQuestionPrevew(m);
            getRequest().setAttribute("mqid", qid);
            getRequest().setAttribute("mainQuestion", mainQuestion);

            int atid = Integer.parseInt((String)mainQuestion.get("atid"));
            getRequest().setAttribute("questionList",  questionService.getBranchQuestion_AnswerByQID(qid,atid));
        }else if(iscon == 1 && isMain == 0){//串题+非主题干
            m.put("id", mqid);
            getRequest().setAttribute("mqid", mqid);

            Map<String, Object> mainQuestion = questionService.getQuestionPrevew(m);
            getRequest().setAttribute("mainQuestion", mainQuestion);

            int atid = Integer.parseInt(String.valueOf(mainQuestion.get("atid")));
            getRequest().setAttribute("questionList",  questionService.getBranchQuestion_AnswerByQID(mqid,atid));
        }
        Map mm = new HashMap();
        mm.put("c_id", cid);
        mm.put("id", qid);
        mm.put("isView", 0);
        Map<String,Object> lastAndNextQuestion = questionService.getPrevAndNextQuestion(mm);
        getRequest().setAttribute("lastQuestion", lastAndNextQuestion.get("lastQuestion"));
        getRequest().setAttribute("nextQuestion", lastAndNextQuestion.get("nextQuestion"));
        return "jsp/question/previewQuestion4Translate";
    }

    @PostMapping("/editQuestionByAI")
    public @ResponseBody String editQuestionByAI(){
        String cid = getPara("cid");
        String qid = getPara("qid");
        String mqid = getPara("mqid");
        if(!getSubject().hasRole("administrator")){
            Map param = new HashMap();
            param.put("uid", getUserID());
            param.put("cid", cid);
            param.put("permission", "question:add");
            if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0) {
                return "noRoot";
            }
        }
        String requestActionStr = getPara("requestAction");
        String cacheKey = StringUtils.isBlank(mqid)?
                "cid_"+cid+"_qid_"+qid+"_action_"+requestActionStr:
                "cid_"+cid+"_qid_"+mqid+"_action_"+requestActionStr;
        QuestionIntelliEditAction requestAction = QuestionIntelliEditAction.valueOf(requestActionStr);
        LocalCache cache = LocalCache.getInstance();
        QuestionEditInfo questionEditInfo = cache.get("AIQuestionEditMission", cacheKey);
        if(questionEditInfo !=null &&
                requestAction.equals(questionEditInfo.getAction()) &&
                QuestionEditStatus.RUNNING.equals(questionEditInfo.getStatus())){
            return "busy";
        }
        cache.evict("AIQuestionEditMission", cacheKey);
        Integer isMain = Utils.changeObjToInt(getPara("isMain"));
        Integer iscon = Utils.changeObjToInt(getPara("iscon"));
        Map<String, Object> m = new HashMap<>();
        m.put("c_id", cid);
        QuestionEditInfo newInfo = new QuestionEditInfo();
        newInfo.setStatus(QuestionEditStatus.RUNNING);
        newInfo.setAction(requestAction);
        if(iscon == 0){
            m.put("id", qid);
            new Thread(() -> {
                try {
                    cache.set("AIQuestionEditMission", cacheKey,newInfo);
                    Map<String, Object> mainQuestion=questionService.getQuestion_AnswerByQID(m);
                    GeneratedQuestion question = (GeneratedQuestion) QuestionOperatorCharger.handleQuestion(
                                    QuestionClassUtils.toGeneratedQuestion(mainQuestion),
                                    requestAction, 1);
                    newInfo.setGeneratedQuestion(question);
                    newInfo.setStatus(QuestionEditStatus.FINISH);
                    cache.set("AIQuestionEditMission", cacheKey,newInfo);
                } catch (Exception e) {
                    logger.info("editQuestionByAIError",e);
                    cache.evict("AIQuestionEditMission", cacheKey);
                }
            }).start();
        }else if(iscon == 1 && isMain == 1){//串题+主题干
            m.put("id", qid);
            new Thread(() -> {
                try {
                    cache.set("AIQuestionEditMission", cacheKey,newInfo);
                    Map<String, Object> mainQuestion = questionService.getQuestionPrevew(m);
                    int atid = Integer.parseInt((String)mainQuestion.get("atid"));
                    List<Map<String, Object>> questionList = questionService.getBranchQuestion_AnswerByQID(qid,atid);
                    MainGeneratedQuestion question = (MainGeneratedQuestion) QuestionOperatorCharger.handleQuestion(
                            QuestionClassUtils.toMainGeneratedQuestion(mainQuestion,questionList),
                            requestAction, 1);
                    newInfo.setMainGeneratedQuestion(question);
                    newInfo.setStatus(QuestionEditStatus.FINISH);
                    cache.set("AIQuestionEditMission", cacheKey,newInfo);
                } catch (Exception e) {
                    logger.info("editQuestionByAIError",e);
                    cache.evict("AIQuestionEditMission", cacheKey);
                }
            }).start();
        }else if(iscon == 1 && isMain == 0){//串题+非主题干
            m.put("id", mqid);
            try {
                cache.set("AIQuestionEditMission", cacheKey,newInfo);
                Map<String, Object> mainQuestion = questionService.getQuestionPrevew(m);
                int atid = Integer.parseInt(String.valueOf(mainQuestion.get("atid")));
                List<Map<String, Object>> questionList = questionService.getBranchQuestion_AnswerByQID(mqid,atid);
                MainGeneratedQuestion question = (MainGeneratedQuestion) QuestionOperatorCharger.handleQuestion(
                        QuestionClassUtils.toMainGeneratedQuestion(mainQuestion,questionList),
                        requestAction, 1);
                newInfo.setMainGeneratedQuestion(question);
                newInfo.setStatus(QuestionEditStatus.FINISH);
                cache.set("AIQuestionEditMission", cacheKey,newInfo);
            } catch (Exception e) {
                logger.info("editQuestionByAIError",e);
                cache.evict("AIQuestionEditMission",cacheKey);
            }
        }
        return "success";
    }

    @PostMapping("/getInfoFromEditByAI")
    public @ResponseBody QuestionEditInfo getInfoFromEditByAI(){
        String cid = getPara("cid");
        String qid = getPara("qid");
        String mqid = getPara("mqid");
        if(!getSubject().hasRole("administrator")){
            Map param = new HashMap();
            param.put("uid", getUserID());
            param.put("cid", cid);
            param.put("permission", "question:add");
            if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0) {
                return null;
            }
        }
        String requestActionStr = getPara("requestAction");
        String cacheKey = StringUtils.isBlank(mqid)?
                "cid_"+cid+"_qid_"+qid+"_action_"+requestActionStr:
                "cid_"+cid+"_qid_"+mqid+"_action_"+requestActionStr;
        LocalCache cache = LocalCache.getInstance();
        QuestionEditInfo questionEditInfo = cache.get("AIQuestionEditMission", cacheKey
        );
        return questionEditInfo;
    }

    @PostMapping("/acceptQuestionEditFromAI")
    public @ResponseBody String acceptQuestionEditFromAI() {
        String cid = getPara("cid");
        String qid = getPara("qid");
        String mqid = getPara("mqid");
        if (!getSubject().hasRole("administrator")) {
            Map<String, Object> permissionParam = new HashMap<String, Object>();
            permissionParam.put("uid", getUserID());
            permissionParam.put("cid", cid);
            permissionParam.put("permission", "question:add");
            if (questionService.checkQuestionPermission(permissionParam, getUserID() + "_" + cid) == 0) {
                return "fail";
            }
        }

        String requestActionStr = getPara("requestAction");
        String cacheKey = StringUtils.isBlank(mqid)
                ? "cid_" + cid + "_qid_" + qid + "_action_" + requestActionStr
                : "cid_" + cid + "_qid_" + mqid + "_action_" + requestActionStr;

        LocalCache cache = LocalCache.getInstance();
        QuestionEditInfo questionEditInfo = cache.get("AIQuestionEditMission", cacheKey);
        if (questionEditInfo == null
                || (questionEditInfo.getGeneratedQuestion() == null && questionEditInfo.getMainGeneratedQuestion() == null)) {
            return "fail";
        }

        Integer isMain = Utils.changeObjToInt(getPara("isMain"));
        Integer iscon = Utils.changeObjToInt(getPara("iscon"));
        Map<String, Object> mainParam = new HashMap<String, Object>();

        if (iscon == 0 && questionEditInfo.getGeneratedQuestion() != null) {
            mainParam.put("id", qid);
            Map<String, Object> question = questionService.getQuestionInfo(mainParam);

            GeneratedQuestion generatedQuestion = questionEditInfo.getGeneratedQuestion();
            String id = questionService.getQuestionID();
            int atid = Utils.changeObjToInt(question.get("atid"));
            Map<String, Object> param = buildQuestionParam(
                    cid, id, null, 0, 0, question,
                    generatedQuestion.getContent(),
                    PaperContentUtils.fitForVarchar2_4000Byte(generatedQuestion.getExplain())
            );
            fillAnswerParam(param, atid, generatedQuestion.getAnswer(), generatedQuestion.getAnswerList());
            questionService.insertQuestion(param);
        } else if (iscon == 1
                && questionEditInfo.getMainGeneratedQuestion() != null
                && questionEditInfo.getMainGeneratedQuestion().getQuestionList() != null
                && !questionEditInfo.getMainGeneratedQuestion().getQuestionList().isEmpty()) {

            if (isMain == 0) {
                mainParam.put("id", mqid);
            } else {
                mainParam.put("id", qid);
            }
            Map<String, Object> question = questionService.getQuestionInfo(mainParam);
            MainGeneratedQuestion mainGeneratedQuestion = questionEditInfo.getMainGeneratedQuestion();
            int atid = Utils.changeObjToInt(question.get("atid"));

            // 插入主题干
            String mainId = questionService.getQuestionID();
            Map<String, Object> mainInsertParam = buildQuestionParam(
                    cid, mainId, null, 1, 1, question,
                    mainGeneratedQuestion.getContent(),
                    ""
            );
            questionService.insertQuestion(mainInsertParam);

            // 插入子题
            List<GeneratedQuestion> branchQuestions = mainGeneratedQuestion.getQuestionList();
            for (GeneratedQuestion branch : branchQuestions) {
                String branchId = questionService.getQuestionID();

                Map<String, Object> branchParam = buildQuestionParam(
                        cid, branchId, mainId, 0, 1, question,
                        branch.getContent(),
                        branch.getExplain()
                );
                fillAnswerParam(branchParam, atid, branch.getAnswer(), branch.getAnswerList());
                questionService.insertQuestion(branchParam);
            }
        }

        cache.evict("AIQuestionEditMission", cacheKey);
        return "success";
    }

    private Map<String, Object> buildQuestionParam(String cid,
                                                   String id,
                                                   String mqid,
                                                   int isMain,
                                                   int iscon,
                                                   Map<String, Object> question,
                                                   String content,
                                                   String answerExplain) {
        Map<String, Object> param = new HashMap<>();
        param.put("cid", cid);
        param.put("isMain", isMain);
        param.put("iscon", iscon);
        if (StringUtils.isNotBlank(mqid)) {
            param.put("mqid", mqid);
        }

        param.put("id", id);
        param.put("qtid", question.get("qtid"));
        param.put("atid", question.get("atid"));
        param.put("aid", question.get("aid"));
        param.put("sourceid", question.get("soid"));
        param.put("cognitionid", question.get("coid"));
        param.put("difficultyid", question.get("did"));
        param.put("knowledgeid", question.get("kid"));
        param.put("answertime", question.get("answertime"));
        param.put("answertime_b", question.get("answertime_b"));
        param.put("theme1id", question.get("t1id"));
        param.put("theme2id", question.get("t2id"));
        param.put("theme3id", question.get("t3id"));
        param.put("addtime", new Date());
        param.put("answertype", question.get("atid"));
        param.put("creatorid", getUserID());
        param.put("creator", getUserInfo().getRealname());
        param.put("content", content);
        param.put("answerexplain", answerExplain);

        return param;
    }

    private void fillAnswerParam(Map<String, Object> param,
                                 int atid,
                                 String correctAnswer,
                                 List<Map<String, String>> answerList) {
        if (atid < 4 || atid == 8 || atid == 9) {
            StringBuilder answerIdBuilder = new StringBuilder();
            List<Map<String, Object>> answers = new ArrayList<>();

            if (answerList != null) {
                for (Map<String, String> answerMap : answerList) {
                    String aid = questionService.getAnswerID();
                    Map<String, Object> answerItem = new HashMap<>();

                    for (Map.Entry<String, String> entry : answerMap.entrySet()) {
                        String key = entry.getKey();
                        String value = entry.getValue();

                        answerItem.put("aid", aid);
                        answerItem.put("answer_content", value);
                        answerItem.put("answer_content_6", "");

                        if (correctAnswer != null && correctAnswer.contains(key)) {
                            if (answerIdBuilder.length() > 0) {
                                answerIdBuilder.append(",");
                            }
                            answerIdBuilder.append(aid);
                        }
                    }

                    answers.add(answerItem);
                }
            }

            param.put("answer", answers);
            param.put("answerid", answerIdBuilder.toString());

        } else if (atid == 4) {
            List<Map<String, Object>> answers = new ArrayList<>();
            Map<String, Object> answerItem = new HashMap<>();
            String aid = questionService.getAnswerID();

            answerItem.put("aid", aid);
            answerItem.put("answer_content",
                    answerList != null && !answerList.isEmpty() ? answerList.get(0).get("A") : "");
            answerItem.put("answer_content_6", "");
            answers.add(answerItem);

            param.put("answer", answers);
            param.put("answerid", aid);

        } else {
            List<Map<String, Object>> answers = new ArrayList<>();
            Map<String, Object> answerItem = new HashMap<>();
            String aid = questionService.getAnswerID();

            answerItem.put("aid", aid);
            answerItem.put("answer_content", "");

            String answerCon = correctAnswer;
            if (StringUtils.isBlank(answerCon)) {
                answerCon = "无标准答案";
            }
            answerItem.put("answer_content_6", answerCon);

            answers.add(answerItem);

            param.put("answer", answers);
            param.put("answerid", aid);
        }
    }
}