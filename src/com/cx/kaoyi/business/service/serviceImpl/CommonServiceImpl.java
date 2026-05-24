package com.cx.kaoyi.business.service.serviceImpl;

import com.cx.kaoyi.framework.base.IPRange;

import com.cx.kaoyi.business.service.CommonService;

import com.cx.kaoyi.framework.base.BaseService;
import com.cx.kaoyi.framework.cache.LocalCache;

import com.cx.kaoyi.framework.shiro.LocalSessionDAO;
import com.cx.kaoyi.framework.utils.DateFormatUtils;
import com.cx.kaoyi.framework.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.ServletContext;
import java.text.SimpleDateFormat;
import java.time.Duration;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.*;
import java.util.stream.Collectors;

//CommonService实现类，除了已有的注释外，其余请查看相应的xml(与xml的ID相对应)
@Service("commonService")
public class CommonServiceImpl extends BaseService implements CommonService {

	@Autowired
	private LocalSessionDAO localSessionDAO;

	@Autowired
	private ServletContext servletContext;
	
	public static String namespace = "resources.mappers.common";
	
	@Override
	public List<Map<String, Object>> getMenus(Map param){
		return query(namespace + ".getMenus", param);
	}

	@Override
	public List<Map<String, Object>> defaultCognition() {
		return query(namespace + ".defaultCognition");
	}

	@Override
	public List<Map<String, Object>> defaultArrangement() {
		return query(namespace + ".defaultArrangement");
	}

	@Override
	public List<Map<String, Object>> defaultDifficulty() {
		return query(namespace + ".defaultDifficulty");
	}

	@Override
	public List<Map<String, Object>> defaultExamType() {
		return query(namespace + ".defaultExamType");
	}

	@Override
	public List<Map<String, Object>> defaultKnowledge() {
		return query(namespace + ".defaultKnowledge");
	}

	@Override
	public List<Map<String, Object>> defaultQuestionType() {
		return query(namespace + ".defaultQuestionType");
	}

	@Override
	public List<Map<String, Object>> defaultSource() {
		return query(namespace + ".defaultSource");
	}

	@Override
	public List<Map<String, Object>> defaultSpecialty() {
		List<Map<String,Object>> list=query(namespace + ".defaultSpecialty");
		for(int i=0;i<list.size();i++){
			if("所有专业".equals(String.valueOf(list.get(i).get("NAME")))){
				list.remove(i);
			}
		}
		return list;
	}

	@Override
	public void initSpecialtyAndUnit(){
		List<Map<String,Object>> specialtyList=query(namespace + ".defaultSpecialty");
		Map<String, String> specialtyMap = new HashMap<>();
		Map<String, String> specialtyUnitMap = new HashMap<>();
		for(int i=0;i<specialtyList.size();i++){
			if("所有专业".equals(String.valueOf(specialtyList.get(i).get("NAME")))){
				specialtyList.remove(i);
			}else{
				specialtyMap.put(String.valueOf(specialtyList.get(i).get("ID")), String.valueOf(specialtyList.get(i).get("NAME")));
				specialtyUnitMap.put(String.valueOf(specialtyList.get(i).get("ID")), String.valueOf(specialtyList.get(i).get("UNITID")));
			}
		}

		List<Map<String, Object>> unitList = query(namespace + ".defaultUnit");
		Map<String, String> unitMap = new HashMap<>();
		for(Map<String,Object> unit : unitList){
			unitMap.put(String.valueOf(unit.get("ID")), String.valueOf(unit.get("NAME")));
		}
		servletContext.setAttribute("specialtyMap", specialtyMap);//专业
		servletContext.setAttribute("specialtyUnitMap", specialtyUnitMap);//专业学院映射
		servletContext.setAttribute("specialtyList", specialtyList);	//默认专业列表
		servletContext.setAttribute("unitMap", unitMap);	//默认单位列表
		servletContext.setAttribute("unitList", unitList);	//默认单位列表
	}

