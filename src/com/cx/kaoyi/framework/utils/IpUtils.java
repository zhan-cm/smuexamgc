package com.cx.kaoyi.framework.utils;

import com.cx.kaoyi.framework.base.IPRange;

import javax.servlet.http.HttpServletRequest;
import java.util.*;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

public class IpUtils {
    // —— 只保留合法 IPv4 (0.0.0.0 – 255.255.255.255) ——
    private static final Pattern IPV4_PATTERN = Pattern.compile(
            "^(25[0-5]|2[0-4]\\d|[0-1]?\\d?\\d)" +
                    "(\\.(25[0-5]|2[0-4]\\d|[0-1]?\\d?\\d)){3}$"
    );

    // —— 标准 IPv6 （8 段全写）——
    private static final Pattern IPV6_STD_PATTERN = Pattern.compile(
            "^[0-9a-fA-F]{1,4}(:[0-9a-fA-F]{1,4}){7}$"
    );
    // —— 压缩式 IPv6 （允许 :: 缩写）——
    private static final Pattern IPV6_HEX_COMPRESSED_PATTERN = Pattern.compile(
            "^((?:[0-9A-Fa-f]{1,4}(?::|$)){0,7})(?:::)((?:[0-9A-Fa-f]{1,4}(?::|$)){0,7})$"
    );

    /** 原有方法，纯 IPv4 过滤 */
    public static boolean isIpv4(String ip) {
        return ip != null && IPV4_PATTERN.matcher(ip).matches();
    }

    /** 新增：判断 IPv6 */
    public static boolean isIpv6(String ip) {
        if (ip == null) return false;
        return IPV6_STD_PATTERN.matcher(ip).matches()
                || IPV6_HEX_COMPRESSED_PATTERN.matcher(ip).matches();
    }

    public static boolean isOnlyLocal(HttpServletRequest request){
        Set<String> ipSet = getAllValidIp(request);
        if(ipSet.size()==1 && ipSet.contains("127.0.0.1")){
            return true;
        }
        return false;
    }

    public static boolean includeIp(HttpServletRequest request, String ip){
        Set<String> ipSet = getAllValidIp(request);
        for(String ipFind : ipSet){
            if(ipFind.equals(ip)){
                return true;
            }
        }
        return false;
    }

    /** 新增：任意合法 IP（v4 或 v6）*/
    public static boolean isIp(String ip) {
        return isIpv4(ip) || isIpv6(ip);
    }

    //=======================================================================
    // 支持 IPv4 + IPv6，并且只有当头部一条都没解析到时，
    // 才回退到 request.getRemoteAddr()（从而自动剔除 Nginx 本机回环）
    //=======================================================================

    /** 获取所有合法 IP（v4/v6），保序去重；只有在头部空时，才回退 RemoteAddr */
    public static Set<String> getAllValidIp(HttpServletRequest request) {
        Set<String> result = new LinkedHashSet<>();
        String[] HEADERS = {
                "X-Forwarded-For", "X-Real-IP",
                "Proxy-Client-IP", "WL-Proxy-Client-IP",
                "HTTP_CLIENT_IP", "HTTP_X_FORWARDED_FOR"
        };

        for (String header : HEADERS) {
            String list = request.getHeader(header);
            if (list == null || list.isEmpty() || "unknown".equalsIgnoreCase(list)) {
                continue;
            }
            for (String part : list.split(",")) {
                String ip = part.trim();
                if (isIp(ip)) {
                    result.add(ip);
                }
            }
        }

        // 只要头部解析到过任意一个，就不加入 RemoteAddr
        if (!result.isEmpty()) {
            return result;
        }

        // 头都没有，再回退 RemoteAddr（可能是 127.0.0.1 或 ::1）
        String remote = request.getRemoteAddr();
        if ("0:0:0:0:0:0:0:1".equals(remote) || "::1".equals(remote)) {
            remote = "127.0.0.1";
        }
        if (isIp(remote)) {
            result.add(remote);
        }
        return result;
    }

    public static Set<String> getAllValidIpv4(HttpServletRequest request) {
        Set<String> result = new LinkedHashSet<>();
        String[] HEADERS = {
                "X-Forwarded-For", "X-Real-IP",
                "Proxy-Client-IP", "WL-Proxy-Client-IP",
                "HTTP_CLIENT_IP", "HTTP_X_FORWARDED_FOR"
        };

        for (String header : HEADERS) {
            String list = request.getHeader(header);
            if (list == null || list.isEmpty() || "unknown".equalsIgnoreCase(list)) {
                continue;
            }
            for (String part : list.split(",")) {
                String ip = part.trim();
                if (isIpv4(ip)) {
                    result.add(ip);
                }
            }
        }

        // 只要头部解析到过任意一个，就不加入 RemoteAddr
        if (!result.isEmpty()) {
            return result;
        }

        // 头都没有，再回退 RemoteAddr（可能是 127.0.0.1 或 ::1）
        String remote = request.getRemoteAddr();
        if ("0:0:0:0:0:0:0:1".equals(remote) || "::1".equals(remote)) {
            remote = "127.0.0.1";
        }
        if (isIpv4(remote)) {
            result.add(remote);
        }
        return result;
    }

    public static String getFirstValidIpToString(HttpServletRequest request) {
        return getAllValidIp(request).stream()
                .limit(1)
                .collect(Collectors.joining(","));
    }

    /** IP 列表合并成逗号分隔的字符串 */
    public static String getAllValidIpToString(HttpServletRequest request) {
        return getAllValidIp(request).stream()
                .limit(2)
                .collect(Collectors.joining(","));
    }

    public static String matchAddrId(HttpServletRequest request) {
        Set<String> ids = matchAddrIds(request);
        return ids.stream().findFirst().orElse("");
    }

    public static Set<String> matchAddrIds(HttpServletRequest request) {
        Set<String> result = new HashSet<>();
        try {
            List<IPRange> ranges = (List<IPRange>)
                    request.getServletContext().getAttribute("addr4examRanges");
            Set<String> clientIps = getAllValidIpv4(request);
            for (String ip : clientIps) {
                for (IPRange r : ranges) {
                    if (r.contains(ip)) {
                        result.add(r.getId());
                    }
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result; // 可能是空集合
    }
}