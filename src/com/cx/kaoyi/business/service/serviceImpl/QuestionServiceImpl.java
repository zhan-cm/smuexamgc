package com.cx.kaoyi.business.service.serviceImpl;

import com.cx.kaoyi.business.domain.Permission;
import com.cx.kaoyi.business.service.CourseService;
import com.cx.kaoyi.business.service.PermissionService;
import com.cx.kaoyi.business.service.QuestionService;
import com.cx.kaoyi.business.service.SystemService;
import com.cx.kaoyi.framework.base.BaseService;
import com.cx.kaoyi.framework.utils.PageUtils;
import com.cx.kaoyi.framework.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import java.math.BigDecimal;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

@Service("QuestionService")
public class QuestionServiceImpl extends BaseService implements QuestionService{
	
	@Autowired
    private PermissionService permissionService;
	
	@Autowired
    private SystemService systemService;
	
	@Autowired
    private CourseService courseService;

	public static String namespace = "resources.mappers.question";

	@Override
	public String getQuestionID() {
		return query(namespace + ".getQuestionID").get(0).get("KEY").toString();
	}
	
	@Override
	public String getAnswerID() {
		return query(namespace + ".getAnswerID").get(0).get("KEY").toString();
	}
	
	@Override
	public String getAnswerID4ExcelImport() {
		return query(namespace + ".getAnswerID").get(0).get("KEY").toString();
	}

	/**
	 * 查找超过45天的被删除的试题
	 * @return
	 */
	@Override
	public List<Map<String, Object>> getDelQuestion45(String updatetime){
        List<Map<String, Object>> list = query(namespace + ".getDelQuestion45", updatetime);
        return	list;
	}

	@Override
	public String getQuestionCount(Map param) {
		return  query(namespace + ".getQuestionCount", param).get(0).get("NUM").toString();
	}

	@Override
	public List<Map<String, Object>> getQuestion(Map param, PageUtils pu) {
		List<Map<String, Object>> list = query(namespace + ".getQuestion", param, pu.getRb());
		double distinction=0;
		for(Map<String, Object> question:list){
			if(distinction>=0.3){
				question.put("zl", "优秀");
			}else if(distinction<0.3&&distinction>=0.15){
				question.put("zl", "良好");
			}else if(distinction<0.15&&distinction>=0){
				question.put("zl", "尚可");
			}else{
				question.put("zl", "需修改");
			}
		}
		return list;
	}

	@Override
	public List<String> findCourseIllegalAnswerQids(String cid){
		Map<String, Object> param = new HashMap<>();
		param.put("cid", cid);
		param.put("limitAnswerType", "object");
		// 1. 查出所有答案
		List<Map<String,Object>> answerDbList = queryList(namespace + ".getAnswersByCid", param);

		// 2. 按 qid 分组
		Map<String, List<Map<String,Object>>> answerDbMap = new HashMap<>();
		for (Map<String,Object> answerDb : answerDbList) {
			answerDbMap
					.computeIfAbsent(String.valueOf(answerDb.get("QID")), k -> new ArrayList<>())
					.add(answerDb);
		}

		// 3. 遍历每个 qid，判断是否有重复答案
		List<String> illegalQids = new ArrayList<>();
		for (Map.Entry<String, List<Map<String,Object>>> entry : answerDbMap.entrySet()) {
			String qid = entry.getKey();
			List<Map<String,Object>> list = entry.getValue();

			Set<String> contentSet = new HashSet<>();
			Set<String> content6Set = new HashSet<>();

			for (Map<String,Object> a : list) {
				String content = Utils.stripAllHtml4Compare((String) a.get("ACONTENT"));
				if (content != null && !"".equals(content) && !contentSet.add(content)) { // content 重复
					illegalQids.add(qid);
				}
				String content6 = Utils.stripAllHtml4Compare((String) a.get("ACONTENT_6"));
				if (content6 != null && !"".equals(content6) && !content6Set.add(content6)) { // content_6 重复
					illegalQids.add(qid);
				}
			}
		}
		return illegalQids;
	}
	
	@Override
	public int insertQuestion(Map param){
		insert(namespace + ".addQuestionVersion", param);
		
		int ismain = Utils.changeObjToInt(param.get("isMain"));
		if(param.get("answer")!=null){			
			if(ismain==0){
				List<Map<String, Object>> ls = (List<Map<String, Object>>) param.get("answer");
				for(int i=0;i<ls.size();i++) {
					Map m = ls.get(i);
					m.put("id", param.get("id"));
					m.put("index", i);
					m.put("answertype", param.get("answertype"));
					try {
						insert(namespace + ".insertAnswer", m);
					}catch (Exception e) {
						e.printStackTrace();
					}
				}
			}
		}
		
//		int iscon = Integer.parseInt((String)param.get("iscon"));
		//串题小题及非串题为一道题目
//		if(ismain==0||iscon==0){
//			update(namespace + ".addQuestionNum", (String)param.get("cid"));
//		}
		update(namespace+".call_updateCourseQuestioncount",(String)param.get("cid"));
//		int rtn=update(namespace + ".updateQuestionNum2", (String)param.get("cid"));
//		if(rtn==0){
//			update(namespace+".insertCourseQuesPageTotal",(String)param.get("cid"));
//		}

//        insert(namespace+".insertQuestionTarget",param);
		return 1;
	}
	
//	@Override
//	public int insertQuestion4ExcelImport(Map param){
//		int rtn = insert(namespace + ".addQuestionVersion", param);
//		
//		int ismain = Integer.parseInt((String)param.get("isMain"));
//		if(param.get("answer")!=null){			
//			if(ismain==0){
//				insert(namespace + ".insertAnswer", param);
//			}
//		}
//		
//		return rtn;
//	}
	
	@Override
	public List<Map<String,Object>> getQuestionFilterByTheme1(String cid){
		return query(namespace + ".getQuestionFilterByTheme1", cid);
	}
	@Override
	public List<Map<String,Object>> getQuestionFilterByTheme1_2(Map param){
		return query(namespace + ".getQuestionFilterByTheme1_2", param);
	}
	

	@Override
	public List<Map<String, Object>> getDistributionStatistics(Map param) {
		return query(namespace + ".getDistributionStatistics", param);
	}
	
	@Override
	public List<Map<String, Object>> getDifficultyDistribution(String c_id) {
		return query(namespace + ".getDifficultyDistribution", c_id);
	}
	@Override
	public List<Map<String, Object>> getDifficultyDistribution2(Map param) {
		return query(namespace + ".getDifficultyDistribution2", param);
	}

	@Override
	public List<Map<String, Object>> getCognitionDistribution(String c_id) {
		return query(namespace + ".getCognitionDistribution", c_id);
	}

	@Override
	public List<Map<String, Object>> getKnowledgeDistribution(String c_id) {
		return query(namespace + ".getKnowledgeDistribution", c_id);
	}

