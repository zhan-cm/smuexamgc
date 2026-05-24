package com.cx.kaoyi.business.controller.system;

import com.cx.kaoyi.business.domain.Permission;
import com.cx.kaoyi.business.service.*;
import com.cx.kaoyi.framework.GPT.generateDTO.business.QuestionGenerateThreadPool;
import com.cx.kaoyi.framework.GPT.generateDTO.business.QuestionGeneratorConfig;
import com.cx.kaoyi.framework.base.BaseController;
import com.cx.kaoyi.framework.base.FileDownloadUtils;


import com.cx.kaoyi.framework.cache.LocalCache;

import com.cx.kaoyi.framework.shiro.ShiroConstants;
import com.cx.kaoyi.framework.utils.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.session.ExpiredSessionException;
import org.apache.shiro.session.Session;
import org.apache.shiro.session.mgt.DefaultSessionKey;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.transaction.interceptor.TransactionAspectSupport;
import org.springframework.web.bind.annotation.*;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.stream.Collectors;

@Controller
@RequestMapping("/system")
public class SystemController extends BaseController{

	@Autowired
	public CommonService commonService;

	@Autowired
	public SystemService systemService;

	@Autowired
	public CourseService courseService;

	@Autowired
	public PoiService poiService;

	@Autowired
	public PaperService paperService;

	@Autowired
	public PermissionService permissionService;

	// 系统参数页面
	@RequestMapping("/params")
	public String params(){
		if (getSubject().hasRole("administrator")) {
			return "jsp/system/params";
		}
		return "jsp/notTheRole";
	}

	// 题目类型设置页面
	@RequestMapping("/setQuestionType")
	public String setQuestionType(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		return "jsp/system/setQuestionType";
	}

	// 教学单位设置页面
	@RequestMapping("/setUnit")
	public String setUnit(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		return "jsp/system/setUnit";
	}

	// 学生专业设置页面
	@RequestMapping("/setSpecialty")
	public String setSpecialty(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		return "jsp/system/setSpecialty";
	}

	//学校名称设置
	@RequestMapping("/setOrganizationName")
	public String setOrganizationName(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		Map<String,Object> map = systemService.getSystemParam("organization_info");
		Map<String,Object> map1 = systemService.getSystemParam("organization_info_en");
		getRequest().setAttribute("info", map);
		getRequest().setAttribute("info_en", map1);
		return "jsp/system/setOrganizationName";
	}

	@RequestMapping("updateOrganizationName")
	public @ResponseBody String updateOrganizationName(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		Map param = new HashMap();
		param.put("name", "organization_info");
		String schoolName = getPara("param");
		param.put("param", schoolName);
		param.put("yl_1", getPara("yl_1"));
		param.put("yl_2", getPara("yl_2"));
		param.put("yl_3", getPara("yl_3"));
		param.put("yl_4", getPara("yl_4"));
		param.put("yl_5", getPara("yl_5"));
		int i = systemService.updateSystemParam(param);
		Map m = new HashMap();
		String schoolName_en = getPara("param_en");
		m.put("name", "organization_info_en");
		m.put("param", schoolName_en);
		int j = systemService.updateSystemParam(m);
		getApplication().setAttribute("organizationinfo", systemService.getSystemParam("organization_info"));
		getApplication().setAttribute("organizationinfo_en", systemService.getSystemParam("organization_info_en"));
		if(i>0){
			Map log = new HashMap();
			log.put("content", "修改学校名称为："+schoolName);
			log.put("cid", "");
			systemService.addSysLog(log);
			return "success";
		}else{
			return "false";
		}
	}

	// 查询部门
	// 改动中文乱码问题
	@RequestMapping("/queryDep")
	public String queryDep(){
		String unitId = getPara("uid");
		getRequest().setAttribute("uid", unitId);
		String unitName = systemService.getUnitNameById(unitId);
		getRequest().setAttribute("uname", unitName);
		return "jsp/system/queryDep";
	}

	//	获取系统默认题型
	@RequestMapping("/getDefaultQuestionTypeList")
	public @ResponseBody Map<String, Object> getDefaultQuestionTypeList(){
		if (!getSubject().hasRole("administrator")) {
			return null;
		}
		Map m = new HashMap();
		return getRes(commonService.defaultQuestionType(), systemService.getDefaultQuestionTypeCount(m));
	}

	//	获取系统默认单位
	@RequestMapping("/getUnitList")
	public @ResponseBody Map<String, Object> getUnitList(){
		if (!getSubject().hasRole("administrator")) {
			return null;
		}
		String name = getPara("name");
		Map m = new HashMap();
		if(!StringUtils.isEmpty(name)) {
			m.put("name", name);
		}
		m.put("del", getPara("del"));
		if(getPara("sort") != null && getPara("order") != null) {
			m.put("sort", getPara("sort"));
			m.put("order", getPara("order"));
		}
		PageUtils pu = getPageUtil();
		return getRes(systemService.getUnitList(m, pu), systemService.getUnitCount(m));
	}

	//	获取部门
	@RequestMapping("/getDepList")
	public @ResponseBody Map<String, Object> getDepList(){
		if (!getSubject().hasRole("administrator")) {
			return null;
		}
		Map m = new HashMap();
		m.put("uid", getPara("uid"));
		m.put("del", getPara("del"));
		if(getPara("sort") != null && getPara("order") != null) {
			m.put("sort", getPara("sort"));
			m.put("order", getPara("order"));
		}
		PageUtils pu = getPageUtil();
		return getRes(systemService.getDepartmentList(m, pu), systemService.getDepartmentCount(m));
	}

	//	获取系统默认专业
	@RequestMapping("/getSpecialtyList")
	public @ResponseBody Map<String, Object> getSpecialtyList(){
		if (!getSubject().hasRole("administrator")) {
			return null;
		}
		PageUtils pu = getPageUtil();
		Map m = new HashMap();
		m.put("name", getPara("name"));
		m.put("del", getPara("del"));
		String sort = pu.getSort();
		String order = pu.getOrder();
		if(sort != null && order != null) {
			m.put("sort", pu.getSort());
			m.put("order", pu.getOrder());
		}
		return getRes(systemService.getSpecialtyList(m, pu), systemService.getSpecialtyCount(m));
	}

	@RequestMapping("/deleteByDate")
	public @ResponseBody int deleteByDate() {
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		String bdate = getPara("bdate");
		String edate = getPara("edate");
		Map param = new HashMap();
		param.put("bdate", bdate);
		param.put("edate", edate);
		int rtn = systemService.delByDate(param);
		if(rtn>0){
			Map log = new HashMap();
			log.put("content", "删除了"+bdate+"到"+edate+"的系统日志");
			log.put("cid", "");
			systemService.addSysLog(log);
		}
		return rtn;
	}


