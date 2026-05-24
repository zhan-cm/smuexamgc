package com.cx.kaoyi.framework.GPT.generateDTO.payload;

import com.alibaba.fastjson2.annotation.JSONField;
import com.cx.kaoyi.framework.GPT.NormalDTO.Message;

import java.util.List;

public class AIPayloadV2 {
    private String model;
    private List<Message> messages;
    private float temperature = 0.95f;  //随机输出，0-1.0之内，越大越随机，默认0.95，不可为0
    @JSONField(name = "max_completion_tokens")
    private int maxCompletionTokens = 4096; //最大输出token数，默认是1024，deepseek最大是8192，但是不知道为啥百度限制最大4096
    //（1）取值范围: （0,2147483647‌），会由模型随机生成，默认值为空
    //（2）如果指定，系统将尽最大努力进行确定性采样，以便使用相同seed和参数的重复请求返回相同的结果
    private int seed;
    @JSONField(name = "web_search")
    private WebSearch webSearch = new WebSearch(); //联网搜索功能，暂不支持deepseek
    @JSONField(name = "response_format")
    private ResponseFormat responseFormat = new ResponseFormat(); //指定响应内容的格式，要求json

    public String getModel() {
        return model;
    }

    public void setModel(String model) {
        this.model = model;
    }

    public List<Message> getMessages() {
        return messages;
    }

    public void setMessages(List<Message> messages) {
        this.messages = messages;
    }

    public float getTemperature() {
        return temperature;
    }

    public void setTemperature(float temperature) {
        this.temperature = temperature;
    }

    public int getMaxCompletionTokens() {
        return maxCompletionTokens;
    }

    public void setMaxCompletionTokens(int maxCompletionTokens) {
        this.maxCompletionTokens = maxCompletionTokens;
    }

    public int getSeed() {
        return seed;
    }

    public void setSeed(int seed) {
        this.seed = seed;
    }

    public WebSearch getWebSearch() {
        return webSearch;
    }

    public void setWebSearch(WebSearch webSearch) {
        this.webSearch = webSearch;
    }

    public ResponseFormat getResponseFormat() {
        return responseFormat;
    }

    public void setResponseFormat(ResponseFormat responseFormat) {
        this.responseFormat = responseFormat;
    }
}
