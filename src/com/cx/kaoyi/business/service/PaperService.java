package com.cx.kaoyi.business.service;

import com.cx.kaoyi.business.domain.Theme;
import com.cx.kaoyi.business.domain.exampaper.db.ExampaperAnswerDb;
import com.cx.kaoyi.business.domain.exampaper.db.ExampaperQuestionDb;
import com.cx.kaoyi.business.domain.exampaper.db.ExampaperQuestionTypeDb;
import com.cx.kaoyi.framework.utils.PageUtils;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

public interface PaperService {

	public String getExamInfoID();

	public int addExamInfo(Map param);
	
	public int addBExamInfo(Map param);

	public int updateExamQuestionType(Map param);	
	
	public int addExampaperCourse(Map param);

	public int updateQuestionScore(Map param);
	
	public List<Map<String, Object>> getRandomQuestion(Map param);

	public List<Map<String, Object>> getExampaperQuestionTypeList(String ei_id);
	
	public List<Map<String, Object>> getPaperList(Map param, PageUtils pu);
	
	public List<Map<String, Object>> getQuestionFromPaper(Map param, PageUtils pu);

	public int updatePaperQuestionType(Map param);
	
	public int updatePaperQuestionTypeQTTime(Map param);

	public List<Map<String, Object>> getExampaperQuestionList(Map param, PageUtils pu);

	List<String> findExampaperIllegalAnswerQids(String eid);
	
	public List<Map<String, Object>> getExampaperQuestionList4xls(Map param);

	public String getExampaperQuestionCount(Map param);
	
	public String getQuestionFromPaperCount(Map param);

	public String getPaperCount(Map param);
	
	public List<Map<String, Object>> getExampaperQuestionParam(String ei_id);
	
	public List<Map<String, Object>> getExampaperQuestionParamSpec(Map map);

	public String getQuestionCount(Map param);

	Map<String, BigDecimal> getThemeLevelStatsForPaper(String eid);

	List<Map<String,Object>> getQuestion4adjustOrder(Map map);

	String movePaperQuestionOrder(Map map);
	
	public List<Map<String,Object>> getThemeCount4ForseePaper(Map param);
	
	public List<Map<String,Object>> getAllDiff4ForseePaper(Map param);
	
	public List<Map<String,Object>> getAllKnow4ForseePaper(Map param);
	
	public List<Map<String,Object>> getAllCogn4ForseePaper(Map param);
	
	public List<Map<String,Object>> getAllQt4ForseePaper(Map param);
	
	public List<Map<String,Object>> getRealDiff4ForseePaper(String eid);
	
	public List<Map<String, Object>> getPaperDifficultyDistribution(Map param);

	public List<Map<String, Object>> getPaperKnowledgeDistribution(Map param);

	public List<Map<String, Object>> getPaperCognitionDistribution(Map param);

	public List<Map<String, Object>> getPaperQuestionTypeDistribution(Map param);
	
	public List<Map<String, Object>> getPaperWjDistribution(Map param);

	public List<Map<String, Object>> getExamObject(String ei_id);
	
	public List<Map<String, Object>> getUnitBySpecialty(List<String> speList);
	
	public Map<String, Object> getExamInfo(String ei_id);
	
	public Map<String, Object> getExamInfoByTypeID(Map param);
	
	public Map<String, Object> getCourseByTypeID(Map param);
	
	public int deleteExampaperQuestionByEIID(String ei_id);
	
	public List<Map<String, Object>> getPaperQuestion(Map param, PageUtils pu);
	
	public int deleteExampaperQuestion(Map param);

	public int updateExampaperQuestion(Map param);
	
	public int addQuestionIntoPaper(Map param);
	
	public List<Map<String, Object>> getTeacherByUnitID(String unitID);
	
	public int updateExamInfo(Map param);
	
	public int updateRawExamInfo(Map param);
	
	public int deleteExampaper(String eid);

	public List<Map<String, Object>> getMqids(Map param);
	
	public List<Map<String, Object>> getTeacherMarkPaper(String userId, int isMobile);

	public List<Map<String, Object>> selectThemeFromPaper(String eid);
	
	public List<Map<String, Object>> selectThemeFromPaper_course(Map param);

	public List<Map<String, Object>> selectDifficultyFromPaper(String eid);

	public List<Map<String, Object>> selectKnowledgeFromPaper(String eid);

	public List<Map<String, Object>> selectQuestionTypeFromPaper(String eid);

