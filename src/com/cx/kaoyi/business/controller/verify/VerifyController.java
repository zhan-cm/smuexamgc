package com.cx.kaoyi.business.controller.verify;

import java.math.BigDecimal;
import java.util.*;

import com.alibaba.fastjson2.JSONObject;


import com.cx.kaoyi.framework.question.dto.RepeatABRate;
import com.cx.kaoyi.framework.question.repeat.StatsApiClient;
import com.cx.kaoyi.framework.utils.DateFormatUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;

import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.service.CourseService;
import com.cx.kaoyi.business.service.PaperService;
import com.cx.kaoyi.business.service.QuestionService;
import com.cx.kaoyi.business.service.SystemService;
import com.cx.kaoyi.business.service.UserService;
import com.cx.kaoyi.business.service.VerifyService;
import com.cx.kaoyi.framework.base.BaseController;
import com.cx.kaoyi.framework.utils.PageUtils;
import com.cx.kaoyi.framework.utils.Utils;

@Controller
@RequestMapping("/verify")
public class VerifyController extends BaseController {

	@Autowired
	public PaperService paperService;

	@Autowired
	public CourseService courseService;

	@Autowired
	public QuestionService questionService;

	@Autowired
	public VerifyService verifyService;
	
	@Autowired
	public UserService userService;
	
	@Autowired
	public SystemService systemService;

	@Autowired
	private StatsApiClient statsApiClient;

	@Value("${openFindRepeatSystem:0}")
	private Integer openFindRepeatSystem;

	/**
	 * 未提交审核的试卷列表
	 * @author yoyo
	 * @return 
	 */
	@RequestMapping("/paperList")
	public String paperList() {
		Set<String> cIDs= getUserInfo().getcIDs();
		if(cIDs==null){
			User u = getUserInfo();
			if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
	        	u.setcIDs(userService.findAllCids());
	        }else{ //其他角色，查询有浏览课程权限的所有课程
	        	u.setcIDs(userService.findCids(u.getId()));
	        }
			cIDs = u.getcIDs();	
		}		
		Map<String, Object> m = new HashMap<>();
		m.put("cIDs", cIDs);

		List<String> cidstrList=getCidStrList(cIDs);
		m.put("cidstr", cidstrList);

