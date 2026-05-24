package com.cx.kaoyi.business.domain.exampaper.db;

public class ExampaperQuestionTypeDb {
    private String qtid;
    private String qtname;
    private String qtDesc;
    private Integer qtOrder;
    private Long qtTime;
    private Integer xxdf;
    private Integer mediaSet;

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
