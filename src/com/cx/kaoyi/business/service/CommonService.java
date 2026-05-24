package com.cx.kaoyi.business.service;

import com.cx.kaoyi.framework.base.IPRange;

import java.util.List;
import java.util.Map;

public interface CommonService {

	List<Map<String, Object>> getMenus(Map param);
	
	List<Map<String, Object>> defaultCognition();
	
	List<Map<String, Object>> defaultArrangement();
	
	List<Map<String, Object>> defaultDifficulty();
	
	List<Map<String, Object>> defaultExamType();
	
	List<Map<String, Object>> defaultKnowledge();
	
	List<Map<String, Object>> defaultQuestionType();

	List<Map<String, Object>> defaultSource();

	List<Map<String, Object>> defaultSpecialty();

	void initSpecialtyAndUnit();

	void initGlobalPermissions();
	
	List<Map<String, Object>> defaultUnit();
	
	List<Map<String, Object>> defaultDepartment();
	
	List<Map<String, Object>> getDeptList(String u_id);
	
	Map<String, Object> getAnswerType(Map map);

	List<Map<String, Object>> getSchoolYear();
	
	List<Map<String, Object>> getTerm();
	
	List<Map<String, Object>> getExamWay();
	
	List<Map<String, Object>> getGrade();
	
	Map<String, Object> getGradeById(String id);
	
	List<Map<String, Object>> getSystemTime();
	
	List<Map<String, Object>> getQueryScore();
	
	List<Map<String, Object>> getQueryPaper();
	
	List<Map<String, Object>> getTestMode();
	
	public List<Map<String, Object>> getAnswerSequence();
	
	List<Map<String, Object>> getCorrectPaper();
	
	List<Map<String, Object>> getForbidDay();
	
	List<Map<String, Object>> getTodayTest(Map param);
	
	List<Map<String, Object>> getRoles();
	
	List<Map<String,Object>> getTestQuestionByCache(Map<String,Object> m);
	
	List<Map<String,Object>> getTestQuestion(String eid);
	
	List<Map<String, Object>> getTestQuestionType(String eid);

	List<Map<String, Object>> getTestQuestionTypeByCache(String eid);

	int addSA(Map param);

	int updateAnswertime(Map param);
	
	int addSA1(Map param);
	
	int addSAQ(Map param);
	
	int addSAQT(Map param);

	List<Map<String, Object>> getSAQT(Map param);

	List<Map<String, Object>> getNotFinishSAQTInAllList(List<Map<String, Object>> allqtList, List<Map<String, Object>> notFinishQuestionList);

	List<Map<String, Object>> getNotFinishSAQ(Map param);
	
	List<Map<String, Object>> getFinishSAQ(Map param);
	
	List<Map<String, Object>> getAllSAQT(Map param);

	List<Map<String, Object>> getAllSAQ(Map param);

	Map<Integer, List<Map<String, Object>>> getFinishedOrNotFinishSAQ(Map param);
	
	List<String> checkScore(Map param);
	
	List<Map<String, Object>> getSAQOrder(Map param);
	
	int updateStudentExamIPAndTime(Map param);
	
	public int addStudentExam(Map param);
	
	public List<Map<String, Object>> getStudentExam(Map param);
	
	public Map<String, Object> getQuestionTypeByQTID(Map param);
	
	public int updateSAQT(Map param);
	
	public int removeOnlineID(Map param);
	
	public int updateStudentExam(Map param);
	
	public int updateStudentExamUseTime(Map param);

	public List<Map<String, Object>> getAccountCount(Map param);
	
	public int addCoursePer(Map param);

	public int delAddCoursePer(String tid,String username);
	
	public int insertAddCourse(String tid,String username);
	
	/**
	 * 获取角色的中文名称
	 * @author 洪艳
	 * @return List<Map<String, Object>>，包含了角色id和角色cname
	 */
	public List<Map<String, Object>> defaultRole();

	public List<Map<String, Object>> getRolesByUserRole(Map param);

	String getSystemTimeStrByID(String id);
	
	Integer getSystemTimeByID(String id);
	
/*	public List<Map<String, Object>> getSpecialtyByUnit(String unitid);*/
	
	public String getNearSystemTimeId(String name);
	
	public List<Map<String, Object>> getRolesByUserRole_2(Map param);

	public List<Map<String, Object>> findCidsBySpecialty(String id);

	public String getCRole(String id);

	public String getTeacherHavingAddUserPermission(String tid);
	
	public String getAddCoursePermission(String tid);
	
	public List<Map<String,Object>> getStudentJwList();
	
	public Map<String,Object> getUnitByName(String unitname);
	
	public Map<String, Object> getSpecialtyByName(Map param);
	
	public String getUnitId();
	
	public int insertUnit(Map param);
	
	public String getSpeId();
	
	public int insertSpecial(Map param);
	
	public Map<String, Object> getGradeByName(String gradename);
	
	public String getGradeId() ;
	
	public int insertGrade(Map param);
	
	public Map<String, Object> getStudentByNum(Map param);
	
	public String getStuId();
	
	public int insertStudent(Map param);
	
	public int updateStudent(Map param);

	Map<String, Object> getUnitById(String id);

	Map<String, Object> getDeptById(String id);

	List<Map<String, Object>> getCognitionList();

	List<Map<String, Object>> getSourceList();

	List<Map<String, Object>> getKnowledgeList();

	List<Map<String, Object>> getDifficultyList();

	List<Map<String, Object>> getStudentMenu();

	int getQtIsconByQtid(Map m);

	List<Map<String, Object>> getAnswerTypeList();
	
	int addStudentLoginRecord(Map map);
	
	int addSA_mode3(Map param);
	
	Map<String, Integer> getQnumGroupByQtype(List<Map<String,Object>> exampaperQuestion);

	int checkStudentExam(Map param);
	//List<Map<String,Object>> checkStudentExam(Map param);

	int updateSAQTTime(Map param);

	List<Map<String, Object>> getJwUnitList();

	String getJwUnitIDFromUnit(String uname);

	int updateJwUnit(Map param);

	int updateUnit(Map param);

	List<Map<String, Object>> getJwDeptList();

	String getDeptByName(Map param);

	int insertDept(Map param);

	int updateDept(Map par);

	int updateJwDeptId(Map par);

	List<Map<String, Object>> getJwTeacherList();
	
	List<Map<String,Object>> getAddUser_coursePermission(String tid);
	
	int updateStudentQtypeUseTime(Map param);
	
	int addStudentExam4AutoTest(Map param);
	
	List<Map<String, Object>> getMTtodayTest();
	
	List<Map<String,Object>> getExamObject(Map<String,Object> param);
	
	Map<String, Object> getStudentExamState(Map param);
	
	Map<String,Object> getQuestion(Map param);
	
	List<Map<String,Object>> getTestQuestion_qid(Map param);
	
	List<Map<String, Object>> getSAQ_yc(Map param);
	
	List<Map<String, Object>> getSAQT_yc(Map param);

	String updateIpRecord(Map param);
	Map<String,Object> calculateQuestionBankData(boolean isAuto);
}