	// 	添加系统默认题型
	@RequestMapping("/addQuestionType")
	public @ResponseBody String addQuestionType(){
		if (getSubject().hasRole("administrator")) {
			Map param = new HashMap();
			param.put("name", getPara("qt_name"));
			param.put("e_qtname", getPara("e_qt_name"));
			param.put("iscon", getPara("qt_iscon"));
			param.put("answertypeid", getPara("qt_answertypeid"));
			param.put("desc", getPara("qt_desc"));
			param.put("e_qtdesc", getPara("e_qt_desc"));
			param.put("isdefault", 1);
			param.put("xxdf", getPara("qt_xxdf"));
			param.put("mediaSet", getPara("qt_mediaSet"));
			systemService.insertQuestionType(param);
			getApplication().setAttribute("questionTypeList", commonService.defaultQuestionType());
			return "1";
		}else {
			return "0";
		}

	}

	//  添加单位
	@RequestMapping("/addUnit")
	public @ResponseBody String addUnit(){
		if (!getSubject().hasRole("administrator")) {
			return "0";
		}
		String uname = getPara("uname");
		uname=uname.trim();

		Map param = new HashMap();
		param.put("uname", uname);
		param.put("contact", getPara("contact"));
		param.put("tel", getPara("tel"));
		int code = Utils.changeObjToInt(getPara("code"));
		param.put("code", code);
		int rs = systemService.getRepeatUnit(param);
		if(rs==0) {
			systemService.insertUnit(param);
			getApplication().setAttribute("unitList", commonService.defaultUnit());

			Map log = new HashMap();
			log.put("content", "添加教学单位" + uname);
			log.put("cid", "");
			systemService.addSysLog(log);
			return "1";
		}else {
			return "0";
		}
	}

	//  添加部门
	@RequestMapping("/addDep")
	public @ResponseBody int addDep(){
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		String dname=getPara("dname");
		dname=dname.trim();
		if(dname.equals("undefined")||dname.equals("")||dname==null){
			return -1;
		}
		Map param = new HashMap();
		param.put("uid", getPara("uid"));
		param.put("uname", getPara("uname"));
		param.put("dname", dname);
		param.put("dcontact", getPara("contact"));
		param.put("dtel", getPara("tel"));
		int code = Utils.changeObjToInt(getPara("code"));
		param.put("code", code);
		int rs = systemService.getRepeatDep(param);
		if(rs == 0) {
			return systemService.insertDepartment(param);
		}else {
			return 0;
		}
	}

	//  添加专业
	@RequestMapping("/addSpecialty")
	public @ResponseBody int addSpecialty(){
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		String sname = getPara("sname").replace("&#40;", "（").replace("&#41;", "）");
		sname=sname.trim();
		if(sname.equals("undefined")||sname.equals("")||sname==null){
			return 2;
		}
		Map param = new HashMap();
		param.put("uid", getPara("uid"));
		param.put("name", sname);
		int rs = systemService.getRepeatSpecialty(param);
		if(rs==0) {
			systemService.insertSpecialty(param);
			List<Map<String, Object>> specialtyList = commonService.defaultSpecialty();
			Map<String, String> specialtyMap = new HashMap<>();
			for(Map<String,Object> sp : specialtyList){
				specialtyMap.put(String.valueOf(sp.get("ID")), String.valueOf(sp.get("NAME")));
			}
			getApplication().setAttribute("specialtyMap", specialtyMap);
			getApplication().setAttribute("specialtyList", specialtyList);
			Map log = new HashMap();
			log.put("content", "新增专业"+sname);
			log.put("cid", "");
			systemService.addSysLog(log);
			return 1;
		}else {
			return 0;
		}

	}

	//  添加考试类别
	@RequestMapping("/addExamtype")
	public @ResponseBody int addExamtype(){
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		String name = getPara("name");
		name=name.trim();
		if(name.equals("undefined")||name.equals("")||name==null){
			return 2;
		}
//		int num =systemService.getAddExamtypeCount()+1;
		Map param = new HashMap();
		//压力测试考试类别 固定id 13
		if("压力测试".equals(name)){
			param.put("id", "13");
		}
		param.put("name", name);
//		param.put("eorder", num);
		param.put("isdefault", 1);
		int rs = systemService.getRepeatExamtype(param);
		if(rs==0) {
			try{
				systemService.insertExamtype(param);
			}catch(Exception e){
				return -1;
			}
			getApplication().setAttribute("examTypeList", commonService.defaultExamType());
			Map log = new HashMap();
			log.put("content", "新增考试类别"+name);
			log.put("cid", "");
			systemService.addSysLog(log);
			return 1;
		}else {
			return 0;
		}
	}

	// 系统默认题型数目,用于检测重复
	@RequestMapping("/checkRepeatQuestionType")
	public @ResponseBody String checkRepeatQuestionType(){
		List<Map<String, Object>> qtList = commonService.defaultQuestionType();
		for(int i=0;i<qtList.size();i++){
			if(getPara("qtname").equals(qtList.get(i).get("NAME"))){
				return "-1";
			}
		}
		return "1";
	}

	// 系统单位数目,用于检测重复
	@RequestMapping("/checkRepeatUnit")
	public @ResponseBody String checkRepeatUnit(){

		List<Map<String, Object>> unitList = commonService.defaultUnit();
		for(int i=0;i<unitList.size();i++){
			if(getPara("uname").equals(unitList.get(i).get("NAME"))){
				if(!getPara("uid").equals(unitList.get(i).get("ID"))){
					return "-1";
				}
			}
		}
		return "1";
	}

	// 单位部门数目,用于检测重复
	@RequestMapping("/checkRepeatDep")
	public @ResponseBody String checkRepeatDep(){
		Map m = new HashMap();
		m.put("uid", getPara("uid"));
		m.put("dname", getPara("dname"));
		return systemService.getDepartmentCount(m);
	}

	// 系统专业数目,用于检测重复
	@RequestMapping("/checkRepeatSpecialty")
	public @ResponseBody String checkRepeatSpecialty(){

		List<Map<String, Object>> specialtyList = commonService.defaultSpecialty();

		for(int i=0;i<specialtyList.size();i++){
			if(getPara("sname").equals(specialtyList.get(i).get("NAME"))){
				if(!getPara("sid").equals(specialtyList.get(i).get("ID"))){
					return "-1";
				}
			}
		}
		return "1";
	}

	// 更新部门
	@RequestMapping("/updateDep")
	public @ResponseBody int updateDep(){
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		String dname=getPara("dname");
		dname=dname.trim();
		if(dname.equals("undefined")||dname.equals("")||dname==null){
			return -1;
		}
		Map param = new HashMap();
		param.put("id", getPara("id"));
		param.put("dname", dname);
		param.put("contact", getPara("contact"));
		param.put("tel", getPara("tel"));
		param.put("uid", getPara("uid"));
		String codeStr = getPara("code");
		if (codeStr == null || "".equals(codeStr)) {
			param.put("code", 0);
		} else {
			try {
				int code = Integer.parseInt(codeStr);
				param.put("code", code);
			} catch (NumberFormatException e) {
				param.put("code", 0);
			}
		}
		int rs = systemService.getRepeatDep(param);
		if(rs==0) {
			String depName = systemService.getDeptByID(getPara("id"));
			int s = systemService.updateDep(param);
			Map log = new HashMap();
			log.put("content", "修改部门（"+depName+"）名称为"+getPara("dname"));
			log.put("cid", "");
			systemService.addSysLog(log);
			return s;
		}else {
			return 0;
		}
	}

