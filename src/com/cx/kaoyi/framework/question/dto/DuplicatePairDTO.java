package com.cx.kaoyi.framework.question.dto;

public class DuplicatePairDTO {

    private ExampaperQuestionInRepeat origin;

    /** 三年窗口内 top1 */
    private ExampaperQuestionInRepeat duplicate;
    private double score;

    public DuplicatePairDTO() {}

    public DuplicatePairDTO(ExampaperQuestionInRepeat origin,
                            ExampaperQuestionInRepeat duplicate,
                            double score) {
        this.origin = origin;
        this.duplicate = duplicate;
        this.score = score;
    }

    public ExampaperQuestionInRepeat getOrigin() {
        return origin;
    }

    public void setOrigin(ExampaperQuestionInRepeat origin) {
        this.origin = origin;
    }

    public ExampaperQuestionInRepeat getDuplicate() {
        return duplicate;
    }

    public void setDuplicate(ExampaperQuestionInRepeat duplicate) {
        this.duplicate = duplicate;
    }

    public double getScore() {
        return score;
    }

    public void setScore(double score) {
        this.score = score;
    }
}