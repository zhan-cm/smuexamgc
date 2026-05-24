package com.cx.kaoyi.business.domain.exampaper;

import java.math.BigDecimal;
import java.util.List;

public class ExampaperQuestion {
    private String qid;
    private String content;
    private Integer iscon;
    private Integer ismain;
    private String mqid;
    private List<ExampaperQuestion> branchQuestion;
    private String answerid;
    private List<ExampaperAnswer> answerList;
    private String qtid;
    private Integer atid;
    private String qtname;
    private Integer th;
    private Integer xxdf;
    private Integer mediaSet;
    private BigDecimal score;
    private String filepath;
    private String[] stuLastAns;

    public ExampaperQuestion(){}//kryo缓存必备

    public String getQid() {
        return qid;
    }

    public void setQid(String qid) {
        this.qid = qid;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public Integer getIscon() {
        return iscon;
    }

    public void setIscon(Integer iscon) {
        this.iscon = iscon;
    }

    public Integer getIsmain() {
        return ismain;
    }

    public void setIsmain(Integer ismain) {
        this.ismain = ismain;
    }

    public List<ExampaperQuestion> getBranchQuestion() {
        return branchQuestion;
    }

    public void setBranchQuestion(List<ExampaperQuestion> branchQuestion) {
        this.branchQuestion = branchQuestion;
    }

    public String getAnswerid() {
        return answerid;
    }

    public void setAnswerid(String answerid) {
        this.answerid = answerid;
    }

    public String getQtid() {
        return qtid;
    }

    public void setQtid(String qtid) {
        this.qtid = qtid;
    }

    public String getQtname() {
        return qtname;
    }

    public void setQtname(String qtname) {
        this.qtname = qtname;
    }

    public String getMqid() {
        return mqid;
    }

    public void setMqid(String mqid) {
        this.mqid = mqid;
    }

    public Integer getAtid() {
        return atid;
    }

    public void setAtid(Integer atid) {
        this.atid = atid;
    }

    public List<ExampaperAnswer> getAnswerList() {
        return answerList;
    }

    public void setAnswerList(List<ExampaperAnswer> answerList) {
        this.answerList = answerList;
    }

    public Integer getTh() {
        return th;
    }

    public void setTh(Integer th) {
        this.th = th;
    }

    public String getAnswerContent(){
        if(atid==5 || atid==6 || atid==7 || atid==12 || atid==13){
            for(ExampaperAnswer ea : answerList){
                if(ea.getAid().equals(answerid)){
                    return ea.getContent();
                }
            }
            return "";
        }
        return answerid;
    }

    public Integer getXxdf() {
        return xxdf;
    }

    public void setXxdf(Integer xxdf) {
        this.xxdf = xxdf;
    }

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
    }

    public String[] getStuLastAns() {
        return stuLastAns;
    }

    public void setStuLastAns(String[] stuLastAns) {
        this.stuLastAns = stuLastAns;
    }

    public String getFilepath() {
        return filepath;
    }

    public void setFilepath(String filepath) {
        this.filepath = filepath;
    }

    public Integer getMediaSet() {
        return mediaSet;
    }

    public void setMediaSet(Integer mediaSet) {
        this.mediaSet = mediaSet;
    }
}
