package com.cx.kaoyi.framework.GPT.generateDTO.business;

import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Component;
import org.springframework.util.StreamUtils;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

@Component
public class QuestionGeneratorConfig {

    private static Map<String, String> configMap = new ConcurrentHashMap<>();
    private static String APIKeyV2 = "";

    // 构造函数
    public QuestionGeneratorConfig() throws IOException {
        // 获取 gptfiles 目录
        ClassLoader classLoader = getClass().getClassLoader();
        URL resourceUrl = classLoader.getResource("resources/gptfiles");
        if (resourceUrl != null) {
            String decodedPath = URLDecoder.decode(resourceUrl.getFile(), StandardCharsets.UTF_8.name());
            File directory = new File(decodedPath);
            if (directory.isDirectory()) {
                File[] files = directory.listFiles();
                if (files != null) {
                    for (File file : files) {
                        if (file.isFile()) {
                            try (InputStream inputStream = classLoader.getResourceAsStream("resources/gptfiles/" + file.getName())) {
                                String fileName = file.getName();
                                String key = fileName.substring(0, fileName.lastIndexOf('.'));
                                String value = StreamUtils.copyToString(inputStream, StandardCharsets.UTF_8);
                                configMap.put(key, value);
                            }
                        }
                    }
                }
            }
        } else {
            System.out.println("gptfiles目录未找到，启动失败");
        }
    }

    public static void setAPIKeyV2(String input){
        if(StringUtils.isNotBlank(input)){
            APIKeyV2 = input.trim();;
        }
    }

    public static String getAPIKeyV2(){
        return APIKeyV2;
    }

    public static Map<String, String> getConfigMap() {
        return configMap;
    }
}