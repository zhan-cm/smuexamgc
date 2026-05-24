package com.cx.kaoyi.framework.handler;

import com.cx.kaoyi.business.domain.exampaper.ExampaperAnswer;
import com.cx.kaoyi.business.domain.exampaper.ExampaperQuestion;
import com.cx.kaoyi.business.domain.exampaper.ExampaperQuestionType;
import com.cx.kaoyi.business.domain.exampaper.db.ExampaperAnswerDb;
import com.cx.kaoyi.business.domain.exampaper.db.ExampaperQuestionDb;
import com.cx.kaoyi.business.domain.exampaper.db.ExampaperQuestionTypeDb;
import com.cx.kaoyi.framework.utils.Utils;
import org.apache.commons.lang3.StringUtils;

import java.util.*;

public class PaperObjBuilder {

    public static String buildAllExampaperString(List<ExampaperQuestionType> questionTypesWithQuestionList){
        StringBuilder sb = new StringBuilder();
        for(ExampaperQuestionType questionType:questionTypesWithQuestionList){
            sb.append(Utils.int2chineseNum(questionType.getQtOrder()+1)).append("、").append(questionType.getQtname()).append("\n");

            for(ExampaperQuestion question:questionType.getQuestionList()){
                if(question.getIsmain()==1){
                    sb.append("串题题干：[").append(Utils.stripHtmlExcept4Img(question.getContent())).append("]").append("\n");
                    sb.append("以下串题子题共用上述题干：【");
                    List<ExampaperQuestion> branchQuestionList = question.getBranchQuestion();
                    for(ExampaperQuestion branchQuestion : branchQuestionList){
                        sb.append(branchQuestion.getTh()).append(".").append(Utils.stripHtmlExcept4Img(branchQuestion.getContent())).append("\n");
                        sb.append(buildExampaperAnswerString(branchQuestion.getAnswerList(), branchQuestion.getAtid(), branchQuestion.getAnswerid()));
                    }
                    sb.append("】");
                    sb.append("\n");
                }else{
                    sb.append(question.getTh()).append(".").append(Utils.stripHtmlExcept4Img(question.getContent())).append("\n");
                    sb.append(buildExampaperAnswerString(question.getAnswerList(), question.getAtid(), question.getAnswerid()));
                }
                sb.append("\n");
            }
        }
        return sb.toString();
    }

    private static String buildExampaperAnswerString(List<ExampaperAnswer> answerList, int ansType, String answerid){
        StringBuilder sb = new StringBuilder();
        String correctAnswer = "";
        String[] multipleLetter = answerid.split(",");
        for(int i=0;i<answerList.size();i++){
            ExampaperAnswer answer = answerList.get(i);
            String contentStr = Utils.stripHtmlExcept4Img(answer.getContent());
            if(ansType == 0 || ansType == 2 || ansType == 4 || ansType == 8){//单选题、判断题
                sb.append((char) (i + 65)).append(".").append(contentStr).append("\n");
                if(answerid.equals(answer.getAid())){
                    correctAnswer = String.valueOf((char) (i + 65));
                }
            } else if (ansType == 1 || ansType == 3 || ansType == 9) {//多选题
                sb.append((char) (i + 65)).append(".").append(contentStr).append("\n");
                for(String s : multipleLetter){
                    if(s.equals(answer.getAid())){
                        correctAnswer += String.valueOf((char) (i + 65));
                        break;
                    }
                }
            } else if(ansType==5 || ansType==6 || ansType==7 || ansType==12){//主观题，口语题
                sb.append("\n");
                correctAnswer = contentStr;
            } else if (ansType==13) {//在线编程题，先不处理
                sb.append("\n");
                correctAnswer = contentStr;
            }
        }
        //最后补上答案信息
        sb.append("正确答案："+correctAnswer);
        sb.append("\n");
        return sb.toString();
    }

    public static List<Map<String,Object>> buildExamQtypeQuestionOrder(List<ExampaperQuestionType> existQt){
        List<Map<String,Object>> rtn = new ArrayList<>();
        for(ExampaperQuestionType eqt : existQt){
            Map<String,Object> param = new HashMap<>();
            param.put("qtname", eqt.getQtname());
            param.put("qtid", eqt.getQtid());
            List<Map<String, String>> qqList = new ArrayList<>();
            param.put("qqList", qqList);
            rtn.add(param);
            for(ExampaperQuestion eq : eqt.getQuestionList()){
                Map<String, String> eqParam = new HashMap<>();
                eqParam.put("isAnswer", "Y");
                eqParam.put("qid", eq.getQid());
                qqList.add(eqParam);
            }
        }
        return rtn;
    }

