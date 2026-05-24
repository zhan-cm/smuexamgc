package com.cx.kaoyi.business.controller.user;

import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.service.*;
import com.cx.kaoyi.framework.base.BaseController;


import com.cx.kaoyi.framework.cache.LocalCache;

import com.cx.kaoyi.framework.shiro.ShiroConstants;
import com.cx.kaoyi.framework.utils.PageUtils;
import com.cx.kaoyi.framework.utils.Utils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.regex.Pattern;


@Controller
@RequestMapping("/users")
public class UserController extends BaseController{

	@Autowired
	public UserService userService;
	
	@Autowired
	public PermissionService permissionService;

	@Autowired
	public CommonService commonService;
	
	@Autowired
	public SystemService systemService;
	@Autowired
	private PasswordHelper passwordHelper;
	
	//用户管理
	/**
	 * @author 黎青华
	 * 判定用户是否有添加/修改用户的权限
	 * @return
	 */
	@RequestMapping("/users")
	public String users() {
		//Subject s = getSubject();
		
		//boolean[] res = getSubject().hasRoles(Arrays.asList("administrator", "dean"));
		//for(int i=0; i<res.length; i++){
		//	if(res[i] == true){
		//		return "jsp/users/userList";
		//	}
		//}
		if(getSubject().hasRole("administrator")){
			return "jsp/users/userList";
		}
		//获取用户权限
		String rs = commonService.getTeacherHavingAddUserPermission(getUserID());
		if ("1".equals(rs)) {
			return "jsp/users/userList";
		}else{
			return "jsp/notTheRole";
		}
	}
	
	//进入添加教师页面
	@RequestMapping("/toAddUser")
	public String toAddUser() {
		User u = getUserInfo();
		if(u==null){
			return "jsp/notTheRole";
		}
		Map param = new HashMap();
		param.put("role", u.getRoleID());
		param.put("unit", u.getUnitID());
		param.put("dep", u.getDepID());
		getRequest().setAttribute("roleByUser", commonService.getRolesByUserRole(param));
		getRequest().setAttribute("userInfo", param);
		String roleID=u.getRoleID();
		// 设置是否可以分配"添加、编辑用户"权限
		// 只有只有管理员和教务人员可以分配此权限，其他角色都不能
		if("1".equals(roleID)||"2".equals(roleID)) {
			getRequest().setAttribute("canAssignEditUser", true);
		} else {
			getRequest().setAttribute("canAssignEditUser", false);
		}
		return "jsp/users/addUser";
	}
	
