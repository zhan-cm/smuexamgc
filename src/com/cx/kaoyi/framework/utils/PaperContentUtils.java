package com.cx.kaoyi.framework.utils;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PaperContentUtils {
    private static final Pattern p_enter = Pattern.compile("<br/>", Pattern.CASE_INSENSITIVE);
    private static final Pattern p_enter2 = Pattern.compile("<br>", Pattern.CASE_INSENSITIVE);
    private static final Pattern p_html = Pattern.compile("(?!<(img|video|audio|p|table|tr|td|tbody|span|sup|sub|u|ins|/p|/table|/tr|/td|/tbody|/span|/sup|/sub|/u|/ins|em|/em|strong|/strong).*?>)<.*?>", Pattern.CASE_INSENSITIVE);

    public static String getQuestionTxt(String content, String qtid){
        //将HTML中的换行符<br/>替换成"\n"
        Matcher m_enter = p_enter.matcher(content);
        content = m_enter.replaceAll("%br/%");

        Matcher m_enter2 = p_enter2.matcher(content);
        content = m_enter2.replaceAll("%br/%");

        Matcher m_html = p_html.matcher(content);
        content = m_html.replaceAll("");
        content=content.replaceAll("%br/%","<br/>");

        org.jsoup.nodes.Document doc = Jsoup.parse(content);
        doc.outputSettings().prettyPrint(false);
        org.jsoup.nodes.Element body = doc.body();

        // 2. 如果 body 里**唯一**的子元素是 <p> 或 <div>，就 unwrap 一次，循环直到不再满足
        while (true) {
            org.jsoup.select.Elements children = body.children();
            if (children.size() == 1) {
                org.jsoup.nodes.Element only = children.first();
                String tag = only.tagName().toLowerCase();
                if ("p".equals(tag) || "div".equals(tag)) {
                    only.unwrap();
                    continue;
                }
            }
            break;
        }

        // 3. 删除末尾多余的 <br/>（只删“最后”的那些）
        org.jsoup.select.Elements brs = body.select("br");
        for (int i = brs.size() - 1; i >= 0; i--) {
            org.jsoup.nodes.Element br = brs.get(i);
            if (br.nextSibling() == null) {
                br.remove();
            } else {
                break;
            }
        }

        // 4. 给所有B1型题 <p> 追加样式
        if("155_0_1".equals(qtid)) {
            body.select("p").forEach(p -> {
                // 1) 插入换行
                String txt = p.text();
                if (!txt.endsWith("\n")) {
                    p.after("\n");
                }
                // 2) 解包：把 p 标签本身去掉，只保留里面的文本／子节点
                p.unwrap();
            });
        }

        // 5. 返回处理后的 HTML
        return body.html();
    }

    // MS Office / Outlook 条件注释（原始 & 转义两种）
    private static final Pattern MSO_CC = Pattern.compile(
            "<!--\\s*\\[if[^\\]]+\\]\\s*>.*?<!\\s*\\[endif\\]\\s*--\\s*>",
            Pattern.CASE_INSENSITIVE | Pattern.DOTALL
    );
    private static final Pattern MSO_CC_ESCAPED = Pattern.compile(
            "&lt;!--\\s*\\[if[^\\]]+\\]\\s*&gt;.*?&lt;!\\s*\\[endif\\]\\s*--\\s*&gt;",
            Pattern.CASE_INSENSITIVE | Pattern.DOTALL
    );

    //清理 Word/Outlook 生成的 MSO 条件注释（原始 & 被转义两种）
    public static String stripMsoConditionalComments(String s) {
        if (s == null || s.isEmpty()) return s;
        String out = MSO_CC.matcher(s).replaceAll("");
        out = MSO_CC_ESCAPED.matcher(out).replaceAll("");
        return out;
    }

    private static final int DEFAULT_MAX_BYTES = 4000;
    private static final String ELLIPSIS = "...";
    private static final int ELLIPSIS_BYTES = 3; // "..." in UTF-8

    /**
     * 最稳版本：按 UTF-8 字节数确保不超过 VARCHAR2(4000 BYTE)。
     *
     * 4级处理：
     * 1) 原文(HTML) UTF-8字节 <= maxBytes 直接返回
     * 2) 保守清理HTML后 <= maxBytes 返回
     * 3) 转纯文本（保留基本换行）<= maxBytes 返回
     * 4) 纯文本仍超：按字节截断到 (maxBytes - 3) + "..."
     */
    public static String fitForVarchar2_4000Byte(String html) {
        return fitForVarchar2Byte(html, DEFAULT_MAX_BYTES);
    }

    public static String fitForVarchar2Byte(String html, int maxBytes) {
        if (html == null) return null;
        if (maxBytes <= 0) return "";
        html = stripMsoConditionalComments(html);
        // Level 1
        if (utf8Bytes(html) <= maxBytes) return html;

        // Level 2
        String lvl2 = conservativeCleanHtml(html);
        if (utf8Bytes(lvl2) <= maxBytes) return lvl2;

        // Level 3
        String lvl3 = toPlainTextPreserveLineBreaks(html);
        if (utf8Bytes(lvl3) <= maxBytes) return lvl3;

        // Level 4
        int cutBytes = Math.max(0, maxBytes - ELLIPSIS_BYTES);
        return truncateUtf8ByBytes(lvl3, cutBytes) + ELLIPSIS;
    }

    private static int utf8Bytes(String s) {
        return s.getBytes(StandardCharsets.UTF_8).length;
    }

    /**
     * 按 UTF-8 字节数截断，保证结果的 UTF-8 字节长度 <= maxBytes。
     * 不会把多字节字符截断到一半，也不会把代理对截断坏。
     */
    private static String truncateUtf8ByBytes(String s, int maxBytes) {
        if (s == null) return null;
        if (maxBytes <= 0) return "";
        byte[] bytes = s.getBytes(StandardCharsets.UTF_8);
        if (bytes.length <= maxBytes) return s;

        // 二分找最大可行的“字符边界”位置
        int lo = 0, hi = s.length();
        int best = 0;

        while (lo <= hi) {
            int mid = (lo + hi) >>> 1;

            int end = mid;
            // 避免把 UTF-16 代理对从中间切开
            if (end > 0
                    && end < s.length()
                    && Character.isHighSurrogate(s.charAt(end - 1))
                    && Character.isLowSurrogate(s.charAt(end))) {
                end--;
            }

            int b = utf8Bytes(s.substring(0, end));
            if (b <= maxBytes) {
                best = end;
                lo = mid + 1;
            } else {
                hi = mid - 1;
            }
        }
        return s.substring(0, best);
    }

    private static String conservativeCleanHtml(String html) {
        Document doc = Jsoup.parseBodyFragment(html);
        doc.outputSettings().prettyPrint(false);

        Element body = doc.body();

        body.select("script,style,noscript,meta,link,iframe,object,embed,svg,canvas").remove();

        unwrapAll(body.select("span,font"));

        for (Element el : body.getAllElements()) {
            String tag = el.tagName();
            if ("a".equals(tag)) {
                String href = el.hasAttr("href") ? el.attr("href") : null;
                el.clearAttributes();
                if (href != null && !href.isEmpty()) el.attr("href", href);
            } else {
                el.clearAttributes();
            }
        }

        removeEmptyBlocks(body.select("p,div,section,article,header,footer"));

        String out = body.html();

        out = out.replace("&nbsp;", " ");
        out = out.replace('\u00A0', ' ');
        out = out.replaceAll(">\\s+<", "><");
        out = out.replaceAll("[\\t\\n\\r]+", "");
        out = out.replaceAll("\\s{2,}", " ").trim();

        return out;
    }

    private static String toPlainTextPreserveLineBreaks(String html) {
        Document doc = Jsoup.parseBodyFragment(html);
        Element body = doc.body();

        body.select("br").append("\\n");
        body.select("p,div,li,blockquote").prepend("\\n");

        String text = body.text().replace("\\n", "\n");

        text = text.replace('\u00A0', ' ');
        text = text.replaceAll("[ \\t\\x0B\\f\\r]+", " ");  // 不动 \n
        text = text.replaceAll("\\n{3,}", "\n\n");
        return text.trim();
    }

    private static void unwrapAll(Elements elements) {
        Element[] arr = elements.toArray(new Element[0]);
        for (Element e : arr) {
            if (e != null && e.parent() != null) {
                e.unwrap();
            }
        }
    }

    private static void removeEmptyBlocks(Elements blocks) {
        Element[] arr = blocks.toArray(new Element[0]);
        for (Element el : arr) {
            if (el == null) continue;
            String t = el.text();
            if (t == null || t.trim().isEmpty()) {
                el.remove();
            }
        }
    }
}