	@Override
	public List<Map<String, Object>> getQuestionDetail(Map param) {
		return query(namespace + ".getQuestionDetail", param);
	}
	/*
	@Override	
	public List<Map<String, Object>> getQuestionByCID(Map param) {
		return query(namespace + ".getQuestionByCID", param);
	}*/

	@Override
	public Map<String, Object> getQuestionInfo(Map param) {
		Map<String, Object> map = query(namespace + ".getQuestionInfo", param).get(0);
		
		if(map.get("aid")!=null && map.get("coid")!=null && map.get("did")!=null && map.get("kid")!=null){
			String[] aid = ((String)map.get("aid")).split(",");
			String[] cid = ((String)map.get("coid")).split(",");
			String[] did = ((String)map.get("did")).split(",");
			String[] kid = ((String)map.get("kid")).split(",");
//			String[] answertimeid = ((String)map.get("answertime")).split(",");
			
			List<Map<String,Object>> arrangementList = new ArrayList<Map<String,Object>>();
			Map m = new HashMap();
			m.put("cid", param.get("c_id"));
			for(String a:aid){
				m.put("aid", a);
				arrangementList.add((Map<String, Object>) queryOne(namespace + ".getArrangementByID",m));			
			}
			List<Map<String,Object>> cognitionList = new ArrayList<Map<String,Object>>();
			for(String c:cid){
				m.put("coid", c);
				cognitionList.add((Map<String, Object>) queryOne(namespace + ".getCognitionByID",m));			
			}
			List<Map<String,Object>> difficultyList = new ArrayList<Map<String,Object>>();
			for(String d:did){
				m.put("did", d);
				difficultyList.add((Map<String, Object>) queryOne(namespace + ".getDifficultyByID",m));			
			}
			List<Map<String,Object>> knowledgeList = new ArrayList<Map<String,Object>>();
			for(String k:kid){
				m.put("kid", k);
				knowledgeList.add((Map<String, Object>) queryOne(namespace + ".getKnowledgeByID",m));			
			}
			List<String> answertimeList = new ArrayList<String>();
			if(StringUtils.isEmpty(map.get("answertime"))) {
				for(int i=0;i<aid.length;i++) {
					answertimeList.add(map.get("answertime_b").toString());
				}
			} else {
				String at = map.get("answertime").toString();
				String[] atList = at.split(",");
				for(int i=0;i<atList.length;i++) {
					answertimeList.add(atList[i]);
				}
			}
			map.put("arrangementList", arrangementList);
			map.put("cognitionList", cognitionList);
			map.put("difficultyList", difficultyList);
			map.put("knowledgeList", knowledgeList);
			map.put("answertimeList", answertimeList);
		}
		
		int atid = Integer.parseInt(String.valueOf(map.get("atid")));
		List<Map<String,Object>> answerLs = getAnswerByQID(param);
		if(atid<4||atid==8||atid==9){
			if(answerLs!=null){
				for(Map<String,Object> answerMap:answerLs) {
					String acontent=String.valueOf(answerMap.get("ACONTENT"));
					if(acontent==null||"null".equals(acontent)||"".equals(acontent)) {
						acontent=String.valueOf(answerMap.get("ACONTENT_6"));
					}
					answerMap.put("ACONTENT", acontent);
				}
				map.put("answerList", answerLs);
			}
		}else if(atid==4){
			if(answerLs!=null&&answerLs.size() > 0) {
				if(answerLs.get(0) != null){
					String aStr = (String) answerLs.get(0).get("ACONTENT");
					if("true".equals(aStr)){
						map.put("answerid", "true");	
					}else if("false".equals(aStr)){
						map.put("answerid", "false");					
					}
				}
			}
		}else if(atid==13){
			if(answerLs!=null&&answerLs.size()>0){
				map.put("answerid","");
				if(answerLs.get(0).get("ACONTENT_6")!=null){
					map.put("answerid", Base64.getEncoder().encodeToString(answerLs.get(0).get("ACONTENT_6").toString().getBytes(StandardCharsets.UTF_8)));
				}
			}
		}else{
			if(answerLs!=null&&answerLs.size()>0){
				map.put("answerid", answerLs.get(0).get("ACONTENT_6"));
			}					
		}		
		return map;
	}
	
	@Override
	public Map<String, Object> getQuestionPrevew(Map param) {
		Map<String,Object> map = query(namespace + ".getQuestionPreview", param).get(0);
		if(map.get("aid")!=null && map.get("cid")!=null && map.get("did")!=null && map.get("kid")!=null){
			String[] aid = ((String)map.get("aid")).split(",");
			String[] cid = ((String)map.get("cid")).split(",");
			String[] did = ((String)map.get("did")).split(",");
			String[] kid = ((String)map.get("kid")).split(",");
			List<String> answertimeList = new ArrayList<String>();
			if(StringUtils.isEmpty(map.get("answertime"))) {
				for(int i=0;i<aid.length;i++) {
					answertimeList.add(map.get("answertime_b").toString().trim());
				}
			} else {
				String at = (String) map.get("answertime");
				String[] atList = at.split(",");
				for(int i=0;i<atList.length;i++) {
					answertimeList.add(atList[i]);
				}
			}
//			String[] answertimeid = ((String)map.get("answertime")).split(",");
			List<Map<String,Object>> arrangementList = new ArrayList<Map<String,Object>>();
			Map m = new HashMap();
			m.put("cid", param.get("c_id"));
//			List<String> answertimeList = new ArrayList<String>();
			for(String a:aid){
				m.put("aid", a);
				arrangementList.add((Map<String, Object>) queryOne(namespace + ".getArrangementByID",m));
//				answertimeList.add(map.get("answertime").toString());
			}
			List<Map<String,Object>> cognitionList = new ArrayList<Map<String,Object>>();
			for(String c:cid){
				m.put("coid", c);
				cognitionList.add((Map<String, Object>) queryOne(namespace + ".getCognitionByID",m));			
			}
			List<Map<String,Object>> difficultyList = new ArrayList<Map<String,Object>>();
			for(String d:did){
				m.put("did", d);
				difficultyList.add((Map<String, Object>) queryOne(namespace + ".getDifficultyByID",m));			
			}
			List<Map<String,Object>> knowledgeList = new ArrayList<Map<String,Object>>();
			for(String k:kid){
				m.put("kid", k);
				knowledgeList.add((Map<String, Object>) queryOne(namespace + ".getKnowledgeByID",m));			
			}
//			for(String a:answertimeid){
//				answertimeList.add((Map<String, Object>) queryOne(namespace + ".getAnswertimeByID",a));			
//			}
			
			
			map.put("arragementList", arrangementList);
			map.put("cognitionList", cognitionList);
			map.put("difficultyList", difficultyList);
			map.put("knowledgeList", knowledgeList);
			map.put("answertimeList", answertimeList);
		}	
		
		return map;
	}
	
	private Object checkQuestionExist(String qid) {
		return queryOne(namespace + ".checkQuestionExist", qid);
	}
	
