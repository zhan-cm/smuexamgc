package com.cx.kaoyi.business.domain.exampaper;

import com.cx.kaoyi.framework.utils.Utils;
import com.cx.kaoyi.framework.utils.serialize.KryoPoolUtils;

import java.util.*;

public class ExamQuestionToShow {
    private Integer qIndex;
    Map<String, String> qtDescMap = new HashMap<>();
    Map<String, String> eQtDescMap = new HashMap<>();
    private Date thisQuestionBeginDate;
    private List<ExampaperQuestion> allQuestion;
    private ExampaperQuestion nowQuestion;
    private String lan;

    public ExamQuestionToShow(){}//kryo缓存必备

    public void setQuestion(List<ExampaperQuestionType> existQt, String lan){
        if(lan == null || "0".equals(lan) || lan.equalsIgnoreCase("zh_CN")){
            this.lan = "zh_CN";
        }else {
            this.lan = "en_US";
        }
        List<ExampaperQuestion> allQuestion = new ArrayList<>();
        for(ExampaperQuestionType eqt : existQt){
            allQuestion.addAll(eqt.getQuestionList());
            qtDescMap.put(eqt.getQtid(), eqt.getQtDesc());
            eQtDescMap.put(eqt.getQtid(), eqt.getE_qtDesc());
        }
        this.allQuestion = allQuestion;
        this.qIndex = 0;
        this.nowQuestion = allQuestion.get(qIndex);
        this.thisQuestionBeginDate = new Date();
    }

    public void setQuestion(Integer forward){
        if(allQuestion==null || allQuestion.isEmpty()){
            return;
        }
        if(allQuestion.size()<=qIndex){
            qIndex = allQuestion.size()-1;
        }

        if(forward==0){ //向之前的一题
            qIndex--;
            if(qIndex<=0){//如果是第一题
                qIndex = 0;
            }
        }else{ //向之后的一题
            qIndex++;
            if(qIndex>=allQuestion.size()-1){//如果是最后一题
                qIndex = allQuestion.size()-1;
            }
        }
        nowQuestion = allQuestion.get(qIndex);
        this.thisQuestionBeginDate = new Date();
    }

    public void setQuestion(String qid){
        for(int i=0;i<allQuestion.size();i++){
            ExampaperQuestion question = allQuestion.get(i);
            if(qid.equals(question.getQid())){
                this.qIndex = i;
                this.nowQuestion = question;
                this.thisQuestionBeginDate = new Date();
                break;
            }
        }
    }

    private ExampaperQuestion restructureQuestion(ExampaperQuestion question){
        ExampaperQuestion rtn = KryoPoolUtils.deepCopy(question);
        String content = Utils.trimContent(rtn.getContent());
        if(rtn.getMediaSet()==1){
            content = Utils.transformRichTextWithMedia(rtn.getQid(), content);
        }
        rtn.setContent(content);
        if(rtn.getIsmain()==0){
            if(rtn.getAtid()==4){
                List<ExampaperAnswer> eas = rtn.getAnswerList();
                for(ExampaperAnswer ea : eas){
                    if("true".equals(ea.getContent())){
                        ea.setContent("对");
                    }else {
                        ea.setContent("错");
                    }
                }
            }
            rtn.setAnswerid("");
        }else{
            List<ExampaperQuestion> branches = rtn.getBranchQuestion();
            for(ExampaperQuestion branch : branches){
                String branchContent = Utils.trimContent(branch.getContent());
                if(branch.getMediaSet()==1){
                    branchContent = Utils.transformRichTextWithMedia(branch.getQid(), branchContent);
                }
                branch.setContent(branchContent);
                if(rtn.getAtid()==4){
                    List<ExampaperAnswer> eas = branch.getAnswerList();
                    for(ExampaperAnswer ea : eas){
                        if("true".equals(ea.getContent())){
                            ea.setContent("对");
                        }else {
                            ea.setContent("错");
                        }
                    }
                }
                branch.setAnswerid("");
            }
        }
        return rtn;
    }

