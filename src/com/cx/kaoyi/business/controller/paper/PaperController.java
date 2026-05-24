package com.cx.kaoyi.business.controller.paper;


import java.math.BigDecimal;
import java.text.ParseException;
import java.util.*;

import com.alibaba.fastjson2.JSONArray;
import com.alibaba.fastjson2.JSONObject;
import com.cx.kaoyi.business.service.*;
import com.cx.kaoyi.framework.base.FileDownloadUtils;


import com.cx.kaoyi.framework.cache.LocalCache;
import com.cx.kaoyi.framework.question.dto.DuplicatePairDTO;
import com.cx.kaoyi.framework.question.dto.QuestionStatDto;
import com.cx.kaoyi.framework.question.repeat.PaperChangeRecorder;
import com.cx.kaoyi.framework.question.repeat.StatsApiClient;

import com.cx.kaoyi.framework.utils.*;
import com.cx.kaoyi.framework.utils.Image.ImgUtil;
import com.cx.kaoyi.framework.utils.result.GenerateWordUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.framework.base.BaseController;

import javax.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/paper")
public class PaperController extends BaseController{
	@Value("${wj_cid}")
	private String wj_cid;

	@Value("${openFindRepeatSystem:0}")
	private Integer openFindRepeatSystem;
	
	@Autowired
	public PaperService paperService;
	
	@Autowired
	public CourseService courseService;
	
	@Autowired
	public QuestionService questionService;

	@Autowired
	public CommonService commonService;
	
	@Autowired
	public VerifyService verifyService;
	
	@Autowired
	public UserService userService;
	
	@Autowired
	public SystemService systemService;
	
	@Autowired
	public PoiService poiService;

	@Autowired
	private StatsApiClient statsApiClient;

	@Autowired
	private PaperChangeRecorder paperChangeRecorder;

	// 进入结构化组卷
	@RequestMapping("/inCommonPaper")
	public String inCommonPaper() {
		if("1".equals(getApplication().getAttribute("paperdate_switch"))){
			if(!getSubject().hasRole("administrator")){
				User u = getUserInfo();
				int isMobile = 0;
				List<Map<String, Object>> res = paperService.getTeacherMarkPaper(u.getId(),isMobile);
				if(res!=null && res.size()>0) {
					for(Map<String, Object> s: res){
						String endDate = (String) s.get("ENDDATE");
						if(DateFormatUtils.isEndDateExceedsMonths(endDate) >2) {
							getRequest().setAttribute("isMobile", isMobile);
							return "jsp/unablePaper";
						}
					}
				}
			}
		}
		return "jsp/paper/inCommonPaper";
	}
	
	// 进入手工组卷
	@RequestMapping("/inCommonPaper1")
	public String inCommonPaper1() {
		if("1".equals(getApplication().getAttribute("paperdate_switch"))){
			if(!getSubject().hasRole("administrator")){
				User u = getUserInfo();
				int isMobile = 0;
				List<Map<String, Object>> res = paperService.getTeacherMarkPaper(u.getId(),isMobile);
				if(res!=null && res.size()>0) {
					for(Map<String, Object> s: res){
						String endDate = (String) s.get("ENDDATE");
						if(DateFormatUtils.isEndDateExceedsMonths(endDate) >2) {
							getRequest().setAttribute("isMobile", isMobile);
							return "jsp/unablePaper";
						}
					}
				}
			}
		}
		return "jsp/paper/inCommonPaper1";
	}
	
	// 进入按难度组卷
	@RequestMapping("/inDifficultyPaper")
	public String inDifficultyPaper() {
		if("1".equals(getApplication().getAttribute("paperdate_switch"))){
			if(!getSubject().hasRole("administrator")){
				User u = getUserInfo();
				int isMobile = 0;
				List<Map<String, Object>> res = paperService.getTeacherMarkPaper(u.getId(),isMobile);
				if(res!=null && res.size()>0) {
					for(Map<String, Object> s: res){
						String endDate = (String) s.get("ENDDATE");
						if(DateFormatUtils.isEndDateExceedsMonths(endDate) >2) {
							getRequest().setAttribute("isMobile", isMobile);
							return "jsp/unablePaper";
						}
					}
				}
			}
		}
		return "jsp/paper/inDifficultyPaper";
	}
	
	@RequestMapping("/getDifficultQuestionCount")
	public @ResponseBody List<Map<String, Object>> getDifficultTable(){
		Map param = new HashMap();
		int Sys_forbidDay = Utils.changeObjToInt(getApplication().getAttribute("question_used_day"));//获取系统设置好的限制次数（parseint）
		int forbidDay = Math.min(Utils.changeObjToInt(getPara("forbidDay"), Sys_forbidDay),
				Sys_forbidDay == 0 ? Integer.MAX_VALUE : Sys_forbidDay);

		int Sys_forbidNum = Utils.changeObjToInt(getApplication().getAttribute("question_use_time"));//获取系统设置好的限制次数（parseint）
		int forbidNum = Math.min(Utils.changeObjToInt(getPara("forbidNum"), Sys_forbidNum),
				Sys_forbidNum == 0 ? Integer.MAX_VALUE : Sys_forbidNum);

		int limit4Isreview = Utils.changeObjToInt(getApplication().getAttribute("limit4Isreview"));
		int isVerified = (limit4Isreview == 1)
				? 1 : Utils.changeObjToInt(getPara("isVerified"), limit4Isreview);

		param.put("forbidBefore", forbidDay);	//组卷时限定多少天以前出过的试题不再出
		param.put("forbidNum",forbidNum);	//组卷时限定多少次以上出过的试题不再出
		param.put("isVerified", isVerified);	//组卷时限定试题是否通过审核
		
		param.put("cid", getPara("cid"));
		return paperService.getDifficultQuestionCount(param);
	}
	
	/**
	 * 结构化组卷,取消组卷
	 * @author yoyo
	 * 黎青华修改，取消组卷不删除试卷
	 * @return
	 */
	@RequestMapping("/cancelCommonPaper")
	public String cancelCommonPaper(){
		/*String eid = getPara("eid");
		paperService.deleteExampaper(eid);*/
		return "jsp/paper/inCommonPaper";
	}
	
	@RequestMapping("/cancelDifficultyPaper")
	public String cancelDifficultyPaper() {
		return "jsp/paper/inDifficultyPaper";
	}
	
	/**@author 黎青华
	 * 进入编辑信息调用editMultiCourseExamInfo
	 * 进入合并组卷
	 */
	@RequestMapping("/inCombinePaper")
	public String inCombinePaper() {
		if("1".equals(getApplication().getAttribute("paperdate_switch"))){
			if(!getSubject().hasRole("administrator")){
				User u = getUserInfo();
				int isMobile = 0;
				List<Map<String, Object>> res = paperService.getTeacherMarkPaper(u.getId(),isMobile);
				if(res!=null && res.size()>0) {
					for(Map<String, Object> s: res){
						String endDate = (String) s.get("ENDDATE");
						if(DateFormatUtils.isEndDateExceedsMonths(endDate) >2) {
							getRequest().setAttribute("isMobile", isMobile);
							return "jsp/unablePaper";
						}
					}
				}
			}
		}
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
		getRequest().setAttribute("nowTime", new Date().getTime());
		return "jsp/paper/inCombinePaper";
	}
	
	/**@author 洪艳
	 * 合并组卷，取消组卷
	 */
	@RequestMapping("/cancelCombinePaper")
	public String cancelCombinePaper() {
		String eid = getPara("eid");
		paperService.deleteExampaper(eid);
		return "jsp/paper/inCombinePaper";
	}
	
	/**添加合并考卷考务信息
	 * @throws ParseException
	 */
	@RequestMapping("/addExamInfo4CombinePaper")
	public String addExamInfo4CombinePaper(RedirectAttributes ra) throws ParseException {
		Map<String,Object> param = new HashMap<>();
		String cid = getPara("c_id");
		User u = getUserInfo();
		String[] cids = cid.split(",");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("permission", "paper:add");
			for(String cc:cids) {
				map.put("cid", cc);
				if(courseService.checkCoursePermission(map,getUserID()+"_"+cid)==0){
					return "jsp/notTheRole";
				}
			}			
		}
		
		param.put("teacherid", u.getId()); //教师id
		param.put("cid", cid);		//课程id
		param.put("cname", getPara("c_name")); //课程名
		param.put("code", getPara("code"));	//课程代码
		param.put("period", getPara("period"));	//学时
		param.put("ename", getPara("ename"));	//试卷名称
		param.put("schoolYear", getPara("schoolYear")); //考试学年
		param.put("term", getPara("term"));	//考试学期
		param.put("type", getPara("examType"));	//考试类型
		param.put("testway", getPara("examWay")); //开闭卷
		param.put("total", getPara("total"));	//考试应到人数
		param.put("printcount", getPara("pcount"));	//打印份数
		param.put("proportion", getPara("percent"));	//成绩比例
		if(StringUtils.isEmpty(getPara("bt"))){
			ra.addAttribute("c_id", cid);
			return "redirect:/paper/editExamInfo";
		}
		if(StringUtils.isEmpty(getPara("et"))){
			ra.addAttribute("c_id", cid);
			return "redirect:/paper/editExamInfo";
		}
		param.put("begindate", Utils.getDateFromStr(getPara("bt"),"yyyy-MM-dd HH:mm")); //开始时间
		param.put("enddate", Utils.getDateFromStr(getPara("et"),"yyyy-MM-dd HH:mm")); //结束时间
		param.put("time", getPara("time"));		//考试用时
		param.put("missionnum", getPara("missionnum"));		//通用号	
		param.put("lockBefore", getPara("loginBefore"));	//开考前多少分钟禁止登录
		param.put("lockAfter", getPara("loginAfter"));	//开考后多少分钟后禁止登录
		param.put("scheckway", getPara("queryScore"));	//成绩开放给学生查看
		param.put("getanswer", getPara("queryPaper"));	//考试答案开放给学生查看
		param.put("testtimeset", getPara("testMode"));	//考试方式
		param.put("randomanswer", getPara("randomAnswer")); //选项随机
		param.put("answerSequence", getPara("answerSequence"));	//答题顺序
		param.put("tasknum_switch", "0"); //是否启用任务号
		param.put("switch_out_limit", getPara("switchOutLimitSelect")); //切屏限制
		param.put("correctway", getPara("correctPaper"));	//改卷方式
		param.put("remark2s", getPara("remark2s"));	//考试时给学生看的备注
		param.put("e_remark2s", getPara("e_remark2s"));	//考试时给学生看的备注
		param.put("remark2t", getPara("remark2t"));	//教师添加的考试备注

		int Sys_forbidDay = Utils.changeObjToInt(getApplication().getAttribute("question_used_day"));//获取系统设置好的限制次数（parseint）
		int forbidDay = Math.min(Utils.changeObjToInt(getPara("forbidDay"), Sys_forbidDay),
				Sys_forbidDay == 0 ? Integer.MAX_VALUE : Sys_forbidDay);

		int Sys_forbidNum = Utils.changeObjToInt(getApplication().getAttribute("question_use_time"));//获取系统设置好的限制次数（parseint）
		int forbidNum = Math.min(Utils.changeObjToInt(getPara("forbidNum"), Sys_forbidNum),
				Sys_forbidNum == 0 ? Integer.MAX_VALUE : Sys_forbidNum);

		int limit4Isreview = Utils.changeObjToInt(getApplication().getAttribute("limit4Isreview"));
		int isVerified = (limit4Isreview == 1)
				? 1 : Utils.changeObjToInt(getPara("isVerified"), limit4Isreview);

		param.put("forbidBefore", forbidDay);	//组卷时限定多少天以前出过的试题不再出
		param.put("forbidNum", forbidNum);	//组卷时限定多少次以上出过的试题不再出
		param.put("isVerified", isVerified);	//组卷时限定试题是否通过审核
		param.put("depid", u.getDepID());	//组卷人所在科室id
		param.put("teachername", u.getUsername());	//组卷人用户名
		param.put("tel", getPara("tel"));	//组卷人联系电话
		param.put("sidverify", getPara("sidVer"));	//是否验证学号考试
		param.put("facetime", getPara("facetime"));	//人脸识别次数
		param.put("facefail", getPara("face_fail"));
		if(getPara("facetime")==null || !"2".equals(getPara("sidVer"))){
			param.put("facetime", 0);//人脸识别次数
			param.put("facefail", 0);
		}
		param.put("invigilatorids", getPara("invigilator")); //监考老师id
		param.put("patrolids", getPara("patrolids")); //巡考老师id
		param.put("createTime", new Date());
		String[] arr = getParaValues("testObj");
		if(arr == null || arr.length == 0){	//未选考试对象时，返回考务信息
			ra.addAttribute("c_id", cid);
			return "redirect:/paper/editExamInfo";
		}
		List<Map> list = new ArrayList<>();
		for(String a:arr){
			String[] s = a.split(",");
			Map m = new HashMap();
			m.put("grade", s[0]);
			m.put("specialty", s[1]);
			list.add(m);
		}
		param.put("objectList", list);
		param.put("isUnion", getPara("isUnion"));
		param.put("editor_switch",getPara("editorSwitch"));
		param.put("randomSwitch", getPara("randomSwitch"));
		
		String unitID="";
		for(String s:cids){
			String unitID_2=courseService.getCourse_UnitID(s);
			if("".equals(unitID)){
				unitID=unitID_2;
			}else{
				if(!unitID.equals(unitID_2)){
					unitID=u.getUnitID();
					break;
				}
			}
		}
		param.put("unitid", unitID);	//组卷人所在单位id
		String answersheet=getPara("answersheet");
		if(answersheet!=null&&!"undefined".equals(answersheet)&& !"".equals(answersheet)){
			param.put("answersheet", answersheet);
		}
		paperService.addExamInfo4MultiCourse(param);
		getRequest().setAttribute("eid", param.get("id"));
		
		String[] cnames = getPara("c_name").split(",");
		getRequest().setAttribute("cid", cid);
		getRequest().setAttribute("c_ids", cids);
		getRequest().setAttribute("cname", cnames);
		getRequest().setAttribute("eids", getSession().getAttribute("eids"));
		
		Map m = new HashMap();
		String[] eids = getSession().getAttribute("eids").toString().split(",");
		m.put("eid", eids);
		if(cids.length == 1) {
			m.put("cid", cid);
			getRequest().setAttribute("courseInfo", paperService.getPaperFilter(m));
			getRequest().setAttribute("cname", courseService.getCourseNameById(cids).get(0).get("NAME_C"));
		}else{
			getRequest().setAttribute("courseInfo", paperService.getPaperFilter(m));
			getRequest().setAttribute("courseList", courseService.getCourseNameById(cids));
		}
		getRequest().setAttribute("state", getPara("state"));
		
		Map log = new HashMap();
		log.put("content", "通过了“合并组卷”创建了试卷《"+getPara("ename")+"》,试卷编号为"+param.get("id"));
		log.put("cid", cid);
		systemService.addSysLog(log);
		
		getRequest().setAttribute("forbidDay", forbidDay);
		getRequest().setAttribute("forbidNum", forbidNum);
		getRequest().setAttribute("isVerified", isVerified);
		
