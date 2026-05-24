package com.cx.kaoyi.business.controller;

import java.util.*;


import com.cx.kaoyi.framework.utils.IpUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.service.CommonService;
import com.cx.kaoyi.business.service.SystemService;
import com.cx.kaoyi.business.service.UserService;
import com.cx.kaoyi.framework.base.BaseController;

@Controller
public class IndexController extends BaseController{


	@Autowired
	public CommonService commonService;

	@Autowired
	public UserService userService;
	
	@Autowired
	public SystemService systemService;

	@RequestMapping("/")
    public String index() {
		if(getSubject().isAuthenticated() && getUserInfo()!=null){
			return "jsp/default";
		}else if(getSubject().isAuthenticated() && getStudentInfo()!=null){
			return "jsp/studentLogin/default";
		}
		return "jsp/index";
    }
	
	//系统认证后默认页面
	@RequestMapping("/default")
    public String defaultPage() {
		if(getSubject().isAuthenticated() && getUserInfo()!=null){
			return "jsp/default";
		}else if(getSubject().isAuthenticated() && getStudentInfo()!=null){
			return "jsp/studentLogin/default";
		}
		return "jsp/index";
    }
	
	//登录页面
	@RequestMapping("/login")
	public String login(){
		if(getSubject().isAuthenticated() && getUserInfo()!=null){
			return "jsp/default";
		}else if(getSubject().isAuthenticated() && getStudentInfo()!=null){
			return "jsp/studentLogin/default";
		}
		return "jsp/index";
	}

	//注销时记录到系统日志
	@RequestMapping("/logoutLog")
	public @ResponseBody String logoutLog() {
		User u = getUserInfo();
		if(getSubject().isAuthenticated()){
			if(StringUtils.isBlank(u.getIp())){
				u.setIp(IpUtils.getAllValidIpToString(getRequest()));
			}
			Map log = new HashMap<>();
			log.put("content", "退出系统。");
			log.put("cid", "");
			systemService.addSysLog(log);
		}
		return "1";
	}
}