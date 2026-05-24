package com.cx.kaoyi.framework.base;

import okhttp3.OkHttpClient;

import java.util.concurrent.TimeUnit;

public class HttpClientHolder {
    private static final OkHttpClient globalClient = new OkHttpClient();

    public static OkHttpClient getGlobalClient() {
        return globalClient;
    }

    public static OkHttpClient getClientWithTimeout(int connectTimeoutSeconds,
                                                    int readTimeoutSeconds,
                                                    int writeTimeoutSeconds) {
        return globalClient.newBuilder()
            .connectTimeout(connectTimeoutSeconds, TimeUnit.SECONDS)
            .readTimeout(readTimeoutSeconds, TimeUnit.SECONDS)
            .writeTimeout(writeTimeoutSeconds, TimeUnit.SECONDS)
            .build();
    }
}
