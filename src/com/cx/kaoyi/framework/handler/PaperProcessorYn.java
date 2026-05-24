package com.cx.kaoyi.framework.handler;

import com.cx.kaoyi.framework.utils.Image.ImgUtil;
import com.cx.kaoyi.framework.utils.Image.SvgSizeUtil;
import com.cx.kaoyi.framework.utils.Utils;
import com.cx.kaoyi.framework.utils.WebFilePath;
import com.cx.kaoyi.framework.utils.serialize.KryoPoolUtils;
import org.apache.commons.io.IOUtils;
import org.apache.commons.lang3.StringUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Node;
import org.jsoup.nodes.TextNode;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.net.URL;
import java.nio.file.Paths;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;


public class PaperProcessorYn {
    private static final double CONVERSION_FACTOR = 914400d / 96d; // 1px -> EMU

    private static final String WORD_FONT_ASCII = "宋体";
    private static final String WORD_FONT_EAST_ASIA = "宋体";
    private static final String WORD_FONT_HINT = "eastAsia";
    private static final String WORD_FONT_SIZE = "24"; // 与你当前模板正文一致

    private String tmpDocxPath;
    private boolean isPreview;
    private int questionLabelCount = 23; // 图片 rId 起始

    private static final Pattern DATA_IMAGE_BASE64_PATTERN =
            Pattern.compile("^data:image/([^;]+);base64,(.*)$",
                    Pattern.CASE_INSENSITIVE | Pattern.DOTALL);

    public PaperProcessorYn(String tmpDocxPath, boolean isPreview) {
        this.tmpDocxPath = tmpDocxPath;
        this.isPreview = isPreview;
    }

