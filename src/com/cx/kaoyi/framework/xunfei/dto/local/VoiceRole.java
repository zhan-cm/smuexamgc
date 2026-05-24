package com.cx.kaoyi.framework.xunfei.dto.local;

public enum VoiceRole {
    CATHERINE("x4_enus_catherine_profnews"),
    RYAN("x4_enus_ryan_assist");

    private final String value;

    VoiceRole(String value) {
        this.value = value;
    }

    public String getValue() {
        return value;
    }
}
