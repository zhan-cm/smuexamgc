package com.cx.kaoyi.framework.GPT.utils.quesitonGenerate;

import com.alibaba.fastjson2.JSON;
import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONException;
import com.alibaba.fastjson2.JSONObject;
import com.cx.kaoyi.framework.GPT.NormalDTO.Message;
import com.cx.kaoyi.framework.GPT.generateDTO.MainGeneratedQuestion;
import com.cx.kaoyi.framework.GPT.generateDTO.business.QuestionGeneratorConfig;
import com.cx.kaoyi.framework.GPT.generateDTO.payload.AIPayloadV2;
import com.cx.kaoyi.framework.GPT.generateDTO.payload.WebSearch;
import com.cx.kaoyi.framework.GPT.utils.AIUtils;
import com.cx.kaoyi.framework.base.HttpClientHolder;
import com.cx.kaoyi.framework.utils.serialize.FastJsonTypeRefs;
import okhttp3.*;

import java.io.IOException;
import java.net.SocketTimeoutException;
import java.util.*;

public class QuestionIsconGeneratorCharger {
    private static final OkHttpClient client = HttpClientHolder.
            getClientWithTimeout(20,120,120);
    private static final MediaType JSONType = MediaType.get("application/json; charset=utf-8");

    public static MainGeneratedQuestion sendMessage(String questionRequire, int promptJsonIndex, int retryTime, boolean useEnglish) {
        String url = "https://spark-api-open.xf-yun.com/agent/v1/chat/completions";
        Random random = new Random();
        AIPayloadV2 aiPayload = new AIPayloadV2();
        WebSearch webSearch = new WebSearch();
        webSearch.setEnable(true);
        aiPayload.setWebSearch(webSearch);
        aiPayload.setModel("ernie-4.5-turbo-32k");
        aiPayload.setSeed(Math.abs(random.nextInt()));
        aiPayload.getResponseFormat().setType("text");
        aiPayload.setMaxCompletionTokens(12000);
        Message roleMessage = new Message();
        roleMessage.setRole("system");
        String formatRequire = QuestionGeneratorConfig.getConfigMap().get("question"+promptJsonIndex);
        formatRequire += "\n\n//所有字段内容请用普通文本输出，不要使用加粗、星号或其他 Markdown 标记。";
        String useEnglishStr = useEnglish?"\n生成的题目内容请全部使用英文输出，因为这是英文题":"";
        roleMessage.setContent("你是串题题目生成助手，我将给你一个题目要求，包含题目所属试卷/课程，题目主题词要求等要求，请你生成一道专业综合性较强且难度较大的串题。" +
                "其中串题是指有一道主题干内容和若干与主题干相关的子题的题型，每道子题题目与答案类型均一致。"+
                "你的回复内容应为json字符串格式，格式如下："+formatRequire+useEnglishStr);
        List<Message> list = new ArrayList<>();
        list.add(roleMessage);
        Message message = new Message();
        message.setRole("user");
        String sendContent = "需生成的题目内容要求如下：\n"+questionRequire+useEnglishStr;
        List<String> cognition = Arrays.asList("应用", "记忆", "理解");
        List<String> theme = findQuestionTheme(questionRequire, 1);
        int random1 = random.nextInt(theme.size());
        int random2 = random.nextInt(cognition.size());
        String addPrompt = String.format("可以从这个方面出题：关于%s的%s型题目", theme.get(random1), cognition.get(random2));
        sendContent += addPrompt;
        if(retryTime==0){
            aiPayload.setTemperature(1.0f);
            aiPayload.setSeed(random.nextInt());
            sendContent += "请记住格式如下："+formatRequire+useEnglishStr;
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
                MainGeneratedQuestion askResponse = JSONObject.parseObject(AIUtils.findJson(content), MainGeneratedQuestion.class);
                return askResponse;
            }
        } catch (IOException e) {
            e.printStackTrace();
            if(e instanceof SocketTimeoutException && retryTime>0){ //仅在超时情况下重试
                return sendMessage(questionRequire,promptJsonIndex,retryTime-1, useEnglish);
            }
        } catch (JSONException e){
            e.printStackTrace();
            if(retryTime>0){
                return sendMessage(questionRequire,promptJsonIndex,retryTime-1, useEnglish);
            }
        } catch (Exception e) {  // 捕获所有其他未知异常
            e.printStackTrace();
        }
        return null;
    }

    private static List<String> findQuestionTheme(String questionRequire, int retryTime) {
        String url = "https://spark-api-open.xf-yun.com/agent/v1/chat/completions";
        Random random = new Random();
        AIPayloadV2 aiPayload = new AIPayloadV2();
        aiPayload.setModel("ernie-4.5-turbo-32k");
        aiPayload.setSeed(Math.abs(random.nextInt()));
        aiPayload.getResponseFormat().setType("text");

        Message roleMessage = new Message();
        roleMessage.setRole("system");
        roleMessage.setContent("你是题目生成助手，我将给你一个题目要求，包含题目所属试卷/课程，题目主题词要求等要求，请你分析一下这个题可以从哪些个层面出。细化一下主题词。"+
                "你的回复内容应为字符串数组，并转为json格式类似[\"主题词1\",\"主题词2\"]的字符串数组，比如我给你主题词是“脑和脑神经”，你应当返回的内容格式类似如下："+
                QuestionGeneratorConfig.getConfigMap().get("questionSeparate")+"\n，返回的就是一个纯字符串，格式是json的字符串数组，只有一个数组，以“[”开头且以“]”结尾，这个数组里面的字符串可以有若干个，但只有这一个数组。");
        List<Message> list = new ArrayList<>();
        list.add(roleMessage);
        Message message = new Message();
        message.setRole("user");
        String sendContent = "需生成的题目内容要求如下：/n"+questionRequire;
        if(retryTime==0){
            aiPayload.setTemperature(1.0f);
            aiPayload.setSeed(Math.abs(random.nextInt()));
            sendContent += "请记住格式如下："+QuestionGeneratorConfig.getConfigMap().get("questionSeparate")+"\n，返回的就是一个纯字符串，格式是json的字符串数组，只有一个数组，以“[”开头且以“]”结尾，这个数组里面的字符串可以有若干个，但只有这一个数组。";
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
                List<String> askResponse = JSONObject.parseObject(AIUtils.findJsonArr(
                        AIUtils.replaceMarkDownJson(rtnMessage.getString("content"))), FastJsonTypeRefs.LIST_STR_REFS);
                return askResponse;
            }
        } catch (IOException e) {
            e.printStackTrace();
            if(e instanceof SocketTimeoutException && retryTime>0){ //仅在超时情况下重试
                return findQuestionTheme(questionRequire,retryTime-1);
            }
        } catch (JSONException e){
            e.printStackTrace();
            if(retryTime>0){
                return findQuestionTheme(questionRequire,retryTime-1);
            }
        } catch (Exception e) {  // 捕获所有其他未知异常
            e.printStackTrace();
        }
        return null;
    }
}