	//添加教师
	@RequestMapping("/addTeacher")
	public String addTeacher(User u) {
		if(Utils.checkForScriptTag(u.getUsername())||Utils.checkForScriptTag(u.getRealname())||Utils.checkForScriptTag(u.getIdcard())||Utils.checkForScriptTag(u.getEmail())||Utils.checkForScriptTag(u.getNum())||Utils.checkForScriptTag(u.getTel())) {
			getRequest().setAttribute("registerError", "非法输入！");
			return "forward:/users/toAddUser"; 
		}
		if(u.getIdcard()!=null&&!"".equals(u.getIdcard())&&!Pattern.compile("^[a-zA-Z0-9]+$").matcher(u.getIdcard()).matches()) {
			getRequest().setAttribute("registerError", "非法输入！");
			return "forward:/users/toAddUser"; 
		}
		if(u.getEmail()!=null&&!"".equals(u.getEmail())&&!Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$").matcher(u.getEmail()).matches()) {
			getRequest().setAttribute("registerError", "非法输入！");
			return "forward:/users/toAddUser"; 
		}
		if(u.getNum()!=null&&!"".equals(u.getNum())&&!Pattern.compile("^[a-zA-Z0-9]+$").matcher(u.getNum()).matches()) {
			getRequest().setAttribute("registerError", "非法输入！");
			return "forward:/users/toAddUser"; 
		}
		if(u.getTel()!=null&&!"".equals(u.getTel())&&!Pattern.compile("^(?:1[3-9]\\d{9}|0\\d{2,3}-?\\d{7,8}(?:-\\d{1,6})?)$").matcher(u.getTel()).matches()) {
			getRequest().setAttribute("registerError", "非法输入！");
			return "forward:/users/toAddUser"; 
		}
		
		u.setId(Utils.get32PrimaryKey());
		String username=u.getUsername().trim();
		if(StringUtils.isEmpty(username)){
			getRequest().setAttribute("registerError", "用户名不能为空");
			return "forward:/users/toAddUser";
		}else{
			User user = userService.findByUsername(username);
			if(user != null) {
				getRequest().setAttribute("registerError", "该用户名已被注册");
				return "forward:/users/toAddUser";
			}
		}
		if(StringUtils.isEmpty(u.getPassword())){
			getRequest().setAttribute("registerError", "密码不能为空");
			return "forward:/users/toAddUser";
		}
		if(!u.getPassword().equals(getRequest().getParameter("confirmPass"))){
			getRequest().setAttribute("registerError", "两次输入密码不一致");
			return "forward:/users/toAddUser";
		}
		if(getPara("addcourse") != null){
			Map m = new HashMap();
			m.put("tid", u.getId());
			commonService.addCoursePer(m);
		}
		if (getPara("edituser") != null) {
			userService.insertEditUser(u.getId());
		}
		userService.createUser(u);
		List<Map<String,Object>> rolePermission=permissionService.findRolePermission();
		
		String roleId=u.getRoleID();
		List<Map<String,Object>> cidList=null;
		if("3".equals(roleId)){
			cidList=userService.getCourseByUnit(u.getId());
		}else{
			cidList=userService.getCourseByDept(u.getId());
		}
		
		if(cidList.size()>0) {
			for(Map<String,Object> cmap:cidList) {
				for(Map<String,Object> rp:rolePermission){
					if(roleId.equals((String)rp.get("RID"))){
						cmap.put("pid", (String)rp.get("PID"));
						cmap.put("uid", u.getId());
						cmap.put("cid", cmap.get("CID"));
						userService.addTeacherPermission(cmap);
					}
				}
			}			
		}
		getRequest().setAttribute("users", userService.findOne(u.getId()));
		getRequest().setAttribute("courseList", userService.getCourseByUID(u.getId()));
		getRequest().setAttribute("addteacher","1");
		
		Map log = new HashMap();
		log.put("content", "添加用户-"+username+"("+u.getRealname()+")");
		log.put("cid", "");
		systemService.addSysLog(log);
		
		return "jsp/users/editPermission";
	}
	
	//更新教师权限（请细看userService.updatePermissions）
	@RequestMapping("/addPermission")
	public @ResponseBody String addPermission(@RequestBody Map map) {
		if(!getSubject().hasRole("administrator")){
			String rs = commonService.getTeacherHavingAddUserPermission(getUserID());
			if (!"1".equals(rs)) {
				return "0";
			}
		}
		
		userService.updatePermissions(map, (String)map.get("username"));
		
		User u = userService.findOne((String)map.get("uid"));
		Map log = new HashMap();
		log.put("content", "修改了用户"+u.getUsername()+"("+u.getRealname()+")的课程权限");
		log.put("cid", "");
		systemService.addSysLog(log);
		
		return "1";
	}
	
	//编辑教师权限页面(新)
	@RequestMapping("/editUserPermission")
	public String editUserPermission() {
		if(!getSubject().hasRole("administrator")){
			String rs = commonService.getTeacherHavingAddUserPermission(getUserID());
			if (!"1".equals(rs)) {
				return "jsp/notTheRole";
			}
		}
		String uid = getPara("id");
		String addteacher = getPara("addteacher");
		User u = userService.findOne(uid);
		getRequest().setAttribute("users", u);
		getRequest().setAttribute("courseList", userService.getCourseByUID(uid));
		if(addteacher!=null && addteacher!=""){
			getRequest().setAttribute("addteacher", addteacher);
		}
		getRequest().setAttribute("addteacher", addteacher);
		return "jsp/users/editPermission";
	}
	