	@Override
	public int updateQuestionWithNoVersion(Map param) {	
		String qid = "";
		if(!StringUtils.isEmpty(param.get("id"))) {
			qid = param.get("id").toString();
		}
		if(!StringUtils.isEmpty(checkQuestionExist(qid))) {
			String qtid = param.get("qtid").toString().split("_")[0];
			if(!param.get("isMain").toString().equals("1")){
				List<Map<String,Object>> answer = (List<Map<String, Object>>) param.get("answer");
				for(Map<String,Object> m:answer){
					m.put("answertype", param.get("answertype"));
					if(m.get("answer_content")!=null &&
							String.valueOf(m.get("answer_content")).getBytes(Charset.forName("UTF-8")).length>3990){
						//选择题答案太长，一般是公式带有latex信息
						m.put("answer_content_6", m.get("answer_content"));
						m.remove("answer_content");
					}
					update(namespace+".updateAnswer",m);//更新答案
				}
				List<Map<String,Object>> answer_add = (List<Map<String, Object>>) param.get("answer_add");
				if(answer_add!=null&&answer_add.size()>0){
					for(Map<String,Object> m:answer_add){
						if(m.get("answer_content")!=null &&
								String.valueOf(m.get("answer_content")).getBytes(Charset.forName("UTF-8")).length>3980){
							//选择题答案太长，一般是公式带有latex信息
							m.put("answer_content_6", m.get("answer_content"));
							m.remove("answer_content");
						}
						insert(namespace+".insertAnswer",m);	//插入答案
					}
				}
				
				List<Map<String,Object>> answer_delete=(List<Map<String,Object>>)param.get("answer_delete");
				if(answer_delete!=null&&answer_delete.size()>0){
					for(Map<String,Object> m:answer_delete){
						delete(namespace+".deleteAnswer_one",m);//删除答案
					}
				}
			} else {
				List<Map<String, Object>> list = query(namespace + ".getBrachQuestionByMqid",param.get("id"));
				for(Map m:list) {
					m.put("id", m.get("ID"));
					m.put("qtid", param.get("qtid"));
					m.put("theme1id", param.get("theme1id"));
					m.put("theme2id", param.get("theme2id"));
					m.put("theme3id", param.get("theme3id"));
					update(namespace + ".updateQuestionVersion", m);
				}
			}
			param.put("edittimes", (int) queryOne(namespace + ".getEditTimesByQid", param.get("id")+"") + 1);
			param.put("reeditnum", 0);
			update(namespace + ".updateQuestionVersion", param);
			//删除原来的附件
			/*
			List<String> old_file = (List<String>) param.get("old_file");
			if(old_file!=null && old_file.size()>0){
				for(String url:old_file){
					File file = new File(url);
					if(file.exists()){
						file.delete();
					}
				}
			}*/
		}
		//更新指标
//		try{
//			delete(namespace+".delQuestionTarget",qid);
//			insert(namespace+".insertQuestionTarget",param);
//		}catch (Exception e){
//
//		}
		return 1;
	}

	/**
	 * 暂时删除试题，改变试题的状态
	 * @param param
	 * @return
	 */
	@Override
	public Map<String,Object> deleteQuestion(Map param) {		
		Map<String,Object> rtn=new HashMap<String,Object>();
		String del_id="";
		int sum = 0;
		int ismain = Integer.parseInt(String.valueOf(param.get("ismain")));
		if(ismain==1){
			List<Map<String,Object>> branchQuestion = query(namespace+".getBrachQuestionByMqid",(String)param.get("qid"));
			if(branchQuestion!=null && branchQuestion.size()>0){
				for(Map<String,Object> m:branchQuestion){
					Map<String, Object> que = new HashMap<>();
					que.put("qid",m.get("ID"));
					que.put("state",2);
					que.put("updatorid",param.get("updatorid"));
					que.put("updatetime",param.get("updatetime"));
					sum += update(namespace + ".updateDelQuestionVersion", que);
					del_id+=m.get("ID")+",";
				}
			}
		}
		param.put("state",2);
		sum += update(namespace + ".updateDelQuestionVersion", param);
		del_id+=param.get("qid")+",";
		if(ismain==1 && sum>0){
			sum--;
		}
		update(namespace+".call_updateCourseQuestioncount",param.get("cid"));

		rtn.put("sum",sum);
		if(sum>0){
			rtn.put("del_id",del_id);
		}else{
			rtn.put("del_id","");
		}

		return rtn;
	}

	/**
	 * 彻底删除试题，从数据库中删除
	 * @param param
	 * @return
	 */
	@Override
	public Map<String,Object> deleteQuestionReal(Map param) {
		Map<String,Object> rtn=new HashMap<String,Object>();
		String del_id="";
		int sum = 0;
		int ismain = Integer.parseInt(String.valueOf(param.get("ismain")));
		if(ismain==1){
			List<Map<String,Object>> branchQuestion = query(namespace+".getBrachQuestionByMqid",(String)param.get("qid"));
			if(branchQuestion!=null && branchQuestion.size()>0){
				for(Map<String,Object> m:branchQuestion){
					delete(namespace + ".delAnswer", m.get("ID"));
					sum += delete(namespace + ".delQuesionVersion", m.get("ID"));
					del_id+=m.get("ID")+",";
				}
			}
		}

		if(ismain!=1){
			delete(namespace + ".delAnswer", (String)param.get("qid"));
		}
		sum += delete(namespace + ".delQuesionVersion", (String)param.get("qid"));
		del_id+=param.get("qid")+",";
		if(ismain==1 && sum>0){
			sum--;
		}

		rtn.put("sum",sum);
		if(sum>0){
			rtn.put("del_id",del_id);
		}else{
			rtn.put("del_id","");
		}

		return rtn;
	}

	/**
	 * 恢复暂时被删除的试题到题库中去
	 * @param param 试题信息
	 * @return
	 */
	@Override
	public Map<String,Object> recoverSelect(Map param) {
		Map<String,Object> rtn=new HashMap<String,Object>();
		String del_id="";
		int sum = 0;
		int ismain = Integer.parseInt(String.valueOf(param.get("ismain")));
		if(ismain==1){
			List<Map<String,Object>> branchQuestion = query(namespace+".getBrachQuestionByMqid",(String)param.get("qid"));
			if(branchQuestion!=null && branchQuestion.size()>0){
				for(Map<String,Object> m:branchQuestion){
					//更改试题状态为0
					Map<String, Object> que = new HashMap<>();
					que.put("qid",m.get("ID"));
					que.put("state",0);
					que.put("updatorid",param.get("updatorid"));
					que.put("updatetime", param.get("updatetime"));
					sum += update(namespace + ".updateDelQuestionVersion", que);
					del_id+=m.get("ID")+",";
				}
			}
		}

		param.put("state",0);
		sum += update(namespace + ".updateDelQuestionVersion", param);
		del_id+=param.get("qid")+",";
		if(ismain==1 && sum>0){
			sum--;
		}

		rtn.put("sum",sum);
		if(sum>0){
			rtn.put("del_id",del_id);
		}else{
			rtn.put("del_id","");
		}

		return rtn;
	}

