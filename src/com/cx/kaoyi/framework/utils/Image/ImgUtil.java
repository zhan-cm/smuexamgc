package com.cx.kaoyi.framework.utils.Image;

import com.cx.kaoyi.framework.utils.PaperContentUtils;
import com.cx.kaoyi.framework.utils.WebFilePath;
import org.apache.batik.transcoder.TranscoderInput;
import org.apache.batik.transcoder.TranscoderOutput;
import org.apache.batik.transcoder.image.ImageTranscoder;
import org.apache.batik.transcoder.image.PNGTranscoder;
import org.apache.commons.lang3.StringUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import java.awt.*;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.*;
import java.security.MessageDigest;
import java.util.Base64;

public class ImgUtil {

    public static String getImageBase64Str(String imgFilePath) {
        return getImageBase64Str(Paths.get(imgFilePath));
    }

    public static String getImageBase64Str(Path imgPath) {
        if (imgPath == null) return null;

        try (InputStream in = Files.newInputStream(imgPath);
             ByteArrayOutputStream baos = new ByteArrayOutputStream()) {

            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                baos.write(buffer, 0, bytesRead);
            }
            byte[] data = baos.toByteArray();
            return Base64.getEncoder().encodeToString(data);

        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static boolean generateImage(String base64str, String dirPath, String picName) {
        if (base64str == null || base64str.isEmpty()) {
            return false;
        }
        if (dirPath == null || dirPath.trim().isEmpty()) {
            return false;
        }
        if (picName == null || picName.trim().isEmpty()) {
            return false;
        }

        Path dir = Paths.get(dirPath);
        try {
            Files.createDirectories(dir);
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }

        Path savePath = dir.resolve(picName);
        return generateImage(base64str, savePath);
    }

    public static boolean generateImage(String base64str, String saveFilePath) {
        if (base64str == null || base64str.isEmpty()) {
            return false;
        }
        if (saveFilePath == null || saveFilePath.trim().isEmpty()) {
            return false;
        }
        return generateImage(base64str, Paths.get(saveFilePath));
    }

    public static boolean generateImage(String base64str, Path savePath) {
        if (base64str == null || base64str.isEmpty()) {
            return false;
        }
        if (savePath == null) {
            return false;
        }

        // 去掉 data URI 前缀（如果有的话）
        int idx = base64str.indexOf("base64,");
        if (idx != -1) {
            base64str = base64str.substring(idx + "base64,".length());
        }

        try {
            Path parent = savePath.getParent();
            if (parent != null) {
                Files.createDirectories(parent);
            }

            byte[] base64Data = Base64.getDecoder().decode(base64str);
            return generateImage(base64Data, savePath);

        } catch (IllegalArgumentException e) {
            // base64 解码失败
            return false;
        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    public static boolean generateImage(byte[] base64Data, String saveFilePath) {
        if (base64Data == null || base64Data.length == 0) {
            return false;
        }
        if (saveFilePath == null || saveFilePath.trim().isEmpty()) {
            return false;
        }
        return generateImage(base64Data, Paths.get(saveFilePath));
    }

    public static boolean generateImage(byte[] base64Data, Path savePath) {
        if (base64Data == null || base64Data.length == 0) {
            return false;
        }
        if (savePath == null) {
            return false;
        }

        try {
            Path parent = savePath.getParent();
            if (parent != null) {
                Files.createDirectories(parent);
            }

            Files.write(savePath, base64Data,
                    StandardOpenOption.CREATE,
                    StandardOpenOption.TRUNCATE_EXISTING,
                    StandardOpenOption.WRITE);
            return true;

        } catch (IOException e) {
            e.printStackTrace();
            return false;
        }
    }

    /** SVG 文件 -> PNG 文件 */
    public static void svgFileToPng(String svgPath, String pngPath,
                                    Double targetW, Double targetH,
                                    Float dpi, boolean whiteBg) throws Exception {

        Path svg = Paths.get(svgPath);
        Path png = Paths.get(pngPath);

        Path parent = png.getParent();
        if (parent != null) {
            Files.createDirectories(parent);
        }

        try (InputStream in = Files.newInputStream(svg);
             OutputStream out = new BufferedOutputStream(
                     Files.newOutputStream(png,
                             StandardOpenOption.CREATE,
                             StandardOpenOption.TRUNCATE_EXISTING,
                             StandardOpenOption.WRITE))) {
            svgStreamToPng(in, out, targetW, targetH, dpi, whiteBg);
        }
    }

    /** SVG 字节 -> PNG 字节 */
    public static byte[] svgBytesToPng(byte[] svgBytes,
                                       Double targetW, Double targetH,
                                       Float dpi, boolean whiteBg) throws Exception {
        try (InputStream in = new ByteArrayInputStream(svgBytes);
             ByteArrayOutputStream out = new ByteArrayOutputStream()) {
            svgStreamToPng(in, out, targetW, targetH, dpi, whiteBg);
            return out.toByteArray();
        }
    }

    /** SVG 文本 -> PNG 字节 */
    public static byte[] svgStringToPng(String svgText,
                                        Double targetW, Double targetH,
                                        Float dpi, boolean whiteBg) throws Exception {
        byte[] bytes = svgText.getBytes(StandardCharsets.UTF_8);
        return svgBytesToPng(bytes, targetW, targetH, dpi, whiteBg);
    }

    /** 通用：SVG 流 -> PNG 流 */
    public static void svgStreamToPng(InputStream svgIn, OutputStream pngOut,
                                      Double targetW, Double targetH,
                                      Float dpi, boolean whiteBg) throws Exception {
        PNGTranscoder t = new PNGTranscoder();

        if (whiteBg) {
            t.addTranscodingHint(ImageTranscoder.KEY_BACKGROUND_COLOR, Color.white);
        }
        // 只设其一即可，另一边按 viewBox 等比
        if (targetW != null && targetW > 0) {
            t.addTranscodingHint(PNGTranscoder.KEY_WIDTH, targetW.floatValue());
        }
        if (targetH != null && targetH > 0) {
            t.addTranscodingHint(PNGTranscoder.KEY_HEIGHT, targetH.floatValue());
        }
        if (dpi != null && dpi > 0) {
            t.addTranscodingHint(PNGTranscoder.KEY_PIXEL_UNIT_TO_MILLIMETER, 25.4f / dpi);
        }

        TranscoderInput input = new TranscoderInput(svgIn);
        TranscoderOutput output = new TranscoderOutput(pngOut);
        t.transcode(input, output);
        pngOut.flush();
    }

    /** 简单判断是否 SVG（按扩展名或 dataURI） */
    public static boolean isSvg(String urlOrPath) {
        if (urlOrPath == null) return false;
        String s = urlOrPath.trim().toLowerCase();
        return s.endsWith(".svg") || s.startsWith("data:image/svg+xml");
    }

    public static String saveEditorFomulaPic(String content, String cid) {
        if (StringUtils.isBlank(content)) return content;
        content = PaperContentUtils.stripMsoConditionalComments(content);
        Document doc = Jsoup.parseBodyFragment(content);
        doc.outputSettings().prettyPrint(false);
        Elements imgs = doc.select("img[data-latex]");
        for (Element img : imgs) {
            String src = img.attr("src");
            if (StringUtils.isBlank(src) || !src.startsWith("data:image/svg+xml;base64,")) {
                continue;
            }
            try {
                String base64str = src.substring("data:image/svg+xml;base64,".length());
                byte[] svgBytes = Base64.getDecoder().decode(base64str);
                // 用 svg 内容 hash 做文件名，避免同一个公式重复生成一堆时间戳文件
                MessageDigest md = MessageDigest.getInstance("SHA-256");
                byte[] digest = md.digest(svgBytes);
                StringBuilder sb = new StringBuilder();
                for (byte b : digest) {
                    sb.append(String.format("%02x", b));
                }
                String nowName = sb.toString() + ".svg";
                Path localDir = Paths.get(WebFilePath.getRealPath(), "kaoyi_upload", cid);
                if (!Files.exists(localDir) || !Files.isDirectory(localDir)) {
                    Files.deleteIfExists(localDir);
                    Files.createDirectories(localDir);
                }
                Path localFile = localDir.resolve(nowName);
                if (!Files.exists(localFile)) {
                    Files.write(localFile, svgBytes);
                }
                Path nginxDir = Paths.get(WebFilePath.getNginxRoot(), "kaoyi_upload", cid);
                if (!Files.exists(nginxDir) || !Files.isDirectory(nginxDir)) {
                    Files.deleteIfExists(nginxDir);
                    Files.createDirectories(nginxDir);
                }
                Files.copy(
                        localFile,
                        nginxDir.resolve(nowName),
                        StandardCopyOption.REPLACE_EXISTING
                );
                img.attr("src", "/kaoyi_upload/" + cid + "/" + nowName);//只替换 src
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return doc.body().html();
    }
}