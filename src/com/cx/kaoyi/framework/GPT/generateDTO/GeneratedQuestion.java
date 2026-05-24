package com.cx.kaoyi.framework.GPT.generateDTO;

import java.util.List;
import java.util.Map;

public class GeneratedQuestion {

    public GeneratedQuestion(){}

    private String qtype; //题型
    private String content;   // 题目内容
    private String answer;    // 标准答案
    private List<Map<String, String>> answerList; // 选项列表
    private String explain;   // 答案解析

    public String getQtype() {
        return qtype;
    }

    public void setQtype(String qtype) {
        this.qtype = qtype;
    }

    public String getContent() {
        return content;
    }

    public void setContent(String content) {
        this.content = content;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public List<Map<String, String>> getAnswerList() {
        return answerList;
    }

    public void setAnswerList(List<Map<String, String>> answerList) {
        this.answerList = answerList;
    }

    public String getExplain() {
        return explain;
    }

    public void setExplain(String explain) {
        this.explain = explain;
    }
}