	//加载权限表
	@RequestMapping("/editUserPermissionLoad")
	public @ResponseBody Map<String,Object> editUserPermissionLoad() {
		String uid = getPara("tid");
		String type = getPara("type");
		String cname=(getPara("cname")!=null)?getPara("cname").trim():getPara("cname");
		Map param = new HashMap();
		param.put("uid", uid);
		param.put("cname", cname);
		
		Map map=new HashMap();
		map.put("tid", uid);
		map.put("uid", getUserID());		
		map.put("cname", cname);
		if(getSubject().hasRole("administrator")){
			map.put("role", "administrator");
		}
		PageUtils pu = getPageUtil();
		
		List<Map<String,Object>> courselist = new ArrayList<Map<String,Object>>();
		String courseCount = "0";
		switch(type) {
		case "fromUser" : courselist = userService.getCourseByUID(param,pu); courseCount = userService.getCourseByUIDCount(uid); break;
		case "fromUnit" : courselist = userService.getCourseByUIDFromUnit(map,pu); courseCount = userService.getCourseByUIDFromUnitCount(map); break;
		case "fromOtherUnit" : courselist = userService.getCourseByUIDFromOtherUnit(map,pu); courseCount = userService.getCourseByUIDFromOtherUnitCount(map); break;
		}

		return getRes(courselist,courseCount);
	}

	//关闭,恢复账户
	@RequestMapping("/alterUserState")
	public @ResponseBody String alterUserState() {
		if(!getSubject().hasRole("administrator")){
			return "0";
		}
		String id = getPara("id");
		String state = getPara("state");
		String username=getPara("username");
		User user =new User();
		user.setId(id);
		user.setState(state);
		if("1".equals(state)){
			LocalCache cache = LocalCache.getInstance();
			cache.evict(ShiroConstants.RETRY_PSW_KEY, username);
		}
		int t =userService.alterUserState(user);
		Map log = new HashMap();
		if("1".equals(state)){
			log.put("content", " 恢复用户名为“"+username+"“的账号。");
		}else{
			log.put("content", " 关闭用户名为“"+username+"“的账号。");
		}
		log.put("cid", "");
		systemService.addSysLog(log);
		if(t>0) {
			return "1";
		}else{
			return "0";
		}
	}

	//编辑教师账号页面
	@RequestMapping("/editUser")
	public String editUser() {
		if(!getSubject().hasRole("administrator")){
			String rs = commonService.getTeacherHavingAddUserPermission(getUserID());
			if (!"1".equals(rs)) {
				return "jsp/notTheRole";
			}
		}
		
		String uid = getPara("id");
		User u = userService.findOne(uid);
		getRequest().setAttribute("user", u);
		getSession().setAttribute("user_toEdit",u);
		User user = getUserInfo();
		String roleID=user.getRoleID();
		// 设置是否可以分配"添加、编辑用户"权限
		// 只有只有管理员和教务人员可以分配此权限，其他角色都不能
		if("1".equals(roleID)||"2".equals(roleID)) {
			getRequest().setAttribute("canAssignEditUser", true);
		} else {
			getRequest().setAttribute("canAssignEditUser", false);
		}
		Map param = new HashMap();
		param.put("role", roleID);
		param.put("unit", u.getUnitID());
		param.put("dep", u.getDepID());
		getRequest().setAttribute("roleByUsers", commonService.getRolesByUserRole(param));
		getRequest().setAttribute("userInfo", param);
		
		List<Map<String, Object>> res = userService.getUserPermission(uid);
		if(res.size()>0){
			for (int i = 0; i < res.size(); i++) {
				if ("14".equals(res.get(i).get("PID"))) {
					getRequest().setAttribute("coursemark", "1");
				} else if ("40".equals(res.get(i).get("PID"))) {
					getRequest().setAttribute("usermark", "1");
				}
			}
		}
		//改动结束
		return "jsp/users/editUser";
	}