    public Integer getqIndex() {
        return qIndex;
    }

    public void setqIndex(Integer qIndex) {
        this.qIndex = qIndex;
    }

    public ExampaperQuestion getNowQuestion() {
        return restructureQuestion(nowQuestion);
    }

    public ExampaperQuestion getNowQuestionWithAnswer() {
        return nowQuestion;
    }

    public void setNowQuestion(ExampaperQuestion nowQuestion) {
        this.nowQuestion = nowQuestion;
    }

    public String getQtDesc() {
        if("zh_CN".equals(lan)){
            return qtDescMap.get(nowQuestion.getQtid());
        }else{
            return eQtDescMap.get(nowQuestion.getQtid());
        }
    }

    public Date getThisQuestionBeginDate() {
        return thisQuestionBeginDate;
    }

    public void setThisQuestionBeginDate(Date thisQuestionBeginDate) {
        this.thisQuestionBeginDate = thisQuestionBeginDate;
    }

    public boolean isFirst(){
        return qIndex == 0;
    }

    public boolean isLast(){
        return qIndex == allQuestion.size()-1;
    }

    public void refreshDate(){
        this.thisQuestionBeginDate = new Date();
    }

    public void refreshQuestionWithQids(List<ExampaperQuestionType> existQt, Set<String> qids){
        if (qids == null || qids.isEmpty() || allQuestion == null || allQuestion.isEmpty()
                || existQt == null || existQt.isEmpty()) {
            return;
        }
        Map<String, ExampaperQuestion> needRefreshQuestionMap = new HashMap<>();
        for(ExampaperQuestionType eqt : existQt){
            List<ExampaperQuestion> exampaperQuestions = eqt.getQuestionList();
            for(ExampaperQuestion question : exampaperQuestions){
                if(qids.contains(question.getQid())){
                    needRefreshQuestionMap.put(question.getQid(), question);
                }
                if(question.getBranchQuestion()!=null && question.getBranchQuestion().size()>0){
                    List<ExampaperQuestion> branchQuestions = question.getBranchQuestion();
                    for(ExampaperQuestion branchQuestion : branchQuestions){
                        if(qids.contains(branchQuestion.getQid())){
                            needRefreshQuestionMap.put(branchQuestion.getQid(), branchQuestion);
                        }
                    }
                }
            }
        }
        if(needRefreshQuestionMap.isEmpty()){
            return;
        }
        for(ExampaperQuestion eqNow : allQuestion){
            ExampaperQuestion needRefreshQuestion = needRefreshQuestionMap.get(eqNow.getQid());
            if(needRefreshQuestion!=null){
                eqNow.setContent(needRefreshQuestion.getContent());
                eqNow.setAnswerid(needRefreshQuestion.getAnswerid());
                eqNow.setAnswerList(
                        needRefreshQuestion.getAnswerList() == null ? null : new ArrayList<>(needRefreshQuestion.getAnswerList())
                );
                eqNow.setScore(needRefreshQuestion.getScore());
            }
            if(eqNow.getBranchQuestion()!=null && eqNow.getBranchQuestion().size()>0){
                for(ExampaperQuestion eqNowBranch : eqNow.getBranchQuestion()){
                    ExampaperQuestion needRefreshBranch = needRefreshQuestionMap.get(eqNowBranch.getQid());
                    if(needRefreshBranch!=null){
                        eqNowBranch.setContent(needRefreshBranch.getContent());
                        eqNowBranch.setAnswerid(needRefreshBranch.getAnswerid());
                        eqNowBranch.setAnswerList(
                                needRefreshBranch.getAnswerList() == null ? null : new ArrayList<>(needRefreshBranch.getAnswerList())
                        );
                        eqNowBranch.setScore(needRefreshBranch.getScore());
                    }
                }
            }
        }
        if (qIndex == null || qIndex < 0) qIndex = 0;
        if (qIndex >= allQuestion.size()) qIndex = allQuestion.size() - 1;
        this.nowQuestion = allQuestion.get(qIndex);
    }
}