		if(cIDs.size()>0) {
			getRequest().setAttribute("courseList", courseService.getCourseList(m));
		}else {
			getRequest().setAttribute("courseList", new ArrayList());
		}
		return "jsp/verify/paperList";
	}
	
	/**
	 * 等待初审的试卷
	 * @author zhang zhilin,yoyo
	 * @return
	 */
	@RequestMapping("/waitFirstVerify")
	public String waitFirstVerify() {
		Set<String> cIDs= getUserInfo().getcIDs();
		if(cIDs==null){
			User u = getUserInfo();
			if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
	        	u.setcIDs(userService.findAllCids());
	        }else{ //其他角色，查询有浏览课程权限的所有课程
	        	u.setcIDs(userService.findCids(u.getId()));
	        }
			cIDs = u.getcIDs();	
		}
		
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("cIDs", cIDs);
		List<String> cidstrList=getCidStrList(cIDs);
		m.put("cidstr", cidstrList);
		if(cIDs.size()>0) {
			getRequest().setAttribute("courseList", courseService.getCourseList(m));
		}else {
			getRequest().setAttribute("courseList", new ArrayList());
		}
		if("1".equals((String)getApplication().getAttribute("enable_c_switch"))){
			return "jsp/verify/waitFirstVerify_dl";
		}else {
			return "jsp/verify/waitFirstVerify";
		}
	}
	
	/**
	 * 等待终审的试卷
	 * @author yan hong
	 * @return
	 */
	@RequestMapping("/waitLastVerify")
	public String waitLastVerify() {
		Set<String> cIDs= getUserInfo().getcIDs();
		if(cIDs==null){
			User u = getUserInfo();
			if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
	        	u.setcIDs(userService.findAllCids());
	        }else{ //其他角色，查询有浏览课程权限的所有课程
	        	u.setcIDs(userService.findCids(u.getId()));
	        }
			cIDs = u.getcIDs();	
		}
		Map<String, Object> m = new HashMap<>();
		m.put("cIDs", cIDs);
		List<String> cidstrList=getCidStrList(cIDs);
		m.put("cidstr", cidstrList);
		if(cIDs.size()>0) {
			getRequest().setAttribute("courseList", courseService.getCourseList(m));
		}else {
			getRequest().setAttribute("courseList", new ArrayList());
		}
		if("1".equals(getApplication().getAttribute("enable_c_switch"))){
			return "jsp/verify/waitLastVerify_dl";
		}else {
			return "jsp/verify/waitLastVerify";
		}
	}
	
	/**
	 * 审核未通过的试卷
	 * @author zhang zhilin,yoyo
	 * @return
	 */
	@RequestMapping("/unVerify")
	public String unVerify() {
		Set<String> cIDs= getUserInfo().getcIDs();
		if(cIDs==null){
			User u = getUserInfo();
			if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
	        	u.setcIDs(userService.findAllCids());
	        }else{ //其他角色，查询有浏览课程权限的所有课程
	        	u.setcIDs(userService.findCids(u.getId()));
	        }
			cIDs = u.getcIDs();	
		}
		Map<String, Object> m = new HashMap<>();
		m.put("cIDs", cIDs);
		List<String> cidstrList=getCidStrList(cIDs);
		m.put("cidstr", cidstrList);
		if(cIDs.size()>0) {
			getRequest().setAttribute("courseList", courseService.getCourseList(m));
		}else {
			getRequest().setAttribute("courseList", new ArrayList());
		}
		return "jsp/verify/unVerify";
	}
	
	/**
	 * 通过审核的试卷
	 * @author zhang zhilin,yoyo
	 * @return
	 */
	@RequestMapping("/verified")
	public String verified() {
		getRequest().setAttribute("num", getPara("num"));
		getRequest().setAttribute("redirect", getPara("redirect"));//标记是否跳转请求
		
		Set<String> cIDs= getUserInfo().getcIDs();
		if(cIDs==null){
			User u = getUserInfo();
			if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
	        	u.setcIDs(userService.findAllCids());
	        }else{ //其他角色，查询有浏览课程权限的所有课程
	        	u.setcIDs(userService.findCids(u.getId()));
	        }
			cIDs = u.getcIDs();	
		}
		Map<String, Object> m = new HashMap<>();
		m.put("cIDs", cIDs);
		List<String> cidstrList=getCidStrList(cIDs);
		m.put("cidstr", cidstrList);
		if(cIDs.size()>0) {
			getRequest().setAttribute("courseList", courseService.getCourseList(m));
		}else {
			getRequest().setAttribute("courseList", new ArrayList());
		}
		return "jsp/verify/verified";
	}
	
	/**
	 * 暂时删除的试卷
	 * @return
	 */
	@RequestMapping("/del")
	public String del() {
		Set<String> cIDs= getUserInfo().getcIDs();
		if(cIDs==null){
			User u = getUserInfo();
			if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
	        	u.setcIDs(userService.findAllCids());
	        }else{ //其他角色，查询有浏览课程权限的所有课程
	        	u.setcIDs(userService.findCids(u.getId()));
	        }
			cIDs = u.getcIDs();	
		}
		Map<String, Object> m = new HashMap<>();
		m.put("cIDs", cIDs);
		List<String> cidstrList=getCidStrList(cIDs);
		m.put("cidstr", cidstrList);
		if(cIDs.size()>0) {
			getRequest().setAttribute("courseList", courseService.getCourseList(m));
		}else {
			getRequest().setAttribute("courseList", new ArrayList());
		}
		return "jsp/verify/del";
	}

	/**
	 * 获取A卷试卷列表
	 * @author yoyo
	 * @param /state/【-1，暂时删除的试卷 0，未提交审核的试卷 1，等待初审的试卷  2，等待终审的试卷 3，通过审核的试卷  5，尚未收卷的试卷 7，审核未通过的试卷】
	 * @return
	 */
	@RequestMapping("/getPaperList")
	public @ResponseBody Map<String, Object> getPaperList() {
		String mobile = getPara("mobile");
		Map<String, Object> m = new HashMap<>();
		m.put("tid", getUserID());
		//m.put("cIDs", getUserInfo().getcIDs());
		Enumeration<String> paramNames = getRequest().getParameterNames();  
		// 通过循环将表单参数放入键值对映射中  
		while(paramNames.hasMoreElements()) {  
			String key = paramNames.nextElement();  			
			String value = getRequest().getParameter(key);
			m.put(key, value);
		}
		setMapParamSafe(m,"num");
		setMapParamSafe(m,"teacher");
		String role=getUserInfo().getRole();
		if("administrator".equals(role)||"expert".equals(role)){
			m.put("role", "administrator");
		}
		if("2".equals(getPara("state"))){
			Map<String,Object> lastVerifyMap = systemService.getSystemParam("lastverify");
			for(int i=1;i<=4;i++){
				String jw=String.valueOf(lastVerifyMap.get("YL_"+i));
				if(jw.equals(getUsername())){
					m.put("role", "administrator");
					break;
				}
			}
		}
		if(mobile != null){
			m.put("mobile", mobile);
		}
		PageUtils pu = getPageUtil();
		List<Map<String,Object>> list=verifyService.getPaperList(m, pu);
		for (Map<String, Object> mapp : list) {
			if (mapp.containsKey("ename")) {
				String ename = (String) mapp.get("ename");
				if (ename != null) {
					String modifiedEname = ename.replace("\"", "\u201C");
					mapp.put("ename", modifiedEname);
				}
			}
		}
		for(Map<String,Object> map:list){
			List<Map<String,Object>> eo=(List<Map<String, Object>>) map.get("eo");
			Set<String> gset=new HashSet<>();
			Set<String> sset=new HashSet<>();
			if(eo!=null&&eo.size()>0){
				for(Map<String,Object> em:eo){
					gset.add(String.valueOf(em.get("GNAME")));
					sset.add(String.valueOf(em.get("SNAME")));
				}
				map.put("GNAME", String.join(",",gset));
				map.put("SNAME", String.join(",", sset));
			}else{
				map.put("GNAME", "");
				map.put("SNAME", "");
			}

			Date begindate= (Date) map.get("begindate");
			Date enddate= (Date) map.get("enddate");
			String examdate_b = DateFormatUtils.formatDate(begindate);
			String examdate_e = DateFormatUtils.formatDate(enddate);
			if(examdate_b.equals(examdate_e)){
				map.put("examDate",examdate_b);
			}else{
				map.put("examDate",examdate_b+"<br/>--"+examdate_e);
			}
			map.put("examTime", DateFormatUtils.formatHourMinute(begindate) +"--"+ DateFormatUtils.formatHourMinute(enddate));
		}
		return getRes(list, verifyService.getPaperCount(m));
	}

	/**
	 * 获取已通过审核待考的试卷
	 * @return
	 */
	@RequestMapping("/getVerifiedPaperList")
	public @ResponseBody Map<String, Object> getVerifiedPaperList() {
		Map<String, Object> m = new HashMap<String, Object>();
		m.put("tid", getUserID());
		//m.put("cIDs", getUserInfo().getcIDs());
		Enumeration<String> paramNames = getRequest().getParameterNames();  
		// 通过循环将表单参数放入键值对映射中  
		while(paramNames.hasMoreElements()) {  
			String key = paramNames.nextElement();  			
			String value = getRequest().getParameter(key);
			m.put(key, value);
		}
		setMapParamSafe(m, "num");
		setMapParamSafe(m, "teacher");
		setMapParamSafe(m, "mobile");
		String role=getUserInfo().getRole();
		if("administrator".equals(role)||"expert".equals(role)){
			m.put("role", "administrator");
		}
		PageUtils pu = getPageUtil();
		List<Map<String,Object>> list=verifyService.getVerifiedPaperList(m);
		return getRes(Utils.paginate(list,pu.getPage(),pu.getRows()), list.size());
	}
	

	// 删除试卷
	@RequestMapping("/deletePaper")
	public @ResponseBody String deletePaper() {
		Map m = new HashMap();
		String eid = getPara("eid");
		m.put("eid", eid);
		if(!getSubject().hasRole("administrator")){
			m.put("uid", getUserID());
			m.put("permission", "paper:del");
			if(verifyService.checkPaperPermission(m)==0){
				return "jsp/notTheRole";
			}
		}

		verifyService.deletePaper(eid, -1);
		return "1";
	}

	// 撤销删除
	@RequestMapping("/cancelDel")
	public @ResponseBody String cancelDel() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:del");
			if(verifyService.checkPaperPermission(map)==0){
				return "jsp/notTheRole";
			}
		}
		verifyService.cancelDelPaper(eid);
		return "";
	}
	
	/**
	 * 彻底删除试卷
	 * @author yoyo
	 * @return
	 */
	@RequestMapping("/completeDel")
	public @ResponseBody String completeDel() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:del");
			if(verifyService.checkPaperPermission(map)==0){
				return "jsp/notTheRole";
			}
		}
		verifyService.toCompleteDel(eid);
		
		return "1";
	}
	
	/**
	 * 批量彻底删除试卷
	 * @author li
	 * @return
	 */
	@RequestMapping("/completeDelSelect")
	public @ResponseBody String completeDelSelect(@RequestBody Map map) {
		ArrayList<Map<String, String>> list = (ArrayList<Map<String, String>>) map.get("data");
		for(int i=0;i<list.size();i++) {
			Map param = list.get(i);
			param.put("permission", "paper:del");
			if(checkPaperPermission(param)==1){
				verifyService.toCompleteDel(list.get(i).get("eid"));
			}
		}
		return "1";
	}

	// 试卷权限设置
	@RequestMapping("/appoint")
	public String appoint() {
		String eid = getPara("eid");
		Map<String, Object> examinfo = paperService.getExamInfo(eid);
		if(!getSubject().hasRole("administrator")){
			String allowEditPermission=String.valueOf(getSession().getAttribute("allowEditPermission_"+eid));
			if("N".equals(allowEditPermission)||"null".equals(allowEditPermission)||"".equals(allowEditPermission)) {
				return "jsp/notTheRole"; 
			}
		}
		String cid = getPara("cid");
		String type = getPara("type");
		
		String mobile = getPara("mobile");

		getRequest().setAttribute("cid", cid);
		getRequest().setAttribute("eid", eid);
		getRequest().setAttribute("mobile", mobile);
		getRequest().setAttribute("type", type);
		int aorb = Integer.parseInt(String.valueOf(examinfo.get("AORB")));
		if(aorb==0){
			getRequest().setAttribute("title", "《"+examinfo.get("ENAME").toString().trim()+examinfo.get("EXAMTYPE").toString().trim()+"》（A卷）");
		}else{
			getRequest().setAttribute("title", "《"+examinfo.get("ENAME").toString().trim()+examinfo.get("EXAMTYPE").toString().trim()+"》（B卷）");
		}
		
		return "jsp/verify/appoint";
	}
	
	// 添加授权人页面
	@RequestMapping("/authorizedTeacher")
	public String authorizedTeacher() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			String allowEditPermission=String.valueOf(getSession().getAttribute("allowEditPermission_"+eid));
			if("N".equals(allowEditPermission)||"null".equals(allowEditPermission)||"".equals(allowEditPermission)) {
				return "jsp/notTheRole"; 
			}
		}
		String cid = getPara("cid");
		String type = getPara("type");
		String uid = getUserInfo().getId();
		String mobile = getPara("mobile");

        Map<String, Object> examinfo = paperService.getExamInfo(eid);
		boolean b = false;
		if(getSubject().hasRole("administrator")){
			b = true;
		}else{
			if(uid.equals((String)examinfo.get("TEACHERID"))){
				b = true;
			}
		}
		if(b){
			getRequest().setAttribute("cid", cid);
			getRequest().setAttribute("eid", eid);
			getRequest().setAttribute("mobile", mobile);
			getRequest().setAttribute("type", type);
			int aorb = Integer.parseInt(String.valueOf(examinfo.get("AORB")));
			if(aorb==0){
				getRequest().setAttribute("title", "《"+examinfo.get("ENAME").toString().trim()+examinfo.get("EXAMTYPE").toString().trim()+"》（A卷）");
			}else{
				getRequest().setAttribute("title", "《"+examinfo.get("ENAME").toString().trim()+examinfo.get("EXAMTYPE").toString().trim()+"》（B卷）");
			}
		}
		return "jsp/verify/authorizedTeacher";
	}

	/**
	 * 试卷相关权限的教师
	 * @author yoyo
	 * @param
	 * @return List<Map<String, Object>> [tid,tname,unitid,depid,roleid,pers[pid],ownPers[pid]]
	 */
	@RequestMapping("/getAppointTeacher")
	public @ResponseBody List<Map<String, Object>> getAppointTeacher() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			String allowEditPermission=String.valueOf(getSession().getAttribute("allowEditPermission_"+eid));
			if("N".equals(allowEditPermission)||"null".equals(allowEditPermission)||"".equals(allowEditPermission)) {
				return null; 
			}
		}
		String c = getPara("cid");
		String[] cids = c.split(",");
		Map m = new HashMap();
		m.put("cid", cids);
		m.put("eid", eid);
		//通过试卷id查找该试卷的考试类型
		Map<String, Object> examInfo = paperService.getExamInfo(eid);
		String type = examInfo.get("TYPE").toString();

		//考生类别是否需要教务处审核
		String state =verifyService.getExamtype(type);
		List<Map<String, Object>> perList = verifyService.getTeacherPermission(m);
		HashSet<String> tids=new HashSet<>();
		HashSet<String> lastVerifySet=new HashSet<>();
		Map<String,Object> lastVerifyMap = systemService.getSystemParam("lastverify");
		for (int a = 1; a <= 4; a++) {//4个终审人
			//系统默认审核人员
			String mr=(String) lastVerifyMap.get("YL_"+a);
			String mr_id="";
			if(mr!=null&&!"".equals(mr)){
				User user=userService.findByUsername(mr);
				if(user!=null && !"".equals(user.getId())){
					lastVerifySet.add(user.getId());
				}
			}

			if("1".equals(state)){//终审必需教务处审核,非教务处人员的终审选择框去除
				for(int i=0;i<perList.size();i++){
					Map<String, Object> map=perList.get(i);
					String tid_=String.valueOf(map.get("TID"));
					if(lastVerifySet.contains(tid_)&&("31".equals(map.get("PID"))||"36".equals(map.get("PID")))){
						continue;
					}
					tids.add(tid_);
					if(!"2".equals(map.get("RID"))){
						if("36".equals(map.get("PID"))){
							perList.remove(i);
							i--;
						}
					}
				}
			}else{
				for(int i=0;i<perList.size();i++){
					Map<String, Object> map=perList.get(i);
					String tid_=String.valueOf(map.get("TID"));
					if(lastVerifySet.contains(tid_)&&("31".equals(map.get("PID"))||"36".equals(map.get("PID")))){
						continue;
					}
					tids.add(tid_);
				}
			}
			//临时添加授权教师能正常显示权限设置页面
//		List<Map<String, Object>> authorList = verifyService.getAuthorPermission(m);
//		for(int i=0;i<authorList.size();i++){
//			Map<String, Object> map=authorList.get(i);
//			String tid_=String.valueOf(map.get("TID"));
//			if(mr_id.equals(tid_)&&("31".equals(map.get("PID"))||"36".equals(map.get("PID")))){
//				continue;
//			}
//			tids.add(tid_);
//		}
		}
		for(String mr_id : lastVerifySet){
			tids.add(mr_id);
			Map<String, Object> map_31=new HashMap<>();
			map_31.put("TID",mr_id);
			map_31.put("PID","31");
			map_31.put("RID","2");
			perList.add(map_31);
			Map<String, Object> map_36=new HashMap<>();
			map_36.put("TID",mr_id);
			map_36.put("PID","36");
			map_36.put("RID","2");
			perList.add(map_36);
		}

		List<Map<String,Object>> rtnList=verifyService.getAppointTeacher(tids);
		List<Map<String, Object>> ownPerList = verifyService.getTeacherPaPers(eid);
		String[] pArray=new String[]{"31","37","33","34","39"};

		for(Map<String,Object> tmap:rtnList){
			List<String> pidList=new ArrayList<>();
			List<String> ownPers=new ArrayList<>();
			String tid=String.valueOf(tmap.get("tid"));
			for(String p:pArray){
				boolean b=false;
				for(int j=0;j<ownPerList.size();j++){
					if(tid.equals(ownPerList.get(j).get("TID"))&&p.equals(ownPerList.get(j).get("PID"))){
						b=true;
						ownPerList.remove(j);
						break;
					}
				}
				if(b){
					ownPers.add(p+"_checked");
					pidList.add(p);
				}else{
					ownPers.add(p+"_unchecked");
				}
			}

			for(int i=0;i<perList.size();i++){
				String tid_c=(String)perList.get(i).get("TID");
				if(tid.equals(tid_c)){
					String pid_c=(String)perList.get(i).get("PID");
					if(!pid_c.equals("11")){
						boolean b=false;
						for(int j=0;j<ownPerList.size();j++){
							if(tid.equals(ownPerList.get(j).get("TID"))&&pid_c.equals(ownPerList.get(j).get("PID"))){
								b=true;
								ownPerList.remove(j);
								break;
							}
						}
						if(b){
							ownPers.add(pid_c+"_checked");
							pidList.add(pid_c);
						}else{
							ownPers.add(pid_c+"_unchecked");
						}
					}
				}
			}
			tmap.put("ownPers", ownPers);
			tmap.put("pidList", pidList);
		}
		getSession().setAttribute(eid+"_teacher_permission",rtnList);
		
		return rtnList;
	}
	
	//添加授权人
	@RequestMapping("/getAllAuthorizedTeacher")
	public @ResponseBody Map<String, Object> getAllAuthorizedTeacher() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			String allowEditPermission=String.valueOf(getSession().getAttribute("allowEditPermission_"+eid));
			if("N".equals(allowEditPermission)||"null".equals(allowEditPermission)||"".equals(allowEditPermission)) {
				return null; 
			}
		}
		Map param = new HashMap();
		param.put("uname", (getPara("uname") !=null)?getPara("uname").trim():getPara("uname"));
		param.put("unitid", getPara("unitid"));
		param.put("roleid", getPara("roleid"));
		String uid = getUserInfo().getId();
		String c = getPara("cid");
		String[] cids = getPara("cid").split(",");
		Map m = new HashMap();
		m.put("cid", cids);
		m.put("eid", eid);
	
		List<Map<String, Object>> perList = verifyService.getTeacherPermission(m);

		PageUtils pu = getPageUtil();
		List<Map<String,Object>> rtnList=verifyService.getAllAuthorizedTeacher(param,pu);
		List<Map<String, Object>> ownPerList = verifyService.getTeacherPaPers(eid);
		String[] pArray=new String[]{"31","37","33","34","39"};

		for(Map<String,Object> tmap:rtnList){
			List<String> pidList=new ArrayList<>();
			List<String> ownPers=new ArrayList<String>();
			String tid=String.valueOf(tmap.get("tid"));
			for(String p:pArray){
				boolean b=false;
				for(int j=0;j<ownPerList.size();j++){
					if(tid.equals((String)ownPerList.get(j).get("TID"))&&p.equals((String)ownPerList.get(j).get("PID"))){
						b=true;
						ownPerList.remove(j);
						break;
					}
				}
				if(b){
					ownPers.add(p+"_checked");
					pidList.add(p);
				}else{
					ownPers.add(p+"_unchecked");
				}
			}
			
			for(int i=0;i<perList.size();i++){
				String tid_c=(String)perList.get(i).get("TID");
				if(tid.equals(tid_c)){
					String pid_c=(String)perList.get(i).get("PID");
					if(!pid_c.equals("11")){
						boolean b=false;
						for(int j=0;j<ownPerList.size();j++){
							if(tid.equals((String)ownPerList.get(j).get("TID"))&&pid_c.equals((String)ownPerList.get(j).get("PID"))){
								b=true;
								ownPerList.remove(j);
								break;
							}
						}
						if(b){
							ownPers.add(pid_c+"_checked");
							pidList.add(pid_c);
						}else{
							ownPers.add(pid_c+"_unchecked");
						}
					}
				}
			}
			tmap.put("ownPers", ownPers);
			tmap.put("pidList", pidList);
		}
		getSession().setAttribute(eid+"_authorized_permission",rtnList);

		return getRes(rtnList,verifyService.getAllAuthorTeacherCount(param));
	}

	// 获取课程
	@RequestMapping("/getCourseList")
	public @ResponseBody List<Map<String, Object>> getCourseList() {
		Map m = new HashMap();
		m.put("cIDs", getUserInfo().getcIDs());
		return verifyService.getCourseList(m);
	}

	//更新教师试卷权限
	@RequestMapping("/addAppointTeacher")
	public @ResponseBody String addAppointTeacher(@RequestBody Map map) {
		String eid = map.get("eid").toString();
		String allowEditPermission=String.valueOf(getSession().getAttribute("allowEditPermission_"+eid));
		if("Y".equals(allowEditPermission) || getSubject().hasRole("administrator")) {
			map.put("system_permission",getApplication().getAttribute("permissions"));
			String ename = paperService.getENameByID(eid);
			map.put("ename",ename);
			map.put("permission_old",getSession().getAttribute(eid+"_teacher_permission"));
			verifyService.updatePaperPer(map);		

			return "1";
		}else {
			return "0";
		}
		
		
	}
	
	//更新授权教师试卷权限
	@RequestMapping("/addAuthorizedTeacher")
	public @ResponseBody String addAuthorizedTeacher(@RequestBody Map map) {
		// userService.updatePermissions(map);
		String eid = map.get("eid").toString();
		String allowEditPermission=String.valueOf(getSession().getAttribute("allowEditPermission_"+eid));
		if("Y".equals(allowEditPermission)) {
			map.put("system_permission",getApplication().getAttribute("permissions"));
			map.put("permission_old",getSession().getAttribute(eid+"_authorized_permission"));
			verifyService.updateAuthorPaperPer(map);
		}else {
			return "0";
		}
//		String ename = paperService.getENameByID(eid);
//		Map log = new HashMap();
//		log.put("content", "修改试卷《"+ ename +"》（编号："+ eid +"）的权限");
//		log.put("cid", "");
//		systemService.addSysLog(log);
		
		return "1";
	}

	// 改卷任务分配
	@RequestMapping("/correctDistribution")
	public String correctDistribution() {
		String eid = getPara("eid");
		getRequest().setAttribute("cid", getPara("cid"));
		getRequest().setAttribute("eid", eid);
		getRequest().setAttribute("ename", getPara("ename"));
		
		getRequest().setAttribute("paperRight", verifyService.getPaperRight(eid));		
		getRequest().setAttribute("subjectiveQuestion", verifyService.getSubjectiveQuestion(eid));
		
		//获取学生的班级
		getRequest().setAttribute("classList", verifyService.getStudentClass(eid));
		
		return "jsp/verify/correctDistribution";
	}

	//判断教师权限
	@RequestMapping("/haveRight")
	public @ResponseBody String haveRight() {
		String eid = getPara("eid");
		if(getSubject().hasRole("administrator")) {
			return "1";
		}
		
		//String state = getPara("state");
		String permission = getPara("permission");
		if(permission==null || permission.equals("")) {
			return "0";
		}

		List<String> pids = new ArrayList<>();
		if(permission.equals("paper:firstVerify")){//验证是否有初审的权限
			if("Y".equals(getSession().getAttribute("allowFirstVerify_"+eid))){
				return "1";
			}
			pids.add("35");
		}else if(permission.equals("paper:lastVerify")){//验证是否有终审的权限
			if("Y".equals(getSession().getAttribute("allowLastVerify_"+eid))){
				return "1";
			}else {
				Map<String,Object> lastVerifyMap = systemService.getSystemParam("lastverify");
				for(int i=1;i<=4;i++){
					//获取系统设置的默认审核人
					String mr = (String) lastVerifyMap.get("YL_"+i);
					if(org.apache.commons.lang3.StringUtils.isNotBlank(mr) && mr.equals(getUsername())){
						getSession().setAttribute("allowLastVerify_"+eid, "Y");
						return "1";
					}
				}
			}
			pids.add("36");
		}else if(permission.equals("paper:rewind")){//验证是否有收卷的权限，只要有查看试卷的权限即可收卷
			if("Y".equals(getSession().getAttribute("allowRewind_"+eid))){
				return "1";
			}
			pids.add("31");
			pids.add("36");
		}else {
			return "0";
		}

		String tid = getUserID();
		if(!permission.equals("paper:lastVerify")) {//查看是否是组卷人，如果是，拥有终审权限的其他全部权限
			Map<String, Object> examInfo = paperService.getExamInfo(eid);
			if(tid.equals(examInfo.get("TEACHERID"))) {
				getSession().setAttribute("allowFirstVerify_"+eid, "Y");
				getSession().setAttribute("allowRewind_"+eid, "Y");
				return "1";
			}
		}
		Map map = new HashMap();
		map.put("eid", eid);
		map.put("tid", tid);
		map.put("pids", pids);
		
		Integer num = Integer.parseInt(verifyService.paperPerCount(map));
		if(num > 0){
			if(permission.equals("paper:firstVerify")){//验证是否有初审的权限
				getSession().setAttribute("allowFirstVerify_"+eid, "Y");
			}else if(permission.equals("paper:lastVerify")){//验证是否有终审的权限
				getSession().setAttribute("allowLastVerify_"+eid, "Y");
			}else if(permission.equals("paper:rewind")){//验证是否有收卷的权限，只要有查看试卷的权限即可收卷
				getSession().setAttribute("allowRewind_"+eid, "Y");
			}
			return "1";
		}
		
		return "0";
	}
	
	//B卷试题数目