	@Override
	public void initGlobalPermissions(){
		List<Map<String,Object>> permissions = query(namespace + ".getPermissions");
		List<Map<String,Object>> coursePermissions = new ArrayList<>();
		List<Map<String,Object>> questionPermissions = new ArrayList<>();
		List<Map<String,Object>> paperPermissions = new ArrayList<>();
		Set<String> excludedIds = new HashSet<>(Arrays.asList(
				"20", "10", "14", "34", "33", "30", "37", "38", "31"
		));
		for (Map<String,Object> p : permissions) {
			if (excludedIds.contains(p.get("ID"))) {
				continue;
			}
			String type = (String) p.get("TYPE");
			if ("course".equals(type)) {
				coursePermissions.add(p);
			} else if ("question".equals(type)) {
				questionPermissions.add(p);
			} else if ("paper".equals(type)) {
				paperPermissions.add(p);
			}
		}

		servletContext.setAttribute("permissions", permissions);
		servletContext.setAttribute("coursePermissions", coursePermissions);
		servletContext.setAttribute("questionPermissions", questionPermissions);
		servletContext.setAttribute("paperPermissions", paperPermissions);
	}

	@Override
	public List<Map<String, Object>> defaultDepartment() {
		return query(namespace + ".defaultDepartment");
	}
	
	@Override
	public List<Map<String, Object>> defaultUnit() {
		return query(namespace + ".defaultUnit");
	}

	@Override
	public List<Map<String, Object>> getDeptList(String u_id) {
		return query(namespace + ".getDeptList", u_id);
	}

	@Override
	public Map<String, Object> getAnswerType(Map map) {
		return query(namespace + ".getAnswerType", map).get(0);
	}

	@Override
	public List<Map<String, Object>> getSchoolYear() {
		return query(namespace + ".getSchoolYear");
	}

	@Override
	public List<Map<String, Object>> getTerm() {
		return query(namespace + ".getTerm");
	}

	@Override
	public List<Map<String, Object>> getExamWay() {
		return query(namespace + ".getExamWay");
	}

	@Override
	public List<Map<String, Object>> getGrade() {
		List<Map<String,Object>> list = query(namespace + ".getGrade");
		//Map<String,Object> map=null;
		for(int i=0;i<list.size();i++){
			if("所有年级".equals(String.valueOf(list.get(i).get("NAME")))){
				//map=list.get(i);
				list.remove(i);
			}
		}
		/*
		if(map!=null){
			list.add(0, map);
		}*/
		return list;
	}
	
	@Override
	public Map<String, Object> getGradeById(String id) {
		return (Map<String, Object>) queryOne(namespace + ".getGradeById",id);
	}

	@Override
	public List<Map<String, Object>> getSystemTime() {
		return query(namespace + ".getSystemTime");
	}

	@Override
	public List<Map<String, Object>> getQueryScore() {
		return query(namespace + ".getQueryScore");
	}

	@Override
	public List<Map<String, Object>> getQueryPaper() {
		return query(namespace + ".getQueryPaper");
	}

	@Override
	public List<Map<String, Object>> getTestMode() {
		return query(namespace + ".getTestMode");
	}

	@Override
	public List<Map<String, Object>> getAnswerSequence() {
		return query(namespace + ".getAnswerSequence");
	}

	@Override
	public List<Map<String, Object>> getCorrectPaper() {
		return query(namespace + ".getCorrectPaper");
	}

	@Override
	public List<Map<String, Object>> getForbidDay() {
		return query(namespace + ".getForbidDay");
	}
	
	@Override
	public List<Map<String, Object>> getTodayTest(Map param) {
		return query(namespace + ".getTodayTest",param);
	}

	@Override
	public List<Map<String,Object>> getTestQuestionByCache(Map<String, Object> m) {
		LocalCache cache = LocalCache.getInstance();
		String eid = (String) m.get("eid");
		List<Map<String,Object>> list = cache.get("exampaper_question", eid);
		if(list==null || list.isEmpty()){
			list = query(namespace + ".getTestQuestion", m);
			cache.set("exampaper_question",eid, list);
		}
		return list;
	}
	
	@Override
	public Map<String,Object> getQuestion(Map param){
		return queryOne(namespace+".getQuestion",param);
	}
	
	public List<Map<String,Object>> getTestQuestion(String eid) {
		return query(namespace + ".getTestQuestion", eid);
	}

	@Override
	public List<Map<String, Object>> getTestQuestionType(String eid) {
		return query(namespace + ".getTestQuestionType", eid);
	}

