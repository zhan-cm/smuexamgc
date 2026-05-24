package com.cx.kaoyi.framework.GPT.generateDTO;

import java.util.List;

public class MainGeneratedQuestion {
    public MainGeneratedQuestion(){}

    private String qtype; //题型
    private String content;   // 题目内容
    private List<GeneratedQuestion> questionList;

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

    public List<GeneratedQuestion> getQuestionList() {
        return questionList;
    }

    public void setQuestionList(List<GeneratedQuestion> questionList) {
        this.questionList = questionList;
    }
}
