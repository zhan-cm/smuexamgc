package com.cx.kaoyi.framework.xunfei.utils;

import com.alibaba.fastjson2.JSON;
import com.cx.kaoyi.framework.base.HttpClientHolder;
import com.cx.kaoyi.framework.xunfei.dto.local.VoiceRole;
import com.cx.kaoyi.framework.xunfei.dto.remote.JsonParse;
import okhttp3.*;

import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.net.URL;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.concurrent.CompletableFuture;

public class WebTtsWsService extends WebSocketListener {
    public static final String hostUrl = "https://tts-api.xfyun.cn/v2/tts";
    private final String appid;
    private final String apiSecret;
    private final String apiKey;
    private OkHttpClient client;
    private WebSocket webSocket;
    private CompletableFuture<byte[]> future;
    private ByteArrayOutputStream base64AudioStream; // 使用ByteArrayOutputStream来收集数据

    public WebTtsWsService(String appid, String apiSecret, String apiKey) {
        this.appid = appid;
        this.apiSecret = apiSecret;
        this.apiKey = apiKey;
        this.client = HttpClientHolder.getGlobalClient();
        this.base64AudioStream = new ByteArrayOutputStream();
    }

    private void connectToServer() throws Exception {
        String url = getAuthUrl(hostUrl, apiKey, apiSecret).replace("http://", "ws://").replace("https://", "wss://");
        Request request = new Request.Builder().url(url).build();
        webSocket = client.newWebSocket(request, this);
        future = new CompletableFuture<>();
    }

    public CompletableFuture<byte[]> sendMessage(String text, VoiceRole vcn, int speed, int pitch) throws Exception {
        connectToServer();
        // 连接成功后发送请求
        String requestJson = "{\n" +
                "  \"common\": {\n" +
                "    \"app_id\": \"" + appid + "\"\n" +
                "  },\n" +
                "  \"business\": {\n" +
                "    \"aue\": \"lame\",\n" +
                "    \"sfl\": 1,\n" +
                "    \"tte\": \"UTF8\",\n" +
                "    \"ent\": \"intp65\",\n" +
                "    \"vcn\": \"" + vcn.getValue() + "\",\n" +
                "    \"pitch\": " + pitch + ",\n" +
                "    \"speed\": " + speed + "\n" +
                "  },\n" +
                "  \"data\": {\n" +
                "    \"status\": 2,\n" +
                "    \"text\": \"" + Base64.getEncoder().encodeToString(text.getBytes(StandardCharsets.UTF_8)) + "\"\n" +
                "  }\n" +
                "}";
        webSocket.send(requestJson);
        return future;
    }

    @Override
    public void onMessage(WebSocket webSocket, String receivedText) {
        JsonParse myJsonParse = JSON.parseObject(receivedText, JsonParse.class);
        if (myJsonParse.getCode() != 0) {
            future.completeExceptionally(new RuntimeException("发生错误，错误码为：" + myJsonParse.getCode()));
            return;
        }
        if (myJsonParse.getData() != null) {
            try {
                byte[] tmp = Base64.getDecoder().decode(myJsonParse.getData().getAudio());
                base64AudioStream.write(tmp);  // 直接写入到ByteArrayOutputStream中
            } catch (IOException e) {
                future.completeExceptionally(e);
                return;
            }
            if (myJsonParse.getData().getStatus() == 2) {
                future.complete(base64AudioStream.toByteArray()); // 直接从ByteArrayOutputStream获取字节数组
                base64AudioStream.reset(); // 重置流以便下次使用
            }
        }
    }

    @Override
    public void onOpen(WebSocket webSocket, Response response) {
        // 关闭握手时的 ResponseBody，避免连接泄漏
        try (ResponseBody ignored = response.body()) {
            // nothing
        }
        super.onOpen(webSocket, response);
    }

    public void closeConnection() {
        if (webSocket != null) {
            webSocket.close(1000, "Closing connection");
        }
        if (client != null) {
            client.dispatcher().executorService().shutdown();// 关闭执行服务
            client.connectionPool().evictAll();// 清理并关闭连接池
            if (client.cache() != null) {
                try {
                    client.cache().close();// 如果有缓存，也关闭它
                } catch (IOException e) {
                    e.printStackTrace();
                }
            }
        }
        try {
            base64AudioStream.close(); // 关闭流资源
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    // 鉴权方法
    public static String getAuthUrl(String hostUrl, String apiKey, String apiSecret) throws Exception {
        URL url = new URL(hostUrl);
        SimpleDateFormat format = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss z", Locale.US);
        format.setTimeZone(TimeZone.getTimeZone("GMT"));
        String date = format.format(new Date());

        String preStr = "host: " + url.getHost() + "\n" +
                "date: " + date + "\n" +
                "GET " + url.getPath() + " HTTP/1.1";
        Mac mac = Mac.getInstance("hmacsha256");
        SecretKeySpec spec = new SecretKeySpec(apiSecret.getBytes(StandardCharsets.UTF_8), "hmacsha256");
        mac.init(spec);
        byte[] hexDigits = mac.doFinal(preStr.getBytes(StandardCharsets.UTF_8));
        String sha = Base64.getEncoder().encodeToString(hexDigits);
        String authorization = String.format("api_key=\"%s\", algorithm=\"%s\", headers=\"%s\", signature=\"%s\"", apiKey, "hmac-sha256", "host date request-line", sha);

        HttpUrl httpUrl = Objects.requireNonNull(HttpUrl.parse("https://" + url.getHost() + url.getPath())).newBuilder()
                .addQueryParameter("authorization", Base64.getEncoder().encodeToString(authorization.getBytes(StandardCharsets.UTF_8)))
                .addQueryParameter("date", date)
                .addQueryParameter("host", url.getHost())
                .build();

        return httpUrl.toString();
    }
}