    public Map<String, Object> processPaper(List<Map<String, Object>> questiontypeJson,
                                            List<Map<String, Object>> resJson,
                                            Map<String, Object> examInfo,
                                            boolean showAns) {

        List<List<List<Map<String, Object>>>> contentListList = new ArrayList<>();
        List<List<Map<String, Object>>> imgListList = new ArrayList<>();
        List<List<List<Map<String, Object>>>> answerContentListList = new ArrayList<>();
        List<List<Map<String, Object>>> answerImgListList = new ArrayList<>();
        List<Map<String, Object>> allImgList = new ArrayList<>();

        for (Map<String, Object> question : resJson) {
            List<List<Map<String, Object>>> contentList = new ArrayList<>();
            List<Map<String, Object>> imgList = new ArrayList<>();
            processString((String) question.get("content"), contentList, imgList,
                    (String) question.get("filepath"), allImgList);
            contentListList.add(contentList);
            imgListList.add(imgList);

            if ("0".equals(String.valueOf(question.get("ismain")))) {
                if (showAns) {
                    List<List<Map<String, Object>>> answerContent = new ArrayList<>();
                    List<Map<String, Object>> answerImg = new ArrayList<>();
                    processString((String) question.get("rightAns"), answerContent, answerImg,
                            null, allImgList);
                    answerContentListList.add(answerContent);
                    answerImgListList.add(answerImg);
                } else {
                    answerContentListList.add(Collections.singletonList(new ArrayList<>()));
                    answerImgListList.add(new ArrayList<>());
                }
            } else {
                answerContentListList.add(new ArrayList<>());
                answerImgListList.add(new ArrayList<>());
            }
        }

        List<Map<String, Object>> myQuestion = buildQuestionStructure(
                resJson, contentListList, imgListList, answerContentListList, answerImgListList
        );

        List<Map<String, Object>> questionsByQt = new ArrayList<>();
        int examinfoScore = 0;

        for (Map<String, Object> qt : questiontypeJson) {
            String qtName = (String) qt.get("QTNAME");
            examinfoScore += Double.parseDouble(qt.get("SCORE").toString());

            Map<String, Object> qtMap = new HashMap<>();
            qtMap.put("qtname", qtName);
            qtMap.put("atid", qt.get("ATID"));
            qtMap.put("qcount", qt.get("QCOUNT"));
            qtMap.put("score", qt.get("SCORE"));
            String qtdesc = Optional.ofNullable(Objects.toString(qt.get("QTDESC"), "").replaceAll("&nbsp;",""))
                    .filter(s -> !s.isEmpty())
                    .map(s -> {
                        String t = s.replaceFirst("\\p{P}+$", "");
                        if (t.isEmpty()) return "";
                        char c = t.charAt(t.length() - 1);
                        return t + (String.valueOf(c).matches("[A-Za-z]") ? "," : "，");
                    })
                    .orElse("");
            qtMap.put("qtDesc", qtdesc);
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

        Map<String, Object> params = new HashMap<>();
        params.put("allImgList", allImgList);
        params.put("examObject", examInfo.get("examObject"));
        params.put("questionsByQt", questionsByQt);
        params.put("etime", examInfo.get("etime"));
        params.put("showAns", showAns);

        Map<String, Object> examInfoMap = new HashMap<>();
        examInfoMap.put("ename", examInfo.get("ENAME"));
        examInfoMap.put("aorb", "0".equals(String.valueOf(examInfo.get("AORB"))) ? "A" : "B");
        examInfoMap.put("qtypeNum", Utils.int2chineseNum(questionsByQt.size()));
        examInfoMap.put("score", examinfoScore);
        examInfoMap.put("unitName", examInfo.get("UNITNAME"));
        examInfoMap.put("termName", examInfo.get("TERMNAME"));
        examInfoMap.put("termName1", examInfo.get("TERMNAME1"));
        examInfoMap.put("schoolYear", examInfo.get("schoolYear"));
        examInfoMap.put("schoolYear1", examInfo.get("schoolYear1"));
        examInfoMap.put("schoolYear2", examInfo.get("schoolYear2"));

        String testWay = String.valueOf(examInfo.get("TESTWAY"));
        if ("0".equals(testWay)) {
            examInfoMap.put("testWay", "闭卷");
        } else if ("1".equals(testWay)) {
            examInfoMap.put("testWay", "开卷");
        } else {
            examInfoMap.put("testWay", "半开卷");
        }
        params.put("examInfo", examInfoMap);

        return params;
    }

    /**
     * 处理正文 / 答案字符串：
     * 1. 用 Jsoup 递归解析 HTML
     * 2. 生成“与图片槽位对齐”的 segment 列表
     * 3. 每个 segment 直接提供可写入 FTL 的 WordML
     */
    private void processString(String input,
                               List<List<Map<String, Object>>> contentList,
                               List<Map<String, Object>> imgList,
                               String filePath,
                               List<Map<String, Object>> allImgList) {
        List<Map<String, Object>> currentContent = new ArrayList<>();

        String html = normalizeHtml(input);
        FlowContext ctx = new FlowContext(currentContent, imgList, allImgList);

        if (StringUtils.isNotBlank(html)) {
            Document doc = Jsoup.parseBodyFragment(html);
            for (Node node : doc.body().childNodes()) {
                walkHtml(node, HtmlStyle.root(), ctx);
            }
            ctx.flushCurrentRuns(false);
        }

        boolean hasSuccessFilePath = false;
        if (filePath != null && filePath.matches("(?i).*\\.(png|jpe?g|svg|bmp|gif)$")) {
            String[] allFilePathImgUrls = filePath.split(",");
            for (String filePathUrl : allFilePathImgUrls) {
                if (StringUtils.isBlank(filePathUrl) || !filePathUrl.matches("(?i).*\\.(png|jpe?g|svg|bmp|gif)$")) {
                    continue;
                }
                ctx.addImageFromPath(filePathUrl.trim(), null, null);
                hasSuccessFilePath = true;
            }
        }

        if (hasSuccessFilePath && !currentContent.isEmpty()) {
            Map<String, Object> lastContent = currentContent.get(currentContent.size() - 1);
            String oldWordml = (String) lastContent.getOrDefault("wordml", "");
            lastContent.put("wordml", oldWordml + buildBreakWordMl());
            lastContent.put("lastWrap", isPreview ? "\n" : "<w:br/>");
        }

        contentList.add(currentContent);
    }

    /** 统一把原始字符串规整成 HTML 片段，交给 Jsoup。 */
    private String normalizeHtml(String input) {
        if (StringUtils.isBlank(input)) {
            return "";
        }
        String html = Utils.replaceUnrecognizableChars(input);
        html = html.replace("\r\n", "\n").replace("\r", "\n");
        // 把文本里的普通换行提升为 <br/>，交给 Jsoup 处理
        html = html.replace("\n", "<br/>");
        // 兼容有些历史内容里塞入了 WordML 换行标签
        html = html.replaceAll("(?i)<w:br\\s*/>", "<br/>");
        return html;
    }

    /** 递归遍历 HTML DOM，生成文本 run 与图片槽位。 */
    private void walkHtml(Node node, HtmlStyle currentStyle, FlowContext ctx) {
        if (node == null) {
            return;
        }

        if (node instanceof TextNode) {
            String txt = ((TextNode) node).getWholeText();
            if (txt != null && !txt.isEmpty()) {
                // 这里不要提前把 \u00A0 统一改成普通空格。
                // 对 <u>&nbsp;&nbsp;&nbsp;</u> 这类仅空白填空，后面会转成真正可见的下划线字符。
                ctx.addText(txt, currentStyle);
            }
            return;
        }

        if (!(node instanceof Element)) {
            return;
        }

        Element el = (Element) node;
        String tag = el.tagName().toLowerCase(Locale.ROOT);

        if ("img".equals(tag)) {
            String imgUrl = el.attr("src");
            String wAttr = resolveImgSize(el, "width");
            String hAttr = resolveImgSize(el, "height");
            ctx.addImageFromPath(imgUrl, wAttr, hAttr);
            return;
        }

        if ("br".equals(tag)) {
            ctx.addBreak();
            return;
        }

        HtmlStyle nextStyle = currentStyle.copy();
        applyTagStyle(tag, el, nextStyle);
        applyInlineStyle(el.attr("style"), nextStyle);

        for (Node child : el.childNodes()) {
            walkHtml(child, nextStyle, ctx);
        }

        if (isBlockTag(tag)) {
            ctx.addBreakIfNeeded();
        }
    }

    private boolean isBlockTag(String tag) {
        return "p".equals(tag)
                || "div".equals(tag)
                || "section".equals(tag)
                || "article".equals(tag)
                || "li".equals(tag)
                || "ul".equals(tag)
                || "ol".equals(tag)
                || "blockquote".equals(tag)
                || "table".equals(tag)
                || "tr".equals(tag)
                || "td".equals(tag);
    }

    private void applyTagStyle(String tag, Element el, HtmlStyle style) {
        switch (tag) {
            case "b":
            case "strong":
                style.bold = true;
                break;
            case "i":
            case "em":
                style.italic = true;
                break;
            case "u":
            case "ins":
                style.underline = true;
                break;
            case "s":
            case "strike":
            case "del":
                style.strike = true;
                break;
            case "sub":
                style.vertAlign = "subscript";
                break;
            case "sup":
                style.vertAlign = "superscript";
                break;
            default:
                break;
        }

        String valign = el.attr("valign");
        if ("sub".equalsIgnoreCase(valign) || "subscript".equalsIgnoreCase(valign)) {
            style.vertAlign = "subscript";
        } else if ("sup".equalsIgnoreCase(valign) || "super".equalsIgnoreCase(valign)
                || "superscript".equalsIgnoreCase(valign)) {
            style.vertAlign = "superscript";
        }
    }

    /**
     * 兼容 style="font-weight:bold; text-decoration:underline; vertical-align:super;" 这种写法。
     */
    private void applyInlineStyle(String styleText, HtmlStyle style) {
        if (StringUtils.isBlank(styleText)) {
            return;
        }
        String lower = styleText.toLowerCase(Locale.ROOT);

        if (lower.contains("font-weight:bold") || lower.contains("font-weight: bold")
                || lower.matches(".*font-weight\\s*:\\s*[5-9]00.*")) {
            style.bold = true;
        }
        if (lower.contains("font-style:italic") || lower.contains("font-style: italic")) {
            style.italic = true;
        }
        if (lower.contains("text-decoration:underline") || lower.contains("text-decoration: underline")
                || lower.contains("text-decoration-line:underline") || lower.contains("text-decoration-line: underline")) {
            style.underline = true;
        }
        if (lower.contains("line-through")) {
            style.strike = true;
        }
        if (lower.contains("vertical-align:super") || lower.contains("vertical-align: super")
                || lower.contains("vertical-align:sup") || lower.contains("vertical-align: sup")
                || lower.contains("vertical-align:superscript") || lower.contains("vertical-align: superscript")) {
            style.vertAlign = "superscript";
        }
        if (lower.contains("vertical-align:sub") || lower.contains("vertical-align: sub")
                || lower.contains("vertical-align:subscript") || lower.contains("vertical-align: subscript")) {
            style.vertAlign = "subscript";
        }
    }

    private String resolveImgSize(Element imgEl, String attrName) {
        String val = imgEl.attr(attrName);
        if (StringUtils.isNotBlank(val)) {
            val = val.trim().replace("px", "");
            return val;
        }
        String style = imgEl.attr("style");
        if (StringUtils.isNotBlank(style)) {
            Matcher m = Pattern.compile(attrName + "\\s*:\\s*(\\d+(?:\\.\\d+)?)px", Pattern.CASE_INSENSITIVE).matcher(style);
            if (m.find()) {
                return m.group(1);
            }
        }
        return null;
    }

    private Map<String, Object> processImage(String imgUrl, String wAttr, String hAttr) {
        try {
            if (StringUtils.isBlank(imgUrl)) {
                return null;
            }

            imgUrl = imgUrl.trim();

            byte[] imageBytes;
            BufferedImage image;

            boolean base64Svg = isBase64Svg(imgUrl);
            boolean isSvg = base64Svg || ImgUtil.isSvg(imgUrl);

            // Word 里最终显示用的尺寸，注意：这个尺寸不能被 3 倍放大影响
            double displayWidth = 0d;
            double displayHeight = 0d;

            if (isSvg) {
                double reqW = parseSize(wAttr, 0);
                double reqH = parseSize(hAttr, 0);

                byte[] svgBytes = readImageSourceBytes(imgUrl);

                SvgSizeUtil.SvgSize svgSize;
                try (InputStream sizeIn = new ByteArrayInputStream(svgBytes)) {
                    svgSize = SvgSizeUtil.readSvgSize(sizeIn);
                }

                Double targetW = reqW > 0 ? reqW : null;
                Double targetH = reqH > 0 ? reqH : null;

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

                // 如果 SVG 本身也读不到尺寸，兜底
                if ((targetW == null || targetW <= 0) && (targetH == null || targetH <= 0)) {
                    targetW = 200d;
                    targetH = 200d;
                } else if (targetW == null || targetW <= 0) {
                    targetW = targetH;
                } else if (targetH == null || targetH <= 0) {
                    targetH = targetW;
                }

                // 这是 Word 里的显示尺寸，保持原始目标尺寸，不乘 3
                displayWidth = targetW;
                displayHeight = targetH;

                // 只有 base64 SVG 转 PNG 时提高栅格化分辨率
                double rasterScale = base64Svg ? 3d : 1d;

                double renderWidth = displayWidth * rasterScale;
                double renderHeight = displayHeight * rasterScale;

                Float dpi = 96f;
                boolean whiteBg = true;

                try (InputStream renderIn = new ByteArrayInputStream(svgBytes)) {
                    ByteArrayOutputStream baos = new ByteArrayOutputStream();
                    ImgUtil.svgStreamToPng(renderIn, baos, renderWidth, renderHeight, dpi, whiteBg);
                    imageBytes = baos.toByteArray();
                }

                image = ImageIO.read(new ByteArrayInputStream(imageBytes));
            } else {
                byte[] sourceBytes = readImageSourceBytes(imgUrl);

                image = ImageIO.read(new ByteArrayInputStream(sourceBytes));
                if (image == null) {
                    throw new IllegalArgumentException("无法识别图片格式：" + imgUrl);
                }

                ByteArrayOutputStream baos = new ByteArrayOutputStream();
                ImageIO.write(image, "png", baos);
                imageBytes = baos.toByteArray();

                // 普通图片仍然按原逻辑：有 width/height 属性用属性，否则用图片自身尺寸
                displayWidth = parseSize(wAttr, image.getWidth());
                displayHeight = parseSize(hAttr, image.getHeight());
            }

            if (image == null) {
                throw new IllegalArgumentException("图片读取失败：" + imgUrl);
            }

            String fileName = "image" + (questionLabelCount - 22) + ".png";
            File outputFile = new File(tmpDocxPath, "word/media/" + fileName);
            if (!outputFile.getParentFile().exists()) {
                outputFile.getParentFile().mkdirs();
            }

            try (FileOutputStream fos = new FileOutputStream(outputFile)) {
                fos.write(imageBytes);
            }

            // 这里必须用 displayWidth / displayHeight，不能用 image.getWidth() / image.getHeight()
            // 因为 base64 SVG 的 image 实际像素已经被放大了 3 倍
            double width = displayWidth > 0 ? displayWidth : image.getWidth();
            double height = displayHeight > 0 ? displayHeight : image.getHeight();

            long rawWidthEmu = Math.round(width * CONVERSION_FACTOR);
            long rawHeightEmu = Math.round(height * CONVERSION_FACTOR);

            double scale = Math.min(1.0,
                    Math.min((double) 4700000 / rawWidthEmu, (double) 4900000 / rawHeightEmu));

            Map<String, Object> imgMap = new HashMap<>();
            imgMap.put("questionLabel", questionLabelCount);
            imgMap.put("width", String.valueOf(Math.round(rawWidthEmu * scale)));
            imgMap.put("height", String.valueOf(Math.round(rawHeightEmu * scale)));
            return imgMap;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    private Map<String, Object> createImageMap(String base64) {
        Map<String, Object> map = new HashMap<>();
        map.put("base64", base64);
        map.put("questionLabel", questionLabelCount);
        return map;
    }

    private int calculateWrapNum(String qtname, String atid) {
        int answerType = Integer.parseInt(atid);
        if (answerType <= 5 || answerType == 8 || answerType == 9 || answerType == 10
                || "填空题".equals(qtname)) {
            return 0;
        } else if (answerType == 6 || answerType == 7 || answerType == 11) {
            if (qtname != null && (qtname.contains("简答") || qtname.contains("分析")
                    || qtname.contains("论述") || qtname.contains("作文"))) {
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

        for (int i = 0; i < resClone.size(); i++) {
            Map<String, Object> question = resClone.get(i);
            int iscon = Integer.parseInt(String.valueOf(question.get("iscon")));
            int ismain = Integer.parseInt(String.valueOf(question.get("ismain")));

            if (iscon == 1 && ismain == 1) {
                Map<String, Object> mainQuestion = new HashMap<>();
                mainQuestion.put("th", question.get("th"));
                mainQuestion.put("qtype", question.get("qtype"));
                mainQuestion.put("iscon", iscon);
                mainQuestion.put("ismain", ismain);
                mainQuestion.put("atid", question.get("atid"));
                mainQuestion.put("content", contentListList.get(i));
                mainQuestion.put("imgList", imgListList.get(i));
                mainQuestion.put("questionList", new ArrayList<Map<String, Object>>());

                for (int j = 0; j < resClone.size(); j++) {
                    Map<String, Object> subQuestion = resClone.get(j);
                    Object mqid = subQuestion.get("mqid");
                    Object mainQid = question.get("qid");

                    if (mqid != null && mainQid != null && mqid.toString().equals(mainQid.toString())) {
                        int mainTh = Integer.parseInt(String.valueOf(mainQuestion.get("th")));
                        int subTh = Integer.parseInt(String.valueOf(subQuestion.get("th")));
                        if (subTh < mainTh) {
                            mainQuestion.put("th", subTh);
                        }

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
            } else if (iscon == 0) {
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

    private boolean isBase64ImageSrc(String src) {
        if (StringUtils.isBlank(src)) {
            return false;
        }
        return DATA_IMAGE_BASE64_PATTERN.matcher(src.trim()).matches();
    }

    private boolean isBase64Svg(String src) {
        if (StringUtils.isBlank(src)) {
            return false;
        }

        Matcher m = DATA_IMAGE_BASE64_PATTERN.matcher(src.trim());
        if (!m.matches()) {
            return false;
        }

        String mimeSubType = m.group(1).toLowerCase(Locale.ROOT);
        return mimeSubType.contains("svg");
    }

    private byte[] decodeBase64Image(String src) {
        Matcher m = DATA_IMAGE_BASE64_PATTERN.matcher(src.trim());
        if (!m.matches()) {
            throw new IllegalArgumentException("非法的 base64 图片 src");
        }

        String base64 = m.group(2).replaceAll("\\s+", "");
        return Base64.getDecoder().decode(base64);
    }

    private byte[] readImageSourceBytes(String imgUrl) throws Exception {
        if (isBase64ImageSrc(imgUrl)) {
            return decodeBase64Image(imgUrl);
        }

        if (imgUrl.startsWith("http://") || imgUrl.startsWith("https://")) {
            try (InputStream in = new URL(imgUrl).openStream()) {
                return IOUtils.toByteArray(in);
            }
        }

        String fullPath = Paths.get(WebFilePath.getRealPath(), imgUrl).toString();
        try (InputStream in = new FileInputStream(fullPath)) {
            return IOUtils.toByteArray(in);
        }
    }

    // =========================
    // WordML 构造与运行时辅助
    // =========================

    private Map<String, Object> createSegmentFromRuns(List<RunInfo> runs) {
        Map<String, Object> map = new HashMap<>();
        map.put("type", "wordml");
        map.put("str", buildPlainText(runs));
        map.put("wordml", buildWordMl(runs));
        return map;
    }

    private Map<String, Object> createEmptySegment() {
        Map<String, Object> map = new HashMap<>();
        map.put("type", "wordml");
        map.put("str", "");
        map.put("wordml", "");
        return map;
    }

    private String buildPlainText(List<RunInfo> runs) {
        StringBuilder sb = new StringBuilder();
        for (RunInfo run : runs) {
            if (run.breakLine) {
                sb.append(isPreview ? "\n" : "");
            } else {
                sb.append(normalizeRunTextForWord(run));
            }
        }
        return sb.toString();
    }

    private String buildBreakWordMl() {
        return "<w:r><w:br/></w:r>";
    }

    private String buildWordMl(List<RunInfo> runs) {
        if (runs == null || runs.isEmpty()) {
            return "";
        }
        StringBuilder sb = new StringBuilder();
        for (RunInfo run : runs) {
            if (run.breakLine) {
                sb.append(buildBreakWordMl());
                continue;
            }

            String wordText = normalizeRunTextForWord(run);
            if (wordText == null || wordText.isEmpty()) {
                continue;
            }

            boolean underlineForWord = run.underline && !shouldRenderAsLiteralUnderline(run);

            sb.append("<w:r>");
            sb.append("<w:rPr>");
            sb.append("<w:rFonts w:ascii=\"").append(WORD_FONT_ASCII)
                    .append("\" w:hAnsi=\"").append(WORD_FONT_ASCII)
                    .append("\" w:eastAsia=\"").append(WORD_FONT_EAST_ASIA)
                    .append("\" w:hint=\"").append(WORD_FONT_HINT).append("\"/>");
            sb.append("<w:sz w:val=\"").append(WORD_FONT_SIZE).append("\"/>");
            sb.append("<w:szCs w:val=\"").append(WORD_FONT_SIZE).append("\"/>");
            if (run.bold) {
                sb.append("<w:b/>");
            }
            if (run.italic) {
                sb.append("<w:i/>");
            }
            if (underlineForWord) {
                sb.append("<w:u w:val=\"single\"/>");
            }
            if (run.strike) {
                sb.append("<w:strike/>");
            }
            if (StringUtils.isNotBlank(run.vertAlign) && !"baseline".equals(run.vertAlign)) {
                sb.append("<w:vertAlign w:val=\"").append(run.vertAlign).append("\"/>");
            }
            sb.append("</w:rPr>");
            sb.append("<w:t xml:space=\"preserve\">")
                    .append(escapeXml(wordText))
                    .append("</w:t>");
            sb.append("</w:r>");
        }
        return sb.toString();
    }

    /**
     * Word 对“只有空格的下划线 run”显示不稳定。
     * 对 <u>&nbsp;&nbsp;&nbsp;</u> 这类纯空白填空，直接渲染成真正可见的下划线字符。
     */
    private String normalizeRunTextForWord(RunInfo run) {
        if (run == null || run.text == null) {
            return "";
        }

        if (shouldRenderAsLiteralUnderline(run)) {
            return repeatUnderline(run.text);
        }

        return run.text.replace('\u00A0', ' ');
    }

    private boolean shouldRenderAsLiteralUnderline(RunInfo run) {
        if (run == null || !run.underline || run.text == null || run.text.isEmpty()) {
            return false;
        }
        return isAllBlank(run.text);
    }

    private boolean isAllBlank(String text) {
        if (text == null || text.isEmpty()) {
            return false;
        }
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            if (!Character.isWhitespace(c) && c != '\u00A0') {
                return false;
            }
        }
        return true;
    }

    private String repeatUnderline(String blankText) {
        int count = 0;
        for (int i = 0; i < blankText.length(); i++) {
            char c = blankText.charAt(i);
            if (Character.isWhitespace(c) || c == '\u00A0') {
                count++;
            }
        }
        if (count <= 0) {
            count = 6;
        }
        StringBuilder sb = new StringBuilder(count);
        for (int i = 0; i < count; i++) {
            sb.append('_');
        }
        return sb.toString();
    }

    private String escapeXml(String text) {
        if (text == null || text.isEmpty()) {
            return "";
        }
        StringBuilder sb = new StringBuilder(text.length() + 16);
        for (int i = 0; i < text.length(); i++) {
            char c = text.charAt(i);
            switch (c) {
                case '&':
                    sb.append("&amp;");
                    break;
                case '<':
                    sb.append("&lt;");
                    break;
                case '>':
                    sb.append("&gt;");
                    break;
                case '"':
                    sb.append("&quot;");
                    break;
                case '\'':
                    sb.append("&apos;");
                    break;
                default:
                    // 过滤掉 Word XML 容易出问题的控制字符，但保留制表与换行语义（换行已单独变 br）
                    if (c == 0x9 || c >= 0x20) {
                        sb.append(c);
                    }
                    break;
            }
        }
        return sb.toString();
    }

    // =========================
    // 内部状态对象
    // =========================

    private class FlowContext {
        private final List<Map<String, Object>> contentBlocks;
        private final List<Map<String, Object>> imgList;
        private final List<Map<String, Object>> allImgList;
        private final List<RunInfo> currentRuns = new ArrayList<>();

        private FlowContext(List<Map<String, Object>> contentBlocks,
                            List<Map<String, Object>> imgList,
                            List<Map<String, Object>> allImgList) {
            this.contentBlocks = contentBlocks;
            this.imgList = imgList;
            this.allImgList = allImgList;
        }

        private void addText(String text, HtmlStyle style) {
            if (text == null || text.isEmpty()) {
                return;
            }
            RunInfo run = new RunInfo();
            run.text = text;
            run.bold = style.bold;
            run.italic = style.italic;
            run.underline = style.underline;
            run.strike = style.strike;
            run.vertAlign = style.vertAlign;
            currentRuns.add(run);
        }

        private void addBreak() {
            RunInfo run = new RunInfo();
            run.breakLine = true;
            currentRuns.add(run);
        }

        private void addBreakIfNeeded() {
            if (currentRuns.isEmpty()) {
                return;
            }
            RunInfo last = currentRuns.get(currentRuns.size() - 1);
            if (!last.breakLine) {
                addBreak();
            }
        }

        private void flushCurrentRuns(boolean forceEmpty) {
            if (currentRuns.isEmpty()) {
                if (forceEmpty) {
                    contentBlocks.add(createEmptySegment());
                }
                return;
            }
            contentBlocks.add(createSegmentFromRuns(new ArrayList<>(currentRuns)));
            currentRuns.clear();
        }

        private void addImageFromPath(String imgUrl, String wAttr, String hAttr) {
            if (StringUtils.isBlank(imgUrl)) {
                return;
            }

            if (currentRuns.isEmpty()) {
                contentBlocks.add(createEmptySegment());
            } else {
                flushCurrentRuns(false);
            }

            Map<String, Object> imgInfo = processImage(imgUrl, wAttr, hAttr);
            if (imgInfo != null) {
                imgList.add(imgInfo);
                allImgList.add(createImageMap("image" + questionLabelCount));
                questionLabelCount++;
            }
        }
    }

    private static class HtmlStyle {
        private boolean bold;
        private boolean italic;
        private boolean underline;
        private boolean strike;
        private String vertAlign = "baseline";

        static HtmlStyle root() {
            return new HtmlStyle();
        }

        HtmlStyle copy() {
            HtmlStyle s = new HtmlStyle();
            s.bold = this.bold;
            s.italic = this.italic;
            s.underline = this.underline;
            s.strike = this.strike;
            s.vertAlign = this.vertAlign;
            return s;
        }
    }

    private static class RunInfo {
        private String text;
        private boolean breakLine;
        private boolean bold;
        private boolean italic;
        private boolean underline;
        private boolean strike;
        private String vertAlign = "baseline";
    }
}