	@Override
	public void delAnswer(String qid){
		delete(namespace + ".delAnswer", qid);
	}

	@Override
	public int verifyQuestion(Map param) {
		update(namespace + ".verifyQuestion", param);
		
		if("1".equals(String.valueOf(param.get("isMain")))){
			update(namespace + ".verifyBranchQuestion", param);
		}
		return 0;
	}
	
	@Override
	public int LastVerifyQuestion(Map param) {
		update(namespace + ".LastVerifyQuestion", param);
		
		if("1".equals(String.valueOf(param.get("isMain")))){
			update(namespace + ".LastVerifyBranchQuestion", param);
		}
		return 0;
	}

	@Override
	public List<Map<String, Object>> getQuestionTypeInfo(Map param) {
		return query(namespace + ".getQuestionTypeInfo", param);
	}

	@Override
	public List<Map<String, Object>> getQuestionTypeInfo_t3(Map param) {
		return query(namespace + ".getQuestionTypeInfo_t3", param);
	}

	
	@Override
	public List<Map<String, Object>> getQuestionByQID(String qid) {
//		List<Map<String, Object>> list = query(namespace + ".getQuestionByQID", qid);		
		return query(namespace + ".getQuestionByQID", qid);
	}
	
	/**
	 * 获取所有试题，包括答案选项和答案，使用者：QuestionController【previewQuestion】
	 * @author 洪艳
	 * @param 'param[qid'、version] 主题干  atid 答案分类id
	 * @return Map<String, Object>试题信息+answer正确答案+answerList【AID、ACONTENT】答案选项
	 */
	public Map<String, Object> getQuestion_AnswerByQID(Map param) {
		Map<String, Object> mainQuestionMap = getQuestionPrevew(param);
		int atid = Integer.parseInt(String.valueOf(mainQuestionMap.get("atid")));
		List<Map<String, Object>> answerLs = getAnswerByQID(param);
		if(atid<4||atid==8||atid==9){
			if(answerLs.get(0)!=null&&mainQuestionMap.get("answerid")!=null){
				String[] answerid = ((String)mainQuestionMap.get("answerid")).split(",");
				StringBuffer sb = new StringBuffer();
				for(int i=0;i<answerLs.size();i++){
					char pre = (char)(i+65);
					Map<String, Object> amap = answerLs.get(i);
					String acontent=String.valueOf(amap.get("ACONTENT"));
					if(acontent==null||"null".equals(acontent)||"".equals(acontent)) {
						acontent=String.valueOf(amap.get("ACONTENT_6"));
					}
					amap.put("ACONTENT", pre+"."+acontent);
					for(int j=0;j<answerid.length;j++){
						if(answerid[j].equals((String)amap.get("AID"))){
							sb.append(pre);
						}
					}
				}
				mainQuestionMap.put("answer", sb.toString());
				mainQuestionMap.put("answerList", answerLs);
			}
		}else if(atid==4){
			Map<String, Object> map = answerLs.get(0);
			String aStr = (String) map.get("ACONTENT");
			if("true".equals(aStr)){
				mainQuestionMap.put("answer", "对");	
			}else if("false".equals(aStr)){
				mainQuestionMap.put("answer", "错");					
			}
		}else if(atid==13){
			if(answerLs!=null&&answerLs.size()>0){
				mainQuestionMap.put("answerid","");
				if(answerLs.get(0).get("ACONTENT_6")!=null){
					mainQuestionMap.put("answerid", Base64.getEncoder().encodeToString(answerLs.get(0).get("ACONTENT_6").toString().getBytes(StandardCharsets.UTF_8)));
				}
			}
		}else{
			Map<String, Object> map = answerLs.get(0);
			mainQuestionMap.put("answer", map.get("ACONTENT_6"));			
		}
		
		return mainQuestionMap;
	}
	
	/**
	 * 获取所有分支试题，包括答案选项和答案，使用者：QuestionController【previewQuestion】
	 * @author 洪艳
	 * @param mqid 主题干  atid 答案分类id
	 * @return List<Map<String, Object>>试题信息+answer正确答案+answerList【AID、ACONTENT】答案选项
	 */
	public List<Map<String, Object>> getBranchQuestion_AnswerByQID(String mqid,int atid) {
		List<Map<String, Object>> list = query(namespace + ".getBranchQuestionByQID", mqid);
		if(atid<4||atid==8||atid==9){	
			for(int a=0;a<list.size();a++){
				Map<String, Object> map = list.get(a);
								
				Map m = new HashMap();
				m.put("id", map.get("qid"));		
				
				List<Map<String, Object>> answerLs = getAnswerByQID(m);
				
				if(map.get("answerid")!=null&&answerLs.get(0)!=null){
					String[] answerid = ((String)map.get("answerid")).split(",");
					StringBuffer sb = new StringBuffer();
					for(int i=0;i<answerLs.size();i++){
						char pre = (char)(i+65);
						Map<String, Object> amap = answerLs.get(i);
						String acontent=String.valueOf(amap.get("ACONTENT"));
						if(acontent==null||"null".equals(acontent)||"".equals(acontent)) {
							acontent=String.valueOf(amap.get("ACONTENT_6"));
						}
						amap.put("ACONTENT", pre+"."+acontent);
						for(int j=0;j<answerid.length;j++){
							if(answerid[j].equals((String)amap.get("AID"))){
								sb.append(pre);
							}
						}
					}
					map.put("answer", sb.toString());
					map.put("answerList", answerLs);
				}
				
			}
		}else if(atid==4){
			for(int a=0;a<list.size();a++){
				Map<String, Object> map = list.get(a);
				Map m = new HashMap();
				m.put("id", map.get("qid"));	
				Map<String, Object> answerM = getAnswerByQID(m).get(0);
				
				if(answerM!=null){
					if("true".equals(answerM.get("ACONTENT"))){
						list.get(a).put("answer", "对");	
					}else if("false".equals(answerM.get("ACONTENT"))){
						list.get(a).put("answer", "错");					
					}
				}
			}
			
		}else{
			for(int a=0;a<list.size();a++){
				Map<String, Object> map = list.get(a);
				Map m = new HashMap();
				m.put("id", map.get("qid"));
				Map<String, Object> answerM = getAnswerByQID(m).get(0);
				if(answerM!=null){
					map.put("answer", answerM.get("ACONTENT_6"));
				}
				
			}
				
		}
		
		return list;
	}
	
	/*
	public String getAnswerType(String qtid) {
		return (String) queryOne(namespace + ".getAnswerType", qtid);
	}*/

