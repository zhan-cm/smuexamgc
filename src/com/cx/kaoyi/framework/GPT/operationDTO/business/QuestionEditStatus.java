package com.cx.kaoyi.framework.GPT.operationDTO.business;

public enum QuestionEditStatus {
    RUNNING("运行中"),
    EMPTY("空闲中"),
    FINISH("已完成");

    private final String desc;
    QuestionEditStatus(String desc) {
        this.desc = desc;
    }
    public String getDesc() {
        return desc;
    }
}