		return "jsp/paper/QuestionFromPaper4CombinePaper";
	}
	
	// 进入编辑考务信息
	@RequestMapping("/editExamInfo")
	public String editExamInfo() {
		String cid = getPara("c_id");
		getRequest().setAttribute("c_id", cid);
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("cid", cid);
			map.put("permission", "paper:add");
			if(courseService.checkCoursePermission(map,getUserID()+"_"+cid)==0){
				return "jsp/notTheRole";
			}
		}
		
		Map<String, Object> map = courseService.getCourseAttr(cid).get(0);
		getRequest().setAttribute("courseInfo", map);
		String cnames = map.get("name_c")+"";
		getRequest().setAttribute("examInfo", paperService.getDefaultExamInfo("1"));
		getRequest().setAttribute("ename", cnames);
		getRequest().setAttribute("c_name", cnames);
		getRequest().setAttribute("examTypeList", map.get("examTypeList"));
		getRequest().setAttribute("code", map.get("code"));
		getRequest().setAttribute("period", map.get("period"));
		getRequest().setAttribute("contact", map.get("contact"));
		getRequest().setAttribute("way", getPara("way"));
		getRequest().setAttribute("user", getUserInfo());
		
		String organizationinfo_en="";
		try {
			organizationinfo_en=(String)((Map<String, Object>)getApplication().getAttribute("organizationinfo_en")).get("PARAM");
		}catch(Exception e) {}
		
		if("gmu".equals(organizationinfo_en)) {
			getRequest().setAttribute("jwc_kcdm", paperService.getJWC_KCDM());
			return "jsp/paper/examInfo-gmu";
		}else {
			return "jsp/paper/examInfo";
		}
	}
	
	// 返回编辑考务信息
	@RequestMapping("/cancelStructure")
	public String cancelStructure() {
		String cid = getPara("cid");
		paperService.deleteExampaper(getPara("eid"));
		getRequest().setAttribute("c_id", cid);
		getRequest().setAttribute("c_name", courseService.getCourseAttr(cid).get(0).get("name_c"));
		getRequest().setAttribute("examTypeList", courseService.getCourseAttr(cid).get(0).get("examTypeList"));
		getRequest().setAttribute("code", courseService.getCourseAttr(cid).get(0).get("code"));
		getRequest().setAttribute("period", courseService.getCourseAttr(cid).get(0).get("period"));
		getRequest().setAttribute("way", getPara("way"));
		getRequest().setAttribute("user", getUserInfo());
		return "jsp/paper/examInfo";
	}
		
	// 结构化组卷，添加考务信息
	@RequestMapping("/addExamInfo")
	public String addExamInfo(RedirectAttributes ra) throws ParseException {
		Map param = new HashMap();
		String cid = getPara("c_id");
		User u = getUserInfo();
		
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("cid", cid);
			map.put("permission", "paper:add");
			if(courseService.checkCoursePermission(map,getUserID()+"_"+cid)==0){
				return "jsp/notTheRole";
			}
		}
		String ename = getPara("ename");
		if(StringUtils.isEmpty(ename)){
			ra.addAttribute("c_id", cid);
			return "redirect:/paper/editExamInfo";
		}
		param.put("teacherid", u.getId()); //教师id
		param.put("cid", cid);		//课程id
		param.put("cname", getPara("c_name")); //课程名
		param.put("code", getPara("code"));	//课程代码
		param.put("period", getPara("period"));	//学时
		param.put("ename", ename);	//试卷名称
		param.put("schoolYear", getPara("schoolYear")); //考试学年
		param.put("term", getPara("term"));	//考试学期
		param.put("type", getPara("examType"));	//考试类型
		param.put("testway", getPara("examWay")); //开闭卷
		param.put("total", getPara("total"));	//考试应到人数
		param.put("printcount", getPara("pcount"));	//打印份数
		param.put("proportion", getPara("percent"));	//成绩比例
		if(StringUtils.isEmpty(getPara("bt"))){
			ra.addAttribute("c_id", cid);
			return "redirect:/paper/editExamInfo";
		}
		if(StringUtils.isEmpty(getPara("et"))){
			ra.addAttribute("c_id", cid);
			return "redirect:/paper/editExamInfo";
		}
		param.put("begindate", Utils.getDateFromStr(getPara("bt"),"yyyy-MM-dd HH:mm")); //开始时间
		param.put("enddate", Utils.getDateFromStr(getPara("et"),"yyyy-MM-dd HH:mm")); //结束时间
		param.put("time", getPara("time"));		//考试用时
		param.put("missionnum", getPara("missionnum"));		//通用号	
		param.put("lockBefore", getPara("loginBefore"));	//开考前多少分钟禁止登录
		param.put("lockAfter", getPara("loginAfter"));	//开考后多少分钟后禁止登录
		param.put("scheckway", getPara("queryScore"));	//成绩开放给学生查看
		param.put("getanswer", getPara("queryPaper"));	//考试答案开放给学生查看
		param.put("testtimeset", getPara("testMode"));	//考试方式
		param.put("tasknum_switch", "0"); //是否启用任务号
		param.put("switch_out_limit", getPara("switchOutLimitSelect")); //切屏限制
		param.put("randomanswer", getPara("randomAnswer")); //选项随机
		param.put("answerSequence", getPara("answerSequence"));	//答题顺序
		param.put("correctway", getPara("correctPaper"));	//改卷方式
		param.put("remark2s", getPara("remark2s"));	//考试时给学生看的备注
		param.put("e_remark2s", getPara("e_remark2s"));	//英文版备注
		param.put("remark2t", getPara("remark2t"));	//教师添加的考试备注

		int Sys_forbidDay = Utils.changeObjToInt(getApplication().getAttribute("question_used_day"));//获取系统设置好的限制次数（parseint）
		int forbidDay = Math.min(Utils.changeObjToInt(getPara("forbidDay"), Sys_forbidDay),
				Sys_forbidDay == 0 ? Integer.MAX_VALUE : Sys_forbidDay);
		
		int Sys_forbidNum = Utils.changeObjToInt(getApplication().getAttribute("question_use_time"));//获取系统设置好的限制次数（parseint）
		int forbidNum = Math.min(Utils.changeObjToInt(getPara("forbidNum"), Sys_forbidNum),
				Sys_forbidNum == 0 ? Integer.MAX_VALUE : Sys_forbidNum);

		int limit4Isreview = Utils.changeObjToInt(getApplication().getAttribute("limit4Isreview"));
		int isVerified = (limit4Isreview == 1)
				? 1 : Utils.changeObjToInt(getPara("isVerified"), limit4Isreview);


		param.put("forbidBefore", forbidDay);	//组卷时限定多少天以前出过的试题不再出
		param.put("forbidNum",forbidNum);	//组卷时限定多少次以上出过的试题不再出
		param.put("isVerified", isVerified);	//组卷时限定试题是否通过审核
		param.put("createTime", new Date());
		param.put("depid", u.getDepID());	//组卷人所在科室id
		param.put("unitid", courseService.getCourse_UnitID(cid));	//组卷人所在单位id
		param.put("teachername", u.getUsername());	//组卷人用户名
		param.put("tel", getPara("tel"));	//组卷人联系电话
		param.put("sidverify", getPara("sidVer"));	//是否验证学号考试,是否人脸识别
		param.put("facetime", getPara("facetime"));	//人脸识别次数
		param.put("facefail", getPara("face_fail"));
		if(getPara("facetime")==null || !"2".equals(getPara("sidVer"))){
			param.put("facetime", 0);//人脸识别次数
			param.put("facefail", 0);
		}
		param.put("invigilatorids", getPara("invigilator")); //监考老师id
		param.put("patrolids", getPara("patrolids")); //巡考老师id
		String[] arr = getParaValues("testObj");
		if(arr == null || arr.length == 0){	//未选考试对象时，返回考务信息
			ra.addAttribute("c_id", cid);
			return "redirect:/paper/editExamInfo";
		}
		List<Map> list = new ArrayList<>();
		for(String a:arr){
			String[] s = a.split(",");
			Map m = new HashMap();
			m.put("grade", s[0]);
			m.put("specialty", s[1]);
			list.add(m);
		}
		param.put("objectList", list);
		param.put("venues", getPara("venues"));
		if(getPara("isUnion")!=null&&!"undefined".equals(getPara("isUnion"))){
			param.put("isUnion", getPara("isUnion"));
		}
		param.put("editor_switch",getPara("editorSwitch"));
		param.put("randomSwitch", getPara("randomSwitch"));
		if(getPara("mobile")!=null&&!"undefined".equals(getPara("mobile"))){
			/*if("1".equals(getPara("mobile"))){
				param.put("mobile", 2);
			}*/
			param.put("mobile", getPara("mobile"));
		}
		String answersheet=getPara("answersheet");
		if(answersheet!=null&&!"undefined".equals(answersheet)&& !"".equals(answersheet)){
			param.put("answersheet", answersheet);
		}
		param.put("handInTimeLimit",getPara("handInTimeLimit"));
		paperService.addExamInfo(param);
		
		String way = getPara("way");
		getRequest().setAttribute("ei_id", param.get("id"));
		
		getRequest().setAttribute("c_id", cid);
		Map m = new HashMap();
		m.put("forbidDay", forbidDay);
		m.put("forbidNum", forbidNum);
		m.put("isVerified",isVerified);
		getRequest().setAttribute("forbidDay", forbidDay);
		getRequest().setAttribute("forbidNum", forbidNum);
		getRequest().setAttribute("isVerified", isVerified);
		m.put("id", cid);
		m.put("cid", cid);
		
		getRequest().setAttribute("distributionStatistics", questionService.getDistributionStatistics(m));  //根据主题词，题型获取试题分布统计
		getRequest().setAttribute("difficultyDistribution", questionService.getDifficultyDistribution2(m));
		getRequest().setAttribute("themeList", questionService.getQuestionFilterByTheme1_2(m));
		getRequest().setAttribute("questionTypeList", questionService.getAllQT4CourseQuestion(m));		
		
		if(way.equals("0")){	//当way为0时，结构化组卷， 否则手工组卷
			Map log = new HashMap();
			log.put("content", "通过了“结构化组卷”创建了试卷《"+ename+"》,试卷编号为"+param.get("id"));
			log.put("cid", cid);
			systemService.addSysLog(log);
			return "jsp/paper/structure";
		}else if(way.equals("1")){
			Map log = new HashMap();
			log.put("content", "通过了“手工组卷”创建了试卷《"+ename+"》,试卷编号为"+param.get("id"));
			log.put("cid", cid);
			systemService.addSysLog(log);
			List<Map<String, Object>> courseAttrList = courseService.getCourseAttr(cid);//课程信息
			getRequest().setAttribute("courseInfo", courseAttrList);
			getRequest().setAttribute("questionFilter", questionService.getQuestionFilter(cid));//主题词
			return "jsp/paper/manual";
		}else if(way.equals("4")) {
			Map log = new HashMap();
			log.put("content", "通过“按难度组卷”创建了试卷《"+ename+"》,试卷编号为"+param.get("id"));
			log.put("cid", cid);
			systemService.addSysLog(log);
			return "jsp/paper/difficultPaper";
		}else {
			return null;
		}
	}
	
	@RequestMapping("getAllQT4CourseQuestion")
	public @ResponseBody List<Map<String, Object>> getAllQT4CourseQuestion(){
		Map param=new HashMap();
		param.put("forbidDay", getPara("forbidDay"));
		param.put("forbidNum", getPara("forbidNum"));
		param.put("isVerified",getPara("isVerified"));
		param.put("cid", getPara("cid"));
		return questionService.getAllQT4CourseQuestion(param);
	}	

	//结构化组卷=>调整分值
	@RequestMapping("/structure")
	public String structure() {
		int sd = Utils.changeObjToInt(getPara("sdiff"));
		int md = Utils.changeObjToInt(getPara("mdiff"));
		int dd = Utils.changeObjToInt(getPara("ddiff"));

		double sdiffRatio = (double)sd / (sd + md + dd);
		double mdiffRatio = (double)md / (sd + md + dd);
		double ddiffRatio = (double)dd / (sd + md + dd);
        
		String c_id = getPara("c_id");
		String ei_id = getPara("ei_id");
		if(getPara("buildWay")!=null&&"1".equals(getPara("buildWay"))){
			paperService.rebuildA(ei_id);//重新组A卷，删除原A卷信息
		}
		Map<String,Object> examinfo = paperService.getExamInfo(ei_id);

		int forbidNum = Utils.changeObjToInt(getPara("forbidNum"), 999999);
		int forbidDay = Utils.changeObjToInt(getPara("forbidDay"), 999999);
		int isVerified = Utils.changeObjToInt(getPara("isVerified"));

		int Sys_forbidDay = Utils.changeObjToInt(examinfo.get("FORBIDBEFORE"));
		int Sys_forbidNum = Utils.changeObjToInt(examinfo.get("FORBIDNUM"));

		if(forbidNum>Sys_forbidNum) {
			forbidNum=Sys_forbidNum;
		}
		if(forbidDay>Sys_forbidDay) {
			forbidDay=Sys_forbidDay;
		}
		
		Map par = new HashMap();
		par.put("eid", ei_id);
		par.put("forbidDay", forbidDay);
		par.put("forbidNum", forbidNum);
		par.put("isVerified", isVerified);		
		paperService.saveExaminfoQuestionFilterParam(par);
		
		Map param = new HashMap();
		param.put("ei_id", ei_id);
		
		String questionNum = getPara("questionNum").replaceAll("&quot;", "\"");	//结构化组卷填写的参数
		List<Map> n = JSONObject.parseObject(questionNum,List.class);

		List<List<Map<String, Object>>> nAll=new ArrayList<>();//保存非主题干，用于计算难度分布
		List<List<Map<String, Object>>> mAll=new ArrayList<>();//保存主题干
		List<double[]> diffList = new ArrayList<>();
		List<Map> mlist=new ArrayList<>();
		
		for(int i=0;i<10;i++){
			List<Map<String, Object>> nlist = new ArrayList<>();
			List<Map<String, Object>> mainlist = new ArrayList<>();
			Iterator<Map> nit = n.iterator();
			while (nit.hasNext()) {
	            JSONObject ob = (JSONObject) nit.next();
	            if(Utils.NotEmpty(ob.getString("qnum"))){
	                Map m = new HashMap();
	                m.put("cid", c_id);
	                m.put("num", ob.getString("qnum"));
	                m.put("thid", ob.getString("qthid"));
	                m.put("thid_pid", ob.getString("qthid_parent"));
	                m.put("qtid", ob.getString("qtid"));
	                m.put("thlevel", ob.getString("thlevel"));
	                m.put("eid", ei_id);
	                if(isVerified==1){
	                	m.put("isVerified", isVerified);
	                }
	                if(forbidDay>0){
	                	m.put("forbidDay", forbidDay);
	                }
	                if(forbidNum>=1){
	                	m.put("forbidNum", forbidNum);
	                }
	            	String iscon = ob.getString("iscon");
	            	if(iscon.equals("1")){
	            		List<Map<String, Object>> res = paperService.getMqids(m); //当选中题型为串题时，查看有没有对应该题型和主题词的小题
	            		if(res!=null && res.size()>0){//能抽出题目
	            			int branchNum = ((BigDecimal)res.get(0).get("QSUM")).intValue();
		            		int num = Integer.parseInt((String)m.get("num"));
		            		if(branchNum<num){
		            			int next=10;
		            			while(next>0){
		            				m.put("mqids", res);
		                			m.put("extra_num", num-branchNum);
		                			Map<String,Object> extra = paperService.getMqids_extra(m);
		                			if(extra==null){
		                				break;
		                			}
		                			res.add(extra);
		                			branchNum = branchNum+((BigDecimal)extra.get("COUNT")).intValue();
		                			if(branchNum>=num){
		                				break;
		                			}
		                			next--;
		            			}            			
		            		}
		            		
	            		}else{//抽不出题目
	            			Map<String,Object> mqid_null = paperService.getMqids_null(m);
	            			if(mqid_null!=null){
	            				res.add(mqid_null);
	            			}
	            			
	            		}
	            		if(res!=null && res.size()>0){
	            			for(Map<String, Object> s: res){
		            			s.put("cid", c_id);
		            			s.put("ei_id", ei_id);
		            			mainlist.add(s);  
		            		}
		            		
		            		List<Map<String,Object>> branch = paperService.getBrachByMqid(res);
		            		for(Map<String, Object> s:branch){
		            			s.put("EID", ei_id);
		            			nlist.add(s); 
		            		}
	            		}	            		
	            	}else{
	            		List<Map<String, Object>> qList =  paperService.getRandomQuestion(m);
	            		for(Map<String, Object> s: qList){
	            			s.put("EID", ei_id);
	            			nlist.add(s);  //非串题
	            		}
	            	}
		            if(i==0){
		            	mlist.add(m);
		            }
	            }
	        }
			int stemp = 0;
    		int mtemp = 0;
    		int dtemp = 0;
    		double diff_array[] = new double[3]; 
    		for(Map<String,Object> bm:nlist){
    			int diff = ((BigDecimal)bm.get("DIFFICULTYID")).intValue();
				if(diff==1){
					stemp ++;
				}
				if(diff==2){
					mtemp++;
				}
				if(diff==3){
					dtemp++;
				}
			}
    		diff_array[0] = (double)stemp/(stemp+mtemp+dtemp);
    		diff_array[1] = (double)mtemp/(stemp+mtemp+dtemp);
    		diff_array[2] = (double)dtemp/(stemp+mtemp+dtemp);
			nAll.add(nlist);
			mAll.add(mainlist);		
			diffList.add(diff_array);
		}
		
		double gab[] = new double[10];
		for(int i=0;i<diffList.size();i++){
			double[] diff = diffList.get(i);
			double sum = 0;
			sum += Math.abs(diff[0]-sdiffRatio);
			sum += Math.abs(diff[1]-mdiffRatio);
			sum += Math.abs(diff[2]-ddiffRatio);
			gab[i]=sum;			
		}
		
		int min_index = 0;
		double min = gab[0];
		for(int i=1;i<gab.length;i++){
			if(gab[i]<min){
				min = gab[i];
				min_index = i;
			}
		}
        
		param.put("question", nAll.get(min_index));
		param.put("mainQuestion", mAll.get(min_index));
		param.put("mquestion", mlist);
		
		if(mlist.size() > 0){
			paperService.structurePaper(param);
		}
		
		//更新题型分数
		List<Map<String,Object>> exampaperQuestionTypeList=paperService.getExampaperQuestionTypeList(ei_id);
		String qtscore = getPara("qtscore").replaceAll("&quot;", "\"");	//结构化组卷填写的参数
		List<Map> s = JSONObject.parseObject(qtscore,List.class);
		Iterator<Map> sit = s.iterator();
		Map sm = new HashMap();
		while (sit.hasNext()) {
            JSONObject ob = (JSONObject) sit.next();
            sm.put(ob.getString("qtid"), ob.getString("qtscore"));            
        }
		Iterator it = sm.entrySet().iterator();  
		while (it.hasNext()) {  
			Map.Entry entry = (Map.Entry) it.next(); 
			Map m = new HashMap();
			String qtid=(String) entry.getKey();
			for(Map<String,Object> eqt:exampaperQuestionTypeList){
				if(qtid.equals(String.valueOf(eqt.get("QTID")))){
					int xxdf=Utils.changeObjToInt(eqt.get("XXDF"));
					if(xxdf==1){
						//获取题型的总得分
						Map eqtm=new HashMap();
						eqtm.put("qtid", eqt.get("QTID"));
						eqtm.put("eid", ei_id);
						Map<String,Object> eqt_score=paperService.getZF_qtid(eqtm);
						eqt.put("SCORE", eqt_score.get("SCORE"));
						continue;
					}else{
						m.put("qtid", entry.getKey());
			            m.put("qtscore", entry.getValue());
			            m.put("qttime", "-1");
			            m.put("ei_id", ei_id);
						eqt.put("SCORE", entry.getValue());
			            paperService.updatePaperQuestionType(m);
					}
				}
			}
		}  
		
//		paperService.updatePaperQuestionOrder(ei_id);

		//调整题型显示，选择题（A1，A2,B1，X），填空，名解，简答，问答，案例
		List<Map<String, Object>> qt_sys = (List<Map<String, Object>>) getApplication().getAttribute("questionTypeList");
		List<Map<String, Object>> qt_xzt=new ArrayList<>();
		for(int i=0;i<qt_sys.size();i++){
			Map<String, Object> qts=qt_sys.get(i);
			int atid=Integer.parseInt(String.valueOf(qts.get("ANSWERTYPEID")));
			if(atid==0||atid==1||atid==2||atid==3||atid==8||atid==9){
				qt_xzt.add(qts);
				qt_sys.remove(qts);
				i--;
			}
		}
		List<Map<String, Object>> qtList=new ArrayList<>();
		for(Map<String, Object> qts:qt_xzt){
			//String qtstr=qts.get("ID")+"_"+qts.get("ANSWERTYPEID")+"_"+qts.get("ISCON");
			String qtname=((String)qts.get("NAME")).trim();
			for(int i=0;i<exampaperQuestionTypeList.size();i++){
				Map<String, Object> qt=exampaperQuestionTypeList.get(i);
				if(qtname.equals(((String)qt.get("QTNAME")).trim())){
					qtList.add(qt);
					exampaperQuestionTypeList.remove(qt);
					break;
				}
			}
		}
		for(int i=0;i<exampaperQuestionTypeList.size();i++){
			Map<String, Object> qt=exampaperQuestionTypeList.get(i);
			int atid=Integer.parseInt(String.valueOf(qt.get("ATID")));
			if(atid==0||atid==1||atid==2||atid==3||atid==8||atid==9){
				qtList.add(qt);
				exampaperQuestionTypeList.remove(qt);
				i--;
			}
		}
		for(Map<String, Object> qts:qt_sys){
			//String qtstr=qts.get("ID")+"_"+qts.get("ANSWERTYPEID")+"_"+qts.get("ISCON");
			String qtname=((String)qts.get("NAME")).trim();
			for(int i=0;i<exampaperQuestionTypeList.size();i++){
				Map<String, Object> qt=exampaperQuestionTypeList.get(i);
				if(qtname.equals(((String)qt.get("QTNAME")).trim())){
					qtList.add(qt);
					exampaperQuestionTypeList.remove(qt);
					break;
				}
			}
		}
		for(Map<String, Object> qt:exampaperQuestionTypeList){
			qtList.add(qt);
		}
		getRequest().setAttribute("exampaperQuestionTypeList", qtList);
		getRequest().setAttribute("ei_id", ei_id);
		getRequest().setAttribute("c_id", c_id);

        getRequest().setAttribute("mode", 0);
		return "jsp/paper/adjustPaper";
	}
	
	@RequestMapping("/setDiffQuestionType")
	public String setDiffQuestionType() {
		String ei_id = getPara("ei_id");
		String cid = getPara("c_id");
		String res = getPara("res").replaceAll("&quot;", "\"");
		if(Utils.NotEmpty(res)) {
			Map param = new HashMap();
			List<Map<String, Object>> par = new ArrayList<>();
			List<Map> resArray = JSONObject.parseObject(res,List.class);
			Iterator<Map> rit = resArray.iterator();
			while(rit.hasNext()) {
				JSONObject ob = (JSONObject) rit.next();
				Map m = new HashMap();
				m.put("qtid", ob.getString("qtid"));
				int xxdf=Utils.changeObjToInt(ob.getString("xxdf"));
				BigDecimal score=new BigDecimal(0);
				if(xxdf==0||xxdf==2) {
					score = new BigDecimal(ob.getString("qtscore"));
				}
				m.put("qtscore", score.setScale(4, 1));
				m.put("qtname", ob.getString("qtname"));
				m.put("e_qtname",ob.getString("e_qtname"));
				m.put("qttime", ob.getString("qttime"));
				m.put("qtindex", ob.getString("qtindex"));
				m.put("atid", ob.getString("atid"));
				m.put("qtdesc", ob.getString("qtdesc"));
				m.put("e_qtdesc", ob.getString("e_qtdesc"));
				m.put("mediaset", ob.getString("mediaset"));

				int iscon = ob.getIntValue("qtiscon");
				m.put("iscon", iscon);
				
				List<String> qids = new ArrayList<>();
				JSONArray q = ob.getJSONArray("qids");
				Iterator<Object> it = q.iterator();
				while(it.hasNext()) {
					String qid = it.next().toString().trim();
					qids.add(qid);
				}
				int qcount = qids.size();
				if(iscon == 1) {
					List<Map<String, Object>> ls = paperService.getMqids_Diff(qids);
					for(Map mq:ls) {
						qids.add(mq.get("ID").toString());
					}
				}
				m.put("qtcount", qcount);
				m.put("qids", qids);
				m.put("cid", cid);
				m.put("eid", ei_id);
				m.put("xxdf", xxdf);
				par.add(m);
			}
//			String mqids = getPara("mqids");
//			List<String> ls = new ArrayList<String>();
//			JSONArray mqs = JSONArray.fromObject(mqids);
//			if(mqs.size() > 0) {
//				Iterator<Object> it = mqs.iterator();
//				while(it.hasNext()) {
//					ls.add(it.next().toString().trim());
//				}
//			}
//			if(ls.size()>0) {
//				param.put("mqids", ls);
//			}
			param.put("qparams", par);
 			param.put("cid", cid);
			param.put("eid", ei_id);
			param.put("tid", getUserID());
			paperService.addQuestionIntoPaper4Diff(param);
//			paperService.addQuestionParam2Paper(ei_id);
		}
		paperService.updatePaperQuestionOrder(ei_id);
		getRequest().setAttribute("ei_id", ei_id);
		getRequest().setAttribute("c_id", getPara("c_id"));
		Map<String, Object> examInfo = paperService.getExamInfo(ei_id);
		getRequest().setAttribute("bid", examInfo.get("BID"));
		getRequest().setAttribute("aorb", examInfo.get("AORB"));
		getRequest().setAttribute("ename", examInfo.get("ENAME"));
		getRequest().setAttribute("state", examInfo.get("STATE"));
		getRequest().setAttribute("mobile", examInfo.get("MOBILE"));
		getRequest().setAttribute("themeList", paperService.selectThemeFromPaper(ei_id));
		getRequest().setAttribute("questionTypeList", paperService.selectQuestionTypeFromPaper(ei_id));
		getRequest().setAttribute("cognitionList", paperService.selectCognitionFromPaper(ei_id));
		getRequest().setAttribute("difficultyList", paperService.selectDifficultyFromPaper(ei_id));
		getRequest().setAttribute("knowledgeList", paperService.selectKnowledgeFromPaper(ei_id));	
		getRequest().setAttribute("isUnion", examInfo.get("ISUNION"));
		getRequest().setAttribute("assembly", "y"); //标识是新组的试卷
		getRequest().setAttribute("readonly","0");
		if(!getSubject().hasRole("administrator")){
			getRequest().setAttribute("isAdmin", "n");
		}else{
			getRequest().setAttribute("isAdmin", "y");
		}
		systemService.addOnlineSysLog("预览了"+ei_id+"的试卷");
		return "jsp/paper/previewPaper";
	}
	
	// 设置题型
	@RequestMapping("/setQuestionType")
	public String setQuestionType() {
		String ei_id = getPara("ei_id");
		String[] cids = getPara("c_id").split(",");
		if(cids.length>1){//说明是多课程组卷，如果是多课程组卷，列表会显示所属课程
			getRequest().setAttribute("multi", 1);
			List<Map<String,Object>> course=paperService.getPaper_CourseName(cids);
			getRequest().setAttribute("courseList", course);
		}else{
			getRequest().setAttribute("multi", 0);
		}
		String res = getPara("res").replaceAll("&quot;", "\"");
		if(Utils.NotEmpty(res)){
			List<Map> resArray = JSONObject.parseObject(res,List.class);
			Iterator<Map> rit = resArray.iterator();
	        while (rit.hasNext()) {
	            JSONObject ob = (JSONObject) rit.next();
				int xxdf=Utils.changeObjToInt(ob.getString("xxdf"));
	            if(xxdf==0 || xxdf==2){
	            	Map m = new HashMap();
		            m.put("qtid", ob.getString("qtid"));
		            BigDecimal score = new BigDecimal(ob.getString("qtscore"));
		            m.put("qtscore", score.setScale(4, 1));
		            m.put("qttime", ob.getString("qttime"));
		            m.put("qtindex", ob.getString("qtindex"));
		            m.put("ei_id", getPara("ei_id")); 
		            paperService.updatePaperQuestionType(m);
	            }
	        }
		}
		Map m = new HashMap();
		m.put("eid", ei_id);
		paperService.updatePaperScore(m);
        getRequest().setAttribute("ei_id", ei_id);
		getRequest().setAttribute("c_id", getPara("c_id"));
		Map<String, Object> examInfo = paperService.getExamInfo(ei_id);
		getRequest().setAttribute("bid", examInfo.get("BID"));
		getRequest().setAttribute("cpid", examInfo.get("CPID"));
		getRequest().setAttribute("aorb", examInfo.get("AORB"));
		getRequest().setAttribute("ename", examInfo.get("ENAME"));
		getRequest().setAttribute("state", examInfo.get("STATE"));
		getRequest().setAttribute("mobile", examInfo.get("MOBILE"));
		getRequest().setAttribute("questionTypeList", paperService.selectQuestionTypeFromPaper(ei_id));
		getRequest().setAttribute("cognitionList", paperService.selectCognitionFromPaper(ei_id));
		getRequest().setAttribute("difficultyList", paperService.selectDifficultyFromPaper(ei_id));
		getRequest().setAttribute("knowledgeList", paperService.selectKnowledgeFromPaper(ei_id));
		getRequest().setAttribute("themeList", paperService.selectThemeFromPaper(ei_id));
		getRequest().setAttribute("isC", getPara("isC"));
		getRequest().setAttribute("isUnion", getPara("isUnion"));
//		String isB = getPara("isB");		
		paperService.updatePaperQuestionOrder(ei_id);
		
		String assembly = getPara("assembly");
		if("y".equals(assembly)){
			getRequest().setAttribute("assembly", assembly);
		}else {
			getRequest().setAttribute("assembly", "n");
		}
		if(!getSubject().hasRole("administrator")){
			getRequest().setAttribute("isAdmin", "n");
		}else{
			getRequest().setAttribute("isAdmin", "y");
		}
		getRequest().setAttribute("readonly", "0");
		systemService.addOnlineSysLog("预览了"+ei_id+"的试卷");
		if("3".equals(examInfo.get("TESTTIMESET").toString())){
			getRequest().setAttribute("sign", 1);  //sign=1，组卷模式
			return "jsp/paper/score";
		}
		
		if ("0".equals(examInfo.get("AORB").toString())){//A卷
			return "jsp/paper/previewPaper";
		}else{
			getRequest().setAttribute("isB", "true");
			return "jsp/paper/previewPaper4addB";//B卷
		}
	}
	
	/**
	 * 非组卷模式 保存试卷的分值和时间
	 * @author yoyo
	 */
	@RequestMapping("/setQuestionType2")
	public @ResponseBody String setQuestionType2() {
		String ei_id = getPara("ei_id");
//		String[] cids = getPara("c_id").split(",");
		String res = getPara("res").replaceAll("&quot;", "\"");
		if(Utils.NotEmpty(res)){
			List<Map> resArray = JSONObject.parseObject(res,List.class);
			Iterator<Map> rit = resArray.iterator();
	        while (rit.hasNext()) {
	            JSONObject ob = (JSONObject) rit.next();
				int xxdf=Utils.changeObjToInt(ob.getString("xxdf"));
				if(xxdf==0 || xxdf==2){
					Map m = new HashMap();
					m.put("qtid", ob.getString("qtid"));
					BigDecimal score = new BigDecimal(ob.getString("qtscore"));
					m.put("qtscore", score.setScale(4, 1));
					m.put("qttime", ob.getString("qttime"));
					m.put("qtindex", ob.getString("qtindex"));
					m.put("ei_id", getPara("ei_id"));
					paperService.updatePaperQuestionType(m);
				}
	        }
		}
		Map m = new HashMap();
		m.put("eid", ei_id);
		paperService.updatePaperScore(m);
		paperService.updatePaperQuestionOrder(ei_id);
		return "success";
	}

    /**
     * 手工组卷=>调整分值
     * @return
     */
	@RequestMapping("/adjustPaper")
	public String adjustPaper() {
		String way = getPara("way");
		String[] c_ids = getPara("c_id").split(",");
		String ei_id = getPara("ei_id");

		List<Map<String,Object>> rtn = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> wj = new ArrayList<Map<String,Object>>();
		List<Map<String,Object>> list =  paperService.getExampaperQuestionTypeList(ei_id);
		for(int i=0;i<list.size();i++){
			Map<String,Object> eqt=list.get(i);
			int xxdf=Utils.changeObjToInt(eqt.get("XXDF"));
			if(xxdf==1){
				//获取题型的总得分
				Map eqtm=new HashMap();
				eqtm.put("qtid", eqt.get("QTID"));
				eqtm.put("eid", ei_id);
				Map<String,Object> eqt_score=paperService.getZF_qtid(eqtm);
				eqt.put("SCORE", eqt_score.get("SCORE"));
			}else{
				if(list.get(i).get("SCORE")!=null){
					String score = list.get(i).get("SCORE").toString();
					if(score.indexOf(".")!=-1){
						String[] splitScore = score.split("\\.");
						if(splitScore[1].length()>1){
							list.get(i).put("SCORE", splitScore[0]+"."+splitScore[1].substring(0,2)); //分数保留两位小数
						}
					}
				}
			}
			
			String qtid = String.valueOf(list.get(i).get("QTID"));
			if(qtid.equals("100")||qtid.equals("101")||qtid.equals("102")||qtid.equals("103")){
				wj.add(list.get(i));
			}else{
				rtn.add(list.get(i));
			}
		}
		if(wj.size()>0){
			for(Map<String,Object> mm:wj){
				rtn.add(mm);
			}
		}
		
		getRequest().setAttribute("exampaperQuestionTypeList",rtn);
		getRequest().setAttribute("ei_id", ei_id);
		getRequest().setAttribute("c_id", getPara("c_id"));
		if ("1".equals(way)) {//非组卷模式进入的调整分值
			return "jsp/paper/adjustPaper2";
		}
        getRequest().setAttribute("mode", 1);
        return "jsp/paper/adjustPaper";
	}
	
	@RequestMapping("/adjustPaper4combinePaper")
	public String adjustPaper4combinePaper() {
		String[] c_ids = getPara("c_id").split(",");
		String ei_id = getPara("ei_id");
		
		List<Map<String,Object>> exampaperQuestionTypeList=paperService.getExampaperQuestionTypeList(ei_id);	
		for(Map<String,Object> eqt:exampaperQuestionTypeList){
			int xxdf=Utils.changeObjToInt(eqt.get("XXDF"));
			if(xxdf==1){
				//获取题型的总得分
				Map eqtm=new HashMap();
				eqtm.put("qtid", eqt.get("QTID"));
				eqtm.put("eid", ei_id);
				Map<String,Object> eqt_score=paperService.getZF_qtid(eqtm);
				eqt.put("SCORE", eqt_score.get("SCORE"));
			}
		}
		getRequest().setAttribute("exampaperQuestionTypeList", exampaperQuestionTypeList);
		getRequest().setAttribute("ei_id", ei_id);
		getRequest().setAttribute("c_id", getPara("c_id"));

		return "jsp/paper/adjustPaper";
	}

	// 获取试题类型信息
	@RequestMapping("/getQuestionTypeInfo")
	public @ResponseBody Map getQuestionTypeInfo() {
		String t2t3=getPara("t2t3");
		Map param = new HashMap();
		param.put("id", getPara("c_id"));
		param.put("th_pid", getPara("th_id"));
		if(getPara("forbidDay")!=null) {
			param.put("forbidDay", getPara("forbidDay"));
		}
		if(getPara("forbidNum")!=null) {
			param.put("forbidNum", getPara("forbidNum"));
		}
		if(getPara("isVerified")!=null) {
			param.put("isVerified", getPara("isVerified"));
		}
		Map res = new HashMap();
		//res.put("themeList", questionService.getQuestionTypeTheme2List(param));//获取2级主题词
		List<Map<String,Object>> list=null;
		if("3".equals(t2t3)){
			list=questionService.getQuestionTypeInfo_t3(param);
		}else{
			list=questionService.getQuestionTypeInfo(param);
		}
		Set<String> set=new HashSet<String>();
		for(Map<String,Object> m:list){
			set.add((String)m.get("THID"));
		}
		List<Map<String,Object>> rtn=new ArrayList<Map<String,Object>>();
		for(String qhid:set){
			Map<String,Object> map=new HashMap<String,Object>();
			map.put("THID", qhid);			
			List<Map<String,Object>> l=new ArrayList<Map<String,Object>>();
			for(Map<String,Object> mm:list){
				if(qhid.equals(mm.get("THID"))){
					map.put("THNAME", mm.get("THNAME"));
					l.add(mm);
				}
			}
			map.put("qt", l);
			rtn.add(map);
		}
		res.put("qtInfo", rtn);//获取试题数目
		return res;
	}

	/**
	 * 从题库加题,添加试题
	 * @return
	 */
	@RequestMapping("/addQuestionIntoPaper")
	public @ResponseBody String addQuestionIntoPaper() {
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
		
		Map param = new HashMap();
		param.put("id", getPara("c_id"));
		param.put("ei_id", ei_id);
		
		String[] q = getParaValues("qids");
		param.put("qids", q);
		
		int rtn = paperService.addQuestionIntoPaper(param);
		
		Map<String, Object> map = paperService.getExamInfo(ei_id);
		if ("0".equals(map.get("STATE")+"") || "1".equals(map.get("STATE")+"") || "2".equals(map.get("STATE")+"")) {
			paperService.updateReloadPaper(ei_id);
		}
		paperService.updatePaperQuestionOrder(ei_id);

		String qids = "";
		for(int i=0;i<q.length;i++) {
			qids += q[i].split("_")[0] + ",";
		}
		qids = qids.substring(0,qids.length()-1);
		paperService.updateExampaperCourse(param);
		Map log = new HashMap();
		log.put("content", "为试卷"+ei_id+"从题库加题，试题ID为："+qids);
		log.put("cid", getPara("c_id"));
		systemService.addSysLog(log);
		
		return rtn+"";
	}

	@RequestMapping("/checkScore")
    public @ResponseBody String checkScore(){
	    String eid=getPara("eid");
        List<Map<String, Object>> rs = paperService.getPaperNoScore(eid);
        if (rs.size()!=0) {
            return "false";
        }
        return "true";
    }
	
	/**
	 * 从试卷里加题,添加试题
	 * @return
	 */
	@RequestMapping("/addQuestionIntoPaperFromPaper")
	public @ResponseBody String addQuestionIntoPaperFromPaper() {
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
		Map param = new HashMap();
		param.put("id", getPara("c_id"));
		param.put("ei_id", ei_id);
		String[] q = getParaValues("qids");
		param.put("qids", getParaValues("qids"));	
		
		int rtn = paperService.addQuestionIntoPaperFromPaper(param);
		paperService.updateExampaperCourse(param);
		
		String qids = "";
		for(int i=0; i<q.length;i++) {
			qids += q[i].split("_")[0] + ",";
		}
		qids = qids.substring(0,qids.length()-1);
		Map log = new HashMap();
		log.put("content", "为试卷"+ei_id+"从已有试卷加题，试题ID为："+qids);
		log.put("cid", getPara("c_id"));
		systemService.addSysLog(log);
		
		return rtn+"";
	}
	
	/**
	 * 从试卷里加题,添加试题
	 * @return
	 */
	@RequestMapping("/addQuestion4CombinePaper")
	public @ResponseBody String addQuestion4CombinePaper() {
		String cid=getPara("c_id");
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
		
		Map param = new HashMap();
		param.put("id", getPara("c_id"));
		param.put("ei_id", ei_id);
		String[] q = getParaValues("qids");
		param.put("qids", getParaValues("qids"));	
		
		int rtn = paperService.addQuestion4CombinePaper(param);
		
		int forbidDay = 0;
		int forbidNum = 0;
		if(getPara("forbidDay")!=""&&getPara("forbidDay")!=null){
			forbidDay = Integer.parseInt(getPara("forbidDay"));
		}
		if(getPara("forbidNum")!=""&&getPara("forbidNum")!=null){
			forbidNum = Integer.parseInt(getPara("forbidNum"));
		}
		int isVerified = Integer.parseInt(getPara("isVerified"));
		
		Map par = new HashMap();
		par.put("forbidDay", forbidDay);
		par.put("forbidNum", forbidNum);
		par.put("isVerified", isVerified);
		par.put("eid", ei_id);
		
		paperService.saveExaminfoQuestionFilterParam(par);
		
		String qids = "";
		for(int i=0; i<q.length;i++) {
			qids += q[i].split("#")[0] + ",";
		}
		qids = qids.substring(0,qids.length()-1);
		Map log = new HashMap();
		log.put("content", "为试卷"+ei_id+"从已有试卷加题，试题ID为："+qids);
		log.put("cid", cid);
		systemService.addSysLog(log);
		
		return rtn+"";
	}
	
	/**
	 * 已有试卷合并，添加所有试题
	 * @return
	 */
	@RequestMapping("/addAllQuestionIntoPaperFromPaper")
	public @ResponseBody String addAllQuestionIntoPaperFromPaper() {
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", getPara("eid"));
			map.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(map)==0){
				return "jsp/notTheRole";
			}
		}
		Map m = new HashMap();
		m.put("eid", getPara("eid"));
		m.put("eids", getPara("eids").split(","));
		int forbidDay = 0;
		int forbidNum = 0;
		int isVerified = 0;
		if(!StringUtils.isEmpty(getPara("forbidDay"))){
			forbidDay = Integer.parseInt(getPara("forbidDay"));
		}
		if(!StringUtils.isEmpty(getPara("forbidNum"))){
			forbidNum = Integer.parseInt(getPara("forbidNum"));
		}
		if(!StringUtils.isEmpty(getPara("isVerified"))) {
			isVerified = Integer.parseInt(getPara("isVerified"));
		}
    	m.put("isVerified", isVerified);
    	m.put("forbidDay", forbidDay);
    	m.put("forbidNum", forbidNum);

		List<Map<String,Object>> qidsList = paperService.getDistinctQID4combinePaperCount(m);

		m.put("qids", qidsList);
		int rtn = paperService.addAllQuestionIntoPaperFromPaper(m);
		
		paperService.saveExaminfoQuestionFilterParam(m);
		
		Map log = new HashMap();
		log.put("content", "合并试卷（"+getPara("eids")+"）所有试题");
		log.put("cid", "");
		systemService.addSysLog(log);
		return rtn+"";
	}
	
	// 手工组卷
	@RequestMapping("/manual")
	public String manual() {		
		String c_id = getPara("c_id");
		String ei_id = getPara("ei_id");
		
		int forbidDay = 0;
		int forbidNum = 0;
		if(getPara("forbidDay")!=""){
			forbidDay = Integer.parseInt(getPara("forbidDay"));
		}
		if(getPara("forbidNum")!=""){
			forbidNum = Integer.parseInt(getPara("forbidNum"));
		}
		int isVerified = Integer.parseInt(getPara("isVerified"));
		
		Map par = new HashMap();
		par.put("forbidDay", forbidDay);
		par.put("forbidNum", forbidNum);
		par.put("isVerified", isVerified);
		par.put("eid", ei_id);
		
		paperService.saveExaminfoQuestionFilterParam(par);
		
		getRequest().setAttribute("questionTypeList", courseService.getCourseAttr(c_id).get(0).get("questionTypeList"));
		getRequest().setAttribute("exampaperQuestionTypeList", paperService.getExampaperQuestionTypeList(ei_id));
		getRequest().setAttribute("c_id", c_id);
		getRequest().setAttribute("ei_id", ei_id);
		return "jsp/paper/adjustPaper";
	}
	
	@RequestMapping("/getExampaperQuestionList")
	public @ResponseBody Map<String, Object> getExampaperQuestionList() {
		String eid= getPara("ei_id");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:view");
			if(verifyService.checkPaperPermission(map)==0){
				return null;
			}
		}
		Map<String,Object> examinfo = paperService.getExamInfo(eid);
		PageUtils pu = getPageUtil();
		Map m = new HashMap();
		m.put("cid", getPara("cid"));
		m.put("ei_id", getPara("ei_id"));
		m.put("th1id", getPara("th1id"));
		m.put("th2id", getPara("th2id"));
		m.put("th3id", getPara("th3id"));
		m.put("qtid", getPara("qtid"));
		m.put("coid", getPara("coid"));
		m.put("did", getPara("did"));
		m.put("kid", getPara("kid"));
		m.put("question", getPara("question"));
		setMapParamSafe(m,"testNumMin");
		setMapParamSafe(m,"testNumMax");
		Map par = new HashMap();
		par.put("schoolyear",examinfo.get("SCHOOLYEAR"));
		par.put("term",examinfo.get("TERM"));

		if("illegalAnswer".equals(getPara("illegalAnswer"))){
			m.clear();
			m.put("ei_id", eid);
			m.put("illegalAnswerQids", paperService.findExampaperIllegalAnswerQids(eid));
		}
		m.put("excludeIsMain",1);
		List<Map<String, Object>> rtnList = paperService.getExampaperQuestionList(m, pu);
		Map<String,Object> rtn = getRes(rtnList, paperService.getExampaperQuestionCount(m));
		m.remove("excludeIsMain");
		rtn.put("excludeIsmainTotal", paperService.getExampaperQuestionCount(m));

		if(openFindRepeatSystem==1) {
			if(StringUtils.isNotBlank(eid) && rtnList!=null && !rtnList.isEmpty()){
				Map<String, QuestionStatDto> questionStatDtos = statsApiClient.queryDedupStatsMapByExam(eid);
				if(questionStatDtos!=null && !questionStatDtos.isEmpty()){
					for(Map<String,Object> rtnQuestion : rtnList){
						if(rtnQuestion.get("qid")==null) continue;
						QuestionStatDto statDto = questionStatDtos.get(String.valueOf(rtnQuestion.get("qid")));
						if(statDto==null) continue;
						rtnQuestion.put("use_time", statDto.getCount3Year());
					}
				}
			}
		}
		return rtn;
	}

	// 进入从题库加题
	@RequestMapping("/addQuestionFromBase")
	public String addQuestionFromBase() {
		String eid=getPara("ei_id");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(map)==0){
				return "jsp/notTheRole";
			}
		}

		Map<String, Object> examInfo = paperService.getExamInfo(eid);
		String examCid = (String) examInfo.get("CID");
		String[] cids = examCid.split(",");
		getRequest().setAttribute("aorb", examInfo.get("AORB"));
		getRequest().setAttribute("bid", examInfo.get("BID"));
		getRequest().setAttribute("cpid", examInfo.get("CPID"));
		getRequest().setAttribute("c_id", examCid);
		getRequest().setAttribute("ei_id", eid);
		if (cids.length==1) {
			if(!getSubject().hasRole("administrator")){
				Map map = new HashMap();
				map.put("uid",getUserID());
				map.put("cid", cids[0]);
				map.put("permission", "question:view");
				if(questionService.checkQuestionPermission(map,getUserID()+"_"+cids[0])==0){
					return "jsp/notTheRole";
				}
			}
			
			List<Map<String, Object>> rs = courseService.getCourseAttr(cids[0]);//获取课程相关参数
			getRequest().setAttribute("courseInfo", rs.get(0));
			getRequest().setAttribute("courseList", rs);
		}else{
			List<Map<String, Object>> courseList = new ArrayList<>();
			int rtn = 0;
			for(String cid:cids){
				if(!getSubject().hasRole("administrator")){
					Map map = new HashMap();
					map.put("uid",getUserID());
					map.put("cid", cid);
					map.put("permission", "question:view");
					rtn += questionService.checkQuestionPermission(map,getUserID()+"_"+cid);
				}
				Map<String, Object> rs = courseService.getCourseAttr(cid).get(0);
				courseList.add(rs);
			}
			if(!getSubject().hasRole("administrator") && rtn==0){
				return "jsp/notTheRole";
			}
			getRequest().setAttribute("courseInfo", paperService.getFilterByCourseAttrs(courseList));
			getRequest().setAttribute("courseList", courseList);
		}
		return "jsp/paper/addQuestionFromBase";
	}

	/**
	 * 从题库加题，获取未在试卷里的试题列表
	 * @return
	 */
	@RequestMapping("/getQuestionList")
	public @ResponseBody Map<String, Object> getQuestionList() {
		String eid=getPara("ei_id");
		Map<String,Object> examinfo = paperService.getExamInfo(eid);
		String[] cids = getPara("c_id").split(",");
		int rtn = 0;
		if(!"administrator".equals(getUserInfo().getRole())){
			for(String cid:cids) {
				Map map = new HashMap();
				map.put("uid",getUserID());
				map.put("cid", cid);
				map.put("permission", "question:view");
				rtn += questionService.checkQuestionPermission(map,getUserID()+"_"+cid);
			}
		}
		if(!"administrator".equals(getUserInfo().getRole()) && rtn==0){
			return null;
		}
		Map m = new HashMap();
		m.put("cid", cids);
		m.put("eid", getPara("ei_id"));
		m.put("bid", getPara("bid"));
		m.put("cpid", examinfo.get("CPID"));

		int Sys_forbidDay = Utils.changeObjToInt(getApplication().getAttribute("question_used_day"));//获取系统设置好的限制次数（parseint）
		int forbidDay = Math.min(Utils.changeObjToInt(getPara("forbidDay"), Sys_forbidDay),
				Sys_forbidDay == 0 ? Integer.MAX_VALUE : Sys_forbidDay);

		int Sys_forbidNum = Utils.changeObjToInt(getApplication().getAttribute("question_use_time"));//获取系统设置好的限制次数（parseint）
		int forbidNum = Math.min(Utils.changeObjToInt(getPara("forbidNum"), Sys_forbidNum),
				Sys_forbidNum == 0 ? Integer.MAX_VALUE : Sys_forbidNum);

		int limit4Isreview = Utils.changeObjToInt(getApplication().getAttribute("limit4Isreview"));
		int isVerified = (limit4Isreview == 1)
				? 1 : Utils.changeObjToInt(getPara("isVerified"), limit4Isreview);
		
        if(forbidDay>0){
        	m.put("forbidDay", forbidDay);
        }
        if(forbidNum>=1){
        	m.put("forbidNum", forbidNum);
        }
        if(isVerified==1){
        	m.put("isVerified", isVerified);
        }
        if(isVerified==3){
        	m.put("isVerified", isVerified);
        }
		m.put("type",  getPara("type"));
		m.put("th1id", getPara("th1id"));
		m.put("th2id", getPara("th2id"));
		m.put("th3id", getPara("th3id"));
		m.put("qtid", getPara("qtid"));
		m.put("coid", getPara("coid"));
		m.put("did", getPara("did"));
		m.put("kid", getPara("kid"));
		m.put("beginDate", getPara("beginDate"));
		m.put("endDate", getPara("endDate"));		
		m.put("question", getPara("question"));
		m.put("real_name", getPara("real_name"));
		PageUtils pu = getPageUtil();
		m.put("order", pu.getOrder());
		m.put("sort", pu.getSort());
		List<Map<String, Object>> rtnList = paperService.getPaperQuestion(m, pu);
		if(openFindRepeatSystem==1) {
			if(rtnList!=null && !rtnList.isEmpty()){
				List<String> qids = new ArrayList<>();
				for(Map<String, Object> question : rtnList){
					qids.add(String.valueOf(question.get("qid")));
					if(question.get("branch")!=null && question.get("branch") instanceof List){
						List<Map<String,Object>> branches = (List<Map<String,Object>>)question.get("branch");
						for(Map<String,Object> branch : branches){
							qids.add(String.valueOf(branch.get("qid")));
						}
					}
				}
				Map<String, QuestionStatDto> questionStatDtos = statsApiClient.queryDedupStatsMapByQids(eid, qids);
				if(questionStatDtos!=null && !questionStatDtos.isEmpty()){
					for(Map<String,Object> rtnQuestion : rtnList){
						if(rtnQuestion.get("qid")==null) continue;
						QuestionStatDto statDto = questionStatDtos.get(String.valueOf(rtnQuestion.get("qid")));
						if(rtnQuestion.get("branch")!=null && rtnQuestion.get("branch") instanceof List){
							List<Map<String,Object>> branches = (List<Map<String,Object>>)rtnQuestion.get("branch");
							for(Map<String,Object> branch : branches){
								if(branch.get("qid")==null) continue;
								QuestionStatDto statDto4branch = questionStatDtos.get(String.valueOf(branch.get("qid")));
								if(statDto4branch==null) continue;
								branch.put("use_time", statDto4branch.getCount3Year());
							}
						}
						if(statDto==null) continue;
						rtnQuestion.put("use_time", statDto.getCount3Year());
					}
				}
			}
		}
		getRequest().setAttribute("aorb", examinfo.get("AORB"));
		return getRes(rtnList, paperService.getQuestionCount(m));
	}
	
	// 编辑考务信息
	@RequestMapping("/inEditExamInfo")
	public String inEditExamInfo() {
		String[] cids = getPara("cid").split(",");
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			if(getSubject().hasRole("teachingoffice")){
				Map map = new HashMap();
				map.put("unitid", getUserInfo().getUnitID());
				map.put("cids",cids);
				if(paperService.checkUnit(map)==0){
					return "jsp/notTheRole";
				}
			}else{
				Map map = new HashMap();
				map.put("uid", getUserID());
				map.put("eid", eid);
				map.put("permission", "paper:view");
				if(verifyService.checkPaperPermission(map)==0){
					return "jsp/notTheRole";
				}
			}

		}
		getRequest().setAttribute("ei_id", eid);
		getRequest().setAttribute("c_id", getPara("cid"));
		getRequest().setAttribute("action", getPara("action"));
		
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
						if(((String)mm.get("SPID")).equals(m.get("SPID"))){
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
						if(mm.get("ETID").equals(m.get("ETID"))){
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
		}
		
		String organizationinfo_en="";
		try {
			organizationinfo_en=(String)((Map<String, Object>)getApplication().getAttribute("organizationinfo_en")).get("PARAM");
		}catch(Exception e) {}
		
		if("gmu".equals(organizationinfo_en)) {
			getRequest().setAttribute("jwc_kcdm", paperService.getJWC_KCDM());
			return "jsp/paper/editExamInfo-gmu";
		}else {
			return "jsp/paper/editExamInfo";
		}
	}
	
	@RequestMapping("/viewExamInfo")
	public String viewExamInfo() {
		String[] cids = getPara("cid").split(",");
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator") && !getSubject().hasRole("expert")){
			if(getSubject().hasRole("teachingoffice")){
				Map map = new HashMap();
				map.put("unitid", getUserInfo().getUnitID());
				map.put("cids",cids);
				if(paperService.checkUnit(map)==0){
					return "jsp/notTheRole";
				}
			}else{
				Map map = new HashMap();
				map.put("uid", getUserID());
				map.put("eid", eid);
				map.put("permission", "paper:view");
				if(verifyService.checkPaperPermission(map)==0){
					return "jsp/notTheRole";
				}
			}

		}

		getRequest().setAttribute("ei_id", eid);
		getRequest().setAttribute("c_id", getPara("cid"));
		getRequest().setAttribute("action", getPara("action"));
		if (cids.length==1) {
			List<Map<String,Object>> clist=courseService.getCourseAttr(cids[0]);
			if(clist!=null&&clist.size()>0){
				Map<String, Object> map = clist.get(0);
				getRequest().setAttribute("specialtyList", map.get("specialtyList"));
				getRequest().setAttribute("examTypeList", map.get("examTypeList"));
				getRequest().setAttribute("name_c", map.get("name_c"));
			}			
			getRequest().setAttribute("examInfo",paperService.getExamInfo(eid));
			getRequest().setAttribute("examObject",paperService.getExamObject(eid));			
		}else{
			List<Map<String, Object>> specialtyList = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> examTypeList = new ArrayList<Map<String, Object>>();
			StringBuffer cname=new StringBuffer();
			for(String cid:cids){				
				Map<String, Object> map=null;
				List<Map<String,Object>> cList=courseService.getCourseAttr(cid);
				if(cList!=null&&cList.size()>0){
					map=cList.get(0);
				}else{
					continue;
				}
				cname.append(map.get("name_c")+",");
				List<Map<String, Object>> specialtyls = (List<Map<String, Object>>) map.get("specialtyList");
				for(Map<String, Object> m:specialtyls){
					boolean b = true;
					for(Map<String, Object> mm:specialtyList){
						if(mm.get("SPID").equals(m.get("SPID"))){
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
						if(mm.get("ETID").equals(m.get("ETID"))){
							b = false;
							break;
						}
					}
					if(b){
						examTypeList.add(m);
					}
				}
			}
			getRequest().setAttribute("name_c", cname.substring(0, cname.length()-1));
			getRequest().setAttribute("specialtyList", specialtyList);
			getRequest().setAttribute("examTypeList", examTypeList);
			getRequest().setAttribute("examInfo",paperService.getExamInfo(eid));
			getRequest().setAttribute("examObject",paperService.getExamObject(eid));
		}		
		return "jsp/paper/viewExamInfo";
	}
	
	@RequestMapping("/getExamModAndTime")
	public @ResponseBody Map<String,Object> getExamModAndTime(){
		String eid = getPara("eid");
		Map<String,Object> examinfo = paperService.getExamInfo(eid);
		Map<String,Object> examModAndTime = new HashMap<>();
		examModAndTime.put("testtimeset",examinfo.get("TESTTIMESET"));
		Map<String, Object> systemTimeMap = (Map<String, Object>) getApplication().getAttribute("systemTimeMap");
		String timesec = String.valueOf(systemTimeMap.get(examinfo.get("TIME")+"_val"));
		examModAndTime.put("timesec", timesec);
		return examModAndTime;
	}

	@RequestMapping("/score")
	public String score() {
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
		getRequest().setAttribute("ei_id", ei_id);
		Map<String, Object> examInfo = paperService.getExamInfo(ei_id);
		getRequest().setAttribute("c_id", examInfo.get("CID"));
		getRequest().setAttribute("bid", examInfo.get("BID"));
		getRequest().setAttribute("ename", examInfo.get("ENAME"));
		getRequest().setAttribute("themeList", paperService.selectThemeFromPaper(ei_id));
		getRequest().setAttribute("questionTypeList", paperService.selectQuestionTypeFromPaper(ei_id));
		getRequest().setAttribute("cognitionList", paperService.selectCognitionFromPaper(ei_id));
		getRequest().setAttribute("difficultyList", paperService.selectDifficultyFromPaper(ei_id));
		getRequest().setAttribute("knowledgeList", paperService.selectKnowledgeFromPaper(ei_id));
		return "jsp/paper/score";
	}

	// 题型说明
	@RequestMapping("/questionTypeExplain")
	public String questionTypeExplain() {
		getRequest().setAttribute("ei_id", getPara("eid"));
		return "jsp/paper/questionTypeExplain";
	}
	
	@RequestMapping("/checkList")
	public String checkList() {
		String[] cids = getPara("c_id").split(",");
		String ei_id = getPara("ei_id");
		if(!getSubject().hasRole("administrator") && !getSubject().hasRole("expert")){
			if(getSubject().hasRole("teachingoffice")){
				Map map = new HashMap();
				map.put("unitid", getUserInfo().getUnitID());
				map.put("cids",cids);
				if(paperService.checkUnit(map)==0){
					return "jsp/notTheRole";
				}
			}else{
				Map map = new HashMap();
				map.put("uid", getUserID());
				map.put("eid", ei_id);
				map.put("permission", "paper:view");
				if(verifyService.checkPaperPermission(map)==0){
					return "jsp/notTheRole";
				}
			}

		}

		//试卷名称
		Map<String,Object> examinfo = paperService.getExamInfo(ei_id);
		getRequest().setAttribute("ename", examinfo.get("ENAME"));
		//试卷总难度与分值分布
		Map m = new HashMap();
		m.put("ei_id", ei_id);
		List<Map<String, Object>> das = paperService.getPaperCheckScoreDiffAndScore(m);
		//获得总题数
		BigDecimal c = (BigDecimal) examinfo.get("SUBJECTSUM");
		BigDecimal stotal = (BigDecimal) examinfo.get("SCORE");

		for(int j=0;j<das.size();j++) {
			Map mm = new HashMap();
			mm.put("dname", das.get(j).get("DNAME"));
			mm.put("count", das.get(j).get("COUNT"));
			mm.put("score", das.get(j).get("SCORE"));
			mm.put("percent", Utils.percentOf((BigDecimal) das.get(j).get("COUNT"), c));
			mm.put("spercent", Utils.percentOf((BigDecimal) das.get(j).get("SCORE"), stotal));
			das.set(j,mm);
		}
		getRequest().setAttribute("examDiffAndScore", das);
		//题型数量分值表
		getRequest().setAttribute("paperQtCountAndSum", paperService.getPaperQtCountAndSum(ei_id));
		
		ArrayList<Map<String, Object>> res = new ArrayList<>();
		//试卷内每个课程的双向细目表
		for(int i=0;i<cids.length;i++) {
			Map param = new HashMap();
			param.put("ei_id", ei_id);
			param.put("cid", cids[i]);
			//每个课程难度与分值分布
			List<Map<String, Object>> diffAndScore = paperService.getPaperCheckScoreDiffAndScore(param);
			//int count = Integer.parseInt(String.valueOf(paperService.getPaperQuestionCountForCheckList(param)));
			for(int k=0;k<diffAndScore.size();k++) {
				Map ms = new HashMap();
				ms.put("dname", diffAndScore.get(k).get("DNAME"));
				ms.put("count", diffAndScore.get(k).get("COUNT"));
				ms.put("score", diffAndScore.get(k).get("SCORE"));
				ms.put("percent", Utils.percentOf((BigDecimal) diffAndScore.get(k).get("COUNT"), c));
				ms.put("spercent", Utils.percentOf((BigDecimal) diffAndScore.get(k).get("SCORE"), stotal));
				diffAndScore.set(k, ms);
			}
			
			Map rs = new HashMap();
			rs.put("cname", courseService.getCourseCNameByCid(cids[i]));
			rs.put("diffAndScore", diffAndScore);
			rs.put("checkList", paperService.getPaperCheckList(param));
			rs.put("getExamPaperQuestionType", paperService.getExamPaperQuestionType(param));
			rs.put("themeList", paperService.getThemeFromPaperCid(param));
			res.add(rs);
		}
		getRequest().setAttribute("eInfo", examinfo);
		getRequest().setAttribute("eid", ei_id);
		getRequest().setAttribute("res", res);
		getRequest().setAttribute("cids", getPara("c_id"));
		getRequest().setAttribute("sign",getPara("sign"));
		return "jsp/paper/checkList";
	}
	
	@RequestMapping("/getThQSumAndQCount")
	public @ResponseBody List<Map<String, Object>> getThQSumAndQCount(){
		Map param = new HashMap();
		param.put("thlevel", getPara("thlevel"));
		param.put("eid", getPara("eid"));
		param.put("cid", getPara("cid"));
		param.put("thid", getPara("thid"));
		return paperService.getThemeQSumAndQCount(param);
	}

	@RequestMapping("/rebuild")
	public String rebuild() {
		String[] c_ids = getPara("c_id").split(",");
		if(!getSubject().hasRole("administrator")){
			for(String cid:c_ids) {
				Map map = new HashMap();
				map.put("uid", getUserID());
				map.put("cid", cid);
				map.put("permission", "paper:add");
				if(courseService.checkCoursePermission(map,getUserID()+"_"+cid)==0){
					return "jsp/notTheRole";
				}
			}
		}
		if(c_ids.length>1){
			getRequest().setAttribute("multi", 1);
		}else{
			getRequest().setAttribute("multi", 0);
		}
		String ei_id = getPara("ei_id");
		
		Map<String,Object> examinfo = paperService.getExamInfo(ei_id);
		int state = Integer.parseInt(String.valueOf(examinfo.get("STATE")));
		if(state==0 || state==1 || state==2){
			int aorb = Integer.parseInt(String.valueOf(examinfo.get("AORB")));
			if(aorb==1){//B卷，重新生成B卷
				paperService.rebuildB(ei_id);

		        getRequest().setAttribute("ei_id", ei_id);
				getRequest().setAttribute("c_id", getPara("c_id"));
				getRequest().setAttribute("bid", examinfo.get("BID"));
				getRequest().setAttribute("aorb", 1);
				getRequest().setAttribute("ename", examinfo.get("ENAME"));
				if(c_ids.length==1){
					getRequest().setAttribute("themeList", paperService.selectThemeFromPaper(ei_id));
				}				
				getRequest().setAttribute("questionTypeList", paperService.selectQuestionTypeFromPaper(ei_id));
				getRequest().setAttribute("cognitionList", paperService.selectCognitionFromPaper(ei_id));
				getRequest().setAttribute("difficultyList", paperService.selectDifficultyFromPaper(ei_id));
				getRequest().setAttribute("knowledgeList", paperService.selectKnowledgeFromPaper(ei_id));
				getRequest().setAttribute("isB", "true");
				getRequest().setAttribute("sum", paperService.getTotalPoints(ei_id));
				Map m = new HashMap();
				m.put("ei_id", ei_id);
				getRequest().setAttribute("total", paperService.getExampaperQuestionCount(m));
				getRequest().setAttribute("readonly", "0");
				getRequest().setAttribute("rebuild", "1"); //1标识已经重新组卷，用作提示
				if(!getSubject().hasRole("administrator")){
					getRequest().setAttribute("isAdmin", "n");
				}else{
					getRequest().setAttribute("isAdmin", "y");
				}
				return "jsp/paper/previewPaper4addB";
			}else{//A卷
				//paperService.getPaperCheckList(param);//每个课程的双向细目表
				//根据试卷id查看组卷双向细目表题目数量
				getRequest().setAttribute("getMultiCourseStructureQSum", paperService.getMultiCourseStructureQSum(ei_id));
				//paperService.rebuildA(ei_id);//这里先不删除这些信息，在重新组卷的双向细目表那个页面删除
				getRequest().setAttribute("buildWay",getPara("buildWay"));
				if (c_ids.length==1) {//结构化组卷
					Map m = new HashMap();
					m.put("forbidDay", examinfo.get("FORBIDBEFORE"));
					m.put("forbidNum", examinfo.get("FORBIDNUM"));
					m.put("isVerified", examinfo.get("ISVERIFIED"));
					m.put("id", c_ids[0]);
					m.put("cid", c_ids[0]);
					m.put("ei_id", ei_id);

					Map<String,Object> courseAttr = courseService.getCourseAttr(c_ids[0]).get(0);//获取课程相关参数
					getRequest().setAttribute("themeList", courseAttr.get("themeList"));
					getRequest().setAttribute("questionTypeList", questionService.getAllQT4CourseQuestion(m));
					getRequest().setAttribute("difficultyDistribution", questionService.getDifficultyDistribution(c_ids[0]));
					getRequest().setAttribute("distributionStatistics", questionService.getDistributionStatistics(m));


					getRequest().setAttribute("c_id", getPara("c_id"));
					getRequest().setAttribute("ei_id", ei_id);
					getRequest().setAttribute("forbidDay", examinfo.get("FORBIDBEFORE"));
					getRequest().setAttribute("forbidNum", examinfo.get("FORBIDNUM"));
					getRequest().setAttribute("isVerified", examinfo.get("ISVERIFIED"));
					return "jsp/paper/structure";
				}else{
					getRequest().setAttribute("c_id", getPara("c_id"));
					getRequest().setAttribute("c_ids", c_ids);
					getRequest().setAttribute("ei_id", ei_id);
					Map m = new HashMap();
					m.put("forbidDay", examinfo.get("FORBIDBEFORE"));
					m.put("forbidNum", examinfo.get("FORBIDNUM"));
					m.put("isVerified", examinfo.get("ISVERIFIED"));

					String[] cnames = new String[c_ids.length];
					List[] distributionStatistics_array = new ArrayList[c_ids.length];
					List[] themeList_array = new ArrayList[c_ids.length];
					List[] questionTypeList_array = new ArrayList[c_ids.length];
					List[] difficultyDistributions = new ArrayList[c_ids.length];
					for(int i=0;i<c_ids.length;i++){
						m.put("id", c_ids[i]);
						m.put("cid", c_ids[i]);
						distributionStatistics_array[i] = questionService.getDistributionStatistics(m);
						Map<String, Object> cmap = courseService.getCourseAttr(c_ids[i]).get(0);
						themeList_array[i] =  (List) cmap.get("themeList");
						questionTypeList_array[i] = questionService.getAllQT4CourseQuestion(m);
						cnames[i] = (String) cmap.get("name_c");
						difficultyDistributions[i] = questionService.getDifficultyDistribution(c_ids[i]);
					}

					getRequest().setAttribute("themeList", themeList_array);
					getRequest().setAttribute("questionTypeList", questionTypeList_array);
					getRequest().setAttribute("difficultyDistributions", difficultyDistributions);
					getRequest().setAttribute("distributionStatistics", distributionStatistics_array);

					getRequest().setAttribute("cname", cnames);
					getRequest().setAttribute("forbidDay", examinfo.get("FORBIDBEFORE"));
					getRequest().setAttribute("forbidNum", examinfo.get("FORBIDNUM"));
					getRequest().setAttribute("isVerified", examinfo.get("ISVERIFIED"));
					return "jsp/paper/multiCourseStructure";
				}
			}
		}else{
			return "";
		}
		
	}
	
	// 预测分析
	// 黎青华改动，判断课程是否有多个，如果有多个课程，则拼装多个课程的信息
	@RequestMapping("/forecastPaper")
	public String forecastPaper() {
		String ei_id = getPara("ei_id");
		Map<String,Object> examinfo=paperService.getExamInfo(ei_id);
		
		String[] c_ids = getPara("c_id").split(",");

		getRequest().setAttribute("ei_id", ei_id);
		getRequest().setAttribute("c_id", getPara("c_id"));
		
		BigDecimal questionCount = (BigDecimal) examinfo.get("SUBJECTSUM");
		getRequest().setAttribute("count", questionCount.intValue());

		BigDecimal total = (BigDecimal) examinfo.get("SCORE");//试卷试题总分
		getRequest().setAttribute("total", total.setScale(2, BigDecimal.ROUND_HALF_UP));
		
		Map m1 = new HashMap();
		m1.put("eid", ei_id);
		m1.put("cid", c_ids);
		
//		List<Map<String, Object>> qc = paperService.getPaperQuestionCount(m1);
		Map<String, BigDecimal> themeCountMap = paperService.getThemeLevelStatsForPaper(ei_id);
		List<Map<String,Object>> tCount=paperService.getThemeCount4ForseePaper(m1);
		for(Map<String,Object> tm:tCount){
			int tlevel = Utils.changeObjToInt(tm.get("TLEVEL"));
			BigDecimal tTotal = (BigDecimal) tm.get("TAR");
			if(tlevel==1){
				getRequest().setAttribute("t1percent", Utils.percentOf(themeCountMap.get("T1COUNT"), tTotal));
			}else if(tlevel==2){
				getRequest().setAttribute("t2percent", Utils.percentOf(themeCountMap.get("T2COUNT"), tTotal));
			}else if(tlevel==3){
				getRequest().setAttribute("t3percent", Utils.percentOf(themeCountMap.get("T3COUNT"), tTotal));
			}
		}
		
		List<Map<String, Object>> difficultyDistribution = paperService.getPaperDifficultyDistribution(m1);	//试卷难度分布 
		List<Map<String, Object>> difficultyRes = new ArrayList<>();
		for(Map<String,Object> dm:difficultyDistribution){
			Map m = new HashMap();
			m.put("name", dm.get("DNAME"));
			BigDecimal num = (BigDecimal) dm.get("NUM");
			m.put("num", num.intValue());
			m.put("score", dm.get("SCORE"));
			m.put("percent", Utils.percentOf(num, questionCount));
			m.put("fspercent", Utils.percentOf((BigDecimal) dm.get("SCORE"), total));
			difficultyRes.add(m);
		}
		getRequest().setAttribute("difficultyRes", difficultyRes);	
		
		List<Map<String, Object>> knowledgeDistribution = paperService.getPaperKnowledgeDistribution(m1);	//试卷知识点分布 
		List<Map<String, Object>> knowledgeRes = new ArrayList<>();
		for(Map<String,Object> km:knowledgeDistribution){
			Map m = new HashMap();
			m.put("name", km.get("KNAME"));
			BigDecimal num = (BigDecimal) km.get("NUM");
			m.put("num", num.intValue());
			m.put("score", km.get("SCORE"));
			m.put("percent", Utils.percentOf(num, questionCount));
			m.put("fspercent", Utils.percentOf((BigDecimal) km.get("SCORE"), total));
			knowledgeRes.add(m);
		}
		getRequest().setAttribute("knowledgeRes", knowledgeRes);
		
		List<Map<String, Object>> cognitionDistribution = paperService.getPaperCognitionDistribution(m1);	//试卷认知分布 
		List<Map<String, Object>> cognitionRes = new ArrayList<>();
		for(Map<String,Object> cm:cognitionDistribution){
			Map m = new HashMap();
			m.put("name", cm.get("CONAME"));
			BigDecimal num = (BigDecimal) cm.get("NUM");
			m.put("num", num.intValue());
			m.put("score", cm.get("SCORE"));
			m.put("percent", Utils.percentOf(num, questionCount));
			m.put("fspercent", Utils.percentOf((BigDecimal) cm.get("SCORE"), total));
			cognitionRes.add(m);
		}
		getRequest().setAttribute("cognitionRes", cognitionRes);
		
		List<Map<String, Object>> questionTypeDistribution = paperService.getPaperQuestionTypeDistribution(m1);	//试卷题型分布 
		List<Map<String, Object>> questionTypeRes = new ArrayList<>();
		for(Map<String,Object> qtm:questionTypeDistribution){
			Map m = new HashMap();
			m.put("name", qtm.get("QTNAME"));
			m.put("qtid", qtm.get("QTID"));
			m.put("atid", qtm.get("ATID"));
			BigDecimal num = (BigDecimal) qtm.get("NUM");
			m.put("num", num.intValue());
			m.put("score", qtm.get("SCORE"));
			//m.put("percent", Utils.getPercent(num/questionCount));
			questionTypeRes.add(m);
		}
		//获取问卷调查试题的题型分布
		List<Map<String,Object>> wjQTDistribution=paperService.getPaperWjDistribution(m1);
		for(Map<String,Object> ww:wjQTDistribution){
			Map m = new HashMap();
			m.put("name", ww.get("QTNAME"));
			m.put("qtid", ww.get("QTID"));
			m.put("atid", ww.get("ATID"));
			BigDecimal num = (BigDecimal) ww.get("NUM");
			m.put("num", num.intValue());
			m.put("score", ww.get("SCORE"));
			//m.put("percent", Utils.getPercent(num/questionCount));
			questionTypeRes.add(m);
		}
		
		List<Map<String, Object>> questionTypeRes2 = new ArrayList<>();
		//整理成主观题，客观题
		int zg_num=0;
		double zg_score=0;
		int kg_num=0;
		double kg_score=0;
		int wj_num=0;
		double wj_score=0;
		for(Map<String,Object> qt:questionTypeRes){			
			int atid=Integer.parseInt(String.valueOf(qt.get("atid")));
			if(atid<=4){//客观题
				kg_num+=Integer.parseInt(String.valueOf(qt.get("num")));
				kg_score+=Double.parseDouble(String.valueOf(qt.get("score")));
			}else if(atid>4&&atid<8){//主观题
				zg_num+=Integer.parseInt(String.valueOf(qt.get("num")));
				zg_score+=Double.parseDouble(String.valueOf(qt.get("score")));
			}else if(atid>=8){//问卷调查
				wj_num+=Integer.parseInt(String.valueOf(qt.get("num")));
				wj_score+=Double.parseDouble(String.valueOf(qt.get("score")));
			}
		}
		Map<String,Object> zgM= new HashMap<>();
		zgM.put("name", "主观");
		zgM.put("num", zg_num);
		zgM.put("score", zg_score);
		zgM.put("percent", Utils.percentOf(new BigDecimal(zg_num), questionCount));
		zgM.put("fspercent", Utils.percentOf(new BigDecimal(zg_score), total));
		questionTypeRes2.add(zgM);
		
		Map<String,Object> kgM= new HashMap<>();
		kgM.put("name", "客观");
		kgM.put("num", kg_num);
		kgM.put("score", kg_score);
		kgM.put("percent", Utils.percentOf(new BigDecimal(kg_num), questionCount));
		kgM.put("fspercent", Utils.percentOf(new BigDecimal(kg_score), total));
		questionTypeRes2.add(kgM);
		
		if(wj_num>0){
			Map<String,Object> wjM= new HashMap<>();
			wjM.put("name", "问卷");
			wjM.put("num", wj_num);
			wjM.put("score", wj_score);
			kgM.put("percent", Utils.percentOf(new BigDecimal(wj_num), questionCount));
			kgM.put("fspercent", Utils.percentOf(new BigDecimal(wj_score), total));
			questionTypeRes2.add(wjM);
		}
		
		getRequest().setAttribute("questionTypeRes", questionTypeRes2);
		
		int resultAtime = paperService.getQTAnswertime(ei_id);//试卷试题的总用时
		int examTotalTime = commonService.getSystemTimeByID(String.valueOf(examinfo.get("TIME")));//试卷总用时
		getRequest().setAttribute("answerTime", DateFormatUtils.formatDuration(resultAtime));
		getRequest().setAttribute("totalTime", DateFormatUtils.formatDuration(examTotalTime));
		getRequest().setAttribute("occupiedTime", Utils.percentOf(new BigDecimal(resultAtime), new BigDecimal(examTotalTime)));
//		
//		
//		double total = paperService.getTotalPoints(ei_id);//试卷试题总分
//		getRequest().setAttribute("total", (int)total);
		
		int state=Integer.parseInt(String.valueOf(examinfo.get("STATE")));
		getRequest().setAttribute("state", state);
		double average=0;
		if(state==6){
			average=Double.parseDouble(String.valueOf(examinfo.get("FORECAST_AVERAGESCORE")));
		}
		if(average<=0){
			//计算预计平均分
			List<Map<String,Object>> realDiffList=paperService.getRealDiff4ForseePaper(ei_id);		
			for(Map<String,Object> diff:realDiffList){
				double score=Double.parseDouble(String.valueOf(diff.get("SCORE")));				
				BigDecimal b=new BigDecimal(String.valueOf(diff.get("REALDIFFICULTY")));
				double realdifficulty=b.setScale(3, BigDecimal.ROUND_HALF_UP).doubleValue();
				if(realdifficulty>0){
					average+=realdifficulty*score;
				}else{
					int ygdiff=Integer.parseInt(String.valueOf(diff.get("YGDIFF")));
					if(ygdiff==1){//简单
						average+=score*0.9;
					}else if(ygdiff==2){//中等
						average+=score*0.7;
					}else if(ygdiff==3){//较难
						average+=score*0.5;
					}
				}
				
			}
			BigDecimal ab=new BigDecimal(average);
			average=ab.setScale(2, BigDecimal.ROUND_HALF_UP).doubleValue();
		}
		getRequest().setAttribute("average", average);
		
		List<Map<String, Object>> usetimeTotal = paperService.getUseTimeAndScore(ei_id);
		for(int i=0;i<usetimeTotal.size();i++) {
			String questionPer = Utils.percentOf((BigDecimal) usetimeTotal.get(i).get("NUM"), questionCount);
			String scorePer = Utils.percentOf((BigDecimal) usetimeTotal.get(i).get("SCORE"), total);
			Map map = new HashMap();
			map.put("usetime", usetimeTotal.get(i).get("USETIME"));
			map.put("num", usetimeTotal.get(i).get("NUM"));
			map.put("score", usetimeTotal.get(i).get("SCORE"));
			map.put("questionPer", questionPer);
			map.put("scorePer", scorePer);
			usetimeTotal.set(i, map);
		}
		getRequest().setAttribute("usetimeTotal", usetimeTotal);
		
		if(getPara("verify") != null){
			getRequest().setAttribute("verify", 1);
		}
		
		int aorb=Integer.parseInt(String.valueOf(examinfo.get("AORB")));
		if(aorb==0){
			getRequest().setAttribute("paperName", "《"+examinfo.get("CNAME")+"(A卷)》");
		}else{
			getRequest().setAttribute("paperName", "《"+examinfo.get("CNAME")+"(B卷)》");
		}
		
		getRequest().setAttribute("ename", examinfo.get("ENAME"));
		
		return "jsp/paper/forecastPaper";
	}
	
	// 获取题型说明
	@RequestMapping("/getQuestionTypeExplain")
	public @ResponseBody List<Map<String, Object>> getQuestionTypeExplain() {
		String ei_id = getPara("ei_id");
		return paperService.getQuestionTypeExplain(ei_id);
	}

	/**
	 * 生成B卷
	 * @author yoyo
	 * @return
	 */
	@RequestMapping("/generateBpaper")
	public String generateBpaper() {
		try {
			String aid = getPara("aid");
			
			if(!getSubject().hasRole("administrator")){
				String allowGenerateB=(String)getSession().getAttribute("allowGenerateB_"+aid);
				if(allowGenerateB==null||"null".equals(allowGenerateB)||"".equals(allowGenerateB)||"N".equals(allowGenerateB)) {
					return "jsp/notTheRole";
				}
			}

			Map m = new HashMap();
			
			m.put("aid", aid);
			m.put("createTime", new Date());
			m.put("isUnion",0);
			paperService.addBExamInfo(m);
			String bid = m.get("id") + "";
			Map<String,Object> bexaminfo = paperService.getExamInfo(bid);
			List<Map<String, Object>> res = paperService.getExampaperQuestionParam(aid);
			Map paramSpec = new HashMap();
			paramSpec.put("eid", aid);
			List<Map<String,Object>> resSpec = paperService.getExampaperQuestionParamSpec(paramSpec); //查找是否存在父子关系的1，2级同题型param
			if(res == null || res.size() <= 0) {
				Map param = new HashMap();
				param.put("ei_id", aid);
				paperService.addExampaperQuestionParam(param);
				res = paperService.getExampaperQuestionParam(aid);
			}
			
			for(Map param:res) {               //遍历原res，为里边的param打标记0和1，区分正常的全1级抽题和特殊的不在任何2级内的1级抽题
				param.put("spec","0");
				for(Map spec:resSpec) {
					if(param.get("QTID").equals(spec.get("QTID")) && param.get("THID").equals(spec.get("THID"))) {
						param.put("spec", "1");
					}
				}	
			}
			
			List<Map<String, Object>> paramList = new ArrayList<Map<String, Object>>();
			
			//Set<Map<String, Object>> nlist = new HashSet<Map<String, Object>>();
			List<Map<String, Object>> nlist = new ArrayList<Map<String, Object>>();
			List<Map<String, Object>> mainlist = new ArrayList<Map<String, Object>>();
			for(int i=0;i<res.size();i++){
				int qnum = ((BigDecimal) res.get(i).get("NUM")).intValue();
				if(qnum!=0){
					Map m1 = new HashMap();
					m1.put("cid", res.get(i).get("CID"));
					m1.put("num", qnum);
					m1.put("thid", res.get(i).get("THID"));
					m1.put("thid_pid", res.get(i).get("PID"));
					m1.put("qtid", res.get(i).get("QTID"));				
					m1.put("thlevel", String.valueOf(res.get(i).get("THLEVEL")));
					m1.put("eid", bid);
					m1.put("spec", res.get(i).get("spec"));
					if(bexaminfo.get("ISVERIFIED")!=null && Integer.parseInt(String.valueOf(bexaminfo.get("ISVERIFIED")))==1){
						m1.put("isVerified", "1");
	                }
					if(bexaminfo.get("FORBIDBEFORE")!=null){
						int forbidDay = Integer.parseInt(String.valueOf(bexaminfo.get("FORBIDBEFORE")));
		                if(forbidDay>0){
		                	m1.put("forbidDay", forbidDay);
		                }
					}
					
	                int forbidNum = 0;
	                if(bexaminfo.get("FORBIDNUM")!=null && !"".equals(String.valueOf(bexaminfo.get("FORBIDNUM")))){
	                	forbidNum = Integer.parseInt(String.valueOf(bexaminfo.get("FORBIDNUM")));
	                }
	                if(forbidNum>=1){
	                	m1.put("forbidNum", forbidNum);
	                }
					
					int iscon = Integer.parseInt(String.valueOf(res.get(i).get("ISCON")));
					if(iscon==1){
						List<Map<String, Object>> mqids = paperService.getMqids(m1); //当选中题型为串题时，查看有没有对应该题型和主题词的小题
						if(mqids!=null && mqids.size()>0){
							int branchNum = ((BigDecimal)mqids.get(0).get("QSUM")).intValue();
		            		if(branchNum<qnum){
		            			int next=10;
		            			while(next>0){
		            				m1.put("mqids", mqids);
		            				m1.put("extra_num", qnum-branchNum);
		                			Map<String,Object> extra = paperService.getMqids_extra(m1);
		                			if(extra==null){
		                				break;
		                			}
		                			mqids.add(extra);
		                			branchNum = branchNum+((BigDecimal)extra.get("COUNT")).intValue();
		                			if(branchNum>=qnum){
		                				break;
		                			}
		                			next--;
		            			}            			
		            		}
						}else{
							Map<String,Object> mqid_null = paperService.getMqids_null(m1);
	            			if(mqid_null!=null){
	            				mqids.add(mqid_null);
	            			}else {
	            				m1.put("noTheme", "Y");
	            				mqid_null = paperService.getMqids_null(m1);
	            				if(mqid_null!=null){
	            					mqids.add(mqid_null);
	            				}
	            			}
						}
	            		
	            		for(Map<String, Object> s: mqids){
	            			s.put("cid", res.get(i).get("CID"));
	            			s.put("ei_id", bid);
	            			mainlist.add(s);
	            		}

	            		if(mqids!=null&&mqids.size()>0) {
                            List<Map<String,Object>> branch = paperService.getBrachByMqid(mqids);
                            for(Map<String, Object> s:branch){
                                boolean f=false;
                                for(int z=0;z<nlist.size();z++){
                                    if(String.valueOf(s.get("ID")).equals(String.valueOf(nlist.get(z).get("ID")))){
                                        f=true;
                                        break;
                                    }
                                }
                                if(!f){
                                    s.put("EID", bid);
                                    nlist.add(s);
                                }
                            }
                        }

					}else{
						List<Map<String, Object>> qList =  paperService.getRandomQuestion(m1);
	            		for(Map<String, Object> s: qList){
	            			s.put("EID", bid);
	            			nlist.add(s);  //非串题
	            		}
						
					}
					paramList.add(m1);
				}					
			}
			
			Map param = new HashMap();
			param.put("ei_id", bid);
			param.put("question", new ArrayList<>(nlist));
			param.put("mainQuestion", mainlist);
			param.put("mquestion", paramList);
			param.put("aid", aid);
			
			if(paramList.size() > 0){
				paperService.generateBpaper(param);	//添加试卷试题（有点难，请耐心看）
			}

			List<Map<String,Object>> exampaperQuestionTypeList=paperService.getExampaperQuestionTypeList(bid);
			getRequest().setAttribute("exampaperQuestionTypeList", exampaperQuestionTypeList);
			getRequest().setAttribute("ei_id", bid);
			getRequest().setAttribute("c_id", getPara("cid"));
			getRequest().setAttribute("isRebulid", 0);
			getRequest().setAttribute("isB", "true");
			
			paperService.updatePaperQuestionOrder(bid);
			
			String ename = String.valueOf(bexaminfo.get("ENAME"));
			Map log = new HashMap();
			log.put("content", "试卷《"+ ename +"》（编号："+ aid +"）生成B卷，B卷ID为" + bid);
			log.put("cid", getPara("cid"));
			systemService.addSysLog(log);
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return "jsp/paper/adjustPaper";

	}

	// 编辑A卷
	@RequestMapping("/editApaper")
	public String editApaper() {
		String ei_id = getPara("ei_id");
		Map<String, Object> examInfo = paperService.getExamInfo(ei_id);
		int eiState = Utils.changeObjToInt(examInfo.get("STATE"));
		String[] cids = getPara("c_id").split(",");
		if(cids.length>1){//说明是多课程组卷，如果是多课程组卷，列表会显示所属课程
			getRequest().setAttribute("multi", 1);
			List<Map<String,Object>> course=paperService.getPaper_CourseName(cids);
			getRequest().setAttribute("courseList", course);
		}else{
			getRequest().setAttribute("multi", 0);
			getRequest().setAttribute("themeList", paperService.selectThemeFromPaper(ei_id));
		}
        getRequest().setAttribute("ei_id", ei_id);
		getRequest().setAttribute("c_id", getPara("c_id"));
		getRequest().setAttribute("mobile", getPara("mobile"));
		//way用于分辨是从监考管理进入还是试卷管理进入[way=monitor(监考管理);为空表示其他入口进入]
		getRequest().setAttribute("way", getPara("way"));
		getRequest().setAttribute("bid", examInfo.get("BID"));
		getRequest().setAttribute("aorb", examInfo.get("AORB"));
		getRequest().setAttribute("restart", examInfo.get("RESTART"));
		getRequest().setAttribute("ename", examInfo.get("ENAME"));
		getRequest().setAttribute("isUnion", examInfo.get("ISUNION"));
		getRequest().setAttribute("randomanswer", examInfo.get("RANDOMANSWER"));
		
		getRequest().setAttribute("questionTypeList", paperService.selectQuestionTypeFromPaper(ei_id));
		getRequest().setAttribute("cognitionList", paperService.selectCognitionFromPaper(ei_id));
		getRequest().setAttribute("difficultyList", paperService.selectDifficultyFromPaper(ei_id));
		getRequest().setAttribute("knowledgeList", paperService.selectKnowledgeFromPaper(ei_id));
		
		//试卷的试题是否可编辑[edit=1(不能编辑)；为空表示可编辑]，暂时没起作用，如果有必要屏蔽试卷试题的编辑入口，可启用
		if(getPara("edit")!=null) {
			getRequest().setAttribute("edit", getPara("edit"));
		}
		//试卷的试题列表，标记是否可以编辑试卷[readonly=1(不能编辑);为空表示可以编辑]
		if(getPara("readonly")!=null){
			getRequest().setAttribute("readonly", getPara("readonly"));
		}else{
			getRequest().setAttribute("readonly", "0");
		}
		if(!getSubject().hasRole("administrator")){
			getRequest().setAttribute("isAdmin", "n");
		}else{
			getRequest().setAttribute("isAdmin", "y");
		}
		systemService.addOnlineSysLog("预览了"+ei_id+"的试卷");
		return "jsp/paper/previewPaper";
	}
	
	// 编辑B卷
	@RequestMapping("/editBpaper")
	public String editBpaper() {
		String ei_id = getPara("ei_id");
		Map<String, Object> examInfo = paperService.getExamInfo(ei_id);
		int eiState = Utils.changeObjToInt(examInfo.get("STATE"));

		String[] cids = getPara("c_id").split(",");
		if(cids.length>1){//说明是多课程组卷，如果是多课程组卷，列表会显示所属课程
			getRequest().setAttribute("multi", 1);
			List<Map<String,Object>> course=paperService.getPaper_CourseName(cids);
			getRequest().setAttribute("courseList", course);
		}else{
			getRequest().setAttribute("multi", 0);
			getRequest().setAttribute("themeList", paperService.selectThemeFromPaper(ei_id));
		}
        getRequest().setAttribute("ei_id", ei_id);
		getRequest().setAttribute("c_id", getPara("c_id"));
		getRequest().setAttribute("bid", examInfo.get("BID"));
		getRequest().setAttribute("cpid", examInfo.get("CPID"));
		getRequest().setAttribute("aorb", examInfo.get("AORB"));
		getRequest().setAttribute("ename", examInfo.get("ENAME"));
		getRequest().setAttribute("randomanswer", examInfo.get("RANDOMANSWER"));
		
		getRequest().setAttribute("questionTypeList", paperService.selectQuestionTypeFromPaper(ei_id));
		getRequest().setAttribute("cognitionList", paperService.selectCognitionFromPaper(ei_id));
		getRequest().setAttribute("difficultyList", paperService.selectDifficultyFromPaper(ei_id));
		getRequest().setAttribute("knowledgeList", paperService.selectKnowledgeFromPaper(ei_id));
		getRequest().setAttribute("isB", "true");
		getRequest().setAttribute("sum", paperService.getTotalPoints(ei_id));
		Map m = new HashMap();
		m.put("ei_id", ei_id);
		getRequest().setAttribute("total", paperService.getExampaperQuestionCount(m));
		
		/*
		if(getPara("firstVerify")!=null) {
			getRequest().setAttribute("firstVerify", getPara("firstVerify"));
		}*/
		//试卷的试题是否可编辑[edit=1(不能编辑)；为空表示可编辑]，暂时没起作用，如果有必要屏蔽试卷试题的编辑入口，可启用
		if(getPara("edit")!=null) {
			getRequest().setAttribute("edit", getPara("edit"));
		}
		//试卷的试题列表，标记是否可以编辑试卷[readonly=1(不能编辑);为空表示可以编辑]
		if(getPara("readonly")!=null){
			getRequest().setAttribute("readonly", getPara("readonly"));
		}else{
			getRequest().setAttribute("readonly", "0");
		}
		if(!getSubject().hasRole("administrator")){
			getRequest().setAttribute("isAdmin", "n");
		}else{
			getRequest().setAttribute("isAdmin", "y");
		}
		systemService.addOnlineSysLog("预览了"+ei_id+"的试卷");
		return "jsp/paper/previewPaper4addB";
	}
	
	// 删除试卷试题
	@RequestMapping("/delQuestion")
	public @ResponseBody String delQuestion() {
		String eid=getPara("ei_id");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(map)==0){
				return "";
			}
		}
		Map m = new HashMap();
		m.put("id", getPara("q_id"));
		m.put("ei_id", getPara("ei_id"));
		m.put("mqid", getPara("mqid"));		
		paperService.deleteExampaperQuestion(m);
		Map log = new HashMap();
		log.put("content", "删除试卷试题，试题编号为："+ getPara("q_id")+"，试卷编号为："+getPara("ei_id"));
		log.put("cid", "");
		systemService.addSysLog(log);
		paperService.updatePaperQuestionOrder(getPara("ei_id"));
		return "";
	}
	
	/**
	 * 批量删除试卷的试题
	 * @param map
	 * @return
	 */
	@RequestMapping("/delSelectQuestion")
	public @ResponseBody String delSelectQuestion(@RequestBody Map map) {
		List<Map<String, Object>> list = (List<Map<String, Object>>) map.get("data");
		StringBuffer sb=new StringBuffer();
		for(int i=0;i<list.size();i++) {
			String eid=list.get(i).get("eid").toString();
			if(!getSubject().hasRole("administrator")){
				Map mm = new HashMap();
				mm.put("uid", getUserID());
				mm.put("eid", eid);
				mm.put("permission", "paper:update");
				if(verifyService.checkPaperPermission(mm)==0){
					return "";
				}
			}
			Map param = new HashMap();
			param.put("ei_id", eid);
			param.put("id", list.get(i).get("qid").toString());
			if(list.get(i).get("mqid")!=null){
				param.put("mqid", list.get(i).get("mqid").toString());
				sb.append(param.get("mqid")+",");
			}else{
				param.put("mqid", "");
				sb.append(param.get("id")+",");
			}

			paperService.deleteExampaperQuestion(param);
		}
        Map log = new HashMap();
        log.put("content", "批量删除试卷试题，试题编号为（"+sb.substring(0, sb.length()-1)+"），试卷编号为："+list.get(0).get("eid"));
        log.put("cid", "");
        systemService.addSysLog(log);
		paperService.updatePaperQuestionOrder(list.get(0).get("eid").toString());
		return "1";
	}
	
	//删除B卷
	/*
	@RequestMapping("/delBExamInfo")
	public @ResponseBody String delBExamInfo() {		
		return paperService.delExamInfo(getPara("eid")) + "";
	}*/
	
	
	// 获取相同部门教师列表
	@RequestMapping("/getTeacherList")
	public @ResponseBody List<Map<String, Object>> getTeacherList() {		
		return paperService.getTeacherByUnitID(getUserInfo().getUnitID());
	}

	//更新考务信息
	@RequestMapping("/updateExamInfo")
	public @ResponseBody String updateExamInfo() throws ParseException {
		Map param = new HashMap();
		String ei_id = getPara("ei_id");
		String action = getPara("action");
		String state = getPara("state");
		User u = getUserInfo();
		if(u==null){
			return "false";
		}
		if(getPara("chosen")!=null&&!StringUtils.isEmpty(getPara("chosen"))) {
			param.put("ei_id", getPara("chosen"));
		}else {
			param.put("ei_id", ei_id);
		}
//		if(StringUtils.isEmpty(getPara("chosen"))){
//			param.put("ei_id", getPara("ei_id")); //考务ID
//		}else{
//			ei_id = getPara("chosen");
//			param.put("chosen", getPara("chosen")); //选用试卷
//			param.put("ei_id", getPara("chosen")); //考务ID
//		}
		String ename = getPara("ename");
		param.put("period", getPara("period"));	//学时
		param.put("ename", ename);	//试卷名称
		param.put("code", getPara("code"));
		param.put("schoolYear", getPara("schoolYear")); //考试学年
		param.put("term", getPara("term"));	//考试学期
		param.put("type", getPara("examType"));	//考试类型
		param.put("testway", getPara("examWay")); //开闭卷
		param.put("total", getPara("total"));	//考试应到人数
		param.put("printcount", getPara("pcount"));	//打印份数
		param.put("proportion", getPara("percent"));	//成绩比例
		param.put("begindate", Utils.getDateFromStr(getPara("bt"),"yyyy-MM-dd HH:mm")); //开始时间
		param.put("enddate", Utils.getDateFromStr(getPara("et"),"yyyy-MM-dd HH:mm")); //结束时间
		param.put("time", getPara("time"));		//考试用时
		param.put("missionnum", getPara("missionnum"));		//通用号	
		param.put("lockBefore", getPara("loginBefore"));	//开考前多少分钟禁止登录
		param.put("lockAfter", getPara("loginAfter"));	//开考后多少分钟后禁止登录
		param.put("handInTimeLimit", getPara("handInTimeLimit"));
		param.put("scheckway", getPara("queryScore"));	//成绩开放给学生查看
		param.put("getanswer", getPara("queryPaper"));	//考试答案开放给学生查看
		param.put("testtimeset", getPara("testMode"));	//考试方式
		param.put("answerSequence", getPara("answerSequence"));	//答题顺序
		param.put("correctway", getPara("correctPaper"));	//改卷方式
		param.put("remark2s", getPara("remark2s"));	//考试时给学生看的备注
		param.put("e_remark2s", getPara("e_remark2s"));	//教师添加的考试备注
		param.put("remark2t", getPara("remark2t"));	//教师添加的考试备注
		param.put("switch_out_limit", getPara("switchOutLimitSelect")); //切屏限制
		param.put("tasknum_switch", "0"); //是否启用任务号
		param.put("forbidBefore", getPara("forbidDay"));	//组卷时限定多少天以前出过的试题不再出
		param.put("forbidNum", getPara("forbidNum"));	//组卷时限定多少次以上出过的试题不再出
		param.put("isVerified", getPara("isVerified"));	//组卷时限定试题是否通过审核
		param.put("tel", getPara("tel"));
		param.put("randomanswer", getPara("randomAnswer"));
		param.put("sidverify", getPara("sidVer"));	//是否验证学号考试，是否启用人脸识别
		param.put("facetime", getPara("facetime"));	//人脸识别次数
		param.put("facefail", getPara("face_fail"));
		if(getPara("facetime")==null || !"2".equals(getPara("sidVer"))){
			param.put("facetime", 0);//人脸识别次数
			param.put("facefail", 0);
		}
		param.put("invigilatorids", getPara("invigilator")); //监考老师id
		param.put("patrolids", getPara("patrol")); //巡考老师id
		param.put("courseTeacher", getPara("courseTeacher")); //任课老师
		param.put("firstverifyopinion", getPara("firstverifyopinion")); //初级审核意见
		param.put("lastverifyopinion", getPara("lastverifyopinion")); //终极审核意见
		param.put("firstpsw", getPara("firstpsw")); //一次登录密码
		param.put("secondpsw", getPara("secondpsw")); //二次登录密码
		param.put("venues", getPara("venues"));
		param.put("isUnion", getPara("isUnion"));
		param.put("editor_switch", getPara("editorSwitch"));
		param.put("random_switch", getPara("randomSwitch"));
		param.put("mobile",getPara("mobile"));
		String answersheet=getPara("answersheet");
		if(answersheet!=null && !"undefined".equals(answersheet)&& !"".equals(answersheet)){
			param.put("answersheet", answersheet);
		}
		
		String[] arr = getParaValues("testObj");
		List<Map<String,Object>> list = new ArrayList<>();
		if(arr!=null){
			for(String a:arr){
				String[] s = a.split(",");
				Map m = new HashMap();
				m.put("grade", s[0]);
				m.put("specialty", s[1]);
				list.add(m);
			}
		}
		
		param.put("objectList", list);

		String return_state = getPara("return_state");
		if(action != null && state != null){
			param.put("action", action);
			if(action.equals("submitForVer") && state.equals("0")){
				param.put("state", 1);
				param.put("submit4verify", new Date());
				param.put("submit4verifyid", getUserID());
				param.put("submit4verifyname", getUsername());
				
				Map log = new HashMap();
				log.put("content", "审核试卷《"+ ename +"》（编号："+ ei_id +"）");
				log.put("cid", "");
				systemService.addSysLog(log);
			}
			if(action.equals("firstVerify") && state.equals("1")){
				param.put("state", 2);
				param.put("firstverify", new Date());
				param.put("firstverifyid", getUserID());
				param.put("firstverifyname", getUsername());
				
				//更新试卷试题的考试次数
				Map<String,Object> examinfo = paperService.getExamInfo(ei_id);
				param.put("eid", param.get("ei_id"));
				param.put("testtime", examinfo.get("BEGINDATE"));
				questionService.updateNum_testtime(param);
				
				Map log = new HashMap();
				log.put("content", "初审试卷《"+ ename +"》（编号："+ ei_id +"）");
				log.put("cid", "");
				systemService.addSysLog(log);
			}
			if(action.equals("lastVerify") && state.equals("2")){
				param.put("action", "lastVerify");
				param.put("state", 3);
				param.put("lastverify", new Date());
				param.put("lastverifyid", getUserID());
				param.put("lastverifyname", getUsername());
				param.put("firstpsw",(int)((Math.random()*9+1)*10000) + "");
				param.put("secondpsw",(int)((Math.random()*9+1)*10000) + "");	
				
				Map log = new HashMap();
				log.put("content", "终审试卷《"+ ename +"》（编号："+ ei_id +"）");
				log.put("cid", "");
				systemService.addSysLog(log);
			}
			if(action.equals("fail") && return_state.equals("2")){
				param.put("state", 7);
				param.put("verifyfail", new Date());
				param.put("verifyfailid", getUserID());
				param.put("verifyfailname", getUsername());
				
				Map log = new HashMap();
				log.put("content", "审核不通过，试卷《"+ ename +"》（编号："+ ei_id +"）");
				log.put("cid", "");
				systemService.addSysLog(log);
			}
			if(action.equals("fail") && return_state.equals("0")){
				param.put("state", 0);
				param.put("verifyfail", new Date());
				param.put("verifyfailid", getUserID());
				param.put("verifyfailname", getUsername());
				
				Map log = new HashMap();
				log.put("content", "审核不通过，试卷退回到尚未提交，试卷《"+ ename +"》（编号："+ ei_id +"）");
				log.put("cid", "");
				systemService.addSysLog(log);
			}
			if(action.equals("fail") && return_state.equals("1")){
				param.put("state", 1);
				param.put("verifyfail", new Date());
				param.put("verifyfailid", getUserID());
				param.put("verifyfailname", getUsername());
				
				Map log = new HashMap();
				log.put("content", "审核不通过，试卷退回到尚未初审，试卷《"+ ename +"》（编号："+ ei_id +"）");
				log.put("cid", "");
				systemService.addSysLog(log);
			}
			if(action.equals("reVerify")){
				param.put("state", 1);
			}
			
		}else {
			Map log = new HashMap();
			log.put("content", "编辑试卷《"+ ename +"》（编号："+ ei_id +"）考务信息");
			log.put("cid", "");
			systemService.addSysLog(log);
		}

		Map<String,Object> examinfo = paperService.getExamInfo(ei_id);
		if (openFindRepeatSystem==1){
			if("submitForVer".equals(action) || "reVerify".equals(action)){
				paperChangeRecorder.recordPaperRepeatPdf(examinfo, "firstSubmit", u);
			}else if("firstVerify".equals(action)){
				paperChangeRecorder.recordPaperRepeatPdf(examinfo, "firstVerify", u);
			}
		}
		paperService.updateExamInfo(param);

		LocalCache cache = LocalCache.getInstance();
		cache.evict("examinfo",ei_id);
		return "success";
	}

	@GetMapping("/toPaperQuestionRepeatCompare")
	public String toPaperQuestionRepeatCompare(@RequestParam(value = "eids", required = false) String[] eids){
		if(eids!=null && eids.length==2){
			getRequest().setAttribute("eids", String.join(",", eids));
		}
		return "jsp/paper/paperQuestionRepeatCompare";
	}

	@PostMapping("/findTwoPaperRepeatQuestions")
	public @ResponseBody Map<String,Object> findTwoPaperRepeatQuestions(){
		Map<String,Object> param = new HashMap<>();
		String eid1 = getPara("eid1");
		String eid2 = getPara("eid2");
		if(!verifyService.checkViewPaperPermission(eid1)){
			param.put("errorMsg", "没有预览试卷"+eid1+"的权限");
			return param;
		}
		if(!verifyService.checkViewPaperPermission(eid2)){
			param.put("errorMsg", "没有预览试卷"+eid2+"的权限");
			return param;
		}
		Map<String,Object> rtn = paperService.findTwoPaperRepeatQuestions(eid1, eid2, Utils.changeObjToInt(getPara("answerMatch")));
		return rtn;
	}

	@RequestMapping("/getRepeatDetail")
	public @ResponseBody List<DuplicatePairDTO> getRepeatDetail(){
		String eid = getPara("eid");
		if(openFindRepeatSystem==0){
			return null;
		}
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:view");
			if(verifyService.checkPaperPermission(map)==0){
				return null;
			}
		}
		String qid = getPara("qid");
		String fromPaper = getPara("fromPaper");
		return statsApiClient.statsDetailByQid(eid, qid, fromPaper);
	}

	@RequestMapping("/toExamRepeatDetail")
	public String toExamRepeatDetail(HttpServletResponse response) throws Exception {
		String eid = getPara("eid");
		User user = getUserInfo();

		if (user == null || openFindRepeatSystem == 0 || StringUtils.isBlank(eid)) {
			return "jsp/notTheRole";
		}
		Map<String, Object> examInfo = paperService.getExamInfo(eid);
		if (!getSubject().hasRole("administrator")) {
			Map<String, Object> map = new HashMap<>();
			map.put("uid", user.getId());
			map.put("eid", eid);
			map.put("permission", "paper:update");
			if (verifyService.checkPaperPermission(map) == 0) {
				return "jsp/notTheRole";
			}
		}

		Map<String,Object> model = new HashMap<>();
		model.put("repeatDetail", statsApiClient.statsDetailByExam(
				eid,
				(String) examInfo.get("BID")));
		model.put("checkTeacher", user.getRealname() + "（ " + user.getUsername() + " ）");
		model.put("checkTimeStr", DateFormatUtils.getNowTime4ZhCN());

		model.put("ename", examInfo.get("ENAME") + "（" +eid + "）");
		GenerateWordUtils.setFtlView(response, "wenzhouPaper/examRepeatDetail.ftl", model);
		return null;
	}

	@RequestMapping(value = "/checkPaperRepeatPdf", method = {RequestMethod.GET, RequestMethod.POST}, produces = "text/plain;charset=UTF-8")
	public @ResponseBody String checkPaperRepeatPdf(@RequestParam("eid") String eid,
						@RequestParam("type") String type) {

		if (StringUtils.isBlank(eid) || StringUtils.isBlank(type)) {
			return "fail";
		}

		String fileName = null;
		if ("firstSubmit".equals(type)) {
			fileName = eid + "_firstSubmit.pdf";
		} else if ("firstVerify".equals(type)) {
			fileName = eid + "_firstVerify.pdf";
		} else {
			return "fail";
		}

		int result = statsApiClient.pdfExists(eid, fileName);

		if(result==-1){
			return "busy";
		}
		if (result == 1) {
			return "success";
		}
		if (result == 0) {
			return "not_found";
		}
		return "fail";
	}

	/**
	 * 下载查重PDF
	 * 下载失败直接下发 error.txt
	 */
	@RequestMapping(value = "/downloadPaperRepeatPdf", method = {RequestMethod.GET, RequestMethod.POST})
	public ResponseEntity<Resource> downloadPaperRepeatPdf(@RequestParam("eid") String eid,
											 @RequestParam("type") String type) {

		if (StringUtils.isBlank(eid) || StringUtils.isBlank(type)) {
			return FileDownloadUtils.errorResponse("参数错误");
		}

		String fileName = null;
		if ("firstSubmit".equals(type)) {
			fileName = eid + "_firstSubmit.pdf";
		} else if ("firstVerify".equals(type)) {
			fileName = eid + "_firstVerify.pdf";
		} else {
			return FileDownloadUtils.errorResponse("参数错误");
		}

		// 先查一下，尽量把提示分清楚
		int exists = statsApiClient.pdfExists(eid, fileName);
		if (exists == 0) {
			return FileDownloadUtils.errorResponse("文件不存在：" + fileName);
		}
		if (exists != 1) {
			return FileDownloadUtils.errorResponse("查重系统繁忙或请求失败，请稍后重试");
		}

		byte[] bytes = statsApiClient.downloadPdfBytes(eid, fileName);
		if (bytes == null || bytes.length == 0) {
			return FileDownloadUtils.errorResponse("查重PDF下载失败，请稍后重试");
		}

		return FileDownloadUtils.download(bytes, fileName, MediaType.APPLICATION_PDF);
	}

	@RequestMapping("/updateExamInfoState")
	public @ResponseBody int updateExamInfoState() {
		String ei_id = getPara("ei_id");
		Map<String, Object> examInfo = paperService.getExamInfo(ei_id);
		Map param = new HashMap();
		param.put("state", "0");
		param.put("aorb", examInfo.get("AORB"));
		if(getPara("chosen")!=null&&!StringUtils.isEmpty(getPara("chosen"))) {
			param.put("ei_id", getPara("chosen"));
		}else {
			param.put("ei_id", ei_id);
		}
		String ename = getPara("ename");
		param.put("period", getPara("period"));	//学时
		param.put("ename", ename);	//试卷名称
		param.put("code", getPara("code"));
		param.put("schoolYear", getPara("schoolYear")); //考试学年
		param.put("term", getPara("term"));	//考试学期
		param.put("type", getPara("examType"));	//考试类型
		param.put("testway", getPara("examWay")); //开闭卷
		param.put("total", getPara("total"));	//考试应到人数
		param.put("printcount", getPara("pcount"));	//打印份数
		param.put("proportion", getPara("percent"));	//成绩比例
		try {
			param.put("begindate", Utils.getDateFromStr(getPara("bt"),"yyyy-MM-dd HH:mm")); //开始时间
			param.put("enddate", Utils.getDateFromStr(getPara("et"),"yyyy-MM-dd HH:mm")); //结束时间
		}catch (ParseException e){
			e.printStackTrace();
		}
		param.put("time", getPara("time"));		//考试用时
		param.put("missionnum", getPara("missionnum"));		//通用号
		param.put("lockBefore", getPara("loginBefore"));	//开考前多少分钟禁止登录
		param.put("lockAfter", getPara("loginAfter"));	//开考后多少分钟后禁止登录
		param.put("handInTimeLimit", getPara("handInTimeLimit"));
		param.put("scheckway", getPara("queryScore"));	//成绩开放给学生查看
		param.put("getanswer", getPara("queryPaper"));	//考试答案开放给学生查看
		param.put("testtimeset", getPara("testMode"));	//考试方式
		param.put("answerSequence", getPara("answerSequence"));	//答题顺序
		param.put("correctway", getPara("correctPaper"));	//改卷方式
		param.put("remark2s", getPara("remark2s"));	//考试时给学生看的备注
		param.put("e_remark2s", getPara("e_remark2s"));	//教师添加的考试备注
		param.put("remark2t", getPara("remark2t"));	//教师添加的考试备注
		param.put("forbidBefore", getPara("forbidDay"));	//组卷时限定多少天以前出过的试题不再出
		param.put("forbidNum", getPara("forbidNum"));	//组卷时限定多少次以上出过的试题不再出
		param.put("isVerified", getPara("isVerified"));	//组卷时限定试题是否通过审核
		param.put("tel", getPara("tel"));
		param.put("randomanswer", getPara("randomAnswer"));
		param.put("sidverify", getPara("sidVer"));	//是否验证学号考试
		param.put("facetime", getPara("facetime"));	//人脸识别次数
		param.put("facefail", getPara("face_fail"));
		if(getPara("facetime")==null || !"2".equals(getPara("sidVer"))){
			param.put("facetime", 0);//人脸识别次数
			param.put("facefail", 0);
		}
		param.put("invigilatorids", getPara("invigilator")); //监考老师id
		param.put("patrolids", getPara("patrol")); //巡考老师id
		param.put("courseTeacher", getPara("courseTeacher")); //任课老师
		param.put("firstverifyopinion", getPara("firstverifyopinion")); //初级审核意见
		param.put("lastverifyopinion", getPara("lastverifyopinion")); //终极审核意见
		param.put("firstpsw", getPara("firstpsw")); //一次登录密码
		param.put("secondpsw", getPara("secondpsw")); //二次登录密码
		param.put("venues", getPara("venues"));
		param.put("isUnion", getPara("isUnion"));
		param.put("editor_switch", getPara("editorSwitch"));
		param.put("random_switch", getPara("randomSwitch"));
		param.put("mobile",getPara("mobile"));
		param.put("tasknum_switch", "0"); //是否启用任务号
		param.put("switch_out_limit", getPara("switchOutLimitSelect")); //切屏限制
		String answersheet=getPara("answersheet");
		if(answersheet!=null && !"undefined".equals(answersheet)&& !"".equals(answersheet)){
			param.put("answersheet", answersheet);
		}

		String[] arr = getParaValues("testObj");
		List<Map<String,Object>> list = new ArrayList<>();
		if(arr!=null){
			for(String a:arr){
				String[] s = a.split(",");
				Map m = new HashMap();
				m.put("grade", s[0]);
				m.put("specialty", s[1]);
				list.add(m);
			}
		}

		param.put("objectList", list);
		paperService.updateExamInfo(param);
        return 1;
	}


	//进入从已有试卷加题页面
	@RequestMapping("/QuestionFromPaper")
	public String QuestionFromPaper(){
		String eid=getPara("eid");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(map)==0){
				return "jsp/notTheRole";
			}
		}
		getRequest().setAttribute("cid", getPara("cid"));
		getRequest().setAttribute("eid",eid);
		String[] eids = getParaValues("eids");
		StringBuffer sb = new StringBuffer();
		for(String e:eids){
			sb.append(e+",");
		}
		getRequest().setAttribute("eids", sb.substring(0,sb.length()-1));
		String[] cids = getPara("cid").split(",");
		Map m = new HashMap();
		m.put("eid", sb.substring(0,sb.length()-1).toString().split(","));
		if(cids.length == 1) {
			m.put("cid", getPara("cid"));
			getRequest().setAttribute("courseInfo", paperService.getPaperFilter(m));
			getRequest().setAttribute("cname", courseService.getCourseNameById(cids).get(0).get("NAME_C"));
		}else {
			getRequest().setAttribute("courseInfo", paperService.getPaperFilter(m));
			getRequest().setAttribute("courseList", courseService.getCourseNameById(cids));
		}
