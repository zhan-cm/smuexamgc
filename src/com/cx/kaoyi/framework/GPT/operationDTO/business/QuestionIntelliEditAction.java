package com.cx.kaoyi.framework.GPT.operationDTO.business;

public enum QuestionIntelliEditAction {
    TRANSLATE("翻译题目"),
    GENERATE_SIMILAR("出类似题目");

    private final String desc;
    QuestionIntelliEditAction(String desc) {
            this.desc = desc;
        }
    public String getDesc() {
            return desc;
        }
}