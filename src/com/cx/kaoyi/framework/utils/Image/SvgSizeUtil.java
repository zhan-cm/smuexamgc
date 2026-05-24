package com.cx.kaoyi.framework.utils.Image;

import org.apache.commons.io.IOUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import java.io.InputStream;
import java.nio.charset.StandardCharsets;

public class SvgSizeUtil {

    public static class SvgSize {
        public final Double widthPx;
        public final Double heightPx;

        public SvgSize(Double widthPx, Double heightPx) {
            this.widthPx = widthPx;
            this.heightPx = heightPx;
        }

        public boolean valid() {
            return widthPx != null && widthPx > 0 && heightPx != null && heightPx > 0;
        }

        public double ratio() {
            if (!valid()) return 1.0;
            return widthPx / heightPx;
        }

        @Override
        public String toString() {
            return "SvgSize{widthPx=" + widthPx + ", heightPx=" + heightPx + "}";
        }
    }

    public static SvgSize readSvgSize(InputStream in) throws Exception {
        byte[] bytes = IOUtils.toByteArray(in);
        String xml = new String(bytes, StandardCharsets.UTF_8);

        Document doc = Jsoup.parse(xml, "", org.jsoup.parser.Parser.xmlParser());
        Element svg = doc.selectFirst("svg");
        if (svg == null) {
            return new SvgSize(null, null);
        }

        Double width = parseLengthToPx(svg.attr("width"));
        Double height = parseLengthToPx(svg.attr("height"));

        String viewBox = svg.attr("viewBox");
        Double vbWidth = null;
        Double vbHeight = null;
        if (viewBox != null && !"".equals(viewBox.trim())) {
            String[] arr = viewBox.trim().split("[,\\s]+");
            if (arr.length == 4) {
                try {
                    vbWidth = Double.parseDouble(arr[2]);
                    vbHeight = Double.parseDouble(arr[3]);
                } catch (Exception ignored) {}
            }
        }

        // 优先 width/height
        if (width != null && width > 0 && height != null && height > 0) {
            return new SvgSize(width, height);
        }

        // 一边缺失，用 viewBox 补比例
        if (width != null && width > 0 && (height == null || height <= 0)
                && vbWidth != null && vbHeight != null && vbWidth > 0 && vbHeight > 0) {
            return new SvgSize(width, width * vbHeight / vbWidth);
        }

        if (height != null && height > 0 && (width == null || width <= 0)
                && vbWidth != null && vbHeight != null && vbWidth > 0 && vbHeight > 0) {
            return new SvgSize(height * vbWidth / vbHeight, height);
        }

        // width/height 都没有，退回 viewBox
        if (vbWidth != null && vbWidth > 0 && vbHeight != null && vbHeight > 0) {
            return new SvgSize(vbWidth, vbHeight);
        }

        return new SvgSize(width, height);
    }

    private static Double parseLengthToPx(String s) {
        if (s == null) return null;
        s = s.trim();
        if (s.isEmpty()) return null;

        // 百分比没法从 SVG 自身推绝对像素
        if (s.endsWith("%")) return null;

        try {
            if (s.endsWith("px")) {
                return Double.parseDouble(s.substring(0, s.length() - 2).trim());
            }
            if (s.endsWith("pt")) {
                double pt = Double.parseDouble(s.substring(0, s.length() - 2).trim());
                return pt * 96.0 / 72.0;
            }
            if (s.endsWith("in")) {
                double in = Double.parseDouble(s.substring(0, s.length() - 2).trim());
                return in * 96.0;
            }
            if (s.endsWith("cm")) {
                double cm = Double.parseDouble(s.substring(0, s.length() - 2).trim());
                return cm * 96.0 / 2.54;
            }
            if (s.endsWith("mm")) {
                double mm = Double.parseDouble(s.substring(0, s.length() - 2).trim());
                return mm * 96.0 / 25.4;
            }
            // 无单位，SVG 里一般按 px 处理
            return Double.parseDouble(s);
        } catch (Exception e) {
            return null;
        }
    }
}