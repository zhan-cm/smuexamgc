package com.cx.kaoyi.framework.GPT.generateDTO.payload;
import com.alibaba.fastjson2.JSONObject;
import com.alibaba.fastjson2.annotation.JSONField;

import java.util.Map;

public class ResponseFormat {

    /**
     * 指定响应内容的格式，可选值：
     * json_object：以json格式返回，可能出现不满足效果情况
     * text：以文本格式返回，默认为text
     * json_schema：以json_schema规定的格式返回
     */
    private String type = "json_schema";  // 不设置的话默认返回文本格式
    @JSONField(name = "json_schema")
    private Map<String, Object> jsonSchema; //当type为json_schema时，该参数必填

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public Map<String, Object> getJsonSchema() {
        return jsonSchema;
    }

    public void setJsonSchema(Map<String, Object> jsonSchema) {
        this.jsonSchema = jsonSchema;
    }

    public void setJsonSchemaFromString(String jsonSchemaString) {
        this.jsonSchema = JSONObject.parseObject(jsonSchemaString,Map.class);
    }
}