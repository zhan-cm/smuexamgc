package com.cx.kaoyi.business.domain.exampaper.db;

import java.math.BigDecimal;

public class ExampaperQuestionDb {
    private String qid;
    private String content;
    private Integer iscon;
    private Integer ismain;
    private String answerid;
    private String qtid;
    private Integer atid;
    private Integer th;
    private String mqid;
    private String theme1id;
    private String theme2id;
    private String theme3id;
    private String filepath;
    private BigDecimal score;

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

    public Integer getTh() {
        return th;
    }

    public void setTh(Integer th) {
        this.th = th;
    }

    public String getTheme1id() {
        return theme1id;
    }

    public void setTheme1id(String theme1id) {
        this.theme1id = theme1id;
    }

    public String getTheme2id() {
        return theme2id;
    }

    public void setTheme2id(String theme2id) {
        this.theme2id = theme2id;
    }

    public String getTheme3id() {
        return theme3id;
    }

    public void setTheme3id(String theme3id) {
        this.theme3id = theme3id;
    }

    public BigDecimal getScore() {
        return score;
    }

    public void setScore(BigDecimal score) {
        this.score = score;
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

    public String getFilepath() {
        return filepath;
    }

    public void setFilepath(String filepath) {
        this.filepath = filepath;
    }
}
