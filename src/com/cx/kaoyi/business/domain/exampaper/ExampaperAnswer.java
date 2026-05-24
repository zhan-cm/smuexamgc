package com.cx.kaoyi.business.domain.exampaper;

public class ExampaperAnswer {
    private String aid;
    private String qid;
    private Integer atid;
    private String content;
    private Integer aorder;

    public ExampaperAnswer(){}//kryo缓存必备

    public String getAid() {
        return aid;
    }

    public void setAid(String aid) {
        this.aid = aid;
    }

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

    public Integer getAorder() {
        return aorder;
    }

    public void setAorder(Integer aorder) {
        this.aorder = aorder;
    }

    public Integer getAtid() {
        return atid;
    }

    public void setAtid(Integer atid) {
        this.atid = atid;
    }
}
