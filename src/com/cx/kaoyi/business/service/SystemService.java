package com.cx.kaoyi.business.service;

import java.util.List;
import java.util.Map;

import com.cx.kaoyi.framework.utils.PageUtils;

public interface SystemService {
	
	public List<Map<String, Object>> getUnitList(Map param, PageUtils pu);
	
	public List<Map<String, Object>> getAllUnit(Map param);
	
	public List<Map<String, Object>> getDepartmentList(Map param, PageUtils pu);
	
	public List<Map<String, Object>> getSpecialtyList(Map param, PageUtils pu);
	
	public String getDefaultQuestionTypeCount(Map param);
	
	public int insertQuestionType(Map param);

	public int addSchoolYear(Map param);

	public String getSchoolYearByName(Map param);
	
	public String getUnitCount(Map param);
	
	public String getDepartmentCount(Map param);
	
	public String getSpecialtyCount(Map param);
	
	public String getExamtypeCount(Map param);
	
	public String getAddrCount(Map param);

	public int insertUnit(Map param);

	List<String> getServerNameList();

	int addServerName(String serverName);

	int deleteServerName(String serverName);

	public int insertDepartment(Map param);

	public int insertSpecialty(Map param);
	
	public int insertExamtype(Map param);

	public int insertAddr(Map param);

	public int updateDep(Map param);

	public int updateUnit(Map param);

	public int updateSpecialty(Map param);
	
	public int updateExamtype(Map param);

	public int updateAddr(Map param);
	
	public int delUnit(Map param);
	
	public int delDep(Map param);
	
	public int delSpecialty(Map param);
	
	public int delExamtype(Map param);
	
	public int del(Map param);
	
	public int delQuestionType(Map param);
	
	public int delAddr(String id);
	
	public int delByDate(Map param);

	int addOnlineSysLog(String content);

	int addOnlineStuSysLog(String content);
	
	public int addSysLog(Map param);

	int addAnySysLog(Map param);

	public int addDelQuestionSysLog(Map param);
	
	public int addSysLog_student(Map param);
	
	public int addSysLog_noLogin(Map param);
	
	public List<Map<String,Object>> getLogsList(Map param,PageUtils pu);
	
	public String getLogsCount(Map param);
	
	public List<Map<String,Object>> getLogsListBefore(String time);
	
	public int delLogsBefore(String time);
	
	public int insertGrade(String gname);

	public int delCourseSpecialty(Map param);

	public Map<String,Map<String,Object>> getAllSystemParam();
	
	public Map<String,Object> getSystemParam(String name);
	
	public int updateSystemParam(Map param);

	public String getUnitNameById(String unitId);

	public String getAddrByID(String id);

	public String getSpNameByID(String id);
	
	public String getEmNameByID(String id);

	public int updateQuestionTypeOrder(String[] qtids);
	
	public int updateQuestionType(Map map);

	public int recSpecialty(String id);

	int updateStudentSpecialtyInSelf();
	
	public int recExamtype(String id);

	public int getRepeatSpecialty(Map map);
	
	public int getRepeatExamtype(Map map);

	public int getRepeatUnit(Map param);

//	public int delDepByUid(String uid);

	public int getRepeatDep(Map param);

	public int recUnit(String para);

	public int recDep(String para);

	public String getDeptByID(String para);
	
	public int updateTeacherPermission(Map param);

	public int deleteUnit(String para);

	public List<Map<String, Object>> getCourseNameByUnit(String para);

	public List<Map<String, Object>> getTeacherNameByUnit(String para);

	public String getDepartmentNameByUnit(String para);

	public int delDepByUid(Map param);

	public Object getStudentLoginRecord(Map m, PageUtils pu);

	public String getStudentLoginRecordTotal(Map m);
	
	public List<Map<String,Object>> getMenuPermission();
	
	public List<Map<String,Object>> getAllMenuRole();
	
	public int saveMenuPermission(Map param);
	
	public int saveMenuOrder(String mid, String direction);
	
//	public HSSFWorkbook exportPaperQuestion(String eid);
	
	public List<Map<String,Object>> findAllTeacher();

	public List<Map<String,Object>> findNotLoginTeacher();
	
	public void resetPass(Map param);

	int clearListeningRecord();
	
}