//	@RequestMapping("/getBNum")
//	public @ResponseBody String getBNum() {
//		return verifyService.getBNum(getPara("eid"));
//	}
	
	//提交等待初级审核
	@RequestMapping("/submitForVer")
	public String submitForVer() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:submitForVer");
			if(verifyService.checkPaperPermission(map)==0){
				return "jsp/notTheRole";
			}
		}
		String[] cids = getPara("cid").split(",");
		if(cids.length==1){
			List<Map<String,Object>> clist=courseService.getCourseAttr(cids[0]);
			if(clist!=null&&clist.size()>0){
				getRequest().setAttribute("specialtyList", clist.get(0).get("specialtyList"));
				getRequest().setAttribute("examTypeList", clist.get(0).get("examTypeList"));
			}
			getRequest().setAttribute("examObject",paperService.getExamObject(eid));
			getRequest().setAttribute("action","submitForVer");	
			
		}else{
			List<Map<String, Object>> specialtyList = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> examTypeList = new ArrayList<Map<String, Object>>();
			for(String cid:cids){	
				Map<String, Object> map=null;
				List<Map<String,Object>> clist=courseService.getCourseAttr(cid);
				if(clist!=null&&clist.size()>0){
					map=clist.get(0);
				}else{
					continue;
				}
				
				List<Map<String, Object>> specialtyls = (List<Map<String, Object>>) map.get("specialtyList");
				for(Map<String, Object> m:specialtyls){
					boolean b = true;
					for(Map<String, Object> mm:specialtyList){
						if(((String)mm.get("SPID")).equals((String)m.get("SPID"))){
							b = false;
							break;
						}
					}
					if(b){
						specialtyList.add(m);
					}else{
						continue;
					}
				}
				
				List<Map<String, Object>> ls = (List<Map<String, Object>>) map.get("examTypeList");
				for(Map<String, Object> m:ls){
					boolean b = true;
					for(Map<String, Object> mm:examTypeList){
						if(((String)mm.get("ETID")).equals((String)m.get("ETID"))){
							b = false;
							break;
						}
					}
					if(b){
						examTypeList.add(m);
					}else{
						continue;
					}
				}
			}
			getRequest().setAttribute("specialtyList", specialtyList);
			getRequest().setAttribute("examTypeList", examTypeList);
			
			getRequest().setAttribute("examObject",paperService.getExamObject(eid));
			getRequest().setAttribute("action","submitForVer");	
		}
		
		Map<String, Object> examinfo = paperService.getExamInfo(eid);
		getRequest().setAttribute("examInfo", examinfo);
		
		String organizationinfo_en="";
		try {
			organizationinfo_en=(String)((Map<String, Object>)getApplication().getAttribute("organizationinfo_en")).get("PARAM");
		}catch(Exception e) {}
		
		if("gmu".equals(organizationinfo_en)) {
			getRequest().setAttribute("jwc_kcdm", paperService.getJWC_KCDM());
			return "jsp/verify/editExamInfo-gmu";
		}else {
			return "jsp/verify/editExamInfo";
		}
	}
	
	//初级审核
	@RequestMapping("/firstVerify")
	public String firstVerify() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			String per=String.valueOf(getSession().getAttribute("allowFirstVerify_"+eid));
			if(!"Y".equals(per)) {
				return "jsp/notTheRole"; 
			}
		}
		//String state = getPara("state");
		//String tid = getPara("tid");

		//String estate = verifyService.getPaperByEID(eid).get("state").toString();
		String[] cids = getPara("cid").split(",");
		
		if(cids.length==1){
			List<Map<String,Object>> clist=courseService.getCourseAttr(cids[0]);
			if(clist!=null&&clist.size()>0){
				getRequest().setAttribute("specialtyList", clist.get(0).get("specialtyList"));
				getRequest().setAttribute("examTypeList", clist.get(0).get("examTypeList"));
			}
			getRequest().setAttribute("examObject",paperService.getExamObject(eid));
			getRequest().setAttribute("action","firstVerify");	
		}else{
			List<Map<String, Object>> specialtyList = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> examTypeList = new ArrayList<Map<String, Object>>();
			for(String cid:cids){				
				Map<String, Object> map=null;
				List<Map<String,Object>> clist=courseService.getCourseAttr(cid);
				if(clist!=null&&clist.size()>0){
					map=clist.get(0);
				}else{
					continue;
				}
				List<Map<String, Object>> specialtyls = (List<Map<String, Object>>) map.get("specialtyList");
				for(Map<String, Object> m:specialtyls){
					boolean b = true;
					for(Map<String, Object> mm:specialtyList){
						if(((String)mm.get("SPID")).equals((String)m.get("SPID"))){
							b = false;
							break;
						}
					}
					if(b){
						specialtyList.add(m);
					}else{
						continue;
					}
				}
				
				List<Map<String, Object>> ls = (List<Map<String, Object>>) map.get("examTypeList");
				for(Map<String, Object> m:ls){
					boolean b = true;
					for(Map<String, Object> mm:examTypeList){
						if(((String)mm.get("ETID")).equals((String)m.get("ETID"))){
							b = false;
							break;
						}
					}
					if(b){
						examTypeList.add(m);
					}else{
						continue;
					}
				}
			}
			getRequest().setAttribute("specialtyList", specialtyList);
			getRequest().setAttribute("examTypeList", examTypeList);
			getRequest().setAttribute("examObject",paperService.getExamObject(eid));
			getRequest().setAttribute("action","firstVerify");	
		}
		
		getRequest().setAttribute("examInfo",paperService.getExamInfo(eid));
		
		String organizationinfo_en="";
		try {
			organizationinfo_en=(String)((Map<String, Object>)getApplication().getAttribute("organizationinfo_en")).get("PARAM");
		}catch(Exception e) {}
		
		if("gmu".equals(organizationinfo_en)) {
			getRequest().setAttribute("jwc_kcdm", paperService.getJWC_KCDM());
			return "jsp/verify/editExamInfo-gmu";
		}else {
			return "jsp/verify/editExamInfo";
		}
	}

	//终级审核
	@RequestMapping("/lastVerify")
	public String lastVerify() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			String per=String.valueOf(getSession().getAttribute("allowLastVerify_"+eid));
			if(!"Y".equals(per)) {
				return "jsp/notTheRole"; 
			}
		}
		Map<String,Object> examinfo = paperService.getExamInfo(eid);
		String[] cids = String.valueOf(examinfo.get("CID")).split(",");
		if(cids.length==1){
			List<Map<String,Object>> clist=courseService.getCourseAttr(cids[0]);
			if(clist!=null&&clist.size()>0){
				getRequest().setAttribute("specialtyList", clist.get(0).get("specialtyList"));
				getRequest().setAttribute("examTypeList", clist.get(0).get("examTypeList"));
			}
			getRequest().setAttribute("examInfo",examinfo);
			getRequest().setAttribute("examObject",paperService.getExamObject(eid));
			getRequest().setAttribute("action","lastVerify");	
		}else{
			List<Map<String, Object>> specialtyList = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> examTypeList = new ArrayList<Map<String, Object>>();
			for(String cid:cids){				
				Map<String, Object> map=null;
				List<Map<String,Object>> clist=courseService.getCourseAttr(cid);
				if(clist!=null&&clist.size()>0){
					map=clist.get(0);
				}else{
					continue;
				}
				
				List<Map<String, Object>> specialtyls = (List<Map<String, Object>>) map.get("specialtyList");
				for(Map<String, Object> m:specialtyls){
					boolean b = true;
					for(Map<String, Object> mm:specialtyList){
						if(((String)mm.get("SPID")).equals((String)m.get("SPID"))){
							b = false;
							break;
						}
					}
					if(b){
						specialtyList.add(m);
					}
				}
				
				List<Map<String, Object>> ls = (List<Map<String, Object>>) map.get("examTypeList");
				for(Map<String, Object> m:ls){
					boolean b = true;
					for(Map<String, Object> mm:examTypeList){
						if(((String)mm.get("ETID")).equals((String)m.get("ETID"))){
							b = false;
							break;
						}
					}
					if(b){
						examTypeList.add(m);
					}
				}
			}
			getRequest().setAttribute("specialtyList", specialtyList);
			getRequest().setAttribute("examTypeList", examTypeList);
			getRequest().setAttribute("examInfo",examinfo);
			getRequest().setAttribute("examObject",paperService.getExamObject(eid));
			getRequest().setAttribute("action","lastVerify");	
		}
		
		String organizationinfo_en="";
		try {
			organizationinfo_en=(String)((Map<String, Object>)getApplication().getAttribute("organizationinfo_en")).get("PARAM");
		}catch(Exception e) {}
		
		if("gmu".equals(organizationinfo_en)) {
			getRequest().setAttribute("jwc_kcdm", paperService.getJWC_KCDM());
			return "jsp/verify/editExamInfo-gmu";
		}else {
			return "jsp/verify/editExamInfo";
		}
	}
	
	//重新审核
	@RequestMapping("/reVerify")
	public String reVerify() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:submitForVer");
			if(verifyService.checkPaperPermission(map)==0){
				return "jsp/notTheRole";
			}
		}