	public List<Map<String, Object>> selectCognitionFromPaper(String eid);	

	public List<Map<String, Object>> getPaper(String eid);	

	public List<Map<String, Object>> getPaperQuestiontype(String eid);

	int copyPaper(String bid, String aid, boolean isShuffle);

	public int delExampaperQuestion(String eid);
	
	public int delExampaperQuestionParam(String eid);
	
	public int delExampaperQuestionType(String eid);
	
	//public int delExamInfo(String eid);
	
	public int addExamInfo4MultiCourse(Map param);
	
	public List<Map<String, Object>> getPaperQuestiontypeScore(String eid);
	
	public List<Map<String, Object>> getPaperQuestionScore(Map param);
	
	public int addBExampaperCourse(Map param);
	
	public int addCExampaperCourse(Map param);
	
	public double getTotalPoints(String eid);
	
	public int getQTAnswertime(String eid);
	
	public List<Map<String, Object>> getUseTimeAndScore(String eid);

	//public void updateExaminfoCids(Map m);
	
	public List<Map<String, Object>> getExamInfoByEid_Tid(Map param);

	public int updateReloadPaper(String ei_id);
	
	public Map<String,Object> getMqids_extra(Map param);
	
	public List<Map<String,Object>> getBrachByMqid(List<Map<String,Object>> param);
	
	public int structurePaper(Map param);

	public List<Map<String, Object>> getPaperNoScore(String eid);

	public int deleteExampaperQuestionType(String eid);

	public int deleteExampaperQuestionParam(String eid);

	public List<Map<String, Object>> getPaperQtCountAndSum(String ei_id);

	public List<Map<String, Object>> getPaperCheckScoreDiffAndScore(Map m);

	public String getPaperQuestionCountForCheckList(Map m);

	public List<Map<String, Object>> getPaperCheckList(Map param);

	List<Map<String,Object>> getPaperCheckListAll(Map param);

	public List<Map<String, Object>> getExamPaperQuestionType(Map param);
	
	public Map<String, Object> getQuestion_AnswerByQID(Map param);
	
	public Map<String, Object> getQuestionPrevew(Map param);
	
	
	public List<Map<String, Object>> getBranchQuestion_AnswerByQID(Map param);
	
	public Map<String, Object> getLastQuestion(Map param);
	
	public Map<String, Object> getNextQuestion(Map param);
	
	public int addExampaperMainQuestion_2(Map param);
	
	public Map<String, Object> getQuestionInfo(Map param);
	
	public String getCidByQid(Map param);
	
	public int updateQuestion(Map param);
	
	public int generateBpaper(Map param);
	
	public List<Map<String, Object>> getQuestionTypeExplain(String ei_id);
	
	public int rebuildB(String eid);
	
	public int rebuildA(String eid);
	
	public int addQuestionIntoPaperFromPaper(Map param);
	
	public int addQuestion4CombinePaper(Map param);
	
	public int adjustPaper_back(String eid);

	public int updatePaperQuestionNum(String eid);

	public String getQuestionTotalTime(String eid);
	
	public Map<String, Object> getMqids_null(Map param);
	
	public List<Map<String, Object>> getAnswerByQID_Version(Map m);
	
	public List<Map<String, Object>> getPaperList4combinePaper(Map param, PageUtils pu);
	
	public String getPaperList4combinePaperCount(Map param);
	
	public List<Map<String,Object>> selectcidsByeids(Map m);
	
	public List<Map<String, Object>> getDistinctQID4combinePaperCount(Map param);
	
	public int addAllQuestionIntoPaperFromPaper(Map param);

	public int updateDefaultExamInfo(Map param);

	public List<Map<String, Object>> getDefaultExamInfo(String id);

	public String getENameByID(String eid);

	public List<Map<String, Object>> getMultiCourseStructureQSum(String ei_id);

	public int saveCheckList(Map m);
	
	public int saveCheckList_nonexist(Map m);
	
	public List<Map<String,Object>> getCheckList(String eid);

	public int getTemplateCount(Map m);

	public List<String> getTemplateByCid(String cid);

	public List<Map<String, Object>> getTemplateDetail(Map param);
	
	public List<Map<String, Object>> getWjQuestion(Map param, PageUtils pu);
	
	public String getWjQuestionCount(Map param);
	
	public int updateStudentExamEndTime(Map input);

	public List<Map<String, Object>> getPaperAnswerByQID(Map m);

	List<Map<String, Object>> findRepeatQuestions(Map param);

