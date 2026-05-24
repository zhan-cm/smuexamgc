package com.cx.kaoyi.business.service;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import com.cx.kaoyi.framework.GPT.generateDTO.QuestionGeneratedParam;
import com.cx.kaoyi.framework.utils.PageUtils;
import org.springframework.web.multipart.MultipartFile;

public interface QuestionService {

	String getQuestionID();
	
	String getAnswerID();
	
	List<Map<String, Object>> getDelQuestion45(String nowDay);

	String getQuestionCount(Map param);

	List<Map<String, Object>> getQuestion(Map param, PageUtils pu);

	List<String> findCourseIllegalAnswerQids(String cid);
	
	List<Map<String, Object>> getQuestionDetail(Map param);
	
	//List<Map<String, Object>> getQuestionByCID(Map param);
	
	Map<String, Object> getQuestionInfo(Map param);
	
	/**
	 * 获取试题的预览信息
	 * @author 洪艳
	 * @param param
	 * @return
	 */
	Map<String,Object> getQuestionPrevew(Map param);
	
	Map<String, Object> getQuestionCon(Map param);
	
	int insertQuestion(Map param);
	
//	int insertQuestion4ExcelImport(Map param);
	int insertMainQuestion4TransferData(Map param);
	
//	int updateBranchQuestion(Map param);
	
	int verifyQuestion(Map param);
	
	int LastVerifyQuestion(Map param);
	
	Map<String,Object> deleteQuestion(Map param);

	Map<String,Object> deleteQuestionReal(Map param);

	Map<String,Object> recoverSelect(Map param);

	List<Map<String, Object>> getDistributionStatistics(Map param);
	
	List<Map<String, Object>> getDifficultyDistribution(String c_id);
	
	List<Map<String, Object>> getDifficultyDistribution2(Map param);
	
	List<Map<String, Object>> getCognitionDistribution(String c_id);
	
	List<Map<String, Object>> getKnowledgeDistribution(String c_id);
	
	List<Map<String, Object>> getQuestionTypeInfo(Map param);
	
	List<Map<String, Object>> getQuestionByQID(String qid);
	
	List<Map<String, Object>> getBranchQuestion_AnswerByQID(String mqid,int atid);
	
	Map<String, Object> getQuestion_AnswerByQID(Map param);
	
	//String getAnswerType(String qtid);

	List<Map<String, Object>> getAnswerByQID(Map param);
	
	public Map<String, Object> getThemeIdByName(Map param);
	
	public Map<String, Object> getCognitionId(String coname);
	
	public Map<String, Object> getSourceId(String soname);
	
	public Map<String, Object> getKnowledgeId(String kname);

	public Map<String, Object> getDifficultyId(String dname);

	public int delAll(Map courseinfo,String path);
	
	public String getCidByQid(String qid);

	public List<Map<String, Object>> writeQuestionXls(Map m);
	
	public int updateNum_testtime(Map m);
	
	List<Map<String,Object>> selectAnswerByQID(String qid);
	
	String getAnswerID4ExcelImport();
	
	//List<Map<String,Object>> getRelePaperByQid(Map param);
	
	void delAnswer(String qid);
	
	Map<String, Object> getQtByQtnameFromCourse_QuestionType(Map param) ;
	Map<String, Object> getQtByQtnameFromQuestionType(Map param) ;
	
	
	void insertQt4Transfer(Map param);
	
	List<Map<String, Object>> findRepeatQuestions(Map param);

	List<Map<String, Object>> findRepeatQuestionsWithAnswer(List<Map<String, Object>> list);
	
//	List<Map<String, Object>> getVerifyNum(String cid);
//	
//	List<Map<String, Object>> getCreateNum(String cid);

	Map<String, List<Map<String, Object>>> getWorkLoad(Map<String, Object> param);

	List<Map<String, Object>> getWorkLoadTotalAll(Map param);
	
/*	List<Map<String, Object>> getVerifyCount(String cid);
	
	List<Map<String, Object>> getCreateCount(String cid);*/
	
	List<Map<String, Object>> getUsedQuestionTypeByCid(String cid);

	Map<String,Object> getPrevAndNextQuestion(Map param);
	
	int checkQuestionPermission(Map param,String username);
	
	int checkQuestionState(Map param);
	
	int updateQuestionWithNoVersion(Map param);
	
	List<Map<String,Object>> getAllQT4CourseQuestion(Map param);
	
	List<Map<String,Object>> getAllQT4CourseQuestion2(Map param);
	
	BigDecimal getQuestionCount4Distribution(String cid);
	
	int insertQuestion4TransferData(Map param);

	int updateMqid4TransferData(Map param);
	
//	int updateQuestionNum2(String cid);

	List<Map<String, Object>> checkThemeExist(Map m);

	Map<String, Object> getQuestionFilter(String cid);
	
	String getAllQuestionCount(Map param);

//	String getThemeId();
	
	List<Map<String, Object>> getSameAtidQuestionTypeByQid(String qid);
	
	int insertThemeForImportQuestion(List themeList);

	List<Map<String, Object>> getRepeatQuestionForImportQuestion(Map mainQuestion);

	int insertQuestionForImportQuestion(List<Map<String, Object>> questionlist);

	void insertAnswerForImportQuestion(List<Map<String, Object>> answerlist);

	List getRepeatAnswerContent(Map param);
	
	List<Map<String,Object>> getQuestionFilterByTheme1(String cid);
	
	List<Map<String,Object>> getQuestionFilterByTheme1_2(Map param);

	int insertTheme4ImportQuestion(Map param);

	List<Map<String, Object>> getQuestionBranch4Xls(Map param);
	
	Map<String, Object> getQuestionByQID4CopyQuestion(Map param);
	int insertQuestion4CopyQuestion(Map param);

	int updateQuestionTarget(Map param);

	Map<String,Object> selectTarget(Map param);
	
	/*用于修正answertime,后面可删除*/
	List<Map<String,Object>> getAnswertime(Map param);
	void batchUpdateAnswertime(List<Map<String,Object>> list);
	List<Map<String,Object>> getPaperAnswertime(Map param);
	void batchUpdatePaperAnswertime(List<Map<String,Object>> list);
	/*用于修正answertime,后面可删除*/
	
	List<Map<String, Object>> getQuestion4StudentEnd(Map param, PageUtils pu);
	
	String getQuestionCount4StudentEnd(Map param);
	
	Map<String,Object> getQtByQtid(Map param);

	int clearQuestionNum(String id);/*清除试题使用次数 num字段*/

	List<Map<String, Object>> getQuestionTypeInfo_t3(Map param);

	void call_updateCourseQuestioncount(String cid);
	
	int getAllQuestionCountBycid(String cid);
}
