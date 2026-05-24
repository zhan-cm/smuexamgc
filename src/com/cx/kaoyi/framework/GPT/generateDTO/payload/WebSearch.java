package com.cx.kaoyi.framework.GPT.generateDTO.payload;

import com.alibaba.fastjson2.annotation.JSONField;

public class WebSearch {

    /**
     * 是否开启实时搜索功能
     * 说明：
     * 1. 如果关闭实时搜索，角标和溯源信息都不会返回。
     * 2. 可选值：
     *    - true：开启
     *    - false：关闭（默认）
     */
    @JSONField(name = "enable")
    private boolean enable = false;

    /**
     * 是否开启上角标返回
     * 说明：
     * 1. 仅当 enable 为 true 时生效。
     * 2. 可选值：
     *    - true：开启，若开启且触发了搜索增强，响应内容会附上角标，并带上角标对应的搜索溯源信息。
     *    - false：未开启（默认）。
     * 3. 若检索内容包含非公开网页，则角标不生效。
     */
    @JSONField(name = "enable_citation")
    private boolean enableCitation = false;

    /**
     * 是否返回搜索溯源信息
     * 说明：
     * 1. 仅当 enable 为 true 时生效。
     * 2. 可选值：
     *    - true：返回，若为 true，则在触发搜索增强的情况下，会返回搜索溯源信息 search_results。
     *    - false：不返回（默认）。
     * 3. 若检索内容为非公开网页，即使触发搜索也不返回溯源信息。
     */
    @JSONField(name = "enable_trace")
    private boolean enableTrace = false;

    @JSONField(name = "enable_status")
    private boolean enableStatus = false;

    public boolean isEnable() {
        return enable;
    }
    public void setEnable(boolean enable) {
        this.enable = enable;
    }
    public boolean isEnableCitation() {
        return enableCitation;
    }
    public void setEnableCitation(boolean enableCitation) {
        this.enableCitation = enableCitation;
    }
    public boolean isEnableTrace() {
        return enableTrace;
    }
    public void setEnableTrace(boolean enableTrace) {
        this.enableTrace = enableTrace;
    }

    public boolean isEnableStatus() {
        return enableStatus;
    }

    public void setEnableStatus(boolean enableStatus) {
        this.enableStatus = enableStatus;
    }
}