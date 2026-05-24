package com.cx.kaoyi.business.controller.permission;

import com.cx.kaoyi.business.domain.Permission;
import com.cx.kaoyi.business.service.PermissionService;
import com.cx.kaoyi.framework.base.BaseController;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/permission")
public class PermissionController extends BaseController{

	@Autowired
	public PermissionService permissionService;
	
	//通过角色ID获取权限
	@RequestMapping("/getPermissionsByRID")
	public @ResponseBody List<Permission> getPermissionsByRID() {		
		return permissionService.findPerByRID(getPara("rid"));		
	}
	
	//通过角色ID和课程ID获取权限
	@RequestMapping("/getPermissionsByRIDAndCID")
	public @ResponseBody List<Permission> getPermissionsByRIDAndCID() {
		Map map = new HashMap();
		String uid = getPara("uid");
		String cid = getPara("cid");
		map.put("uid", uid);
		map.put("cid", cid);
		return permissionService.findPerByUIDAndCID(map,uid+"_"+cid);
	}
	
	/**
	 * 根据用户id和课程id获取试题权限
	 * @author 洪艳
	 * @return
	 */
	/*
	@RequestMapping("/getQuestionPermissionsByUIDAndCID")
	public @ResponseBody List<Permission> getQuestionPermissionsByUIDAndCID() {	
		User user = (User)getSubject().getSession().getAttribute("userInfo");
		if(!"administrator".equals(user.getRole())){
			Map map = new HashMap();
			map.put("uid", user.getId());
			map.put("cid", getPara("cid"));
			return permissionService.getQuestionPermissionsByUIDAndCID(map,user.getUsername()+"_"+getPara("cid"));
		}else{
			Permission p = new Permission();
			p.setPermission("*:*");
			List<Permission> list = new ArrayList<Permission>();
			list.add(p);
			return list;
		}
		
				
	}*/
	
	//通过角色ID、UID、cid获取权限
	@RequestMapping("/getPermissionsByRID_uid_cid")
	public @ResponseBody List<Permission> getPermissionsByRID_uid_cid() {
		String rid=getPara("rid");
		String cid=getPara("cid");
		String uid=getPara("uid");
		return permissionService.getPermissionsByRID_uid_cid(rid,cid,uid);		
	}
	
}
