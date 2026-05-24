package com.cx.kaoyi.business.domain;

import java.io.Serializable;
import java.util.Date;

public class Student implements Serializable {
	private String id; // 学生ID
	private String name; // 学生姓名
	private String num; // 学生学号
	private String klassid; // 学生班级ID
	private String klass; // 学生班级
	private String specialtyid; // 学生专业ID
	private String specialty; // 学生专业
	private String grade; // 学生入学年级
	private String pass; // 学生登陆密码
	private String tel; // 联系电话
	private String email; //邮箱地址
	private int selftesttime; //自考次数
	private Boolean state = Boolean.TRUE; // 学生状态
	private Date logintime; // 学生登录时间
	private String ip; // 学生登录IP
	private String salt; // 盐
	private String onlineid; //  
	private String specialty_name;
	private String grade_name;
	private String xxdh;
	private String idcard;
	private String wxphone;
	private String wxunionid;
	private String device;

	public String getWxPhone() {
		return wxphone;
	}

	public void setWxPhone(String wxphone) {
		this.wxphone = wxphone;
	}

	public String getDevice(){
		return device;
	}

	public void setDevice(String device){
		this.device = device;
	}

	public String getWxUnionID() {
		return wxunionid;
	}

	public void setWxUnionID(String wxunionid) {
		this.wxunionid = wxunionid;
	}

	public String getIdcard() {
		return idcard;
	}

	public void setIdcard(String idcard) {
		this.idcard = idcard;
	}
	
	public String getXxdh() {
		return xxdh;
	}

	public void setXxdh(String xxdh) {
		this.xxdh = xxdh;
	}

	public String getSpecialty_name() {
		return specialty_name;
	}

	public void setSpecialty_name(String specialty_name) {
		this.specialty_name = specialty_name;
	}

	public String getGrade_name() {
		return grade_name;
	}

	public void setGrade_name(String grade_name) {
		this.grade_name = grade_name;
	}

	public String getOnlineid() {
		return onlineid;
	}

	public void setOnlineid(String onlineid) {
		this.onlineid = onlineid;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getKlassid() {
		return klassid;
	}

	public void setKlassid(String klassid) {
		this.klassid = klassid;
	}

	public String getKlass() {
		return klass;
	}

	public void setKlass(String klass) {
		this.klass = klass;
	}

	public String getSpecialtyid() {
		return specialtyid;
	}

	public void setSpecialtyid(String specialtyid) {
		this.specialtyid = specialtyid;
	}

	public String getSpecialty() {
		return specialty;
	}

	public void setSpecialty(String specialty) {
		this.specialty = specialty;
	}
	
	public String getGrade() {
		return grade;
	}

	public void setGrade(String grade) {
		this.grade = grade;
	}

	public String getPass() {
		return pass;
	}

	public void setPass(String pass) {
		this.pass = pass;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public Boolean getState() {
		return state;
	}

	public void setState(Boolean state) {
		this.state = state;
	}

	public Date getLogintime() {
		return logintime;
	}

	public void setLogintime(Date logintime) {
		this.logintime = logintime;
	}

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getSalt() {
		return salt;
	}

	public void setSalt(String salt) {
		this.salt = salt;
	}

	public String getCredentialsSalt() {
		return name + salt;
	}
	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public int getSelftesttime() {
		return selftesttime;
	}

	public void setSelftesttime(int selftesttime) {
		this.selftesttime = selftesttime;
	}

	@Override
	public String toString() {
		return "Student [id=" + id + ", name=" + name + ", num=" + num + ", klassid=" + klassid + ", klass=" + klass
				+ ", specialtyid=" + specialtyid + ", specialty=" + specialty + ", grade=" + grade + ", pass=" + pass
				+ ", tel=" + tel + ", state=" + state + ", logintime=" + logintime + ", ip=" + ip + ", salt=" + salt
				+ ", onlineid=" + onlineid + ", wxunionid=" + wxunionid +", device=" + device
				+ ", wxphone=" + wxphone + "]";
	}


}