	// 更新单位
	@RequestMapping("/updateUnit")
	public @ResponseBody int updateUnit(){
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		String uname = getPara("uname");
		uname=uname.trim();
		String id = getPara("id");
		Map param = new HashMap();
		param.put("id", id);
		param.put("uname", uname);

		String codeStr = getPara("code");
		if (codeStr == null || "".equals(codeStr)) {
			param.put("code", 0);
		} else {
			try {
				int code = Integer.parseInt(codeStr);
				param.put("code", code);
			} catch (NumberFormatException e) {
				param.put("code", 0);
			}
		}
		if(!"null".equals(getPara("contact"))){
			param.put("contact", getPara("contact"));
		}else{
			param.put("contact", "");
		}
		if(!"null".equals(getPara("tel"))){
			param.put("tel", getPara("tel"));
		}else{
			param.put("tel", "");
		}

		int rs = systemService.getRepeatUnit(param);
		if(rs == 0) {
			String name = systemService.getUnitNameById(id);
			systemService.updateUnit(param);
			commonService.initSpecialtyAndUnit();

			Map log = new HashMap();
			log.put("content", "更新教学单位 "+name+" 信息");
			log.put("cid", "");
			systemService.addSysLog(log);
			return 1;
		}else {
			return 0;
		}

	}

	// 更新专业
	@RequestMapping("/updateSpecialty")
	public @ResponseBody int updateSpecialty(){
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		String id = getPara("id");
		String sname = getPara("sname");
		sname=sname.trim();
		if(sname.equals("undefined")||sname.equals("")||sname==null){
			return 2;
		}
		Map map = new HashMap();
		map.put("id", id);
		map.put("uid", getPara("uid"));
		map.put("name", sname);
		int rs = systemService.getRepeatSpecialty(map);
		if(rs == 0) {
			String spname = systemService.getSpNameByID(id);
			systemService.updateSpecialty(map);
			commonService.initSpecialtyAndUnit();

			Map log = new HashMap();
			log.put("content", "修改《"+spname+"》专业为《"+sname+"》");
			log.put("cid", "");
			systemService.addSysLog(log);
			return 1;
		}else {
			return 0;
		}
	}

	// 更新考试类别
	@RequestMapping("/updateExamtype")
	public @ResponseBody int updateExamtype(){
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		String id = getPara("id");
		String name = getPara("name");
		String state = getPara("state");
		name=name.trim();
		if(name.equals("undefined")||name.equals("")||name==null){
			return 2;
		}

		Map map = new HashMap();
		String spname = systemService.getEmNameByID(id);
		map.put("id", id);
		map.put("state", state);
		systemService.updateExamtype(map);
		getApplication().setAttribute("examTypeList", commonService.defaultExamType());
		Map log = new HashMap();
		log.put("content", "修改《"+spname+"》考试类别为《"+name+"》");
		log.put("cid", "");
		systemService.addSysLog(log);
		return 1;

	}

	@RequestMapping("/updateStudentSpecialtyInSelf")
	public @ResponseBody int updateStudentSpecialtyInSelf(){
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		commonService.initSpecialtyAndUnit();
		return systemService.updateStudentSpecialtyInSelf();
	}

	@RequestMapping("/recSpecialty")
	public @ResponseBody int recSpecialty() {
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		int rtn = systemService.recSpecialty(getPara("id"));
		List<Map<String, Object>> specialtyList = commonService.defaultSpecialty();
		Map<String, String> specialtyMap = new HashMap<>();
		for(Map<String,Object> sp : specialtyList){
			specialtyMap.put(String.valueOf(sp.get("ID")), String.valueOf(sp.get("NAME")));
		}
		getApplication().setAttribute("specialtyMap", specialtyMap);
		getApplication().setAttribute("specialtyList", specialtyList);
		return rtn;
	}

	@RequestMapping("/recExamtype")
	public @ResponseBody int recExamtype() {
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		int i= systemService.recExamtype(getPara("id"));
		if(i==1) {
			getApplication().setAttribute("examTypeList", commonService.defaultExamType());
		}
		return i;
	}

	@RequestMapping("/recUnit")
	public @ResponseBody int recUnit() {
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		int rtn = systemService.recUnit(getPara("id"));
		getApplication().setAttribute("unitList", commonService.defaultUnit());
		return rtn;
	}

	//获取系统单位
	@RequestMapping("getAllUnit")
	public @ResponseBody List<Map<String, Object>> getAllUnit(){
		Map m = new HashMap();
		List<Map<String, Object>> unitList = systemService.getAllUnit(m);
		return unitList;
	}

	/**
	 * @author 黎青华
	 * 删除单位(把单位状态设为0)
	 * @param "uid" 单位主键
	 */
	@RequestMapping("delUnit")
	public @ResponseBody String delUnit() {
		if (!getSubject().hasRole("administrator")) {
			return "0";
		}
		String id = getPara("uid");
		String uname = systemService.getUnitNameById(id);
		Map param = new HashMap();
		param.put("id", id);
		systemService.delUnit(param);
//		systemService.delDepByUid(param);
		getApplication().setAttribute("unitList", commonService.defaultUnit());

		Map log = new HashMap();
		log.put("content", "删除教学单位："+uname);
		log.put("cid", "");
		systemService.addSysLog(log);

		return "1";
	}

	/**
	 * @author 黎青华
	 * 删除二级单位
	 * @param "id" 二级单位主键
	 */
	@RequestMapping("delDep")
	public @ResponseBody String delDep() {
		if (!getSubject().hasRole("administrator")) {
			return "";
		}
		Map param = new HashMap();
		param.put("id", getPara("id"));
		return systemService.delDep(param)+"";
	}

	@RequestMapping("recDep")
	public @ResponseBody int recDep() {
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		return systemService.recDep(getPara("id"));
	}

	/**
	 * @author 黎青华
	 * 删除学生专业
	 * @param "id" 主键
	 *
	 */
	@RequestMapping("delSpecialty")
	public @ResponseBody String delSpecialty() {
		if (!getSubject().hasRole("administrator")) {
			return "";
		}
		Map param = new HashMap();
		String id = getPara("id");
		param.put("id", id);
		String spname = systemService.getSpNameByID(id);
		systemService.delCourseSpecialty(param);
		String rs = systemService.delSpecialty(param)+"";
		List<Map<String, Object>> specialtyList = commonService.defaultSpecialty();
		Map<String, String> specialtyMap = new HashMap<>();
		for(Map<String,Object> sp : specialtyList){
			specialtyMap.put(String.valueOf(sp.get("ID")), String.valueOf(sp.get("NAME")));
		}
		getApplication().setAttribute("specialtyMap", specialtyMap);
		getApplication().setAttribute("specialtyList", specialtyList);

		Map log = new HashMap();
		log.put("content", "删除专业"+spname);
		log.put("cid", "");
		systemService.addSysLog(log);

		return rs;
	}

