package com.cx.kaoyi.business.domain;

import java.io.Serializable;
import java.util.Date;
import java.util.Set;

public class User implements Serializable {
	private String id; // 教师ID
	private String realname; // 教师姓名
	private String username; // 教师注册用户名
	private String num; // 教师工作证号
	private String password; // 登陆密码
	private String tel; // 联系电话
	private String email; // email邮箱
	private String unitID; // 所属单位ID
	private String unit; // 所属单位
	private String depID; // 所属科室ID
	private String dep; // 所属科室
	private Date loginTime; // 教师登录时间
	private String salt; // 盐
	private String roleID; // 所含角色ID
	private String role; // 所含角色
	private String role_cname;//角色中文名
	private Set<String> cIDs; // 课程ID
	private Set<String> pCIDs; //可添加试卷的课程ID
	private String state; // 用户状态
	private String ip;
	private Integer email_lock;
	private String idcard; // 身份证号
	private String uniqid;
	private String wxunionid;
	private String wxphone;
	private String employee_num;
	private String device;

	public Set<String> getpCIDs() {
		return pCIDs;
	}

	public void setpCIDs(Set<String> pCIDs) {
		this.pCIDs = pCIDs;
	}
	
	public Integer getEmail_lock() {
		return email_lock;
	}

	public void setEmail_lock(Integer email_lock) {
		this.email_lock = email_lock;
	}
	
	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}

	public String getRole_cname() {
		return role_cname;
	}

	public void setRole_cname(String role_cname) {
		this.role_cname = role_cname;
	}

	public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getDep() {
		return dep;
	}

	public void setDep(String dep) {
		this.dep = dep;
	}

	public String getUnit() {
		return unit;
	}

	public void setUnit(String unit) {
		this.unit = unit;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getRealname() {
		return realname;
	}

	public void setRealname(String realname) {
		this.realname = realname;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getNum() {
		return num;
	}

	public void setNum(String num) {
		this.num = num;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public String getTel() {
		return tel;
	}

	public void setTel(String tel) {
		this.tel = tel;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getUnitID() {
		return unitID;
	}

	public void setUnitID(String unitID) {
		this.unitID = unitID;
	}

	public String getDepID() {
		return depID;
	}

	public void setDepID(String depID) {
		this.depID = depID;
	}

	public Date getLoginTime() {
		return loginTime;
	}

	public void setLoginTime(Date loginTime) {
		this.loginTime = loginTime;
	}

	public String getSalt() {
		return salt;
	}

	public void setSalt(String salt) {
		this.salt = salt;
	}

	public String getRoleID() {
		return roleID;
	}

	public void setRoleID(String roleID) {
		this.roleID = roleID;
	}

	public Set<String> getcIDs() {
		return cIDs;
	}

	public void setcIDs(Set<String> cIDs) {
		this.cIDs = cIDs;
	}

	public String getState() {
		return state;
	}

	public void setState(String state) {
		this.state = state;
	}

	public String getCredentialsSalt() {
		return username + salt;
	}
	
	public String getIdcard() {
		return idcard;
	}

	public void setIdcard(String idcard) {
		this.idcard = idcard;
	}
	
	public String getUniqid() {
		return uniqid;
	}

	public void setUniqid(String uniqid) {
		this.uniqid = uniqid;
	}

	public String getWxUnionID() {
		return wxunionid;
	}

	public void setWxUnionID(String wxunionid) {
		this.wxunionid = wxunionid;
	}

	public String getWxPhone() {
		return wxphone;
	}

	public void setWxPhone(String wxphone) {
		this.wxphone = wxphone;
	}

	public String getEmployee_num(){
		return employee_num;
	}

	public void setEmployee_num(String employee_num){
		this.employee_num = employee_num;
	}

	public String getDevice(){
		return device;
	}

	public void setDevice(String device){
		this.device = device;
	}

	@Override
	public String toString() {
		return "User [id=" + id + ", realname=" + realname + ", username=" + username + ", num=" + num + ", password="
				+ password + ", tel=" + tel + ", email=" + email + ", unitID=" + unitID + ", unit=" + unit + ", depID="
				+ depID + ", dep=" + dep + ", loginTime=" + loginTime + ", salt=" + salt + ", roleID=" + roleID
				+ ", role=" + role + ", uniqid=" + uniqid + ", cIDs=" + cIDs + ", idcard=" + idcard + ", state=" + state
				+ ", device=" + device + ", wxphone=" + wxphone + ", wxunionid=" + wxunionid + "]";
	}

}
