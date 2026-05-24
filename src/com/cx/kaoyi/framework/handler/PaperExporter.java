package com.cx.kaoyi.framework.handler;

import com.aspose.words.Document;
import com.aspose.words.SaveFormat;
import com.cx.kaoyi.framework.utils.result.GenerateWordUtils;
import net.lingala.zip4j.ZipFile;
import net.lingala.zip4j.model.ZipParameters;

import java.io.*;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Map;
import java.util.stream.Stream;

public class PaperExporter {

    private String paperName;

    public PaperExporter(String paperName){
        this.paperName = paperName;
    }

    public void createPaperTmpDir(String targetPath) throws IOException {
        String zipPath = "resources/ftlmodel/"+paperName+"Paper/zipPackage";
        ClassLoader classLoader = getClass().getClassLoader();
        URL resourceUrl = classLoader.getResource(zipPath);
        if (resourceUrl == null) {
            throw new RuntimeException("Resource not found: " + zipPath);
        }
        // 将路径解码，获取到本地系统可用的文件路径
        String sourcePath;
        try {
            sourcePath = URLDecoder.decode(resourceUrl.getFile(), StandardCharsets.UTF_8.name());
            if(sourcePath.startsWith("/")){
                sourcePath = sourcePath.substring(1,sourcePath.length());
            }
        } catch (UnsupportedEncodingException e) {
            throw new RuntimeException("Failed to decode resource file path.", e);
        }

        Path sourceDir = Paths.get(sourcePath);
        Path targetDir = Paths.get(targetPath);

        // 创建目标目录（如果不存在）
        Files.createDirectories(targetDir);
        // 检查源路径是否为有效目录
        if (!Files.isDirectory(sourceDir)) {
            return;
        }

        // 遍历源目录并复制每个条目
        try (Stream<Path> stream = Files.walk(sourceDir)) {
            stream.forEach(source -> {
                try {
                    // 计算相对路径并解析目标路径
                    Path relative = sourceDir.relativize(source);
                    Path destination = targetDir.resolve(relative);

                    if (Files.isDirectory(source)) {
                        // 创建目标目录
                        Files.createDirectories(destination);
                    } else {
                        // 确保父目录存在并复制文件
                        Files.createDirectories(destination.getParent());
                        Files.copy(source, destination, StandardCopyOption.REPLACE_EXISTING);
                    }
                } catch (IOException ex) {
                    throw new UncheckedIOException(ex);
                }
            });
        } catch (UncheckedIOException ex) {
            throw ex.getCause();
        }
    }

    public void exportPaper(Map<String, Object> map, String tmpDocxPath) {
        GenerateWordUtils.exportDocxXml(map, paperName + "Paper/document.xml.rels.ftl", tmpDocxPath, "word/_rels/document.xml.rels");
        GenerateWordUtils.exportDocxXml(map, paperName + "Paper/document.ftl", tmpDocxPath, "word/document.xml");
        Path sourceFolder = Paths.get(tmpDocxPath);
        Path zipPath = Paths.get(tmpDocxPath + ".zip");
        Path docxPath = zipPath.resolveSibling(
                zipPath.getFileName().toString().replaceFirst("\\.zip$", ".docx")
        );
        ZipParameters parameters = new ZipParameters();
        parameters.setIncludeRootFolder(false);
        try {
            // 如果已存在旧的 zip / docx，先删掉，避免干扰
            Files.deleteIfExists(zipPath);
            Files.deleteIfExists(docxPath);

            // zip4j 这里通常仍需要 File
            try (ZipFile zipFile = new ZipFile(zipPath.toFile())) {
                zipFile.addFolder(sourceFolder.toFile(), parameters);
            }

            Files.move(zipPath, docxPath, StandardCopyOption.REPLACE_EXISTING);

        } catch (IOException e) {
            throw new RuntimeException("导出 paper 失败: " + docxPath, e);
        }
    }

    public void exportPaperPdf(Map<String, Object> map, String tmpDocxPath) {
        exportPaper(map, tmpDocxPath);

        Path docxPath = Paths.get(tmpDocxPath + ".docx");
        Path pdfPath = Paths.get(tmpDocxPath + ".pdf");

        try {
            Document doc = new Document(docxPath.toString());
            doc.save(pdfPath.toString(), SaveFormat.PDF);
        } catch (Exception e) {
            throw new RuntimeException("导出 PDF 失败", e);
        }
    }
}
