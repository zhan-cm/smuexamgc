package com.cx.kaoyi.business.controller.common;

import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.service.CommonService;
import com.cx.kaoyi.business.service.UserService;
import com.cx.kaoyi.framework.base.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

//普通类
@Controller
@RequestMapping("/common")
public class CommonController extends BaseController{

	@Autowired
	public CommonService commonService;
	
	@Autowired
	public UserService userService;
	
	//获取菜单
	@RequestMapping("/getMenus")
	public @ResponseBody List<Map<String, Object>> getMenus(){
		User user = getUserInfo();
		if(user==null){
			return new ArrayList<>();
		}
		Map param = new HashMap();
		param.put("roleID", user.getRoleID());
		
		if(!getSubject().hasRole("administrator")){
//			if(getSubject().hasRole("dean")) {
//				param.put("sys", 1);//教务处人员
//			}else {
//				param.put("sys", 0);//普通教师
//			}
			
//			String rs = commonService.getTeacherHavingAddUserPermission(user.getId());
//			if ("1".equals(rs)) {
//				param.put("editUser", "1");
//			}else{
//				param.put("editUser", "0");
//			}
			List<Map<String,Object>> list=commonService.getAddUser_coursePermission(user.getId());
			boolean addCourse=false;
			boolean editUser=false;
			if(list!=null&&list.size()>0){
				for(Map<String,Object> mm:list){
					if("14".equals(String.valueOf(mm.get("PID")))){
						addCourse=true;
					}
					if("40".equals(String.valueOf(mm.get("PID")))){
						editUser=true;
					}
				}
			}
			if(!addCourse){
				param.put("addCourse", "0");
			}
			if(!editUser){
				param.put("editUser", "0");
			}
		}else{
			param.put("editUser", "1");//是否可编辑用户
			param.put("sys", 2);//超级管理员
		}
		return commonService.getMenus(param);
	}
	
	//获取根据题型获取答案类型
	//黎青华修改，查询的表由questiontype改为course_questiontype
	@RequestMapping("/getAnswerType")
	public @ResponseBody Map<String, Object> getAnswerType(){
		Map<String, Object> map = new HashMap<>();
		String qtid = getPara("qtid");
		String cid = getPara("cid");
		map.put("qtid", qtid);
		map.put("cid", cid);
		return commonService.getAnswerType(map);
	}

	//获取科室列表
	@RequestMapping("/getDepartment")
	public @ResponseBody List<Map<String, Object>> getDepartment(){
		String unitid = getPara("unitid");
		Map<String, Object> m = new HashMap<>();
		m.put("ID", null);
		m.put("NAME", "科室不限");
		List<Map<String, Object>> res = commonService.getDeptList(unitid);
		res.add(0,m);
		return res;
	}
	
	//获取单位列表
	@RequestMapping("/getUnit")
	public @ResponseBody List<Map<String, Object>> getUnit(){
		Map<String, Object> m = new HashMap<>();
		m.put("ID", null);
		m.put("NAME", "单位不限");
		List<Map<String, Object>> res;
		if(getApplication().getAttribute("unitList")!=null){ //要浅拷贝，否则下面添加元素会影响原数组
			res = new ArrayList<>(((List<Map<String, Object>>) getApplication().getAttribute("unitList")));
		}else {
			res = commonService.defaultUnit();
		}

		res.add(0,m);
		return res;
	}
	
	/**
	 * 获取角色的中文名称，使用者：后台人员管理列表
	 * @author 洪艳
	 * @return List<Map<String, Object>>，包含了角色id和角色cname
	 */
	@RequestMapping("/getRole")
	public @ResponseBody List<Map<String, Object>> getRole(){
		Map<String, Object> m = new HashMap<>();
		m.put("ID", null);
		m.put("NAME", "角色不限");
		List<Map<String, Object>> res;
		if(getSubject().hasRole("administrator")){
			res = commonService.defaultRole();
		}else{
			User u = getUserInfo();
			Map param = new HashMap();
			param.put("role", u.getRoleID());
			res = commonService.getRolesByUserRole_2(param);
		}
//		List<Map<String, Object>> res = commonService.defaultRole();
		
		res.add(0,m);
		return res;
	}
	
	/**
	 * 课程，试卷，试题权限(init的权限值因缺失""在页面转json太麻烦)
	 */
	@RequestMapping("/getPermission")
	public @ResponseBody Map<String, Object> getPermission(){
		Map<String, Object> res = new HashMap<>();
		res.put("cp", getApplication().getAttribute("coursePermissions"));		
		res.put("qp", getApplication().getAttribute("questionPermissions"));
		res.put("pp", getApplication().getAttribute("paperPermissions"));
		//非超级管理员权限
		String cid =getPara("cid");
		Map map = new HashMap();
		map.put("tid", getUserInfo().getId());
		map.put("cid", cid);
		//用户在该课程下的所有权限
		List<String>  list = userService.getPermissionsCid(map);
		List<String>  list_cp = userService.getPermissionIdByType("course");
		List<String>  list_qp = userService.getPermissionIdByType("question");
		List<String>  list_pp = userService.getPermissionIdByType("paper");
		list_cp.retainAll(list);
		list_qp.retainAll(list);
		list_pp.retainAll(list);
		map.put("type", "course");
		map.put("list", list_cp);
		res.put("cp",userService.getPermissionsByType(map));
		map.put("type", "question");
		map.put("list", list_qp);
		res.put("qp", userService.getPermissionsByType(map));
		map.put("type", "paper");
		map.put("list", list_pp);
		res.put("pp", userService.getPermissionsByType(map));
		return res;
	}

	@RequestMapping("/getAllPermissionToView")
	public @ResponseBody Map<String, Object> getPermissionToView(){
		Map<String, Object> res = new HashMap<>();
		res.put("cp", getApplication().getAttribute("coursePermissions"));
		res.put("qp", getApplication().getAttribute("questionPermissions"));
		res.put("pp", getApplication().getAttribute("paperPermissions"));
		return res;
	}
	
	/**
	 * 获取层次
	 */
	@RequestMapping("/getArrangement")
	public @ResponseBody List<Map<String, Object>> getArrangement(){
		Map<String, Object> m = new HashMap<>();
		m.put("ID", null);
		m.put("NAME", "层次不限");
		List<Map<String, Object>> res;
		if(getApplication().getAttribute("arrangementList")!=null){ //要浅拷贝，否则下面添加元素会影响原数组
			res = new ArrayList<>(((List<Map<String, Object>>) getApplication().getAttribute("arrangementList")));
		}else{
			res = commonService.defaultArrangement();
		}
		res.add(0,m);
		return res;
	}
    
    /**
     * 	@author yoyo
     */
    @RequestMapping("/getSystemTimeByID")
    public @ResponseBody String getSystemTimeByID(){
    	String id=getPara("id");
    	return String.valueOf(commonService.getSystemTimeByID(id));
    }
    
    /**
     * 获得学生端菜单
     */
    @RequestMapping("/getStudentMenus")
    public @ResponseBody List<Map<String, Object>> getStudentMenus(){
    	return commonService.getStudentMenu();
    }

}
