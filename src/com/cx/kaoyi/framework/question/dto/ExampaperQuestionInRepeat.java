package com.cx.kaoyi.framework.question.dto;

import java.math.BigDecimal;

public class ExampaperQuestionInRepeat {
    private int eid;
    private int qid;
    private int atid;
    private int iscon;
    private String answerid;
    private BigDecimal score;
    private String contentRaw;
    private String content;
    private Hash128 contentHash;

    public int getEid() {
        return eid;
    }

    public void setEid(int eid) {
        this.eid = eid;
    }

    public int getQid() {
        return qid;
    }

    public void setQid(int qid) {
        this.qid = qid;
    }

    public int getAtid() {
        return atid;
    }

    public void setAtid(int atid) {
        this.atid = atid;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getContentRaw() {
        return contentRaw;
    }

    public void setContentRaw(String contentRaw) {
        this.contentRaw = contentRaw;
    }

    public Hash128 getContentHash() {
        return contentHash;
    }

    public void setContentHash(Hash128 contentHash) {
        this.contentHash = contentHash;
    }

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
    }

    public int getIscon() {
        return iscon;
    }

    public void setIscon(int iscon) {
        this.iscon = iscon;
    }

    public String getAnswerid() {
        return answerid;
    }

    public void setAnswerid(String answerid) {
        this.answerid = answerid;
    }
}