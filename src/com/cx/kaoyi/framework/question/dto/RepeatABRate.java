package com.cx.kaoyi.framework.question.dto;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class RepeatABRate {
    private BigDecimal paperScoreRate4AIn3Years;
    private BigDecimal paperNumRateAIn3Years;
    private BigDecimal paperScoreRate4BIn3Years;
    private BigDecimal paperNumRateBIn3Years;
    private BigDecimal paperRate4AB;//A、B卷重复分值比例
    private BigDecimal paperNum4AB;//A、B卷重复题目数量

    public static RepeatABRate buildEmptyObj(){
        RepeatABRate empty = new RepeatABRate();
        empty.setPaperNumRateAIn3Years(BigDecimal.ZERO);
        empty.setPaperNumRateBIn3Years(BigDecimal.ZERO);
        empty.setPaperScoreRate4AIn3Years(BigDecimal.ZERO);
        empty.setPaperScoreRate4BIn3Years(BigDecimal.ZERO);
        empty.setPaperRate4AB(BigDecimal.ZERO);
        empty.setPaperNum4AB(BigDecimal.ZERO);
        return empty;
    }

    public BigDecimal getPaperScoreRate4AIn3Years() {
        return paperScoreRate4AIn3Years;
    }

    public void setPaperScoreRate4AIn3Years(BigDecimal paperScoreRate4AIn3Years) {
        this.paperScoreRate4AIn3Years = paperScoreRate4AIn3Years;
    }

    public BigDecimal getPaperNumRateAIn3Years() {
        return paperNumRateAIn3Years;
    }

    public void setPaperNumRateAIn3Years(BigDecimal paperNumRateAIn3Years) {
        this.paperNumRateAIn3Years = paperNumRateAIn3Years;
    }

    public BigDecimal getPaperScoreRate4BIn3Years() {
        return paperScoreRate4BIn3Years;
    }

    public void setPaperScoreRate4BIn3Years(BigDecimal paperScoreRate4BIn3Years) {
        this.paperScoreRate4BIn3Years = paperScoreRate4BIn3Years;
    }

    public BigDecimal getPaperNumRateBIn3Years() {
        return paperNumRateBIn3Years;
    }

    public void setPaperNumRateBIn3Years(BigDecimal paperNumRateBIn3Years) {
        this.paperNumRateBIn3Years = paperNumRateBIn3Years;
    }

    public BigDecimal getPaperRate4AB() {
        return paperRate4AB;
    }

    public void setPaperRate4AB(BigDecimal paperRate4AB) {
        this.paperRate4AB = paperRate4AB;
    }

    public BigDecimal getPaperNum4AB() {
        return paperNum4AB;
    }

    public void setPaperNum4AB(BigDecimal paperNum4AB) {
        this.paperNum4AB = paperNum4AB;
    }

    public String getPaperScoreRate4AIn3YearsPercent() {
        return toPercentString(paperScoreRate4AIn3Years);
    }

    public String getPaperNumRateAIn3YearsPercent() {
        return toPercentString(paperNumRateAIn3Years);
    }

    public String getPaperScoreRate4BIn3YearsPercent() {
        return toPercentString(paperScoreRate4BIn3Years);
    }

    public String getPaperNumRateBIn3YearsPercent() {
        return toPercentString(paperNumRateBIn3Years);
    }

    public String getPaperRate4ABPercent() {
        return toPercentString(paperRate4AB);
    }

    // 约定：原值是比例（0.3015 -> 30.15%）
    private String toPercentString(BigDecimal rate) {
        if (rate == null) {
            return null;
        }
        BigDecimal percent = rate
                .multiply(new BigDecimal("100"))
                .setScale(2, RoundingMode.HALF_UP);
        return percent.toPlainString() + "%";
    }
}