	@Override
	public List<Map<String, Object>> getTestQuestionTypeByCache(String eid){
		LocalCache cache = LocalCache.getInstance();
		List<Map<String,Object>> list = cache.get("exampaper_qtype", eid);
		if(list==null || list.isEmpty()){
			list = query(namespace + ".getTestQuestionType", eid);
			cache.set("exampaper_qtype",eid, list);
			return list;
		}
		return list;
	}

	@Override
	public int addSA(Map param) {
		List<Map<String,Object>>  list = query(namespace+".getStudentExamQuestion",param);
		int rtn = 0;
		Integer atid = Utils.changeObjToInt(param.get("atid"));
		String eid = (String) param.get("eid");
		String sid = (String) param.get("sid");
		String qid = (String) param.get("qid");
		Map<String,Object> stuAns = new HashMap<>();
		stuAns.put("qid", qid);
		stuAns.put("atid", param.get("atid"));
		stuAns.put("answertime", param.get("answertime"));
		LocalCache cache = LocalCache.getInstance();
		if((atid > 4 && atid < 8) || (atid > 9 && atid < 12)){
			if(param.get("content")!=null){ //只要不为空指针就行了，一律刷新缓存
				stuAns.put("content_6", param.get("content"));
				cache.set("stu_ans_exam", eid+"_"+sid+"_"+qid, stuAns);
			}
		}else {
			if(param.get("aid")!=null){
				stuAns.put("aid", param.get("aid"));
				cache.set("stu_ans_exam", eid+"_"+sid+"_"+qid, stuAns);
			}
		}
		if(list!=null && list.size()>0){
			update(namespace + ".updateStudentExamQuestion", param);
		}else{
			insert(namespace + ".addSA", param);
			rtn = 1;
		}
		update(namespace + ".updateSAQ", param);
		return rtn;
	}

	@Override
	public int updateAnswertime(Map param) {
		return update(namespace + ".updateAnswertime", param);
	}

	@Override
	public int addSA_mode3(Map param) {
		List<Map<String,Object>>  list = query(namespace+".getStudentExamQuestion",param);
		Integer atid = Utils.changeObjToInt(param.get("atid"));
		String eid = (String) param.get("eid");
		String sid = (String) param.get("sid");
		String qid = (String) param.get("qid");
		Map<String,Object> stuAns = new HashMap<>();
		stuAns.put("qid", qid);
		stuAns.put("atid", param.get("atid"));
		stuAns.put("answertime", param.get("answertime"));
		LocalCache cache = LocalCache.getInstance();
		if((atid > 4 && atid < 8) || (atid > 9 && atid < 12)){
			if(param.get("content")!=null){ //只要不为空指针就行了，一律刷新缓存
				stuAns.put("content_6", param.get("content"));
				cache.set("stu_ans_exam", eid+"_"+sid+"_"+qid, stuAns);
			}
		}else {
			if(param.get("aid")!=null){
				stuAns.put("aid", param.get("aid"));
				cache.set("stu_ans_exam", eid+"_"+sid+"_"+qid, stuAns);
			}
		}
		if(list!=null && list.size()>0){
			update(namespace + ".updateStudentExamQuestion", param);
		}else{
			insert(namespace + ".addSA", param);
		}
		return 1;
	}
	
	@Override
	public int addSA1(Map param) {
		List<Map<String,Object>>  list = query(namespace+".getStudentExamQuestion",param);
		Integer atid = Utils.changeObjToInt(param.get("atid"));
		String eid = (String) param.get("eid");
		String sid = (String) param.get("sid");
		String qid = (String) param.get("qid");
		Map<String,Object> stuAns = new HashMap<>();
		stuAns.put("qid", qid);
		stuAns.put("atid", param.get("atid"));
		stuAns.put("answertime", param.get("answertime"));
		LocalCache cache = LocalCache.getInstance();
		if((atid > 4 && atid < 8) || (atid > 9 && atid < 12)){
			if(param.get("content")!=null){ //只要不为空指针就行了，一律刷新缓存
				stuAns.put("content_6", param.get("content"));
				cache.set("stu_ans_exam", eid+"_"+sid+"_"+qid, stuAns);
			}
		}else {
			if(param.get("aid")!=null){
				stuAns.put("aid", param.get("aid"));
				cache.set("stu_ans_exam", eid+"_"+sid+"_"+qid, stuAns);
			}
		}
		if(list!=null && list.size()>0){
			return update(namespace + ".updateStudentExamQuestion", param);
		}else{
			return insert(namespace + ".addSA", param);
		}
	}
	

