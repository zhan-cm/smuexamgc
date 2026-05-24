package com.cx.kaoyi.framework.GPT.utils;

import com.cx.kaoyi.framework.base.HttpClientHolder;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import org.apache.commons.lang3.StringUtils;

import java.io.IOException;

public class AIUtils {

    private static final OkHttpClient TRY_IMG_CLIENT = HttpClientHolder.getClientWithTimeout(
                5,5,5);
    private static final String[] keepHtmlTagListWithImg = {
            "sub", "sup", "b", "i", "u", "em", "strong", "br",
            "math", "mrow", "mi", "mo", "mn", "msup", "msub", "mfrac",
            "table", "thead", "tbody", "tfoot", "tr", "td", "th", "caption", "colgroup", "col", "img"
    };

    private static final String[] keepHtmlTagList = {
            "sub", "sup", "b", "i", "u", "em", "strong", "br",
            "math", "mrow", "mi", "mo", "mn", "msup", "msub", "mfrac",
            "table", "thead", "tbody", "tfoot", "tr", "td", "th", "caption", "colgroup", "col"
    };

    public static String findJson(String input){
        if (input == null) return null;
        String s = replaceMarkDownJson(input);
        int n = s.length();
        int start = -1;

        for (int i = 0; i < n; i++) {
            char c = s.charAt(i);
            if (c == '{' || c == '[') { start = i; break; }
        }
        if (start < 0) return input;

        java.util.ArrayDeque<Character> stack = new java.util.ArrayDeque<>();
        boolean inString = false;
        boolean escape = false;

        for (int i = start; i < n; i++) {
            char c = s.charAt(i);

            if (inString) {
                if (escape) {
                    escape = false;
                } else if (c == '\\') {
                    escape = true;
                } else if (c == '"') {
                    inString = false;
                }
                continue;
            }

            if (c == '"') {
                inString = true;
                continue;
            }

            if (c == '{' || c == '[') {
                stack.push(c);
            } else if (c == '}' || c == ']') {
                if (stack.isEmpty()) continue; // 容错：多余闭合
                char open = stack.pop();
                if ((open == '{' && c != '}') || (open == '[' && c != ']')) {
                    // 括号类型不匹配：直接失败
                    return input;
                }
                if (stack.isEmpty()) {
                    return s.substring(start, i + 1).trim();
                }
            }
        }
        return input; // 没找到完整闭合 JSON
    }

    public static String findJsonArr(String str){
        if(str==null){
            return null;
        }
        boolean isObj = false;
        if(str.startsWith("{") && str.endsWith("}")){ //可能输出错了，由字符串数组输出为了对象，那么可能存在引号的错误转义
            isObj = true;
        }
        int begin = 0;
        int end = str.length();
        for(int i=0;i<end;i++){
            if(str.charAt(i)=='['){
                begin = i;
                break;
            }
        }

        for (int i=end-1;i>=0;i--){
            if(str.charAt(i)==']'){
                end = i+1;
                break;
            }
        }
        str = str.substring(begin,end);
        if(isObj){
            str = str.replace("\\\"","\"");
        }
        str = str.replaceAll("\"\"", "\"");
        return str;
    }

    public static String replaceMarkDownJson(String str){
        return str.replace("```json", "")
                .replace("json```", "")
                .replace("```markdown", "")
                .replace("markdown```", "")
                .replace("```", "");
    }

    public static String[] getKeepHtmlTagListWithImg(){
        return keepHtmlTagListWithImg;
    }

    public static String[] getKeepHtmlTagListNoImg(){
        return keepHtmlTagList;
    }

    /** 用 HEAD 请求检测 URL 是否返回 2xx */
    private static boolean isReachable(String url) {
        if (StringUtils.isBlank(url)) {
            return false;
        }
        Request req = new Request.Builder().url(url).head().build();
        try (Response resp = TRY_IMG_CLIENT.newCall(req).execute()) {
            return resp.isSuccessful();
        } catch (IOException e) {
            return false;   // 网络异常就当不可用
        }
    }
}