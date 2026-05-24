package com.cx.kaoyi.framework.GPT.generateDTO;

import java.util.Date;

public class QuestionGeneratedParam {
    private String id;
    private String creatorId;
    private String creatorname;
    private String theme1Id;
    private String theme2Id;
    private String theme3Id;
    private String qtid;
    private String cname;
    private String theme;
    private Integer iscon;
    private Integer ismain;
    private Integer atid;
    private String qtname;
    private int promptJsonIndex;
    private String ansType;
    private String qtiscon;
    private Integer source;
    private String answerExplain;
    private String content;
    private String answerid;
    private String mqid;
    private String cid;          // 缺失的字段
    private String filepath;     // 缺失的字段
    private String updatorid;    // 缺失的字段
    private Date updatetime;     // 缺失的字段
    private String updatorname;  // 缺失的字段
    private Integer state;       // 缺失的字段

    // 构造方法保持不变

    // Getter 和 Setter 方法
    public String getCid() {
        return cid;
    }

    public void setCid(String cid) {
        this.cid = cid;
    }

    public Integer getIscon() {
        return iscon;
    }

    public void setIscon(Integer iscon) {
        this.iscon = iscon;
    }

    public String getFilepath() {
        return filepath;
    }

    public void setFilepath(String filepath) {
        this.filepath = filepath;
    }

    public String getUpdatorid() {
        return updatorid;
    }

    public void setUpdatorid(String updatorid) {
        this.updatorid = updatorid;
    }

    public Date getUpdatetime() {
        return updatetime;
    }

    public void setUpdatetime(Date updatetime) {
        this.updatetime = updatetime;
    }

    public String getUpdatorname() {
        return updatorname;
    }

    public void setUpdatorname(String updatorname) {
        this.updatorname = updatorname;
    }

    public Integer getState() {
        return state;
    }

    public void setState(Integer state) {
        this.state = state;
    }

    public QuestionGeneratedParam(String creatorId, String creatorname, String theme1Id, String theme2Id, String theme3Id, String qtid, String cname, String theme,
                                  Integer atid, Integer iscon, String qtname) {
        this.creatorId = creatorId;
        this.creatorname = creatorname;
        this.theme1Id = theme1Id;
        this.theme2Id = theme2Id;
        this.theme3Id = theme3Id;
        this.qtid = qtid;
        this.cname = cname;
        this.theme = theme;
        this.atid = atid;
        this.iscon = iscon;
        this.ismain = 0;
        this.qtname = qtname;

        this.ansType = "单选题";
        this.promptJsonIndex = 0;
        if(atid==0||atid==2||atid==8){
            this.ansType = "单选题";
            this.promptJsonIndex = 0;
        }else if(atid==1||atid==3||atid==9){
            this.ansType = "多选题";
            this.promptJsonIndex = 1;
        }else if(atid==4){
            this.ansType = "判断题";
            this.promptJsonIndex = 2;
        }else if(atid==5||atid==6||atid==7||atid==10||atid==11){
            this.ansType = "主观题";
            this.promptJsonIndex = 3;
        }else if(atid==13){
            this.ansType = "在线编程题";
        }else if(atid==12){
            this.ansType = "英语听力题";
        }
        if(iscon==1){
            this.promptJsonIndex += 10;
        }
        if(qtname.contains("B1型题") || "155".equals(qtid)){ //B1型题
            this.promptJsonIndex = 14;
        }
    }

    public String getCname() {
        return cname;
    }

    public void setCname(String cname) {
        this.cname = cname;
    }

    public String getTheme() {
        return theme;
    }

    public void setTheme(String theme) {
        this.theme = theme;
    }

    public String getQtname() {
        return qtname;
    }

    public void setQtname(String qtname) {
        this.qtname = qtname;
    }

    public int getPromptJsonIndex() {
        return promptJsonIndex;
    }

    public void setPromptJsonIndex(int promptJsonIndex) {
        this.promptJsonIndex = promptJsonIndex;
    }

    public String getAnsType() {
        return ansType;
    }

    public void setAnsType(String ansType) {
        this.ansType = ansType;
    }

    public Integer getAtid() {
        return atid;
    }

    public void setAtid(Integer atid) {
        this.atid = atid;
    }

    public String getQtid() {
        return qtid;
    }

    public void setQtid(String qtid) {
        this.qtid = qtid;
    }

    public String getTheme3Id() {
        return theme3Id;
    }

    public void setTheme3Id(String theme3Id) {
        this.theme3Id = theme3Id;
    }

    public String getTheme2Id() {
        return theme2Id;
    }

    public void setTheme2Id(String theme2Id) {
        this.theme2Id = theme2Id;
    }

    public String getTheme1Id() {
        return theme1Id;
    }

    public void setTheme1Id(String theme1Id) {
        this.theme1Id = theme1Id;
    }

    public String getCreatorname() {
        return creatorname;
    }

    public void setCreatorname(String creatorname) {
        this.creatorname = creatorname;
    }

    public String getCreatorId() {
        return creatorId;
    }

    public void setCreatorId(String creatorId) {
        this.creatorId = creatorId;
    }

    public String getQtiscon(){
        return qtiscon;
    }

    public void setQtiscon(String qtiscon){
        this.qtiscon = qtiscon;
    }

    public Integer getSource(){
        return source;
    }

    public void setSource(Integer source){
        this.source = source;
    }

    public String getAnswerExplain(){
        return answerExplain;
    }

    public void setAnswerExplain(String answerExplain){
        this.answerExplain = answerExplain;
    }

    public String getContent(){
        return content;
    }

    public void setContent(String content){
        this.content = content;
    }

    public String getAnswerid(){
        return answerid;
    }

    public void setAnswerid(String answerid){
        this.answerid = answerid;
    }

    public String getId(){
        return id;
    }

    public void setId(String id){
        this.id = id;
    }

    public String getMqid(){
        return mqid;
    }

    public void setMqid(String mqid){
        this.mqid = mqid;
    }

    public Integer getIsmain() {
        return ismain;
    }

    public void setIsmain(Integer ismain) {
        this.ismain = ismain;
    }
}
