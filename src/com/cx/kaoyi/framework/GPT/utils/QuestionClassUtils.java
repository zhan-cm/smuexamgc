package com.cx.kaoyi.framework.GPT.utils;

import com.cx.kaoyi.framework.GPT.generateDTO.GeneratedQuestion;
import com.cx.kaoyi.framework.GPT.generateDTO.MainGeneratedQuestion;
import com.cx.kaoyi.framework.utils.Utils;
import org.apache.commons.lang3.StringUtils;

import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class QuestionClassUtils {

    /**
     * 用来拆选项内容，比如：
     * A. 高血压
     * A、高血压
     * A: 高血压
     * A) 高血压
     */
    private static final Pattern OPTION_PATTERN =
            Pattern.compile("^\\s*([A-Z])\\s*[\\.．、:：\\)）]?\\s*(.*)$");

    /**
     * 串题：主题干 + 子题列表
     */
    public static MainGeneratedQuestion toMainGeneratedQuestion(Map<String, Object> mainQuestion,
                                                                List<Map<String, Object>> questionList) {
        MainGeneratedQuestion result = new MainGeneratedQuestion();
        if (mainQuestion == null) {
            result.setQuestionList(Collections.emptyList());
            return result;
        }

        String mainQtype = Objects.toString(mainQuestion.get("qtname"),"");
        result.setQtype(mainQtype);
        result.setContent(Objects.toString(mainQuestion.get("content"),""));

        List<GeneratedQuestion> children = new ArrayList<>();
        if (questionList != null) {
            for (Map<String, Object> questionMap : questionList) {
                children.add(toGeneratedQuestion(questionMap));
            }
        }
        result.setQuestionList(children);
        return result;
    }

    /**
     * 非串题：单题
     * 或者串题里的子题
     */
    public static GeneratedQuestion toGeneratedQuestion(Map<String, Object> questionMap) {
        GeneratedQuestion result = new GeneratedQuestion();
        if (questionMap == null) {
            result.setAnswerList(Collections.emptyList());
            return result;
        }

        String qtype = Objects.toString(questionMap.get("qtname"),"");

        Integer atid = Utils.changeObjToInt(questionMap.get("atid"));

        result.setQtype(qtype);
        String ans = Objects.toString(questionMap.get("answer"),"");
        result.setContent(Objects.toString(questionMap.get("content"),"") + buildFilePath(Objects.toString(questionMap.get("filepath"),"")));
        result.setAnswer(ans);
        result.setExplain(Objects.toString(questionMap.get("exp"),""));

        if (Arrays.asList(5, 6, 7, 12, 13).contains(atid)) {
            result.setAnswerList(Collections.emptyList());
        } else if(atid==4) { //判断题
            List<Map<String,String>> ansList = new ArrayList<>();
            Map<String, String> map1 = new HashMap<>();
            map1.put("A", "true");
            Map<String, String> map2 = new HashMap<>();
            map2.put("B", "false");
            ansList.add(map1);
            ansList.add(map2);
            result.setAnswerList(ansList);
            if("true".equalsIgnoreCase(ans) || "对".equals(ans) || "正确".equals(ans) || "正".equals(ans) || "√".equals(ans)){
                result.setAnswer("A");
            }else {
                result.setAnswer("B");
            }
        } else {
            result.setAnswerList(buildOptionAnswerList(questionMap.get("answerList")));
        }

        return result;
    }

    private static String buildFilePath(String filePath) {
        if (filePath == null || filePath.trim().isEmpty()) {
            return "";
        }
        String[] tmp = filePath.split(",");
        StringBuilder sb = new StringBuilder();
        for (String path : tmp) {
            if (path == null || path.trim().isEmpty()) {
                continue;
            }
            path = path.trim();
            String lowerPath = path.toLowerCase();
            if (lowerPath.contains(".mp4")) {
                sb.append("<video class=\"attachment-video\" controls preload=\"metadata\">")
                        .append("<source src=\"").append(path).append("\" type=\"video/mp4\" />")
                        .append("</video>");
            } else if (lowerPath.contains(".mp3")) {
                sb.append("<audio class=\"attachment-audio\" src=\"").append(path).append("\" controls>")
                        .append("Your browser does not support the audio element.")
                        .append("</audio>");
            } else if (lowerPath.contains(".jpg")
                    || lowerPath.contains(".jpeg")
                    || lowerPath.contains(".png")
                    || lowerPath.contains(".gif")
                    || lowerPath.contains(".bmp")) {
                sb.append("<img ")
                        .append("src=\"").append(path).append("\" ")
                        .append("alt=\"附件图片\" ")
                        .append("class=\"attachment-image js-preview-image\" ")
                        .append("data-preview-src=\"").append(path).append("\" ")
                        .append("/>");
            }
        }
        return sb.toString();
    }

    /**
     * 把原始 answerList 转成：
     * [
     *   {"A":"高血压"},
     *   {"B":"增加饮水量"}
     * ]
     */
    private static List<Map<String, String>> buildOptionAnswerList(Object answerListObj) {
        if (!(answerListObj instanceof List)) {
            return Collections.emptyList();
        }

        List<?> rawList = (List<?>) answerListObj;
        List<Map<String, String>> result = new ArrayList<>();

        int index = 0;
        for (Object obj : rawList) {
            if (!(obj instanceof Map)) {
                index++;
                continue;
            }

            Map<?, ?> raw = (Map<?, ?>) obj;
            String optionText = Objects.toString(raw.get("ACONTENT"),"");
            if (StringUtils.isBlank(optionText)) {
                optionText = Objects.toString(raw.get("acontent"),"");
            }

            if (StringUtils.isBlank(optionText)) {
                index++;
                continue;
            }

            String optionKey = null;
            String optionValue = optionText.trim();

            Matcher matcher = OPTION_PATTERN.matcher(optionText.trim());
            if (matcher.matches()) {
                optionKey = matcher.group(1);
                String parsedValue = matcher.group(2);
                if (!StringUtils.isBlank(parsedValue)) {
                    optionValue = parsedValue.trim();
                }
            }

            // 如果拆不出 A/B/C，就按顺序补
            if (StringUtils.isBlank(optionKey)) {
                optionKey = String.valueOf((char) ('A' + index));
            }

            Map<String, String> item = new LinkedHashMap<>();
            item.put(optionKey, optionValue);
            result.add(item);

            index++;
        }

        return result;
    }
}