package com.cx.kaoyi.framework.GPT.operationDTO.business;

import com.cx.kaoyi.framework.GPT.generateDTO.GeneratedQuestion;
import com.cx.kaoyi.framework.GPT.generateDTO.MainGeneratedQuestion;

public class QuestionEditInfo {

    public QuestionEditInfo(){}

    private QuestionIntelliEditAction action;
    private QuestionEditStatus status;
    private MainGeneratedQuestion mainGeneratedQuestion;
    private GeneratedQuestion generatedQuestion;

    public QuestionIntelliEditAction getAction() {
        return action;
    }

    public void setAction(QuestionIntelliEditAction action) {
        this.action = action;
    }

    public QuestionEditStatus getStatus() {
        return status;
    }

    public void setStatus(QuestionEditStatus status) {
        this.status = status;
    }

    public MainGeneratedQuestion getMainGeneratedQuestion() {
        return mainGeneratedQuestion;
    }

    public void setMainGeneratedQuestion(MainGeneratedQuestion mainGeneratedQuestion) {
        this.mainGeneratedQuestion = mainGeneratedQuestion;
    }

    public GeneratedQuestion getGeneratedQuestion() {
        return generatedQuestion;
    }

    public void setGeneratedQuestion(GeneratedQuestion generatedQuestion) {
        this.generatedQuestion = generatedQuestion;
    }
}