//		String bid = getPara("bid");
//		if(!StringUtils.isEmpty(bid)){
//			getRequest().setAttribute("bid", bid);
//		}
		String[] cids = getPara("cid").split(",");
		if(cids.length==1){
			List<Map<String,Object>> clist=courseService.getCourseAttr(cids[0]);
			if(clist!=null&&clist.size()>0){
				getRequest().setAttribute("specialtyList", clist.get(0).get("specialtyList"));
				getRequest().setAttribute("examTypeList", clist.get(0).get("examTypeList"));
			}
			getRequest().setAttribute("examInfo",paperService.getExamInfo(eid));
			getRequest().setAttribute("examObject",paperService.getExamObject(eid));
		}else{
			List<Map<String, Object>> specialtyList = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> examTypeList = new ArrayList<Map<String, Object>>();
			for(String cid:cids){				
				Map<String, Object> map = null;
				List<Map<String,Object>> clist=courseService.getCourseAttr(cid);
				if(clist!=null&&clist.size()>0){
					map=clist.get(0);
				}else{
					continue;
				}
				List<Map<String, Object>> specialtyls = (List<Map<String, Object>>) map.get("specialtyList");
				for(Map<String, Object> m:specialtyls){
					boolean b = true;
					for(Map<String, Object> mm:specialtyList){
						if(((String)mm.get("SPID")).equals((String)m.get("SPID"))){
							b = false;
							break;
						}
					}
					if(b){
						specialtyList.add(m);
					}else{
						continue;
					}
				}
				
				List<Map<String, Object>> ls = (List<Map<String, Object>>) map.get("examTypeList");
				for(Map<String, Object> m:ls){
					boolean b = true;
					for(Map<String, Object> mm:examTypeList){
						if(((String)mm.get("ETID")).equals((String)m.get("ETID"))){
							b = false;
							break;
						}
					}
					if(b){
						examTypeList.add(m);
					}else{
						continue;
					}
				}
			}
			getRequest().setAttribute("specialtyList", specialtyList);
			getRequest().setAttribute("examTypeList", examTypeList);
			getRequest().setAttribute("examInfo", paperService.getExamInfo(eid));
			getRequest().setAttribute("examObject", paperService.getExamObject(eid));
			
		}
		getRequest().setAttribute("action", "reVerify");
		
		String organizationinfo_en="";
		try {
			organizationinfo_en=(String)((Map<String, Object>)getApplication().getAttribute("organizationinfo_en")).get("PARAM");
		}catch(Exception e) {}
		
		if("gmu".equals(organizationinfo_en)) {
			getRequest().setAttribute("jwc_kcdm", paperService.getJWC_KCDM());
			return "jsp/verify/editExamInfo-gmu";
		}else {
			return "jsp/verify/editExamInfo";
		}
	}
	
	
	//	改卷权限更新
	@RequestMapping("/addPermission")
	public @ResponseBody String addPermission() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			String allowEditPermission=String.valueOf(getSession().getAttribute("allowEditPermission_"+eid));
			if("N".equals(allowEditPermission)||"null".equals(allowEditPermission)||"".equals(allowEditPermission)) {
				return null; 
			}
		}
		String cid = getPara("cid");
		String ename = getPara("ename");
		getRequest().setAttribute("cid", cid);
		getRequest().setAttribute("eid", eid);
		getRequest().setAttribute("ename", ename);
		getRequest().setAttribute("url", getPara("url"));
		
		getRequest().setAttribute("paperRight", verifyService.getPaperRight(eid));
		getRequest().setAttribute("subjectiveQuestion", verifyService.getSubjectiveQuestion(eid));
		if(!StringUtils.isEmpty(getRequest().getParameterValues("correctPer"))){
			String[] correctPer = Arrays.stream(getRequest().getParameterValues("correctPer"))
					.filter(Objects::nonNull)
					.filter(s -> !s.isEmpty())
					.toArray(String[]::new);
			List correctList = new ArrayList();
			for(int i=0; i<correctPer.length; i++){
				Map param1 = new HashMap();			
				param1.put("qid", correctPer[i].split(",")[0]);
				param1.put("tid", correctPer[i].split(",")[1]);
				correctList.add(param1);
			}
			if(correctList.size() > 0 && !StringUtils.isEmpty(eid)){
				Map map1 = new HashMap();		
				map1.put("correctList", correctList);
				map1.put("eid", eid);
				verifyService.insertCorrectPer(map1);
			}
		}else{
			Map map1 = new HashMap();
			map1.put("eid", eid);
			verifyService.deleteCorrectPer(map1);	
		}
		
		if(!StringUtils.isEmpty(getRequest().getParameterValues("correctCla"))){
			String[] correctCla = Arrays.stream(getRequest().getParameterValues("correctCla"))
					.filter(Objects::nonNull)
					.filter(s -> !s.isEmpty())
					.toArray(String[]::new);
			List<Map<String,Object>> claList = new ArrayList<>();
			for(int i=0; i<correctCla.length; i++){
				Map param1 = new HashMap();			
				param1.put("cla", correctCla[i].split(",")[0]);
				param1.put("tid", correctCla[i].split(",")[1]);
				claList.add(param1);
			}
			if(claList.size() > 0 && !StringUtils.isEmpty(eid)){
				Map map1 = new HashMap();		
				map1.put("claList", claList);
				map1.put("eid", eid);
				verifyService.insertCorrectCla(map1);
			}
		}else{
			Map map1 = new HashMap();
			map1.put("eid", eid);
			verifyService.deleteCorrectCla(map1);
		}
		
		if(!StringUtils.isEmpty(getRequest().getParameterValues("reviewPer"))){
			String[] reviewPer = Arrays.stream(getRequest().getParameterValues("reviewPer"))
					.filter(Objects::nonNull)
					.filter(s -> !s.isEmpty())
					.toArray(String[]::new);
			List reviewList = new ArrayList();
			for(int i=0; i<reviewPer.length; i++){
				reviewList.add(reviewPer[i]);
			}
			if(reviewList.size() > 0 && !StringUtils.isEmpty(eid)){
				Map map2 = new HashMap();
				map2.put("reviewList", reviewList);
				map2.put("eid", eid);
				verifyService.insertReviewPer(map2);
			}
		}else{
			Map map1 = new HashMap();
			map1.put("eid", eid);
			verifyService.deleteReviewPer(map1);
		}
		return null;
	}	
	
	//获取教师审核改卷权限
	@RequestMapping("/getReviewPers")
	public @ResponseBody Map<String, Object> getReviewPers() {
		// userService.updatePermissions(map);
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			String allowEditPermission=String.valueOf(getSession().getAttribute("allowEditPermission_"+eid));
			if("N".equals(allowEditPermission)||"null".equals(allowEditPermission)||"".equals(allowEditPermission)) {
				return null; 
			}
		}
		return verifyService.getCorrectAndReviewPers(eid);
	}

	// 设置题型
	@RequestMapping("/setQuestionType")
	public String setQuestionType() {
		String ei_id = getPara("ei_id");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", ei_id);
			map.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(map)==0){
				return "jsp/notTheRole";
			}
		}
		String res = getPara("res");
		if(Utils.NotEmpty(res)){
//			JSONArray resArray = JSONArray.fromObject(res);
			List<Map> resArray = JSONObject.parseObject(res,List.class);
			Iterator<Map> rit = resArray.iterator();
	        while (rit.hasNext()) {
	            JSONObject ob = (JSONObject) rit.next();
	            Map m = new HashMap();
	            m.put("qtid", ob.getString("qtid"));
	            m.put("qtscore", ob.getString("qtscore"));
	            m.put("qttime", ob.getString("qttime"));
	            m.put("qtindex", ob.getString("qtindex"));
	            m.put("ei_id", getPara("ei_id")); 
	            paperService.updatePaperQuestionType(m);
	        }
		}
		getRequest().setAttribute("uid", getUserID());
		return "jsp/verify/paperList";
	}
	
	/**
	 * 验证是否有对应的试卷权限
	 * @author 洪艳
	 * @param map，传入参数（permission[例如：paper:view],uid,eid）
	 * @return 1,有 0,无
	 */
	@RequestMapping("/checkPaperPermission")
	public @ResponseBody int checkPaperPermission(@RequestBody Map map){
		User u = getUserInfo();
		if(u==null){
			return 0;
		}
		if(!getSubject().hasRole("administrator")){
			map.put("uid", u.getId());
			return verifyService.checkPaperPermission(map);
		}else{
			return 1;
		}
	}
	
	/**
	 * 验证是否有试卷的权限设置权限，只有组卷人才有试卷的权限设置权限
	 * @author 洪艳
	 * @param map，传入参数（eid）
	 * @return 1,有 2,无
	 */
	@RequestMapping("/checkPaperPermission2")
	public @ResponseBody int checkPaperPermission2(@RequestBody Map map){
		String eid = map.get("eid").toString();
		Map<String, Object> examInfo = paperService.getExamInfo(eid);
		if(!getSubject().hasRole("administrator")){
			String uid = getUserInfo().getId();
			Map<String,Object> lastVerifyMap = systemService.getSystemParam("lastverify");
			if(uid.equals(examInfo.get("TEACHERID"))
					||getUsername().equals(lastVerifyMap.get("YL_1")) || getUsername().equals(lastVerifyMap.get("YL_2"))
					||getUsername().equals(lastVerifyMap.get("YL_3")) || getUsername().equals(lastVerifyMap.get("YL_4"))
			){
				getSession().setAttribute("allowEditPermission_"+eid, "Y");
				getSession().setAttribute("AORB", examInfo.get("AORB"));
				getSession().setAttribute("ENAME", examInfo.get("ENAME"));
				getSession().setAttribute("EXAMTYPE", examInfo.get("EXAMTYPE"));
				return 1;
			}else{
				getSession().setAttribute("allowEditPermission_"+eid, "N");
				return 2;
			}
		}else{
			getSession().setAttribute("AORB", examInfo.get("AORB"));
			getSession().setAttribute("ENAME", examInfo.get("ENAME"));
			getSession().setAttribute("EXAMTYPE", examInfo.get("EXAMTYPE"));
			getSession().setAttribute("allowEditPermission_"+eid, "Y");
			return 1;
		}
		
	}

	@RequestMapping("/checkPaperIsZjrOrLastVerify")
	public @ResponseBody int checkPaperIsZjrOrLastVerify(@RequestParam String eid){ //查看是否是组卷人或者是终审人，温州医科大学启用B卷用
		User u = getUserInfo();
		if(u==null){
			return 0;
		}
		Map<String,Object> lastVerifyMap = systemService.getSystemParam("lastverify");
		if(!getSubject().hasRole("administrator")){
			Map<String, Object> examinfo = paperService.getExamInfo(eid);
			String tid=String.valueOf(examinfo.get("TEACHERID"));
			if(u.getId().equals(tid)
					||u.getUsername().equals(lastVerifyMap.get("YL_1")) || u.getUsername().equals(lastVerifyMap.get("YL_2"))
					||u.getUsername().equals(lastVerifyMap.get("YL_3")) || u.getUsername().equals(lastVerifyMap.get("YL_4"))
			){
				return 1;
			}
			Map map = new HashMap();
			map.put("uid", u.getId());
			map.put("eid", eid);
			map.put("permission", "paper:lastVerify");
			if (verifyService.checkPaperPermission(map) == 0) {
				return 2;
			}
		}
		return 1;
	}
	
	/**
	 * 验证是否有生成B卷的权限,只有组卷人才可以生成B卷
	 * @author 洪艳
	 * @param /map/，传入参数（cid）
	 * @return 1,有 2,无
	 */
	@RequestMapping("/checkGenerateBpaperPermission")
	public @ResponseBody int checkGenerateBpaperPermission(){
		if(getSubject().hasRole("administrator")) {
			return 1;
		}else {
			String uid = getUserInfo().getId();
			Map m = new HashMap();
			m.put("eid", getPara("eid"));
			m.put("tid", uid);
			List<Map<String,Object>> ls = paperService.getExamInfoByEid_Tid(m);
			if(ls!=null && ls.size()>0) {
				getSession().setAttribute("allowGenerateB_"+getPara("eid"), "Y");
				return 1;
			}else {
				getSession().setAttribute("allowGenerateB_"+getPara("eid"), "N");
				return 2;
			}
		}		
	}
	
	@RequestMapping("/checkGenerateCpaperPermission")
	public @ResponseBody int checkGenerateCpaperPermission(){
		String aid = getPara("aid");
		if(getSubject().hasRole("administrator")) {
			return 1;
		}else {
			String uid = getUserInfo().getId();
			Map m = new HashMap();
			m.put("eid", getPara("eid"));
			m.put("tid", uid);
			List<Map<String,Object>> ls = paperService.getExamInfoByEid_Tid(m);
			if(ls!=null && ls.size()>0) {
				if (aid!=null&&!"".equals(aid)){
					getSession().setAttribute("allowGenerateC_"+getPara("aid"), "Y");
					return 1;
				}else {
					getSession().setAttribute("allowGenerateC_"+getPara("eid"), "Y");
					return 1;
				}
			}else {
				getSession().setAttribute("allowGenerateC_"+getPara("eid"), "N");
				return 2;
			}
		}		
	}

	@RequestMapping("/checkRepetitionRateQuestionExam")
	public @ResponseBody Map<String,Object> checkRepetitionRateQuestionExam() {
		String eid = getPara("eid");
		Map<String,Object> examinfo = paperService.getExamInfo(eid);
		String bid = (String) examinfo.get("BID");
		Map<String, Object> rtn = new HashMap<>();
		if (openFindRepeatSystem==1){
			RepeatABRate repeatABRate = statsApiClient.checkRepeatInfo(eid, bid);
			BigDecimal twentyPercent = BigDecimal.valueOf(0.2);
			BigDecimal tenPercent = BigDecimal.valueOf(0.1);
			if(repeatABRate==null){
				return rtn;
			}else if(repeatABRate.getPaperScoreRate4AIn3Years().compareTo(twentyPercent)>0){
				rtn.put("tip", "error");
				rtn.put("percentageA", repeatABRate.getPaperScoreRate4AIn3YearsPercent());
			}
			if(bid!=null && !"".equals(bid)){
				rtn.put("percentageA", repeatABRate.getPaperScoreRate4AIn3YearsPercent());
				rtn.put("percentageB", repeatABRate.getPaperScoreRate4BIn3YearsPercent());
				rtn.put("countB", repeatABRate.getPaperNum4AB());
				rtn.put("percentageAB", repeatABRate.getPaperRate4ABPercent());
			}
			if(repeatABRate.getPaperScoreRate4BIn3Years().compareTo(twentyPercent)>0){
				rtn.put("tip", "error");
			}
			if(repeatABRate.getPaperRate4AB().compareTo(tenPercent)>0){
				rtn.put("tip", "repeaterror");
			}
		}
		return rtn;
	}
	
	/**
	 * 验证是否已完成自动化测试，验证联系号码是否填写
	 * @author 洪艳
	 * @param /map/，传入参数（eid）
	 * @return 1,有 0,无
	 */
	@RequestMapping("/checkAutoTest")
	public @ResponseBody String checkAutoTest(){
		//查询是否已经测试
		String eid = getPara("eid");
		String bid = getPara("bid");
		String cpid = getPara("cpid");
		String fromWx = "";
		if(getPara("fromWx")!=null){
			fromWx = "，请在电脑端完成测试";
		}
		Map<String, Object> examinfo = paperService.getExamInfo(eid);
		int a = Utils.changeObjToInt(examinfo.get("AUTOTEST"));
		String tel = (String)examinfo.get("TEL");

		if (a!=1) {
			return "A卷模拟测试没有完成" + fromWx;
		}else if (StringUtils.isEmpty(tel)||"null".equals(tel)){
			return "A卷考务信息联系人电话为空，请补全";
		}
		List<Map<String, Object>> rs = paperService.getPaperNoScore(eid);
		if (rs.size()!=0) {
			String qids = "";
			for(int i=0;i<rs.size();i++) {
				qids += rs.get(i).get("QID")+",";
			}
			return "未赋分的试题编号为："+qids+"请赋分后重试";
		}
		List<Map<String,Object>> timeList=paperService.getExamQuestionTime(eid);
		int testMode = Utils.changeObjToInt(examinfo.get("TESTTIMESET"));
		int state=Integer.parseInt(String.valueOf(examinfo.get("STATE")));
		int timeS=0;
		boolean timeFlag=false;
		StringBuilder sb=new StringBuilder();
		for(Map<String,Object> tmap:timeList) {
			try {
				int tt=Integer.parseInt(String.valueOf(tmap.get("TIME")));
				if(tt<=30) {
					sb.append(tmap.get("TH")).append(",");
					timeFlag=true;
				}
				timeS=timeS+tt;
			}catch(Exception e) {
				return "A卷有试题未设置答题时间！";
			}
		}
		if(testMode==0 || testMode==3){
			int time = Utils.changeObjToInt(examinfo.get("EXAMTIME"));
			if(time<timeS){ //每小题用时之和是否小于或等于总用时
				return "A卷每小题答题时间总和大于考试用时，请调整每小题答题时间或总用时！";
			}
			if(state==0 && timeFlag) {
				return "timeError"+sb.substring(0, sb.length()-1);
			}
		}

		if(bid!=null&&!"".equals(bid)&&!"undefined".equals(bid)&&!"null".equals(bid)) {
			int timeSB=0;
			boolean timeFlagB=false;
			StringBuilder sbb=new StringBuilder();
			Map<String, Object> binfo = paperService.getExamInfo(bid);
			String telB = (String)binfo.get("TEL");
			int b = Utils.changeObjToInt(binfo.get("AUTOTEST"));
			if (b!=1) {
				return "B卷模拟测试没有完成"+ fromWx;
			}else if (StringUtils.isEmpty(telB)||"null".equals(telB)){
				return "B卷考务信息联系人电话为空，请补全！";
			}
			
			List<Map<String, Object>> brs = paperService.getPaperNoScore(bid);
			if (brs.size()!=0) {
				String qids = "";
				for(int i=0;i<brs.size();i++) {
					qids += brs.get(i).get("QID")+",";
				}
				return "B卷未赋分的试题编号为："+qids+"请赋分后重试";
			}
			
			List<Map<String,Object>> timeListB=paperService.getExamQuestionTime(bid);
			for(Map<String,Object> tmap:timeListB) {
				try {
					int tt=Integer.parseInt(String.valueOf(tmap.get("TIME")));
					if(tt<=30) {
						sbb.append(tmap.get("TH")+",");
						timeFlagB=true;
					}
					timeSB=timeSB+tt;
				}catch(Exception e) {
					return "B卷有试题未设置答题时间！";
				}
			}
			if(testMode==0 || testMode==3){
				int time=Utils.changeObjToInt(binfo.get("EXAMTIME"));
				if(time<timeSB){ //每小题用时之和是否小于或等于总用时
					return "B卷每小题答题时间总和大于考试用时，请调整每小题答题时间或总用时！";
				}
				if(state==0 && timeFlagB) {
					return "timeErrorB"+sbb.substring(0, sbb.length()-1);
				}
			}
		}

		if(cpid!=null&&!"".equals(cpid)&&!"undefined".equals(cpid)&&!"null".equals(cpid)) {
			int timeSC=0;
			boolean timeFlagC=false;
			StringBuilder sbc=new StringBuilder();
			Map<String, Object> cinfo = paperService.getExamInfo(cpid);
			String telC = (String)cinfo.get("TEL");
			int c = ((BigDecimal)cinfo.get("AUTOTEST")).intValue();
			if (c!=1) {
				return "C卷模拟测试没有完成"+ fromWx;
			}else if (StringUtils.isEmpty(telC)||"null".equals(telC)){
				return "C卷考务信息联系人电话为空，请补全！";
			}
			
			List<Map<String, Object>> crs = paperService.getPaperNoScore(cpid);
			if (crs.size()!=0) {
				String qids = "";
				for(int i=0;i<crs.size();i++) {
					qids += crs.get(i).get("QID")+",";
				}
				return "C卷未赋分的试题编号为："+qids+"请赋分后重试";
			}
			
			List<Map<String,Object>> timeListC=paperService.getExamQuestionTime(cpid);
			for(Map<String,Object> tmap:timeListC) {
				try {
					int tt=Integer.parseInt(String.valueOf(tmap.get("TIME")));
					if(tt<=30) {
						sbc.append(tmap.get("TH")+",");
						timeFlagC=true;
					}
					timeSC=timeSC+tt;
				}catch(Exception e) {
					return "C卷有试题未设置答题时间！";
				}
			}
			if(testMode==0 || testMode==3){
				int time=Utils.changeObjToInt(cinfo.get("EXAMTIME"));
				if(time<timeSC){ //每小题用时之和是否小于或等于总用时
					return "C卷每小题答题时间总和大于考试用时，请调整每小题答题时间或总用时！";
				}
				if(state==0 && timeFlagC) {
					return "timeErrorC"+sbc.substring(0, sbc.length()-1);
				}
			}
		}
		
		//检查是否已经选好初审人和终审人
		List<Map<String,Object>> audit_first=verifyService.getAudit_first(eid);
		List<Map<String,Object>> audit_last=verifyService.getAudit_last(eid);
		if(audit_first==null||audit_first.size()==0){
			return "试卷尚未设定初审人，请通过试卷列表的“权限设置”，电脑端设定初审人后再提交审核！";
		}
		if(audit_last==null||audit_last.size()==0){
			return "试卷尚未设定终审人，请通过试卷列表的“权限设置”，电脑端设定终审人后再提交审核！";
		}

		if(state == 1 && "1".equals(String.valueOf(examinfo.get("RANDOMANSWER")))) {
			String rtn=paperService.checkOption(eid);
			if(!"no".equals(rtn)) {
				return "检测到有选择题第"+rtn+"题的选项未做题目分离，请通知老师编辑试题后再提交终审！";
			}
		}
		return "1";
	}
	
	/**
	 * 选中删除
	 * @author li
	 */
	@RequestMapping("/deleteSelectPaper")
	public @ResponseBody String deleteSelectPaper(@RequestBody Map map) {
		ArrayList<Map<String, String>> list = (ArrayList<Map<String, String>>) map.get("data");
		for(int i=0;i<list.size();i++) {
			Map param = new HashMap();
			String eid = list.get(i).get("eid");
			param.put("eid", eid);
			param.put("permission", "paper:del");
			if(checkPaperPermission(param)==1){
				verifyService.deletePaper(eid, -1);
			}
		}
		return "1";
	}
	
	// 编辑考务信息
	@RequestMapping("/inEditExamInfo")
	public String inEditExamInfo() {
		String[] cids = getPara("cid").split(",");
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(map)==0){
				return "jsp/notTheRole";
			}
		}
		getRequest().setAttribute("ei_id", eid);
		getRequest().setAttribute("c_id", getPara("cid"));
		getRequest().setAttribute("monitor", getPara("monitor"));//用于判断是否从监考管理进入，监考管理进入编辑结束时间顺便修改student_exam_exam的时间，参数值为monitor
		
		if(cids.length==1){
			List<Map<String,Object>> clist=courseService.getCourseAttr(cids[0]);
			if(clist!=null&&clist.size()>0){
				getRequest().setAttribute("specialtyList", clist.get(0).get("specialtyList"));
				getRequest().setAttribute("examTypeList", clist.get(0).get("examTypeList"));
			}			
			getRequest().setAttribute("examInfo",paperService.getExamInfo(eid));
			getRequest().setAttribute("examObject",paperService.getExamObject(eid));
		}else{
			List<Map<String, Object>> specialtyList = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> examTypeList = new ArrayList<Map<String, Object>>();
			for(String cid:cids){		
				Map<String, Object> map=null;
				List<Map<String,Object>> cList=courseService.getCourseAttr(cid);
				if(cList!=null&&cList.size()>0){
					map=cList.get(0);
				}else{
					continue;
				}
				
				List<Map<String, Object>> specialtyls = (List<Map<String, Object>>) map.get("specialtyList");
				for(Map<String, Object> m:specialtyls){
					boolean b = true;
					for(Map<String, Object> mm:specialtyList){
						if(((String)mm.get("SPID")).equals((String)m.get("SPID"))){
							b = false;
							break;
						}
					}
					if(b){
						specialtyList.add(m);
					}
				}
				
				List<Map<String, Object>> ls = (List<Map<String, Object>>) map.get("examTypeList");
				for(Map<String, Object> m:ls){
					boolean b = true;
					for(Map<String, Object> mm:examTypeList){
						if(((String)mm.get("ETID")).equals((String)m.get("ETID"))){
							b = false;
							break;
						}
					}
					if(b){
						examTypeList.add(m);
					}
				}
			}
			getRequest().setAttribute("specialtyList", specialtyList);
			getRequest().setAttribute("examTypeList", examTypeList);
			getRequest().setAttribute("examInfo",paperService.getExamInfo(eid));
			getRequest().setAttribute("examObject",paperService.getExamObject(eid));
			getRequest().setAttribute("action","submitForVer");	
		}
		
		String organizationinfo_en="";
		try {
			organizationinfo_en=(String)((Map<String, Object>)getApplication().getAttribute("organizationinfo_en")).get("PARAM");
		}catch(Exception e) {}
		
		if("gmu".equals(organizationinfo_en)) {
			getRequest().setAttribute("jwc_kcdm", paperService.getJWC_KCDM());
			return "jsp/verify/editExamInfo4paper-gmu";
		}else {
			return "jsp/verify/editExamInfo4paper";
		}
	}
	
	@RequestMapping("/checkChangeStatePer")
	public @ResponseBody int checkChangeStatePer(){
		getSession().setAttribute("allowChangeStatePer", "Y");
		return 1;
	}
	
	//获取教师班级改卷权限
	@RequestMapping("/getTeacherClass")
	public @ResponseBody List<Map<String, Object>> getTeacherClass() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			String allowEditPermission=String.valueOf(getSession().getAttribute("allowEditPermission_"+eid));
			if("N".equals(allowEditPermission)||"null".equals(allowEditPermission)||"".equals(allowEditPermission)) {
				return null; 
			}
		}
		return verifyService.getTeacherClass(eid);
	}
	
	@RequestMapping("/checkSeparateOption")
	public @ResponseBody int checkSeparateOption() {
		String eid=getPara("eid");
		if(getUserInfo()==null){
			return 0;
		}
		Map<String,Object> lastVerifyMap = systemService.getSystemParam("lastverify");
		if(getUsername().equals(lastVerifyMap.get("YL_1")) || getUsername().equals(lastVerifyMap.get("YL_2"))
				||getUsername().equals(lastVerifyMap.get("YL_3")) || getUsername().equals(lastVerifyMap.get("YL_4"))) {
			getSession().setAttribute("allowLastVerify_"+eid, "Y");
			return 1;
		}
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(map)==0){
				return 0;
			}
		}
		if(paperService.getRandomanswer(eid)==1) {
			String rtn=paperService.checkOption(eid);
			if(!"no".equals(rtn)) {
				return 0;
			}
		}
		return 1;
	}

	@RequestMapping("/paperListOfUnit")
	public String paperListOfUnit() {
		Map<String, Object> m = new HashMap<>();
		m.put("unitid",getUserInfo().getUnitID());
		Set<String> cIDs=new HashSet<String>();
		if(getSubject().hasRole("administrator")){
			cIDs= getUserInfo().getcIDs();
			if(cIDs==null){
				cIDs=userService.findAllCids();
			}
		}else if(getSubject().hasRole("teachingoffice")){
			cIDs=userService.getCourseOfUnit(m);
		}else{
			return "";
		}

		m.put("cIDs", cIDs);

		List<String> cidstrList=getCidStrList(cIDs);
		m.put("cidstr", cidstrList);

		if(cIDs.size()>0) {
			getRequest().setAttribute("courseList", courseService.getCourseList(m));
		}else {
			getRequest().setAttribute("courseList", new ArrayList());
		}
		return "jsp/verify/paperListOfUnit";
	}

	@RequestMapping("/getPaperListOfUnit")
	public @ResponseBody Map<String, Object> getPaperListOfUnit() {
		Map m = new HashMap();
		m.put("tid",getUserID());
		if(getSubject().hasRole("administrator")||getSubject().hasRole("teachingoffice")){
			if(getSubject().hasRole("teachingoffice")){
				m.put("role", "teachingoffice");
			}
		}else{
			return null;
		}
		m.put("unitid",getUserInfo().getUnitID());
		PageUtils pu = getPageUtil();
		Enumeration<String> paramNames = getRequest().getParameterNames();
		while(paramNames.hasMoreElements()) {
			String key = paramNames.nextElement();
			String value = getRequest().getParameter(key);
			m.put(key, value);
		}
		String num = getPara("num");
		if (org.apache.commons.lang3.StringUtils.isNotBlank(num)) {
			num = num.replace("，", ",");
			String[] paramNums = num.split(",");
			boolean isPureNum = true;
			for (int i = 0; i < paramNums.length; i++) {
				paramNums[i] = paramNums[i].trim();
				if (!Utils.isNumeric(paramNums[i])) {
					isPureNum = false;
					break;
				}
			}
			if (isPureNum) {
				m.remove("num");
				m.put("manyNums", paramNums);
			} else {
				m.put("num", num.trim());
			}
		}
		List<Map<String,Object>> list=verifyService.getPaperListOfUnit(m, pu);
		for(Map<String,Object> map:list){
			List<Map<String,Object>> eo=(List<Map<String, Object>>) map.get("eo");
			Set<String> gset= new HashSet<>();
			Set<String> sset= new HashSet<>();
			if(eo!=null&&eo.size()>0){
				for(Map<String,Object> em:eo){
					gset.add(String.valueOf(em.get("GNAME")));
					sset.add(String.valueOf(em.get("SNAME")));
				}
				map.put("GNAME", String.join(",",gset));
				map.put("SNAME", String.join(",", sset));
			}else{
				map.put("GNAME", "");
				map.put("SNAME", "");
			}
		}
		return getRes(list, verifyService.getPaperOfUnitCount(m));
	}
}
