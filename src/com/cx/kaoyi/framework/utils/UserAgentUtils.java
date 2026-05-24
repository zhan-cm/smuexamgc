package com.cx.kaoyi.framework.utils;

import nl.basjes.parse.useragent.UserAgent;
import nl.basjes.parse.useragent.UserAgentAnalyzer;
import org.apache.commons.codec.digest.DigestUtils;

import javax.servlet.http.HttpServletRequest;

public class UserAgentUtils {

    private static final UserAgentAnalyzer userAgentAnalyzer = UserAgentAnalyzer
            .newBuilder()
            .useJava8CompatibleCaching()
            .hideMatcherLoadStats()
            .withCache(1500)
            .withField(UserAgent.DEVICE_CLASS)        // 设备类别（例如: Phone, Tablet, Desktop）
            .withField(UserAgent.DEVICE_BRAND)        // 品牌（例如: Apple, Samsung）
            .withField(UserAgent.DEVICE_NAME)         // 产品名/型号（例如: iPhone, Galaxy S22）
            .withField(UserAgent.OPERATING_SYSTEM_NAME)     // 操作系统（例如: iOS, Android）
            .withField(UserAgent.OPERATING_SYSTEM_VERSION)  // 操作系统版本（例如: 17.3, 14.0）
            .withField(UserAgent.AGENT_NAME)          // 浏览器名称（例如: Chrome, Safari）
            .withField(UserAgent.AGENT_VERSION)       // 浏览器版本
            .withField(UserAgent.AGENT_INFORMATION_EMAIL) //agent邮箱，辅助识别出型号
            .withField(UserAgent.AGENT_INFORMATION_URL) //agent官网，辅助识别出型号
            .build();

    public static String parseDevice(String userAgentString) {
        UserAgent agent = userAgentAnalyzer.parse(userAgentString);

        String deviceClass = agent.getValue(UserAgent.DEVICE_CLASS); // Phone, Tablet, Desktop
        String brand = agent.getValue(UserAgent.DEVICE_BRAND);       // Apple, Huawei, etc.
        String model = agent.getValue(UserAgent.DEVICE_NAME);        // iPhone 13 Pro, etc.
        String os = agent.getValue(UserAgent.OPERATING_SYSTEM_NAME); // iOS, Android
        String osVersion = agent.getValue(UserAgent.OPERATING_SYSTEM_VERSION);
        String browser = agent.getValue(UserAgent.AGENT_NAME);       // Safari, Chrome
        String browserVersion = agent.getValue(UserAgent.AGENT_VERSION);

        String deviceInfo = String.format("设备:%s %s (%s) | 系统:%s %s | 浏览器:%s %s",
                brand != null ? brand : "未知",
                model != null ? model : "未知",
                deviceClass != null ? deviceClass : "未知",
                os != null ? os : "未知",
                osVersion != null ? osVersion : "",
                browser != null ? browser : "未知",
                browserVersion != null ? browserVersion : "");
        return deviceInfo;
    }

    public static String fingerprint(HttpServletRequest req){
        String ua = String.valueOf(req.getHeader("User-Agent"));
        String ip = IpUtils.getAllValidIpToString(req);
        return DigestUtils.sha256Hex(ip + "|" + ua);
    }
}