	@Override
	public int addSAQ(Map param) {
		return insert(namespace + ".addSAQ", param);
	}
	
	@Override
	public int addSAQT(Map param) {
		return insert(namespace + ".addSAQT", param);
	}

	@Override
	public List<Map<String, Object>> getSAQT(Map param) {
		return query(namespace + ".getSAQT", param);
	}

	@Override
	public List<Map<String, Object>> getNotFinishSAQTInAllList(List<Map<String, Object>> allqtList, List<Map<String, Object>> notFinishQuestionList){
		List<Map<String, Object>> rtn = new ArrayList<>();
		for(Map<String,Object> qt : allqtList){
			String qtid = String.valueOf(qt.get("QTID"));
			boolean isExist = false;
			for (Map<String, Object> question : notFinishQuestionList){
				String questionQtid = String.valueOf(question.get("QTID"));
				if(qtid.equals(questionQtid)){
					isExist = true;
					break;
				}
			}
			if(isExist){
				rtn.add(qt);
			}
		}
		return rtn;
	}

	@Override
	public List<Map<String, Object>> getNotFinishSAQ(Map param) {
		return query(namespace + ".getNotFinishSAQ", param);
	}
	
	@Override
	public List<Map<String, Object>> getFinishSAQ(Map param) {
		return query(namespace + ".getFinishSAQ", param);
	}
	
	@Override
	public List<Map<String, Object>> getAllSAQT(Map param) {
		return query(namespace + ".getAllSAQT", param);
	}

	@Override
	public List<Map<String, Object>> getAllSAQ(Map param) {
		return query(namespace + ".getAllSAQ", param);
	}

	@Override
	public Map<Integer, List<Map<String, Object>>> getFinishedOrNotFinishSAQ(Map param){
		Map<Integer, List<Map<String, Object>>> rtn = new HashMap<>();
		List<Map<String, Object>> finishedList = new ArrayList<>();
		List<Map<String, Object>> notFinishedList = new ArrayList<>();
		rtn.put(1, finishedList); //已完成的
		rtn.put(0, notFinishedList); //未完成的
		List<Map<String, Object>> allSAQ = this.getAllSAQ(param);
		if(allSAQ!=null){
			for (int i=0;i<allSAQ.size();i++){
				Map<String,Object> saq = allSAQ.get(i);
				if("1".equals(String.valueOf(saq.get("ISFINISH")))){
					finishedList.add(saq);
				}else{
					notFinishedList.add(saq);
				}
			}
		}
		return rtn;
	}

	@Override
	public List<Map<String, Object>> getRoles() {
		return query(namespace + ".getRoles");
	}

	@Override
	public int addStudentExam(Map param) {
		String eid = (String) param.get("eid");
		String sid = (String) param.get("sid");
		LocalCache cache = LocalCache.getInstance();
		param.put("REALENDTIME", DateFormatUtils.formatDateTime((Date) param.get("endtime")));
		param.put("BEGINDATE", DateFormatUtils.formatDateTime((Date) param.get("begindate")));
		cache.setMap("stu_exam_exam", eid+"_"+sid, param,false);
		return insert(namespace + ".addStudentExam", param);
	}

	@Override
	public List<Map<String, Object>> getStudentExam(Map param) {
		List<Map<String, Object>> rtn;
		String eid = (String) param.get("eid");
		String sid = (String) param.get("sid");
		LocalCache cache = LocalCache.getInstance();
		Map<String,Object> studentExamMap = cache.getMap("stu_exam_exam",eid+"_"+sid);
		if(studentExamMap==null || studentExamMap.isEmpty() || studentExamMap.get("STATE")==null
		|| studentExamMap.get("PRINC_STATE")==null || studentExamMap.get("BEGINDATE")==null || studentExamMap.get("REALENDTIME")==null){
			rtn = query(namespace + ".getStudentExam", param);
			if(rtn!=null && !rtn.isEmpty()){
				cache.setMap("stu_exam_exam", eid+"_"+sid ,rtn.get(0),false);
			}
		}else{
			rtn = new ArrayList<>();
			rtn.add(studentExamMap);
		}
		return rtn;
	}