	/**
	 * @author 黄军勇
	 * 删除考试类别
	 * @param "id" 主键
	 *
	 */
	@RequestMapping("delExamtype")
	public @ResponseBody String delExamtype() {
		if (!getSubject().hasRole("administrator")) {
			return "";
		}
		Map param = new HashMap();
		String id = getPara("id");
		param.put("id", id);
		List<Map<String,Object>> courseList = (List<Map<String, Object>>) paperService.getCourseByTypeID(param);
		List<Map<String,Object>> infoList = (List<Map<String, Object>>) paperService.getExamInfoByTypeID(param);
		String spname = systemService.getEmNameByID(id);
		if(infoList!=null && infoList.size()>=0 && courseList!=null && courseList.size()>=0) {
			return "0";
		}
		String rs = systemService.delExamtype(param)+"";
		getApplication().setAttribute("examTypeList", commonService.defaultExamType());
		Map log = new HashMap();
		log.put("content", "删除考试类别"+spname);
		log.put("cid", "");
		systemService.addSysLog(log);

		return rs;
	}

	/**
	 * 彻底删除考试类别
	 * @param "id" 主键
	 *
	 */
	@RequestMapping("del")
	public @ResponseBody String del() {
		if (!getSubject().hasRole("administrator")) {
			return "";
		}
		Map param = new HashMap();
		String id = getPara("id");
		param.put("id", id);
		String spname = systemService.getEmNameByID(id);
		String rs = systemService.del(param)+"";
		getApplication().setAttribute("examTypeList", commonService.defaultExamType());
		Map log = new HashMap();
		log.put("content", "删除考试类别"+spname);
		log.put("cid", "");
		systemService.addSysLog(log);

		return rs;
	}

	/**
	 * @author 黎青华
	 * 把默认题型设为非默认
	 * @param "id" 主键
	 *
	 */
	@RequestMapping("delQuestionType")
	public @ResponseBody String delQuestionType() {
		if (getSubject().hasRole("administrator")) {
			Map param = new HashMap();
			param.put("id", getPara("id"));
			systemService.delQuestionType(param);
			getApplication().setAttribute("questionTypeList", commonService.defaultQuestionType());
			return "1";
		}else {
			return "0";
		}

	}

	/**
	 * @author yoyo
	 * 编辑题型
	 */
	@RequestMapping("updateQuestionType")
	public @ResponseBody String updateQuestionType() {
		if(getSubject().hasRole("administrator")){
			List<Map<String, Object>> qtList = (List<Map<String, Object>>) getApplication().getAttribute("questionTypeList");
			for(int i=0;i<qtList.size();i++){
				if(StringUtils.isEmpty(getPara("qtname"))||(getPara("qtname").equals(qtList.get(i).get("NAME"))&&(!getPara("id").equals(qtList.get(i).get("ID"))))){
					return "-1";
				}
			}

			Map param = new HashMap();
			param.put("id", getPara("id"));
			param.put("name", getPara("qtname"));
			param.put("e_qtname", getPara("e_qtname"));
			param.put("desc", getPara("qtdesc"));
			param.put("e_qtdesc", getPara("e_qtdesc"));
			param.put("iscon", getPara("iscon"));
			param.put("atid", getPara("atid"));
			param.put("xxdf", getPara("xxdf"));
			param.put("mediaSet", getPara("mediaSet"));
			systemService.updateQuestionType(param);

			getApplication().setAttribute("questionTypeList", commonService.defaultQuestionType());
			return "1";
		}else{ //其他角色，查询有浏览课程权限的所有课程
			return "0";
		}
	}

	/**
	 * 查看系统日志
	 * @author yoyo
	 * @return
	 */
	@RequestMapping("/logs")
	public String logs(){
		if (getSubject().hasRole("administrator")) {
			return "jsp/system/sysLog";
		}
		return "jsp/notTheRole";
	}

	/**
	 * 获取日志列表
	 * @author yoyo
	 * @return
	 */
	@RequestMapping("/getLogsList")
	public @ResponseBody Map<String, Object> getLogsList(){
		if (!getSubject().hasRole("administrator")) {
			return null;
		}
		Map param = new HashMap();
		if(getPara("limit_time")!=null && !"".equals(getPara("limit_time"))){
			int limit_time = Integer.parseInt((String)getPara("limit_time"));

			Calendar cal = Calendar.getInstance();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

			Calendar calSmall = Calendar.getInstance();
			calSmall.setTime(cal.getTime());
			calSmall.set(Calendar.DATE
					, calSmall.get(Calendar.DATE)-limit_time);
			param.put("limit_time", sdf.format(calSmall.getTime()));
		}
		if(!StringUtils.isEmpty(getPara("value"))) {
			param.put("value", getPara("value"));
		}
		PageUtils pu = getPageUtil();
		return getRes(systemService.getLogsList(param,pu), systemService.getLogsCount(param));
	}

	@RequestMapping("/kickout")
	public @ResponseBody int kickout() {
		if (getSubject().hasRole("administrator") || getSubject().hasRole("dean")) {
			String sessionid = getPara("id");
			LocalCache cache = LocalCache.getInstance();
			try {
				Session onlineSession = SecurityUtils.getSecurityManager().getSession(new DefaultSessionKey(sessionid));
				onlineSession.setTimeout(0);
				cache.evict(ShiroConstants.SESSION_CACHE_NAME, sessionid);
				return 0;
			} catch (ExpiredSessionException e) {
				cache.evict(ShiroConstants.SESSION_CACHE_NAME, sessionid);
				return 0;
			}
		} else {
			return 1;
		}
	}


	@RequestMapping("/kickoutByName")
	public @ResponseBody int kickoutByName() {
		String name = getPara("name");
		String roleMark = getPara("rolemark");
		LocalCache cache = LocalCache.getInstance();
		String[] roleMarks = roleMark != null ? roleMark.split(",") : null;
		List<String> cacheKeys = cache.keys(ShiroConstants.SESSION_CACHE_NAME);
		int kickedOutCount = 0;
		for (String sessionId : cacheKeys) {
			Map<String, Object> sessionData = cache.getMap(ShiroConstants.SESSION_CACHE_NAME, sessionId);
			if (sessionData == null) continue;
			String cachedName = String.valueOf(sessionData.get("name"));
			Object cachedRole = sessionData.get("rolemark");

			if (!name.equals(cachedName)) continue;

			if (roleMarks != null && roleMarks.length > 0) {
				boolean match = false;
				for (String role : roleMarks) {
					if (cachedRole != null && Integer.parseInt(role) == Integer.parseInt(cachedRole.toString())) {
						match = true;
						break;
					}
				}
				if (!match) continue;
			}

			try {
				Session onlineSession = SecurityUtils.getSecurityManager().getSession(new DefaultSessionKey(sessionId));
				onlineSession.setTimeout(0); // 踢出
			} catch (ExpiredSessionException e) {
			}
			cache.evict(ShiroConstants.SESSION_CACHE_NAME, sessionId);
			kickedOutCount++;
		}
		return kickedOutCount;
	}

	@RequestMapping("/kickoutStudents")
	public @ResponseBody int kickoutStudents() {
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}