//		if (cids.length==1) {
//			getRequest().setAttribute("courseInfo", courseService.getCourseAttr(getPara("cid")));
//		}else {
//			List<Map<String, Object>> themeList = new ArrayList<Map<String, Object>>();
//			List<Map<String, Object>> couresList = new ArrayList<Map<String, Object>>();
//			for(String cid:cids) {
//				Map<String, Object> course = (Map<String, Object>) courseService.getCourseAttr(cid).get(0);
//				List<Map<String, Object>> theme = (List<Map<String, Object>>) course.get("themeList");
//				for(Map mm:theme) {
//					themeList.add(mm);
//				}
//				Map<String, Object> c = new HashMap<String, Object>();
//				c.put("id", course.get("id"));
//				c.put("cname", course.get("name_c"));
//				couresList.add(c);
//			}
//			
//			List<Map<String, Object>> difficultyList = MultiCourseCombination(cids, "difficultyList", "DID");
//			List<Map<String, Object>> questionTypeList = MultiCourseCombination(cids, "questionTypeList", "QTID");
//			List<Map<String, Object>> cognitionList = MultiCourseCombination(cids, "cognitionList", "COID");
//			List<Map<String, Object>> knowledgeList = MultiCourseCombination(cids, "knowledgeList", "KID");
//			
//			List<Map<String, Object>> courseInfo = new ArrayList<Map<String, Object>>();
//			Map<String, Object> m = new HashMap<String, Object>();
//			m.put("difficultyList", difficultyList);
//			m.put("questionTypeList", questionTypeList);
//			m.put("cognitionList", cognitionList);
//			m.put("knowledgeList", knowledgeList);
//			m.put("themeList", themeList);
//			courseInfo.add(m);
//			getRequest().setAttribute("courseInfo", courseInfo);
//			getRequest().setAttribute("courseList", couresList);
//		}
		getRequest().setAttribute("state", getPara("state"));
		return "jsp/paper/QuestionFromPaper";
	}
	
	//从已有试卷加题
	@RequestMapping("/addQuestionFromPaper")
	public String addQuestionFromPaper(){
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", getPara("eid"));
			map.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(map)==0){
				return "jsp/notTheRole";
			}
		}
		getRequest().setAttribute("cid", getPara("cid"));
		getRequest().setAttribute("eid", getPara("eid"));
		return "jsp/paper/addQuestionFromPaper";
	}	

	// 获取试卷
	@RequestMapping("/getPaperList")
	public @ResponseBody Map<String, Object> getPaperList() {
		Map m = new HashMap();
		m.put("cid", getPara("cid").split(","));
		m.put("eid", getPara("eid"));
		m.put("state", getParaValues("state"));
		PageUtils pu = getPageUtil();
		return getRes(paperService.getPaperList(m, pu), paperService.getPaperCount(m));	
	}
	
	// 获取试卷
	@RequestMapping("/getPaperList4combinePaper")
	public @ResponseBody Map<String, Object> getPaperList4combinePaper() {
		Map m = new HashMap();
//		m.put("cid", getPara("cid").split(","));
//		m.put("eid", getPara("eid"));
		m.put("tid", getUserID());
		if(!getSubject().hasRole("administrator")){
			m.put("role", "teacher");
		}else{
			m.put("role", "administrator");
		}
		Enumeration<String> paramNames = getRequest().getParameterNames();  
		// 通过循环将表单参数放入键值对映射中  
		while(paramNames.hasMoreElements()) {  
			String key = paramNames.nextElement();  			
			String value = getRequest().getParameter(key);
			if(key.equals("state")){
				if(value!=null){
					m.put("state", value.split(","));
				}else{
					m.put("state", value);
				}
				
			}else{
				m.put(key, value);
			}			
		}
		m.remove("num");
		String num = getPara("num");
		if (StringUtils.isNotBlank(num)) {
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
				m.put("manyNums", paramNums);
			} else {
				m.put("num", num.trim());
			}
		}
		setMapParamSafe(m, "teacher");
		PageUtils pu = getPageUtil();
		return getRes(paperService.getPaperList4combinePaper(m, pu), paperService.getPaperList4combinePaperCount(m));	
	}

	// 获取试卷的试题
	@RequestMapping("/getQuestionFromPaper")
	public @ResponseBody Map<String, Object> getQuestionFromPaper() {
		if(!getSubject().hasRole("administrator")){
			String[] eids=getPara("eids").split(",");
			for(String e:eids) {
				Map map = new HashMap();
				map.put("uid", getUserID());
				map.put("eid", e);
				map.put("permission", "paper:view");
				if(verifyService.checkPaperPermission(map)==0){
					return null;
				}
			}
		}
		
		Map m = new HashMap();
		m.put("cid", getPara("cid"));
		m.put("eid", getPara("eid"));
		m.put("eids", getPara("eids").split(","));
		m.put("th1id", getPara("th1id"));
		m.put("th2id", getPara("th2id"));
		m.put("th3id", getPara("th3id"));
		m.put("qtid", getPara("qtid"));
		m.put("coid", getPara("coid"));
		m.put("did", getPara("did"));
		m.put("kid", getPara("kid"));
		m.put("isVerified", getPara("isVerified"));
		PageUtils pu = getPageUtil();
		int Sys_forbidDay = Utils.changeObjToInt(getApplication().getAttribute("question_used_day"));//获取系统设置好的限制次数（parseint）
		int forbidDay = Math.min(Utils.changeObjToInt(getPara("forbidDay"), Sys_forbidDay),
				Sys_forbidDay == 0 ? Integer.MAX_VALUE : Sys_forbidDay);

		int Sys_forbidNum = Utils.changeObjToInt(getApplication().getAttribute("question_use_time"));//获取系统设置好的限制次数（parseint）
		int forbidNum = Math.min(Utils.changeObjToInt(getPara("forbidNum"), Sys_forbidNum),
				Sys_forbidNum == 0 ? Integer.MAX_VALUE : Sys_forbidNum);

		int limit4Isreview = Utils.changeObjToInt(getApplication().getAttribute("limit4Isreview"));
		int isVerified = (limit4Isreview == 1)
				? 1 : Utils.changeObjToInt(getPara("isVerified"), limit4Isreview);
		if(isVerified==1){
        	m.put("isVerified", isVerified);
        }
        if(forbidDay>0){
        	m.put("forbidDay", forbidDay);
        }
        if(forbidNum>=1){
        	m.put("forbidNum", forbidNum);
        }
        Map<String, Object> res = new HashMap<>();
		
		res.put("rows", paperService.getQuestionFromPaper(m,pu));
		res.put("total", paperService.getQuestionFromPaperCount(m));
		
		return res;	
	}
	
	//更新试卷题型
	@RequestMapping("/updateExamQuestionType")
	public @ResponseBody String updateExamQuestionType() {
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", getPara("eid"));
			map.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(map)==0){
				return "error";
			}
		}
		String[] ids = getPara("ids").split(",");
		String[] desc = getPara("desc").split("!@#");
		String[] e_qtdesc = getPara("e_qtdesc").split("!@#");
		String[] e_qtname = getPara("e_qtname").split(",");
		String[] sxb=getPara("sxb").split(",");
		String[] xxdf=getPara("xxdf").split(",");
		String[] mediaSet=getPara("mediaSet").split(",");

		for(int i=0;i<ids.length;i++){
			Map m = new HashMap();
			m.put("qtid", ids[i]);
			m.put("qtdesc", desc[i]);
			m.put("e_qtdesc", e_qtdesc[i]);
			m.put("e_qtname", e_qtname[i]);
			m.put("sxb", sxb[i]);
			m.put("XXDF",xxdf[i]);
			m.put("mediaSet", mediaSet[i]);
			m.put("eid", getPara("eid"));
			paperService.updateExamQuestionType(m);
		}
		return "";
	}	

	@RequestMapping("/saveScore")
	public @ResponseBody String saveScore(@RequestBody Map map) {
		String eid = (String) map.get("eid"); 
		if(!getSubject().hasRole("administrator")){
			Map mm = new HashMap();
			mm.put("uid", getUserID());
			mm.put("eid", eid);
			mm.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(mm)==0){
				return "error";
			}
		}
		ArrayList<LinkedHashMap<String,Object>> list = (ArrayList<LinkedHashMap<String, Object>>) map.get("list");
		int rs = 0;
		for(int i=0; i<list.size(); i++){
			Map m = new HashMap();
			m.put("qid", list.get(i).get("qid"));
			BigDecimal s = new BigDecimal(list.get(i).get("score").toString());
			m.put("score", s.setScale(4,1));
			m.put("time", list.get(i).get("time"));
			m.put("eid", eid);
			rs += paperService.updateQuestionScore(m);
		}
		Map m = new HashMap();
		m.put("eid", eid);
		paperService.updatePaperScore(m);
		paperService.updatePaperMainQScore(m);
		LocalCache cache = LocalCache.getInstance();
		List<Map<String,Object>> qlist = cache.get("exampaper_question", eid);
		if(qlist!=null){
			cache.evict("exampaper_question", eid);
		}
		List<Map<String,Object>> qtList = cache.get("exampaper_qtype", eid);
		if(qtList!=null){
			cache.evict("exampaper_qtype", eid);
		}
		systemService.addOnlineSysLog("逐题赋分赋时保存 "+eid+"的试卷");
		return rs+"";
	}
	
	/**
	 * 预览试卷答案
	 * @return
	 */
	@RequestMapping("/seePaperOnlyAnswer")
	public @ResponseBody Map<String, Object> seePaperOnlyAnswer() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:view");
			if(verifyService.checkPaperPermission(map)==0){
				return null;
			}
		}
		List<Map<String, Object>> list = paperService.getPaper(eid);
		List<Map<String, Object>> questiontype = paperService.getPaperQuestiontypeScore(eid);
		Map<String, Map<String, Object>> questionTypeMap = new HashMap<>();
		for(Map<String, Object> qt:questiontype){
			questionTypeMap.put((String) qt.get("QTID"), qt);
		}
		for(int i=0;i<list.size();i++) {
			Map<String, Object> res = list.get(i);
			int ismain = Utils.changeObjToInt(res.get("ismain"));
			if(ismain==0){
				String qtid = String.valueOf(res.get("qtype"));
				BigDecimal nowQuestionscore = (BigDecimal) res.get("score");
				Map<String, Object> questionQt = questionTypeMap.get(qtid);
				BigDecimal curMax = (BigDecimal) questionQt.get("thisQtQuestionMaxScore");
				BigDecimal curMin = (BigDecimal) questionQt.get("thisQtQuestionMinScore");
				BigDecimal newMax = (curMax == null) ? nowQuestionscore : curMax.max(nowQuestionscore);
				BigDecimal newMin = (curMin == null) ? nowQuestionscore : curMin.min(nowQuestionscore);
				questionQt.put("thisQtQuestionMaxScore", newMax);
				questionQt.put("thisQtQuestionMinScore", newMin);
			}
		}
		for (Map<String, Object> qt : questiontype) {
			BigDecimal min = (BigDecimal) qt.get("thisQtQuestionMinScore");
			BigDecimal max = (BigDecimal) qt.get("thisQtQuestionMaxScore");
			String info;
			if (min != null && max != null) {
				if (min.compareTo(max) == 0) {
					info = "每题" + min.stripTrailingZeros().toPlainString() + "分";
				} else {
					info = "每题" + min.stripTrailingZeros().toPlainString() + "-" + max.stripTrailingZeros().toPlainString() + "分";
				}
			} else {
				info = "未统计";
			}
			qt.put("qtScoreInfo", info);
		}

		Map map = new HashMap<String,Object>();
		map.put("res", list);
		map.put("questiontype", questiontype);
		return map;
	}
	
	
	/**
	 * 进入多课程组卷
	 * @author 洪艳
	 */
	@RequestMapping("/inMultiPaper")
	public String inMultiPaper() {
		if("1".equals(getApplication().getAttribute("paperdate_switch"))){
			if(!getSubject().hasRole("administrator")){
				User u = getUserInfo();
				int isMobile = 0;
				List<Map<String, Object>> res = paperService.getTeacherMarkPaper(u.getId(),isMobile);
				if(res!=null && res.size()>0) {
					for(Map<String, Object> s: res){
						String endDate = (String) s.get("ENDDATE");
						if(DateFormatUtils.isEndDateExceedsMonths(endDate) >2) {
							getRequest().setAttribute("isMobile", isMobile);
							return "jsp/unablePaper";
						}
					}
				}
			}
		}
		return "jsp/paper/inMultiPaper";
	}
	
	/**
	 * 多课程组卷,取消组卷
	 * @author yoyo
	 * @return
	 */
	@RequestMapping("/cancelMultiPaper")
	public String cancelMultiPaper(){
//		String eid = getPara("eid");
//		paperService.deleteExampaper(eid);
		return "jsp/paper/inMultiPaper";
	}
	
	/**
	 * 多课程组卷，进入编辑考务信息
	 * @author yoyo
	 * @return
	 */
	@RequestMapping("/editMultiCourseExamInfo")
	public String editMultiCourseExamInfo() {
		String[] cids = getPara("cids").split(",");
		getRequest().setAttribute("c_id", getPara("cids"));
		getRequest().setAttribute("examInfo", paperService.getDefaultExamInfo("1"));
		StringBuffer c_names = new StringBuffer();
		StringBuffer contacts = new StringBuffer();
		StringBuffer codes = new StringBuffer();
		List<Map<String, Object>> examTypeList = new ArrayList<Map<String, Object>>();
		for(String cid:cids){
			if(!getSubject().hasRole("administrator")){
				Map map = new HashMap();
				map.put("uid", getUserID());
				map.put("cid", cid);
				map.put("permission", "paper:add");
				if(courseService.checkCoursePermission(map,getUserID()+"_"+cid)==0){
					return "jsp/notTheRole";
				}
			}
			
			Map<String, Object> map = courseService.getCourseAttr(cid).get(0);
			c_names.append(map.get("name_c")+",");
			if(map.get("contact")!=null){
				contacts.append(map.get("contact")+",");
			}			
			if(map.get("code")!=null){
				codes.append(map.get("code")+",");
			}			
			List<Map<String, Object>> ls = (List<Map<String, Object>>) map.get("examTypeList");
			for(Map<String, Object> m:ls){
				boolean b = true;
				for(Map<String, Object> mm:examTypeList){
					if(((String)mm.get("ETID")).equals(m.get("ETID"))){
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
		//getRequest().setAttribute("courseInfo", map);
		getRequest().setAttribute("c_name", c_names.deleteCharAt(c_names.length() - 1));
		getRequest().setAttribute("ename", c_names);
		getRequest().setAttribute("examTypeList", examTypeList);
		if(codes.length()>0){
			getRequest().setAttribute("code", codes.deleteCharAt(codes.length() - 1));
		}		
		//getRequest().setAttribute("period", "0");
		if(contacts.length()>0){
			getRequest().setAttribute("contact", contacts.deleteCharAt(contacts.length() - 1));
		}
		
		getRequest().setAttribute("way", getPara("way"));
		getRequest().setAttribute("user", getUserInfo());
		
		String organizationinfo_en="";
		try {
			organizationinfo_en=(String)((Map<String, Object>)getApplication().getAttribute("organizationinfo_en")).get("PARAM");
		}catch(Exception e) {}
		
		if("gmu".equals(organizationinfo_en)) {
			getRequest().setAttribute("jwc_kcdm", paperService.getJWC_KCDM());
			return "jsp/paper/examInfo-gmu";
		}else {
			return "jsp/paper/examInfo";
		}
	}
	
	/**
	 * 多课程组卷--添加考务信息
	 * @param ra
	 * @return
	 * @throws ParseException
	 */
	@RequestMapping("/addExamInfo4MultiCourse")
	public String addExamInfo4MultiCourse(RedirectAttributes ra) throws ParseException {
		Map param = new HashMap();
		String cid = getPara("c_id");
		String[] cids = cid.split(",");
		User u = getUserInfo();
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("permission", "paper:add");
			for(String cc:cids) {
				map.put("cid", cc);
				if(courseService.checkCoursePermission(map,getUserID()+"_"+cid)==0){
					return "jsp/notTheRole";
				}
			}			
		}
		param.put("teacherid", u.getId()); //教师id
		param.put("cid", cid);		//课程id
		param.put("cname", getPara("c_name")); //课程名
		param.put("code", getPara("code"));	//课程代码
		param.put("period", getPara("period"));	//学时
		param.put("ename", getPara("ename"));	//试卷名称
		//param.put("num",  Utils.get32PrimaryKey()); //试卷编号
		param.put("schoolYear", getPara("schoolYear")); //考试学年
		param.put("term", getPara("term"));	//考试学期
		param.put("type", getPara("examType"));	//考试类型
		param.put("testway", getPara("examWay")); //开闭卷
		param.put("total", getPara("total"));	//考试应到人数
		param.put("printcount", getPara("pcount"));	//打印份数
		param.put("proportion", getPara("percent"));	//成绩比例
		if(StringUtils.isEmpty(getPara("bt"))){
			ra.addAttribute("c_id", cid);
			return "redirect:/paper/editExamInfo";
		}
		if(StringUtils.isEmpty(getPara("et"))){
			ra.addAttribute("c_id", cid);
			return "redirect:/paper/editExamInfo";
		}
		param.put("begindate", Utils.getDateFromStr(getPara("bt"),"yyyy-MM-dd HH:mm")); //开始时间
		param.put("enddate", Utils.getDateFromStr(getPara("et"),"yyyy-MM-dd HH:mm")); //结束时间
		param.put("time", getPara("time"));		//考试用时
		param.put("missionnum", getPara("missionnum"));		//通用号	
		param.put("lockBefore", getPara("loginBefore"));	//开考前多少分钟禁止登录
		param.put("lockAfter", getPara("loginAfter"));	//开考后多少分钟后禁止登录
		param.put("scheckway", getPara("queryScore"));	//成绩开放给学生查看
		param.put("getanswer", getPara("queryPaper"));	//考试答案开放给学生查看
		param.put("testtimeset", getPara("testMode"));	//考试方式
		param.put("tasknum_switch", "0"); //是否启用任务号
		param.put("switch_out_limit", getPara("switchOutLimitSelect")); //切屏限制
		param.put("randomanswer", getPara("randomAnswer"));
		param.put("answerSequence", getPara("answerSequence"));	//答题顺序
		param.put("correctway", getPara("correctPaper"));	//改卷方式
		param.put("remark2s", getPara("remark2s"));	//考试时给学生看的备注
		param.put("e_remark2s", getPara("e_remark2s"));	//考试时给学生看的备注
		param.put("remark2t", getPara("remark2t"));	//教师添加的考试备注

		int Sys_forbidDay = Utils.changeObjToInt(getApplication().getAttribute("question_used_day"));//获取系统设置好的限制次数（parseint）
		int forbidDay = Math.min(Utils.changeObjToInt(getPara("forbidDay"), Sys_forbidDay),
				Sys_forbidDay == 0 ? Integer.MAX_VALUE : Sys_forbidDay);

		int Sys_forbidNum = Utils.changeObjToInt(getApplication().getAttribute("question_use_time"));//获取系统设置好的限制次数（parseint）
		int forbidNum = Math.min(Utils.changeObjToInt(getPara("forbidNum"), Sys_forbidNum),
				Sys_forbidNum == 0 ? Integer.MAX_VALUE : Sys_forbidNum);

		int limit4Isreview = Utils.changeObjToInt(getApplication().getAttribute("limit4Isreview"));
		int isVerified = (limit4Isreview == 1)
				? 1 : Utils.changeObjToInt(getPara("isVerified"), limit4Isreview);
		
		param.put("forbidBefore", forbidDay);	//组卷时限定多少天以前出过的试题不再出
		param.put("forbidNum",forbidNum);	//组卷时限定多少次以上出过的试题不再出
		param.put("isVerified", isVerified);	//组卷时限定试题是否通过审核
		param.put("depid", u.getDepID());	//组卷人所在科室id
		param.put("teachername", u.getUsername());	//组卷人用户名
		param.put("tel", getPara("tel"));	//组卷人联系电话
		param.put("sidverify", getPara("sidVer"));	//学号、任务号限定
		param.put("facetime", getPara("facetime"));	//人脸识别次数
		param.put("facefail", getPara("face_fail"));
		if(getPara("facetime")==null || !"2".equals(getPara("sidVer"))){
			param.put("facetime", 0);//人脸识别次数
			param.put("facefail", 0);
		}
		param.put("invigilatorids", getPara("invigilator")); //监考老师id
		param.put("patrolids", getPara("patrolids")); //巡考老师id
		param.put("createTime", new Date());
		String[] arr = getParaValues("testObj");
		if(arr == null || arr.length == 0){	//未选考试对象时，返回考务信息
			ra.addAttribute("c_id", cid);
			return "redirect:/paper/editExamInfo";
		}
		List<Map> list = new ArrayList<Map>();
		for(String a:arr){
			String[] s = a.split(",");
			Map m = new HashMap();
			m.put("grade", s[0]);
			m.put("specialty", s[1]);
			list.add(m);
		}
		param.put("objectList", list);
		param.put("isUnion", getPara("isUnion"));
		param.put("editor_switch",getPara("editorSwitch"));
		param.put("randomSwitch", getPara("randomSwitch"));
		
		String unitID="";
		for(String s:cids){
			String unitID_2=courseService.getCourse_UnitID(s);
			if("".equals(unitID)){
				unitID=unitID_2;
			}else{
				if(unitID.equals(unitID_2)){
					continue;
				}else{
					unitID=u.getUnitID();
					break;
				}
			}
		}
		param.put("unitid", unitID);
		paperService.addExamInfo4MultiCourse(param);
		
		getRequest().setAttribute("ei_id", param.get("id"));
		String[] cnames = getPara("c_name").split(",");
//		String temp = "[";
//		for(String c:cids){
//			temp += c+",";
//		}
//		temp = temp.substring(0, temp.length()-1);
//		temp += "]";
		getRequest().setAttribute("c_id", cid);
		getRequest().setAttribute("c_ids", cids);
		getRequest().setAttribute("cname", cnames);
		//getRequest().setAttribute("c_id", cid);
		Map m = new HashMap();
		m.put("forbidDay",forbidDay);
		m.put("forbidNum",forbidNum);
		m.put("isVerified", isVerified);
		getRequest().setAttribute("forbidDay", forbidDay);
		getRequest().setAttribute("forbidNum", forbidNum);
		getRequest().setAttribute("isVerified", isVerified);
		
		List[] distributionStatistics_array = new ArrayList[cids.length];
		List[] themeList_array = new ArrayList[cids.length];
		List[] difficultyDistributions = new ArrayList[cids.length];
		List<Map<String,Object>>[] questionTypeList_array = new ArrayList[cids.length];
		for(int i=0;i<cids.length;i++){
			m.put("id", cids[i]);
			distributionStatistics_array[i] = questionService.getDistributionStatistics(m);
			
			themeList_array[i] =  questionService.getQuestionFilterByTheme1_2(m);
			questionTypeList_array[i] = questionService.getAllQT4CourseQuestion2(m);
			difficultyDistributions[i] = questionService.getDifficultyDistribution2(m);
		}	
		
		getRequest().setAttribute("distributionStatistics", distributionStatistics_array); //根据主题词，题型获取试题分布统计
		getRequest().setAttribute("themeList", themeList_array);
		getRequest().setAttribute("questionTypeList", questionTypeList_array);
		getRequest().setAttribute("difficultyDistributions", difficultyDistributions);
		
		Map log = new HashMap();
		log.put("content", "通过了“多课程组卷”创建了试卷《"+getPara("ename")+"》,试卷编号为"+param.get("id"));
		log.put("cid", cid);
		systemService.addSysLog(log);
		
		return "jsp/paper/multiCourseStructure";
	}
	
	/**
	 * 多课程组卷(通过难度分布进行组卷)
	 * @return
	 */
	@RequestMapping("/multiCourseStructure")
	public String multiCourseStructure(){		
		String c_ids = getPara("c_id");
		String ei_id = getPara("ei_id");

		if(getPara("buildWay")!=null&&"1".equals(getPara("buildWay"))){
			paperService.rebuildA(ei_id);//重新组A卷，删除原A卷信息
		}
		
		Map<String,Object> examinfo = paperService.getExamInfo(ei_id);

		int forbidNum = Utils.changeObjToInt(getPara("forbidNum"), 999999);
		int forbidDay = Utils.changeObjToInt(getPara("forbidDay"), 999999);
		int isVerified = Utils.changeObjToInt(getPara("isVerified"));

		int Sys_forbidDay = Utils.changeObjToInt(examinfo.get("FORBIDBEFORE"));
		int Sys_forbidNum = Utils.changeObjToInt(examinfo.get("FORBIDNUM"));

		if(forbidNum>Sys_forbidNum) {
			forbidNum=Sys_forbidNum;
		}
		if(forbidDay>Sys_forbidDay) {
			forbidDay=Sys_forbidDay;
		}
		
		Map par = new HashMap();
		par.put("eid", ei_id);
		par.put("forbidDay", forbidDay);
		par.put("forbidNum", forbidNum);
		par.put("isVerified", isVerified);		
		paperService.saveExaminfoQuestionFilterParam(par);
		
		String diffcultyNum = getPara("difficultyNum").replaceAll("&quot;", "\"");
		List<Map> k = JSONObject.parseObject(diffcultyNum,List.class);
		
		
		String questionNum = getPara("questionNum").replaceAll("&quot;", "\"");	//结构化组卷填写的参数
		List<Map> n = JSONObject.parseObject(questionNum,List.class);
		
		
		String[] cids = c_ids.split(",");
		List<Map<String,Object>> cList = new ArrayList<>();
		for(String cid:cids){			
			Map<String,Object> m = new HashMap<>();
			m.put("cid", cid);
			Iterator<Map> kit = k.iterator();
			while (kit.hasNext()) {//难度分布 按课程分开
				JSONObject ob = (JSONObject) kit.next();
	            if(cid.equals(ob.getString("cid"))){
	            	double sdiffRatio = 0;
	        		double mdiffRatio = 0;
	        		double ddiffRatio = 0;
	        		int sd = 0;
	        		int md = 0;
	        		int dd = 0;
	            	if(ob.getString("sdiff") != null){
		            	m.put("sdiff", ob.getString("sdiff"));
		            	sd = Integer.valueOf(ob.getString("sdiff"));
		            }
		            if(ob.getString("mdiff") != null){
		            	m.put("mdiff", ob.getString("mdiff"));
		            	md = Integer.valueOf(ob.getString("mdiff"));
		            }
		            if(ob.getString("ddiff") != null){
		            	m.put("ddiff", ob.getString("ddiff"));
		            	dd = Integer.valueOf(ob.getString("ddiff"));
		            }
		            sdiffRatio = (double)sd / (sd + md + dd);
		            m.put("sdiffRatio", sdiffRatio);
		            mdiffRatio = (double)md / (sd + md + dd);
		            m.put("mdiffRatio", mdiffRatio);
		            ddiffRatio = (double)dd / (sd + md + dd);
		            m.put("ddiffRatio", ddiffRatio);
	            }
			}
			
			List qnList = new ArrayList();
			Iterator<Map> nit = n.iterator();
			while (nit.hasNext()) {
	            JSONObject ob = (JSONObject) nit.next();
	            if(cid.equals(ob.getString("cid"))){
	            	qnList.add(ob);
	            }
			}
			m.put("qnList", qnList);
			cList.add(m);
		}
		
		List<Map<String, Object>> questionAll=new ArrayList<Map<String, Object>>();//保存非主题干，用于计算难度分布
		List<Map<String, Object>> mainQuestionAll=new ArrayList<Map<String, Object>>();//保存主题干
		List<Map> mlist=new ArrayList<Map>();
		
		Map param = new HashMap();
		param.put("ei_id", ei_id);
		
		for(Map<String,Object> cm:cList){
			double sdiffRatio = (Double) cm.get("sdiffRatio");
    		double mdiffRatio = (Double) cm.get("mdiffRatio");
    		double ddiffRatio = (Double) cm.get("ddiffRatio");
    		
    		String c_id = (String) cm.get("cid");    		
    		List<List<Map<String, Object>>> nAll=new ArrayList<List<Map<String, Object>>>();//保存非主题干，用于计算难度分布
    		List<List<Map<String, Object>>> mAll=new ArrayList<List<Map<String, Object>>>();//保存主题干
    		
    		List<double[]> diffList = new ArrayList<double[]>();
    		
    		for(int i=0;i<10;i++){    	
    			List<Map<String, Object>> nlist = new ArrayList<Map<String, Object>>();
    			List<Map<String, Object>> mainlist = new ArrayList<Map<String, Object>>();
    			
    			List qn = (List) cm.get("qnList");
        		for(int j=0;j<qn.size();j++){
        			JSONObject ob = (JSONObject) qn.get(j);
        			if(Utils.NotEmpty(ob.getString("qnum"))){
    	                Map m = new HashMap();
    	                m.put("cid", c_id);
    	                m.put("num", ob.getString("qnum"));
    	                m.put("thid", ob.getString("qthid"));
    	                m.put("thid_pid", ob.getString("qthid_parent"));
    	                m.put("qtid", ob.getString("qtid"));
    	                m.put("thlevel", ob.getString("thlevel"));
    	                m.put("eid", ei_id);
    	                if(isVerified==1){
    	                	m.put("isVerified", isVerified);
    	                }
    	                if(forbidDay>0){
    	                	m.put("forbidDay", forbidDay);
    	                }
    	                if(forbidNum>=1){
    	                	m.put("forbidNum", forbidNum);
    	                }
    	            	String iscon = ob.getString("iscon");
    	            	if(iscon.equals("1")){
    	            		List<Map<String, Object>> res = paperService.getMqids(m); //当选中题型为串题时，查看有没有对应该题型和主题词的小题
    	            		if(res!=null && res.size()>0){//能抽出题目
    	            			int branchNum = ((BigDecimal)res.get(0).get("QSUM")).intValue();
        	            		int num = Integer.parseInt((String)m.get("num"));
        	            		if(branchNum<num){
        	            			int next=10;
        	            			while(next>0){
        	            				m.put("mqids", res);
        	                			m.put("extra_num", num-branchNum);
        	                			Map<String,Object> extra = paperService.getMqids_extra(m);
        	                			if(extra==null){
        	                				break;
        	                			}
        	                			res.add(extra);
        	                			branchNum = branchNum+((BigDecimal)extra.get("COUNT")).intValue();
        	                			if(branchNum>=num){
        	                				break;
        	                			}
        	                			next--;
        	            			}            			
        	            		}
    	            		}else{//抽不出题目
    	            			Map<String,Object> _null = paperService.getMqids_null(m);
    	            			if(_null!=null){
    	            				res.add(_null);
    	            			}
    	            		}
    	            		if(res!=null && res.size()>0){
    	            			for(Map<String, Object> s: res){
        	            			s.put("cid", c_id);
        	            			s.put("ei_id", ei_id);
        	            			mainlist.add(s);  
        	            		}
        	            		
        	            		List<Map<String,Object>> branch = paperService.getBrachByMqid(res);
        	            		for(Map<String, Object> s:branch){
        	            			s.put("EID", ei_id);
        	            			nlist.add(s); 
        	            		}
    	            		}
    	            		
    	            	}else{
    	            		List<Map<String, Object>> qList =  paperService.getRandomQuestion(m);
    	            		for(Map<String, Object> s: qList){
    	            			s.put("EID", ei_id);
    	            			nlist.add(s);  //非串题
    	            		}
    	            	}
    		            if(i==0){
    		            	mlist.add(m);
    		            }
    	            }
        		}
        		int stemp = 0;
        		int mtemp = 0;
        		int dtemp = 0;
        		double diff_array[] = new double[3]; 
        		for(Map<String,Object> bm:nlist){
        			int diff = ((BigDecimal)bm.get("DIFFICULTYID")).intValue();
    				if(diff==1){
    					stemp ++;
    				}
    				if(diff==2){
    					mtemp++;
    				}
    				if(diff==3){
    					dtemp++;
    				}
    			}
        		diff_array[0] = (double)stemp/(stemp+mtemp+dtemp);
        		diff_array[1] = (double)mtemp/(stemp+mtemp+dtemp);
        		diff_array[1] = (double)dtemp/(stemp+mtemp+dtemp);
    			nAll.add(nlist);
    			mAll.add(mainlist);		
    			diffList.add(diff_array);
    		}
    		double gab[] = new double[10];
    		for(int i=0;i<diffList.size();i++){
    			double[] diff = diffList.get(i);
    			double sum = 0;
    			sum += Math.abs(diff[0]-sdiffRatio);
    			sum += Math.abs(diff[1]-mdiffRatio);
    			sum += Math.abs(diff[2]-ddiffRatio);
    			gab[i]=sum;			
    		}
    		
    		int min_index = 0;
    		double min = gab[0];
    		for(int i=1;i<gab.length;i++){
    			if(gab[i]<min){
    				min = gab[i];
    				min_index = i;
    			}
    		}
    		
    		for(Map<String,Object> mm:nAll.get(min_index)){
    			questionAll.add(mm);
    		}
    		for(Map<String,Object> mm:mAll.get(min_index)){
    			mainQuestionAll.add(mm);
    		}
		}
		
		param.put("question", questionAll);
		param.put("mainQuestion", mainQuestionAll);
		param.put("mquestion", mlist);
		
		if(mlist.size() > 0){
			paperService.structurePaper(param);	//添加试卷试题（有点难，请耐心看）
		}
		//更新题型分数
		String qtscore = getPara("qtscore").replaceAll("&quot;", "\"");	//结构化组卷填写的参数
		List<Map> s = JSONObject.parseObject(qtscore,List.class);

		Iterator<Map> sit = s.iterator();
		Map sm = new HashMap();
		while (sit.hasNext()) {
            JSONObject ob = (JSONObject) sit.next();
            sm.put(ob.getString("qtid"), ob.getString("qtscore"));            
        }
		Iterator it = sm.entrySet().iterator();  
		while (it.hasNext()) {  
			Map.Entry entry = (Map.Entry) it.next(); 
			Map m = new HashMap();
            m.put("qtid", entry.getKey());
            m.put("qtscore", entry.getValue());
            m.put("qttime", "-1");
            m.put("ei_id", ei_id); 
            paperService.updatePaperQuestionType(m);
		}

		List<Map<String,Object>> exampaperQuestionTypeList=paperService.getExampaperQuestionTypeList(ei_id);
		//调整题型显示，选择题（A1，A2,B1，X），填空，名解，简答，问答，案例
		List<Map<String, Object>> qt_sys=commonService.defaultQuestionType();
		List<Map<String, Object>> qt_xzt=new ArrayList<Map<String, Object>>();
		for(int i=0;i<qt_sys.size();i++){
			Map<String, Object> qts=qt_sys.get(i);
			int atid=Integer.parseInt(String.valueOf(qts.get("ANSWERTYPEID")));
			if(atid==0||atid==1||atid==2||atid==3||atid==8||atid==9){
				qt_xzt.add(qts);
				qt_sys.remove(qts);
				i--;
			}
		}
		List<Map<String, Object>> qtList=new ArrayList<Map<String, Object>>();
		for(Map<String, Object> qts:qt_xzt){
			//String qtstr=qts.get("ID")+"_"+qts.get("ANSWERTYPEID")+"_"+qts.get("ISCON");
			String qtname=((String)qts.get("NAME")).trim();
			for(int i=0;i<exampaperQuestionTypeList.size();i++){
				Map<String, Object> qt=exampaperQuestionTypeList.get(i);
				if(qtname.equals(((String)qt.get("QTNAME")).trim())){
					qtList.add(qt);
					exampaperQuestionTypeList.remove(qt);
					break;
				}
			}
		}
		for(int i=0;i<exampaperQuestionTypeList.size();i++){
			Map<String, Object> qt=exampaperQuestionTypeList.get(i);
			int atid=Integer.parseInt(String.valueOf(qt.get("ATID")));
			if(atid==0||atid==1||atid==2||atid==3||atid==8||atid==9){
				qtList.add(qt);
				exampaperQuestionTypeList.remove(qt);
				i--;
			}
		}
		for(Map<String, Object> qts:qt_sys){
			//String qtstr=qts.get("ID")+"_"+qts.get("ANSWERTYPEID")+"_"+qts.get("ISCON");
			String qtname=((String)qts.get("NAME")).trim();
			for(int i=0;i<exampaperQuestionTypeList.size();i++){
				Map<String, Object> qt=exampaperQuestionTypeList.get(i);
				if(qtname.equals(((String)qt.get("QTNAME")).trim())){
					qtList.add(qt);
					exampaperQuestionTypeList.remove(qt);
					break;
				}
			}
		}
		for(Map<String, Object> qt:exampaperQuestionTypeList){
			qtList.add(qt);
		}
		getRequest().setAttribute("exampaperQuestionTypeList", qtList);
		getRequest().setAttribute("ei_id", ei_id);
		getRequest().setAttribute("c_id", c_ids);
		
		getRequest().setAttribute("c_ids", cids);
		
//		paperService.updatePaperQuestionOrder(ei_id);
        getRequest().setAttribute("mode", 3);//多课程组卷
		return "jsp/paper/adjustPaper";
	}
	
	/**
	 * 进入测试A卷，根据试卷的sidverify来判断是否需要学号验证后登陆
	 * @author yoyo
	 * @param eid
	 * @return
	 */
	/*
	@RequestMapping("/testPaperB")
	public @ResponseBody String testPaperB(@RequestParam(value = "eid") String eid) {
		getSession().setAttribute("adminTest", 1);
		getSession().setAttribute("eid", eid);
		
		Student s = new Student();
		User u = (User)getSession().getAttribute("userInfo");
		s.setId(u.getId());
		s.setName(u.getRealname());
		getSession().setAttribute("student", s);
		
		return "exam/agree";
	}*/
	
	/**
	 * 根据考务id删除试卷的试题
	 * @author yoyo
	 * @param 'eid'
	 * @return
	 */
	@RequestMapping("/adjustPaper_back")
	public @ResponseBody String adjustPaper_back() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(map)==0){
				return "error";
			}
		}
		paperService.adjustPaper_back(eid);
		//更新试卷信息，试卷题数清零
		paperService.updatePaperQuestionNum(eid);
		return "success";
	}
	
	/**
	 * @author Sam
	 * 修改试卷的cid
	 */
	/*
	@RequestMapping("/updateExaminfoCids")
	public @ResponseBody String updateExaminfoCids() {
		Map m = new HashMap();
		m.put("cid", getPara("cid"));
		m.put("eid", getPara("eid"));
		paperService.updateExaminfoCids(m);
		return "1";
	}*/