    public static List<ExampaperQuestionType> buildExampaperQuestionTypesWithQuestionList (
                                                    List<ExampaperQuestionTypeDb> questionType,
                                                    List<ExampaperQuestionDb> question,
                                                    List<ExampaperAnswerDb> answer){

        List<ExampaperQuestionType> exampaperQuestionTypes = new ArrayList<>();
        if(questionType==null || question==null){
            return exampaperQuestionTypes;
        }

        Map<String, List<ExampaperAnswer>> answerQidMap = new HashMap<>();
        for(ExampaperAnswerDb exampaperAnswerDb:answer){
            List<ExampaperAnswer> answerList = answerQidMap.getOrDefault(exampaperAnswerDb.getQid(), new ArrayList<>());
            answerList.addAll(buildExampaperAnswer(exampaperAnswerDb));
            answerQidMap.put(exampaperAnswerDb.getQid(), answerList);
        }

        Map<String, List<ExampaperQuestion>> questionQtidMap = new HashMap<>();
        for (ExampaperQuestionDb exampaperQuestionDb : question) {
            if(exampaperQuestionDb.getIscon()==0){
                ExampaperQuestion exampaperQuestion = buildExampaperQuestion(exampaperQuestionDb);
                exampaperQuestion.setAnswerList(answerQidMap.get(exampaperQuestion.getQid()));
                List<ExampaperQuestion> exampaperQuestions = questionQtidMap.getOrDefault(exampaperQuestion.getQtid(), new ArrayList<>());
                exampaperQuestions.add(exampaperQuestion);
                questionQtidMap.put(exampaperQuestion.getQtid(), exampaperQuestions);
                continue;
            }
            if(exampaperQuestionDb.getIsmain()==1){
                ExampaperQuestion exampaperQuestion = buildExampaperQuestion(exampaperQuestionDb);
                List<ExampaperQuestion> branchQuestions = new ArrayList<>();
                for(ExampaperQuestionDb exampaperQuestionDb2 : question){
                    if(exampaperQuestionDb2.getIscon()==0 || exampaperQuestionDb2.getIsmain()==1){
                        continue;
                    }
                    if(exampaperQuestionDb.getQid().equals(exampaperQuestionDb2.getMqid())){
                        ExampaperQuestion branchQuestion = buildExampaperQuestion(exampaperQuestionDb2);
                        branchQuestion.setAnswerList(answerQidMap.get(branchQuestion.getQid()));
                        branchQuestions.add(branchQuestion);
                    }
                }
                exampaperQuestion.setBranchQuestion(branchQuestions);
                List<ExampaperQuestion> exampaperQuestions = questionQtidMap.getOrDefault(exampaperQuestion.getQtid(), new ArrayList<>());
                exampaperQuestions.add(exampaperQuestion);
                questionQtidMap.put(exampaperQuestion.getQtid(), exampaperQuestions);
            }
        }

        for (ExampaperQuestionTypeDb exampaperQuestionTypeDb : questionType) {
            ExampaperQuestionType exampaperQuestionType = buildExampaperQuestionType(exampaperQuestionTypeDb);
            List<ExampaperQuestion> questions = questionQtidMap.getOrDefault(exampaperQuestionType.getQtid(), new ArrayList<>());
            for(ExampaperQuestion ques : questions){
                ques.setQtname(exampaperQuestionType.getQtname());
                ques.setXxdf(exampaperQuestionType.getXxdf());
                ques.setMediaSet(exampaperQuestionType.getMediaSet());
                if(ques.getBranchQuestion()!=null && ques.getBranchQuestion().size()>0){
                    for(ExampaperQuestion branchQues : ques.getBranchQuestion()){
                        branchQues.setQtname(exampaperQuestionType.getQtname());
                        branchQues.setXxdf(exampaperQuestionType.getXxdf());
                        branchQues.setMediaSet(exampaperQuestionType.getMediaSet());
                        branchQues.setStuLastAns(new String[1]);
                    }
                    ques.setStuLastAns(new String[ques.getBranchQuestion().size()]);
                }else{
                    ques.setStuLastAns(new String[1]);
                }
            }
            exampaperQuestionType.setQuestionList(questions);
            exampaperQuestionTypes.add(exampaperQuestionType);
        }
        return exampaperQuestionTypes;
    }