	//更新教师账号
	@RequestMapping("/updateTeacher")
	public String updateTeacher(User u) {
		String username=u.getUsername()==null?"":u.getUsername().trim();
		String realname=u.getRealname()==null?"":u.getRealname().trim();
		String idcard=u.getIdcard()==null?"":u.getIdcard().trim();
		String email=u.getEmail()==null?"":u.getEmail().trim();
		String num=u.getNum()==null?"":u.getNum().trim();
		String tel=u.getTel()==null?"":u.getTel().trim();
		if(Utils.checkForScriptTag(username)||Utils.checkForScriptTag(realname)||Utils.checkForScriptTag(idcard)||Utils.checkForScriptTag(email)||Utils.checkForScriptTag(num)||Utils.checkForScriptTag(tel)) {
			getRequest().setAttribute("registerError", "非法输入！");
			return "forward:/users/toAddUser"; 
		}
		if(!"".equals(idcard)&&!Pattern.compile("^[a-zA-Z0-9]+$").matcher(idcard).matches()) {
			getRequest().setAttribute("registerError", "非法输入！");
			return "forward:/users/toAddUser"; 
		}
		if(!"".equals(email)&&!Pattern.compile("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$").matcher(email).matches()) {
			getRequest().setAttribute("registerError", "非法输入！");
			return "forward:/users/toAddUser"; 
		}
		if(!"".equals(num)&&!Pattern.compile("^[a-zA-Z0-9]+$").matcher(num).matches()) {
			getRequest().setAttribute("registerError", "非法输入！");
			return "forward:/users/toAddUser"; 
		}
		if(!"".equals(tel)&&!Pattern.compile("^(?:1[3-9]\\d{9}|0\\d{2,3}-?\\d{7,8}(?:-\\d{1,6})?)$").matcher(tel).matches()) {
			getRequest().setAttribute("registerError", "非法输入！");
			return "forward:/users/toAddUser"; 
		}
		getRequest().removeAttribute("user");
		User user_toEdit=(User)getSession().getAttribute("user_toEdit");
		if(user_toEdit==null||!user_toEdit.getUsername().equals(u.getUsername())){
			getRequest().setAttribute("flag", "error");
			getRequest().setAttribute("updateError", "非法操作！");
			return "forward:/users/editUser";
		}
		if("1".equals(u.getRoleID())) {
			if(!getSubject().hasRole("administrator")) {
				getRequest().setAttribute("flag", "error");
				getRequest().setAttribute("updateError", "非法操作！");
				return "forward:/users/editUser";
			}
		}
		if((getSubject().hasRole("administrator") || getSubject().hasRole("dean")) && u.getPassword()!=null&&!"".equals(u.getPassword())){
			String password=u.getPassword();
			String pass_switch=(String)getApplication().getAttribute("pass_switch");
			if("1".equals(pass_switch)){
				if (!(password.length()>=8&&(password.matches(".*[a-z]{1,}.*") || password.matches(".*[A-Z]{1,}.*"))&& password.matches(".*\\d{1,}.*")&&password.matches(".*[~！!@#$%^&*()_+|<>,.?/:;'\\[\\]{}\"\\-]+.*"))) {
					getRequest().setAttribute("flag", "error");
					getRequest().setAttribute("updateError", "密码强度过弱，密码必须包含字母、数字和特殊符号，且不少于8个字符！");
					return "forward:/users/editUser";
				}
				//密码不能包含用户名
				if(password.contains(u.getUsername())){
					getRequest().setAttribute("flag", "error");
					getRequest().setAttribute("updateError", "密码不可包含用户名！");
					return "forward:/users/editUser";
				}
			}else{
				if (!(password.length()>5&&(password.matches(".*[a-z]{1,}.*") || password.matches(".*[A-Z]{1,}.*"))&& password.matches(".*\\d{1,}.*"))) {
					getRequest().setAttribute("flag", "error");
					getRequest().setAttribute("updateError", "密码强度过弱，密码必须包含字母和数字，且不少于6个字符！");
					return "forward:/users/editUser";
				}
			}
			passwordHelper.encryptPassword(u);
		}

		if(getPara("addcourse") != null){
			commonService.insertAddCourse(u.getId(),u.getUsername());
		}else{
			commonService.delAddCoursePer(u.getId(),u.getUsername());
		}
		if (getPara("edituser") != null) {
			//复选框被选中时添加权限
			userService.insertEditUser(u.getId());
		}else {
			//复选框没选中时删除权限
			userService.delEditUser(u.getId());
		}
		LocalCache cache = LocalCache.getInstance();
		cache.evict(ShiroConstants.RETRY_PSW_KEY, u.getUsername());
		cache.evict("permissions", "up_" + u.getId() + "_40");
		cache.evict("permissions", "up_" + u.getId() + "_p14");
		cache.evict("roles",u.getUsername());
		//查看用户是否有权限
		List<Map<String, Object>> res = userService.getUserPermission(u.getId());
		if(res.size()>0){
			for (int i = 0; i < res.size(); i++) {
				if ("14".equals(res.get(i).get("PID"))) {
					getRequest().setAttribute("coursemark", "1");
				} else if ("40".equals(res.get(i).get("PID"))) {
					getRequest().setAttribute("usermark", "1");
				}
			}
		}

		userService.updateUser(u);
		
		User newest = userService.findOne(u.getId());
		getRequest().setAttribute("users", newest);
		getRequest().setAttribute("flag", "success");	
		getRequest().setAttribute("message", "更新成功");	
		
		Map log = new HashMap();
		log.put("content", "更改用户"+newest.getUsername()+"("+newest.getRealname()+")权限或密码");
		log.put("cid", "");
		systemService.addSysLog(log);
	
		return "forward:/users/editUser";
	}	