	@Override
	public List<Map<String, Object>> getAnswerByQID(Map param) {
		return query(namespace + ".getAnswerByQID", param);
	}
	
//	@Override	
//	public int updateBranchQuestion(Map param) {
//		if(param.get("answer")!=null){
//			if(!param.get("isMain").toString().equals("1")){
//				insert(namespace + ".insertAnswer", param);
//			}
//		}
//		//insert(namespace + ".addQuestionVersion", param);
//		insert(namespace + ".addBranchQuestionVersion", param);
//		update(namespace + ".updateBranchQuestion", param);
//		if(!StringUtils.isEmpty(param.get("eid"))){
//			update(namespace + ".updatePaperBranchQuestion", param);
//		}
//		return 1;
//	}

	@Override
	public Map<String, Object> getQuestionCon(Map param) {
		return query(namespace + ".getQuestionCon", param).get(0);
	}
	
	@Override
	public Map<String, Object> getQtByQtnameFromCourse_QuestionType(Map param) {
		List<Map<String,Object>> list = query(namespace + ".getQtByQtnameFromCourse_QuestionType", param);
		if(list!=null && list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	@Override
	public Map<String, Object> getQtByQtnameFromQuestionType(Map param) {
		List<Map<String,Object>> list = query(namespace + ".getQtByQtnameFromQuestionType", param);
		if(list!=null && list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	public void insertQt4Transfer(Map param){
		insert(namespace + ".insertQt4Transfer", param);
	}
	
	@Override
	public Map<String, Object> getThemeIdByName(Map param) {
		List<Map<String, Object>> list = query(namespace + ".getThemeIdByName", param);
		if(list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
		
	}

	@Override
	public Map<String, Object> getCognitionId(String coname) {
		return query(namespace + ".getCognitionId", coname).get(0);
	}

	@Override
	public Map<String, Object> getSourceId(String soname) {
		return query(namespace + ".getSourceId", soname).get(0);
	}

	@Override
	public Map<String, Object> getKnowledgeId(String kname) {
		return query(namespace + ".getKnowledgeId", kname).get(0);
	}

	@Override
	public Map<String, Object> getDifficultyId(String dname) {
		return query(namespace + ".getDifficultyId", dname).get(0);
	}

	@Override
	public int delAll(Map courseinfo,String p) {
		String cid =(String)courseinfo.get("cid");
		List<Map<String,Object>> allList = query(namespace+".getQuestionsByCid",cid);
		//List<String> delFile = new ArrayList<String>();
		for(Map<String,Object> qmap:allList){
			Map m = new HashMap();
			m.put("qid", qmap.get("ID"));
			m.put("ismain", qmap.get("ISMAIN"));
			m.put("iscon", qmap.get("ISCON"));
			m.put("cid", cid);
			m.put("id", qmap.get("ID"));
			/*
			String str = getFilePath(m);			
			if(!str.equals("")){
				String[] old_file = getFilePath(m).split(",");
				for(int i=0;i<old_file.length;i++){			
					//delFile.add(p+old_file[i]);
					delFile.add(p.substring(0,p.lastIndexOf("\\smuexam"))+old_file[i]);
					delFile.add(filePath+old_file[i]);
				}
			}*/
			
			//deleteQuestion(m,p);
			int ismain = Integer.parseInt(String.valueOf(m.get("ismain")));
			if(ismain==1){
				List<Map<String,Object>> branchQuestion = query(namespace+".getBrachQuestionByMqid",(String)m.get("qid"));
				if(branchQuestion!=null && branchQuestion.size()>0){
					for(Map<String,Object> map:branchQuestion){
						Map<String, Object> que = new HashMap<>();
						que.put("qid",qmap.get("ID"));
						que.put("state",2);
						que.put("updatorid",courseinfo.get("uid"));
						que.put("updatetime",courseinfo.get("updatetime"));
						update(namespace + ".updateDelQuestionVersion", que);
						//delete(namespace + ".delAnswer", map.get("ID"));
						//(namespace + ".delQuesionVersion", map.get("ID"));
					}
				}
			}
			
			/*if(ismain!=1){
				delete(namespace + ".delAnswer", (String)m.get("qid"));
			}
			delete(namespace + ".delQuesionVersion", (String)m.get("qid"));
			*/
			Map<String, Object> que = new HashMap<>();
			que.put("qid",qmap.get("ID"));
			que.put("state",2);
			que.put("updatorid",courseinfo.get("uid"));
			que.put("updatetime",courseinfo.get("updatetime"));
			update(namespace + ".updateDelQuestionVersion", que);
			update(namespace+".call_updateCourseQuestioncount",cid);
		}
		
		//删除原来的附件
		/*
		if(delFile!=null && delFile.size()>0){
			for(String url:delFile){
				File file = new File(url);
				if(file.exists()){
					file.delete();
				}
			}
		}*/
		
		Map log = new HashMap();
		log.put("content", "删除课程的所有试题，课程序号为："+cid);
		log.put("cid", cid);
		systemService.addSysLog(log);
		
		return 0;
	}
	
	/**
	 * 根据试题查询所属课程的课程id，使用者：预览试题
	 * @author yoyo
	 * @param '试题id'
	 * @return String 课程id
	 */
	@Override
	public String getCidByQid(String qid){
		return (String) queryOne(namespace + ".getCidByQid", qid);
	}

	@Override
	public List<Map<String, Object>> writeQuestionXls(Map m) {
		List<Map<String, Object>> list = query(namespace + ".writeQuestionXls", m);
		return list;
	}

	@Override
	public int updateNum_testtime(Map m) {
		return update(namespace + ".updateNum_testtime", m);
	}

	@Override
	public List<Map<String, Object>> selectAnswerByQID(String qid) {
		return query(namespace + ".selectAnswerByQID", qid);
	}

	/*
	@Override
	public List<Map<String, Object>> getRelePaperByQid(Map param) {
		return query(namespace + ".getRelePaperByQid", param);
	}*/

	@Override
	public List<Map<String, Object>> findRepeatQuestions(Map param) {
		List<Map<String, Object>> qListAll = query(namespace + ".findAllQuestions4Repeat", param);

		// 3 个临时列表：非串题、串题子题、串题主题
		List<Map<String, Object>> qListAllWithMainAndChild = new ArrayList<>();
		List<Map<String, Object>> qListIsconNotMain       = new ArrayList<>();
		List<Map<String, Object>> qListIsconIsMain        = new ArrayList<>();

		// 1. 先把 content 和 compareContent 都放到 question 里
		for (Map<String, Object> question : qListAll) {
			String rawContent = Objects.toString(question.get("content"), "");
			question.put("content", rawContent);
			// 用 stripAllHtml4Compare 生成纯文本 key
			question.put("compareContent", Utils.stripAllHtml4Compare(rawContent));

			int iscon = Utils.changeObjToInt(question.get("qtiscon"));
			if (iscon == 1) {
				int ismain = Utils.changeObjToInt(question.get("ismain"));
				if (ismain == 1) {
					qListIsconIsMain.add(question);
				} else if (question.get("mqid") != null) {
					qListIsconNotMain.add(question);
				}
			} else {
				qListAllWithMainAndChild.add(question);
			}
		}

		// 2. 把主／子题合并
		for (Map<String, Object> mquestion : qListIsconIsMain) {
			// 找子题并搬移到 childList
			for (int i = qListIsconNotMain.size() - 1; i >= 0; i--) {
				Map<String, Object> cquestion = qListIsconNotMain.get(i);
				if (cquestion.get("mqid").equals(mquestion.get("qid"))) {
					List<Map<String, Object>> childList =
							(List<Map<String, Object>>) mquestion.computeIfAbsent("childList", k -> new ArrayList<>());
					childList.add(cquestion);
					qListIsconNotMain.remove(i);
				}
			}
			// 如果有子题，就按照 content 排序并拼接字符串
			List<Map<String, Object>> childList =
					(List<Map<String, Object>>) mquestion.get("childList");
			if (childList != null && !childList.isEmpty()) {
				childList.sort(Comparator.comparing(map -> Utils.stripAllHtml4Compare((String) map.get("content"))));
				StringBuilder mcontent = new StringBuilder("主题干：")
						.append(mquestion.get("content"))
						.append("<br>子题：");
				for (int idx = 0; idx < childList.size(); idx++) {
					mcontent.append("<br>")
							.append(idx + 1)
							.append("、")
							.append(childList.get(idx).get("content"));
				}
				String mcontStr = mcontent.toString();
				// 更新显示用 content
				mquestion.put("content", mcontStr);
				// 更新比对用 compareContent
				mquestion.put("compareContent", Utils.stripAllHtml4Compare(mcontStr));
			}
			qListAllWithMainAndChild.add(mquestion);
		}

		// 3. 按 compareContent 分组，只保留 size>=2 的
		Map<String, List<Map<String, Object>>> groupedByContent =
				qListAllWithMainAndChild.stream()
						.collect(Collectors.groupingBy(q -> (String) q.get("compareContent")));

		List<Map<String, Object>> qlist = groupedByContent.values().stream()
				.filter(g -> g.size() >= 2)
				.flatMap(List::stream)
				.collect(Collectors.toList());

		// 4. 排序：先按显示用 content 升序，再按 num 倒序
		qlist.sort((m1, m2) -> {
			int c = ((String) m1.get("compareContent")).compareTo((String) m2.get("compareContent"));
			if (c != 0) return c;
			BigDecimal n1 = (BigDecimal) m1.get("num");
			BigDecimal n2 = (BigDecimal) m2.get("num");
			return n2.compareTo(n1);
		});

		// 5. sameQuestionLabel 标号
		int sameQuestionLabel = 0;
		String lastContent = "";
		for (Map<String, Object> question : qlist) {
			String currentContent = (String) question.get("compareContent");
			if (!currentContent.equals(lastContent)) {
				sameQuestionLabel++;
			}
			question.put("sameQuestionLabel", sameQuestionLabel);
			lastContent = currentContent;

			// 如果是主题干，清空不显示的字段
			if ("1".equals(String.valueOf(question.get("ismain")))) {
				question.put("answerContent", "");
				question.put("trueAnswer", "");
				continue;
			}

			// 组装 answerContent 和 trueAnswer
			StringBuilder aContent = new StringBuilder();
			StringBuilder trueAnswer = new StringBuilder();
			Map<String, Object> mm = Collections.singletonMap("id", question.get("qid"));
			List<Map<String, Object>> alist = getAnswerByQID(mm);
			alist.sort(Comparator.comparing(map -> Utils.stripAllHtml4Compare((String) map.get("ACONTENT"))));
			int atid = Utils.changeObjToInt(alist.get(0).get("ATID"));

			if (atid < 4) {
				for (int j = 0; j < alist.size(); j++) {
					// 直接用原始字符串，不再 stripHtmlExcept4Img
					String rawA = Objects.toString(alist.get(j).get("ACONTENT"), "");
					if (rawA.isEmpty()) {
						rawA = Objects.toString(alist.get(j).get("ACONTENT_6"), "");
					}
					aContent.append((char) ('A' + j))
							.append("、")
							.append(rawA)
							.append("<br/>");
					// 计算 trueAnswer
					String[] tAid = Objects.toString(question.get("answerid"), "").split(",");
					for (String s : tAid) {
						if (alist.get(j).get("AID").toString().equals(s)) {
							trueAnswer.append((char) ('A' + j));
							break;
						}
					}
				}
			} else if (atid == 4) {
				// 判断对错题
				for (Map<String, Object> a : alist) {
					if (Objects.equals(question.get("answerid"), a.get("AID"))) {
						aContent.append("true".equals(a.get("ACONTENT")) ? "对" : "错");
					}
				}
			} else {
				// 简答题
				for (Map<String, Object> a : alist) {
					aContent.append(Objects.toString(a.get("ACONTENT_6"), ""));
				}
			}

			// 放入显示用 answerContent
			question.put("answerContent", aContent.toString());
			question.put("trueAnswer", trueAnswer.toString());
			// 放入比对用 compareAnswerContent
			question.put("compareAnswerContent", Utils.stripAllHtml4Compare(aContent.toString()));
		}

		return qlist;
	}

	@Override
	public List<Map<String, Object>> findRepeatQuestionsWithAnswer(List<Map<String, Object>> qlist) {
		// 已经在上一个方法中把 content/compareContent 和 answerContent/compareAnswerContent 都填好了

		// 1. 按 content+answerContent 的 compare 字段分组
		Map<String, List<Map<String, Object>>> grouped = qlist.stream()
				.collect(Collectors.groupingBy(
						m -> m.get("compareContent") + "|" + m.get("compareAnswerContent")
				));

		// 2. 只保留组大小 >=2 的，给每组打同一个 sameQuestionLabel
		AtomicInteger labelCounter = new AtomicInteger(0);
		List<Map<String, Object>> duplicates = grouped.values().stream()
				.filter(g -> g.size() >= 2)
				.flatMap(g -> {
					int lbl = labelCounter.getAndIncrement();
					g.forEach(m -> m.put("sameQuestionLabel", lbl));
					return g.stream();
				})
				.collect(Collectors.toList());

		// 3. 排序：先按显示用 content，再按显示用 answerContent，再按 num 降序
		duplicates.sort(Comparator
				.comparing((Map<String, Object> m) -> (String) m.get("compareContent"))
				.thenComparing(m -> Objects.toString(m.get("compareAnswerContent"),""))
				.thenComparing(m -> Utils.changeObjToInt(m.get("num")), Comparator.reverseOrder())
		);

		return duplicates;
	}

	@Override
	public List<Map<String, Object>> getWorkLoadTotalAll(Map param){
		return query(namespace + ".getWorkLoadTotalAll", param);
	}

	@Override
	public Map<String, List<Map<String, Object>>> getWorkLoad(Map<String, Object> param) {
		List<Map<String, Object>> list = query(namespace + ".getWorkLoad", param);

		String[] workTypes = {"createWork", "updateWork", "verifyWork", "lastVerifyWork", "create_updateWork"};

		// 临时分组容器：每种工作类型下，按用户名有序存储
		Map<String, LinkedHashMap<String, Map<String, Object>>> grouped = new LinkedHashMap<>();
		for (String workType : workTypes) {
			grouped.put(workType, new LinkedHashMap<>());
		}

		for (Map<String, Object> row : list) {
			String workType = (String) row.get("WORKTYPE");
			String name = (String) row.get("NAME");
			String qtname = (String) row.get("QTNAME");
			Integer qcount = Utils.changeObjToInt(row.get("QCOUNT"));

			LinkedHashMap<String, Map<String, Object>> userMap = grouped.get(workType);
			if (userMap == null) {
				continue;
			}

			Map<String, Object> userRow = userMap.get(name);
			if (userRow == null) {
				userRow = new LinkedHashMap<>();
				userRow.put("name", name);
				userRow.put("qtcount", new ArrayList<>());
				userMap.put(name, userRow);
			}

			List<Map<String, Object>> qtcountList = (List<Map<String, Object>>) userRow.get("qtcount");

			Map<String, Object> qtMap = new LinkedHashMap<>();
			qtMap.put("qtname", qtname);
			qtMap.put("qcount", qcount);
			qtcountList.add(qtMap);
		}
		Map<String, List<Map<String, Object>>> result = new LinkedHashMap<>();
		for (String workType : workTypes) {
			result.put(workType, new ArrayList<>(grouped.get(workType).values()));
		}
		return result;
	}

	@Override
	public List<Map<String, Object>> getUsedQuestionTypeByCid(String cid) {
		return query(namespace + ".getUsedQuestionTypeByCid", cid);
	}

	@Override
	public Map<String,Object> getPrevAndNextQuestion(Map param){
		Map<String,Object> rtn = new HashMap<>();
		List<Map<String,Object>> list = query(namespace + ".getPrevAndNextQuestion", param);
		if(list==null || list.isEmpty()){
			return rtn;
		}
		List<Map<String,Object>> lastQuestion = new ArrayList<>();
		List<Map<String,Object>> nextQuestion = new ArrayList<>();
		for(int i=0;i<list.size();i++){
			if("LAST".equals(list.get(i).get("RELATION"))){
				lastQuestion.add(list.get(i));
			} else if ("NEXT".equals(list.get(i).get("RELATION"))) {
				nextQuestion.add(list.get(i));
			}
		}
		rtn.put("lastQuestion", lastQuestion);
		rtn.put("nextQuestion", nextQuestion);
		return rtn;
	}
	
	/**
	 * 验证是否有对应的试题权限,使用者：试题列表
	 * @author 洪艳
	 * @param 'map'，传入参数（permission[例如：question:update],uid,cid）
	 * @return 1,有 2,无
	 */
	@Override
	public int checkQuestionPermission(Map param,String uid_cid) {
		//List<Permission> pLs = permissionService.getQuestionPermissionsByUIDAndCID(param,username_cid); 
		if(courseService.checkCreatorID(param)) {return 1;}
		List<Permission> pLs = permissionService.findPerByUIDAndCID(param, uid_cid); 
		if(pLs!=null){
			String permission = (String)param.get("permission");
			String permission_2nd = (String)param.get("permission_2nd");
			if("question:add".equals(permission)){//添加试题的权限，拥有pid:22，20
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==22||pid==20){
						return 1;
					}
				}
			}
			if("question:export".equals(permission)){//导出试题的权限，拥有pid:20,28
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==20||pid==28){
						return 1;
					}
				}
			}//初审试题
			if("question:verify".equals(permission)){//审核试题的权限，拥有pid:20,29
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==20||pid==29){
						return 1;
					}
				}
			}//终审试题
			if("question:lastVerify".equals(permission)){//审核试题的权限，拥有pid:20,29,41
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==20||pid==41){
						return 1;
					}
				}
			}
			if("question:del".equals(permission)){//删除试题的权限，拥有pid:20,24,210
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==20||pid==24||pid==210){
						return 1;
					}
				}
			}
			if("question:import".equals(permission)){//导入试题的权限，拥有pid:20,27
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==20||pid==27){
						return 1;
					}
				}
			}
			if("question:view".equals(permission)){//查看试题的权限，拥有pid:20,21
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==20||pid==21){
						return 1;
					}
				}
			}
			if("question:update".equals(permission)){//修改试题的权限，拥有pid:20,23
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==20||pid==23){
						return 1;
					}
				}
			}
			if("question:patchDel".equals(permission)){//修改试题的权限，拥有pid:20,25
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==20||pid==25){
						return 1;
					}
				}
			}
			if("question:delAll".equals(permission)){//修改试题的权限，拥有pid:20,25
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==20||pid==210){
						return 1;
					}
				}
			}
		}
		return 0;
		
		/*
		210	删除所有试题	question	question:delAll
		29	审核试题	question	question:verify
		22	添加试题	question	question:add
		23	编辑试题	question	question:update
		20	所有试题权限	question	question:*
		21	浏览试题	question	question:view
		24	删除试题	question	question:del
		27	导入试题	question	question:import	
		28	导出试题	question	question:export	
		25	批量删除试题	question	question:patchDel
		26	规范试题格式	question	question:norm
		*/
		/*
		if(pLs!=null){
			for(int i=0;i<pLs.size();i++){
				if(permission.equals(pLs.get(i).getPermission())){
					return 1;
				}
			}
		}
		return 0;*/
	}

	@Override
	public int checkQuestionState(Map param) {
		List<Map<String,Object>> list=query(namespace + ".checkQuestionState", param);
//		if(list.size()==0) {
//			return 2;
//		}
		return list.size();
	}

	@Override
	public List<Map<String, Object>> getAllQT4CourseQuestion(Map m) {
		return query(namespace+".getAllQT4CourseQuestion",m);
	}
	
	@Override
	public List<Map<String, Object>> getAllQT4CourseQuestion2(Map m) {
		return query(namespace+".getAllQT4CourseQuestion2",m);
	}	
	
	@Override
	public BigDecimal getQuestionCount4Distribution(String cid) {
		return queryOne(namespace + ".getQuestionCount4Distribution", cid);
	}
	
	@Override
	public int insertQuestion4TransferData(Map param){
		insert(namespace + ".addQuestionVersion", param);
		
		int ismain = (Integer)param.get("isMain");
		if(param.get("answer")!=null){			
			if(ismain==0){
				insert(namespace + ".insertAnswer4TransferData", param);
			}
		}
		
		return 1;
	}
	
	//数据迁移，先保存主题干
	@Override
	public int insertMainQuestion4TransferData(Map param){
		insert(namespace + ".addQuestion", param);
		insert(namespace + ".addQuestionVersion", param);
		
		return 1;
	}
	
	//数据迁移，更新mqid
	@Override
	public int updateMqid4TransferData(Map param){
		update(namespace + ".updateMqid4TransferData", param);
		return 1;
	}
	
