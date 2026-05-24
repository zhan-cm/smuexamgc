package com.cx.kaoyi.business.service.serviceImpl;

import com.cx.kaoyi.business.domain.Theme;
import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.domain.exampaper.ExampaperQuestion;
import com.cx.kaoyi.business.domain.exampaper.ExampaperQuestionType;
import com.cx.kaoyi.business.domain.exampaper.db.ExampaperAnswerDb;
import com.cx.kaoyi.business.domain.exampaper.db.ExampaperQuestionDb;
import com.cx.kaoyi.business.domain.exampaper.db.ExampaperQuestionTypeDb;
import com.cx.kaoyi.business.service.*;
import com.cx.kaoyi.framework.base.BaseService;


import com.cx.kaoyi.framework.cache.LocalCache;
import com.cx.kaoyi.framework.handler.PaperObjBuilder;
import com.cx.kaoyi.framework.question.repeat.PaperChangeRecorder;

import com.cx.kaoyi.framework.utils.PageUtils;
import com.cx.kaoyi.framework.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;

import javax.servlet.ServletContext;
import java.math.BigDecimal;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

//PaperService实现类，除了已有的注释外，其余请查看相应的xml(与xml的ID相对应)
@Service("paperService")
public class PaperServiceImpl extends BaseService implements PaperService{

	@Value("${wj_cid}")
	private String wj_cid; 
	
	@Autowired
    private PermissionService permissionService;
	
	@Autowired
    private SystemService systemService;
	
	@Autowired
    private QuestionService questionService;
	
	@Autowired
    private VerifyService verifyService;

	@Autowired
	private UserService userService;

	@Autowired
	private PaperChangeRecorder paperChangeRecorder;
	
	public static String namespace = "resources.mappers.paper";

	@Override
	public String getExamInfoID() {
		return query(namespace + ".getExamInfoID").get(0).get("KEY").toString();
	}

	@Override
	public int addExamInfo(Map param) {
		insert(namespace + ".addExamInfo", param);
		//添加试卷课程关系
		Map m = new HashMap();
		m.put("eid", param.get("id"));
		m.put("cid", param.get("cid"));
		insert(namespace + ".addExampaperCourse", m);
		
		//更新课程的试卷数
		update(namespace+".call_updateCoursePapercount",(String)param.get("cid"));
		
		//添加试卷与组卷人的权限关系
		m.put("uid", param.get("teacherid"));
		List<String> cpls = new ArrayList<>();
		cpls.add("31");
		cpls.add("33");
		cpls.add("34");
		cpls.add("35");
		cpls.add("37");		
		cpls.add("38");	
		m.put("cpls", cpls);
		permissionService.addTeacherPaperPermission(m, (String)param.get("teacherid"));

		Map<String,Object> lastVerifyMap = systemService.getSystemParam("lastverify");
		for(int i=1;i<=4;i++){
			//获取系统设置的默认审核人
			String mr = (String) lastVerifyMap.get("YL_"+i);
			if(mr!=null&&!"".equals(mr)){
				User user=userService.findByUsername(mr);
				if(user!=null && !param.get("teacherid").equals(user.getId())){
					m.put("uid", user.getId());
					List<String> cpls_ = new ArrayList<>();
					cpls_.add("31");
					cpls_.add("36");
					m.put("cpls", cpls_);
					permissionService.addTeacherPaperPermission(m, user.getId());
				}
			}
		}
		
		param.put("ei_id", param.get("id"));
		insert(namespace + ".addExamObject", param);
		
		return 1;
	}
	
	@Override
	/**
	 * 多课程组卷--添加考务信息
	 * @author yoyo 
	 */
	public int addExamInfo4MultiCourse(Map param) {
		insert(namespace + ".addExamInfo", param);
		//添加试卷课程关系
		String[] cids = ((String)param.get("cid")).split(",");
		Map m = new HashMap();
		m.put("eid", param.get("id"));
		for(String cid:cids){			
			m.put("cid", cid);
			insert(namespace + ".addExampaperCourse", m);
			update(namespace+".call_updateCoursePapercount",cid);
		}
		param.put("ei_id", param.get("id"));
		insert(namespace + ".addExamObject", param);		
		
		//添加试卷与组卷人的权限关系
		m.put("uid", param.get("teacherid"));
		List<String> cpls = new ArrayList<String>();
		cpls.add("31");
		cpls.add("33");
		cpls.add("34");
		cpls.add("35");
		cpls.add("37");		
		cpls.add("38");	
		m.put("cpls", cpls);
		permissionService.addTeacherPaperPermission(m, (String)param.get("teacherid"));

		Map<String,Object> lastVerifyMap = systemService.getSystemParam("lastverify");
		for(int i=1;i<=4;i++){
			//获取系统设置的默认审核人
			String mr = (String) lastVerifyMap.get("YL_"+i);
			if(mr!=null&&!"".equals(mr)){
				User user=userService.findByUsername(mr);
				if(user!=null && !param.get("teacherid").equals(user.getId())){
					m.put("uid", user.getId());
					List<String> cpls_ = new ArrayList<>();
					cpls_.add("31");
					cpls_.add("36");
					m.put("cpls", cpls_);
					permissionService.addTeacherPaperPermission(m, user.getId());
				}
			}
		}
		
		return 1;
	}

	@Override
	public int addBExamInfo(Map param) {
		insert(namespace + ".addBExamInfo", param);
		param.put("bid", param.get("id"));
		addBidOrCid(Objects.toString(param.get("aid"),""), Objects.toString(param.get("bid"),""), null);
		insert(namespace + ".addBExamObject", param);
		
		//添加课程关系
		this.addBExampaperCourse(param);
		
		List<Map<String,Object>> cids = query(namespace+".selectReleCid4Paper",param.get("aid"));
		for(Map<String,Object> m:cids){
			update(namespace+".call_updateCoursePapercount",(String)m.get("CID"));
		}
		
		//添加试卷权限
		permissionService.addTeacherBPaperPermission(param);
		
		return 1;
	}

	private int addBidOrCid(String eid, String bid, String cpid){
		if(eid==null || "".equals(eid)){
			return 0;
		}
		Map<String, Object> param = new HashMap<>();
		param.put("eid", eid);
		if(bid!=null && !"".equals(bid)){
			param.put("bid", bid);
		}
		if(cpid!=null && !"".equals(cpid)){
			param.put("cpid", cpid);
		}
		if(param.size()<2){
			return 0;
		}
		return update(namespace + ".addBidOrCid", param);
	}

	@Override
	public int structurePaper(Map param) {
		List<Map<String,Object>> qList = (List<Map<String, Object>>) param.get("question");
		if(qList!= null && qList.size()>0){
			insert(namespace + ".addExampaperQuestion_2", qList);
			//添加答案
			insert(namespace+".addExampaperAnswer",param.get("question"));
		}
		List<Map<String,Object>> mList = (List<Map<String, Object>>) param.get("mainQuestion");
		if(mList!=null && mList.size()>0){
			Map main = new HashMap();
    		main.put("mainquestion", param.get("mainQuestion"));
    		main.put("eid", param.get("ei_id"));
    		//addExampaperMainQuestion_2(main);
    		insert(namespace + ".addExampaperMainQuestion_2", main);
		}
		//添加试卷参数，用来之后组B卷		
		insert(namespace + ".addExampaperQuestionParam", param);		
		//更新试卷试题数目
		update(namespace+".updatePaperQuestionCount", param.get("ei_id"));
		
		//添加试卷题型
		//insert(namespace + ".addExampaperQuestionType", param);
		List<Map<String,Object>> qtList=query(namespace+".getQuestionType4Structure",param);
		for(int i=0;i<qtList.size();i++){
			String qtid=String.valueOf(qtList.get(i).get("QTID"));
			int qcount=Integer.parseInt(String.valueOf(qtList.get(i).get("QCOUNT")));
			int sxb=Integer.parseInt(String.valueOf(qtList.get(i).get("SXB")));
			for(int j=(i+1);j<qtList.size();j++){
				if(qtid.equals((String.valueOf(qtList.get(j).get("QTID"))))){
					if(Integer.parseInt(String.valueOf(qtList.get(j).get("SXB")))==1){
						sxb=1;
					}
					qcount+=Integer.parseInt(String.valueOf(qtList.get(j).get("QCOUNT")));
					qtList.remove(j);
					j--;
				}
				
			}
			qtList.get(i).put("SXB", sxb);
			qtList.get(i).put("QCOUNT", qcount);
		}
		Map qtMap=new HashMap();
		qtMap.put("qtList", qtList);
		insert(namespace+".addExampaperQuestionType",qtMap);
		paperChangeRecorder.recordPaperChange((String) param.get("ei_id"));
		return 1;
	}
	
	public int generateBpaper(Map param) {
		int insertNum = 0;
		List<Map<String,Object>> qList = (List<Map<String, Object>>) param.get("question");//题目
		if(qList!= null && qList.size()>0){
			insertNum = insert(namespace + ".addExampaperQuestion_2", qList);
			try{
				//添加答案
				insert(namespace+".addExampaperAnswer",qList);
			}catch (Exception e){
				e.printStackTrace();
			}
		}
		List<Map<String,Object>> mList = (List<Map<String, Object>>) param.get("mainQuestion");
		if(mList!=null && mList.size()>0){
			Map main = new HashMap();
    		main.put("mainquestion", param.get("mainQuestion"));
    		main.put("eid", param.get("ei_id"));
    		//addExampaperMainQuestion_2(main);
    		insert(namespace + ".addExampaperMainQuestion_2", main);
		}
		//添加试卷参数，用来之后组B卷		
		insert(namespace + ".addExampaperQuestionParam", param);		
		//更新试卷试题数目
		update(namespace+".updatePaperQuestionCount", param.get("ei_id"));
		   
		//添加试卷题型
		insert(namespace + ".addExampaperQuestionTypeBPaper", param);

		String eid = (String)param.get("ei_id");
		Map qtm = new HashMap();        
        qtm.put("ei_id", eid); 
        
		List<Map<String,Object>> aqtmList = query(namespace+".selectQuestionTypeFromPaper", param.get("aid"));
		List<Map<String,Object>> qtmList = query(namespace+".selectQuestionTypeFromPaper",eid);
		for(Map<String,Object> mm:qtmList){
			for(Map<String,Object> am:aqtmList){
				if(((String)mm.get("QTID")).equals((String)am.get("QTID"))){
					mm.put("SCORE", am.get("SCORE"));
					mm.put("ANSWERTIME", am.get("ANSWERTIME"));
					if(mm.get("SCORE")!=null && mm.get("ANSWERTIME")!=null){
						mm.put("eid",eid);
						update(namespace+".updateBExamQTByAExamQT",mm);
					}
					break;
				}
			}
			qtm.put("qtid", mm.get("QTID"));
			String s = "0";
			if(!StringUtils.isEmpty(mm.get("SCORE"))) {
				s = mm.get("SCORE").toString();
			}
			BigDecimal score = new BigDecimal(String.valueOf(s));
			qtm.put("qtscore", score.setScale(4, 1));
			update(namespace + ".updatePaperQuestion", qtm);
			if(!"-1".equals(String.valueOf(mm.get("ANSWERTIME")))){	        
		        qtm.put("qttime", mm.get("ANSWERTIME"));
				update(namespace + ".updatePaperQuestionTime", qtm);
			}
		}
		//检查是否有没有答案记录的试题
		List<Map<String,Object>> qidList=query(namespace+".checkLostAnswer",eid);
		if(qidList!=null&&qidList.size()>0) {
			insert(namespace+".addLostAnswer",qidList);
		}
		paperChangeRecorder.recordPaperChange(eid);
		return insertNum;
	}
	
	@Override
	public int addExampaperMainQuestion_2(Map param) {
		// TODO Auto-generated method stub
		return insert(namespace + ".addExampaperMainQuestion_2", param);
	}

	@Override
	public List<Map<String, Object>> getQuestion4adjustOrder(Map map) {
		return query(namespace + ".getQuestion4adjustOrder", map);
	}

	@Override
	public String movePaperQuestionOrder(Map map) {
		String mode = String.valueOf(map.get("mode"));
		String direction = String.valueOf(map.get("direction"));
		String eid = String.valueOf(map.get("eid"));
		String qid = String.valueOf(map.get("qid"));

		if ("branch".equals(mode)) {
			List<Map<String, Object>> list = query(namespace + ".getBranch4adjustOrder", map);
			if (list.size() <= 1) {
				return "只有一个分支";
			}

			int index = -1;
			for (int i = 0; i < list.size(); i++) {
				if (qid.equals(String.valueOf(list.get(i).get("qid")))) {
					index = i;
					break;
				}
			}

			if (index == -1) {
				return "分支不存在";
			}

			int targetIndex = -1;
			if ("up".equals(direction)) {
				targetIndex = index - 1;
				if (targetIndex < 0) {
					return "已经是第一个分支";
				}
			} else {
				targetIndex = index + 1;
				if (targetIndex >= list.size()) {
					return "已经是最后一个分支";
				}
			}

			int startQorder = Utils.changeObjToInt(list.get(0).get("qorder"));
			int startTh = Utils.changeObjToInt(list.get(0).get("th"));

			Map<String, Object> temp = list.get(index);
			list.set(index, list.get(targetIndex));
			list.set(targetIndex, temp);

			for (int i = 0; i < list.size(); i++) {
				Map param = list.get(i);
				param.put("qorder", startQorder + i);
				param.put("th", startTh + i);
				param.put("eid", eid);
				update(namespace + ".updateQuestion4adjustOrder", param);
			}
			return "success";
		}

		List<Map<String, Object>> list = query(namespace + ".getAllQuestion4adjustOrder", eid);
		if (list == null || list.size() == 0) {
			return "没有可调整的试题";
		}
		int ismain = Utils.changeObjToInt(map.get("ismain"));
		List<Map<String, Object>> thisBlock = new ArrayList<>();
		int start = -1;
		int end = -1;
		String qtid = "";
		String cid = "";
		if (ismain == 1) {
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> m = list.get(i);
				if (qid.equals(String.valueOf(m.get("qid"))) || qid.equals(String.valueOf(m.get("mqid")))) {
					if (start == -1) {
						start = i;
						qtid = String.valueOf(m.get("qtid"));
						cid = String.valueOf(m.get("cid"));
					}
					thisBlock.add(m);
					end = i;
				}
			}
		} else {
			for (int i = 0; i < list.size(); i++) {
				Map<String, Object> m = list.get(i);
				if (qid.equals(String.valueOf(m.get("qid")))) {
					start = i;
					end = i;
					qtid = String.valueOf(m.get("qtid"));
					cid = String.valueOf(m.get("cid"));
					thisBlock.add(m);
					break;
				}
			}
		}
		if (start == -1) {
			return "试题不存在";
		}
		int anchorIndex = -1;
		if ("up".equals(direction)) {
			anchorIndex = start - 1;
			if (anchorIndex < 0) {
				return "已经是第一题！";
			}
		} else {
			anchorIndex = end + 1;
			if (anchorIndex >= list.size()) {
				return "已经是最后一题！";
			}
		}
		Map<String, Object> anchor = list.get(anchorIndex);
		if (!qtid.equals(String.valueOf(anchor.get("qtid")))) {
			return "不能跨题型调整试题顺序！";
		}
		if (!cid.equals(String.valueOf(anchor.get("cid")))) {
			return "同一个题型下，不能跨课程调整试题顺序！";
		}
		String rootQid = "";
		String anchorMqid = Objects.toString(anchor.get("mqid"),"");
		int anchorIsmain = Utils.changeObjToInt(anchor.get("ismain"));
		if (anchorIsmain == 1) {
			rootQid = String.valueOf(anchor.get("qid"));
		} else if (!"".equals(anchorMqid) && !"null".equals(anchorMqid)) {
			rootQid = anchorMqid;
		} else {
			rootQid = String.valueOf(anchor.get("qid"));
		}
		List<Map<String, Object>> targetBlock = new ArrayList<>();
		int targetStart = -1;
		int targetEnd = -1;
		for (int i = 0; i < list.size(); i++) {
			Map<String, Object> m = list.get(i);
			if (rootQid.equals(String.valueOf(m.get("qid"))) || rootQid.equals(String.valueOf(m.get("mqid")))) {
				if (targetStart == -1) {
					targetStart = i;
				}
				targetBlock.add(m);
				targetEnd = i;
			}
		}
		if (targetStart == -1) {
			return "目标试题不存在";
		}
		List<Map<String, Object>> newList = new ArrayList<>();
		if ("up".equals(direction)) {
			for (int i = 0; i < targetStart; i++) {
				newList.add(list.get(i));
			}
			newList.addAll(thisBlock);
			newList.addAll(targetBlock);
			for (int i = end + 1; i < list.size(); i++) {
				newList.add(list.get(i));
			}
		} else {
			for (int i = 0; i < start; i++) {
				newList.add(list.get(i));
			}
			newList.addAll(targetBlock);
			newList.addAll(thisBlock);
			for (int i = targetEnd + 1; i < list.size(); i++) {
				newList.add(list.get(i));
			}
		}
		for (int i = 0; i < newList.size(); i++) {
			Map param = newList.get(i);
			param.put("qorder", i + 1);
			param.put("th", i + 1);
			param.put("eid", eid);
			update(namespace + ".updateQuestion4adjustOrder", param);
		}