    public static List<ExampaperQuestion> buildChildQuestionWithMain (
            List<ExampaperQuestionDb> question,
            List<ExampaperAnswerDb> answer){

        List<ExampaperQuestion> rtnChildQuestionWithMain = new ArrayList<>();
        if(question==null || answer==null){
            return rtnChildQuestionWithMain;
        }

        Map<String, List<ExampaperAnswer>> answerQidMap = new HashMap<>();
        for(ExampaperAnswerDb exampaperAnswerDb:answer){
            List<ExampaperAnswer> answerList = answerQidMap.getOrDefault(exampaperAnswerDb.getQid(), new ArrayList<>());
            answerList.addAll(buildExampaperAnswer(exampaperAnswerDb));
            answerQidMap.put(exampaperAnswerDb.getQid(), answerList);
        }

        for (ExampaperQuestionDb exampaperQuestionDb : question) {
            if(exampaperQuestionDb.getIscon()==0){
                ExampaperQuestion exampaperQuestion = buildExampaperQuestion(exampaperQuestionDb);
                exampaperQuestion.setAnswerList(answerQidMap.get(exampaperQuestion.getQid()));
                rtnChildQuestionWithMain.add(exampaperQuestion);
                continue;
            }
            if(exampaperQuestionDb.getIsmain()==0){
                ExampaperQuestion exampaperQuestion = buildExampaperQuestion(exampaperQuestionDb);
                for(ExampaperQuestionDb exampaperQuestionDb2 : question){
                    if(exampaperQuestionDb2.getIscon()==0 || exampaperQuestionDb2.getIsmain()==0){
                        continue;
                    }
                    if(exampaperQuestionDb.getMqid().equals(exampaperQuestionDb2.getQid())){
                        exampaperQuestion.setContent("题干："+exampaperQuestionDb2.getContent() +"子题："+ exampaperQuestion.getContent());
                        exampaperQuestion.setAnswerList(answerQidMap.get(exampaperQuestion.getQid()));
                        rtnChildQuestionWithMain.add(exampaperQuestion);
                        break;
                    }
                }
            }
        }
        return rtnChildQuestionWithMain;
    }

    private static ExampaperQuestionType buildExampaperQuestionType(ExampaperQuestionTypeDb questionTypeDb){
        ExampaperQuestionType questionType = new ExampaperQuestionType();
        questionType.setQtid(questionTypeDb.getQtid());
        questionType.setQtDesc(questionTypeDb.getQtDesc());
        questionType.setQtname(questionTypeDb.getQtname());
        questionType.setQtOrder(questionTypeDb.getQtOrder());
        questionType.setQtTime(questionTypeDb.getQtTime());
        questionType.setXxdf(questionTypeDb.getXxdf());
        questionType.setMediaSet(questionTypeDb.getMediaSet());
        return questionType;
    }

    private static ExampaperQuestion buildExampaperQuestion(ExampaperQuestionDb question){
        ExampaperQuestion exampaperQuestion1 = new ExampaperQuestion();
        exampaperQuestion1.setQtid(question.getQtid());
        exampaperQuestion1.setAtid(question.getAtid());
        exampaperQuestion1.setIscon(question.getIscon());
        exampaperQuestion1.setIsmain(question.getIsmain());
        exampaperQuestion1.setQid(question.getQid());
        exampaperQuestion1.setTh(question.getTh());
        exampaperQuestion1.setMqid(question.getMqid());
        exampaperQuestion1.setContent(question.getContent());
        exampaperQuestion1.setAnswerid(question.getAnswerid());
        exampaperQuestion1.setScore(question.getScore());
        exampaperQuestion1.setFilepath(question.getFilepath());
        return exampaperQuestion1;
    }

