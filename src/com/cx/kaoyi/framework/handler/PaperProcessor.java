package com.cx.kaoyi.framework.handler;

import com.cx.kaoyi.framework.utils.Image.ImgUtil;
import com.cx.kaoyi.framework.utils.Image.SvgSizeUtil;
import com.cx.kaoyi.framework.utils.Utils;
import com.cx.kaoyi.framework.utils.WebFilePath;
import com.cx.kaoyi.framework.utils.serialize.KryoPoolUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Element;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.*;
import java.net.URL;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PaperProcessor {
    private static final double CONVERSION_FACTOR = 914400d / 96d; //把像素换算成 EMU（1 英寸 = 914 400 EMU；96 DPI 下 1 px ≈ 9525 EMU）
    private static final Pattern DATA_IMAGE_BASE64_PATTERN =
            Pattern.compile("^data:image/([^;]+);base64,(.*)$",
                    Pattern.CASE_INSENSITIVE | Pattern.DOTALL);
    private String tmpDocxPath;
    private boolean isPreview;
    private int questionLabelCount = 23; //图片的rid开头

    public PaperProcessor(String tmpDocxPath, boolean isPreview){
        this.tmpDocxPath = tmpDocxPath;
        this.isPreview = isPreview;
    }

    public Map<String, Object> processPaper(List<Map<String, Object>> questiontypeJson,
                                           List<Map<String, Object>> resJson,
                                           Map<String, Object> examInfo,
                                           boolean showAns) {

        // 初始化数据结构
        List<List<List<Map<String, Object>>>> contentListList = new ArrayList<>();
        List<List<Map<String, Object>>> imgListList = new ArrayList<>();
        List<List<List<Map<String, Object>>>> answerContentListList = new ArrayList<>();
        List<List<Map<String, Object>>> answerImgListList = new ArrayList<>();
        List<Map<String, Object>> allImgList = new ArrayList<>();

        // 处理每个题目
        for (Map<String, Object> question : resJson) {
            // 处理题目内容
            List<List<Map<String, Object>>> contentList = new ArrayList<>();
            List<Map<String, Object>> imgList = new ArrayList<>();
            processString((String) question.get("content"), contentList, imgList,
                         (String) question.get("filepath"), allImgList);
            contentListList.add(contentList);
            imgListList.add(imgList);

            // 处理答案
            // 修正后的答案处理部分
            if ("0".equals(question.get("ismain").toString())) {
                if (showAns) {
                    List<List<Map<String, Object>>> answerContent = new ArrayList<>();
                    List<Map<String, Object>> answerImg = new ArrayList<>();
                    processString((String) question.get("rightAns"), answerContent, answerImg,
                            null, allImgList);
                    answerContentListList.add(answerContent);
                    answerImgListList.add(answerImg);
                } else {
                    // 修正点：将一维结构包装成二维
                    List<Map<String, Object>> answerContent = parseSubSupTags((String) question.get("rightAns"));
                    answerContentListList.add(Collections.singletonList(answerContent));
                    answerImgListList.add(new ArrayList<>());
                }
            } else {
                answerContentListList.add(new ArrayList<>());
                answerImgListList.add(new ArrayList<>());
            }
        }

        // 构建题目结构
        List<Map<String, Object>> myQuestion = buildQuestionStructure(resJson, contentListList,
                imgListList, answerContentListList, answerImgListList);

        // 按题型分类
        List<Map<String, Object>> questionsByQt = new ArrayList<>();
        int examinfoScore = 0;

        for (Map<String, Object> qt : questiontypeJson) {
            String qtName = (String) qt.get("QTNAME");
            if (qtName.length() > 10) ;
            examinfoScore += Double.parseDouble(qt.get("SCORE").toString());

            Map<String, Object> qtMap = new HashMap<>();
            qtMap.put("qtname", qtName);
            qtMap.put("atid", qt.get("ATID"));
            qtMap.put("qcount", qt.get("QCOUNT"));
            qtMap.put("score", qt.get("SCORE"));
            qtMap.put("qtDesc", qt.get("QTDESC"));
            qtMap.put("wrapNum", calculateWrapNum(qtName, qt.get("ATID").toString()));
            qtMap.put("qtypeNum", Utils.int2chineseNum(questionsByQt.size() + 1));

            List<Map<String, Object>> qtQuestions = new ArrayList<>();
            for (Map<String, Object> q : myQuestion) {
                if (q.get("qtype").equals(qt.get("QTID"))) {
                    qtQuestions.add(q);
                }
            }
            qtMap.put("question", qtQuestions);
            questionsByQt.add(qtMap);
        }

        // 构建最终参数
        Map<String, Object> params = new HashMap<>();
        params.put("allImgList", allImgList);
        params.put("examObject", examInfo.get("examObject"));
        params.put("questionsByQt", questionsByQt);
        params.put("etime", examInfo.get("etime"));
        params.put("showAns", showAns);

        Map<String, Object> examInfoMap = new HashMap<>();
        examInfoMap.put("ename", examInfo.get("ENAME"));
        examInfoMap.put("aorb", "0".equals(examInfo.get("AORB").toString()) ? "A" : "B");
        examInfoMap.put("qtypeNum", Utils.int2chineseNum(questionsByQt.size()));
        examInfoMap.put("score", examinfoScore);
        examInfoMap.put("unitName", examInfo.get("UNITNAME"));
        examInfoMap.put("termName", examInfo.get("TERMNAME"));
        examInfoMap.put("termName1", examInfo.get("TERMNAME1"));
        examInfoMap.put("schoolYear", examInfo.get("schoolYear"));
        examInfoMap.put("schoolYear1", examInfo.get("schoolYear1"));
        examInfoMap.put("schoolYear2", examInfo.get("schoolYear2"));
        String testWay = examInfo.get("TESTWAY").toString();
        if("0".equals(testWay)){
            examInfoMap.put("testWay", "闭卷");
        }else if("1".equals(testWay)){
            examInfoMap.put("testWay", "开卷");
        }else {
            examInfoMap.put("testWay", "半开卷");
        }
        params.put("examInfo", examInfoMap);

        return params;
    }

    /**
     * 把 html 片段切成若干 “普通文本段”
     * 每个段 Map 结构：
     *   type    = "normal"
     *   str     = 段内纯文本
     *   scripts = List<Map<String,String>>
     *             每条脚本 map: { type: "sub"/"sup", str: "①" }
     *             保留在原文中出现的先后顺序
     */
    private List<Map<String, Object>> parseSubSupTags(String input) {
        List<Map<String, Object>> result = new ArrayList<>();

        Pattern p = Pattern.compile("(?i)<(sub|sup)[^>]*>([\\s\\S]*?)</\\1>");
        Matcher m  = p.matcher(input);

        int last = 0;
        List<Map<String, String>> pending = new ArrayList<>();  // 累积紧挨在前的上下标

        while (m.find()) {
            // --- 1) 先处理 <sub>/<sup> 之前的普通文本 ---
            if (m.start() > last) {
                String plain = stripHtml(input.substring(last, m.start()));
                if (!plain.isEmpty()) {
                    Map<String, Object> seg = new HashMap<>();
                    seg.put("type", "normal");
                    seg.put("str", stripHtml(plain));
                    if (!pending.isEmpty()) {
                        seg.put("scripts", new ArrayList<>(pending));
                        pending.clear();
                    }
                    result.add(seg);
                }
            }

            // --- 2) 把当前脚本收进 pending ---
            String tag     = m.group(1).toLowerCase();
            String content = stripHtml(m.group(2));
            if (!content.isEmpty()) {
                Map<String, String> script = new HashMap<>();
                script.put("type", tag);      // "sub" or "sup"
                script.put("str",  content);
                pending.add(script);
            }
            last = m.end();
        }

        // --- 3) 处理最后一段普通文本 ---
        if (last < input.length()) {
            String plain = stripHtml(input.substring(last));
            if (!plain.isEmpty()) {
                Map<String, Object> seg = new HashMap<>();
                seg.put("type", "normal");
                seg.put("str", plain);
                if (!pending.isEmpty()) {
                    seg.put("scripts", pending);
                    pending = new ArrayList<>();
                }
                result.add(seg);
            }
        }

        // --- 4) 若文尾只有 pending 脚本（极少见），附加到上一段 ---
        if (!pending.isEmpty() && !result.isEmpty()) {
            Map<String, Object> lastSeg = result.get(result.size() - 1);
            List<Map<String, String>> lst = new ArrayList<>();
            lst.addAll(pending);
            lastSeg.put("afterScripts", lst);
        }
        return result;
    }

    public String stripHtml(String content) {
        if (content == null || content.trim().isEmpty()) {
            return "";
        }
        content = content.replaceAll("\\r\\n|\\r|\\n", "<br>"); //先把所有普通换行符换为br
        content = content
                .replaceAll("(?i)<br\\s*/?>|</br>", "___BR___PLACEHOLDER___")
                .replaceAll("(?i)<p[^>]*>", "___P___START___")
                .replaceAll("(?i)</p>", "___P___END___");

        content = content.replaceAll("<[^>]*>", "");

        content = content
                .replaceAll("&ldquo;", "“")
                .replaceAll("&rdquo;", "”")
                .replaceAll("&acute;", "´")
                .replaceAll("&#8226;","•")
                .replaceAll("&lt;", "<")
                .replaceAll("&gt;", ">")
                .replaceAll("&quot;", "\"")
                .replaceAll("&#47;", "/")
                .replaceAll("&#39;", "'")
                .replaceAll("&#40;", "(")
                .replaceAll("&#41;", ")")
                .replaceAll("&nbsp;", " ")
                .replaceAll("&amp;", "&");

        content = content.replaceAll("\\s{2,}", " ").trim();
        content = content
                .replaceAll("&", "&amp;")      // 注意顺序，必须先转义 '&'
                .replaceAll("<", "&lt;")
                .replaceAll(">", "&gt;")
                .replaceAll("\"", "&quot;")
                .replaceAll("'", "&apos;")
                .replaceAll("/", "&#47;");
        String wrapStr = isPreview?"\n":"<w:br/>";
        content = content
                .replaceAll("___BR___PLACEHOLDER___", wrapStr)
                .replaceAll("___P___START___", "")
                .replaceAll("___P___END___", wrapStr);

        while (content.contains(wrapStr+wrapStr)) {
            content = content.replace(wrapStr+wrapStr, wrapStr);
        }
        while (content.startsWith(wrapStr+wrapStr)) {
            content = content.substring(wrapStr.length());
        }
        while (content.endsWith(wrapStr+wrapStr)) {
            content = content.substring(0, content.length() - wrapStr.length());
        }
        return content;
    }

    private void processString(String input, List<List<Map<String, Object>>> contentList,
                              List<Map<String, Object>> imgList, String filePath,
                              List<Map<String, Object>> allImgList) {
        List<Map<String, Object>> currentContent = new ArrayList<>();
        input = Utils.replaceUnrecognizableChars(input); //去除各种零宽字符或者控制符
        Matcher imgMatcher = Utils.IMG_TAG_SRC_PATTERN.matcher(input);
        int lastIndex = 0;
        boolean firstImg = true;
        while (imgMatcher.find()) {
            int start = imgMatcher.start();
            // ── 处理图片前的文本（或空文本占位） ──
            if (start > lastIndex) { // 中间有真实文本，正常解析
                List<Map<String, Object>> parseRtn = parseSubSupTags(input.substring(lastIndex, start));
                if(firstImg){ //是第一张图片
                    if(parseRtn.isEmpty()){ // 图片就在头，只不过前面还有html字符但没解析出文本，插入一个空的 normal 占位
                        currentContent.add(createTextMap("normal", ""));
                    }
                    firstImg = false;
                }
                currentContent.addAll(parseRtn);
            } else if (lastIndex == 0 && start == 0) { // 图片就在头，插入一个空的 normal 占位
                currentContent.add(createTextMap("normal", ""));
            }
            // 处理图片
            String imgTag  = imgMatcher.group(0);   // 整个 <img ...>
            String imgUrl  = imgMatcher.group(1);   // src 属性
            Element imgEl  = Jsoup.parseBodyFragment(imgTag).selectFirst("img");
            String wAttr = imgEl.attr("width");   // 可能是 ""
            String hAttr = imgEl.attr("height");  // 可能是 ""
            if ((wAttr == null || wAttr.isEmpty()) && imgEl.hasAttr("style")) {
                String style = imgEl.attr("style");
                Matcher m = Pattern.compile("width\\s*:\\s*(\\d+(?:\\.\\d+)?)px", Pattern.CASE_INSENSITIVE).matcher(style);
                if (m.find()) {
                    wAttr = m.group(1);
                }
            }
            if ((hAttr == null || hAttr.isEmpty()) && imgEl.hasAttr("style")) {
                String style = imgEl.attr("style");
                Matcher m = Pattern.compile("height\\s*:\\s*(\\d+(?:\\.\\d+)?)px", Pattern.CASE_INSENSITIVE).matcher(style);
                if (m.find()) {
                    hAttr = m.group(1);
                }
            }
            Map<String, Object> imgInfo = processImage(imgUrl, wAttr, hAttr);
            if (imgInfo != null) {
                imgList.add(imgInfo);
                allImgList.add(createImageMap("image"+questionLabelCount));
                questionLabelCount++;
            }
            lastIndex = imgMatcher.end();
        }
        // 处理剩余文本
        if (lastIndex < input.length()) {
            currentContent.addAll(parseSubSupTags(input.substring(lastIndex)));
        }
        contentList.add(currentContent);

        boolean hasSuccessFilePath = false; //是否成功识别出附件图片
        // 处理附件路径中的图片
        if (filePath != null && filePath.matches("(?i).*\\.(png|jpe?g|svg|bmp|gif)$")) {
            String[] allFilePathImgUrls = filePath.split(",");
            for(String filePathUrl : allFilePathImgUrls){
                if(StringUtils.isBlank(filePathUrl) || !filePathUrl.matches("(?i).*\\.(png|jpe?g|svg|bmp|gif)$")){
                    continue;
                }
                Map<String, Object> fileImg = processImage(filePathUrl.trim(),null,null);
                if (fileImg != null) {
                    imgList.add(fileImg);
                    allImgList.add(createImageMap("image"+questionLabelCount));
                    questionLabelCount++;
                    hasSuccessFilePath = true;
                }
            }
        }

        String wrapStr = isPreview?"\n":"<w:br/>";
        if(hasSuccessFilePath && !currentContent.isEmpty()){ //如果有附件，要给最后的文字元素最后一个字符加一个换行让图片在下一行
            Map<String,Object> lastContent = currentContent.get(currentContent.size()-1);
            lastContent.put("lastWrap", wrapStr);
        }
    }

    private Map<String, Object> processImage(String imgUrl, String wAttr, String hAttr) {
        try {
            byte[] imageBytes;
            BufferedImage image;

            if (ImgUtil.isSvg(imgUrl)) {
                double reqW = parseSize(wAttr,0);
                double reqH = parseSize(hAttr,0);

                byte[] svgBytes;
                Matcher m = DATA_IMAGE_BASE64_PATTERN.matcher(imgUrl.trim());
                if (m.matches()) {
                    String base64 = m.group(2).replaceAll("\\s+", "");
                    svgBytes = Base64.getDecoder().decode(base64);
                }else if (imgUrl.startsWith("http://") || imgUrl.startsWith("https://")) {
                    try (InputStream in = new URL(imgUrl).openStream()) {
                        svgBytes = IOUtils.toByteArray(in);
                    }
                } else {
                    String fullPath = Paths.get(WebFilePath.getRealPath(), imgUrl).toString();
                    try (InputStream in = new FileInputStream(fullPath)) {
                        svgBytes = IOUtils.toByteArray(in);
                    }
                }

                SvgSizeUtil.SvgSize svgSize;
                try (InputStream sizeIn = new ByteArrayInputStream(svgBytes)) {
                    svgSize = SvgSizeUtil.readSvgSize(sizeIn);
                }

                Double targetW = reqW;
                Double targetH = reqH;

                if (svgSize != null && svgSize.valid()) {
                    double ratio = svgSize.ratio();

                    if ((targetW == null || targetW <= 0) && (targetH == null || targetH <= 0)) {
                        targetW = (double) Math.round(svgSize.widthPx);
                        targetH = (double) Math.round(svgSize.heightPx);
                    } else if ((targetW == null || targetW <= 0) && targetH != null && targetH > 0) {
                        targetW = (double) Math.round(targetH * ratio);
                    } else if ((targetH == null || targetH <= 0) && targetW != null && targetW > 0) {
                        targetH = (double) Math.round(targetW / ratio);
                    }
                }

                // 最后兜底：实在推不出来，再给默认值，但也尽量成对给
                if ((targetW == null || targetW <= 0) && (targetH == null || targetH <= 0)) {
                    targetW = 200d;
                    targetH = 200d;
                }

                Float dpi = 96f;
                boolean whiteBg = true;

                try (InputStream renderIn = new ByteArrayInputStream(svgBytes)) {
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    ImgUtil.svgStreamToPng(renderIn, baos, targetW, targetH, dpi, whiteBg);
                    imageBytes = baos.toByteArray();
                }

                image = ImageIO.read(new ByteArrayInputStream(imageBytes));
            } else {
                // 原逻辑不动
                if (imgUrl.startsWith("http://") || imgUrl.startsWith("https://")) {
                    image = ImageIO.read(new URL(imgUrl));
                } else {
                    String fullPath = Paths.get(WebFilePath.getRealPath(), imgUrl).toString();
                    image = ImageIO.read(new File(fullPath));
                }
                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                ImageIO.write(image, "png", baos);
                imageBytes = baos.toByteArray();
            }

            String fileName = "image" + (questionLabelCount - 22) + ".png";
            File outputFile = new File(tmpDocxPath, "word/media/" + fileName);
            if (!outputFile.getParentFile().exists()) {
                outputFile.getParentFile().mkdirs();
            }
            try (FileOutputStream fos = new FileOutputStream(outputFile)) {
                fos.write(imageBytes);
            }

            double width = parseSize(wAttr, image.getWidth());
            double height = parseSize(hAttr, image.getHeight());

            long rawWidthEmu  = Math.round(width  * CONVERSION_FACTOR);
            long rawHeightEmu = Math.round(height * CONVERSION_FACTOR);

            double scale = Math.min(1.0,
                    Math.min((double) 4700000 / rawWidthEmu, (double) 4900000 / rawHeightEmu));

            Map<String, Object> imgMap = new HashMap<>();
            imgMap.put("questionLabel", questionLabelCount);
            imgMap.put("width",  String.valueOf(Math.round(rawWidthEmu  * scale)));
            imgMap.put("height", String.valueOf(Math.round(rawHeightEmu * scale)));
            return imgMap;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }


    private Map<String, Object> createTextMap(String type, String text) {
        Map<String, Object> map = new HashMap<>();
        map.put("type", type);
        map.put("str", text);
        return map;
    }

    private Map<String, Object> createImageMap(String base64) {
        Map<String, Object> map = new HashMap<>();
        map.put("base64", base64);
        map.put("questionLabel", questionLabelCount);
        return map;
    }

    private int calculateWrapNum(String qtname, String atid) {
        int answerType = Integer.parseInt(atid);
        if (answerType <=5 || answerType ==8 || answerType ==9 || answerType ==10 ||
            "填空题".equals(qtname)) {
            return 0;
        } else if (answerType ==6 || answerType ==7 || answerType ==11) {
            if (qtname != null && (qtname.contains("简答") || qtname.contains("分析") ||
                qtname.contains("论述") || qtname.contains("作文"))) {
                return 12;
            }
            return 4;
        }
        return 1;
    }

    private List<Map<String, Object>> buildQuestionStructure(List<Map<String, Object>> resJson,
                                                            List<List<List<Map<String, Object>>>> contentListList,
                                                            List<List<Map<String, Object>>> imgListList,
                                                            List<List<List<Map<String, Object>>>> answerContentListList,
                                                            List<List<Map<String, Object>>> answerImgListList) {
        List<Map<String, Object>> resClone = KryoPoolUtils.deepCopy(resJson);
        List<Map<String, Object>> myQuestion = new ArrayList<>();

        // 第一遍处理：构建主问题结构
        for (int i = 0; i < resClone.size(); i++) {
            Map<String, Object> question = resClone.get(i);
            int iscon = Integer.parseInt(question.get("iscon").toString());
            int ismain = Integer.parseInt(question.get("ismain").toString());

            if (iscon == 1 && ismain == 1) {
                Map<String, Object> mainQuestion = new HashMap<>();
                // 初始化主问题属性
                mainQuestion.put("th", question.get("th"));
                mainQuestion.put("qtype", question.get("qtype"));
                mainQuestion.put("iscon", iscon);
                mainQuestion.put("ismain", ismain);
                mainQuestion.put("atid", question.get("atid"));
                mainQuestion.put("content", contentListList.get(i));
                mainQuestion.put("imgList", imgListList.get(i));
                mainQuestion.put("questionList", new ArrayList<Map<String, Object>>());

                // 第二遍处理：收集子问题
                for (int j = 0; j < resClone.size(); j++) {
                    Map<String, Object> subQuestion = resClone.get(j);
                    Object mqid = subQuestion.get("mqid");
                    Object mainQid = question.get("qid");

                    if (mqid != null && mqid.toString().equals(mainQid.toString())){
                        // 更新主问题th为最小题号
                        int mainTh = Integer.parseInt(mainQuestion.get("th").toString());
                        int subTh = Integer.parseInt(subQuestion.get("th").toString());
                        if (subTh < mainTh) {
                            mainQuestion.put("th", subTh);
                        }

                        // 构建子问题结构
                        Map<String, Object> subQMap = new HashMap<>();
                        subQMap.put("th", subQuestion.get("th"));
                        subQMap.put("iscon", subQuestion.get("iscon"));
                        subQMap.put("ismain", subQuestion.get("ismain"));
                        subQMap.put("atid", subQuestion.get("atid"));
                        subQMap.put("score", subQuestion.get("score"));
                        subQMap.put("content", contentListList.get(j));
                        subQMap.put("imgList", imgListList.get(j));
                        subQMap.put("rightAns", answerContentListList.get(j));
                        subQMap.put("answerImgList", answerImgListList.get(j));

                        ((List<Map<String, Object>>) mainQuestion.get("questionList")).add(subQMap);
                    }
                }

                myQuestion.add(mainQuestion);
            } else if (iscon == 0) { // 非组合题
                Map<String, Object> singleQuestion = new HashMap<>();
                singleQuestion.put("th", question.get("th"));
                singleQuestion.put("iscon", iscon);
                singleQuestion.put("ismain", ismain);
                singleQuestion.put("qtype", question.get("qtype"));
                singleQuestion.put("atid", question.get("atid"));
                singleQuestion.put("score", question.get("score"));
                singleQuestion.put("content", contentListList.get(i));
                singleQuestion.put("imgList", imgListList.get(i));
                singleQuestion.put("rightAns", answerContentListList.get(i));
                singleQuestion.put("answerImgList", answerImgListList.get(i));

                myQuestion.add(singleQuestion);
            }
        }
        return myQuestion;
    }

    private double parseSize(String val, double defaultValue) {
        if (val == null || val.trim().isEmpty()) {
            return defaultValue;
        }
        try {
            return Double.parseDouble(val.trim());
        } catch (Exception e) {
            return defaultValue;
        }
    }
}