	@Override
	public Map<String, Object> getQuestionTypeByQTID(Map param) {
		String eid = (String) param.get("eid");
		String qtid = (String) param.get("qtid");
		LocalCache cache = LocalCache.getInstance();
		List<Map<String,Object>> list = cache.get("exampaper_qtype", eid);
		if(list!=null){
			for(Map<String,Object> map : list){
				if(qtid.equals(map.get("QTID"))){
					return map;
				}
			}
		}
		return query(namespace + ".getQuestionTypeByQTID", param).get(0);
	}

	@Override
	public int updateSAQT(Map param) {
		return update(namespace + ".updateSAQT", param);
	}
	
	@Override
	public int removeOnlineID(Map param) {
		return update(namespace + ".updateOnlineID", param);
	}

	@Override
	public int updateStudentExam(Map param) {
		String eid = (String) param.get("eid");
		String sid = (String) param.get("sid");
		LocalCache cache = LocalCache.getInstance();
		cache.setMapFields("stu_exam_exam",eid+"_"+sid, param, false);
		return update(namespace + ".updateStudentExam", param);
	}
	
	@Override
	public int updateStudentExamUseTime(Map param) {
		String eid = (String) param.get("eid");
		String sid = (String) param.get("sid");
		LocalCache cache = LocalCache.getInstance();
		cache.setMapField("stu_exam_exam",eid+"_"+sid, "usetime", Utils.changeObjToInt(param.get("usetime")),false);
		return update(namespace + ".updateStudentExamUseTime", param);
	}
	
	@Override
	public int updateStudentQtypeUseTime(Map param) {
		return update(namespace + ".updateStudentQtypeUseTime", param);
	}
	
	@Override
	public List<Map<String, Object>> getSAQOrder(Map param) {
		return query(namespace + ".getSAQOrder", param);
	}

	@Override
	public List<Map<String, Object>> getAccountCount(Map param) {
		return query(namespace + ".getAccountCount", param);
	}

	@Override
	public int addCoursePer(Map param) {
		return insert(namespace + ".addCoursePer", param);
	}

	//@CacheEvict(value = "permissions", key = "#username")
	public int delAddCoursePer(String tid,String username) {
		return delete(namespace + ".delAddCoursePer", tid);
	}

	//@CacheEvict(value = "permissions", key = "#username")
	public int insertAddCourse(String tid,String username) {
		return insert(namespace + ".insertAddCourse", tid);
	}

	@Override
	public List<Map<String, Object>> defaultRole() {
		return query(namespace + ".defaultRole");
	}
	
	@Override
	public List<Map<String, Object>> getMTtodayTest() {
		return query(namespace + ".getMTtodayTest");
	}
	
	@Override
	public List<Map<String,Object>> getExamObject(Map<String,Object> param){
		return query(namespace+".getExamObject",param);
	}

	@Override
	public List<Map<String, Object>> getRolesByUserRole(Map param) {
		return query(namespace + ".getRolesByUserRole", param);
	}
	
	@Override
	public List<Map<String, Object>> getRolesByUserRole_2(Map param) {
		return query(namespace + ".getRolesByUserRole_2", param);
	}

	@Override
	public String getSystemTimeStrByID(String id){
		Map<String, Object> systemTimeMap = (Map<String, Object>) servletContext.getAttribute("systemTimeMap");
		if(systemTimeMap.get(id+"_name")!=null){
			return (String) systemTimeMap.get(id+"_name");
		}
		int timesec = queryOne(namespace + ".getSystemTimeByID", id);
		return DateFormatUtils.formatDuration(timesec);
	}
	
	@Override
	public Integer getSystemTimeByID(String id) {
		Map<String, Object> systemTimeMap = (Map<String, Object>) servletContext.getAttribute("systemTimeMap");
		if(systemTimeMap.get(id+"_val")!=null){
			return (Integer) systemTimeMap.get(id+"_val");
		}
		return queryOne(namespace + ".getSystemTimeByID", id);
	}	
	
