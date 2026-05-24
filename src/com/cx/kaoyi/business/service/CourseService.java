package com.cx.kaoyi.business.service;

import java.util.List;
import java.util.Map;

import com.cx.kaoyi.business.domain.Theme;
import com.cx.kaoyi.framework.utils.PageUtils;

public interface CourseService {

	/**
	 * 分页获取课程列表，可根据课程名、单位id精准或模糊查询
	 * @author 张智霖、洪艳
	 * @param param【cname课程名、unitid单位id、sort？、order？】
	 * @param pu
	 * @return List<Map<String, Object>>，包括课程基本信息、试题总数、试卷总数
	 */
	List<Map<String, Object>> getCourse(Map param, PageUtils pu);
	List<Map<String, Object>> getUnVerifiedCourse(Map param, PageUtils pu);
	Integer getUnVerifiedCourseCount(Map param);

	List<Map<String, Object>> getCourse4TeacherOffice(Map param, PageUtils pu);

	String getCourseCount4TeacherOffice(Map param);

	public List<Map<String, Object>> getCourse(Map param);

	public List<Map<String, Object>> getDelQueCourse(Map param, PageUtils pu);
	
	public List<Map<String, Object>> getQueCourse(Map param, PageUtils pu);

	public List<String> getCourseByDelQue();
	
	public List<Map<String, Object>> getCourseAttr(String c_id);
	
	public List<Map<String, Object>> getCourseList(Map param);
	
	public List<Map<String, Object>> getCourseListByUnid(Map param);
	
	public String getCourseID();
	
	public String getCount(Map param);
	
	public int deleteCourse(String  c_id);
	int updateCourseState(String cid, int state, String remark);

	//public int addQuestionType(Map param);
	
	/**
	 * 添加课程的业务方法
	 * @author 张智霖、洪艳
	 * @param param
	 * @return int（1：添加成功）
	 */
	public int insertCourse(Map param);
	
	public int updateCourse(Map param);
	
	public int addArrangement(Map param);
	
	public int addKnowledge(Map param);
	
	public int addDifficulty(Map param);
	
	public int addExamType(Map param);
	
	public int addCognition(Map param);	
	
	public int addSource(Map param);
	
	public List<Map<String, Object>> getThemeList(Map param);
	
	public int insertTheme(Map param);
	
	public String getThemeCount(Map param);
	
	public int deleteTheme(String th_id);
	
	public int updateTheme(Map param);
	
	public List<Map<String, Object>> getExplainQuestionType(Map param);

	public List<Map<String, Object>> getCourseCount_cidList(Map param);

	public String getCourseCount(Map param);
	
	public int addThemeFromExcel(Map param);
	
	public List<Map<String, Object>> getParantThemeID(Map param);
	
	/**
	 * 根据课程ID查询课程中文名称，使用者：预览试题【QuestionController：previewQuestion】
	 * @author 洪艳
	 * @param cid
	 * @return cname
	 */
	public String getCourseCNameByCid(String cid);
	
	String getCourseCreator(String cid);

	String getCourseCreatorId(String cid);
	
	List<Map<String,List<String>>> getCourseRecordList(String cid);

	//获取包含题型ID
	List<Map<String, Object>> getQuestionTypeId();
	
	//获取适应层次ID
	public List<Map<String, Object>> getArrangementId();
	
	//获取考试类别ID
	public List<Map<String, Object>> getExamTypeId();
	
	//获取适用专业ID
	public List<Map<String, Object>> getSpecialtyId();
	
	//获取难度ID
	public List<Map<String, Object>> getDifficultyId();
	
	//获取知识点分布ID
	public List<Map<String, Object>> getKnowlegeId();
	
	//获取认知类别ID
	public List<Map<String, Object>> getCognitionId();
	
	//获取题源ID
	public List<Map<String, Object>> getSourceId();
	
	public List<Map<String, Object>> getEditCourseAttr(String c_id);

	public List<Map<String, Object>> getExportThemeExcel(String cid);
	
	public List<Map<String,Object>> selectEditQuestionType(String cid);
	
	public List<Map<String,Object>> selectEditCognition(String cid);
	
	public List<Map<String,Object>> selectEditArrangement(String cid);
	
	public List<Map<String,Object>> selectEditDifficulty(String cid);
	
	public List<Map<String,Object>> selectEditKnowledge(String cid);
	
	public List<Map<String,Object>> selectEditSource(String cid);
	
	public List<Map<String,Object>> selectTheme(String cid);
	
	public List<Map<String,Object>> selectTheme2(String cid);
	
	public List<Map<String,Object>> selectTheme3(String cid);
	
	public void updatePermissions(Map m);

	public int deleteAllTheme(String cid);
	
	public int checkCoursePermission(Map param,String uid_cid);
	
	public int checkCoursePermissionWithPID(Map param,String uid_pid);

	public List<Map<String, Object>> getCourseSpecialtyList(String cid);
	
	public List<Map<String,Object>> getWjQuestiontype();

	public List<Map<String, Object>> getCourseNameById(String[] cid);
	
	public List<Map<String, Object>> getCourse4Export(Map param);
	
	public List<Map<String, Object>> selectSpecialty(String id);
	
	public List<Map<String, Object>> selectArrangement(String id);
	
	//public Map<String,Object> selectQuestionTypeByID(String id);
	
	public List<Map<String, Object>> getCourseQuestionType(String cid);

	public List<Map<String, Object>> getCourseQuestionInfo(String cid);

	public List<Map<String, Object>> getStudentCourseList(Map param, PageUtils pu);

	public String getStudentCourseListCount(Map param);

	public int delAllThemeForNewCourse(String para);
	
	public List<Map<String,Object>> getQuestionQTGX(Map param);
	
	public List<Map<String, Object>> getCourseDifficult(String cid);

	public List<Map<String, Object>> getQuestionTypeByQtids(List list);
	
	public List<Map<String, Object>> getDetailList(Map param, PageUtils pu);
	
	public String getPaperCount(Map param);
	
	public int getThemeID();
	
	public List<Map<String, Object>> getDelCourse(Map param, PageUtils pu);
	
	public String getDelCourseCount(Map param);
	
	public int recoverCourse(String cid);
	
	public List<Map<String, Object>> getCourseCognition(String cid);

	public List<Map<String, Object>> getCourseSource(String cid);

	List<Map<String, Object>> getCourseKnowledge(String cid);

	List<Map<String, Object>> getCourseDifficulty(String cid);

	int addCourseQuestionType(Map param);
	
	List<Map<String,Object>> getCourseByUID_CID(Map param);
	
	int deleteCourseAll(String cid);
	
	int delCourseNotPaper(String cid);
	
	Map<String,Object> getCourseByCID(String cid);
	
	int updateCQ_QT(Map m);
	
	int importCourse(Map param);
	
	String getCourse_UnitID(String cid);
	
	int separateOption(Map param);

	boolean checkCreatorID(Map param);
	
	int setThemeOrder(Map param);
	
	List<Map<String,Object>> findCourseCode(String[] cids);

	List<Theme> getThemeTree(String cid, Long searchPid);

	boolean isThemeInQuestionOrExampaper(Map<String,Object> param);
}
