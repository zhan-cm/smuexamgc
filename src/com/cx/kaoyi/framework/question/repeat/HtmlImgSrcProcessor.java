package com.cx.kaoyi.framework.question.repeat;

import com.cx.kaoyi.framework.base.HttpClientHolder;
import com.cx.kaoyi.framework.utils.Image.ImgUtil;
import com.cx.kaoyi.framework.utils.WebFilePath;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;
import okhttp3.ResponseBody;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Locale;
import java.util.regex.Pattern;

public class HtmlImgSrcProcessor {

    private static final OkHttpClient CLIENT = HttpClientHolder.getClientWithTimeout(15, 120, 120);

    private static final String UNSUPPORTED_MEDIA_HTML =
            "<table style=\"width:100%;border-collapse:collapse;border:1px solid #999;\">" +
            "<tr>" +
            "<td style=\"border:1px solid #999;padding:12px;text-align:center;\">不支持音视频播放</td>" +
            "</tr>" +
            "</table>";

    private static final Pattern FULL_DOC_PATTERN =
            Pattern.compile("(?is)<\\s*(?:!doctype|html|head|body)\\b");

    private HtmlImgSrcProcessor() {
    }

    /**
     * 按规则处理 html：
     * 1. img[src]：
     *    - / 开头 -> WebFilePath.getRealPath() 拼接本地路径 -> ImgUtil 转 base64 -> 回填 data URI
     *    - http/https 开头 -> OkHttp 下载 -> 临时文件 -> ImgUtil 转 base64 -> 回填 data URI
     * 2. audio/video -> 替换成 table 提示
     * 3. 其他内容尽量不动
     */
    public static String process(String html) {
        if (html == null || html.isEmpty()) {
            return html;
        }

        boolean fullDocument = FULL_DOC_PATTERN.matcher(html).find();
        Document doc = fullDocument ? Jsoup.parse(html) : Jsoup.parseBodyFragment(html);

        // 尽量减少 jsoup 对原字符串格式的影响
        doc.outputSettings().prettyPrint(false);

        // 只处理 img[src]
        for (Element img : new ArrayList<>(doc.select("img[src]"))) {
            String src = img.attr("src");
            if (src == null) {
                continue;
            }

            String trimmedSrc = src.trim();
            if (trimmedSrc.isEmpty()) {
                continue;
            }

            // 已经是 data URI 的，不动
            if (trimmedSrc.startsWith("data:")) {
                continue;
            }

            try {
                String newSrc = null;

                if (trimmedSrc.startsWith("/")) {
                    newSrc = buildDataUriFromLocal(trimmedSrc);
                } else if (trimmedSrc.startsWith("http://") || trimmedSrc.startsWith("https://")) {
                    newSrc = buildDataUriFromRemote(trimmedSrc);
                }

                if (newSrc != null && !newSrc.isEmpty()) {
                    img.attr("src", newSrc);
                }
            } catch (Exception e) {
                // 按你的要求尽量只替换规则命中的内容，单个图片失败时保留原 src
                e.printStackTrace();
            }
        }

        // audio / video 直接替换
        for (Element media : new ArrayList<>(doc.select("audio, video"))) {
            media.after(UNSUPPORTED_MEDIA_HTML);
            media.remove();
        }

        return fullDocument ? doc.outerHtml() : doc.body().html();
    }

    /**
     * /xxx/yyy.png -> WebFilePath.getRealPath() + 相对路径
     */
    private static String buildDataUriFromLocal(String src) throws Exception {
        String cleanSrc = stripQueryAndFragment(src);
        String relativePath = cleanSrc.replaceFirst("^/+", "");

        Path realPath = Paths.get(WebFilePath.getRealPath())
                .resolve(relativePath)
                .normalize();

        if (!Files.exists(realPath) || !Files.isRegularFile(realPath)) {
            return null;
        }

        // SVG：转成 PNG 再回填
        if (ImgUtil.isSvg(realPath.toString())) {
            byte[] svgBytes = Files.readAllBytes(realPath);
            byte[] pngBytes = ImgUtil.svgBytesToPng(svgBytes, null, null, null, true);
            String base64 = Base64.getEncoder().encodeToString(pngBytes);
            return "data:image/png;base64," + base64;
        }

        String base64 = ImgUtil.getImageBase64Str(realPath);
        if (base64 == null || base64.isEmpty()) {
            return null;
        }

        String mime = detectMimeType(realPath, cleanSrc, null);
        return "data:" + mime + ";base64," + base64;
    }

