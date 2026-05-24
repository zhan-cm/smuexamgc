package com.cx.kaoyi.business.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.cx.kaoyi.framework.utils.PageUtils;

public interface VerifyService {

	public List<Map<String, Object>> getPaperList(Map param, PageUtils pu);

	public List<Map<String, Object>> getVerifiedPaperList(Map param);
	
	public List<Map<String, Object>> getAppointTeacher(Set param);
	
	public List<Map<String, Object>> getAllAuthorizedTeacher(Map param, PageUtils pu);
	
	public String getAllAuthorTeacherCount(Map param);
	
	public List<Map<String, Object>> getTeacherPermission(Map param);
	
	public List<Map<String, Object>> getAuthorPermission(Map param);
	
	public List<Map<String,Object>> getAudit_first(String eid);
	
	public List<Map<String,Object>> getAudit_last(String eid);
//	public List<Map<String, Object>> getAppointTeacher_roleid(Map param);
	
	public List<Map<String, Object>> getCourseList(Map param);
	
	public int deletePaperPerByUIDAndEID(Map param);
	
	public int deleteAuthorPaperPerByUIDAndEID(Map param);

	public int insertPaperPer(Map param);

	public int updatePaperPer(Map param);
	
	public int updateAuthorPaperPer(Map param);
	
	public List<Map<String, Object>> getTeacherPaPers(String eid);
	
	public String paperPerCount(Map param);
	
	public String getExamtype(String type);
	
	public List<Map<String, Object>> getPaperRight(String eid);
	
	public List<Map<String, Object>> getSubjectiveQuestion(String eid);
	
	public int insertCorrectPer(Map param);
	
	public int insertReviewPer(Map param);
	
	public Map<String, Object> getCorrectAndReviewPers(String eid);

	public int deletePaper(String eid, int state);
	
	public int deleteCorrectPer(Map param);
	
	public int deleteReviewPer(Map param);
	
	public String getBNum(String eid);
	
	public String getPaperCount(Map param);
	
	public String getVerifiedPaperCount(Map param);

	boolean checkViewPaperPermission(String eid);

	public int checkPaperPermission(Map param);
	
	public int toCompleteDel(String eid);
	
	public int completeDel(String eid);
	
	public int cancelDelPaper(String eid);
	
	public List<Map<String,Object>> getStudentClass(String eid);
	
	public int updateCorrectCla(Map param);
	
	public int insertCorrectCla(Map param);
	
	public int deleteCorrectCla(Map param);
	
	public List<Map<String,Object>> getTeacherClass(String eid);
	
	public List<Map<String, Object>> getPaperList4XP(Map param, PageUtils pu);
	
	public String getPaperCount4XP(Map param);

	List<Map<String,Object>> wxGetUnSubmitPaperList(Map param, PageUtils pu);

	public List<Map<String, Object>> getPaperListOfUnit(Map param, PageUtils pu);

	public String getPaperOfUnitCount(Map param);

	public Map<String,Object> getPaperUnit(String eid);

}
