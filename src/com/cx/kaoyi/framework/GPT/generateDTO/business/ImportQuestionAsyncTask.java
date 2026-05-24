package com.cx.kaoyi.framework.GPT.generateDTO.business;

import com.cx.kaoyi.business.service.serviceImpl.IntelliQuestionService;
import com.cx.kaoyi.framework.GPT.generateDTO.GeneratedQuestion;
import com.cx.kaoyi.framework.GPT.generateDTO.QuestionGeneratedParam;
import com.cx.kaoyi.framework.GPT.utils.quesitonGenerate.QuestionImportorCharger;
import org.apache.commons.lang3.StringUtils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class ImportQuestionAsyncTask implements Runnable {

    private QuestionGeneratedParam questionGeneratedParam;
    private String[] wordContents;
    private IntelliQuestionService intelliQuestionService;
    private GeneratedQuestion importedQuestion = new GeneratedQuestion();
    private Integer importedQuestionNum = 0;
    private List<GeneratedQuestion> recQuestions = new ArrayList<>();

    public ImportQuestionAsyncTask(QuestionGeneratedParam questionGeneratedParam, String[] wordContents, IntelliQuestionService intelliQuestionService){
        this.questionGeneratedParam = questionGeneratedParam;
        this.wordContents = wordContents;
        this.intelliQuestionService = intelliQuestionService;
    }

    @Override
    public void run() {
            for (int a = 0; a < wordContents.length; a++) {
                importedQuestionNum = 0;
                String[] contentsSeparate = wordContents[a].split("####");
                for (String contentStr : contentsSeparate) {
                    if (StringUtils.isNotBlank(contentStr)) {
                        importedQuestionNum = 0;
                        recProcess:
                        while(importedQuestionNum<200){
                            GeneratedQuestion ans = QuestionImportorCharger.sendMessage(contentStr, importedQuestion, 1);
                            if (ans == null) {
                                break;
                            }
                            for(GeneratedQuestion recQuestion : recQuestions){
                                if(recQuestion.getContent().equals(ans.getContent())){ //重复识别了
                                    importedQuestion = recQuestions.get(recQuestions.size()-1); //最新识别的应该在最后
                                    continue recProcess;
                                }
                            }

                            importedQuestionNum++;
                            importedQuestion = ans;
                            recQuestions.add(ans);
                            List<Map<String, Object>> answerToSave = new ArrayList<>();
                            Integer atid = 6;
                            String qtid = "165";
                            String qtname = "简答题";
                            if (ans.getQtype().equals("单选题") || ans.getQtype().equals("选择题") || ans.getQtype().equals("单项选择题")
                                    || ans.getQtype().equals("A1型题")) {
                                atid = 0;
                                qtid = "151";
                                qtname = "A1型题";
                            } else if (ans.getQtype().equals("多选题") || ans.getQtype().equals("X型题") || ans.getQtype().equals("多项选择题")) {
                                atid = 1;
                                qtid = "158";
                                qtname = "X型题";;
                            } else if (ans.getQtype().equals("判断题") || ans.getQtype().equals("正误题") || ans.getQtype().equals("对错题")) {
                                atid = 4;
                                qtid = "160";
                                qtname = "判断题";
                            } else if (ans.getQtype().equals("填空题")) {
                                atid = 5;
                                qtid = "161";
                                qtname = "填空题";
                            }
                            questionGeneratedParam.setAtid(atid);
                            questionGeneratedParam.setId(intelliQuestionService.getQuestionAIID());
                            questionGeneratedParam.setSource(1);
                            questionGeneratedParam.setContent(ans.getContent());
                            questionGeneratedParam.setAnswerExplain(ans.getExplain());
                            questionGeneratedParam.setQtid(qtid);
                            questionGeneratedParam.setQtname(qtname);
                            String answerid = "";
                            if (atid < 4 || atid == 8 || atid == 9) {
                                char[] correctArray = ans.getAnswer().toCharArray();
                                for (int i = 0; i < ans.getAnswerList().size(); i++) {
                                    String aid = intelliQuestionService.getAnswerAIID();
                                    String answerContent = ans.getAnswerList().get(i).get(String.valueOf((char) ('A' + i))); // 'A' + i 动态计算字母
                                    Map m = new HashMap();
                                    for (int j = 0; j < correctArray.length; j++) {
                                        if (i == correctArray[j] - 'A') {
                                            answerid += aid + ",";
                                        }
                                    }
                                    m.put("index", i);
                                    m.put("qid", questionGeneratedParam.getId());
                                    m.put("aid", aid);
                                    m.put("answer_content", answerContent);
                                    m.put("answer_content_6", "");
                                    m.put("atid", questionGeneratedParam.getAtid());
                                    answerToSave.add(m);
                                }
                                if (answerid != null && !"".equals(answerid)) {
                                    answerid = answerid.substring(0, answerid.length() - 1);
                                } else {
                                    answerid = (String) answerToSave.get(answerToSave.size() - 1).get("aid");
                                }
                            } else if (atid == 4) {
                                answerid = intelliQuestionService.getAnswerAIID();
                                Map<String, Object> m = new HashMap<>();
                                String answerContent = "";
                                char[] correctArray = ans.getAnswer().toCharArray();
                                for (int i = 0; i < ans.getAnswerList().size(); i++) {
                                    if (i == correctArray[0] - 'A') {
                                        answerContent = ans.getAnswerList().get(i).get(String.valueOf((char) ('A' + i))); // 'A' + i 动态计算字母
                                    }
                                }
                                m.put("index", 0);
                                m.put("qid", questionGeneratedParam.getId());
                                m.put("aid", answerid);
                                if ("对".equals(answerContent)) {
                                    answerContent = "true";
                                } else if ("错".equals(answerContent)) {
                                    answerContent = "false";
                                }
                                m.put("answer_content", answerContent);
                                m.put("answer_content_6", "");
                                m.put("atid", questionGeneratedParam.getAtid());
                                answerToSave.add(m);
                            } else {
                                answerid = intelliQuestionService.getAnswerAIID();
                                Map<String, Object> m = new HashMap<>();
                                m.put("qid", questionGeneratedParam.getId());
                                m.put("aid", answerid);
                                m.put("answer_content", "");
                                String answerCon = ans.getAnswer();
                                if (answerCon == null || "".equals(answerCon)) {
                                    answerCon = "无标准答案";
                                }
                                m.put("answer_content_6", answerCon);
                                m.put("index", 0);
                                m.put("atid", questionGeneratedParam.getAtid());
                                answerToSave.add(m);
                            }
                            questionGeneratedParam.setAnswerid(answerid);
                            try {
                                intelliQuestionService.insertQuestionAI(questionGeneratedParam, answerToSave);
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                        recQuestions.clear();
                    }
                }
            }
        QuestionGenerateThreadPool.getInstance().cancelTask(questionGeneratedParam.getCid());
    }
}
