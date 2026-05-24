package com.cx.kaoyi.framework.base;

import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.streaming.SXSSFWorkbook;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.InputStreamResource;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.util.StringUtils;

import java.io.*;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;

public final class FileDownloadUtils {

    private static final Logger logger = LoggerFactory.getLogger(FileDownloadUtils.class);

    private FileDownloadUtils() {}

    public static ResponseEntity<Resource> download(String path) {
        return download(Paths.get(path));
    }

    public static ResponseEntity<Resource> download(File file) {
        return download(file.toPath());
    }

    public static ResponseEntity<Resource> download(Path path) {
        InputStream in = null;
        try {
            if (!Files.exists(path) || !Files.isReadable(path)) {
                throw new IOException("文件不存在或不可读: " + path);
            }
            String fileName = path.getFileName().toString();
            in = Files.newInputStream(path); // 交给 buildResponse
            return buildResponse(in, fileName, Files.size(path), null);
        } catch (Exception ex) {
            logger.error("下载 [{}] 失败，原因: {}", path, ex.getMessage(), ex);
            try { if (in != null) in.close(); } catch (IOException ignore) {}
            return errorResponse("下载失败，请联系管理员：\n"+ex.getMessage());
        }
    }

    /**
     * 直接传输入流（例如数据库 Blob）
     * @param in        已经打开的输入流（调用方保证可读）
     * @param fileName  下载时显示的文件名（用来猜 MIME）
     */
    public static ResponseEntity<Resource> download(InputStream in, String fileName) {
        return buildResponse(in, fileName, -1, null);
    }

    public static ResponseEntity<Resource> download(byte[] bytes, String fileName) {
        // 注意：ByteArrayInputStream 只是包装，不会复制 bytes
        InputStream in = new ByteArrayInputStream(bytes);
        return buildResponse(in, fileName, bytes.length,null);
    }

    public static ResponseEntity<Resource> download(byte[] bytes,
                                                    String fileName,
                                                    MediaType overrideType) {
        // 注意：ByteArrayInputStream 只是包装，不会复制 bytes
        InputStream in = new ByteArrayInputStream(bytes);
        return buildResponse(in, fileName, bytes.length, overrideType);
    }

    /**
     * 直接把 Apache POI Workbook 导出为下载响应。
     *
     * @param workbook  任意实现：XSSFWorkbook / HSSFWorkbook / SXSSFWorkbook
     * @param fileName  下载时显示的文件名，带 .xlsx 或 .xls
     */
    public static ResponseEntity<Resource> download(Workbook workbook, String fileName) {
        // 判断 MIME：xls ≠ xlsx
        String ext = StringUtils.getFilenameExtension(fileName);
        MediaType excelType = "xls".equalsIgnoreCase(ext)
                ? MediaType.parseMediaType("application/vnd.ms-excel")
                : MediaType.parseMediaType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");

        try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {
            workbook.write(baos);          // 写进内存
            // SXSSFWorkbook 记得 dispose()，否则临时文件不会清
            if (workbook instanceof SXSSFWorkbook) {
                ((SXSSFWorkbook) workbook).dispose();
            }
            workbook.close();
            return download(baos.toByteArray(), fileName, excelType);
        } catch (IOException e) {
            logger.error("生成 Excel 失败，原因: {}", e.getMessage(), e);
            return errorResponse("生成 Excel 失败，请联系管理员：\n" + e.getMessage());
        }
    }


    /**
     * 核心方法：永远返回 ResponseEntity，不向上抛异常。
     *
     * @param in             已打开的输入流（成功路径会交由 Spring 容器在写完后关闭）
     * @param fileName       原始文件名
     * @param contentLength  文件大小，未知时传 -1
     * @param overrideType   手动指定 Content-Type，可为 null
     */
    private static ResponseEntity<Resource> buildResponse(InputStream in,
                                                          String fileName,
                                                          long contentLength,
                                                          MediaType overrideType) {
        HttpHeaders headers = new HttpHeaders();
        try {
            MediaType mediaType = (overrideType != null) ? overrideType : guessMediaType(fileName);
            headers.setContentType(mediaType);
            if (contentLength >= 0) {
                headers.setContentLength(contentLength);
            }
            String encoded = URLEncoder.encode(fileName, "UTF-8").replaceAll("\\+", "%20");
            String cd = "attachment; filename=\"" + encoded + "\"; filename*=UTF-8''" + encoded;
            headers.add(HttpHeaders.CONTENT_DISPOSITION, cd);
            return ResponseEntity.ok()
                    .headers(headers)
                    .body(new InputStreamResource(in));
        } catch (Exception ex) {
            logger.error("文件下载出错，文件名: {}, 原因: {}", fileName, ex.getMessage(), ex);
            try { if (in != null) in.close(); } catch (IOException ignore) {}
            return errorResponse("下载失败，请联系管理员：\n"+ex.getMessage());
        }
    }

    /**
     * 直接返回一个 error.txt 下载。<br>
     * 常用于「无权限」「业务校验失败」等场景，避免写重复的 5 行代码。
     *
     * @param msg 文本内容（会写进 error.txt）
     */
    public static ResponseEntity<Resource> errorResponse(String msg) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.TEXT_PLAIN);
        headers.add(HttpHeaders.CONTENT_DISPOSITION,
                "attachment; filename=\"error.txt\"; filename*=UTF-8''error.txt");

        byte[] bytes = msg.getBytes(StandardCharsets.UTF_8);
        return ResponseEntity.status(HttpStatus.OK)
                .headers(headers)
                .body(new ByteArrayResource(bytes));
    }

    /** 常用后缀 → MIME 对照表（补充 Files.probeContentType 覆盖不到的） */
    private static final Map<String, MediaType> EXT_MAP = new HashMap<>();
    static {
        EXT_MAP.put("pdf", MediaType.APPLICATION_PDF);
        EXT_MAP.put("zip", MediaType.APPLICATION_OCTET_STREAM);
        EXT_MAP.put("rar", MediaType.APPLICATION_OCTET_STREAM);
        EXT_MAP.put("xlsx", MediaType.parseMediaType(
                "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"));
        EXT_MAP.put("xls", MediaType.parseMediaType(
                "application/vnd.ms-excel"));
        EXT_MAP.put("docx", MediaType.parseMediaType(
                "application/vnd.openxmlformats-officedocument.wordprocessingml.document"));
        EXT_MAP.put("doc", MediaType.parseMediaType("application/msword"));
        EXT_MAP.put("png", MediaType.IMAGE_PNG);
        EXT_MAP.put("jpg", MediaType.IMAGE_JPEG);
        EXT_MAP.put("jpeg", MediaType.IMAGE_JPEG);
        EXT_MAP.put("gif", MediaType.IMAGE_GIF);
        // 有需要再往里面加
    }

    private static MediaType guessMediaType(String fileName) {
        try {
            // 尝试系统探测
            Path temp = Paths.get(fileName);
            String probe = Files.probeContentType(temp);
            if (probe != null) {
                return MediaType.parseMediaType(probe);
            }
        } catch (IOException ignore) { /* 探测失败走后备 */ }

        // 后缀兜底
        String ext = StringUtils.getFilenameExtension(fileName);
        if (ext != null) {
            MediaType t = EXT_MAP.get(ext.toLowerCase(Locale.ROOT));
            if (t != null) {
                return t;
            }
        }
        // 仍然识别不了
        return MediaType.APPLICATION_OCTET_STREAM;
    }
}