	//从本学院添加课程权限页面
	@RequestMapping("/addPerFromUnit")
	public String addPerFromUnit() {
		if(!getSubject().hasRole("administrator")){
			String rs = commonService.getTeacherHavingAddUserPermission(getUserID());
			if (!"1".equals(rs)) {
				return "jsp/notTheRole";
			}
		}
		
		String uid = getPara("id");
		User u = userService.findOne(uid);
		getRequest().setAttribute("users", u);
		Map param = new HashMap();
		param.put("tid", uid);
		param.put("uid", getUserID());
		if(getSubject().hasRole("administrator")){
			param.put("role", "administrator");
		}
		getRequest().setAttribute("courseList", userService.getCourseByUIDFromUnit(param));
		getRequest().setAttribute("paperPermissions", permissionService.getPaperPermission4Course());
		return "jsp/users/addPermissionFromUnit";
	}	

	//跨学院添加课程权限
	@RequestMapping("/addPerFromOtherUnit")
	public String addPerFromOtherUnit() {
		String uid = getPara("id");
		User u = userService.findOne(uid);
		getRequest().setAttribute("users", u);
		Map param = new HashMap();
		param.put("tid", uid);
		param.put("uid", getUserID());
		if(getSubject().hasRole("administrator")){
			param.put("role", "administrator");
		}
		getRequest().setAttribute("courseList", userService.getCourseByUIDFromOtherUnit(param));
		return "jsp/users/addPermissionFromOtherUnit";
	}

	
	/**
	 * datagrid加载这个页面，实现分页
	 *   徐维
	 * */
	@RequestMapping("/addPerFromUnitLoad")
	public List<Map<String,Object>> addPerFromUnitLoad() {
		String uid = getPara("id");
		Map param = new HashMap();
		param.put("tid", uid);
		param.put("uid", getUserID());
		if(getSubject().hasRole("administrator")){
			param.put("role", "administrator");
		}
		List<Map<String,Object>> courselist = userService.getCourseByUIDFromUnit(param);
		return courselist;	
	}
	
	@RequestMapping("/addPerFromOtherUnitLoad")
	public List<Map<String,Object>> addPerFromOtherUnitLoad() {
		String uid = getPara("id");
		Map param = new HashMap();
		param.put("tid", uid);
		param.put("uid", getUserID());
		if(getSubject().hasRole("administrator")){
			param.put("role", "administrator");
		}
		List<Map<String,Object>> courselist = userService.getCourseByUIDFromOtherUnit(param);
		return courselist;		
	}
	
	
	
	/**
	 * 获取用户列表，使用者：后台人员管理列表
	 * @author 洪艳
	 * 黎青华，添加用户搜索功能
	 * @return Map<String, Object>
	 */
	@RequestMapping("/getUserList")
	public @ResponseBody Map<String, Object> getUserList() {
		User user = getUserInfo();
		Map param = new HashMap();
		if(user==null){
			return param;
		}
		param.put("uname", (getPara("uname")!=null)?getPara("uname").trim():"");
		param.put("unitid", getPara("unitid"));
		param.put("roleid", getPara("roleid"));
		param.put("depid", getPara("depid"));
		param.put("rname", getPara("rname"));
		param.put("search", getPara("search"));
		param.put("uid", user.getId());
		param.put("username", user.getUsername());
		param.put("role", user.getRoleID());
		return getRes(userService.getUserList(param,getPageUtil()), userService.getTeacherCount(param));
	}