	List<Map<String, Object>> findRepeatQuestionsWithAnswer(List<Map<String, Object>> qlist);

	Map<String,Object> findTwoPaperRepeatQuestions(String eid1, String eid2, int answerMatch);
	public List<Map<String,Object>> getPaperTheme2List(Map param);
	
	public List<Map<String,Object>> getPaperTheme3List(Map param);
	
	public List<Map<String,Object>> getExampaperQuestionOrder(String ei_id);
	
	public List<Map<String,Object>> getExampaperQtTypeOrder(String ei_id);
	
	public List<Map<String,Object>> getAllExamPaper();
	
	public void updatePaperQuestionOrder(String ei_id);
	
	public void batchUpdateQorder(String ei_id);
	
	public Map<String, Object> getPaperFilter(Map param);
	
	public List<Map<String,Object>> getPaper_CourseName(String[] cids);
	
	public void updatePaperScore(Map map);
	
	public List<Map<String, Object>> getGrade4ExamInfo();
	
	/* public List<Map<String, Object>> getUnit4ExamInfo(); */

	public Map<String, Object> getFilterByCourseAttrs(List<Map<String, Object>> courseList);

	public List<Map<String, Object>> getThemeFromPaperCid(Map mm);

	List<Theme> getThemeFromPaperCidAll(Map m);

	public List<Map<String, Object>> getExamPaperCourse(String sid);

	public List<Map<String, Object>> getStudentExampaperQuestionTypeList(String ei_id);

	public int updateStudentExamInfo(Map param);

	public List<Map<String, Object>> getDifficultQuestionCount(Map param);

	public List<Map<String, Object>> getThemeCountByCidAndDid(Map param);

	public List<Map<String, Object>> getDifficultQids(Map m);

	public void addQuestionIntoPaper4Diff(Map param);

//	public void addQuestionParam2Paper(String ei_id);

	public List<Map<String, Object>> getMqids_Diff(List<String> qids);

	public void saveExaminfoQuestionFilterParam(Map par);

	public List<Map<String, Object>> getmQuestionCount_diff(Map param);

	public List<Map<String, Object>> getMqids4DiffStructure(Map param);

	public List<Map<String, Object>> getQuestionTypeParamByQtids(Map param);

	public int addExampaperQuestionParam(Map param);

	public List<Map<String, Object>> getThemeQSumAndQCount(Map param);
	
	public List<Map<String, Object>> getPaperQuestionBranch4Xls(Map param);
	
	public int insertPaperQuestion(List<Map<String, Object>> list);

	void insertAnswerForUnion(List<Map<String, Object>> list);
	
	public List<Map<String,Object>> getExamQuestionTime(String eid);
	
	public int getExamQuestionTimeSum(String eid);

	public int updateExampaperCourse(Map param);
	
	public int getMaxThFromExampaperquestion(String eid);
	
	public List<Map<String,Object>> getQnum_qtid(String eid);
	
	public List<Map<String,Object>> getDept4Paper(String eid);
	
	public String checkOption(String eid);
	
	public int getRandomanswer(String eid);
	
	public int separateOption(Map param);

	public int deleteTemplateByName (String name);
	
	public Map<String, Object> getZF_qtid(Map param);
	
	public Map<String, Object> getZF_qids(Map param);

	public void call_updateCoursePapercount(String cid);

	public Map<String,Object> getLastVerifyInfo(String eid);

	public void updatePaperMainQScore(Map map);

	List<Map<String, Object>> getAllTheme_cid(String cid);

	List<Map<String,Object>> getThemeConcat(String eid);

	List<Map<String,Object>> getPaper_theme(String eid);
	
	String getState4Exam(String eid);

	public List<Map<String,Object>> selectReleCid4Paper(String eid);
	Map<String, Object> getPaperInfo(String eid);
	
	List<Map<String,Object>> getJWC_KCDM();

	List<Map<String, Object>> getPapersByIds(List<String> paperIds);

	List<ExampaperQuestionDb> getExampaperQuestionRaw(String eid);

	List<ExampaperAnswerDb> getExampaperAnswerRaw(String eid);

	List<ExampaperQuestionTypeDb> getExampaperQuestionTypeRaw(String eid);

	int checkUnit(Map param);

	public int addQuestionIntoTK(Map param);

	public int addAnswerIntoTK(Map param);

	public int updateQid(Map param);

	public int updateAid(Map param);

	public int updateQuestion4TK(Map param);
}