//	@Override
//	public int updateQuestionNum2(String cid){
//		update(namespace + ".updateQuestionNum2", cid);
//		return 1;
//	}

	@Override
	public void call_updateCourseQuestioncount(String cid){
		update(namespace+".call_updateCourseQuestioncount",cid);
	}

	@Override
	public List<Map<String, Object>> checkThemeExist(Map m) {
		return query(namespace + ".checkThemeExist", m);
	}

	@Override
	public Map<String, Object> getQuestionFilter(String cid) {
		Map rs = new HashMap();
		rs.put("questionTypeList", query(namespace + ".getQuestionFilterByQuestionType", cid));
		rs.put("themeList", query(namespace + ".getQuestionFilterByTheme1", cid));
		rs.put("cognitionList", query(namespace + ".getQuestionFilterByCognition", cid));
		rs.put("difficultyList", query(namespace + ".getQuestionFilterByDifficulty", cid));
		rs.put("knowledgeList", query(namespace + ".getQuestionFilterByKnowledge", cid));
		return rs;
	}

	@Override
	public List<Map<String, Object>> getSameAtidQuestionTypeByQid(String qid) {
		Map m = new HashMap();
		m.put("id", qid);
		Map<String, Object> question = (Map<String,Object>)query(namespace+".getQuestionInfo",m).get(0);
		int atid = Integer.parseInt(question.get("atid").toString());
		if(atid < 4) {
			m.put("atid", new String[]{"0","1","2","3"});
		}else if(atid==4) {
			m.put("atid", new String[]{"4"});
		}else if(atid > 4 && atid < 8){
			m.put("atid", new String[]{"5","6","7"});
		}else if(atid == 8 || atid == 9) {
			m.put("atid", new String[]{"8","9"});
		}else {
			m.put("atid", new String[]{"10","11"});
		}
		m.put("iscon", Integer.parseInt(String.valueOf(question.get("iscon"))));
		return query(namespace+".getSameAtidQuestionTypeByQid",m);
	}
	
	@Override
	public String getAllQuestionCount(Map param) {
		return query(namespace + ".getAllQuestionCount", param).get(0).get("TAR").toString();
	}