/**
	 * @author Sam
	 * @return
	 */
	@RequestMapping("/getTitleTotalAndSum")
	public @ResponseBody Map<String, Object> getTitleTotalAndSum(){
		String eid = getPara("ei_id");
		Map m = new HashMap();
		m.put("ei_id", eid);
		Map<String, Object> rs = new HashMap<>();
		rs.put("sum", paperService.getTotalPoints(eid));
		rs.put("total", paperService.getExampaperQuestionCount(m));
		return rs;
	}
	
	
	/**
	 * @author sam
	 * 用于检查试卷是否有未赋分的题目
	 * 
	 */
	@RequestMapping("/getPaperNoScore")
	public @ResponseBody String getPaperNoScore() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:view");
			if(verifyService.checkPaperPermission(map)==0){
				return "无权限";
			}
		}
		String bid = getPara("bid");
		List<Map<String, Object>> rs = paperService.getPaperNoScore(eid);
		if (rs.size()!=0) {
			String qids = "";
			for(int i=0;i<rs.size();i++) {
				qids += rs.get(i).get("TH")+",";
			}
			return "未赋分的试题编号为：第"+qids+"题，请赋分后重试";
		}
		if (!StringUtils.isEmpty(bid)) {
			List<Map<String, Object>> brs = paperService.getPaperNoScore(bid);
			if (brs.size()!=0) {
				String qids = "";
				for(int i=0;i<brs.size();i++) {
					qids += brs.get(i).get("TH")+",";
				}
				return "B卷未赋分的试题编号为：第"+qids+"题，请赋分后重试";
			}
		}
		//检查是否需要选项分离，如果是“选项随机”，必须要进行选项分离
		if(paperService.getRandomanswer(eid)==1) {
			String rtn=paperService.checkOption(eid);
			if(!"no".equals(rtn)) {
				return "检测到有选择题第"+rtn+"题的选项未做题目分离，请通知老师编辑试题后再提交终审！";
			}
		}
		
		return "0";//没有没赋分的题目
	}
	
	// 获取试题详细信息
	@RequestMapping("/previewQuestion")
	public String previewQuestion() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:view");
			if(verifyService.checkPaperPermission(map)==0){
				return "jsp/notTheRole";
			}
		}
		String qid = getPara("qid");
		String mqid = getPara("mqid");		

		Map m = new HashMap();
		m.put("qid", qid);
		m.put("eid", eid);
		
		String cid = paperService.getCidByQid(m);
		m.put("c_id", cid);
		
		String cids = getPara("c_ids");
		Integer isMain = Integer.parseInt(getPara("isMain"));
		Integer iscon = Integer.parseInt(getPara("iscon"));
		String cname = courseService.getCourseCNameByCid(cid);
		
		getRequest().setAttribute("c_ids", cids);
		getRequest().setAttribute("eid", eid);//此处eid用于区分是浏览试卷试题还是浏览课程试题
		getRequest().setAttribute("iscon", iscon);
		getRequest().setAttribute("isMain", isMain);
		getRequest().setAttribute("mqid", mqid);
		getRequest().setAttribute("c_id", cid);
		getRequest().setAttribute("c_name", cname);
		String edit = getPara("edit");
		getRequest().setAttribute("edit", edit);//为空表示可编辑试题		
		
		if(iscon == 0){
			m.put("id", qid);
			Map<String, Object> mainQuestion=paperService.getQuestion_AnswerByQID(m);
			getRequest().setAttribute("xxdf", mainQuestion.get("xxdf"));
			getRequest().setAttribute("mainQuestion", mainQuestion);
			if(Utils.changeObjToInt(mainQuestion.get("atid"))==13){
				getRequest().setAttribute("codeRightAns", mainQuestion.get("answerid"));
			}
			getRequest().setAttribute("atid", mainQuestion.get("atid"));
		}else if(iscon == 1 && isMain == 1){//串题+主题干
			m.put("id", qid);
			Map<String, Object> mainQuestion = paperService.getQuestionPrevew(m);
			getRequest().setAttribute("mqid", qid);
			getRequest().setAttribute("mainQuestion", mainQuestion);
			getRequest().setAttribute("xxdf", mainQuestion.get("xxdf"));
			Map param = new HashMap();
			param.put("eid", eid);
			param.put("mqid", qid);
			getRequest().setAttribute("atid", mainQuestion.get("atid"));
			getRequest().setAttribute("questionList",  paperService.getBranchQuestion_AnswerByQID(param));
		}else if(iscon == 1 && isMain == 0){//串题+非主题干
			m.put("id", mqid);
			getRequest().setAttribute("mqid", mqid);
			
			Map<String, Object> mainQuestion = paperService.getQuestionPrevew(m);
			getRequest().setAttribute("mainQuestion", mainQuestion);
			getRequest().setAttribute("xxdf", mainQuestion.get("xxdf"));
			Map param = new HashMap();
			param.put("eid", eid);
			param.put("mqid", mqid);
			getRequest().setAttribute("atid", mainQuestion.get("atid"));
			getRequest().setAttribute("questionList",  paperService.getBranchQuestion_AnswerByQID(param));			
		}		
		
		String repeat = getPara("repeat");//查看是否从查看重复试题进入，查看重复试题没有上一题与下一题
		if ("1".equals(repeat)) {
			return "jsp/paper/previewRepeatQuestion";
		}else {
			Map mm = new HashMap();
			mm.put("c_id", cid);
			mm.put("e_id", eid);
			mm.put("id", qid);
			getRequest().setAttribute("lastQuestion", paperService.getLastQuestion(mm));
			getRequest().setAttribute("nextQuestion", paperService.getNextQuestion(mm));
			return  "jsp/paper/previewQuestion";
		}
	}
	
	/**
	 * 进入试题更新页面
	 * @author 洪艳
	 * @return
	 */
	@RequestMapping("/editQuestion")
	public String editQuestion() {
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
		String qid = Utils.getNotEmptyVal(getPara("q_id"));
		String mqid = Utils.getNotEmptyVal(getPara("mqid"));
		String isMain = Utils.getNotEmptyVal(getPara("isMain"));
		String iscon = Utils.getNotEmptyVal(getPara("iscon"));
		
		Map m = new HashMap();		
		m.put("eid",eid);
		m.put("qid", qid);
		String cid = paperService.getCidByQid(m);		
		m.put("c_id",cid);
		
		List<Map<String,Object>> cList=courseService.getCourseAttr(cid);
		if(cList!=null&&cList.size()>0){
			getRequest().setAttribute("courseInfo", cList.get(0));
		}else{
			getRequest().setAttribute("courseInfo", Collections.EMPTY_MAP);
		}
		
		getRequest().setAttribute("c_id", cid);
		
		
		if(iscon.equals("1") && isMain.equals("0")){  //串题&非主题干
			m.put("id", mqid);
			getRequest().setAttribute("MainQuestion", paperService.getQuestionInfo(m));
		}	
		getRequest().setAttribute("c_ids", cid);
		getRequest().setAttribute("qid", qid);
		getRequest().setAttribute("mqid", mqid);
		getRequest().setAttribute("iscon", iscon);
		getRequest().setAttribute("isMain", isMain);
		getRequest().setAttribute("eid", eid);//此处eid用于区分是浏览试卷试题还是浏览课程试题
		getRequest().setAttribute("isB", getPara("isB"));//标识是否从B卷进入
		
		Map param = new HashMap();
		param.put("id", getPara("q_id"));
		param.put("c_id", cid);
		param.put("eid", eid);
		param.put("e_id", eid);
		getRequest().setAttribute("question", paperService.getQuestionInfo(param));
		getRequest().setAttribute("lastQuestion", paperService.getLastQuestion(param));
		getRequest().setAttribute("nextQuestion", paperService.getNextQuestion(param));
		
		return "jsp/paper/editQuestion";
	}
	
	/**
	 * 修改试题，使用者：editQuestion.jsp
	 * @author 洪艳
	 * @return
	 */
	@RequestMapping("/updateQuestion")
	public String updateQuestion() {
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
		String qid = getPara("qid");
		String mqid = Utils.getNotEmptyVal(getPara("mqid"));
		Map m1 = new HashMap();
		m1.put("qid", qid);
		m1.put("eid", eid);
		String cid = paperService.getCidByQid(m1);

		Map param = new HashMap();

		param.put("CID", cid);
		param.put("eid", eid);
		param.put("id", qid);
		param.put("qtid", Utils.getNotEmptyVal(getPara("questionType")));
		param.put("sourceid", Utils.getNotEmptyVal(getPara("source")));
		param.put("aid", Utils.getNotEmptyVal(getPara("arrangement")));
		param.put("cognitionid", Utils.getNotEmptyVal(getPara("cognition")));
		param.put("difficultyid", Utils.getNotEmptyVal(getPara("difficulty")));
		param.put("knowledgeid", Utils.getNotEmptyVal(getPara("knowledge")));
		param.put("answertime", Utils.getNotEmptyVal(getPara("answertime")));
		param.put("cognitionid_b", Utils.getNotEmptyVal(getPara("cognition_b")));
		param.put("difficultyid_b", Utils.getNotEmptyVal(getPara("difficulty_b")));
		param.put("knowledgeid_b", Utils.getNotEmptyVal(getPara("knowledge_b")));
		param.put("answertime_b", Utils.getNotEmptyVal(getPara("answertime_b")));
		param.put("theme1id", Utils.getNotEmptyVal(getPara("firstTheme")));
		param.put("theme2id", Utils.getNotEmptyVal(getPara("secondTheme")));
		param.put("theme3id", Utils.getNotEmptyVal(getPara("thirdTheme")));
		String qcontent = ImgUtil.saveEditorFomulaPic(getRequest().getParameter("qcontent"), cid);
		param.put("content", qcontent);
		param.put("updatorid", getUserID());
		param.put("updatetime", new Date());
		param.put("answerexplain", PaperContentUtils.fitForVarchar2_4000Byte(getRequest().getParameter("qexplain")));
		param.put("addtime", new Date()); 
		param.put("answertype", Utils.getNotEmptyVal(getPara("AnswerType")));
		param.put("mqid", mqid);
		param.put("isMain", Utils.getNotEmptyVal(getPara("isMain")));
		param.put("iscon", Utils.getNotEmptyVal(getPara("iscon")));
		param.put("filepath", getPara("filepath"));
		param.put("syncToQuestionBank",getPara("syncToQuestionBank"));
		
		Integer AnswerType = Integer.parseInt((String)param.get("answertype"));
		getRequest().setAttribute("atid", AnswerType);
		Integer isMain = Integer.parseInt(getPara("isMain"));
		Integer iscon = Integer.parseInt(getPara("iscon"));
		int xxdf = Utils.changeObjToInt(getPara("xxdf"));
		
		List<Map<String, Object>> answerList = paperService.getPaperAnswerByQID(param);
		if(isMain == 0){
			double qscore=0;
			if(AnswerType<4|| AnswerType==8 || AnswerType==9){
				String correct = getPara("correct");
				String[] correct_array = correct.split(",");
				String answerid = "";
				List<Map> l1 = new ArrayList<>();
				List<Map<String,Object>> l2= new ArrayList<>();//不存在的答案，insert
				List<Map<String,Object>> l3= new ArrayList<>();//被移除的答案，delete
				int f=0;
				for(int i=0;i<100;i++){
					String aid = "";
					if(getPara("answer"+i)!=null){
						f++;
						if(i<answerList.size()){
							aid = (String) answerList.get(i).get("AID");
							String answer_content = getRequest().getParameter("answer"+i);		
							Map m = new HashMap();
							if(xxdf==1){
								double score=Double.parseDouble(getPara("score"+i));
								m.put("score", score);
								if(AnswerType==0||AnswerType==2){
									if(score>qscore){
										qscore=score;
									}
								}
							}
							for(int j=0;j<correct_array.length;j++){
								if(!"".equals(correct_array[j])){
									if(i==Integer.parseInt(correct_array[j])){
										answerid += aid+",";
										if(xxdf==1&&(AnswerType==1||AnswerType==3)){
											double score=Double.parseDouble(getPara("score"+i));
											qscore+=score;
										}
									}
								}
							}
							m.put("aid", aid);
							m.put("qid", qid);
							m.put("eid", eid);
							m.put("answer_content", ImgUtil.saveEditorFomulaPic(answer_content,cid));
							m.put("answer_content_6", "");
							l1.add(m);
						}else{
							aid = questionService.getAnswerID();
							String answer_content = getRequest().getParameter("answer"+i);		
							Map m = new HashMap();
							if(xxdf==1){
								double score=Double.parseDouble(getPara("score"+i));
								m.put("score", score);
								if(AnswerType==0||AnswerType==2){
									if(score>qscore){
										qscore=score;
									}
								}
							}
							for(int j=0;j<correct_array.length;j++){
								if(!"".equals(correct_array[j])){
									if(i==Integer.parseInt(correct_array[j])){
										answerid += aid+",";
										if(xxdf==1&&(AnswerType==1||AnswerType==3)){
											double score=Double.parseDouble(getPara("score"+i));
											qscore+=score;
										}
									}
								}
							}
							m.put("aid", aid);
							m.put("qid", qid);
							m.put("eid", eid);
							m.put("answer_content", answer_content);
							m.put("answer_content_6", "");
							m.put("id", qid);
							m.put("answertype", AnswerType);
							m.put("index", i);
							l2.add(m);
						}
						
					}else{
						break;
					}
				}
				if(f<answerList.size()){
					for(;f<answerList.size();f++){
						l3.add(answerList.get(f));
					}
				}
				
				if(answerid!=null && !"".equals(answerid)){
					answerid = answerid.substring(0,answerid.length()-1);
				}else{
					answerid = (String)l1.get(l1.size()-1).get("aid");
				}
				param.put("answer", l1);
				param.put("answerid", answerid);
				param.put("answer_add", l2);
				param.put("answer_delete", l3);
				if(xxdf==1){
					param.put("score", qscore);
				}
			}else if(AnswerType==4){
				List l3 = new ArrayList();
				Map m = new HashMap();
				m.put("qid", qid);
				m.put("eid", eid);
				m.put("aid", answerList.get(0).get("AID"));
				m.put("answer_content", getPara("answerCon"));
				m.put("answer_content_6", "");
				l3.add(m);
				param.put("answer", l3);
				param.put("answerid", m.get("aid"));
			}else{
				List l3 = new ArrayList();
				Map m = new HashMap();
				m.put("qid", qid);
				m.put("eid", eid);
				m.put("answer_content", "");
				m.put("answertype", AnswerType);
				if(AnswerType==13){
					m.put("answer_content_6",getRequest().getParameter("codeData"));
				}else{
					String answerCon = getRequest().getParameter("answerCon");
					if(answerCon==null||"".equals(answerCon)){
						answerCon="无标准答案";
					}
					m.put("answer_content_6", ImgUtil.saveEditorFomulaPic(answerCon,cid));
				}
				l3.add(m);
				if(answerList!=null&&answerList.size()>0) {
					m.put("aid", answerList.get(0).get("AID"));
					param.put("answer", l3);
				}else {
					m.put("aid", questionService.getAnswerID());
					param.put("answer_add", l3);
				}
				param.put("answerid", m.get("aid"));
			}
		}
		param.put("isAddIntoCourse",getPara("isAddIntoCourse"));
		paperService.updateQuestion(param);
		paperService.updatePaperQuestionOrder(eid);
		questionService.clearQuestionNum(qid);

		if("1".equals(getPara("isAddIntoCourse"))){
			String qid_new=questionService.getQuestionID();
			Map mm=new HashMap();
			mm.put("eid",eid);
			mm.put("qid",qid);
			mm.put("qid_new",qid_new);
			mm.put("addtime",new Date());
			paperService.addQuestionIntoTK(mm);

			mm.put("id",qid);

			Map<String, String> oldToNewAidMap = new HashMap<>();

			String answerid_old=String.valueOf(param.get("answerid"));
			answerList = paperService.getPaperAnswerByQID(mm);
			int aorder=0;

			for(Map<String,Object> amm:answerList){
				String aContent = amm.get("ACONTENT") == null ? "" : amm.get("ACONTENT").toString();
				String content6 = amm.get("CONTENT_6") == null ? "" : amm.get("CONTENT_6").toString();

				Object scoreObj = amm.get("SCORE");
				Double score = 0.0;
				if (scoreObj != null) {
					try {
						if (scoreObj instanceof Double) {
							score = (Double) scoreObj;
						} else {
							score = Double.parseDouble(scoreObj.toString());
						}
					} catch (NumberFormatException e) {
					}
				}

				String aid_new=questionService.getAnswerID();
				String aid_old = String.valueOf(amm.get("AID"));
				oldToNewAidMap.put(aid_old, aid_new);

				amm.put("aid_new",aid_new);
				amm.put("qid_new",qid_new);
				amm.put("content",aContent);
				amm.put("atid",amm.get("ATID"));
				amm.put("content_6",content6);
				amm.put("aorder",++aorder);
				amm.put("score",score);
				amm.put("aid_old",aid_old);
				amm.put("eid",eid);

				paperService.addAnswerIntoTK(amm);
				paperService.updateAid(amm);
			}

			if (answerid_old != null && !answerid_old.trim().isEmpty()) {
				String[] oldAidArray = answerid_old.split(",\\s*");
				StringJoiner sj = new StringJoiner(",");

				for (String oldAid : oldAidArray) {
					String trimOldAid = oldAid.trim(); 
					String newAid = oldToNewAidMap.getOrDefault(trimOldAid, trimOldAid);
					if (!newAid.isEmpty()) {
						sj.add(newAid);
					}
				}
				mm.put("answerid_new",sj.toString());
			}
			paperService.updateQid(mm);
			mm.put("qtid",String.valueOf(param.get("qtid")));
			paperService.updateQuestion4TK(mm);

			qid=qid_new;
		}
		getRequest().setAttribute("iscon", iscon);
		getRequest().setAttribute("isMain", isMain);
		getRequest().setAttribute("mqid", mqid);

		m1.put("c_id", cid);
		
		String cids = getPara("c_ids");
		String cname = courseService.getCourseCNameByCid(cid);		
		
		getRequest().setAttribute("c_ids", cids);
		getRequest().setAttribute("isB", getPara("isB"));//标识是否从B卷进入
		getRequest().setAttribute("iscon", iscon);
		getRequest().setAttribute("isMain", isMain);
		getRequest().setAttribute("mqid", mqid);
		getRequest().setAttribute("c_id", cid);
		getRequest().setAttribute("c_name", cname);	
		getRequest().setAttribute("eid", eid);
		String edit = getPara("edit");
		getRequest().setAttribute("edit", edit);		
		
		if(iscon == 0){
			m1.put("id", qid);
			Map<String, Object> mainQuestion = paperService.getQuestion_AnswerByQID(m1);
			getRequest().setAttribute("mainQuestion", mainQuestion);
			if(AnswerType==13){
				getRequest().setAttribute("codeRightAns", mainQuestion.get("answerid"));
			}
		}else if(iscon == 1 && isMain == 1){//串题+主题干
			m1.put("id", qid);
			Map<String, Object> mainQuestion = paperService.getQuestionPrevew(m1);
			getRequest().setAttribute("mqid", qid);
			getRequest().setAttribute("mainQuestion", mainQuestion);
			
			m1.put("mqid", qid);
			getRequest().setAttribute("questionList",  paperService.getBranchQuestion_AnswerByQID(m1));
		}else if(iscon == 1 && isMain == 0){//串题+非主题干
			m1.put("id", mqid);
			getRequest().setAttribute("mqid", mqid);
			
			Map<String, Object> mainQuestion = paperService.getQuestionPrevew(m1);
			getRequest().setAttribute("mainQuestion", mainQuestion);
			
			m1.put("mqid", mqid);
			getRequest().setAttribute("questionList",  paperService.getBranchQuestion_AnswerByQID(m1));
		}		
		
		getRequest().setAttribute("xxdf", xxdf);
		String repeat = getPara("repeat");//查看是否从查看重复试题进入，查看重复试题没有上一题与下一题
		if ("1".equals(repeat)) {
			return "jsp/paper/previewRepeatQuestion";
		}else {
			Map mm = new HashMap();
			mm.put("e_id", eid);
			mm.put("id", qid);
			getRequest().setAttribute("lastQuestion", paperService.getLastQuestion(mm));
			getRequest().setAttribute("nextQuestion", paperService.getNextQuestion(mm));
			return  "jsp/paper/previewQuestion";
		}
	}
	
	/**
	 * 查询试卷试题总时间
	 */
	@RequestMapping("/getQuestionTotalTime")
	public @ResponseBody String getQuestionTotalTime() {
		return paperService.getQuestionTotalTime(getPara("eid"));
	}
	
	/**
	 * 已有试卷合并，进入编辑考务信息
	 * @author yoyo
	 * @return
	 */
	@RequestMapping("/editCombinePaperExamInfo")
	public String editCombinePaperExamInfo() {
		String[] eids = getPara("eids").split(",");
		Map param = new HashMap();
		param.put("eids", eids);
		List<Map<String,Object>> cidList = paperService.selectcidsByeids(param);
		StringBuilder c_id = new StringBuilder();
		int rtn = 0;
		for(Map<String,Object> m:cidList){
			if(!getSubject().hasRole("administrator")){
				Map map = new HashMap();
				map.put("uid", getUserID());
				map.put("cid", m.get("CID"));
				map.put("permission", "paper:add");
				rtn += courseService.checkCoursePermission(map,getUserID()+"_"+m.get("CID"));
			}
			c_id.append(m.get("CID")+",");
		}
		if(!getSubject().hasRole("administrator") && rtn==0){
			return "jsp/notTheRole";
		}
		getRequest().setAttribute("c_id", c_id.substring(0,c_id.length()-1));
		getRequest().setAttribute("examInfo", paperService.getDefaultExamInfo("1")); //默认考务信息
		StringBuilder c_names = new StringBuilder();
		StringBuilder contacts = new StringBuilder();
		StringBuilder codes = new StringBuilder();
		List<Map<String, Object>> examTypeList = new ArrayList<Map<String, Object>>();
		for(int i=0;i<cidList.size();i++){			
			String cid = (String) cidList.get(i).get("CID");
			Map<String, Object> map = courseService.getCourseAttr(cid).get(0);
			c_names.append(map.get("name_c")+",");
			if(map.get("contact")!=null){
				contacts.append(map.get("contact")+",");
			}			
			if(map.get("code")!=null){
				codes.append(map.get("code")+",");
			}			
			List<Map<String, Object>> ls = (List<Map<String, Object>>) map.get("examTypeList");
			for(Map<String, Object> m:ls){
				boolean b = true;
				for(Map<String, Object> mm:examTypeList){
					if(mm.get("ETID").equals(m.get("ETID"))){
						b = false;
						break;
					}
				}
				if(b){
					examTypeList.add(m);
				}
			}
		}		
		//getRequest().setAttribute("courseInfo", map);
		getRequest().setAttribute("c_name", c_names.deleteCharAt(c_names.length() - 1));
		getRequest().setAttribute("ename", c_names);
		getRequest().setAttribute("examTypeList", examTypeList);
		if(codes.length()>0){
			getRequest().setAttribute("code", codes.deleteCharAt(codes.length() - 1));
		}		
		//getRequest().setAttribute("period", "0");
		if(contacts.length()>0){
			getRequest().setAttribute("contact", contacts.deleteCharAt(contacts.length() - 1));
		}
		
		getRequest().setAttribute("way", getPara("way"));
		getRequest().setAttribute("user", getUserInfo());
		
		getSession().setAttribute("eids", getPara("eids"));
		
		String organizationinfo_en="";
		try {
			organizationinfo_en=(String)((Map<String, Object>)getApplication().getAttribute("organizationinfo_en")).get("PARAM");
		}catch(Exception e) {}
		
		if("gmu".equals(organizationinfo_en)) {
			getRequest().setAttribute("jwc_kcdm", paperService.getJWC_KCDM());
			return "jsp/paper/examInfo-gmu";
		}else {
			return "jsp/paper/examInfo";
		}
	}
	
	/**
	 * @author Sam
	 * 保存双向细目表模板（单课程）
	 * 传入cid与模板名称
	 */
	@RequestMapping("/saveCheckList")
	public @ResponseBody String saveCheckList() {
		Map m = new HashMap();
		m.put("cid", getPara("cid"));
		m.put("name", getPara("name"));
		m.put("eid", getPara("eid"));
		int a = paperService.getTemplateCount(m);
		if(a != 0) {
			return "-1"; //该课程的模板名称已存在
		}
		List<Map<String,Object>> list=paperService.getCheckList(getPara("eid"));
		int rs =0;
		if(list!=null&&list.size()>0){
			for(Map<String,Object> map:list){
				m.put("qtid", map.get("QTID"));
				m.put("thid", map.get("THID"));
				m.put("thlevel", map.get("THLEVEL"));
				m.put("num", map.get("NUM"));
				m.put("iscon", map.get("ISCON"));
				rs+=paperService.saveCheckList(m);
			}
		}else{
			m.put("ei_id", getPara("eid"));
			paperService.addExampaperQuestionParam(m);
			rs=paperService.saveCheckList_nonexist(m);
		}
		return rs+"";
	}
	
	/**
	 * @author Sam
	 * 通过cid获取双向细目表模板
	 * cid
	 */
	@RequestMapping("/getTemplateByCid")
	public @ResponseBody List<String> getTemplateByCid(){
		return paperService.getTemplateByCid(getPara("cid"));
	}
	
	/**
	 * @author Sam
	 * 通过模板名获取相应模板参数
	 * cid,name
	 */
	@RequestMapping("/getTemplateDetail")
	public @ResponseBody List<Map<String, Object>> getTemplateDetail(){
		Map param = new HashMap();
		param.put("cid", getPara("cid"));
		param.put("name", getPara("name"));
		return paperService.getTemplateDetail(param);
	}

	/**
	 *删除双向细目表
	 */
	@RequestMapping("/deleteTemplateDetail")
	public @ResponseBody Integer deleteTemplateDetail(){
		String name = getPara("name");//双向细目表名称
		//删除由于重新组卷所保存的双向细目表模板，模板name
		return paperService.deleteTemplateByName(name);
	}
	
	/**
	 * 添加问卷调查
	 * @author 洪艳
	 * @return
	 */
	@RequestMapping("/addWj")
	public String addWj() {
		getRequest().setAttribute("c_id", getPara("c_id"));
		getRequest().setAttribute("ei_id", getPara("ei_id"));
		
		List<Map<String, Object>> rs = courseService.getCourseAttr(wj_cid);
		List<Map<String, Object>> courseList = new ArrayList<>();
		Map<String, Object> course = new HashMap<>();
		course.put("cname", rs.get(0).get("name_c"));
		course.put("cid", rs.get(0).get("id"));
		courseList.add(course);
		getRequest().setAttribute("courseInfo", rs);
		getRequest().setAttribute("courseList", courseList);
		
		return "jsp/paper/addWj";
	}
	
	/**
	 * 获取问卷调查的题目
	 * @return
	 */
	@RequestMapping("/getWjQuestionList")
	public @ResponseBody Map<String, Object> getWjQuestionList() {
		String eid = getPara("ei_id");
		
		Map m = new HashMap();
		m.put("eid", eid);
		m.put("cid", wj_cid);
		
		m.put("th1id", getPara("th1id"));
		m.put("th2id", getPara("th2id"));
		m.put("th3id", getPara("th3id"));
		m.put("qtid", getPara("qtid"));
		m.put("coid", getPara("coid"));
		m.put("did", getPara("did"));
		m.put("kid", getPara("kid"));
		m.put("isVerified", getPara("isVerified"));
		PageUtils pu = getPageUtil();
		return getRes(paperService.getWjQuestion(m, pu), paperService.getWjQuestionCount(m));
	}
	
	
	
	/**
	 * 试卷查找重复试题
	 * @author 洪艳
	 * @return
	 */
	@RequestMapping("/toFindRepeatQuestions")
	public String toFindRepeatQuestions() {
		String eid = getPara("eid");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:view");
			if(verifyService.checkPaperPermission(map)==0){
				return "jsp/notTheRole";
			}
		}
		Map<String, Object> examInfo = paperService.getExamInfo(eid);//获取考务信息
		getRequest().setAttribute("examInfo", examInfo);
		
		List<Map<String,Object>> examobject=paperService.getExamObject(eid);//获取考试对象
		if(examobject!=null&&examobject.size()>0){
			Set<String> grade=new HashSet<>();
			Set<String> specialty=new HashSet<>();
			for(Map<String,Object> m:examobject){
				grade.add((String)m.get("GNAME"));
				specialty.add((String)m.get("SNAME"));
			}
			String sb=new String();
			for(String s:grade){
				sb=sb+s.substring(0,s.length()-1)+",";
			}
			sb=sb.substring(0,sb.length()-1)+"级";
			for(String s:specialty){
				sb=sb+s+",";
			}
			sb=sb.substring(0,sb.length()-1)+"专业";
			getRequest().setAttribute("examObject", sb);
		}
		
		getRequest().setAttribute("eid", eid);
		
		getRequest().setAttribute("bid", examInfo.get("BID"));
		getRequest().setAttribute("aorb", examInfo.get("AORB"));
		getRequest().setAttribute("ename", examInfo.get("ENAME"));
		getRequest().setAttribute("themeList", paperService.selectThemeFromPaper(eid));
		getRequest().setAttribute("questionTypeList", paperService.selectQuestionTypeFromPaper(eid));
		getRequest().setAttribute("cognitionList", paperService.selectCognitionFromPaper(eid));
		getRequest().setAttribute("difficultyList", paperService.selectDifficultyFromPaper(eid));
		getRequest().setAttribute("knowledgeList", paperService.selectKnowledgeFromPaper(eid));
		
		return "jsp/paper/repeatQuestionList";
	}
	
	//查询重复试题
	@RequestMapping("/findRepeatQuestions")
	public @ResponseBody Map<String, Object> findRepeatQuestions(){
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", getPara("eid"));
			map.put("permission", "paper:view");
			if(verifyService.checkPaperPermission(map)==0){
				return null;
			}
		}
		Map m = new HashMap();
		m.put("eid", getPara("eid"));
		m.put("th1id", getPara("th1id"));
		m.put("th2id", getPara("th2id"));
		m.put("th3id", getPara("th3id"));
		m.put("qtid", getPara("qtid"));
		m.put("coid", getPara("coid"));
		m.put("did", getPara("did"));
		m.put("kid", getPara("kid"));
		m.put("isVerified", getPara("isVerified"));
		m.put("question", getPara("question"));
		m.put("teacher", getPara("teacher"));

		List<Map<String,Object>> rtn;
		if("1".equals(getPara("sameType"))){//1代表要不仅题目相同，答案也相同的list
			List<Map<String,Object>> repeatQuestionList;
			if(getSession().getAttribute("repeatQuestionList")!=null){
				repeatQuestionList = (List<Map<String,Object>>) getSession().getAttribute("repeatQuestionList");
			}else{
				repeatQuestionList = paperService.findRepeatQuestions(m);
			}
			rtn = paperService.findRepeatQuestionsWithAnswer(repeatQuestionList);
			getSession().removeAttribute("repeatQuestionList");
		}else{
			rtn = paperService.findRepeatQuestions(m);
			getSession().setAttribute("repeatQuestionList",rtn);
		}
		return getRes(rtn, rtn.size());
	}
	
	// 获取试卷试题主题词列表
	@RequestMapping("/getPaperThemeList")
	public @ResponseBody List<Map<String, Object>> getPaperThemeList() {
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", getPara("eid"));
			map.put("permission", "paper:view");
			if(verifyService.checkPaperPermission(map)==0){
				return null;
			}
		}
		Map param = new HashMap();
		param.put("th_level", getPara("th_level"));
		param.put("th_pid", getPara("th_pid"));
		param.put("eid", getPara("eid"));
		if("2".equals(getPara("th_level"))){
			return paperService.getPaperTheme2List(param);
		}else if("3".equals(getPara("th_level"))){
			return paperService.getPaperTheme3List(param);
		}
		return new ArrayList();
	}
	
