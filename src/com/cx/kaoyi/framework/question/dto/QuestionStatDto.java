package com.cx.kaoyi.framework.question.dto;

public class QuestionStatDto {
    private int eid;
    private int qid;

    /** 三年窗口内出现次数 */
    private int count3Year;

    public int getEid() { return eid; }
    public void setEid(int eid) { this.eid = eid; }

    public int getQid() { return qid; }
    public void setQid(int qid) { this.qid = qid; }

    public int getCount3Year() {
        return count3Year;
    }

    public void setCount3Year(int count3Year) {
        this.count3Year = count3Year;
    }
}