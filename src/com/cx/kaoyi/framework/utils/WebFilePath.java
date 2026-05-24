package com.cx.kaoyi.framework.utils;

import org.apache.commons.lang3.StringUtils;

import java.io.File;

public class WebFilePath {
    private static String realPath = "";
    private static String nginxRoot = "";
    private static String projectPath = "";
    private static String projectName = "";

    public static void initSystemPath(String projectPathInput, String projectNameInput, String nginxRootInput){
        projectName = projectNameInput;
        setProjectPath(projectPathInput);
        setRealPath(projectPathInput.substring(0,projectPathInput.lastIndexOf(projectNameInput)));
        setNginxRoot(nginxRootInput);
    }

    public static String getProjectName(){
        return projectName;
    }

    public static String getProjectPath(){
        return projectPath;
    }

    private static void setProjectPath(String input) {
        projectPath = setCommonFilePath(input);
    }

    public static String getRealPath(){
        return realPath;
    }

    private static void setRealPath(String input){
        realPath = setCommonFilePath(input);
    }

    public static String getNginxRoot(){
        return nginxRoot;
    }

    private static void setNginxRoot(String input){
        nginxRoot = setCommonFilePath(input);
    }

    private static String setCommonFilePath(String input){
        if (StringUtils.isBlank(input)) {
            return "";
        }
        // 1. 把所有 "/" 和 "\" 都先替换成当前平台的分隔符
        String normalized = input.replace("\\", File.separator)
                .replace("/", File.separator);
        // 2. 如果末尾没有分隔符，就加上一个
        if (!normalized.endsWith(File.separator)) {
            normalized = normalized + File.separator;
        }
        return normalized;
    }
}