//	@RequestMapping("/batchUpdateQorder")
//	public void batchUpdateQorder(){
//		List<Map<String, Object>> examList = paperService.getAllExamPaper();
//		int i=1;
//		for(Map<String,Object> map:examList){
//			paperService.batchUpdateQorder(String.valueOf(map.get("EID")));
//			i++;
//		}
//	}
	
	@RequestMapping("/getPaperFilter")
	public @ResponseBody Map<String, Object> getPaperFilter(){
		String[] eids = getPara("eid").split(",");
		if(!getSubject().hasRole("administrator")){
			for(String eid:eids) {
				Map map = new HashMap();
				map.put("uid", getUserID());
				map.put("eid", eid);
				map.put("permission", "paper:view");
				if(verifyService.checkPaperPermission(map)==0){
					return null;
				}
			}
		}
		Map m = new HashMap();
		m.put("eid", eids);
		if(!StringUtils.isEmpty(getPara("cid"))) {
			m.put("cid", getPara("cid"));
		}
		return paperService.getPaperFilter(m);
	}
	
	@RequestMapping("/getThemeList")
	public @ResponseBody List<Map<String, Object>> getThemeList(){
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", getPara("eid"));
			map.put("permission", "paper:view");
			if(verifyService.checkPaperPermission(map)==0){
				return null;
			}
		}
		Map m = new HashMap();
		m.put("eid", getPara("eid"));
		int tlevel= Utils.changeObjToInt(getPara("th_level"), 1);
		m.put("level", tlevel);
		if(tlevel==2 || tlevel==3){
			m.put("th_pid", getPara("th_pid"));
		}else{
			m.put("level", 1); //防止传了个错值进来全表查询，因为sql只枚举了1、2、3
			m.put("cid", getPara("cid"));
		}
		return paperService.selectThemeFromPaper_course(m);
	}

	@RequestMapping("/adjustQuestionOrder")
	public String adjustQuestionOrder() {
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

		String mode = getPara("mode");
		if(mode == null || "".equals(mode)){
			mode = "question";
		}

		Map param = new HashMap();
		param.put("eid", ei_id);
		param.put("mqid", getPara("mqid"));
		param.put("mode", mode);

		List<Map<String,Object>> list = paperService.getQuestion4adjustOrder(param);

		getRequest().setAttribute("exampaperQuestionList", list);
		getRequest().setAttribute("ei_id", ei_id);
		getRequest().setAttribute("c_id", getPara("c_id"));
		getRequest().setAttribute("mqid", getPara("mqid"));
		getRequest().setAttribute("mode", mode);

		return "jsp/paper/adjustQuestionOrder";
	}

	@RequestMapping("/movePaperQuestionOrder")
	public @ResponseBody String movePaperQuestionOrder() {
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", getPara("ei_id"));
			map.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(map)==0){
				return "error";
			}
		}

		String mode = getPara("mode");
		if(mode == null || "".equals(mode)){
			mode = "question";
		}

		Map param = new HashMap();
		param.put("eid", getPara("ei_id"));
		param.put("qid", getPara("qid"));
		param.put("ismain", getPara("ismain"));
		param.put("mqid", getPara("mqid"));
		param.put("mode", mode);
		param.put("direction", getPara("direction"));

		return paperService.movePaperQuestionOrder(param);
	}
	
	//获取年级列表
	@RequestMapping("/getGrade4ExamInfo")
	public @ResponseBody List<Map<String, Object>> getGrade4ExamInfo(){
		return paperService.getGrade4ExamInfo();
	}
	
	/*
	 * //获取学院列表
	 * 
	 * @RequestMapping("/getUnit4ExamInfo") public @ResponseBody List<Map<String,
	 * Object>> getUnit4ExamInfo(){ return paperService.getUnit4ExamInfo(); }
	 */
	
	@RequestMapping("/getThemeCountByCidAndDid")
	public @ResponseBody List<Map<String, Object>> getThemeCountByCidAndDid(){
		Map param = new HashMap();
		param.put("cid", getPara("cid"));
		param.put("did", getPara("did"));
		param.put("forbidDay", getPara("forbidDay"));
		param.put("forbidNum", getPara("forbidNum"));
		param.put("pid",getPara("pid"));
		param.put("tlevel",getPara("tlevel"));
		return paperService.getThemeCountByCidAndDid(param);
	}
	
	/**
	 * 按难度组卷=>赋分
	 * @return
	 */
	@RequestMapping("/diffStructure")
	public String diffStructure() {
		int Sys_forbidDay = Utils.changeObjToInt(getApplication().getAttribute("question_used_day"));//获取系统设置好的限制次数（parseint）
		int forbidDay = Math.min(Utils.changeObjToInt(getPara("forbidDay"), Sys_forbidDay),
				Sys_forbidDay == 0 ? Integer.MAX_VALUE : Sys_forbidDay);

		int Sys_forbidNum = Utils.changeObjToInt(getApplication().getAttribute("question_use_time"));//获取系统设置好的限制次数（parseint）
		int forbidNum = Math.min(Utils.changeObjToInt(getPara("forbidNum"), Sys_forbidNum),
				Sys_forbidNum == 0 ? Integer.MAX_VALUE : Sys_forbidNum);

		int limit4Isreview = Utils.changeObjToInt(getApplication().getAttribute("limit4Isreview"));
		int isVerified = (limit4Isreview == 1)
				? 1 : Utils.changeObjToInt(getPara("isVerified"), limit4Isreview);
				      
		String cid = getPara("c_id");
		String eid = getPara("ei_id");
		String qNum = getPara("questionNum").replaceAll("&quot;", "\"");
		Map qids = new HashMap();
		LinkedHashSet qtids = new LinkedHashSet();
		List<Map> n = JSONObject.parseObject(qNum,List.class);
		Iterator<Map> it = n.iterator();
		while(it.hasNext()) {
			Map m = new HashMap();
			JSONObject ob = (JSONObject) it.next();
			m.put("forbidDay", forbidDay);
			m.put("forbidNum", forbidNum);
			m.put("isVerified", isVerified);
			m.put("cid", cid);
			m.put("qtid", ob.getString("qtid"));
			if(ob.get("did")!=null) {
				m.put("did", ob.getString("did"));
			}
			if(ob.get("thid")!=null) { 
				m.put("thid", ob.getString("thid"));
				if(ob.get("tlevel")!=null) {
					m.put("tlevel", ob.getString("tlevel"));
				}
			}
			m.put("num", ob.getString("count"));
			int iscon = commonService.getQtIsconByQtid(m);
			if(iscon == 0) {
				List<Map<String, Object>> qlist = paperService.getDifficultQids(m);
				for(Map<String, Object> qq:qlist) {
					Map<String, Object> qt = new HashMap<>();
					String qtid = (String) qq.get("QTID");
					qt.put("qtid", qtid);
					qt.put("qtid_q", qq.get("QTID_Q"));
					qt.put("atid", qq.get("ATID"));
					qt.put("iscon", qq.get("QTISCON"));
					qtids.add(qt);
					List<String> ql;
					if(qids.get(qtid)!=null) {
						ql = (List<String>) qids.get(qtid);
					}else {
						ql = new ArrayList<>();
					}
					ql.add((String) qq.get("QID"));
					qids.put(qtid, ql);
				}
			}else {
				//随机获取题干下有多少子题
				List<String> mqlist = new ArrayList<>();
				List<Map<String, Object>> mqCount = paperService.getmQuestionCount_diff(m);
				int num = Integer.parseInt(ob.getString("count"));
				if(mqCount.size() > 0) {
					for(int i=0;i<mqCount.size();i++) {
						Map mm = mqCount.get(i);
						int count = Integer.parseInt(mm.get("NUM").toString());
						String mqid = mm.get("MQID").toString().trim();
						if(num - count >= 0) {
							mqlist.add(mqid);
							num = num - count;
						}
						if((i+1)==mqCount.size()) {
							if(num > 0) {
								mqlist.add(mqid);
							}
						}
					}
				}
				Map param = new HashMap();
				param.put("cid", cid);
				param.put("mainqids", mqlist);
				
				//获取子题
				List<Map<String, Object>> mqids = paperService.getMqids4DiffStructure(param);
				for(Map<String, Object> mq:mqids) {
					Map<String, Object> qt = new HashMap<String, Object>();
					String qtid = (String) mq.get("QTID");
					qt.put("qtid", qtid);
					qt.put("qtid_q", mq.get("QTID_Q"));
					qt.put("atid", mq.get("ATID"));
					qt.put("iscon", mq.get("QTISCON"));
					qtids.add(qt);
					List<String> ql;
					if(qids.get(qtid)!=null) {
						ql = (List<String>) qids.get(qtid);
					}else {
						ql = new ArrayList<>();
					}
					ql.add((String) mq.get("QID"));
					qids.put(qtid, ql);
				}
			}
			
		}
		
		Map param = new HashMap();
		param.put("cid", cid);
		param.put("qtids", new ArrayList(qtids));
		List<Map<String, Object>> qtList = paperService.getQuestionTypeParamByQtids(param);
		for(Map m:qtList) {		
			String qtid = m.get("QTID").toString();	
			List<String> ls = (List<String>) qids.get(qtid);
			int xxdf = Utils.changeObjToInt(m.get("XXDF"));
			if(xxdf==1){
				//获取题型的总得分
				Map eqtm=new HashMap();
				eqtm.put("qtid", m.get("QTID"));
				eqtm.put("cid", cid);
				eqtm.put("qids", ls);
				Map<String,Object> eqt_score=paperService.getZF_qids(eqtm);
				m.put("SCORE", eqt_score.get("SCORE"));
			}
			m.put("count", ls.size());
			m.put("qids", ls);
		}
		getRequest().setAttribute("qtList", qtList);
		getRequest().setAttribute("eid", eid);
		getRequest().setAttribute("cid", cid);
		getRequest().setAttribute("forbidDay", forbidDay);
		getRequest().setAttribute("forbidNum", forbidNum);
		getRequest().setAttribute("mode", 4);
		return "jsp/paper/diffAdjustPaper";
	}
	
	//获得结构化组卷的题目数量、题型、主题词参数
	@RequestMapping("/getStructureMes")
	public @ResponseBody Map<String, Object> getStructureMes(){
		String cid = getPara("cid");//课程id
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("cid", cid);
			map.put("permission", "paper:add");
			if(courseService.checkCoursePermission(map,getUserID()+"_"+cid)==0){
				return null;
			}
		}
		Map m = new HashMap();
		m.put("cid", cid);
		m.put("cname",courseService.getCourseAttr(cid).get(0).get("name_c"));//获取课程相关参数name_c课程中文名
		m.put("difficultyDistribution", questionService.getDifficultyDistribution(cid));//获取试题难度分布
		m.put("themeList", questionService.getQuestionFilterByTheme1(cid));
		
		Map param = new HashMap();
		param.put("id", cid);
		param.put("cid", cid);

		int Sys_forbidDay = Utils.changeObjToInt(getApplication().getAttribute("question_used_day"));//获取系统设置好的限制次数（parseint）
		int forbidDay = Math.min(Utils.changeObjToInt(getPara("forbidDay"), Sys_forbidDay),
				Sys_forbidDay == 0 ? Integer.MAX_VALUE : Sys_forbidDay);

		int Sys_forbidNum = Utils.changeObjToInt(getApplication().getAttribute("question_use_time"));//获取系统设置好的限制次数（parseint）
		int forbidNum = Math.min(Utils.changeObjToInt(getPara("forbidNum"), Sys_forbidNum),
				Sys_forbidNum == 0 ? Integer.MAX_VALUE : Sys_forbidNum);

		int limit4Isreview = Utils.changeObjToInt(getApplication().getAttribute("limit4Isreview"));
		int isVerified = (limit4Isreview == 1)
				? 1 : Utils.changeObjToInt(getPara("isVerified"), limit4Isreview);

		param.put("forbidBefore", forbidDay);	//组卷时限定多少天以前出过的试题不再出
		param.put("forbidNum",forbidNum);	//组卷时限定多少次以上出过的试题不再出
		param.put("isVerified", isVerified);	//组卷时限定试题是否通过审核

		m.put("questionTypeList", questionService.getAllQT4CourseQuestion(param));//获取课程题目的所有题型
		m.put("distributionStatistics", questionService.getDistributionStatistics(param));//这里是根据限制次数&天数查询
		return m;
	}

	// 导出试题
	@RequestMapping("/exportPaperQuestion")
	public ResponseEntity<Resource> exportPaperQuestion() {
		User u = getUserInfo();
		String cid = getPara("cid");
		String eid = getPara("eid");
		String[] qids= null;
		if(getPara("qids")!=null && !getPara("qids").equals("")){
			qids = (getParaValues("qids"))[0].split(",");
		}
		Map param = new HashMap();
		param.put("uid", u.getId());
		param.put("cid", cid);
		param.put("eid", eid);
		param.put("qids", qids);
		param.put("th1id", getPara("th1id"));
		param.put("th2id", getPara("th2id"));
		param.put("th3id", getPara("th3id"));
		param.put("qtid", getPara("qtid"));
		param.put("coid", getPara("coid"));
		param.put("did", getPara("did"));
		param.put("kid", getPara("kid"));
		param.put("gs", getPara("gs"));
		param.put("permission", "paper:view");
		if(!"administrator".equals(u.getRole())){
			int rtn = verifyService.checkPaperPermission(param);
			if(rtn==0){
				if(getPara("aorb").equals("b")){
					return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
				}else{
					return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
				}
			}
		}
		Map<String,Object> examinfo = paperService.getExamInfo(eid);
		//A/B卷
		
		Object aore = examinfo.get("AORB");
		String aore_type = String.valueOf(aore);
		if("0".equals(aore_type)) {
			aore= "(A卷)";	
		}else {
			aore= "(B卷)";	
		}
		String code = "";
		if(examinfo.get("CODE")!=null) {
			code= (String)examinfo.get("CODE");	
		}	
		String fileName = code+ examinfo.get("ENAME") + aore+".xls";
		HSSFWorkbook workbook = poiService.exportPaperQuestion(param);
		  
		Map log = new HashMap();
		log.put("content", "批量导出试卷试题,试卷代码为："+eid+"，试卷名为《"+examinfo.get("ENAME")+"》");
		log.put("cid", cid);
		systemService.addSysLog(log);
		  
		return FileDownloadUtils.download(workbook, fileName);
	}

	@RequestMapping("/exportAllPaperQuestion")
	public ResponseEntity<Resource> exportAllPaperQuestion() {
		User u = getUserInfo();
		String eid = getPara("eid");
		Map param = new HashMap();
		param.put("uid", u.getId());
		param.put("eid", eid);
		param.put("permission", "paper:view");
		if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = verifyService.checkPaperPermission(param);
			if(rtn==0){
				return null;
			}
		}
		Map<String,Object> examinfo = paperService.getExamInfo(eid);
		//A/B卷

		Object aore = examinfo.get("AORB");
		String aore_type = String.valueOf(aore);
		if("0".equals(aore_type)) {
			aore= "(A卷)";
		}else {
			aore= "(B卷)";
		}
		String code = "";
		if(examinfo.get("CODE")!=null) {
			code= (String)examinfo.get("CODE");
		}
		String fileName = code+ examinfo.get("ENAME") + aore+".xls";
		HSSFWorkbook workbook = poiService.exportAllPaperQuestion(param);


		Map log = new HashMap();
		log.put("content", "批量导出试卷试题,试卷代码为："+eid+"，试卷名为《"+examinfo.get("ENAME")+"》");
		log.put("cid", "");
		systemService.addSysLog(log);

		return FileDownloadUtils.download(workbook, fileName);
	}
	
	//试卷导入试题例子
	@RequestMapping("/importQuestionMonel")
	public ResponseEntity<Resource> importQuestionMonel() {
		return FileDownloadUtils.download(WebFilePath.getProjectPath()+"mb/stmb3.xls");
	}
	
	// 导入试题
	@RequestMapping("/importQuestionToPaper")
	public @ResponseBody Map<String, Object> importQuestionToPaper(@RequestParam(value="uploadFile") MultipartFile mFile) {
		String eid = getPara("eid");
		String cids = getPara("cid");
		Map param = new HashMap();
		param.put("uid", getUserID());
		param.put("eid", eid);
		param.put("permission", "paper:update");
		Map map = new HashMap();
		if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = verifyService.checkPaperPermission(param);			
			if(rtn==0){
				map.put("code", 1);
				map.put("message", "您没有相关权限");
				return map;
			}
		}

		map = poiService.importQuestionToPaper(mFile, cids, eid);
		getRequest().setAttribute("eid", eid);		
		
		Map log = new HashMap();
		log.put("content", "批量导入试卷试题,试卷编号为："+eid);
		log.put("cid", "");
		systemService.addSysLog(log);
		
		return map;
	}
	
	@RequestMapping("/separateOption")
	public @ResponseBody int separateOption() {
		String eid=getPara("eid");
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:update");
			if(verifyService.checkPaperPermission(map)==0){
				return 0;
			}
		}
		
		String all=getPara("all");
		Map<String,Object> param= new HashMap<>();
		param.put("eid", eid);
		if("1".equals(all)) {
			String[] qids = getParaValues("qids");
			param.put("qids", qids);
		}
		return paperService.separateOption(param);
	}

	@RequestMapping("/getAllTheme_cid")
	public @ResponseBody List<Map<String,Object>> getAllTheme_cid() {
		return paperService.getAllTheme_cid(getPara("cid"));
	}
}
