package com.cx.kaoyi.framework.shiro.dto;

import java.util.Date;

public class PasswordWrongRecord {
    private int wrongCount = 0;
    public PasswordWrongRecord(){}//kryo缓存必备

    private Date lastWrongTime = new Date();

    public Date getLastWrongTime() {
        return lastWrongTime;
    }

    public void setLastWrongTime(Date lastWrongTime) {
        this.lastWrongTime = lastWrongTime;
    }

    public int getWrongCount() {
        return wrongCount;
    }

    public void setWrongCount(int wrongCount) {
        this.wrongCount = wrongCount;
    }

    public void addWrongCountAndRefreshTime(){
        this.wrongCount++;
        this.lastWrongTime = new Date();
    }
}
