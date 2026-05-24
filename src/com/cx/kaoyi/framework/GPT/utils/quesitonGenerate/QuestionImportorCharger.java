package com.cx.kaoyi.framework.GPT.utils.quesitonGenerate;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONException;
import com.alibaba.fastjson2.JSONObject;
import com.cx.kaoyi.framework.GPT.NormalDTO.Message;
import com.cx.kaoyi.framework.GPT.generateDTO.GeneratedQuestion;
import com.cx.kaoyi.framework.GPT.generateDTO.business.QuestionGeneratorConfig;
import com.cx.kaoyi.framework.GPT.generateDTO.payload.AIPayloadV2;
import com.cx.kaoyi.framework.GPT.utils.AIUtils;
import com.cx.kaoyi.framework.base.HttpClientHolder;
import com.cx.kaoyi.framework.utils.serialize.FastJsonTypeRefs;
import okhttp3.*;

import java.io.IOException;
import java.net.SocketTimeoutException;
import java.util.*;

public class QuestionImportorCharger {
    private static final OkHttpClient client = HttpClientHolder.
            getClientWithTimeout(35,90,90);
    private static final MediaType JSONType = MediaType.get("application/json; charset=utf-8");

    public static GeneratedQuestion sendMessage(String importRequest, GeneratedQuestion nowImportedQuestion, int retryTime) {
        String url = "https://spark-api-open.xf-yun.com/agent/v1/chat/completions";
        AIPayloadV2 aiPayload = new AIPayloadV2();
        aiPayload.setModel("ernie-x1.1-preview");
        aiPayload.getResponseFormat().setType("text");
        aiPayload.setTemperature(0.35f);
        aiPayload.setMaxCompletionTokens(60000);
        Message roleMessage = new Message();
        roleMessage.setRole("system");
        roleMessage.setContent(QuestionGeneratorConfig.getConfigMap().get("questionImport"));
        List<Message> list = new ArrayList<>();
        list.add(roleMessage);
        Message message = new Message();
        message.setRole("user");
        String sendContent = "\n试题字符串内容如下：\n"+importRequest+"；\n已被提取的试题内容如下,如果是空对象则说明还没有提取任何题目："
                +JSONObject.toJSONString(nowImportedQuestion);
        if(retryTime==0){
            aiPayload.setTemperature(0.8f);
        }
        message.setContent(sendContent);
        list.add(message);
        aiPayload.setMessages(list);
        String payload = JSON.toJSONString(aiPayload);
        RequestBody body = RequestBody.create(payload, JSONType);
        Request request = new Request.Builder()
                .url(url)
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer "+QuestionGeneratorConfig.getAPIKeyV2())
                .post(body)
                .build();

        try (Response response = client.newCall(request).execute()) {
            Map<String, Object> ansMap = JSONObject.parseObject(response.body().string());
            if(ansMap.get("error")!=null){
                System.out.println(ansMap.get("error").toString());
                return null;
            }
            if(ansMap.get("choices")!=null){
                JSONArray choices = (JSONArray) ansMap.get("choices");
                if (choices.isEmpty()) {
                    System.out.println("choices 为空");
                    return null;
                }
                JSONObject choice = choices.getJSONObject(0);
                if (!choice.containsKey("message")) {
                    System.out.println("message 字段缺失");
                    return null;
                }
                JSONObject rtnMessage = choice.getJSONObject("message");
                if (!rtnMessage.containsKey("content")) {
                    System.out.println("content 字段缺失");
                    return null;
                }
                String content = AIUtils.replaceMarkDownJson(rtnMessage.getString("content"));
                if("null".equals(content)){
                    return null;
                }
                return JSONObject.parseObject(AIUtils.findJson(content), GeneratedQuestion.class);
            }
        } catch (IOException e) {
            e.printStackTrace();
            if(e instanceof SocketTimeoutException && retryTime>0){ //仅在超时情况下重试
                return sendMessage(importRequest,nowImportedQuestion,retryTime-1);
            }
        } catch (JSONException e){
            e.printStackTrace();
            if(retryTime>0){
                return sendMessage(importRequest,nowImportedQuestion,retryTime-1);
            }
        } catch (Exception e) {  // 捕获所有其他未知异常
            e.printStackTrace();
        }
        return null;
    }
}
