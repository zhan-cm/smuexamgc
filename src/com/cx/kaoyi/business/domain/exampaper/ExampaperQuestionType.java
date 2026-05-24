package com.cx.kaoyi.business.domain.exampaper;

import java.util.List;

public class ExampaperQuestionType {
    private String qtid;
    private String qtname;
    private String e_qtname;
    private String qtDesc;
    private String e_qtDesc;
    private Integer qtOrder;
    private Long qtTime;
    private Integer xxdf;
    private Integer mediaSet;
    private List<ExampaperQuestion> questionList;

    public ExampaperQuestionType(){}//kryo缓存必备

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

    public String getQtDesc() {
        return qtDesc;
    }

    public void setQtDesc(String qtDesc) {
        this.qtDesc = qtDesc;
    }

    public Integer getQtOrder() {
        return qtOrder;
    }

    public void setQtOrder(Integer qtOrder) {
        this.qtOrder = qtOrder;
    }

    public Long getQtTime() {
        return qtTime;
    }

    public void setQtTime(Long qtTime) {
        this.qtTime = qtTime;
    }

    public List<ExampaperQuestion> getQuestionList() {
        return questionList;
    }

    public void setQuestionList(List<ExampaperQuestion> questionList) {
        this.questionList = questionList;
    }

    public String getE_qtDesc() {
        return e_qtDesc;
    }

    public void setE_qtDesc(String e_qtDesc) {
        this.e_qtDesc = e_qtDesc;
    }

    public String getE_qtname() {
        return e_qtname;
    }

    public void setE_qtname(String e_qtname) {
        this.e_qtname = e_qtname;
    }

    public Integer getXxdf() {
        return xxdf;
    }

    public void setXxdf(Integer xxdf) {
        this.xxdf = xxdf;
    }

    public Integer getMediaSet() {
        return mediaSet;
    }

    public void setMediaSet(Integer mediaSet) {
        this.mediaSet = mediaSet;
    }
}