	@RequestMapping("/inUserInfo")
	public String userInfo() {
		User user = getUserInfo();
		User u = userService.findOne(user.getId());
		getRequest().setAttribute("users", u);
		return "jsp/users/inUserInfo";
	}
	
	/**
	 * 更新个人信息
	 * @author 黎青华
	 */
	@RequestMapping("/updateUserInfo")
	public String updateInfo() {
		if(getUserInfo()==null){
			return "jsp/notTheRole";
		}
		User u=new User();
		u.setId(getUserID());
		u.setRealname(getPara("realname"));
		u.setUsername(getPara("username"));
		u.setIdcard(getPara("idcard"));
		u.setNum(getPara("num"));
		u.setPassword(getPara("password"));
		u.setEmail(getPara("email"));
		u.setState(getPara("state"));
		//u.setLoginTime(getPara("loginTime"));
		u.setUnitID(getPara("unitID"));
		u.setRoleID(getPara("roleID"));
		u.setDepID(getPara("depID"));	
		/*if(StringUtils.isEmpty(u.getPassword())){
			getRequest().setAttribute("updateError", "密码不能为空");
			return "jsp/users/inUserInfo";
		}
		if(!u.getPassword().equals(getPara("confirmPass"))){
			getRequest().setAttribute("updateError", "两次输入密码不一致");
			return "jsp/users/inUserInfo";
		}*/
		userService.updateUser(u);
		getRequest().setAttribute("updateError", "更新成功");
		return "forward:/users/inUserInfo";
	}
	
	@RequestMapping("/inEditPassword")
	public String inEditPassword() {
		User user = getUserInfo();
		User u = userService.findOne(user.getId());
		getRequest().setAttribute("users", u);
		return "jsp/users/inEditPassword";
	}
	
	/**
	 * 修改个人密码
	 * @return
	 */
	@RequestMapping("/updateUserPassword")
	public String updateUserPassword(User u) {
		User user = getUserInfo();
		u.setUsername(user.getUsername());
		if(StringUtils.isEmpty(u.getPassword())){
			getRequest().setAttribute("updateError", "密码不能为空");
			return "jsp/users/inEditPassword";
		}
		if(!u.getPassword().equals(getPara("confirmPass"))){
			getRequest().setAttribute("updateError", "两次输入密码不一致");
			return "jsp/users/inEditPassword";
		}
		String password=u.getPassword();
		String pass_switch=(String)getApplication().getAttribute("pass_switch");
		if("1".equals(pass_switch)){
			if (!(password.length()>=8&&(password.matches(".*[a-z]{1,}.*") || password.matches(".*[A-Z]{1,}.*"))&& password.matches(".*\\d{1,}.*")&&password.matches(".*[~-！!@#$%^&*()_+|<>,.?/:;'\\[\\]{}\"\\-]+.*"))) {
				getRequest().setAttribute("updateError", "密码强度过弱，密码必须包含字母、数字和特殊符号，且不少于8个字符！");
				return "jsp/users/inEditPassword";
			}
			//密码不能包含用户名
			if(password.contains(u.getUsername())){
				getRequest().setAttribute("updateError", "密码不可包含用户名！");
				return "jsp/users/inEditPassword";
			}
		}else{
			if (!(password.length()>5&&(password.matches(".*[a-z]{1,}.*") || password.matches(".*[A-Z]{1,}.*"))&& password.matches(".*\\d{1,}.*"))) {
				getRequest().setAttribute("updateError", "密码强度过弱，密码必须包含字母和数字，且不少于6个字符！");
				return "jsp/users/inEditPassword";
			}
		}

		passwordHelper.encryptPassword(u);
		userService.updateUser(u);
		getRequest().setAttribute("updateError", "更新成功");
		return "forward:/users/inEditPassword";
	}
	
