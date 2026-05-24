package com.cx.kaoyi.business.domain.exampaper.db;

public class ExampaperAnswerDb {
    private String aid;
    private String qid;
    private Integer atid;
    private String content;
    private String content_6;
    private Integer aorder;

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

    public String getContent_6() {
        return content_6;
    }

    public void setContent_6(String content_6) {
        this.content_6 = content_6;
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