	@Override
	public String getNearSystemTimeId(String name) {
		return queryOne(namespace + ".getNearSystemTimeId", name);
	}

/*	@Override
	public List<Map<String, Object>> getSpecialtyByUnit(String unitid) {
		return query(namespace + ".getSpecialtyByUnit", unitid);
	}*/

	/**
	 * 判断客观题是否满分
	 * @author lzhengr
	 */
	@Override
	public List<String> checkScore(Map param) {
		List<Map<String, Object>> res = query(namespace + ".getStudentExamQuestions", param);
		List<String> ids = new ArrayList<>();
		for(Map m : res){
			if(m!=null && m.get("SCORE") != null && m.get("AVERAGESCORE") != null){
				Double score = Double.valueOf(m.get("SCORE").toString());
				Double ascore = Double.valueOf(m.get("AVERAGESCORE").toString());
				if(!score.equals(ascore)){
					ids.add(m.get("TH").toString());
				}
			}
		}
		return ids;
	}

	@Override
	public List<Map<String, Object>> findCidsBySpecialty(String id) {
		return query(namespace + ".getCidsBySpecialty", id);
	}

	@Override
	public String getCRole(String id) {
		return queryOne(namespace + ".getCRole", id)+"";
	}

	@Override
	public String getTeacherHavingAddUserPermission(String tid) {
		LocalCache cache = LocalCache.getInstance();
		if (cache.get("permissions", "up_" + tid + "_40") != null) {
			return "1";
		} else {
			String rtn = queryOne(namespace + ".getTeacherHavingAddUserPermission", tid) + "";
			if ("1".equals(rtn)) {
				cache.set("permissions", "up_" + tid + "_40", rtn);
			}
			return rtn;
		}
	}
	
	@Override
	public String getAddCoursePermission(String tid) {
		return queryOne(namespace + ".getAddCoursePermission", tid)+"";
	}
	
	@Override
	public List<Map<String,Object>> getAddUser_coursePermission(String tid) {
		return query(namespace + ".getAddUser_coursePermission", tid);
	}
	
	@Override
	public List<Map<String,Object>> getStudentJwList(){
		return query(namespace+".getStudentJwList");
	}