		String[] usernames = getParaValues("name[]");
		String roleMarkStr = getPara("rolemark");
		Set<Integer> roleMarks = new HashSet<>();

		if (roleMarkStr != null) {
			for (String r : roleMarkStr.split(",")) {
				roleMarks.add(Integer.parseInt(r));
			}
		}
		LocalCache cache = LocalCache.getInstance();
		// 获取缓存中的所有会话信息
		List<String> keys = cache.keys(ShiroConstants.SESSION_CACHE_NAME);
		for (String sessionId : keys) {
			Map<String, Object> sessionInfo = cache.getMap(ShiroConstants.SESSION_CACHE_NAME, sessionId);
			if (sessionInfo == null) continue;
			String name = (String) sessionInfo.get("name");
			Object rolemarkObj = sessionInfo.get("rolemark");
			int rolemark = (rolemarkObj != null) ? Integer.parseInt(rolemarkObj.toString()) : -1;

			boolean matchUsername = Arrays.asList(usernames).contains(name);
			boolean matchRolemark = roleMarks.isEmpty() || roleMarks.contains(rolemark);

			if (matchUsername && matchRolemark) {
				try {
					Session onlineSession = SecurityUtils.getSecurityManager().getSession(new DefaultSessionKey(sessionId));
					onlineSession.setTimeout(0);
				} catch (Exception e) {
					// 可能 session 已经不存在，不管它
				}

				cache.evict(ShiroConstants.SESSION_CACHE_NAME, sessionId);
			}
		}
		return 1;
	}


	/**
	 * 导出日志
	 * @author yoyo
	 */
	@RequestMapping("/exportLogs")
	public ResponseEntity<Resource> exportLogs() {
		if (!getSubject().hasRole("administrator")) {
			return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
		}
		String time = "";
		if(getPara("limit_time_export")!=null && !"".equals(getPara("limit_time_export"))){
			int limit_time = Integer.parseInt(getPara("limit_time_export"));

			Calendar cal = Calendar.getInstance();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");

			Calendar calSmall = Calendar.getInstance();
			calSmall.setTime(cal.getTime());
			calSmall.set(Calendar.DATE
					, calSmall.get(Calendar.DATE)-limit_time);
			time = sdf.format(calSmall.getTime());

			HSSFWorkbook workbook = poiService.exportLogs(time);
			//删除
			systemService.delLogsBefore(time);
			return FileDownloadUtils.download(workbook, "系统日志.xls");
		}else{
			return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
		}
	}

	/**
	 * 查询出所有与专业相关的课程名与ID
	 * @author Sam
	 */
	@RequestMapping("/findCidsBySpecialty")
	public @ResponseBody List<Map<String, Object>> findCidsBySpecialty(){
		return commonService.findCidsBySpecialty(getPara("id"));
	}

	/**
	 * 设置默认考务信息
	 *
	 */
	@RequestMapping("/setDefaultExamInfo")
	public String setDefaultExamInfo() {
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		if(!StringUtils.isEmpty(getPara("update"))) {
			getRequest().setAttribute("update", "1");
		}
		getRequest().setAttribute("examInfo", paperService.getDefaultExamInfo("1"));
		return "jsp/system/defaultExamInfo";
	}

	@RequestMapping("/switch")
	public String inSwitch(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		return "jsp/system/switch";
	}

	/**
	 * 更新默认考务信息
	 */
	@RequestMapping("/updateDefaultExamInfo")
	public String updateDefaultExamInfo() {
		if (!getSubject().hasRole("administrator")) {
			return "redirect:/jsp/notTheRole";
		}
		Map param = new HashMap();
		param.put("id", "1");
		param.put("term", getPara("term")); //学期
		param.put("schoolYear", getPara("schoolYear")); //学年
		param.put("examType", getPara("examType")); //考试类型
		param.put("examWay", getPara("examWay")); //开闭卷设置
		param.put("total", getPara("total")); //考试人数
		param.put("pcount", getPara("pcount")); //印刷份数
		param.put("period", getPara("period")); //学时数
		param.put("percent", getPara("percent")); //成绩占比
		param.put("bhour", getPara("bhour")); //考试开始登陆小时
		param.put("bmin", getPara("bmin"));	//考试开始登陆分钟
		param.put("ehour", getPara("ehour")); //考试开始登陆小时
		param.put("emin", getPara("emin")); //考试开始登陆分钟
		param.put("time", getPara("time")); //考试用时
		param.put("loginBefore", getPara("loginBefore")); //开考前禁止登录时间
		param.put("loginAfter", getPara("loginAfter")); //开考后禁止登录时间
		param.put("queryScore", getPara("queryScore")); //成绩查询设置
		param.put("queryPaper", getPara("queryPaper")); //答卷查看设置
		param.put("testMode", getPara("testMode")); //考试方式设置
		param.put("answerSequence", getPara("answerSequence")); //答题顺序设置
		param.put("correctPaper", getPara("correctPaper")); //改卷方式设置
		param.put("sidVer", getPara("sidVer")); //学号、任务号限定
		param.put("facetime", getPara("facetime"));	//人脸识别次数
		param.put("facefail", getPara("face_fail"));
		if(getPara("facetime")==null || !"2".equals(getPara("sidVer"))){
			param.put("facetime", 0);//人脸识别次数
			param.put("facefail", 0);
		}
		param.put("forbidDay", getPara("forbidDay")); //试卷天数筛选
		param.put("forbidNum", getPara("forbidNum")); //试题次数筛选
		param.put("isVerified", getPara("isVerified"));
		param.put("randomanswer", getPara("randomAnswer"));
		param.put("handInTimeLimit", getPara("handInTimeLimit"));
		String[] s = getParaValues("security");
		String security = "";
		for(String val:s) {
			security += val + ",";
		}
		param.put("security", security.substring(0, security.length()-1)); //考试安全设置
		param.put("venues", getPara("venues")); //考试地点
		param.put("remark2s", getPara("remark2s")); //考试须知
		param.put("e_remark2s", getPara("e_remark2s")); //英文考试须知
		param.put("remark2t", getPara("remark2t")); //备注说明
		paperService.updateDefaultExamInfo(param);
		return "redirect:/system/setDefaultExamInfo?update=1";
	}

	@RequestMapping("/moveQuestionType")
	public @ResponseBody int moveQuestionType() {
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		String qtid = getPara("id");
		String direction = getPara("direction"); // up / down
		List<Map<String, Object>> list = commonService.defaultQuestionType();
		if (list == null || list.size() == 0) {
			return -1;
		}
		int index = -1;
		for (int i = 0; i < list.size(); i++) {
			if (qtid.equals(String.valueOf(list.get(i).get("ID")))) {
				index = i;
				break;
			}
		}
		if (index == -1) {
			return -1;
		}
		int targetIndex = -1;
		if ("up".equals(direction)) {
			if (index == 0) {
				return -1;
			}
			targetIndex = index - 1;
		} else if ("down".equals(direction)) {
			if (index == list.size() - 1) {
				return -1;
			}
			targetIndex = index + 1;
		} else {
			return -1;
		}

		String[] qtids = new String[list.size()];
		for (int i = 0; i < list.size(); i++) {
			qtids[i] = String.valueOf(list.get(i).get("ID"));
		}
		String temp = qtids[index];
		qtids[index] = qtids[targetIndex];
		qtids[targetIndex] = temp;
		int rtn = systemService.updateQuestionTypeOrder(qtids);
		if (rtn > 0) {
			getApplication().setAttribute("questionTypeList", commonService.defaultQuestionType());
		}
		return rtn;
	}

	@RequestMapping("/setTeacherPermission")
	public String setTeacherPermission(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		return "jsp/system/setTeacherPermission";
	}

	@RequestMapping("/getTeacherPermission")
	public @ResponseBody List<Map<String,Object>> getTeacherPermission(){
		if (!getSubject().hasRole("administrator")) {
			return null;
		}
		List<Map<String,Object>> list = commonService.defaultRole().stream().filter(
				map -> !"1".equals(map.get("ID"))
		).collect(Collectors.toList());
		for(Map<String,Object> map:list){
			List<Permission> pList=permissionService.findPerByRID(String.valueOf(map.get("ID")));
			StringBuilder sb=new StringBuilder();
			for(int i=0;i<pList.size();i++){
				String type=pList.get(i).getType();
				if(type.equals("course")){
					sb.append("cper_"+pList.get(i).getId()+";");
				}else if(type.equals("question")){
					sb.append("qper_"+pList.get(i).getId()+";");
				}else if(type.equals("paper")){
					sb.append("pper_"+pList.get(i).getId()+";");
				}

			}
			if(sb.length()>0){
				map.put("permission", sb.substring(0,sb.length()-1));
			}else{
				map.put("permission", "");
			}

		}
		return list;
	}

	@RequestMapping("/updateTeacherPermission")
	public @ResponseBody int updateTeacherPermission(@RequestBody Map map){
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		return systemService.updateTeacherPermission(map);
	}

	@RequestMapping("/deleteUnit")
	public @ResponseBody int deleteUnit() {
		if (!getSubject().hasRole("administrator")) {
			return 0;
		}
		String uname = systemService.getUnitNameById(getPara("id"));
		int rs = systemService.deleteUnit(getPara("id"));
		String dls = systemService.getDepartmentNameByUnit(getPara("id"));
		getApplication().setAttribute("unitList", commonService.defaultUnit());
		Map log = new HashMap();
		String content = "彻底删除单位“"+uname+"”";
		if(!StringUtils.isEmpty(dls)) {
			content += "及其下级部门 “"+dls+"”";
		}
		log.put("cid", "");
		log.put("content", content);
		systemService.addSysLog(log);
		return rs;
	}

	@RequestMapping("/getCourseAndTeacherByUnit")
	public @ResponseBody Map<String, Object> getCourseByUnit(){
		Map m = new HashMap();
		String dls = systemService.getDepartmentNameByUnit(getPara("id"));
		List<Map<String, Object>> cls = systemService.getCourseNameByUnit(getPara("id"));
		List<Map<String, Object>> tls = systemService.getTeacherNameByUnit(getPara("id"));
		m.put("cls", cls);
		m.put("tls", tls);
		m.put("dls", dls);
		return m;
	}

	@RequestMapping("/inStudentLoginRecord")
	public String inStudentLoginRecord() {
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		return "jsp/system/inStudentLoginRecord";
	}

	@RequestMapping("/getStudentLoginRecord")
	public @ResponseBody Map<String, Object> getStudentLoginRecord(){
		if (!getSubject().hasRole("administrator")) {
			return null;
		}
		Map m = new HashMap();
		PageUtils pu = getPageUtil();
		if(!StringUtils.isEmpty(getPara("eid"))) m.put("eid", getPara("eid"));
		if(!StringUtils.isEmpty(getPara("num"))) m.put("num", getPara("num"));
		if(!StringUtils.isEmpty(getPara("time")))
			try {
				m.put("time", Utils.getDateFromStr(getPara("time"), "yyyy-MM-dd"));
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		if(!StringUtils.isEmpty(pu.getSort())) m.put("sort", pu.getSort());
		if(!StringUtils.isEmpty(pu.getOrder())) m.put("order", pu.getOrder());
		return getRes(systemService.getStudentLoginRecord(m,pu), systemService.getStudentLoginRecordTotal(m));
	}

	// 题目类型设置页面
	@RequestMapping("/setMenuPermission")
	public String setMenuPermission(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		List<Map<String,Object>> mlist=systemService.getMenuPermission();
		List<Map<String,Object>> rlist=commonService.getRoles();
		for(Map<String,Object> map:mlist){
			List<Map<String,Object>> nList=new ArrayList<Map<String,Object>>();
			List<Map<String,Object>> mr=(ArrayList<Map<String, Object>>)map.get("role");
			for(int i=0;i<rlist.size();i++){
				if("1".equals(String.valueOf(rlist.get(i).get("ID")))){
					continue;
				}
				Map<String,Object> mm=new HashMap<String,Object>();
				mm.put("ID", rlist.get(i).get("ID"));
				mm.put("CNAME", rlist.get(i).get("CNAME"));
				if(mr!=null){
					for(int j=0;j<mr.size();j++){
						if(String.valueOf(mr.get(j).get("RID")).equals(rlist.get(i).get("ID"))){
							mm.put("exist", 1);
							break;
						}
					}
				}
				nList.add(mm);
			}
			map.put("role", nList);
		}
		getRequest().setAttribute("mlist", mlist);
		return "jsp/system/setMenuPermission";
	}

	@RequestMapping("/saveMenuPermission")
	public @ResponseBody String saveMenuPermission(){
		if (!getSubject().hasRole("administrator")) {
			return "";
		}
		String mid=getPara("mid");
		String[] rids = getParaValues("rids");
		Map<String,Object> param=new HashMap<String,Object>();
		param.put("mid", mid);
		param.put("rids", rids);
		systemService.saveMenuPermission(param);
		return "success";
	}

	@RequestMapping("/saveAllMenuPermission")
	public @ResponseBody String saveAllMenuPermission(){
		if (!getSubject().hasRole("administrator")) {
			return "";
		}
		String[] dataList = getRequest().getParameterValues("dataList");
		Map temp = new HashMap();
		temp.put("roleID", 1);
		temp.put("union", 0);
		List<Map<String,Object>> menuList = commonService.getMenus(temp);
		List<Map<String,Object>> params = new ArrayList<>();
		for(Map m:menuList){
			Map param = new HashMap();
			param.put("mid", m.get("ID"));
			params.add(param);
		}
		for(String data:dataList){
			String[] detail=data.split(",");
			for(Map m: params){
				if(m.get("mid").equals(detail[3])){
					if(m.get("rids")!=null && !m.get("rids").equals("")){
						StringBuffer a = new StringBuffer(m.get("rids").toString());
						a.append(",").append(detail[0]);
						m.put("rids", a.toString());
					}else{
						m.put("rids", detail[0]);
					}
					break;
				}
			}
		}
		for(Map m: params){
			if(m.get("rids")!=null && !m.get("rids").equals("")){
				m.put("rids", m.get("rids").toString().split(","));
			}
			systemService.saveMenuPermission(m);
		}
		return "success";
	}

	@RequestMapping("/saveMenuOrder")
	public @ResponseBody String saveMenuOrder() {
		if (!getSubject().hasRole("administrator")) {
			return "";
		}
		String mid = getPara("mid");
		String direction = getPara("direction"); // up / down
		int rtn = systemService.saveMenuOrder(mid, direction);
		if (rtn == 0) {
			if ("up".equals(direction)) {
				return "已经是第一行或无法上移";
			} else if ("down".equals(direction)) {
				return "已经是最后一行或无法下移";
			}
			return "移动失败";
		}
		return "success";
	}

	/**
	 * 新增学年信息页面
	 * @return
	 */
	@RequestMapping("/setSchoolYear")
	public String setSchoolYear(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		//getRequest().setAttribute("schoolYear", systemService.getSchoolYear());
		List<Map<String, Object>> syList = commonService.getSchoolYear();
		Map<String, Object> syMap = syList.get(0);
		getRequest().setAttribute("currentSY",syMap);
		return "jsp/system/setSchoolYear";
	}

	/**
	 * 新增学年
	 * @return
	 */
	@Transactional(readOnly = true)
	@RequestMapping("/addSchoolYear")
	public @ResponseBody String addSchoolYear(){
		if (!getSubject().hasRole("administrator")) {
			return "";
		}
		Boolean sySuccess = false;
		//获取页面设传过来的学年值
		String sy = getPara("SchoolYear")+"学年";
		Map param = new HashMap();
		param.put("schoolyear",sy);
		//查询数据库是否有该学年信息
		String syExist = systemService.getSchoolYearByName(param);

		Boolean gySuccess = false;
		//获取页面传来年级值
		String gradeyear = getPara("GradeYear")+"级";
		Map map = new HashMap();
		map.put("grade",gradeyear);
		//查询数据库，是否存在该年级信息
		Map<String, Object> gradeNames = commonService.getGradeByName(gradeyear);

		//如果存在则返回false
		try {
			if(StringUtils.isEmpty(syExist)){
				//添加学年
				int i = systemService.addSchoolYear(param);
				if (i>0){
					//添加学年成功，写入系统日志
					Map log = new HashMap();
					log.put("content","成功添加"+sy);
					log.put("cid", "");
					systemService.addSysLog(log);
					getRequest().setAttribute("schoolYear", commonService.getSchoolYear());
					sySuccess = true;
				}
			}

			if (gradeNames==null){
				//获取年级id
				String gradeId = commonService.getGradeId();
				map.put("gradeid",gradeId);
				//新增年级信息
				int num = commonService.insertGrade(map);
				if (num>0){
					//添加年级成功，写入系统日志
					Map log = new HashMap();
					log.put("content","成功添加"+gradeyear);
					log.put("cid", "");
					systemService.addSysLog(log);
					gySuccess = true;
				}
			}
		} catch (Exception e){
			e.printStackTrace();
			TransactionAspectSupport.currentTransactionStatus().setRollbackOnly();
		}
		if(gySuccess==true&&sySuccess==true){
			//更新学年
			getApplication().setAttribute("schoolYear",commonService.getSchoolYear());
			List<Map<String,Object>> gradeList = commonService.getGrade();
			getApplication().setAttribute("grade", gradeList);
			Map<String, String> gradeMap = new HashMap<>();
			for(Map<String,Object> grade : gradeList){
				gradeMap.put(String.valueOf(grade.get("ID")), String.valueOf(grade.get("NAME")));
			}
			getApplication().setAttribute("gradeMap", gradeMap);
			return "success";
		}
		return "false";
	}

	@RequestMapping("/setQuestionStructureRule")
	public String setQuestionStructureRule() {
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		return "jsp/system/setQuestionStructureRule";
	}

	@RequestMapping("/saveQuestionStructureRule")
	public @ResponseBody String saveQuestionStructureRule(
			@RequestParam("usedDay") Integer usedDay,
			@RequestParam("useTime") Integer useTime,
			@RequestParam("limit4Isreview") String limit4Isreview) {
		if (!getSubject().hasRole("administrator")) {
			return "";
		}

		// 基础校验
		if (usedDay == null || usedDay < 0 || useTime == null || useTime < 0) {
			return "invalid";
		}
		if (!"0".equals(limit4Isreview) && !"1".equals(limit4Isreview)) {
			return "invalid";
		}

		Map<String, Object> param = new HashMap<>();
		param.put("name", "question_used_day");
		param.put("yl_1", String.valueOf(usedDay));
		systemService.updateSystemParam(param);
		param.put("name", "question_use_time");
		param.put("yl_1", String.valueOf(useTime));
		systemService.updateSystemParam(param);
		param.put("name", "limit4Isreview");
		param.put("yl_1", limit4Isreview);
		systemService.updateSystemParam(param);
		getApplication().setAttribute("question_used_day", systemService.getSystemParam("question_used_day").get("YL_1"));
		getApplication().setAttribute("question_use_time", systemService.getSystemParam("question_use_time").get("YL_1"));
		getApplication().setAttribute("limit4Isreview", systemService.getSystemParam("limit4Isreview").get("YL_1"));

		Map<String, Object> log = new HashMap<>();
		StringBuilder sb = new StringBuilder();
		sb.append("修改组卷限制设置：");
		sb.append("不使用").append(usedDay).append("天内使用过的试题；");
		sb.append("不使用").append(useTime).append("次及以上的试题；");
		if ("1".equals(limit4Isreview)) {
			sb.append("未审核的试题不能用于组卷。");
		} else {
			sb.append("未审核的试题可以用于组卷。");
		}
		log.put("content", sb.toString());
		log.put("cid", "");
		systemService.addSysLog(log);

		return "success";
	}

	@RequestMapping("/setLastverify")
	public String setLastverify(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		Map<String,Object> map = systemService.getSystemParam("lastverify");
		if(map==null){
			getRequest().setAttribute("lastverify","");
		}else{
			getRequest().setAttribute("lastverify", map.get("YL_1"));
			getRequest().setAttribute("lastverify2", map.get("YL_2"));
			getRequest().setAttribute("lastverify3", map.get("YL_3"));
			getRequest().setAttribute("lastverify4", map.get("YL_4"));
		}

		return "jsp/system/setLastverify";
	}

	@RequestMapping("/updateLastverify")
	public @ResponseBody String updateLastverify(){
		if (!getSubject().hasRole("administrator")) {
			return "";
		}
		Map param = new HashMap();
		param.put("name", "lastverify");
		param.put("yl_1", getPara("username"));
		param.put("yl_2", getPara("username2"));
		param.put("yl_3", getPara("username3"));
		param.put("yl_4", getPara("username4"));
		int i = systemService.updateSystemParam(param);
		if(i>0){
			Map log = new HashMap();
			log.put("content", "修改系统默认审核试卷账号为："+getPara("username"));
			log.put("cid", "");
			systemService.addSysLog(log);
			return "success";
		}else{
			return "false";
		}
	}

	@RequestMapping("/toSetPaperAndWechatParam")
	public String toSetPaperAndWechatParam(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		return "jsp/system/setPaperAndWechatParam";
	}

	@PostMapping("/updatePaperAndWechatParam")
	public @ResponseBody Map<String,Object> updatePaperAndWechatParam(){
		Map<String,Object> rtn = new HashMap<>();
		if(getUserInfo()==null || !getSubject().hasRole("administrator")){
			rtn.put("status","fail");
			rtn.put("info","权限不足！");
			return rtn;
		}

		Map param = new HashMap();
		param.put("name", "seePaper");
		String seePaper = StringUtils.isBlank(getPara("seePaper"))?"normal":getPara("seePaper").trim();
		param.put("yl_1", seePaper);
		systemService.updateSystemParam(param);
		getApplication().setAttribute("seePaper", seePaper);

		rtn.put("status","success");
		rtn.put("info","操作成功！");
		return rtn;
	}

	@RequestMapping("/setCommonSwitch")
	public String setExamInfoSwitch() {
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		return "jsp/system/setCommonSwitch";
	}

	@RequestMapping("/updateCommonSwitch")
	public @ResponseBody Map<String, Object> updateCommonSwitch(@RequestParam Map<String, String> form) {
		Map<String, Object> result = new HashMap<>();
		if (!getSubject().hasRole("administrator")) {
			result.put("success", false);
			result.put("msg", "无权限");
			return result;
		}
		String[] names = {
				"beginexam_switch", "paperdate_switch", "pass_switch"
		};

		int successCount = 0;
		int failCount = 0;
		List<String> logList = new ArrayList<>();
		List<String> updatedNames = new ArrayList<>();

		for (String name : names) {
			if (!form.containsKey(name)) {
				continue;
			}
			String value = form.get(name);
			Map param = new HashMap();
			param.put("name", name);
			param.put("yl_1", value);
			int i = systemService.updateSystemParam(param);
			if (i > 0) {
				successCount++;
				updatedNames.add(name);
				getApplication().setAttribute(name, value); // 业务实际走 application，就同步更新
				String logStr = "";
				if ("beginexam_switch".equals(name)) {
					logStr += "开始答题限制=" + ("1".equals(value) ? "考试开始后才能答题" : "登录即可答题");
				}
				if("paperdate_switch".equals(name)){
					logStr += "超2月未封存试卷能否组卷=" + ("1".equals(value) ? "不能" : "能");
				}
				if("pass_switch".equals(name)){
					logStr += "强密码开关=" + ("1".equals(value) ? "开启" : "关闭");
				}
				logList.add(logStr);
			} else {
				failCount++;
			}
		}

		if (successCount == 0) {
			result.put("success", false);
			result.put("msg", "没有成功更新任何参数");
			result.put("count", 0);
			result.put("failCount", failCount);
			result.put("updatedNames", updatedNames);
			return result;
		}

		Map log = new HashMap();
		log.put("content", "更新系统开关：" + String.join("；",logList));
		log.put("cid", "");
		systemService.addSysLog(log);

		result.put("success", true);
		result.put("msg", failCount > 0 ? "部分更新成功" : "更新成功");
		result.put("count", successCount);
		result.put("failCount", failCount);
		result.put("updatedNames", updatedNames);
		return result;
	}

	@RequestMapping("/toSetAISecret")
	public String toSetAISecret(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		return "jsp/system/setAISecret";
	}

	@RequestMapping("/toSetAISecretV2")
	public String toSetAISecretV2(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		return "jsp/system/setAISecretV2";
	}

	@RequestMapping("/toSetTTSAISecret")
	public String toSetTTSAISecret(){
		if (!getSubject().hasRole("administrator")) {
			return "jsp/notTheRole";
		}
		return "jsp/system/setTTSAISecret";
	}

	@RequestMapping("/updateAISecretV2Data")
	public @ResponseBody Map<String, Object> updateAISecretV2Data() throws Exception {
		Map<String, Object> rtn = new HashMap<>();
		if (getUserInfo() == null || !getSubject().hasRole("administrator")) {
			rtn.put("status", "fail");
			rtn.put("info", "权限不足！");
			return rtn;
		}

		Map<String, Object> param = new HashMap<>();
		param.put("name", "AI_V2_switch");
		String AISwitch = getPara("AI_V2_switch");
		String AIExampaperTestSwitch = "0".equals(AISwitch)?"0":getPara("AI_exampaper_test_switch");
		boolean change = false;
		if(StringUtils.isNotBlank(getPara("APIKey"))){
			change = true;
			QuestionGeneratorConfig.setAPIKeyV2(getPara("APIKey"));
		}

		if (change) {
			String originKey = AES.generateRandomKey(32);
			param.put("yl_2", AES.aesEncryptGCM(QuestionGeneratorConfig.getAPIKeyV2(), originKey));
			originKey = AES.aesEncrypt(originKey);
			param.put("yl_5", originKey);
		}
		param.put("yl_1", AISwitch);
		param.put("yl_3", AIExampaperTestSwitch);
		systemService.updateSystemParam(param);
		if("1".equals(AISwitch) && StringUtils.isNotBlank(QuestionGeneratorConfig.getAPIKeyV2())){
			getApplication().setAttribute("AI_V2_switch","1");
			getApplication().setAttribute("AI_exampaper_test_switch",AIExampaperTestSwitch);
			QuestionGenerateThreadPool.getInstance().restartThreadPool();
		}else {
			getApplication().setAttribute("AI_V2_switch","0");
			getApplication().setAttribute("AI_exampaper_test_switch","0");
			QuestionGenerateThreadPool.getInstance().shutdownThreadPool();
		}

		rtn.put("status", "success");
		rtn.put("info", "操作成功！");
		return rtn;
	}

	@RequestMapping("/updateTTSParam")
	public @ResponseBody Map<String, Object> updateTTSParam() {
		Map<String, Object> rtn = new HashMap<>();
		if (getUserInfo() == null || !getSubject().hasRole("administrator")) {
			rtn.put("status", "fail");
			rtn.put("info", "权限不足！");
			return rtn;
		}
		Map<String, Object> keyForTTS = (Map<String, Object>) getApplication().getAttribute("AI_En_TTS");

		Map<String, Object> param = new HashMap<>();
		param.put("name", "AI_En_TTS_switch");
		param.put("yl_1", getPara("AI_En_TTS_switch"));
		keyForTTS.put("YL_1",getPara("AI_En_TTS_switch"));
		param.put("yl_2", getPara("appId"));
		keyForTTS.put("YL_2",getPara("appId"));
		param.put("yl_3", getPara("apiSecret"));
		keyForTTS.put("YL_3",getPara("apiSecret"));
		param.put("yl_4", getPara("apiKey"));
		keyForTTS.put("YL_4",getPara("apiKey"));
		param.put("yl_5", getPara("tempDir"));
		keyForTTS.put("YL_5",getPara("tempDir"));
		systemService.updateSystemParam(param);

		rtn.put("status", "success");
		rtn.put("info", "操作成功！");
		return rtn;
	}
}