		return "success";
	}

	@Override
	public List<Map<String, Object>> getExampaperQuestionTypeList(String ei_id) {
		updatePaperQuestionOrder(ei_id);
		return query(namespace + ".getExampaperQuestionTypeList", ei_id);
	}

	@Override
	public int updatePaperQuestionType(Map param) {
		update(namespace + ".updatePaperQuestionType", param);
		if(!String.valueOf(param.get("qttime")).equals("-1")){
			update(namespace + ".updatePaperQuestionTime", param);
		}
		update(namespace + ".updatePaperQuestionTypeQTTime", param);
		return update(namespace + ".updatePaperQuestion", param);
	}
	
	@Override
	public int updatePaperQuestionTypeQTTime(Map param){
		return update(namespace + ".updatePaperQuestionTypeQTTime", param);
	}

	@Override
	public List<Map<String, Object>> getExampaperQuestionList(Map param, PageUtils pu) {
		List<Map<String, Object>> rs = query(namespace + ".getExampaperQuestionList", param, pu.getRb());
		return rs;
	}

	@Override
	public List<String> findExampaperIllegalAnswerQids(String eid){
		Map<String, Object> param = new HashMap<>();
		param.put("eid", eid);
		param.put("limitAnswerType", "object");
		// 1. 查出所有答案
		List<ExampaperAnswerDb> answerDbList = queryList(namespace + ".getExampaperAnswerRaw", param);

		// 2. 按 qid 分组
		Map<String, List<ExampaperAnswerDb>> answerDbMap = new HashMap<>();
		for (ExampaperAnswerDb answerDb : answerDbList) {
			answerDbMap
					.computeIfAbsent(answerDb.getQid(), k -> new ArrayList<>())
					.add(answerDb);
		}

		// 3. 遍历每个 qid，判断是否有重复答案
		List<String> illegalQids = new ArrayList<>();
		for (Map.Entry<String, List<ExampaperAnswerDb>> entry : answerDbMap.entrySet()) {
			String qid = entry.getKey();
			List<ExampaperAnswerDb> list = entry.getValue();

			Set<String> contentSet = new HashSet<>();
			Set<String> content6Set = new HashSet<>();

			for (ExampaperAnswerDb a : list) {
				String content = Utils.stripAllHtml4Compare(a.getContent());
				if (content != null && !"".equals(content) && !contentSet.add(content)) { // content 重复
					illegalQids.add(qid);
				}
				String content6 = Utils.stripAllHtml4Compare(a.getContent_6());
				if (content6 != null && !"".equals(content6) && !content6Set.add(content6)) { // content_6 重复
					illegalQids.add(qid);
				}
			}
		}
		return illegalQids;
	}
	
	@Override
	public List<Map<String, Object>> getExampaperQuestionList4xls(Map param) {
		List<Map<String, Object>> rs = query(namespace + ".getExampaperQuestionList4xls", param);
		return rs;
	}

	@Override
	public String getQuestionCount(Map param) {
		return query(namespace + ".getQuestionCount", param).get(0).get("NUM").toString();
	}
	
	@Override
	public List<Map<String, Object>> getPaperDifficultyDistribution(Map param) {
		return query(namespace + ".getPaperDifficultyDistribution", param);
	}

	@Override
	public Map<String, BigDecimal> getThemeLevelStatsForPaper(String eid){
		return queryOne(namespace + ".getThemeLevelStatsForPaper", eid);
	}
	
	@Override
	public List<Map<String,Object>> getThemeCount4ForseePaper(Map param){
		return query(namespace+".getThemeCount4ForseePaper",param);
	}
	
	@Override
	public List<Map<String,Object>> getAllDiff4ForseePaper(Map param){
		return query(namespace+".getAllDiff4ForseePaper",param);
	}
	
	@Override
	public List<Map<String,Object>> getAllKnow4ForseePaper(Map param){
		return query(namespace+".getAllKnow4ForseePaper",param);
	}
	
	@Override
	public List<Map<String,Object>> getAllCogn4ForseePaper(Map param){
		return query(namespace+".getAllCogn4ForseePaper",param);
	}
	
	@Override
	public List<Map<String,Object>> getAllQt4ForseePaper(Map param){
		return query(namespace+".getAllQt4ForseePaper",param);
	}
	
	@Override
	public List<Map<String,Object>> getRealDiff4ForseePaper(String eid){
		return query(namespace+".getRealDiff4ForseePaper",eid);
	}

	@Override
	public List<Map<String, Object>> getPaperKnowledgeDistribution(Map param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getPaperKnowledgeDistribution", param);
	}

	@Override
	public List<Map<String, Object>> getPaperCognitionDistribution(Map param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getPaperCognitionDistribution", param);
	}

	@Override
	public List<Map<String, Object>> getPaperQuestionTypeDistribution(Map param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getPaperQuestionTypeDistribution", param);
	}
	
	@Override
	public List<Map<String, Object>> getPaperWjDistribution(Map param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getPaperWjDistribution", param);
	}
	
	
	@Override
	public Map<String, Object> getExamInfo(String ei_id) {
		List<Map<String, Object>> list = query(namespace + ".getExamInfo", ei_id);
		if (list != null && !list.isEmpty()) {
			Map<String, Object> examInfo = list.get(0);
			if (examInfo.containsKey("ENAME") && examInfo.get("ENAME") != null) {
				String ename = (String) examInfo.get("ENAME");
				String modifiedEname = ename.replace("\"", "\u201C");
				examInfo.put("ENAME", modifiedEname);
			}
			return examInfo;
		} else {
			return null;
		}
	}
	
	@Override
	public String getState4Exam(String eid) {
		return String.valueOf(query(namespace+".getState4Exam",eid).get(0).get("STATE"));
	}
	
	@Override
	public Map<String, Object> getExamInfoByTypeID(Map param) {
		List<Map<String, Object>> list = query(namespace + ".getExamInfoByTypeID", param);
		if(list!=null && list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	@Override
	public Map<String, Object> getCourseByTypeID(Map param) {
		List<Map<String, Object>> list = query(namespace + ".getCourseByTypeID", param);
		if(list!=null && list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	@Override
	public List<Map<String, Object>> getExamInfoByEid_Tid(Map param) {
		// TODO Auto-generated method stub		
		return query(namespace + ".getExamInfoByEid_Tid", param);
	}
	

	@Override
	public List<Map<String, Object>> getExamObject(String ei_id) {
		// TODO Auto-generated method stub
		return query(namespace + ".getExamObject", ei_id);
	}
	
	@Override
	public List<Map<String, Object>> getUnitBySpecialty(List<String> speList) {
		return query(namespace + ".getUnitBySpecialty", speList);
	}

	@Override
	public int deleteExampaperQuestionByEIID(String ei_id) {
		Map param = new HashMap();
		param.put("ei_id", ei_id);
		delete(namespace + ".deleteExampaperQuestion", param);
		delete(namespace + ".deleteExampaperQuestionParam", ei_id);
		return delete(namespace + ".deleteExampaperQuestionType", ei_id);
	}

	@Override
	public int deleteExampaper(String eid) {
		Map<String,Object> examinfo = this.getExamInfo(eid);
		String[] cids = ((String)examinfo.get("CID")).split(",");
		for(String cid:cids){
			update(namespace+".call_updateCoursePapercount",cid);
		}
		deleteExampaperQuestionByEIID(eid);
		paperChangeRecorder.recordPaperChange(eid);
		return delete(namespace + ".deleteExampaper", eid) + delete(namespace + ".deleteExamObjectList", eid);
	}

	@Override
	public List<Map<String, Object>> getExampaperQuestionParam(String ei_id) {
		// TODO Auto-generated method stub
		return query(namespace + ".getExampaperQuestionParam", ei_id);
	}
	
	@Override
	public List<Map<String, Object>> getExampaperQuestionParamSpec(Map param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getExampaperQuestionParamSpec", param);
	}

	@Override
	public List<Map<String, Object>> getPaperQuestion(Map param, PageUtils pu) {
		List<Map<String, Object>> list = query(namespace + ".getPaperQuestion", param, pu.getRb());
		List<Map<String, Object>> list_s = query(namespace + ".getPaperQuestionSelect", param);
		//查询加题的卷子是A卷还是B卷，0==A   1==B
		String bid=(String)param.get("bid");
		String cpid=(String)param.get("cpid");
		if(!"".equals(bid)) {
			Map bMap = new HashMap();
			bMap.put("cid",param.get("cid"));
			bMap.put("eid",bid);
			List<Map<String, Object>> aList_s = query(namespace + ".getPaperQuestionSelect", bMap);
			for (Map<String, Object> map : list) {
				String qid =map.get("qid").toString();
				map.put("existB",2);
				for (Map<String,Object> aQidMap: aList_s) {
					String aQid = aQidMap.get("QID").toString();
					if(qid.equals(aQid)){
						map.put("existB",1);
						break;
					}
				}
			}
		}
		if(!"".equals(cpid)) {
			Map cMap = new HashMap();
			cMap.put("cid",param.get("cid"));
			cMap.put("eid",cpid);
			List<Map<String, Object>> aList_s = query(namespace + ".getPaperQuestionSelect", cMap);
			for (Map<String, Object> map : list) {
				String qid =map.get("qid").toString();
				map.put("existC",2);
				for (Map<String,Object> aQidMap: aList_s) {
					String aQid = aQidMap.get("QID").toString();
					if(qid.equals(aQid)){
						map.put("existC",1);
						break;
					}
				}
			}
		}
		for (Map<String, Object> map : list) {
			String qid =map.get("qid").toString();
			map.put("existA", 2);
			for (Map<String, Object> map_s : list_s) {
				String qid_s =map_s.get("QID").toString();
				if(qid.equals(qid_s)) {
					map.put("existA", 1);					
				}
				
			}
		}
		for(Map<String,Object> question:list){
			double distinction=Double.parseDouble(String.valueOf(question.get("distinction")));
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
	public int deleteExampaperQuestion(Map param){
		delete(namespace + ".deleteExampaperQuestion", param);	
		if(!StringUtils.isEmpty(param.get("mqid"))){
			String num = query(namespace + ".getExampaperMainQuestionCount", param).get(0).get("NUM").toString();
			if(num.equals("0")){
				delete(namespace + ".deleteExampaperMainQuestion", param);	
			}
		}else{
			List<Map<String,Object>> qids = query(namespace + ".getExampaperMainQuestion", param);
			if(qids.size() > 0) {
				for(Map m:qids) {
					delete(namespace + ".deleteExampaperQuestion", m);
					delete(namespace + ".deleteExampaperAnswer", m);
				}
			}
		}
		update(namespace + ".updateExampaperQuestion", param);//更新题目题型数量
		update(namespace + ".updateExampaperQuestionParam", param);//更新试卷参数数目
		delete(namespace+".deleteEQPWhenNumis0",param);
		delete(namespace+".deleteEQTWhenNumis0",param);
		update(namespace+".updatePaperQuestionCount", param.get("ei_id"));
		delete(namespace+ ".deleteExampaperAnswer",param);

		String eid = String.valueOf(param.get("ei_id"));
		LocalCache cache = LocalCache.getInstance();
		List<Map<String,Object>> list = cache.get("exampaper_question", eid);
		if(list!=null){
			cache.evict("exampaper_question", eid);
		}
		List<Map<String,Object>> qtList = cache.get("exampaper_qtype", eid);
		if(qtList!=null){
			cache.evict("exampaper_qtype", eid);
		}
		paperChangeRecorder.recordPaperChange(eid);
		return 1;
	}

	@Override
	public int updateExampaperQuestion(Map param){
		update(namespace + ".updateExampaperQuestion", param);
		update(namespace + ".updateExampaperQuestionParam", param);
		return 1;
	}
	

	@Override
	public int addQuestionIntoPaper(Map m) {
		Map<String, Object> param = new HashMap<>();
		ArrayList<Map<String, Object>> qids = new ArrayList<>();
		int mqcount = 0;//题干数量
		String[] res = (String[]) m.get("qids");
		int qorder = queryOne(namespace + ".getMaxQorder", m.get("ei_id"));
		for(int i = 0; i < res.length; i++) {
			String[] r = res[i].split("_");
			String qid = r[0];
			int ismain = Integer.parseInt(r[1]);
			//如果是题干
			Map<String, Object> ms = new HashMap<String, Object>();
			ms.put("qid", qid);
			ms.put("qorder", ++qorder);
			qids.add(ms);
			if(ismain == 1) {
				List<Map<String, Object>> branches = query(namespace + ".getAllTheBranches", qid);
				for(Map mm : branches) {
					Map<String, Object> md = new HashMap<String, Object>();
					md.put("qid", mm.get("QID").toString());
					md.put("qorder", ++qorder);
					qids.add(md);
				}
				mqcount++;
			}
		}
		int rtn=qids.size()-mqcount;
		String eid = (String)m.get("ei_id");
		param.put("qids", qids);
		param.put("ei_id", eid);
		//检查是否已经存在
		List<Map<String,Object>> qList=query(namespace+".getExistsQuestion",param);
		if(qList!=null&&qList.size()>0){
			return 0;
		}
		
		if(qids.size()>0){
			insert(namespace+".addQuestionIntoPaper_2",param);
			insert(namespace+".addAnswerIntoPaper_2",param);
		}
		
		//调整exampaper_questiontype和exampaper_questionparam
		changeExampaperParamAndQType(eid);	
		//更新试卷试题数目
		update(namespace+".updatePaperQuestionCount", eid);
		
		//return qidAll.length-mlist.size();
		LocalCache cache = LocalCache.getInstance();
		List<Map<String,Object>> list = cache.get("exampaper_question", eid);
		if(list!=null){
			cache.evict("exampaper_question", eid);
		}
		List<Map<String,Object>> qtList = cache.get("exampaper_qtype", eid);
		if(qtList!=null){
			cache.evict("exampaper_qtype", eid);
		}
		paperChangeRecorder.recordPaperChange(eid);
		return rtn;
	}

	private void changeExampaperParamAndQType(String eid) {
		List<Map<String, Object>> qtype = query(namespace + ".getAllExampaperQuestionType", eid);
		for(int i=0;i<qtype.size();i++){
			String qtid=String.valueOf(qtype.get(i).get("QTID"));
			int qcount=Integer.parseInt(String.valueOf(qtype.get(i).get("QCOUNT")));
			int sxb=Integer.parseInt(String.valueOf(qtype.get(i).get("SXB")));
			for(int j=(i+1);j<qtype.size();j++){
				if(qtid.equals((String.valueOf(qtype.get(j).get("QTID"))))){
					if(Integer.parseInt(String.valueOf(qtype.get(j).get("SXB")))==1){
						sxb=1;
					}
					qcount+=Integer.parseInt(String.valueOf(qtype.get(j).get("QCOUNT")));
					qtype.remove(j);
					j--;
				}
			}
			qtype.get(i).put("QCOUNT", qcount);
			qtype.get(i).put("SXB", sxb);
		}
		
		List<Map<String, Object>> existQtid = query(namespace + ".getQtidFromExampaperQuestionType", eid);
		int qtorder = existQtid.size();
		
		//删除qcount为0的题型
		for(int j=0;j<existQtid.size();j++) {
			boolean flag = false;
			for(Map m : qtype) {
				if(existQtid.get(j).get("QTID").toString().equals(m.get("QTID").toString())){
					flag = true;
					break;
				}
			}
			if(flag==false) {
				Map mm = new HashMap();
				mm.put("eid",eid);
				mm.put("qtid", existQtid.get(j).get("QTID"));
				delete(namespace + ".delExampaperQtype",mm);
			}
		}
		
		for(int j = 0; j < qtype.size(); j++) {
			boolean flag = false;//exampaper_questiontype有题型不存在
			for(int k = 0; k < existQtid.size(); k++) {
				if((String.valueOf(existQtid.get(k).get("QTID"))).equals(String.valueOf(qtype.get(j).get("QTID")))) {
					flag = true;
					break;
				}
			}
			if(flag==true) {//此题型存在
				update(namespace + ".updateExampaperQuestiontype", qtype.get(j));
			}else {//此题型不存在
				qtype.get(j).put("QTORDER", qtorder);
				insert(namespace + ".insertExampaperQuestionType", qtype.get(j));
				
				qtorder++;
			}
		}
		
		//以防删除为0的题型后qtorder错乱,重新排序
		Map param = new HashMap();
		param.put("ei_id", eid);
		List<Map<String, Object>> qtList = query(namespace + ".getExampaperQuestionTypeList", param);
		for(int i=0; i<qtList.size(); i++) {
			Map mm = new HashMap();
			mm.put("qtorder", i);
			mm.put("eid", eid);
			mm.put("qtid", qtList.get(i).get("QTID"));
			update(namespace+".updatePaperQtOrder", mm);
		}
		
		delete(namespace+".delExampaperQuestionParam",eid);
		
		insert(namespace + ".addExampaperQuestionParam",param);
	}
	
	@Override
	public int addExampaperCourse(Map param){
		insert(namespace+".addExampaperCourse", param);
		return 1;
	}
	
	@Override
	public int addQuestionIntoPaperFromPaper(Map param) {
		String ei_id = (String)param.get("ei_id");
		int sum = 0;
		//添加分支的主题干
		String[] qids_str = (String[]) param.get("qids");
		for(String qid:qids_str){
			Map<String,Object> qidM = new HashMap<String,Object>();
			String[] str = qid.split("_");
			qidM.put("qid", str[0]);
			qidM.put("eid", str[1]);
			qidM.put("qtid", str[2]);
			qidM.put("ei_id", ei_id);
			int ismain = Integer.parseInt(str[3]);//老版本的qtid没有atid和iscon，以防数组越界
			if(str.length>5){  
				ismain = Integer.parseInt(str[5]);
			}
			
			if(ismain == 1) {
				insert(namespace+".addExampaperQuestion_fromP",qidM);//添加题干
				Map<String,Object> branchParam = new HashMap<String,Object>();
				branchParam.put("qid", str[0]);
				branchParam.put("eid", str[1]);
				List<Map<String, Object>> branches = query(namespace + ".getAllBranchesFromPaper",branchParam);
				for(Map b:branches) {
					String qids = b.get("QID").toString();
					qidM.put("qid", qids);
					insert(namespace+".addExampaperQuestion_fromP",qidM);
					insert(namespace+".addExampaperAnswer_fromP",qidM);
					sum++;
				}
			}else {
				insert(namespace+".addExampaperQuestion_fromP",qidM);
				insert(namespace+".addExampaperAnswer_fromP",qidM);
				sum++;
			}
			
		}
		
		//调整exampaper_questiontype和exampaper_questionparam
		changeExampaperParamAndQType(ei_id);		
		//更新试卷试题数目
		update(namespace+".updatePaperQuestionCount", ei_id);
		
		Map<String, Object> map = getExamInfo(ei_id);
		if ("0".equals(map.get("STATE")+"") || "1".equals(map.get("STATE")+"") || "2".equals(map.get("STATE")+"")) {
			updateReloadPaper(ei_id);
		}
		
		updatePaperQuestionOrder(ei_id);
		
		/*List<Map<String,Object>> cidList=query(namespace+".getNotExistsGXCid",ei_id);
		Map<String,Object> mm=new HashMap<String,Object>();
		mm.put("eid", ei_id);
		if(cidList!=null&&cidList.size()>0){
			StringBuilder sb=new StringBuilder();
			String cids=String.valueOf(map.get("CID"));
			sb.append(cids+",");
			String[] cidArray=cids.split(",");
			for(int i=0;i<cidList.size();i++){
				String c=String.valueOf(cidList.get(i).get("CID"));
				boolean b=false;
				for(String str:cidArray){
					if(str.endsWith(c)){
						b=true;
						break;
					}
				}
				if(!b){
					sb.append(c+",");
				}
				mm.put("cid", c);
				update(namespace+".addExampaperCourse",mm);
			}
			mm.put("cids", sb.substring(0, sb.length()-1));
			update(namespace+".updateCid4Paper",mm);
		}*/

		LocalCache cache = LocalCache.getInstance();
		List<Map<String,Object>> list = cache.get("exampaper_question", ei_id);
		if(list!=null){
			cache.evict("exampaper_question", ei_id);
		}
		List<Map<String,Object>> qtList = cache.get("exampaper_qtype", ei_id);
		if(qtList!=null){
			cache.evict("exampaper_qtype", ei_id);
		}
		paperChangeRecorder.recordPaperChange(ei_id);
		return sum;
	}

	private void changeExampaperCourse(String ei_id) {
		// TODO Auto-generated method stub
		List<Map<String, Object>> ls = query(namespace + ".getExampaperCourseByEid", ei_id);
		delete(namespace + ".delExampaperCourse", ei_id);//根据eid清空exampaper_course
		StringBuilder cids = new StringBuilder();
		for(Map m:ls) {
			cids.append((String) m.get("CID") + ",");
			Map param = new HashMap();
			param.put("cid", m.get("CID"));
			param.put("eid", m.get("EID"));
			insert(namespace + ".addExampaperCourse", param);
		}
		String cid = cids.toString().substring(0, cids.toString().length()-1);
		Map param = new HashMap();
		param.put("cid", cid);
		param.put("eid", ei_id);
		update(namespace + ".updateExaminfoCids", param);
	}

	@Override
	public int addQuestion4CombinePaper(Map param) {
		String ei_id = (String)param.get("ei_id");
		int sum = 0;
		//添加分支的主题干
		String[] qids_str = (String[]) param.get("qids");
		//查询试题是否选项得分
		
		for(String qid:qids_str){
			Map<String,Object> qidM = new HashMap<String,Object>();
			String[] str = qid.split("#");
			qidM.put("qid", str[0]);
			qidM.put("eid", str[1]);
			qidM.put("qtid", str[2]);
			qidM.put("ei_id", ei_id);
			
			int ismain = Integer.parseInt(str[3]);
			if(ismain == 1) {
				insert(namespace+".addExampaperQuestion_fromP",qidM);//添加题干
				Map map=new HashMap();
				map.put("eid", str[1]);
				map.put("qid", str[0]);
				List<Map<String, Object>> branches = query(namespace + ".getAllBranchesFromPaper",map);
				for(Map b:branches) {
					String qids = b.get("QID").toString();
					qidM.put("qid", qids);
					insert(namespace+".addExampaperQuestion_fromP",qidM);
					insert(namespace+".addExampaperAnswer_fromP",qidM);
					sum++;
				}
			}else {
				insert(namespace+".addExampaperQuestion_fromP",qidM);
				insert(namespace+".addExampaperAnswer_fromP",qidM);
				sum++;
			}
			
		}
		//调整exampaper_questiontype和exampaper_questionparam
		changeExampaperParamAndQType(ei_id);		
		//更新试卷试题数目
		update(namespace+".updatePaperQuestionCount", ei_id);
		
		Map<String, Object> map = getExamInfo(ei_id);
		if ("0".equals(map.get("STATE")+"") || "1".equals(map.get("STATE")+"") || "2".equals(map.get("STATE")+"")) {
			updateReloadPaper(ei_id);
		}
		
		updatePaperQuestionOrder(ei_id);

		LocalCache cache = LocalCache.getInstance();
		List<Map<String,Object>> list = cache.get("exampaper_question", ei_id);
		if(list!=null){
			cache.evict("exampaper_question", ei_id);
		}
		List<Map<String,Object>> qtList = cache.get("exampaper_qtype", ei_id);
		if(qtList!=null){
			cache.evict("exampaper_qtype", ei_id);
		}
		paperChangeRecorder.recordPaperChange(ei_id);
		return sum;
	}
	
	@Override
	public List<Map<String, Object>> getTeacherByUnitID(String unitID) {
		// TODO Auto-generated method stub
		return query(namespace + ".getTeacherByUnitID", unitID);
	}

	@Override
	public int updateExamInfo(Map param) {
		//判断AB卷，同时更新AB卷
		Map<String,Object> examinfo = getExamInfo((String)param.get("ei_id"));
		int y_state = ((BigDecimal)examinfo.get("STATE")).intValue();
		
		if(param.get("action")!=null) {//审核，改变状态
			int state=(Integer)param.get("state");//更新后的状态
			
			delete(namespace + ".deleteExamObject", param);	
			insert(namespace + ".addExamObject", param);
			update(namespace + ".updateExamInfo", param);
			
			String bid="";
			String cpid="";
			if(examinfo.get("BID")!=null && !StringUtils.isEmpty(examinfo.get("BID"))){
				bid=String.valueOf(examinfo.get("BID"));
			}
			if(examinfo.get("CPID")!=null && !StringUtils.isEmpty(examinfo.get("CPID"))){
				cpid=String.valueOf(examinfo.get("CPID"));
			}
			
			if(!"".equals(bid)) {
				String bstate=getState4Exam(bid);
				if(!("6".equals(bstate)||"8".equals(bstate))) {
					if(state==1||state==2||state==7||state==0) {
						param.put("ei_id", bid);
						delete(namespace + ".deleteExamObject", param);	
						insert(namespace + ".addExamObject", param);
						update(namespace + ".updateExamInfo", param);
					}else if(state==3) {
						param.put("state", "-2");
						param.put("ei_id", bid);
						delete(namespace + ".deleteExamObject", param);	
						insert(namespace + ".addExamObject", param);
						update(namespace + ".updateExamInfo", param);
					}
				}
				paperChangeRecorder.recordPaperChange(bid);
			}
			if(!"".equals(cpid)) {
				String cstate=getState4Exam(cpid);
				if(!("6".equals(cstate)||"8".equals(cstate))) {
					if(state==1||state==2||state==7||state==0) {
						param.put("ei_id", cpid);
						delete(namespace + ".deleteExamObject", param);	
						insert(namespace + ".addExamObject", param);
						update(namespace + ".updateExamInfo", param);
					}else if(state==3) {
						param.put("state", "-2");
						param.put("ei_id", cpid);
						delete(namespace + ".deleteExamObject", param);	
						insert(namespace + ".addExamObject", param);
						update(namespace + ".updateExamInfo", param);
					}
				}
				paperChangeRecorder.recordPaperChange(cpid);
			}
			paperChangeRecorder.recordPaperChange((String)param.get("ei_id"));
		}else {//修改考务信息
			delete(namespace + ".deleteExamObject", param);	
			insert(namespace + ".addExamObject", param);
			update(namespace + ".updateExamInfo", param);
			paperChangeRecorder.recordPaperChange((String)param.get("ei_id"));
			if(examinfo.get("BID")!=null && !StringUtils.isEmpty(examinfo.get("BID"))){
				String bstate=getState4Exam((String)examinfo.get("BID"));
				if(!("6".equals(bstate)||"8".equals(bstate))) {
					param.put("ei_id", examinfo.get("BID"));
					delete(namespace + ".deleteExamObject", param);	
					insert(namespace + ".addExamObject", param);
					update(namespace + ".updateExamInfo", param);
					paperChangeRecorder.recordPaperChange((String) examinfo.get("BID"));
				}				
			}
			if(examinfo.get("CPID")!=null && !StringUtils.isEmpty(examinfo.get("CPID"))){
				String cstate=getState4Exam((String)examinfo.get("CPID"));
				if(!("6".equals(cstate)||"8".equals(cstate))) {
					param.put("ei_id", examinfo.get("CPID"));
					delete(namespace + ".deleteExamObject", param);	
					insert(namespace + ".addExamObject", param);
					update(namespace + ".updateExamInfo", param);
					paperChangeRecorder.recordPaperChange((String) examinfo.get("CPID"));
				}				
			}
		}
		
		
		
//		if(state!=3&&state!=4&&state!=-2){
//			if(examinfo.get("BID")!=null && !StringUtils.isEmpty(examinfo.get("BID"))){
//				String bState=this.getState4Exam((String)examinfo.get("BID"));
//				if(!"6".equals(bState)&&!"8".equals(bState)) {
//					if(param.get("action")!=null && "lastVerify".equals((String)param.get("action"))){
//						param.put("state", "-2");
//					}
//					param.put("ei_id", examinfo.get("BID"));
//					delete(namespace + ".deleteExamObject", param);	
//					insert(namespace + ".addExamObject", param);
//					update(namespace + ".updateExamInfo", param);
//				}
//			}
//		}
//		if(param.get("action")!=null && "reVerify".equals((String)param.get("action"))){
//			delete(namespace + ".deleteExamObject", param);	
//			insert(namespace + ".addExamObject", param);
//			update(namespace + ".updateExamInfo", param);
//		}
		return 0;
	}

	@Override
	public String getExampaperQuestionCount(Map param) {
		return query(namespace + ".getExampaperQuestionCount", param).get(0).get("NUM").toString();
	}

	@Override
	public List<Map<String, Object>> getMqids(Map param) {
		if(param.get("thlevel").equals("1")){
			return query(namespace + ".getMqidByParamOfTh1id", param);
		}else if(param.get("thlevel").equals("2")){
			return query(namespace + ".getMqidByParamOfTh2id", param);
		}else if(param.get("thlevel").equals("3")){
			return query(namespace + ".getMqidByParamOfTh3id", param);
		}else{
			return null;
		}
	}

	@Override
	public List<Map<String, Object>> getTeacherMarkPaper(String userId, int isMobile) {
		Map<String,Object> param = new HashMap<>();
		param.put("userId", userId);
		param.put("isMobile", isMobile);
		return query(namespace + ".getTeacherMarkPaper", param);
	}
	
	@Override
	public Map<String, Object> getMqids_null(Map param) {
		if(param.get("thlevel").equals("1")){
			List<Map<String,Object>> list = query(namespace + ".getMqidByParamOfTh1id_null", param);
			if(list!=null && list.size()>0){
				return list.get(0);
			}			
		}else if(param.get("thlevel").equals("2")){
			List<Map<String,Object>> list = query(namespace + ".getMqidByParamOfTh2id_null", param);
			//假设还为空，则查询一级
			if(list!=null && list.size()>0){
				return list.get(0);
			}else {
				List<Map<String, Object>> list2 = query(namespace + ".getMqidByParamOfTh2id_nullIsNull",param);
				if(list2 != null && list2.size() > 0) {
					return list2.get(0);
				}
				//待完成
			}
		}else if(param.get("thlevel").equals("3")){
			List<Map<String,Object>> list = query(namespace + ".getMqidByParamOfTh3id_null", param);
			if(list!=null && list.size()>0){
				return list.get(0);
			}else{
				List<Map<String, Object>> list2 = query(namespace + ".getMqidByParamOfTh3id_nullIsNull",param);
				if(list2 != null && list2.size() > 0) {
					return list2.get(0);
				}
			}
		}
		return null;
	}
	
	public Map<String,Object> getMqids_extra(Map param){
		if(param.get("thlevel").equals("1")){
			List<Map<String,Object>> list1=query(namespace + ".getMqidByParamOfTh1id_extra", param);
			if(list1!=null&&list1.size()>0){
				return list1.get(0);
			}			
		}else if(param.get("thlevel").equals("2")){
			List<Map<String,Object>> list2 = query(namespace + ".getMqidByParamOfTh2id_extra", param);
			if(list2!=null&&list2.size()>0){
				return list2.get(0);
			}			
		}else if(param.get("thlevel").equals("3")){
			List<Map<String,Object>> list3 = query(namespace + ".getMqidByParamOfTh3id_extra", param);
			if(list3!=null&&list3.size()>0){
				return list3.get(0);
			}
		}
		return null;
	}

	@Override
	public List<Map<String, Object>> getPaperList(Map param, PageUtils pu) {
		return query(namespace + ".getPaperList", param, pu.getRb());
	}

	@Override
	public String getPaperCount(Map param) {
		return query(namespace + ".getPaperCount", param).get(0).get("NUM").toString();
	}
	
	@Override
	public List<Map<String, Object>> getPaperList4combinePaper(Map param, PageUtils pu) {
		return query(namespace + ".getPaperList4combinePaper", param, pu.getRb());
	}
	
	@Override
	public String getPaperList4combinePaperCount(Map param) {
		return query(namespace + ".getPaperList4combinePaperCount", param).get(0).get("NUM").toString();
	}

	@Override
	public List<Map<String, Object>> getQuestionFromPaper(Map param, PageUtils pu) {
		List<Map<String,Object>> rtn = new ArrayList<>();
		List<Map<String,Object>> list = query(namespace + ".getQuestionFromPaper", param , pu.getRb());
		Set<String> set = new HashSet<>();
		for(int i=0;i<list.size();i++){
			Map<String,Object> map = list.get(i);
			if(set.add((String)map.get("qid"))){
				rtn.add(map);
			}
		}
		for(Map<String,Object> question:rtn){
			double distinction=Double.parseDouble(String.valueOf(question.get("distinction")));
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
		return rtn;
	}

	@Override
	public List<Map<String, Object>> getDistinctQID4combinePaperCount(Map param) {

		// 1. 先查出原始结果
		List<Map<String,Object>> list = query(namespace + ".getDistinctQID4combinePaperCount", param);

		// 2. 按 qid 去重（保留第一条），同时保持顺序
		Map<String, Map<String,Object>> uniqueByQid = new LinkedHashMap<>();
		for (Map<String,Object> row : list) {
			String qid = String.valueOf(row.get("QID"));
			if (!uniqueByQid.containsKey(qid)) {
				uniqueByQid.put(qid, row);
			}
		}
		List<Map<String,Object>> distinctList = new ArrayList<>(uniqueByQid.values());

		// 3. 串题分组信息：
		//    groupFlags: 每个组的状态 1=有主题干, 2=有子题, 3=都有
		//    groupQids:  每个组内所有 qid
		Map<String, Integer> groupFlags = new HashMap<>();
		Map<String, Set<String>> groupQids = new HashMap<>();

		for (Map<String,Object> row : distinctList) {
			Object isconObj = row.get("ISCON");
			if (isconObj == null) {
				continue;
			}
			// 非串题，直接跳过
			if (!"1".equals(String.valueOf(isconObj))) {
				continue;
			}

			String qid = String.valueOf(row.get("QID"));
			Object mqidObj = row.get("MQID");
			String mqid = mqidObj == null ? null : String.valueOf(mqidObj);

			boolean isMain = (mqid == null || mqid.isEmpty());
			// 主题干用自己的 qid 为组号，子题用 mqid 为组号
			String groupId = isMain ? qid : mqid;

			// 记录组内 qid
			groupQids.computeIfAbsent(groupId, k -> new HashSet<>()).add(qid);

			// 设置标记：1 = main, 2 = child
			int oldFlag = groupFlags.getOrDefault(groupId, 0);
			int addFlag = isMain ? 1 : 2;
			groupFlags.put(groupId, oldFlag | addFlag);
		}

		// 4. 找出所有“不完整串题”里的 qid
		//    条件：flag != 3（没有主题干或没有子题）
		Set<String> badQids = new HashSet<>();
		for (Map.Entry<String, Set<String>> entry : groupQids.entrySet()) {
			String groupId = entry.getKey();
			int flag = groupFlags.getOrDefault(groupId, 0);
			if (flag != 3) {
				// 整组都剔除
				badQids.addAll(entry.getValue());
			}
		}

		// 5. 最终结果：在去重结果中，把 badQids 中的全部过滤掉
		List<Map<String,Object>> rtn = new ArrayList<>();
		for (Map<String,Object> row : distinctList) {
			String qid = String.valueOf(row.get("QID"));
			if (!badQids.contains(qid)) {
				rtn.add(row);
			}
		}
		return rtn;
	}

	@Override
	public String getQuestionFromPaperCount(Map param) {
		return query(namespace + ".getQuestionFromPaperCount", param).get(0).get("NUM").toString();
	}

	@Override
	public int updateExamQuestionType(Map param) {
		LocalCache cache = LocalCache.getInstance();
		String eid = (String) param.get("eid");
		if(eid!=null && !"".equals(eid)){
			cache.evict("exampaper_qtype", eid);
		}
		return update(namespace + ".updateExamQuestionType", param);
	}

	@Override
	public List<Map<String, Object>> selectThemeFromPaper(String eid) {
		// TODO Auto-generated method stub
		return query(namespace + ".selectThemeFromPaper", eid);
	}
	
	@Override
	public List<Map<String, Object>> selectThemeFromPaper_course(Map param) {
		return query(namespace + ".selectThemeFromPaper_course", param);
	}

	@Override
	public List<Map<String, Object>> selectDifficultyFromPaper(String eid) {
		// TODO Auto-generated method stub
		return query(namespace + ".selectDifficultyFromPaper", eid);
	}

	@Override
	public List<Map<String, Object>> selectKnowledgeFromPaper(String eid) {
		// TODO Auto-generated method stub
		return query(namespace + ".selectKnowledgeFromPaper", eid);
	}

	@Override
	public List<Map<String, Object>> selectQuestionTypeFromPaper(String eid) {
		return query(namespace + ".selectQuestionTypeFromPaper", eid);
	}

	@Override
	public List<Map<String, Object>> selectCognitionFromPaper(String eid) {
		return query(namespace + ".selectCognitionFromPaper", eid);
	}

	@Override
	public int updateQuestionScore(Map param) {
		return update(namespace + ".updateQuestionScore", param);
	}

	@Override
	public List<Map<String, Object>> getPaper(String eid) {
		return query(namespace + ".getPaper", eid);
	}

	@Override
	public List<Map<String, Object>> getPaperQuestiontype(String eid) {
		return query(namespace + ".getPaperQuestiontype", eid);
	}

	@Override
	public int copyPaper(String bid, String aid, boolean isShuffle){
		Map<String,String> param = new HashMap<>();
		param.put("aid", aid);
		param.put("bid", bid);
		insert(namespace+".copyExampaperQuestionParam", param);
		List<ExampaperQuestionType> eqt = PaperObjBuilder.buildExampaperQuestionTypesWithQuestionList(
				this.getExampaperQuestionTypeRaw(aid),
				this.getExampaperQuestionRaw(aid),
				this.getExampaperAnswerRaw(aid)
		);
		if(eqt==null || eqt.isEmpty()){
			return 0;
		}
		if(isShuffle){ //打乱顺序
			for(ExampaperQuestionType questions : eqt){
				Collections.shuffle(questions.getQuestionList());
			}
			Collections.shuffle(eqt);
		}
		List<Map<String,Object>> list4qt = new ArrayList<>();
		List<Map<String,Object>> list4question = new ArrayList<>();
		int th = 1;//题号从1开始，串题主题干的题号与其第一个子题一样
		int qorder = 0;//从0开始直接累加
		int qtorder = 0;//从0开始直接累加
		for(ExampaperQuestionType qt : eqt){
			Map<String,Object> qtParam = new HashMap<>();
			qtParam.put("bid", bid);
			qtParam.put("aid", aid);
			qtParam.put("qtorder", qtorder);
			qtParam.put("qtid", qt.getQtid());
			qtorder++;
			list4qt.add(qtParam);
			for(ExampaperQuestion question : qt.getQuestionList()){
				Map<String,Object> qParam = new HashMap<>();
				qParam.put("bid", bid);
				qParam.put("aid", aid);
				qParam.put("qid", question.getQid());
				qParam.put("qorder", qorder);
				qorder++;
				qParam.put("th", th);
				th++;
				list4question.add(qParam);
				if(question.getIsmain()!=1 || question.getBranchQuestion()==null) continue;
				for(int i=0; i<question.getBranchQuestion().size(); i++){
					ExampaperQuestion branchQuestion = question.getBranchQuestion().get(i);
					Map<String,Object> qbParam = new HashMap<>();
					qbParam.put("bid", bid);
					qbParam.put("aid", aid);
					qbParam.put("qid", branchQuestion.getQid());
					qbParam.put("qorder", qorder);
					qorder++;
					qbParam.put("th", th);
					if(i>0){//串题主题干的题号与其第一个子题一样
						th++;
					}
					list4question.add(qbParam);
				}
			}
		}
		Map<String,String> param4Ans = new HashMap<>();
		param4Ans.put("id", aid);
		param4Ans.put("eid", bid);
		insert("resources.mappers.result.addExampaperAnswer", param4Ans);
		insertBatch(namespace+".copyQuestionTypeByShuffleOrder", list4qt, 100);
		insertBatch(namespace+".copyQuestionByShuffleOrder", list4question, 100);
		update(namespace+".updatePaperQuestionCount", bid);
		paperChangeRecorder.recordPaperChange(bid);
		return 1;
	}

	@Override
	public int delExampaperQuestion(String eid) {
		//判断是否是B卷，如果是，直接删除考务信息
		Map<String,Object> examinfo = getExamInfo(eid);
		int aorb = ((BigDecimal)examinfo.get("AORB")).intValue();		
		if(aorb==1){
			verifyService.toCompleteDel(eid);//B卷彻底删除
		}else{
			delete(namespace + ".delExampaperQuestion", eid);
		}
		return 1;
	}

	@Override
	public int delExampaperQuestionParam(String eid) {
		// TODO Auto-generated method stub
		return delete(namespace + ".delExampaperQuestionParam", eid);
	}

	@Override
	public int delExampaperQuestionType(String eid) {
		// TODO Auto-generated method stub
		return delete(namespace + ".delExampaperQuestionType", eid);
	}
	/*
	@Override	
	public int delExamInfo(String eid) {
		Map<String, Object> examinfo = this.getExamInfo(eid);
		// TODO Auto-generated method stub
		delete(namespace + ".delExampaperQuestion", eid);
		delete(namespace + ".delExampaperQuestionParam", eid);
		delete(namespace + ".delExampaperQuestionType", eid);
		delete(namespace + ".deleteExamObjectList", eid);
		update(namespace + ".delBID", eid);
		delete(namespace + ".deleteExampaper", eid);
		
		Map log = new HashMap();
		log.put("content", "彻底删除《"+examinfo.get("ENAME")+"》试卷1套（B卷），其在试卷库中原序号为："+eid);		
		systemService.addSysLog(log);
		
		return 1;
	}*/

	@Override
	public int updateRawExamInfo(Map param) {
		update(namespace + ".updateExamInfo", param);
		return 0;
	}

	@Override
	public List<Map<String, Object>> getPaperQuestiontypeScore(String eid) {
		return query(namespace + ".getPaperQuestiontypeScore" , eid);
	}
	
	@Override
	public List<Map<String, Object>> getPaperQuestionScore(Map param) {
		return query(namespace + ".getPaperQuestionScore" , param);
	}

	@Override
	public int addBExampaperCourse(Map param) {
		return insert(namespace+".addBExampaperCourse",param);
	}
	
	@Override
	public int addCExampaperCourse(Map param) {
		return insert(namespace+".addCExampaperCourse",param);
	}

	@Override
	public double getTotalPoints(String eid) {
		return queryOne(namespace+".getTotalPoints",eid);
	}

	@Override
	public int getQTAnswertime(String eid) {
//		int rs = 0;
//		List<Map<String, Object>> ls = query(namespace+".getQTAnswertime",eid);
//		for(Map m : ls) {
//			Map mm = new HashMap();
//			mm.put("eid", eid);
//			if ("-1".equals(m.get("ATIME")+"")) {
//				mm.put("qtid", m.get("QTID")+"");
//				if (queryOne(namespace + ".getDefaultQTAnswertime", mm)==null) {
//					rs += 0;
//				}else {
//					rs += Integer.parseInt(String.valueOf(queryOne(namespace + ".getDefaultQTAnswertime", mm)));
//				}
//			}else {
//				String ti = queryOne(namespace + ".getSystemtimeByID", m.get("ATIME").toString())+"";
//				int t = Integer.parseInt(queryOne(namespace + ".getSystemtimeByID", m.get("ATIME").toString()).toString());
//				rs += t * Integer.parseInt(m.get("QCOUNT").toString());
//			}
//		}
		
		return queryOne(namespace + ".getQTAnswertime", eid);
	}

	@Override
	public List<Map<String, Object>> getUseTimeAndScore(String eid) {
		// TODO Auto-generated method stub
		return query(namespace+".getUseTimeAndScore", eid);
	}

	@Override
	public List<Map<String, Object>> getRandomQuestion(Map param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getRandomQuestion", param);
	}

	/*
	@Override
	public void updateExaminfoCids(Map m) {
		// TODO Auto-generated method stub
		update(namespace + ".updateExaminfoCids", m);
		insert(namespace + ".addCidToExampaperCourse", m);
	}*/

	@Override
	public int updateReloadPaper(String ei_id) {
		// TODO Auto-generated method stub
		update(namespace + ".updateTeacherState",ei_id);
		return update(namespace+".updateReloadPaper", ei_id);
	}

	@Override
	public List<Map<String, Object>> getBrachByMqid(List<Map<String,Object>> param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getBrachByMqid", param);
	}

	@Override
	public List<Map<String, Object>> getPaperNoScore(String eid) {
		return query(namespace+".getPaperNoScore", eid);
	}

	@Override
	public int deleteExampaperQuestionType(String eid) {
		return delete(namespace + ".deleteExampaperQuestionType", eid);
	}

	@Override
	public int deleteExampaperQuestionParam(String eid) {
		return delete(namespace + ".deleteExampaperQuestionParam", eid);
	}

	@Override
	public List<Map<String, Object>> getPaperQtCountAndSum(String ei_id) {
		return query(namespace + ".getPaperQtCountAndSum", ei_id);
	}

	@Override
	public List<Map<String, Object>> getPaperCheckScoreDiffAndScore(Map m) {
		return query(namespace + ".getPaperCheckScoreDiffAndScore", m);
	}

	@Override
	public String getPaperQuestionCountForCheckList(Map m) {
		return queryOne(namespace + ".getPaperQuestionCountForCheckList", m);
	}

	@Override
	public List<Map<String, Object>> getPaperCheckList(Map param) {
		return query(namespace + ".getPaperCheckList", param);
	}

	@Override
	public List<Map<String, Object>> getPaperCheckListAll(Map param) {
		return query(namespace + ".getPaperCheckListAll", param);
	}

	@Override
	public List<Map<String, Object>> getExamPaperQuestionType(Map param) {
		return query(namespace + ".getExamPaperQuestionType", param);
	}

	/**
	 * 获取所有试题，包括答案选项和答案，使用者：PaperController【previewQuestion】
	 * @author 洪艳
	 * @param 'param[qid、version]' 主题干  atid 答案分类id
	 * @return Map<String, Object>试题信息+answer正确答案+answerList【AID、ACONTENT】答案选项
	 */
	public Map<String, Object> getQuestion_AnswerByQID(Map param) {
		Map<String, Object> mainQuestionMap = getQuestionPrevew(param);
		int atid = Integer.parseInt(String.valueOf(mainQuestionMap.get("atid")));
		List<Map<String, Object>> answerLs = query(namespace + ".getAnswerByQID_Version", param);
		if(atid<4||atid==8||atid==9){
			if(answerLs.get(0)!=null&&mainQuestionMap.get("answerid")!=null){
				String[] answerid = ((String)mainQuestionMap.get("answerid")).split(",");
				StringBuilder sb = new StringBuilder();
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
			if(answerLs!=null&&answerLs.size()>0) {
				Map<String, Object> map = answerLs.get(0);
				mainQuestionMap.put("answer", map.get("ACONTENT_6"));
			}else {
				mainQuestionMap.put("answer", "");
			}
		}
		
		return mainQuestionMap;
	}
	
	@Override
	public Map<String, Object> getQuestionPrevew(Map param) {
		Map<String,Object> map = query(namespace + ".getQuestionPrevew", param).get(0);
		if(map.get("aid")!=null && map.get("cid")!=null && map.get("did")!=null && map.get("kid")!=null){
			String[] aid = ((String)map.get("aid")).split(",");
			String[] cid = ((String)map.get("cid")).split(",");
			String[] did = ((String)map.get("did")).split(",");
			String[] kid = ((String)map.get("kid")).split(",");
//			String[] answertimeid = ((String)map.get("answertime")).split(",");
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
			List<Map<String,Object>> arrangementList = new ArrayList<Map<String,Object>>();
			Map m = new HashMap();
			m.put("cid", param.get("c_id"));
			for(String a:aid){
				m.put("aid", a);
				arrangementList.add(queryOne(namespace + ".getArrangementByID",m));
			}
			List<Map<String,Object>> cognitionList = new ArrayList<Map<String,Object>>();
			for(String c:cid){
				m.put("coid", c);
				cognitionList.add(queryOne(namespace + ".getCognitionByID",m));
			}
			List<Map<String,Object>> difficultyList = new ArrayList<Map<String,Object>>();
			for(String d:did){
				m.put("did", d);
				difficultyList.add(queryOne(namespace + ".getDifficultyByID",m));
			}
			List<Map<String,Object>> knowledgeList = new ArrayList<Map<String,Object>>();
			for(String k:kid){
				m.put("kid", k);
				knowledgeList.add(queryOne(namespace + ".getKnowledgeByID",m));
			}
//			List<Map<String,Object>> answertimeList = new ArrayList<Map<String,Object>>();
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
	
	/**
	 * 获取所有分支试题，包括答案选项和答案，使用者：QuestionController【previewQuestion】
	 * @author 洪艳
	 * @param 'mqid' 主题干  atid 答案分类id
	 * @return List<Map<String, Object>>试题信息+answer正确答案+answerList【AID、ACONTENT】答案选项
	 */
	public List<Map<String, Object>> getBranchQuestion_AnswerByQID(Map param) {		
		List<Map<String, Object>> bList = query(namespace + ".getBranchQuestionByQID_version", param);
		for(int a=0;a<bList.size();a++){
			Map<String, Object> map = bList.get(a);
			map.put("eid", param.get("eid"));
			int atid = Integer.parseInt((String)map.get("atid"));
			if(atid<4){
				map.put("id", map.get("qid"));				
				List<Map<String, Object>> answerLs = query(namespace + ".getAnswerByQID_Version", map);
				if(map.get("answerid")!=null&&answerLs.get(0)!=null){
					String[] answerid = ((String)map.get("answerid")).split(",");
					StringBuilder sb = new StringBuilder();
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
			}else if(atid==4){
				map.put("id", map.get("qid"));
				Map<String, Object> answerM = query(namespace + ".getAnswerByQID_Version", map).get(0);				
				if(answerM!=null){
					if("true".equals(answerM.get("ACONTENT"))){
						map.put("answer", "对");	
					}else if("false".equals(answerM.get("ACONTENT"))){
						map.put("answer", "错");					
					}
				}
			}else{
				map.put("id", map.get("qid"));
				Map<String, Object> answerM = query(namespace + ".getAnswerByQID_Version", map).get(0);
				if(answerM!=null){
					map.put("answer", answerM.get("ACONTENT_6"));
				}					
			}
		}
		
		return bList;
	}
	
	@Override
	public Map<String, Object> getLastQuestion(Map param) {
		List<Map<String, Object>> list = query(namespace + ".getLastQuestion", param);
		if(list!=null && list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	@Override
	public Map<String, Object> getNextQuestion(Map param) {
		List<Map<String, Object>> list = query(namespace + ".getNextQuestion", param);
		if(list!=null && list.size()>0){
			return list.get(0);
		}else{
			return null;
		}
	}
	
	
	@Override
	public Map<String, Object> getQuestionInfo(Map param) {
		Map<String, Object> map = query(namespace + ".getQuestionInfo", param).get(0);
		
		if(map.get("aid")!=null && map.get("coid")!=null && map.get("did")!=null && map.get("kid")!=null){
			String[] aid = ((String)map.get("aid")).split(",");
			String[] cid = ((String)map.get("coid")).split(",");
			String[] did = ((String)map.get("did")).split(",");
			String[] kid = ((String)map.get("kid")).split(",");
			
			List<Map<String,Object>> arrangementList = new ArrayList<Map<String,Object>>();
			Map m = new HashMap();
			m.put("cid", param.get("c_id"));
			for(String a:aid){
				m.put("aid", a);
				arrangementList.add(queryOne(namespace + ".getArrangementByID",m));
			}
			List<Map<String,Object>> cognitionList = new ArrayList<Map<String,Object>>();
			for(String c:cid){
				m.put("coid", c);
				cognitionList.add(queryOne(namespace + ".getCognitionByID",m));
			}
			List<Map<String,Object>> difficultyList = new ArrayList<Map<String,Object>>();
			for(String d:did){
				m.put("did", d);
				difficultyList.add(queryOne(namespace + ".getDifficultyByID",m));
			}
			List<Map<String,Object>> knowledgeList = new ArrayList<Map<String,Object>>();
			for(String k:kid){
				m.put("kid", k);
				knowledgeList.add(queryOne(namespace + ".getKnowledgeByID",m));
			}
			List<String> answertimeList = new ArrayList<String>();
			if(StringUtils.isEmpty(map.get("answertime"))) {
				for(int i=0;i<aid.length;i++) {
					answertimeList.add(String.valueOf((map.get("answertime_b"))));
				}
			}else {
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

		int ismain=Integer.parseInt(String.valueOf(map.get("ismain")));
		if(ismain==0){
			int atid = Integer.parseInt(String.valueOf(map.get("atid")));
			List<Map<String,Object>> answerLs = query(namespace + ".getAnswerByQID_Version", param);
			if(atid<4||atid==8||atid==9){
				if(answerLs!=null){
					for(Map<String,Object> answerMap:answerLs) {
						String acontent=String.valueOf(answerMap.get("ACONTENT"));
						if(acontent==null||"null".equals(acontent)||"".equals(acontent)) {
							acontent=String.valueOf(answerMap.get("ACONTENT_6"));
						}
						answerMap.put("ACONTENT",acontent);
					}
					map.put("answerList",answerLs);
				}
			}else if(atid==4){
				if (answerLs.size() > 0) {
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
				map.put("answerid","");
				if(answerLs.get(0).get("ACONTENT_6")!=null) {
					map.put("answerid", Base64.getEncoder().encodeToString(answerLs.get(0).get("ACONTENT_6").toString().getBytes(StandardCharsets.UTF_8)));
				}
			}else{
				if(answerLs!=null && answerLs.size()>0){
					map.put("content_6", answerLs.get(0).get("ACONTENT_6"));
				}else {
					answerLs = query(namespace + ".getAnswerByQID", param);
					if(answerLs!=null && answerLs.size()>0){
						map.put("content_6", answerLs.get(0).get("ACONTENT_6"));
					}
				}
			}
		}

		return map;
	}
	
	@Override
	public String getCidByQid(Map param){
		return queryOne(namespace + ".getCidByQid", param);
	}
	
	@Override
	public int updateQuestion(Map param) {	
		String eid = param.get("eid").toString();
		
		if(Utils.changeObjToInt(param.get("isMain"))!=1){
			List<Map<String,Object>> aList = (List<Map<String, Object>>) param.get("answer");
			if(aList!=null&&aList.size()>0) {
				for(Map<String,Object> am:aList){
					if(am.get("answer_content")!=null &&
							String.valueOf(am.get("answer_content")).getBytes(Charset.forName("UTF-8")).length>3980){
						//选择题答案太长，一般是公式带有latex信息
						am.put("answer_content_6", am.get("answer_content"));
						am.remove("answer_content");
					}
					update(namespace + ".updatePaperQuestionAnswer", am);
				}	
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
					insert(namespace+".insertAnswer_one",m);
				}
			}
			
			List<Map<String,Object>> answer_delete=(List<Map<String,Object>>)param.get("answer_delete");
			if(answer_delete!=null&&answer_delete.size()>0){
				for(Map<String,Object> m:answer_delete){
					delete(namespace+".deleteAnswer_one",m);
				}
			}
		}else {
			List<Map<String, Object>> list = query(namespace + ".getBrachExampaperQuestionByMqid",param);
			for(Map m : list) {
				m.put("id", m.get("QID"));
				m.put("eid", eid);
				m.put("qtid", param.get("qtid"));
				update(namespace + ".updateQuestion", m);
			}
		}
		
		update(namespace + ".updateQuestion", param);
		changeExampaperParamAndQType(eid);

		if("1".equals(param.get("syncToQuestionBank"))){
			if(!"1".equals(param.get("isAddIntoCourse"))){
				String[] qtid=String.valueOf(param.get("qtid")).split("_");
				param.put("qtid", qtid[0]);
				questionService.updateQuestionWithNoVersion(param);
			}
		}

		LocalCache cache = LocalCache.getInstance();
		List<Map<String,Object>> list = cache.get("exampaper_question", eid);
		if(list!=null){
			cache.evict("exampaper_question", eid);
		}
		List<Map<String,Object>> qtList = cache.get("exampaper_qtype", eid);
		if(qtList!=null){
			cache.evict("exampaper_qtype", eid);
		}
		paperChangeRecorder.recordPaperChange(eid);
		return 1;
	}
	
	@Override
	public List<Map<String, Object>> getQuestionTypeExplain(String ei_id) {
		// TODO Auto-generated method stub
		return query(namespace + ".getQuestionTypeExplain", ei_id);
	}

	@Override
	public List<Map<String,Object>> getPaper_theme(String eid){
		return query(namespace+".getPaper_theme",eid);
	}

	@Override
	public List<Map<String,Object>> getThemeConcat(String eid){
		return query(namespace+".getThemeConcat",eid);
	}
	
	//重新生成B卷
	@Override
	public int rebuildB(String eid){
		Map<String,Object> examinfo = getExamInfo(eid);
		delete(namespace+".completeDel_studentExamExam",eid);
		delete(namespace+".completeDel_studentExam",eid);
		delete(namespace+".completeDel_studentAnswerQuestionExam",eid);
		delete(namespace+".completeDel_studentAnswerQuestion",eid);
		delete(namespace+".completeDel_studentAnswerQuestionTypeExam",eid);
		delete(namespace+".completeDel_studentAnswerQuestionType",eid);
		delete(namespace+".completeDel_studentAnswerExam",eid);
		delete(namespace+".completeDel_studentAnswer",eid);
		delete(namespace+".completeDel_exampaperQuestiontype",eid);//双向细目表信息
		delete(namespace+".completeDel_exampaperQuestionparam",eid);//删除试卷试题
		delete(namespace+".completeDel_exampaperQuestion",eid);//删除试卷答案
		delete(namespace+".completeDel_exampaperAnswer",eid);//重新组卷更新试卷状态*/

		List<Map<String, Object>> res = getExampaperQuestionParam((String)examinfo.get("BID"));//获取A卷双向细目表信息
		List<Map<String, Object>> paramList = new ArrayList<>();
		
		List<Map<String, Object>> nlist = new ArrayList<>();
		List<Map<String, Object>> mainlist = new ArrayList<>();
		for(int i=0;i<res.size();i++){
			int qnum = ((BigDecimal) res.get(i).get("NUM")).intValue();//获取每个主题词、题型下的题目数量
			if(qnum!=0){
				Map m1 = new HashMap();
				m1.put("cid", res.get(i).get("CID"));
				m1.put("num", qnum);
				m1.put("thid", res.get(i).get("THID"));
				m1.put("thid_pid", res.get(i).get("PID"));
				m1.put("qtid", res.get(i).get("QTID"));				
				m1.put("thlevel", String.valueOf(res.get(i).get("THLEVEL")));
				m1.put("eid", eid);
				if(Integer.parseInt(String.valueOf(examinfo.get("ISVERIFIED")))==1){
					m1.put("isVerified", "1");
                }
				int forbidDay = Integer.parseInt(String.valueOf(examinfo.get("FORBIDBEFORE")));
                if(forbidDay>0){
                	m1.put("forbidDay", forbidDay);
                }
                int forbidNum = Integer.parseInt(String.valueOf(examinfo.get("FORBIDNUM")));
                if(forbidNum>1){
                	m1.put("forbidNum", forbidNum);
                }
				
				int iscon = Integer.parseInt(String.valueOf(res.get(i).get("ISCON")));
				if(iscon==1){
					List<Map<String, Object>> mqids = getMqids(m1); //当选中题型为串题时，查看有没有对应该题型和主题词的小题
            		if(mqids!=null && mqids.size() > 0) {
            			int branchNum = ((BigDecimal)mqids.get(0).get("QSUM")).intValue();
                		if(branchNum<qnum){
                			int next=10;
                			while(next>0){
                				m1.put("mqids", mqids);
                				m1.put("extra_num", qnum-branchNum);
                    			Map<String,Object> extra = getMqids_extra(m1);
                    			mqids.add(extra);
                    			branchNum = branchNum+((BigDecimal)extra.get("COUNT")).intValue();
                    			if(branchNum>=qnum){
                    				break;
                    			}
                    			next--;
                			}            			
                		}
            		}else {
            			Map<String,Object> mqid_null = getMqids_null(m1);
            			if(mqid_null!=null){
            				mqids.add(mqid_null);
            			}
            		}
					
            		for(Map<String, Object> s: mqids){
            			s.put("cid", res.get(i).get("CID"));
            			s.put("ei_id", eid);
            			mainlist.add(s);
            		}
            		
            		List<Map<String,Object>> branch = getBrachByMqid(mqids);
            		for(Map<String, Object> s:branch){
            			s.put("EID", eid);
            			nlist.add(s); 
            		}    		
				}else{
					List<Map<String, Object>> qList =  getRandomQuestion(m1);
            		for(Map<String, Object> s: qList){
            			s.put("EID", eid);
            			nlist.add(s);  //非串题
            		}
					
				}
				paramList.add(m1);
			}					
		}
		Map param = new HashMap();
		param.put("ei_id", eid);//原B卷eid
		param.put("question", nlist);//题目
		param.put("mainQuestion", mainlist);//
		param.put("mquestion", paramList);//双向细目表信息
		param.put("aid", examinfo.get("BID"));//A卷ID
		
		if(paramList.size() > 0){
			generateBpaper(param);	//添加试卷试题（有点难，请耐心看）
		}
		updatePaperQuestionOrder(eid);
		return 1;
	}

	//重新组卷-A卷
	@Override
	public int rebuildA(String eid){
		delete(namespace+".completeDel_studentExamExam",eid);
		delete(namespace+".completeDel_studentExam",eid);
		delete(namespace+".completeDel_studentAnswerQuestionExam",eid);
		delete(namespace+".completeDel_studentAnswerQuestion",eid);
		delete(namespace+".completeDel_studentAnswerQuestionTypeExam",eid);
		delete(namespace+".completeDel_studentAnswerQuestionType",eid);
		delete(namespace+".completeDel_studentAnswerExam",eid);
		delete(namespace+".completeDel_studentAnswer",eid);
		delete(namespace+".completeDel_exampaperQuestiontype",eid);//删除题型
		delete(namespace+".completeDel_exampaperQuestionparam",eid);//双向细目表信息
		delete(namespace+".completeDel_exampaperQuestion",eid);//删除试卷试题
		delete(namespace+".completeDel_exampaperAnswer",eid);//删除试卷答案
		update(namespace+".updateReloadPaper", eid);//重新组卷更新试卷状态
		return 1;
	}
	
	//组卷后，调整参数，重新组卷，回到上一步
	@Override
	public int adjustPaper_back(String eid){
		delete(namespace+".completeDel_exampaperQuestiontype",eid);
		delete(namespace+".completeDel_exampaperQuestionparam",eid);
		delete(namespace+".completeDel_exampaperQuestion",eid);
		delete(namespace+".completeDel_exampaperAnswer",eid);
		return 1;
	}

	//组卷后，调整参数，重新组卷，回到上一步
	@Override
	public int updatePaperQuestionNum(String eid){
		update(namespace+".updatePaperQuestionCount",eid);
		return 1;
	}


	
	@Override
	public String getQuestionTotalTime(String eid) {
		return query(namespace + ".getQuestionTotalTime", eid)+"";
	}

	@Override
	public List<Map<String, Object>> getAnswerByQID_Version(Map m) {
		return query(namespace + ".getAnswerByQID_Version", m);
	}
	
	@Override
	public List<Map<String,Object>> selectcidsByeids(Map m){
		return query(namespace+".selectcidsByeids",m);
	}
	
	@Override
	public int addAllQuestionIntoPaperFromPaper(Map param) {
		String eid = (String)param.get("eid");
		List<Map<String,Object>> qidsList = (List<Map<String, Object>>) param.get("qids");
		Map map = new HashMap();
		map.put("eid", eid);
		map.put("qids", qidsList);
		map.put("ei_id", eid);
		
		int sum = insert(namespace+".addAllQuestionIntoPaperFromPaper",map);
		insert(namespace+".addExampaperAnswerFromPaper",map);
		
		List<Map<String, Object>> qtList = query(namespace + ".getQuestionType4Structure", map);
		for(int i=0;i<qtList.size();i++){
			String qtid=String.valueOf(qtList.get(i).get("QTID"));
			int iscon=Integer.parseInt(String.valueOf(qtList.get(i).get("ISCON")));
			int atid=Integer.parseInt(String.valueOf(qtList.get(i).get("ATID")));
			int qcount=Integer.parseInt(String.valueOf(qtList.get(i).get("QCOUNT")));
			for(int j=(i+1);j<qtList.size();j++){
				if(qtid.equals((String.valueOf(qtList.get(j).get("QTID"))))){
					if(iscon==(Integer.parseInt(String.valueOf(qtList.get(j).get("ISCON"))))&&atid==(Integer.parseInt(String.valueOf(qtList.get(j).get("ATID"))))){
						qcount+=Integer.parseInt(String.valueOf(qtList.get(j).get("QCOUNT")));
						qtList.remove(j);
						j--;
					}
//					else{
//						Map mm=new HashMap();
//						mm.put("eid", param.get("ei_id"));
//						mm.put("cid", qtList.get(j).get("CID"));
//						mm.put("qtid", qtList.get(j).get("QTID"));
//						Random random = new Random();
//						String nqtid=String.valueOf(qtList.get(j).get("QTID"))+"_"+random.nextInt(99);
//						mm.put("nqtid", nqtid);
//						qtList.get(j).put("QTID",nqtid);
//						update(namespace+".updateQID4Structure",mm);
//					}
				}
				
			}
			qtList.get(i).put("QCOUNT", qcount);
		}
		Map qtMap=new HashMap();
		qtMap.put("qtList", qtList);
		delete(namespace+".completeDel_exampaperQuestiontype",eid);
		delete(namespace+".completeDel_exampaperQuestionparam",eid); //要先删除再全部添加
		insert(namespace+".addExampaperQuestionType",qtMap);
		insert(namespace+".addExampaperQuestionParam",map);
		
//		insert(namespace + ".changeExampaperQuestionType",eid);
//		insert(namespace + ".changeExampaperQuestionParam",eid);		
		//更新试卷试题数目
		update(namespace+".updatePaperQuestionCount", eid);
		updatePaperQuestionOrder(eid);
		
		return sum;
	}

	@Override
	public int updateDefaultExamInfo(Map param) {
		return update(namespace+".updateDefaultExamInfo",param);
	}

	@Override
	public List<Map<String, Object>> getDefaultExamInfo(String id) {
		return query(namespace+".getDefaultExamInfo",id);
	}

	@Override
	public String getENameByID(String eid) {
		return queryOne(namespace+".getENameByID",eid).toString();
	}

	@Override
	public List<Map<String, Object>> getMultiCourseStructureQSum(String ei_id) {
		return query(namespace+".getMultiCourseStructureQSum",ei_id);
	}

	@Override
	public int saveCheckList(Map m) {
		return insert(namespace+".saveCheckList", m);
	}
	
	@Override
	public int saveCheckList_nonexist(Map m) {
		return insert(namespace+".saveCheckList_nonexist", m);
	}
	
	@Override
	public List<Map<String,Object>> getCheckList(String eid){
		return query(namespace+".getCheckList",eid);
	}

	@Override
	public int getTemplateCount(Map m) {
		return queryOne(namespace+".getTemplateCount",m);
	}

	@Override
	public List<String> getTemplateByCid(String cid) {
		return queryList(namespace + ".getTemplateByCid", cid);
	}

	@Override
	public List<Map<String, Object>> getTemplateDetail(Map param) {
		return query(namespace + ".getTemplateDetail", param);
	}
	
	@Override
	public List<Map<String, Object>> getWjQuestion(Map param, PageUtils pu){
		return query(namespace + ".getWjQuestion", param, pu.getRb());
	}
	
	@Override
	public String getWjQuestionCount(Map param) {
		return query(namespace + ".getWjQuestionCount", param).get(0).get("NUM").toString();
	}
	
	@Override
	public int updateStudentExamEndTime(Map input) {
		// TODO Auto-generated method stub
		return update(namespace + ".updateStudentExamEndTime", input);
	}

	@Override
	public List<Map<String, Object>> getPaperAnswerByQID(Map m) {
		return query(namespace + ".getPaperAnswerByQID", m);
	}

	@Override
	public List<Map<String, Object>> findRepeatQuestions(Map param) {
		String eid = (String) param.get("eid");
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
			Map<String, Object> mm = new HashMap<>();
			mm.put("id", question.get("qid"));
			mm.put("eid", eid);
			List<Map<String, Object>> alist = getAnswerByQID_Version(mm);
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

	public List<Map<String,Object>> getExampaperQuestionWithMainAndChild(Map<String,Object> param){
		List<Map<String,Object>> qListAll = query(namespace+".getExampaperQuestionList", param);
		List<Map<String, Object>> rtnChildQuestionWithMain = new ArrayList<>();
		for(Map<String, Object> question : qListAll){
			String content = Objects.toString(question.get("content"),"");
			question.put("content",content.replaceAll("(\r\n|\r|\n)+", "<br>").replaceAll("<br>+", "<br>").trim());
			int iscon = Utils.changeObjToInt(question.get("iscon"));
			if(iscon == 1){
				int ismain = Utils.changeObjToInt(question.get("ismain"));
				if(ismain==0){
					if(question.get("mqid")==null){ //有主题干id为空的串题，这里就直接跳了
						rtnChildQuestionWithMain.add(question);
						continue;
					}
					for(Map<String, Object> question4FindMain : qListAll){
						if(question4FindMain.get("qid").equals(question.get("mqid"))){
							question.put("content", "题干："+Objects.toString(question4FindMain.get("content"),"")+
									"<br>子题："+Objects.toString(question.get("content"),""));
							rtnChildQuestionWithMain.add(question);
							break;
						}
					}
				}
			}else{ //非串题直接进去
				rtnChildQuestionWithMain.add(question);
			}
		}
		return rtnChildQuestionWithMain;
	}

	@Override
	public Map<String,Object> findTwoPaperRepeatQuestions(String eid1, String eid2, int answerMatch){
		Map<String,Object> eidParam = new HashMap<>();
		eidParam.put("ei_id", eid1);
		List<Map<String,Object>> questionList1 = getExampaperQuestionWithMainAndChild(eidParam);
		eidParam.put("ei_id", eid2);
		List<Map<String,Object>> questionList2 = getExampaperQuestionWithMainAndChild(eidParam);
		List<Map<String,Object>> questionRepeat = new ArrayList<>();
		Integer[][] atidGroups = {{0,2,8}, {1,3,9}, {4}, {5,6,7,10,11}, {12}, {13}};
		Map<Integer, Integer> atidToGroupMap = new HashMap<>();
		for (int groupId = 0; groupId < atidGroups.length; groupId++) {
			for (int atid : atidGroups[groupId]) {
				atidToGroupMap.put(atid, groupId);
			}
		}
		for(Map<String,Object> questionFrom1 : questionList1){
			for(Map<String,Object> questionFrom2 : questionList2){
				if(Objects.toString(questionFrom1.get("qid"),"").equals(
						Objects.toString(questionFrom2.get("qid"),""))){ //qid相同直接进去
					questionRepeat.add(buildRepeatQuestionMap(questionFrom1,questionFrom2));
					continue;
				}
				if(Utils.stripAllHtml4Compare(Objects.toString(questionFrom1.get("content"),"")).equals(
						Utils.stripAllHtml4Compare(Objects.toString(questionFrom2.get("content"),""))
				)){
					if(answerMatch==1) { //答案都一样
						int atid = Utils.changeObjToInt(questionFrom1.get("atid"));
						int atid2 = Utils.changeObjToInt(questionFrom2.get("atid"));

						if (!atidToGroupMap.get(atid).equals(atidToGroupMap.get(atid2))) {  //Atid不一样直接跳
							continue; // 不在同一组，跳过
						}
						if(questionFrom1.get("answer")!=null && questionFrom2.get("answer")!=null
						 && questionFrom1.get("answer") instanceof List && questionFrom2.get("answer") instanceof List){
							List<Map<String,Object>> question1Anslist = (List<Map<String,Object>>) questionFrom1.get("answer");
							List<Map<String,Object>> question2Anslist = (List<Map<String,Object>>) questionFrom2.get("answer");
							if(question1Anslist.size() != question2Anslist.size()){ //答案长度不一样，跳
								continue;
							}
							question1Anslist.sort(Comparator.comparing(map -> Utils.stripAllHtml4Compare(String.valueOf(map.get("ACONTENT")))));
							question2Anslist.sort(Comparator.comparing(map -> Utils.stripAllHtml4Compare(String.valueOf(map.get("ACONTENT")))));
							boolean isSame = true;
							for(int i=0;i<question1Anslist.size();i++){
								Map<String,Object> question1Answer = question1Anslist.get(i);
								Map<String,Object> question2Answer = question1Anslist.get(i);
								if(atid==5 || atid==6 || atid==7 || atid==10 || atid==11 || atid==12 || atid==13){ //主观题
									if(!Utils.stripAllHtml4Compare(Objects.toString(question1Answer.get("ACONTENT_6"),""))
											.equals(Utils.stripAllHtml4Compare(Objects.toString(question2Answer.get("ACONTENT_6"),"")))){
										isSame = false;
										break;
									}
								}else{
									if(!Utils.stripAllHtml4Compare(Objects.toString(question1Answer.get("ACONTENT"),""))
											.equals(Utils.stripAllHtml4Compare(Objects.toString(question2Answer.get("ACONTENT"),"")))){
										isSame = false;
										break;
									}
								}
							}
							if(isSame){
								questionRepeat.add(buildRepeatQuestionMap(questionFrom1,questionFrom2));
							}
						}
					}else{
						questionRepeat.add(buildRepeatQuestionMap(questionFrom1,questionFrom2));
					}
				}
			}
		}

		Map<String,Object> repeatQuestionInfos = new HashMap<>(); //key是题型，all代表全部题型。
		repeatQuestionInfos.put("all_1", questionList1.size());
		repeatQuestionInfos.put("all_2", questionList2.size());
		repeatQuestionInfos.put("all", questionRepeat.size());
		for (Map<String,Object> question : questionList1){
			String qtname = (String) question.get("qtname");
			repeatQuestionInfos.put(qtname+"_1", Utils.changeObjToInt(repeatQuestionInfos.getOrDefault(qtname+"_1",0)) + 1);
		}
		for (Map<String,Object> question : questionList2){
			String qtname = (String) question.get("qtname");
			repeatQuestionInfos.put(qtname+"_2", Utils.changeObjToInt(repeatQuestionInfos.getOrDefault(qtname+"_2",0)) + 1);
		}
		for (Map<String,Object> question : questionRepeat){
			String qtname = (String) question.get("qtname");
			repeatQuestionInfos.put(qtname, Utils.changeObjToInt(repeatQuestionInfos.getOrDefault(qtname,0)) + 1);
		}
		repeatQuestionInfos.put("repeatList", questionRepeat);
		return repeatQuestionInfos;
	}

	private Map<String,Object> buildRepeatQuestionMap(Map<String,Object> question1, Map<String,Object> question2){
		Map<String,Object> rtn = new HashMap<>();
		rtn.put("qtname", question1.get("qtname"));
		rtn.put("atid", question1.get("atid"));
		rtn.put("iscon", question1.get("iscon"));
		rtn.put("ismain", question1.get("ismain"));
		rtn.put("fromContent1", question1.get("content"));
		rtn.put("fromContent2", question2.get("content"));
		rtn.put("fromAnswer1", question1.get("answer"));
		rtn.put("fromAnswer2", question2.get("answer"));
		rtn.put("fromAnswerid1",question1.get("answerid"));
		rtn.put("fromAnswerid2",question2.get("answerid"));
		rtn.put("fromEid1", question1.get("eid"));
		rtn.put("fromEid2", question2.get("eid"));
		rtn.put("fromT1name1", question1.get("t1name"));
		rtn.put("fromT1name2", question2.get("t1name"));
		rtn.put("fromT2name1", question1.get("t2name"));
		rtn.put("fromT2name2", question2.get("t2name"));
		rtn.put("fromT3name1", question1.get("t3name"));
		rtn.put("fromT3name2", question2.get("t3name"));
		rtn.put("fromQid1", question1.get("qid"));
		rtn.put("fromQid2", question2.get("qid"));
		rtn.put("fromScore1", question1.get("SCORE"));
		rtn.put("fromScore2", question2.get("SCORE"));
		rtn.put("fromTh1", question1.get("th"));
		rtn.put("fromTh2", question2.get("th"));
		rtn.put("fromCname1", question1.get("cname"));
		rtn.put("fromCname2", question2.get("cname"));
		return rtn;
	}
	
	@Override
	public List<Map<String,Object>> getPaperTheme2List(Map param){
		return query(namespace+".getPaperTheme2List",param);
	}
	
	@Override
	public List<Map<String,Object>> getPaperTheme3List(Map param){
		return query(namespace+".getPaperTheme3List",param);
	}

	@Override
	public List<Map<String, Object>> getExampaperQuestionOrder(String ei_id) {
		return query(namespace+".getExampaperQuestionOrder",ei_id);
	}
	
	@Override
	public List<Map<String,Object>> getExampaperQtTypeOrder(String ei_id){
		return query(namespace+".getExampaperQtTypeOrder",ei_id);
	}

	@Override
	public List<Map<String, Object>> getAllExamPaper() {
		return query(namespace+".getAllExamPaper");
	}
	
	@Override
	public void updatePaperQuestionOrder(String ei_id){
		//先确认试卷的题型顺序是否有相同的情况，如果是，重新排序
		List<Map<String,Object>> qtorder=getExampaperQtTypeOrder(ei_id);
		boolean b=false;
		for(int i=0;i<qtorder.size();i++){
			try{
				int o1=Integer.parseInt(String.valueOf(qtorder.get(i).get("QTORDER")));
				for(int j=i+1;j<qtorder.size();j++){
					int o2=Integer.parseInt(String.valueOf(qtorder.get(j).get("QTORDER")));
					if(o1==o2){
						b=true;
						break;
					}
				}
			}catch(Exception e){
				b=true;
			}			
			if(b){
				break;
			}
		}
		if(b){
			for(int i=0;i<qtorder.size();i++){
				Map qtMap=new HashMap();
				qtMap.put("eid", ei_id);
				qtMap.put("qtid", qtorder.get(i).get("QTID"));
				qtMap.put("qtorder", i);
				update(namespace+".updatePaperQtOrder",qtMap);
			}
		}
		
		List<Map<String, Object>> qorder = getExampaperQuestionOrder(ei_id);
		//将问卷调查的试题放在最后
		List<Map<String,Object>> wjList=new ArrayList<>();
		for(int i=0;i<qorder.size();i++){
			//因部分多选题出现多选题答案不连续的问题，增加检查更正部分，后期可以删除20220805
            int atid=Integer.parseInt(String.valueOf(qorder.get(i).get("ATID")));
            if(atid==1||atid==3){
                String answerid=String.valueOf(qorder.get(i).get("ANSWERID"));
                String[] strArr=answerid.split(",");
                Arrays.sort(strArr);
                String answerid_="";
                for(String str:strArr){
                    answerid_+=str+",";
                }
                answerid_=answerid_.substring(0,answerid_.length()-1);
                if(!answerid.equals(answerid_)){
                    qorder.get(i).put("ANSWERID",answerid_);
                    update(namespace+".updatePaperQuestionAnswerid",qorder.get(i));
                    update(namespace+".updateQuestionAnswerid",qorder.get(i));
                }
            }
			Map<String,Object> w=qorder.get(i);
			if((String.valueOf(w.get("CID")).equals(wj_cid))){
				wjList.add(w);
				qorder.remove(w);
				i--;
			}
		}
		if(wjList.size()>0){
			Iterator<Map<String,Object>> it=wjList.iterator();
			while(it.hasNext()){
				qorder.add(it.next());
			}
			
		}
		
		List<Map<String,Object>> list=new ArrayList<>();
		for(int i=0;i<qorder.size();i++){
			Map question=qorder.get(i);
			String qid=String.valueOf(question.get("QID"));
			int iscon=Integer.parseInt(String.valueOf(question.get("ISCON")));
			int ismain=Integer.parseInt(String.valueOf(question.get("ISMAIN")));	
			if(iscon==0 || ismain==1){
				list.add(qorder.get(i));
				if(ismain==1){
					for(int j=0;j<qorder.size();j++){
						String mqid=String.valueOf(qorder.get(j).get("MQID"));
						if(qid.equals(mqid)){
							list.add(qorder.get(j));
						}
					}
				}
			}
		}
		
		if(qorder.size()!=list.size()){//有试题有问题，避免出现分支没有题干的问题
			List<String> errorQid=new ArrayList<>();
			for(Map m1:qorder){
				boolean a=false;
				for(Map m2:list){
					if((String.valueOf(m1.get("QID")).equals(String.valueOf(m2.get("QID"))))){
						a=true;
						break;
					}
				}
				if(!a){
					errorQid.add(String.valueOf(m1.get("QID")));
				}
			}
			if(errorQid.size()>0){
				for(int x=0;x<errorQid.size();x++){
					Map error=new HashMap();
					error.put("ei_id", ei_id);
					error.put("id", errorQid.get(x));
					delete(namespace+ ".deleteExampaperAnswer",error);
					delete(namespace+ ".deleteExampaperQuestion",error);
				}
			}
		}
		
		int index=1;
		for(int j=0;j<list.size();j++){
			Map qm=list.get(j);
			Map map=new HashMap();
			map.put("qid", String.valueOf(qm.get("QID")));
			map.put("eid", ei_id);
			map.put("th", index);
			map.put("qorder", j);
			update(namespace + ".updatePaperQuestionOrder", map);
			
			int ismain=Integer.parseInt(String.valueOf(qm.get("ISMAIN")));
			if(ismain==0){
				index++;
			}
		}

		LocalCache cache = LocalCache.getInstance();
		List<Map<String,Object>> qlist = cache.get("exampaper_question", ei_id);
		if(qlist!=null){
			cache.evict("exampaper_question", ei_id);
		}
		List<Map<String,Object>> qtList = cache.get("exampaper_qtype", ei_id);
		if(qtList!=null){
			cache.evict("exampaper_qtype", ei_id);
		}
	}
	
	@Override
	public void batchUpdateQorder(String ei_id){
		//先确认试卷的题型顺序是否有相同的情况，如果是，重新排序
		List<Map<String,Object>> qtorder=getExampaperQtTypeOrder(ei_id);
		boolean b=false;
		for(int i=0;i<qtorder.size();i++){
			int o1=Integer.parseInt(String.valueOf(qtorder.get(i).get("QTORDER")));
			for(int j=i+1;j<qtorder.size();j++){
				int o2=Integer.parseInt(String.valueOf(qtorder.get(j).get("QTORDER")));
				if(o1==o2){
					b=true;
					break;
				}
			}
			if(b){
				break;
			}
		}
		if(b){
			for(int i=0;i<qtorder.size();i++){
				Map qtMap=new HashMap();
				qtMap.put("eid", ei_id);
				qtMap.put("qtid", qtorder.get(i).get("QTID"));
				qtMap.put("qtorder", i);
				update(namespace+".updatePaperQtOrder",qtMap);
			}
		}
		
		List<Map<String, Object>> qorder = getExampaperQuestionOrder(ei_id);
		//将问卷调查的试题放在最后
		List<Map<String,Object>> wjList=new ArrayList<Map<String,Object>>();
		for(int i=0;i<qorder.size();i++){
			Map<String,Object> w=qorder.get(i);
			if((String.valueOf(w.get("CID")).equals(wj_cid))){
				wjList.add(w);
				qorder.remove(w);
				i--;
			}
		}
		if(wjList.size()>0){
			Iterator<Map<String,Object>> it=wjList.iterator();
			while(it.hasNext()){
				qorder.add(it.next());
			}
			
		}
		
		List<Map<String,Object>> list=new ArrayList<Map<String,Object>>();
		for(int i=0;i<qorder.size();i++){
			Map question=qorder.get(i);
			String qid=String.valueOf(question.get("QID"));
			int iscon=Integer.parseInt(String.valueOf(question.get("ISCON")));
			int ismain=Integer.parseInt(String.valueOf(question.get("ISMAIN")));	
			if(iscon==0 || ismain==1){
				list.add(qorder.get(i));
				if(ismain==1){
					for(int j=0;j<qorder.size();j++){
						String mqid=String.valueOf(qorder.get(j).get("MQID"));
						if(qid.equals(mqid)){
							list.add(qorder.get(j));
						}
					}
				}
			}
		}
		
		int index=1;
		for(int j=0;j<list.size();j++){
			Map qm=list.get(j);
			Map map=new HashMap();
			map.put("qid", String.valueOf(qm.get("QID")));
			map.put("eid", ei_id);
			map.put("th", index);
			map.put("qorder", j);
			update(namespace + ".updatePaperQuestionOrder", map);
			
			int ismain=Integer.parseInt(String.valueOf(qm.get("ISMAIN")));
			if(ismain==0){
				index++;
			}
		}	
	}

	@Override
	public Map<String, Object> getPaperFilter(Map param) {
		// TODO Auto-generated method stub
		Map rs = new HashMap();
		rs.put("questionTypeFilter", query(namespace+".getPaperQuestionTypeFilter",param));
		rs.put("theme1Filter", query(namespace+".getPaperTheme1Filter",param));
		rs.put("cognitionFilter", query(namespace+".getPaperCognitionFilter",param));
		rs.put("difficultyFilter", query(namespace+".getPaperDifficultyFilter",param));
		rs.put("knowledgeFilter", query(namespace+".getPaperKnowledgeFilter",param));
		return rs;
	}
	
	@Override
	public List<Map<String,Object>> getPaper_CourseName(String[] cids){
		return query(namespace+".getPaper_CourseName",cids);
	}

	@Override
	public void updatePaperScore(Map map) {
		update(namespace+".updatePaperScore",map);
	}

	@Override
	public void updatePaperMainQScore(Map map) {
		update(namespace+".updatePaperMainQScore",map);
	}

	
	@Override
	public List<Map<String, Object>> getGrade4ExamInfo() {
		List<Map<String,Object>> list = query(namespace + ".getGrade4ExamInfo");
		Map<String,Object> map=null;
		for(int i=0;i<list.size();i++){
			if("所有年级".equals(String.valueOf(list.get(i).get("NAME")))){
				map=list.get(i);
				list.remove(i);
				break;
			}
		}
		
		if(map!=null){
			list.add(0, map);
		}
		return list;
	}
	
	/*
	 * @Override public List<Map<String, Object>> getUnit4ExamInfo() {
	 * List<Map<String,Object>> list = query(namespace + ".getUnit4ExamInfo");
	 * Map<String,Object> map=null; for(int i=0;i<list.size();i++){
	 * if("所有学院".equals(String.valueOf(list.get(i).get("NAME")))){ map=list.get(i);
	 * list.remove(i); } }
	 * 
	 * if(map!=null){ list.add(0, map); } return list; }
	 */

	@Override
	public Map<String, Object> getFilterByCourseAttrs(List<Map<String, Object>> courseList) {
		Map<String, Object> rs = new HashMap<>();
		List<Map<String, Object>> themeList = new ArrayList<>();
		List<Map<String, Object>> questionTypeList = new ArrayList<>();
		Set<String> qtidSet = new HashSet<>();
		List<Map<String, Object>> cognitionList = new ArrayList<>();
		Set<String> coidSet = new HashSet<>();
		List<Map<String, Object>> difficultyList = new ArrayList<>();
		Set<String> didSet = new HashSet<>();
		List<Map<String, Object>> knowledgeList = new ArrayList<>();
		Set<String> kidSet = new HashSet<>();
		rs.put("themeList", themeList);
		rs.put("questionTypeList", questionTypeList);
		rs.put("cognitionList", cognitionList);
		rs.put("difficultyList", difficultyList);
		rs.put("knowledgeList", knowledgeList);
		if(courseList==null || courseList.isEmpty()){
			return rs;
		}
		for(Map<String, Object> course : courseList){
			List<Map<String, Object>> themeListToAdd = (List<Map<String, Object>>) course.get("themeList");
			themeList.addAll(themeListToAdd);
			List<Map<String, Object>> questionTypeListToAdd = (List<Map<String, Object>>) course.get("questionTypeList");
			for(Map<String, Object> questionType : questionTypeListToAdd){
				if(qtidSet.add((String) questionType.get("QTID")) && !"".equals(Objects.toString(questionType.get("QTNAME"),""))){
					questionTypeList.add(questionType);
				}
			}
			List<Map<String, Object>> cognitionListToAdd = (List<Map<String, Object>>) course.get("cognitionList");
			for(Map<String, Object> cognition : cognitionListToAdd){
				if(coidSet.add((String) cognition.get("COID")) && !"".equals(Objects.toString(cognition.get("CONAME"),""))){
					cognitionList.add(cognition);
				}
			}
			List<Map<String, Object>> difficultyListToAdd = (List<Map<String, Object>>) course.get("difficultyList");
			for(Map<String, Object> difficulty : difficultyListToAdd){
				if(didSet.add((String) difficulty.get("DID")) && !"".equals(Objects.toString(difficulty.get("DNAME"),""))){
					difficultyList.add(difficulty);
				}
			}
			List<Map<String, Object>> knowledgeListToAdd = (List<Map<String, Object>>) course.get("knowledgeList");
			for(Map<String, Object> knowledge : knowledgeListToAdd){
				if(kidSet.add((String) knowledge.get("KID")) && !"".equals(Objects.toString(knowledge.get("KNAME"),""))){
					knowledgeList.add(knowledge);
				}
			}
		}
		return rs;
	}

	@Override
	public List<Map<String, Object>> getThemeFromPaperCid(Map mm) {
		// TODO Auto-generated method stub
		return query(namespace + ".getThemeFromPaperCid", mm);
	}

	@Override
	public List<Theme> getThemeFromPaperCidAll(Map m){
		List<Theme> themeList = queryList(namespace+".getThemeFromPaperCidAll",m);
		getChildThemeByPaperCid(m, themeList);
		return themeList;
	}

	private void getChildThemeByPaperCid(Map m, List<Theme> parentList){
		if(parentList==null || parentList.size()==0){
			return;
		}
		for(Theme theme : parentList){
			if(theme.getTlevel()<3){
				m.put("pid",theme.getId());
				m.put("level",theme.getTlevel()+1);
				theme.setChildList(queryList(namespace+".getThemeFromPaperCidAll",m));
				getChildThemeByPaperCid(m, theme.getChildList());
			}
		}
	}

	@Override
	public List<Map<String, Object>> getExamPaperCourse(String sid) {
		// TODO Auto-generated method stub
		return query(namespace + ".getExamPaperCourse", sid);
	}
	
	@Override
	public List<Map<String, Object>> getStudentExampaperQuestionTypeList(String ei_id) {
		// TODO Auto-generated method stub
		return query(namespace + ".getStudentExampaperQuestionTypeList", ei_id);
	}

	@Override
	public int updateStudentExamInfo(Map param) {
		return update(namespace + ".updateStudentExamInfo", param);
	}

	@Override
	public List<Map<String, Object>> getDifficultQuestionCount(Map param) {
		return query(namespace + ".getDifficultQuestionCount", param);
	}

	@Override
	public List<Map<String, Object>> getThemeCountByCidAndDid(Map param) {
		return query(namespace + ".getThemeCountByCidAndDid", param);
	}

	@Override
	public List<Map<String, Object>> getDifficultQids(Map m) {
		return query(namespace + ".getDifficultQids", m);
	}

	@Override
	public void addQuestionIntoPaper4Diff(Map param) {
//		if(param.get("mqids")!=null) {
//			insert(namespace + ".addMquestionIntoPaper_Diff", param);
//		}
		param.put("ei_id", param.get("eid"));
		List<Map<String, Object>> qtlist = (List<Map<String, Object>>) param.get("qparams");
		int qorder = 0;
		for(Map m:qtlist) {
			List qids = (List) m.get("qids");
			for(int i = 0; i < qids.size(); i++) {
				m.put("qid", qids.get(i));
				m.put("qorder", qorder);
				String isRepeat = queryOne(namespace + ".getRepeatQuestionInExampaperQuestion", m);
				if(isRepeat==null || "".equals(isRepeat)) {
					insert(namespace + ".addQuestionIntoPaper_Diff", m);
					insert(namespace + ".addAnswerIntoPaper_Diff", m);
					qorder ++;
				}
			}
			insert(namespace + ".addQuestionTypeIntoPaper_Diff", m);
		}
		update(namespace + ".updatePaperQuestionTypeQTTime", param);
		insert(namespace + ".addExampaperQuestionParam", param);
		update(namespace + ".updatePaperQuestionCount", (String) param.get("eid"));
		paperChangeRecorder.recordPaperChange((String) param.get("eid"));
	}

	@Override
	public List<Map<String, Object>> getMqids_Diff(List<String> qids) {
		return query(namespace + ".getMqids4Diff", qids);
	}

	@Override
	public void saveExaminfoQuestionFilterParam(Map par) {
		update(namespace + ".saveExaminfoQuestionFilterParam", par);
	}

	@Override
	public List<Map<String, Object>> getmQuestionCount_diff(Map param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getmQuestionCount_diff", param);
	}

	@Override
	public List<Map<String, Object>> getMqids4DiffStructure(Map param) {
		return query(namespace + ".getMqids4DiffStructure", param);
	}

	@Override
	public List<Map<String, Object>> getQuestionTypeParamByQtids(Map param) {
		return query(namespace + ".getQuestionTypeParamByQtids", param);
	}

	@Override
	public int addExampaperQuestionParam(Map param) {
		return insert(namespace + ".addExampaperQuestionParam", param);
	}

	@Override
	public List<Map<String, Object>> getThemeQSumAndQCount(Map param) {
		List<Map<String, Object>> thCount = query(namespace + ".getNextThQCountAndQSum", param);
		List<Map<String, Object>> thList = query(namespace + ".getThemeNameByPid", param);
		for(int i=0;i<thList.size();i++) {
			Map par = thList.get(i);
			ArrayList<Map<String, Object>> ls = new ArrayList<>();
			for(Map c:thCount) {
				if(par.get("THID").toString().equals(c.get("THID").toString())) {
					Map m = new HashMap();
					m.put("COUNT", c.get("COUNT"));
					m.put("QTID", c.get("QTID"));
					m.put("SCORE", c.get("SCORE"));
					ls.add(m);
				}
			}
			if(ls.size()==0) {
				thList.remove(i);
				i--;
			}else {
				par.put("TOTAL", ls);
			}
		}
		return thList;
	}
	
	@Override
	public List<Map<String, Object>> getPaperQuestionBranch4Xls(Map param) {
		return query(namespace + ".getPaperQuestionBranch4Xls", param);
	}
	
	@Override
	public int insertPaperQuestion(List<Map<String, Object>> list) {
		return insert(namespace + ".insertPaperQuestion", list);
	}

	@Override
	public void insertAnswerForUnion(List<Map<String, Object>> list) {
		insert(namespace + ".insertAnswerForUnion", list);
	}
	
	@Override
	public List<Map<String,Object>> getExamQuestionTime(String eid){
		return query(namespace+".getExamQuestionTime",eid);
	}
	
	@Override
	public int getExamQuestionTimeSum(String eid) {
		Map<String,Object> map=query(namespace + ".getExamQuestionTimeSum", eid).get(0);
		if(map!=null){
			return Integer.parseInt(String.valueOf(map.get("TIME")));
		}else{
			return 0;
		}
	}

	@Override
	public int updateExampaperCourse(Map param) {
		//更新试卷的cid和exampaper_course的cid
		//changeExampaperCourse(ei_id);
		String ei_id = (String)param.get("ei_id");
		List<Map<String, Object>> ls = query(namespace + ".getExampaperCourseByEid", ei_id);
		delete(namespace + ".delExampaperCourse", ei_id);//根据eid清空exampaper_course
		StringBuilder cids = new StringBuilder();
		Map m1 = new HashMap();
		for(Map m:ls) {
			cids.append(m.get("CID") + ",");
			m1.put("cid", m.get("CID"));
			m1.put("eid", m.get("EID"));
			insert(namespace + ".addExampaperCourse", m1);
		}
		//更新课程的试卷数
		for(Map m:ls) {
			update(namespace+".call_updateCoursePapercount",m.get("CID"));
		}
		String cid = cids.toString().substring(0, cids.toString().length()-1);
		m1.put("cid", cid);
		m1.put("eid", ei_id);
		return update(namespace + ".updateExaminfoCids", m1);
	}
	
	@Override
	public int getMaxThFromExampaperquestion(String eid){
		int thMax=0;
		List<Map<String,Object>> thList=query(namespace+".getThFromExamPaperQuestion",eid);
		if(thList.size()>0){
			thMax=Integer.parseInt(thList.get(0).get("TH").toString());
		}
		return thMax;
	}
	
	@Override
	public List<Map<String,Object>> getQnum_qtid(String eid){
		return query(namespace+".getQnum_qtid",eid);
	}
	
	@Override
	public List<Map<String,Object>> getDept4Paper(String eid) {
		return query(namespace + ".getDept4Paper", eid);
	}
	
	@Override
	public String checkOption(String eid) {
		Map map = new HashMap();
		map.put("eid",eid);
		List<Map<String,Object>> qList=query(namespace+".getQuestionAnswerList",map);
		StringBuilder sb=new StringBuilder();
		for(int i=0;i<qList.size();i++) {
			String qtid=(String) qList.get(i).get("qtid");
			if("155_0_1".equals(qtid)){
				continue;
			}
			List<Map<String,Object>> answer=(List<Map<String, Object>>) qList.get(i).get("answer");
			boolean b=false;
			for(int j=0;j<answer.size();j++) {
				String acontent=String.valueOf(answer.get(j).get("ACONTENT"));
				if(!acontent.equals((char)(j+65)+"")) {
					b=true;
					break;
                }
			}
			if(!b) {
				sb.append(qList.get(i).get("th")+",");
			}
		}
		if(sb.length()>0) {
			return sb.substring(0,sb.length()-1);
		}else {
			return "no";
		}
		
	}
	
	@Override
	public int getRandomanswer(String eid) {
		return queryOne(namespace + ".getRandomanswer",eid);
	}
	
	@Override
	public int separateOption(Map param) {
		int rtn=0;
		List<Map<String,Object>> qList=query(namespace+".getQuestionAnswerList",param);
		
		for(int i=0;i<qList.size();i++) {
			Map<String,Object> qmap=qList.get(i);
			String qtid=String.valueOf(qmap.get("qtid"));
			if("155_0_1".equals(qtid)){
				continue;
			}
			List<Map<String,Object>> answer=(List<Map<String, Object>>) qmap.get("answer");
			boolean b=false;
			for(int j=0;j<answer.size();j++) {
				String acontent=String.valueOf(answer.get(j).get("ACONTENT"));
				if(!acontent.equals((char)(j+65)+"")) {
					b=true;
					break;
				}
			}
			if(!b) {//需要分离
				String details=getText(String.valueOf(qList.get(i).get("content")));
				String fgf=".";
				if(details.indexOf("A.")>0){
					fgf=".";
				}else if(details.indexOf("A、")>0){
					fgf="、";
				}else if(details.indexOf("A,")>0){
					fgf=",";
				}else if(details.indexOf("A ")>0){
					fgf=" ";
				}else if(details.indexOf("A，")>0){
					fgf="，";
				}else if(details.indexOf("A:")>0){
					fgf=":";
				}else if(details.indexOf("A：")>0){
					fgf="：";
				}else if(details.indexOf("A. ")>0){
					fgf=". ";
				}else if(details.indexOf("A．")>0) {
					fgf="．";
				}else if(details.indexOf("A，")>0) {
					fgf="，";
				}else if(details.indexOf("A.")>0) {
					fgf=".";
				}else if(details.indexOf("A．")>0) {
					fgf="．";
				}
				String detail_content=details.substring(0,details.indexOf("A"+fgf));
				qmap.put("content", detail_content);
				
				Map<String,Object> mm=new HashMap<String,Object>();
				mm.put("eid", param.get("eid"));
				int j=0;
				for(;j<20;j++){
					String letter=(char)(j+65)+"";
					String letter_next=(char)(j+66)+"";
					if(details.indexOf(letter_next+fgf)>0){
						String detail_letter=details.substring(details.indexOf(letter+fgf)+(fgf.length()+1),details.indexOf(letter_next+fgf));
						if(detail_letter.equals(letter_next)) {
							continue;
						}
						if(j>=answer.size()) {
							String aid=questionService.getAnswerID();
							mm.put("aid", aid);
							mm.put("qid", qList.get(i).get("qid"));
							mm.put("answer_content", detail_letter);
							mm.put("answer_content_6", "");
							mm.put("answertype", qList.get(i).get("atid"));
							mm.put("index", aid);
							update(namespace+".insertAnswer_one",mm);
							update(namespace+".insertAnswer",mm);
						}else {
							mm.put("aid", answer.get(j).get("AID"));
							mm.put("qid", qList.get(i).get("qid"));
							mm.put("answer_content", detail_letter);
							mm.put("answer_content_6", "");
							update(namespace + ".updatePaperQuestionAnswer", mm);
							update(namespace+".updateAnswer",mm);
						}
					}else{
						String detail_letter=details.substring(details.indexOf(letter+fgf)+(fgf.length()+1));
						if(j>=answer.size()) {
							String aid=questionService.getAnswerID();
							mm.put("aid", aid);
							mm.put("qid", qList.get(i).get("qid"));
							mm.put("answer_content", detail_letter);
							mm.put("answer_content_6", "");
							mm.put("answertype", qList.get(i).get("atid"));
							mm.put("index", aid);
							update(namespace+".insertAnswer_one",mm);
							update(namespace+".insertAnswer",mm);
						}else {
							mm.put("aid", answer.get(j).get("AID"));
							mm.put("qid", qList.get(i).get("qid"));
							mm.put("answer_content", detail_letter);
							mm.put("answer_content_6", "");
							update(namespace + ".updatePaperQuestionAnswer", mm);
							update(namespace+".updateAnswer",mm);
						}
						break;
					}
				}
				j++;
				if(j<answer.size()) {
					for(;j<answer.size();j++) {
						mm.put("aid", answer.get(j).get("AID"));
						mm.put("qid", qList.get(i).get("qid"));
						delete(namespace+".delAnswer",mm);
					}
				}
				update(namespace + ".updatePaperQuestionContent", qmap);
				update(namespace + ".updateQuestionContent", qmap);
				rtn++;
			}			
		}
		paperChangeRecorder.recordPaperChange((String) param.get("eid"));
		return rtn;
	}
	
	private String getText(String content){
        String txtcontent = content.replaceAll("</?[^>]+>", "");
        txtcontent = txtcontent.replaceAll("<a>\\s*|\t|\r|\n|</a>", "");
         return txtcontent;
    }

	public int deleteTemplateByName (String name){
		return delete(namespace + ".deleteTemplateByName", name);
	}
	
	@Override
	public Map<String, Object> getZF_qtid(Map param) {
		return query(namespace + ".getZF_qtid", param).get(0);
	}
	
	@Override
	public Map<String, Object> getZF_qids(Map param) {
		return query(namespace + ".getZF_qids", param).get(0);
	}

	@Override
	public void call_updateCoursePapercount(String cid){
		update(namespace+".call_updateCoursePapercount",cid);
	}

	@Override
	public Map<String,Object> getLastVerifyInfo(String eid){
		return query(namespace+".getLastVerifyInfo",eid).get(0);
	}

    @Override
    public List<Map<String, Object>> getAllTheme_cid(String cid) {
        return query(namespace + ".getAllTheme_cid", cid);
    }

	@Override
	public List<Map<String,Object>> selectReleCid4Paper(String eid){
		return query(namespace+".selectReleCid4Paper",eid);
	}

	@Override
	public Map<String, Object> getPaperInfo(String eid) {
		return query(namespace + ".getPaperInfo", eid).get(0);
	}
    
    @Override
    public List<Map<String,Object>> getJWC_KCDM(){
    	return query(namespace+".getJWC_KCDM");
    }

	@Override
	public List<Map<String, Object>> getPapersByIds(List<String> paperIds) {
		return query(namespace+".getPapersByIds",paperIds);
	}

	@Override
	public List<ExampaperQuestionDb> getExampaperQuestionRaw(String eid){
		return queryList(namespace+".getExampaperQuestionRaw", eid);
	}

	public List<ExampaperAnswerDb> getExampaperAnswerRaw(String eid) {
		Map<String, Object> param = new HashMap<>();
		param.put("eid", eid);
		return queryList(namespace+".getExampaperAnswerRaw", param);
	}

	public List<ExampaperQuestionTypeDb> getExampaperQuestionTypeRaw(String eid) {
		return queryList(namespace+".getExampaperQuestionTypeRaw", eid);
	}

	@Override
	public int checkUnit(Map param){
		List<Map<String,Object>> rtn=query(namespace+".checkUnit",param);
		if(rtn!=null&&rtn.size()!=0){
			return 1;
		}else{
			return 0;
		}
	}

	@Override
	public int addQuestionIntoTK(Map param){
		return insert(namespace+".addQuestionIntoTK",param);
	}

	@Override
	public int updateQuestion4TK(Map param){
		return update(namespace+".updateQuestion4TK",param);
	}

	@Override
	public int addAnswerIntoTK(Map param){
		return insert(namespace+".addAnswerIntoTK",param);
	}

	@Override
	public int updateQid(Map param){
		return update(namespace+".updateQid",param);
	}

	@Override
	public int updateAid(Map param){
		return update(namespace+".updateAid",param);
	}
}

