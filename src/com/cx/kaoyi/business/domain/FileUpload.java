package com.cx.kaoyi.business.domain;

public class FileUpload {
	private String qid;
	private String cid;
	private String eid;
	private String num;
	private String fileChange;
	private String filepath_old;

	public String getCid() {
		return cid;
	}

	public void setCid(String cid) {
		this.cid = cid;
	}

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getQid() {
		return qid;
	}

	public void setQid(String qid) {
		this.qid = qid;
	}

	public String getEid() {
		return eid;
	}

	public void setEid(String eid) {
		this.eid = eid;
	}

	public String getFileChange() {
		return fileChange;
	}

	public void setFileChange(String fileChange) {
		this.fileChange = fileChange;
	}

	public String getFilepath_old() {
		return filepath_old;
	}

	public void setFilepath_old(String filepath_old) {
		this.filepath_old = filepath_old;
	}
}
