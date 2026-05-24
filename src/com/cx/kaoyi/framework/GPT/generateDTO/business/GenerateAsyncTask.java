package com.cx.kaoyi.framework.GPT.generateDTO.business;

import com.cx.kaoyi.business.service.serviceImpl.IntelliQuestionService;
import com.cx.kaoyi.framework.GPT.generateDTO.GeneratedQuestion;
import com.cx.kaoyi.framework.GPT.generateDTO.MainGeneratedQuestion;
import com.cx.kaoyi.framework.GPT.generateDTO.QuestionGeneratedParam;
import com.cx.kaoyi.framework.GPT.utils.quesitonGenerate.QuestionGeneratorCharger;
import com.cx.kaoyi.framework.GPT.utils.quesitonGenerate.QuestionIsconGeneratorCharger;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GenerateAsyncTask implements Runnable {

    private String cid;
    private List<QuestionGeneratedParam> questionGeneratedParamList;
    private IntelliQuestionService intelliQuestionService;

    public GenerateAsyncTask(String cid, List<QuestionGeneratedParam> questionGeneratedParamList, IntelliQuestionService intelliQuestionService) {
        this.cid = cid;
        this.questionGeneratedParamList = questionGeneratedParamList;
        this.intelliQuestionService = intelliQuestionService;
    }

    @Override
    public void run() {
        String englishRegex = "^[A-Za-z0-9\\p{P} ]+$";// 只允许：英文大小写字母、数字、空格（ASCII 0x20）、以及所有 Unicode 标点（包含中文标点）
        for(QuestionGeneratedParam questionGeneratedParam : questionGeneratedParamList){
            String myPrompt = "该题目生成试卷大类为："+questionGeneratedParam.getCname()+
                    "；题目所含大纲为："+questionGeneratedParam.getTheme()+
                    "；题型名叫作："+questionGeneratedParam.getQtname()+"且答案类型为："+questionGeneratedParam.getAnsType();
            try{
                if(questionGeneratedParam.getIscon()==1){
                    MainGeneratedQuestion mainGeneratedQuestion = QuestionIsconGeneratorCharger.sendMessage(myPrompt,questionGeneratedParam.getPromptJsonIndex(),
                            1, questionGeneratedParam.getTheme().matches(englishRegex));
                    if(mainGeneratedQuestion==null){
                        continue;
                    }
                    String mqid = intelliQuestionService.getQuestionAIID();
                    questionGeneratedParam.setCid(cid);
                    questionGeneratedParam.setId(mqid);
                    questionGeneratedParam.setSource(0);
                    questionGeneratedParam.setContent(mainGeneratedQuestion.getContent());
                    questionGeneratedParam.setIsmain(1);
                    intelliQuestionService.insertQuestionAI(questionGeneratedParam, new ArrayList<>());
                    questionGeneratedParam.setIsmain(0);
                    questionGeneratedParam.setId("");
                    questionGeneratedParam.setContent("");
                    questionGeneratedParam.setMqid(mqid);
                    for(GeneratedQuestion childQuestion : mainGeneratedQuestion.getQuestionList()){
                        insertNotMainQuestion(childQuestion, questionGeneratedParam);
                    }
                }else{
                    GeneratedQuestion ans = QuestionGeneratorCharger.sendMessage(myPrompt,questionGeneratedParam.getPromptJsonIndex(),
                            1, questionGeneratedParam.getTheme().matches(englishRegex));
                    if(ans==null){
                        continue;
                    }
                    insertNotMainQuestion(ans, questionGeneratedParam);
                }
            }catch (Exception e){
                e.printStackTrace();
            }
        }
        QuestionGenerateThreadPool.getInstance().cancelTask(cid);
    }

    private void insertNotMainQuestion(GeneratedQuestion ans, QuestionGeneratedParam questionGeneratedParam){
        questionGeneratedParam.setCid(cid);
        questionGeneratedParam.setId(intelliQuestionService.getQuestionAIID());
        questionGeneratedParam.setSource(0);
        questionGeneratedParam.setContent(ans.getContent());
        questionGeneratedParam.setAnswerExplain(ans.getExplain());
        Integer atid = questionGeneratedParam.getAtid();
        String answerid = "";
        List<Map<String,Object>> answerToSave = new ArrayList<>();
        if(atid<4 || atid==8 || atid==9){
            char[] correctArray = ans.getAnswer().toCharArray();
            for(int i=0;i<ans.getAnswerList().size();i++){
                String aid = intelliQuestionService.getAnswerAIID();
                String answerContent = ans.getAnswerList().get(i).get(String.valueOf((char) ('A' + i))); // 'A' + i 动态计算字母
                Map m = new HashMap();
                for(int j=0;j<correctArray.length;j++){
                    if(i == correctArray[j] - 'A'){
                        answerid += aid+",";
                    }
                }
                m.put("index", i);
                m.put("qid",questionGeneratedParam.getId());
                m.put("aid", aid);
                m.put("answer_content", answerContent);
                m.put("answer_content_6", "");
                m.put("atid", questionGeneratedParam.getAtid());
                answerToSave.add(m);
            }
            if(answerid!=null && !"".equals(answerid)){
                answerid = answerid.substring(0,answerid.length()-1);
            }else{
                answerid = (String)answerToSave.get(answerToSave.size()-1).get("aid");
            }
        }else if(atid==4){
            answerid = intelliQuestionService.getAnswerAIID();
            Map<String,Object> m = new HashMap<>();
            String answerContent = "";
            char[] correctArray = ans.getAnswer().toCharArray();
            for(int i=0;i<ans.getAnswerList().size();i++){
                if(i == correctArray[0] - 'A'){
                    answerContent = ans.getAnswerList().get(i).get(String.valueOf((char) ('A' + i))); // 'A' + i 动态计算字母
                }
            }
            m.put("index", 0);
            m.put("qid",questionGeneratedParam.getId());
            m.put("aid", answerid);
            if("对".equals(answerContent)){
                answerContent = "true";
            }else if("错".equals(answerContent)){
                answerContent = "false";
            }
            m.put("answer_content",answerContent);
            m.put("answer_content_6", "");
            m.put("atid", questionGeneratedParam.getAtid());
            answerToSave.add(m);
        }else{
            answerid = intelliQuestionService.getAnswerAIID();
            Map<String,Object> m = new HashMap<>();
            m.put("qid",questionGeneratedParam.getId());
            m.put("aid", answerid);
            m.put("answer_content", "");
            String answerCon = ans.getAnswer();
            if(answerCon==null||"".equals(answerCon)){
                answerCon="无标准答案";
            }
            m.put("answer_content_6", answerCon);
            m.put("index", 0);
            m.put("atid", questionGeneratedParam.getAtid());
            answerToSave.add(m);
        }
        questionGeneratedParam.setAnswerid(answerid);
        try{
            intelliQuestionService.insertQuestionAI(questionGeneratedParam, answerToSave);
        }catch (Exception e){
            e.printStackTrace();
        }
    }
}