//	@Override
//	public String getThemeId() {
//		return query(namespace + ".getThemeId").get(0).get("ID").toString();
//	}
	
	@Override
	public int insertThemeForImportQuestion(List themeList) {
		return insert(namespace + ".insertThemeForImportQuestion", themeList);
	}

	@Override
	public List<Map<String, Object>> getRepeatQuestionForImportQuestion(Map mainQuestion) {
		return query(namespace + ".getRepeatQuestionForImportQuestion", mainQuestion);
	}

	@Override
	public int insertQuestionForImportQuestion(List<Map<String, Object>> list) {
		return insert(namespace + ".insertQuestionForImportQuestion", list);
	}

	@Override
	public void insertAnswerForImportQuestion(List<Map<String, Object>> list) {
		insert(namespace + ".insertAnswerForImportQuestion", list);
	}

	@Override
	public List getRepeatAnswerContent(Map param) {
		return query(namespace + ".getRepeatAnswerContent", param);
	}

	@Override
	public int insertTheme4ImportQuestion(Map param) {
		List<Map<String,Object>> list=query(namespace + ".getRepeatTheme", param);
		if(list.isEmpty()){
			return insert(namespace + ".insertTheme4ImportQuestion", param);
		} else {
			String id =list.get(0).get("ID").toString();
			int state =Integer.parseInt(String.valueOf(list.get(0).get("STATE")));
			if(state == 0){
				update(namespace + ".updateThemeState", id);
			}
			param.put("id", id);
		}
		return 0;
	}

	@Override
	public List<Map<String, Object>> getQuestionBranch4Xls(Map param) {
		return query(namespace + ".getQuestionBranch4Xls", param);
	}
	
	@Override
	public Map<String, Object> getQuestionByQID4CopyQuestion(Map param) {
		Map<String,Object> mainQuestionMap = query(namespace + ".getQuestionByQID4CopyQuestion", param).get(0);
		int ismain=Integer.parseInt(String.valueOf(mainQuestionMap.get("ismain")));
		if(ismain==0){
			mainQuestionMap.put("answerList", getAnswerByQID(param));
		}		
		return mainQuestionMap;
	}
	
	@Override
	public int insertQuestion4CopyQuestion(Map param){
		insert(namespace + ".addQuestionVersion", param);
		
		if(param.get("answerList")!=null){			
			List<Map<String, Object>> ls = (List<Map<String, Object>>) param.get("answerList");
			for(int i=0;i<ls.size();i++) {
				Map m = ls.get(i);
				m.put("id", param.get("id"));
				m.put("index", i);
				insert(namespace + ".insertAnswer", m);
			}
		}
		update(namespace+".call_updateCourseQuestioncount",(String)param.get("cid"));
		return 1;
	}
	
	/*用于修正answertime,后面可删除*/
	public List<Map<String,Object>> getAnswertime(Map param){
		return query(namespace+".getAnswertime",param);
	}
	
	public void batchUpdateAnswertime(List<Map<String,Object>> list){
		for(Map<String,Object> map:list){
			update(namespace+".batchUpdateAnswertime",map);
		}
	}
	
	public List<Map<String,Object>> getPaperAnswertime(Map param){
		return query(namespace+".getPaperAnswertime",param);
	}
	
	public void batchUpdatePaperAnswertime(List<Map<String,Object>> list){
		for(Map<String,Object> map:list){
			update(namespace+".batchUpdatePaperAnswertime",map);
		}
	}
	
	/*用于修正answertime*/
	 
	@Override
	public List<Map<String, Object>> getQuestion4StudentEnd(Map param, PageUtils pu) {
		List<Map<String, Object>> list = query(namespace + ".getQuestion4StudentEnd", param, pu.getRb());
		for(Map<String, Object> map:list){
			String ismain=String.valueOf(map.get("ismain"));
			if("1".equals(ismain)){
				List<Map<String,Object>> branch=query(namespace+".getBranchByQID4StudentEnd",String.valueOf(map.get("qid")));
				map.put("branch", branch);
			}
		}
		return list;
	}
	
	@Override
	public String getQuestionCount4StudentEnd(Map param) {
		return  query(namespace + ".getQuestionCount4StudentEnd", param).get(0).get("NUM").toString();
	}
	
	@Override
	public Map<String,Object> getQtByQtid(Map param) {
		return  (Map<String,Object>)queryOne(namespace + ".getQtByQtid", param);
	}

	public int clearQuestionNum(String id){
		update(namespace + ".clearQuestionNum", id);
		return 1;
	}

    @Override
    public int updateQuestionTarget(Map param){
        return update(namespace+".updateQuestionTarget",param);
    }

    @Override
    public Map<String,Object> selectTarget(Map param){
	    return query(namespace+".selectTarget",param).get(0);
    }
    
	@Override
	public int getAllQuestionCountBycid(String cid) {
		return queryOne(namespace + ".getAllQuestionCountBycid", cid);
	}
}