	/**
	 * 重置密码，生成的密码为8位随机密码
	 * resetPassword
	 * @return
	 */
	@RequestMapping("/resetPassword")
	public @ResponseBody Map<String, Object> resetPassword() {
		Map<String, Object> rs = new HashMap();
		if (getSubject().hasRole("administrator") || getSubject().hasRole("dean")|| getSubject().hasRole("teachingoffice") || getSubject().hasRole("secretary")) {
			String password = "";
			char[] charr = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@#$%^&*~_".toCharArray();
			Random random = new Random();
			for(int i=0;i<10;i++){
				String verificationCode = "";
				for (int j = 0; j <8; j++) {
					verificationCode+=charr[random.nextInt(charr.length)];
				}
				if(verificationCode.matches(".*[a-z]{1,}.*") && verificationCode.matches(".*[A-Z]{1,}.*")&& verificationCode.matches(".*\\d{1,}.*")&&verificationCode.matches(".*[~-！!@#$%^&*()_+|<>,.?/:;'\\[\\]{}\"\\-]+.*")){
					password=verificationCode;
					break;
				}
			}
			if("".equals(password)){
				StringBuilder sb=new StringBuilder();
				for(int i=0;i<2;i++) {
					int a = Math.abs(new Random().nextInt(6));
					sb.append((char) (a + 33));
				}
				for(int i=0;i<2;i++) {
					int a = Math.abs(new Random().nextInt(9));
					sb.append((char) (a + 48));
				}
				for(int i=0;i<2;i++) {
					int a = Math.abs(new Random().nextInt(24));
					sb.append((char) (a + 65));
				}
				for(int i=0;i<2;i++) {
					int a = Math.abs(new Random().nextInt(24));
					sb.append((char) (a + 97));
				}
				password=sb.toString();
			}

			String uid = getPara("uid");
			User user = userService.findOne(uid);
			
			user.setPassword(password);
			//user.setEmail_lock(0);
			passwordHelper.encryptPassword(user);
			userService.updateUser(user);
			rs.put("type", "success");
			rs.put("rname", user.getRealname());
			rs.put("password", password);
			
			Map log = new HashMap();
			log.put("content", "重置了用户"+user.getUsername()+"（"+user.getRealname()+"）的密码");
			log.put("cid", 0);
			systemService.addSysLog(log);
			LocalCache cache = LocalCache.getInstance();
			cache.evict(ShiroConstants.RETRY_PSW_KEY, user.getUsername());
		}else {
			rs.put("type", "fail");
		}
		return rs;
	}
	
	@RequestMapping("/unlockEmail")
	public @ResponseBody Map<String, Object> unlockEmail() {
		Map<String, Object> rs = new HashMap();
		if (getSubject().hasRole("administrator") || getSubject().hasRole("dean")|| getSubject().hasRole("teachingoffice")) {
			String uid = getPara("uid");
			User user = userService.findOne(uid);
			
			rs.put("type", "success");
			rs.put("rname", user.getRealname());
			userService.updateUserEmail_lock(uid);
			
			Map log = new HashMap();
			log.put("content", "解锁了用户"+user.getUsername()+"（"+user.getRealname()+"）的邮箱");
			log.put("cid", 0);
			systemService.addSysLog(log);
			
		}else {
			rs.put("type", "fail");
		}
		return rs;
	}
	
	@RequestMapping("/delUser")
	public @ResponseBody String delUser() {
		String uid = getPara("uid");
		User u = userService.findOne(uid);
		
		if(getSubject().hasRole("administrator")) {
			//删除与该用户相关的所有权限			
			userService.deleteUser(uid);
			
			Map log = new HashMap();
			log.put("content", "删除了用户"+u.getUsername()+"("+u.getRealname()+")。");
			log.put("cid", "");
			systemService.addSysLog(log);
			
			return "1"; //删除成功
		}else{
			return "-1";  //无权限
		}
	}
    
    @RequestMapping("/getUsersByName")
    public @ResponseBody List<Map<String, Object>> getUsersByName(){
    	return userService.getUsersByName((getPara("name") !=null)?getPara("name").trim():getPara("name"));
    }
}