	@Override
	public Map<String, Object> getUnitByName(String unitname) {
		List<Map<String,Object>> list = query(namespace+".getUnitByName",unitname);
		if(list!=null&&list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	@Override
	public Map<String, Object> getSpecialtyByName(Map param) {
		List<Map<String,Object>> list = query(namespace+".getSpecialtyByName",param);
		if(list!=null&&list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	@Override
	public Map<String, Object> getGradeByName(String gradename) {
		List<Map<String,Object>> list = query(namespace+".getGradeByName",gradename);
		if(list!=null&&list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	@Override
	public Map<String, Object> getStudentByNum(Map param) {
		List<Map<String,Object>> list = query(namespace+".getStudentByNum",param);
		if(list!=null&&list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	@Override
	public String getUnitId() {
		return queryOne(namespace + ".getUnitId","")+"";
	}
	
	@Override
	public int insertUnit(Map param){
		return insert(namespace+".insertUnit",param);
	}

	@Override
	public String getSpeId() {
		return queryOne(namespace + ".getSpeId","")+"";
	}

	@Override
	public int insertSpecial(Map param) {
		return insert(namespace+".insertSpecial",param);
	}
	
	@Override
	public String getGradeId() {
		return queryOne(namespace + ".getGradeId","")+"";
	}

	@Override
	public int insertGrade(Map param) {
		return insert(namespace+".insertGrade",param);
	}
	
	@Override
	public String getStuId() {
		return queryOne(namespace + ".getStuId","")+"";
	}

	@Override
	public int insertStudent(Map param) {
		return insert(namespace+".insertStudent",param);
	}
	
	@Override
	public int updateStudent(Map param){
		return update(namespace+".updateStudent",param);
	}

	@Override
	public Map<String, Object> getUnitById(String id) {
		// TODO Auto-generated method stub
		return (Map<String, Object>) queryOne(namespace+".getUnitById",id);
	}

	@Override
	public Map<String, Object> getDeptById(String id) {
		// TODO Auto-generated method stub
		return (Map<String, Object>) queryOne(namespace+".getDeptById", id);
	}

	/*
	 * @see com.cx.kaoyi.business.service.CommonService#updateStudentExamIPAndTime(java.util.Map)
	 */
	@Override
	public int updateStudentExamIPAndTime(Map param) {
		// TODO Auto-generated method stub
		return update(namespace+".updateStudentExamIPAndTime",param);
	}

	@Override
	public List<Map<String, Object>> getCognitionList() {
		// TODO Auto-generated method stub
		return query(namespace+".getCognitionList");
	}

	@Override
	public List<Map<String, Object>> getSourceList() {
		// TODO Auto-generated method stub
		return query(namespace+".getSourceList");
	}

	@Override
	public List<Map<String, Object>> getKnowledgeList() {
		// TODO Auto-generated method stub
		return query(namespace+".getKnowledgeList");
	}

	@Override
	public List<Map<String, Object>> getDifficultyList() {
		return query(namespace+".getDifficultyList");
	}

	@Override
	public List<Map<String, Object>> getStudentMenu() {
		return query(namespace+".getStudentMenus");
	}

	@Override
	public int getQtIsconByQtid(Map m) {
		return queryOne(namespace + ".getQtIsconByQtid", m);
	}

	@Override
	public List<Map<String, Object>> getAnswerTypeList() {
		return query(namespace + ".getAnswerTypeList");
	}
	
	@Override
	public int addStudentLoginRecord(Map map) {
		return insert(namespace + ".addStudentLoginRecord", map);
	}
	
	@Override
	public Map<String, Integer> getQnumGroupByQtype(List<Map<String,Object>> exampaperQuestion) {
		Map<String, Integer> rtn = new HashMap<>();
		for(Map<String,Object> question : exampaperQuestion){
			String qtid = String.valueOf(question.get("qtype"));
			int ismain = Integer.parseInt(String.valueOf(question.get("ismain")));
			int iscon = Integer.parseInt(String.valueOf(question.get("qtiscon")));
			if(ismain==1 || iscon==0){ //给大英考试看总题型对不对的校验，有主题干和非串题
				int nowQtidNum = rtn.getOrDefault(qtid,0);
				rtn.put(qtid, nowQtidNum+1);
			}
		}
		return rtn;
	}

	@Override
	public int checkStudentExam(Map param){
		return queryOne(namespace+".checkStudentExam",param);
	}

	@Override
	public int updateSAQTTime(Map param) {
		return update(namespace + ".updateSAQTTime", param);
	}

	@Override
	public List<Map<String, Object>> getJwUnitList() {
		return query(namespace + ".getJwUnitList");
	}

	@Override
	public String getJwUnitIDFromUnit(String uname) {
		List<Map<String, Object>> list = query(namespace + ".getJwUnitIDFromUnit", uname);
		if(list.size() > 0) {
			return list.get(0).get("ID").toString();
		}else {
			return null;
		}
	}

	@Override
	public int updateJwUnit(Map param) {
		return update(namespace + ".updateJwUnit", param);
	}

	@Override
	public int updateUnit(Map param) {
		return update(namespace + ".updateUnit", param);
	}

	@Override
	public List<Map<String, Object>> getJwDeptList() {
		return query(namespace + ".getJwDeptList");
	}

	@Override
	public String getDeptByName(Map param) {
		List<Map<String, Object>> ls = query(namespace + ".getDeptByName", param);
		return ls.size() > 0 ? ls.get(0).get("ID").toString() : null;
	}

	@Override
	public int insertDept(Map param) {
		return insert(namespace + ".insertDept", param);
	}

	@Override
	public int updateDept(Map par) {
		return update(namespace + ".updateDept", par);
	}

	@Override
	public int updateJwDeptId(Map par) {
		return update(namespace + ".updateJwDeptId", par);
	}

	@Override
	public List<Map<String, Object>> getJwTeacherList() {
		return query(namespace + ".getJwTeacherList");
	}
	
	@Override
	public int addStudentExam4AutoTest(Map param) {
		update(namespace + ".updateOnlineID", param);
		return insert(namespace + ".addStudentExam4AutoTest", param);
	}

	@Override
	public Map<String, Object> getStudentExamState(Map param) {
		String eid = (String) param.get("eid");
		String sid = (String) param.get("sid");
		LocalCache cache = LocalCache.getInstance();
		Map<String,Object> studentExamMap = cache.getMap("stu_exam_exam",eid+"_"+sid);
		if(studentExamMap==null || studentExamMap.isEmpty() || studentExamMap.get("STATE")==null || studentExamMap.get("PRINC_STATE")==null){
			List<Map<String, Object>> ls= query(namespace + ".getStudentExam", param);
			if(ls!=null && !ls.isEmpty()){
				cache.setMap("stu_exam_exam", eid+"_"+sid ,ls.get(0),false);
			}
			return ls.size() > 0 ? ls.get(0): null;
		}
		return studentExamMap;
	}
	
	@Override
	public List<Map<String,Object>> getTestQuestion_qid(Map param){
		List<Map<String, Object>> ls= query(namespace + ".getTestQuestion_qid", param);
		int size=ls.size();
		for(int i=0;i<size;i++){
			Map<String,Object> m=ls.get(i);
			String iscon=String.valueOf(m.get("qtiscon"));
			String ismain=String.valueOf(m.get("ismain"));
			
			if("1".equals(iscon)&&"0".equals(ismain)){
				param.put("mqid", String.valueOf(m.get("mqid")));
				List<Map<String, Object>> mlist= query(namespace + ".getMQuestion_qid", param);
				if(mlist!=null&&mlist.size()>0){
					ls.add(mlist.get(0));
				}
			}
		}
		return ls;
	}
	
	@Override
	public List<Map<String, Object>> getSAQ_yc(Map param) {
		return query(namespace + ".getSAQ_yc", param);
	}
	
	@Override
	public List<Map<String, Object>> getSAQT_yc(Map param) {
		return query(namespace + ".getSAQT_yc", param);
	}
	
	@Override
	public String updateIpRecord(Map param) {
		List<Map<String,Object>> ipList=query(namespace+".getIpRecord",param);
		if(ipList!=null&&ipList.size()>0) {
			int time=Integer.parseInt(String.valueOf(ipList.get(0).get("TIME")));
			if(time>=5) {
				SimpleDateFormat sdf =   new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
				try {
					Date lasttime=sdf.parse(String.valueOf(ipList.get(0).get("LASTTIME")));
					Date now=new Date();
					LocalDateTime dateTime1 = LocalDateTime.ofInstant(lasttime.toInstant(), ZoneId.systemDefault());
			        LocalDateTime dateTime2 = LocalDateTime.ofInstant(now.toInstant(), ZoneId.systemDefault());
			        Duration duration = Duration.between(dateTime1, dateTime2);
			        if(Math.abs(duration.toMinutes()) <= 20) { //5次被锁定后20分钟才能再操作
			        	return "lock";
			        }else {
			        	param.put("time", 1);
			        	update(namespace+".updateIpRecord",param);
			        	return "success";
			        }
				}catch(Exception e) {
					e.printStackTrace();
					return "error";
				}
			}else {
				param.remove("time");
				update(namespace+".updateIpRecord",param);
				
				return "success";
			}
		}else {
			insert(namespace+".addIpRecord",param);
			return "success";
		}
	}

	@Override
	public Map<String,Object> calculateQuestionBankData(boolean isAuto){
		LocalCache cache = LocalCache.getInstance();
		Map<String,Object> lastQuestionBankData = cache.get("questionBankData",1);
		if(lastQuestionBankData==null){
			lastQuestionBankData = new HashMap<>();
		}
		int loggedInSessionCount = localSessionDAO.getLoggedInSessionCount();
		lastQuestionBankData.put("onlineCount", loggedInSessionCount);
		if(isAuto && loggedInSessionCount>280){ //自动刷新时超过280人考试就不会更新了
			cache.set("questionBankData",1,lastQuestionBankData);
			return lastQuestionBankData;
		}

		Map<String,Object> oneData = queryOne(namespace+".getQuestionBankOneData");
		oneData.put("examAnswerTypeTotal",query(namespace+".getExamAnswerTypeTotal"));
		oneData.put("lastRefresh",new Date());
		oneData.put("onlineCount", loggedInSessionCount);
		cache.set("questionBankData",1,oneData);
		return oneData;
	}
}