    /**
     * 远程 URL：
     * 1. OkHttp 拉取
     * 2. 落临时文件
     * 3. 再走 ImgUtil.getImageBase64Str(tempPath)
     * 4. 最后回填 data URI
     */
    private static String buildDataUriFromRemote(String url) throws Exception {
        Request request = new Request.Builder()
                .url(url)
                .get()
                .build();

        try (Response response = CLIENT.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                return null;
            }

            ResponseBody body = response.body();
            if (body == null) {
                return null;
            }

            String contentType = normalizeContentType(response.header("Content-Type"));
            byte[] bytes = body.bytes();
            if (bytes.length == 0) {
                return null;
            }

            // SVG：直接转 PNG
            if (isSvgUrlOrContentType(url, contentType)) {
                byte[] pngBytes = ImgUtil.svgBytesToPng(bytes, null, null, null, true);
                String base64 = Base64.getEncoder().encodeToString(pngBytes);
                return "data:image/png;base64," + base64;
            }

            String suffix = guessSuffix(url, contentType);
            Path tempFile = Files.createTempFile("html_img_", suffix);
            try {
                Files.write(tempFile, bytes,
                        StandardOpenOption.CREATE,
                        StandardOpenOption.TRUNCATE_EXISTING,
                        StandardOpenOption.WRITE);

                String base64 = ImgUtil.getImageBase64Str(tempFile);
                if (base64 == null || base64.isEmpty()) {
                    return null;
                }

                String mime = detectMimeType(tempFile, url, contentType);
                return "data:" + mime + ";base64," + base64;
            } finally {
                try {
                    Files.deleteIfExists(tempFile);
                } catch (IOException ignore) {
                }
            }
        }
    }

    private static String stripQueryAndFragment(String s) {
        if (s == null) {
            return null;
        }
        int q = s.indexOf('?');
        int h = s.indexOf('#');

        int end = s.length();
        if (q >= 0) {
            end = Math.min(end, q);
        }
        if (h >= 0) {
            end = Math.min(end, h);
        }
        return s.substring(0, end);
    }

    private static String normalizeContentType(String contentType) {
        if (contentType == null) {
            return null;
        }
        String s = contentType.trim().toLowerCase(Locale.ROOT);
        int idx = s.indexOf(';');
        return idx >= 0 ? s.substring(0, idx).trim() : s;
    }

    private static boolean isSvgUrlOrContentType(String urlOrPath, String contentType) {
        if (contentType != null && contentType.contains("svg")) {
            return true;
        }
        return ImgUtil.isSvg(stripQueryAndFragment(urlOrPath));
    }

    private static String detectMimeType(Path path, String originalNameOrUrl, String contentType) {
        // 1. 先信 header
        if (contentType != null && !contentType.isEmpty()) {
            return contentType;
        }

        // 2. 再 probe 本地文件
        try {
            String probe = Files.probeContentType(path);
            if (probe != null && !probe.trim().isEmpty()) {
                return probe;
            }
        } catch (IOException ignore) {
        }

        // 3. 最后按后缀猜
        String byExt = guessMimeTypeByName(originalNameOrUrl);
        if (byExt != null) {
            return byExt;
        }

        // 兜底
        return "image/png";
    }

    private static String guessMimeTypeByName(String nameOrUrl) {
        if (nameOrUrl == null) {
            return null;
        }

        String s = stripQueryAndFragment(nameOrUrl).toLowerCase(Locale.ROOT);
        if (s.endsWith(".png")) return "image/png";
        if (s.endsWith(".jpg") || s.endsWith(".jpeg")) return "image/jpeg";
        if (s.endsWith(".gif")) return "image/gif";
        if (s.endsWith(".bmp")) return "image/bmp";
        if (s.endsWith(".webp")) return "image/webp";
        if (s.endsWith(".svg")) return "image/svg+xml";
        if (s.endsWith(".ico")) return "image/x-icon";
        return null;
    }

    private static String guessSuffix(String url, String contentType) {
        if (contentType != null) {
            if ("image/png".equals(contentType)) return ".png";
            if ("image/jpeg".equals(contentType)) return ".jpg";
            if ("image/gif".equals(contentType)) return ".gif";
            if ("image/bmp".equals(contentType)) return ".bmp";
            if ("image/webp".equals(contentType)) return ".webp";
            if ("image/svg+xml".equals(contentType)) return ".svg";
            if ("image/x-icon".equals(contentType)) return ".ico";
        }

        String s = stripQueryAndFragment(url);
        if (s != null) {
            int idx = s.lastIndexOf('.');
            if (idx >= 0 && idx < s.length() - 1) {
                String ext = s.substring(idx).toLowerCase(Locale.ROOT);
                if (ext.matches("\\.(png|jpg|jpeg|gif|bmp|webp|svg|ico)")) {
                    return ext;
                }
            }
        }

        return ".img";
    }
}