package com.cx.kaoyi.framework.utils.result;

import freemarker.template.Configuration;
import freemarker.template.Template;
import freemarker.template.TemplateException;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;

public class GenerateWordUtils {
    private static final Configuration CFG = new Configuration(Configuration.VERSION_2_3_34);

    static {
        CFG.setDefaultEncoding("UTF-8");
        CFG.setClassLoaderForTemplateLoading(
                GenerateWordUtils.class.getClassLoader(),
                "resources/ftlmodel"
        );
    }

    public static InputStream exportDocAsStream(Map<String, Object> dataModel, String ftlName) {
        try (ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream()) {
            Template template = CFG.getTemplate(ftlName, "utf-8");

            try (Writer writer = new BufferedWriter(new OutputStreamWriter(byteArrayOutputStream, "utf-8"), 10240)) {
                template.process(dataModel, writer); // 渲染模板
            }

            return new ByteArrayInputStream(byteArrayOutputStream.toByteArray());
        } catch (IOException | TemplateException e) {
            e.printStackTrace();
            return null; // 或者抛出一个自定义异常
        }
    }

    public static void exportDocxXml(Map<String, Object> dataModel, String ftlName, String outputFilePath, String outputFileInnerPath) {
        try {
            Template template = CFG.getTemplate(ftlName, "utf-8");
            File outputFile = new File(outputFilePath, outputFileInnerPath);
            if(!outputFile.getParentFile().exists()){
                outputFile.getParentFile().mkdirs();
            }
            try (Writer writer = new BufferedWriter(
                    new OutputStreamWriter(new FileOutputStream(outputFile), StandardCharsets.UTF_8), 10240)) {
                template.process(dataModel, writer);
            }

        } catch (IOException | TemplateException e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to export doc file.", e);
        }
    }

    public static void setFtlView(HttpServletResponse response, String ftlName, Map<String,Object> model) throws Exception {
        response.setContentType("text/html; charset=UTF-8");
        Template template = CFG.getTemplate(ftlName, "utf-8");
        template.process(model, response.getWriter());
    }

    public static String getFtlStr(String ftlName, Map<String,Object> model){
        StringWriter out = new StringWriter(16 * 1024);
        try {
            Template template = CFG.getTemplate(ftlName, "utf-8");
            template.process(model, out);
            return out.toString();
        } catch (Exception e) {
            throw new RuntimeException("渲染的"+ftlName+"HTML失败", e);
        }
    }
}