    private static List<ExampaperAnswer> buildExampaperAnswer(ExampaperAnswerDb answerDb){
        List<ExampaperAnswer> rtn = new ArrayList<>();
        ExampaperAnswer answer = new ExampaperAnswer();
        answer.setAid(answerDb.getAid());
        answer.setAtid(answerDb.getAtid());
        answer.setAorder(answerDb.getAorder());
        answer.setQid(answerDb.getQid());
        Integer ansType = answerDb.getAtid();
        if(ansType == 0 || ansType == 2 || ansType == 8){//单选题
            if(StringUtils.isBlank(answerDb.getContent())){
                answer.setContent(answerDb.getContent_6());
            }else{
                answer.setContent(answerDb.getContent());
            }
            rtn.add(answer);
        } else if (ansType == 4) {//判断题
            ExampaperAnswer answer2 = new ExampaperAnswer();
            answer2.setAid("0");
            answer2.setAtid(answerDb.getAtid());
            answer2.setQid(answerDb.getQid());
            if("true".equalsIgnoreCase(answerDb.getContent()) || "对".equals(answerDb.getContent())
            || "正确".equals(answerDb.getContent()) || "正".equals(answerDb.getContent())
            || "√".equals(answerDb.getContent())){
                answer.setContent("true");
                answer2.setContent("false");
                answer2.setAorder(answerDb.getAorder()!=null?answerDb.getAorder()+1:null);
                rtn.add(answer);
                rtn.add(answer2);
            }else{
                answer2.setContent("true");
                answer2.setAorder(answerDb.getAorder()!=null?answerDb.getAorder()-1:null);
                answer.setContent("false");
                rtn.add(answer2);
                rtn.add(answer);
            }
        } else if (ansType == 1 || ansType == 3 || ansType == 9) {//多选题
            if(StringUtils.isBlank(answerDb.getContent())){
                answer.setContent(answerDb.getContent_6());
            }else{
                answer.setContent(answerDb.getContent());
            }
            rtn.add(answer);
        } else if(ansType==5 || ansType==6 || ansType==7 || ansType==12){//主观题，口语题
            answer.setContent(answerDb.getContent_6());
            rtn.add(answer);
        } else if (ansType==13) {//在线编程题，先不处理
            answer.setContent(answerDb.getContent_6());//暂时
            rtn.add(answer);
        }

        return rtn;
    }

    public static Set<String> getExampaperQuestionAllQtids(List<ExampaperQuestionDb> questions){
        Set<String> rtn = new HashSet<>();
        if(questions==null || questions.isEmpty()){
            return rtn;
        }
        for(ExampaperQuestionDb eq : questions){
            rtn.add(eq.getQtid());
        }
        return rtn;
    }

    public static Set<String> getExampaperQuestionTypeWithQuestionListQids(List<ExampaperQuestionType> questionTypes){
        Set<String> rtn = new HashSet<>();
        if(questionTypes==null || questionTypes.isEmpty()){
            return rtn;
        }
        for(ExampaperQuestionType qt : questionTypes){
            List<ExampaperQuestion> questions = qt.getQuestionList();
            if(questions==null || questions.isEmpty()){
                continue;
            }
            for(ExampaperQuestion question:questions){
                rtn.add(question.getQid());
                if(question.getIsmain()==1 && question.getBranchQuestion()!=null){
                    for(ExampaperQuestion branch : question.getBranchQuestion()){
                        rtn.add(branch.getQid());
                    }
                }
            }
        }
        return rtn;
    }

    /**
     * 从各题型里删除指定 qid（含子题）。
     * 1. 删掉符合 qids 的题目 / 子题
     * 2. 如果某个串题题干（ismain==1）删完后已无子题，连同题干一起删除
     * 3. 某题型的 questionList 为空时，删除该题型
     */
    public static void deleteExampaperQuestionTypeWithQuestionListQids(List<ExampaperQuestionType> questionTypes, Set<String> qids) {

        if (questionTypes == null || questionTypes.isEmpty()
                || qids == null || qids.isEmpty()) {
            return;
        }

        // ▼ 第一层：遍历题型，用 iterator.remove() 保证安全
        for (Iterator<ExampaperQuestionType> qtIt = questionTypes.iterator(); qtIt.hasNext(); ) {
            ExampaperQuestionType qt = qtIt.next();
            List<ExampaperQuestion> questions = qt.getQuestionList();
            if (questions == null) {
                qtIt.remove();           // 没有题目，直接删掉题型
                continue;
            }

            // ▼ 第二层：遍历题目，同样用 Iterator
            for (Iterator<ExampaperQuestion> qIt = questions.iterator(); qIt.hasNext(); ) {
                ExampaperQuestion q = qIt.next();

                // 2‑1 题目本身在删除集合里 —— 直接删
                if (qids.contains(q.getQid())) {
                    qIt.remove();
                    continue;
                }

                // 2‑2 处理子题（branchQuestion）
                List<ExampaperQuestion> branches = q.getBranchQuestion();
                if (branches != null && !branches.isEmpty()) {
                    branches.removeIf(b -> qids.contains(b.getQid()));  // 安全批量删除
                }

                // 2‑3 如果这是串题题干且子题已被删光 —— 连题干一起删
                if (q.getIsmain() == 1 && (branches == null || branches.isEmpty())) {
                    qIt.remove();
                }
            }

            // ▼ 第三层：如果该题型已空，删除题型
            if (questions.isEmpty()) {
                qtIt.remove();
            }
        }
    }

}