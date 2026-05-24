package com.cx.kaoyi.business.domain.download;

import java.util.Date;

public class Progress {
    private String info;
    private Integer progressNum=0;
    private Integer total=0;
    private Integer isFinish=0;
    private Integer isRun = 0;
    private Date lastDate;
    private Date createDate;

    public Progress(){}

    public Progress(Integer total){
        this.total = total;
        this.createDate = new Date();
        this.lastDate = new Date();
        this.isRun = 1;
    }

    public void refreshLastDate(){
        this.lastDate = new Date();
    }

    public void addProgressNum(){
        this.progressNum = this.progressNum+1;
        refreshLastDate();
    }

    public Integer getProgressNum() {
        return progressNum;
    }

    public void setProgressNum(Integer progressNum) {
        this.progressNum = progressNum;
    }

    public Integer getTotal() {
        return total;
    }

    public void setTotal(Integer total) {
        this.total = total;
    }

    public Integer getIsFinish() {
        return isFinish;
    }

    public void setIsFinish(Integer isFinish) {
        this.isFinish = isFinish;
    }

    public Integer getIsRun() {
        return isRun;
    }

    public void setIsRun(Integer isRun) {
        this.isRun = isRun;
    }

    public Date getLastDate() {
        return lastDate;
    }

    public void setLastDate(Date lastDate) {
        this.lastDate = lastDate;
    }

    public Date getCreateDate() {
        return createDate;
    }

    public void setCreateDate(Date createDate) {
        this.createDate = createDate;
    }

    public String getInfo() {
        return info;
    }

    public void setInfo(String info) {
        this.info = info;
    }
}