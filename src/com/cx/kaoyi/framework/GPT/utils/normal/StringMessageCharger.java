package com.cx.kaoyi.framework.GPT.utils.normal;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONException;
import com.alibaba.fastjson2.JSONObject;
import com.cx.kaoyi.framework.GPT.NormalDTO.Message;
import com.cx.kaoyi.framework.GPT.generateDTO.payload.AIPayloadV2;
import com.cx.kaoyi.framework.base.HttpClientHolder;
import okhttp3.*;

import java.io.IOException;
import java.net.SocketTimeoutException;
import java.util.*;

public class StringMessageCharger {
    private static final MediaType JSONType = MediaType.get("application/json; charset=utf-8");

    public static String sendMessage(String role, String content, int retryTime, String modelName, String apiKey2) {
        String url = "https://spark-api-open.xf-yun.com/agent/v1/chat/completions";
        Random random = new Random();
        AIPayloadV2 aiPayload = new AIPayloadV2();
        aiPayload.setModel(modelName);
        aiPayload.setSeed(Math.abs(random.nextInt()));
        aiPayload.setTemperature(0.5f);
        aiPayload.getResponseFormat().setType("text");
        OkHttpClient client = HttpClientHolder.
                getClientWithTimeout(15,120,120);
        switch (modelName){
            case "deepseek-r1":
                client = HttpClientHolder.
                        getClientWithTimeout(15,300,300);
                aiPayload.setMaxCompletionTokens(15000);
                break;
            case "ernie-4.5-turbo-vl-32k":
                aiPayload.setMaxCompletionTokens(12000);
                break;
            case "ernie-4.5-turbo-vl":
                client = HttpClientHolder.
                        getClientWithTimeout(15,300,300);
                aiPayload.setMaxCompletionTokens(12000);
                break;
            case "deepseek-v3":
                aiPayload.setMaxCompletionTokens(8000);
                break;
            case "ernie-4.5-turbo-32k":
                aiPayload.setMaxCompletionTokens(12000);
                break;
            case "ernie-4.0-turbo-8k":
                aiPayload.setMaxCompletionTokens(2048);
                break;
            case "ernie-x1-turbo-32k":
                client = HttpClientHolder.
                        getClientWithTimeout(15,300,300);
                aiPayload.setMaxCompletionTokens(15000);
                break;
            default:
                aiPayload.setMaxCompletionTokens(2048);
                break;
        }
        Message roleMessage = new Message();
        roleMessage.setRole("system");
        roleMessage.setContent(role);
        List<Message> list = new ArrayList<>();
        list.add(roleMessage);
        Message message = new Message();
        message.setRole("user");
        if(retryTime==0){
            aiPayload.setTemperature(1.0f);
            aiPayload.setSeed(Math.abs(random.nextInt()));
        }
        message.setContent(content);
        list.add(message);
        aiPayload.setMessages(list);
        String payload = JSON.toJSONString(aiPayload);
        RequestBody body = RequestBody.create(payload, JSONType);
        Request request = new Request.Builder()
                .url(url)
                .header("Content-Type", "application/json")
                .header("Authorization", "Bearer "+apiKey2)
                .post(body)
                .build();

        try (Response response = client.newCall(request).execute()) {
            Map<String, Object> ansMap = JSONObject.parseObject(response.body().string(), HashMap.class);
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
                String res = rtnMessage.getString("content");
                return res;
            }
        } catch (IOException e) {
            e.printStackTrace();
            if(e instanceof SocketTimeoutException && retryTime>0){ //仅在超时情况下重试
                return sendMessage(role,content,retryTime-1, modelName,apiKey2);
            }
        } catch (JSONException e){
            e.printStackTrace();
            if(retryTime>0){
                return sendMessage(role,content,retryTime-1, modelName,apiKey2);
            }
        } catch (Exception e) {  // 捕获所有其他未知异常
            e.printStackTrace();
        }
        return null;
    }
}