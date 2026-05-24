package com.cx.kaoyi.business.controller.question;

import com.cx.kaoyi.business.component.ConvertVideo;
import com.cx.kaoyi.business.domain.FileUpload;
import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.domain.download.Progress;
import com.cx.kaoyi.business.service.*;
import com.cx.kaoyi.framework.base.BaseController;
import com.cx.kaoyi.framework.base.FileDownloadUtils;


import com.cx.kaoyi.framework.cache.LocalCache;
import com.cx.kaoyi.framework.utils.*;

import com.cx.kaoyi.framework.utils.Image.ImgUtil;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.io.*;
import java.math.BigDecimal;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Controller
@RequestMapping("/question")
public class QuestionController extends BaseController{
	
	@Value("${wj_cid}")
	private String wj_cid;
	   
	@Autowired
	public QuestionService questionService;

	@Autowired
	public CourseService courseService;
	
	@Autowired
	public PoiService poiService;
	
	@Autowired
	public SystemService systemService;
	
	@Autowired
	public PermissionService permissionService;
	
	@Autowired
	private UserService userService;

	// 进入编辑试题
	@RequestMapping("/ineditQuestion")
	public String ineditQuestion() {
		User u = getUserInfo();
		if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
        	u.setcIDs(userService.findAllCids());
        }else{ //其他角色，查询有浏览课程权限的所有课程
        	u.setcIDs(userService.findCids(u.getId()));
        }
		Set<String> cIDs = u.getcIDs();
		if(wj_cid!=null && !"".equals(wj_cid)){
			cIDs.add(wj_cid);
		}
		getRequest().setAttribute("back", getPara("back"));

		return "jsp/question/ineditQuestion";
	}

	@PostMapping("/checkTmpWorkloadExcelZip")
	public @ResponseBody Map<String, Object> checkTmpWorkloadExcelZip() {
		User u = getUserInfo();
		Map<String, Object> rtn = new HashMap<>();
		if (u == null || (!getSubject().hasRole("administrator") && !getSubject().hasRole("dean"))) {
			rtn.put("historyFiles", Collections.emptyList());
			return rtn;
		}

		Path userFolder = Paths.get(
				WebFilePath.getProjectPath(),
				"tmpUser",
				u.getUsername(),
				"workloadExcelZip"
		);

		if (!Files.isDirectory(userFolder)) {
			rtn.put("historyFiles", Collections.emptyList());
			return rtn;
		}

		try (Stream<Path> paths = Files.list(userFolder)) {
			rtn.put("historyFiles", paths
					.filter(Files::isRegularFile)
					.filter(p -> p.getFileName().toString().toLowerCase(Locale.ROOT).endsWith(".zip"))
					.map(p -> {
						long ts;
						try { ts = Files.getLastModifiedTime(p).toMillis(); }
						catch (IOException e) { ts = Long.MIN_VALUE; }
						return new AbstractMap.SimpleEntry<>(p, ts);
					})
					.sorted((a, b) -> Long.compare(b.getValue(), a.getValue())) // 倒序
					.map(e -> e.getKey().getFileName().toString())
					.collect(Collectors.toList()));
		} catch (IOException e) {
			e.printStackTrace();
			rtn.put("historyFiles", Collections.emptyList());
		}

		LocalCache cache = LocalCache.getInstance();
		Progress progress =
				cache.get("analysis_mission",  u.getUsername() + "_exportWorkload");
		if(progress!=null){
			rtn.put("nowProgress", progress);
		}
		return rtn;
	}

	@GetMapping("/downloadWorkloadExcelZip")
	public ResponseEntity<Resource> downloadWorkloadExcelZip() {
		User u = getUserInfo();
		String fileName = getPara("fileName");
		if (u == null || StringUtils.isBlank(fileName)) return FileDownloadUtils.errorResponse("下载失败，没有权限。");

		Path downloadFile = Paths.get(
				WebFilePath.getProjectPath(),
				"tmpUser",
				u.getUsername(),
				"workloadExcelZip",
				fileName
		);

		if(!Files.exists(downloadFile)){
			return FileDownloadUtils.errorResponse("下载失败，没有权限。");
		}

		return FileDownloadUtils.download(downloadFile);
	}

	@PostMapping("/exportWorkloadExcelZipAsync")
	public ResponseEntity<?> exportWorkloadExcelZipAsync(){
		User u = getUserInfo();
		if (u == null || (!getSubject().hasRole("administrator") && !getSubject().hasRole("dean"))) {
			return ResponseEntity.ok("无权限");
		}
		LocalCache cache = LocalCache.getInstance();
		Progress progress =
				cache.get("analysis_mission",  u.getUsername() + "_exportWorkload");
		if(progress!=null){
			return ResponseEntity.ok("已有一个导出任务，请稍后");
		}
		String onlyTotal = getPara("onlyTotal");
		String cidStr = getPara("cidStr");
		String depId = getPara("depid");
		String unitId = getPara("unitid");
		String arrangeid = getPara("arrangeid");
		String beginDate = getPara("beginDate");
		String endDate = getPara("endDate");
		Map<String,Object> param = new HashMap<>();
		if(!StringUtils.isAnyBlank(beginDate, endDate)){
			param.put("beginDate", beginDate);
			param.put("endDate", endDate);
		}
		if(StringUtils.isBlank(cidStr)){
			param.put("depid", depId);
			param.put("unitid", unitId);
			param.put("arrangeid", arrangeid);
			Set<String> cIDs;
			if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
				cIDs = userService.findAllCids();
			}else{ //其他角色，查询有浏览课程权限的所有课程
				cIDs = userService.findCids(u.getId());
			}
			param.put("cidstr", getCidStrList(cIDs));
		}else {
			String[] cidArr = cidStr.split(",");
			Set<String> cIDs = new HashSet<>();
			for(String cid:cidArr){
				cIDs.add(cid);
			}
			param.put("cidstr", getCidStrList(cIDs));
		}

		new Thread(()->{
			if("onlyTotal".equals(onlyTotal)){
				poiService.exportWorkloadExcelZipOnlyTotal(u.getUsername(), param);
			}else{
				poiService.exportWorkloadExcelZip(u.getUsername(), param);
			}
		}).start();
		return ResponseEntity.ok("success");
	}

	/**
	 * 进入被删的试题课程列表 
 	 */
	@RequestMapping("/indelQuestion")
	public String indelQuestion() {
		getRequest().setAttribute("back", getPara("back"));

		return "jsp/question/indelQuestion";
	}
	
	// 进入编辑试题
	@RequestMapping("/inCountQuestion")
	public String inCountQuestion() {
		User u = getUserInfo();
		if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
        	u.setcIDs(userService.findAllCids());
        }else{ //其他角色，查询有浏览课程权限的所有课程
        	u.setcIDs(userService.findCids(u.getId()));
        }
		Set<String> cIDs = u.getcIDs();
		if(wj_cid!=null && !"".equals(wj_cid)){
			cIDs.add(wj_cid);
		}
		getRequest().setAttribute("back", getPara("back"));
		
		return "jsp/question/inCountQuestion";
	}

	// 进入分布统计
	@RequestMapping("/distributionStatistics")
	public String distributionStatistics() {
		if(getUserInfo()==null && getStudentInfo()==null){
			return "jsp/notTheRole";
		}
		String cid = getPara("c_id");
		Map<String, Object> courseAttr = courseService.getCourseAttr(cid).get(0);
		if(!cid.equals(wj_cid) && Utils.changeObjToInt(courseAttr.get("open"))==0){
			if(!getSubject().hasRole("administrator")) {
				Map map = new HashMap();
				map.put("uid",getUserID());
				map.put("cid", cid);
				map.put("permission", "question:view");
				if(questionService.checkQuestionPermission(map,getUserID()+"_"+cid)==0){
					return "jsp/notTheRole"; 
				}
			}
		}
		Map param = new HashMap();
		param.put("id", cid);
		param.put("cid", cid);
		Map m0 = new HashMap();
		m0.put("c_id", cid);

		getRequest().setAttribute("cname", courseAttr.get("name_c"));
		getRequest().setAttribute("distributionStatistics", questionService.getDistributionStatistics(param)); //试题分布统计 !=2
		getRequest().setAttribute("themeList", courseAttr.get("themeList"));
		getRequest().setAttribute("questionTypeList", questionService.getAllQT4CourseQuestion(param));//获取课程题目的所有题型
		BigDecimal questionCount = questionService.getQuestionCount4Distribution(cid);
		getRequest().setAttribute("count", questionCount);
		getRequest().setAttribute("course", courseAttr.get("c_name_c"));
		
		List<Map<String, Object>> difficultyDistribution = questionService.getDifficultyDistribution(cid);
		List<Map<String, Object>> difficultyRes = new ArrayList<>();
		for(int j=0;j<difficultyDistribution.size();j++){
			Map m = new HashMap();
			m.put("name", difficultyDistribution.get(j).get("DNAME"));
			BigDecimal num = (BigDecimal) difficultyDistribution.get(j).get("NUM");
			m.put("num", num);
			m.put("percent", Utils.percentOf(num,questionCount));
			difficultyRes.add(m);
		}		
		getRequest().setAttribute("difficultyRes", difficultyRes);

		List<Map<String, Object>> cognitionDistribution = questionService.getCognitionDistribution(cid);
		List<Map<String, Object>> cognitionRes = new ArrayList<>();
		for(int j=0;j<cognitionDistribution.size();j++){
			Map m = new HashMap();
			m.put("name", cognitionDistribution.get(j).get("CONAME"));
			BigDecimal num = (BigDecimal) cognitionDistribution.get(j).get("NUM");
			m.put("num", num);
			m.put("percent", Utils.percentOf(num, questionCount));
			cognitionRes.add(m);
		}		
		getRequest().setAttribute("cognitionRes", cognitionRes);
		
		List<Map<String, Object>> knowledgeDistribution = questionService.getKnowledgeDistribution(cid);
		List<Map<String, Object>> knowledgeRes = new ArrayList<Map<String, Object>>();
		for(int j=0;j<knowledgeDistribution.size();j++){
			Map m = new HashMap();
			m.put("name", knowledgeDistribution.get(j).get("KNAME"));
			BigDecimal num = (BigDecimal) knowledgeDistribution.get(j).get("NUM");
			m.put("num", num);
			m.put("percent", Utils.percentOf(num, questionCount));
			knowledgeRes.add(m);
		}
		getRequest().setAttribute("knowledgeRes", knowledgeRes);
		getRequest().setAttribute("cid", cid);
		getRequest().setAttribute("role", getUserInfo()==null?"student":"user");
		return "jsp/question/distributionStatistics";
	}
	
	// 进入试题列表页面
	@RequestMapping("/QuestionList")
	public String QuestionList(){
		String cid = getPara("c_id");
		if(!cid.equals(wj_cid)){
			if(!"administrator".equals(getUserInfo().getRole())){
				Map map = new HashMap();
				map.put("uid",getUserID());
				map.put("cid", cid);
				map.put("permission", "question:view");
				if(questionService.checkQuestionPermission(map,getUserID()+"_"+cid)==0){
					return "jsp/notTheRole"; 
				}
			}
		}
		
		getRequest().setAttribute("c_id", cid);
		getRequest().setAttribute("courseInfo", courseService.getCourseAttr(cid));
		systemService.addOnlineSysLog("进入了"+cid+"的试题列表");
		return "jsp/question/questionList";
	}

	// 进入被删除的试题列表页面
	@RequestMapping("/DelQuestionList")
	public String DelQuestionList(){
		String cid = getPara("c_id");
		if(!cid.equals(wj_cid)){
			if(!"administrator".equals(getUserInfo().getRole())){
				int rtn = 0;
				Map map = new HashMap();
				map.put("uid",getUserID());
				map.put("cid", cid);
				map.put("permission", "question:view");
				rtn = questionService.checkQuestionPermission(map,getUserID()+"_"+cid);
				if(rtn==0){
					return "jsp/notTheRole";
				}
			}
		}
		getRequest().setAttribute("c_id", cid);
		getRequest().setAttribute("courseInfo", courseService.getCourseAttr(cid));
		return "jsp/question/delquestionList";
	}

	// 进入试题列表页面
	@RequestMapping("/QuestionList4Verify")
	public String QuestionList4Verify(){
		String cid = getPara("c_id");
		if(!"administrator".equals(getUserInfo().getRole())){
			Map map = new HashMap();
			map.put("uid",getUserID());
			map.put("cid", cid);
			map.put("permission", "question:verify");
			if(questionService.checkQuestionPermission(map,getUserID()+"_"+cid)==0){
				map.put("permission", "question:lastVerify");
				if(questionService.checkQuestionPermission(map,getUserID()+"_"+map.get("cid"))==0) {
					return "jsp/notTheRole"; 
				}				
			}
		}
	
		getRequest().setAttribute("c_id", cid);
		getRequest().setAttribute("courseInfo", courseService.getCourseAttr(cid));
		return "jsp/question/questionList4Verify";
	}


	//导出所有试题
	@RequestMapping("/exportAll")  
    public ResponseEntity<Resource> exportAll() {
		User u = getUserInfo();
		String cid = getPara("cid");
		Map param = new HashMap();
		param.put("uid", u.getId());
		param.put("cid", cid);
		param.put("th1id", getPara("th1id"));
		param.put("th2id", getPara("th2id"));
		param.put("th3id", getPara("th3id"));
		param.put("qtid", getPara("qtid"));
		param.put("coid", getPara("coid"));
		param.put("did", getPara("did"));
		param.put("kid", getPara("kid"));
		param.put("isVerified", getPara("isVerified"));
		param.put("question", getPara("question"));
		param.put("teacher", getPara("teacher"));
		param.put("permission", "question:export");
		param.put("gs", getPara("gs"));
		if(!"administrator".equals(getUserInfo().getRole())){
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0){
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
			}
		}
		Map<String, Object> courseAttr=courseService.getCourseAttr(cid).get(0);
		HSSFWorkbook workbook = poiService.exportQuestion(param,null);
		  
		Map log = new HashMap();
		log.put("content", "批量导出课程试题,课程代码为："+cid+"，课程名为《"+courseAttr.get("name_c")+"》");
		log.put("cid", cid);
		systemService.addSysLog(log);
		  
		return FileDownloadUtils.download(workbook,courseAttr.get("name_c") + ".xls");
	} 

	//导出所选试题
	@RequestMapping("/exportSelect")  
    public ResponseEntity<Resource> exportSelect() {
		User u = (User) getSubject().getSession().getAttribute("userInfo");
		String cid = getPara("cid");
		Map param = new HashMap();
		param.put("uid", u.getId());
		param.put("cid", cid);
		param.put("gs", getPara("gs"));
		param.put("permission", "question:export");
		if(!"administrator".equals(getUserInfo().getRole())){
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0){
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
			}
		}
		String[] qids = (getParaValues("qids"))[0].split(",");
		HSSFWorkbook workbook = poiService.exportQuestion(param, qids);
		String cname = (String) courseService.getCourseAttr(cid).get(0).get("name_c");
		
		Map log = new HashMap();
		log.put("content", "批量导出课程试题,课程为："+cname+"("+cid+")");
		log.put("cid", cid);
		systemService.addSysLog(log);
		  
		return FileDownloadUtils.download(workbook, cname + ".xls");
	}
	
	// 导入试题
	@RequestMapping("/importQuestion")
	public @ResponseBody Map<String, Object> importQuestion(@RequestParam(value="uploadFile") MultipartFile mFile) {
		User u = getUserInfo();
		String cid = getPara("cid");
		String repeat = getPara("repeat");
		Map param = new HashMap();
		param.put("uid", u.getId());
		param.put("cid", cid);
		param.put("permission", "question:import");
		Map map = new HashMap();
		if(!"administrator".equals(getUserInfo().getRole())){
			if(u==null || questionService.checkQuestionPermission(param,u.getId()+"_"+cid)==0){
				map.put("code", 1);
				map.put("message", "您没有相关权限");
				return map;
			}
		}

		map = poiService.importQuestion(mFile, cid, repeat);
		getRequest().setAttribute("c_id", cid);		
		
		Map log = new HashMap();
		log.put("content", "批量导入课程试题,课程代码为："+cid);
		log.put("cid", cid);
		systemService.addSysLog(log);
		
		return map;
	}
	
	// 导入试题例子
	@RequestMapping("/importQuestionMonel")
    public ResponseEntity<Resource> importQuestionMonel() throws IOException {
		return FileDownloadUtils.download(WebFilePath.getProjectPath() +"mb/stmb2.xlsx");
    }
    
    /**
     * 从word导入试题模板-通用版
     * @return
     * @throws IOException
     */
    @RequestMapping("/importQuesFromWordTemp")
    public ResponseEntity<Resource> importQuesFromWordTemp() {
		return FileDownloadUtils.download(WebFilePath.getProjectPath()+"mb/Word导入模板说明.docx");
    }

	/**
	 * 获取试题列表，使用者：编辑试题
	 * @author 洪艳
	 * @return Map<String, Object>
	 */
	@RequestMapping("/getQuestionList")
	public @ResponseBody Map<String, Object> getQuestionList() {
		String cid = getPara("c_id");
		if(!cid.equals(wj_cid)){
			if(!"administrator".equals(getUserInfo().getRole())){
				Map map = new HashMap();
				map.put("uid",getUserID());
				map.put("cid", cid);
				map.put("permission", "question:view");
				if(questionService.checkQuestionPermission(map,getUserID()+"_"+cid)==0){
					return null; 
				}
			}
		}
		Map m = genQuestionListParamMap(cid);
		if("illegalAnswer".equals(getPara("illegalAnswer"))){
			m.clear();
			m.put("c_id", getPara("c_id"));
			m.put("illegalAnswerQids", questionService.findCourseIllegalAnswerQids(cid));
		}
		PageUtils pu = getPageUtil();
		return getRes(questionService.getQuestion(m, pu), questionService.getQuestionCount(m));
	}
	private Map<String, Object> genQuestionListParamMap(String cid){
		Map m = new HashMap();
		m.put("c_id", cid);
		m.put("th1id", getPara("th1id"));
		m.put("th2id", getPara("th2id"));
		m.put("th3id", getPara("th3id"));
		m.put("qtid", getPara("qtid"));
		m.put("coid", getPara("coid"));
		m.put("did", getPara("did"));
		m.put("kid", getPara("kid"));
		m.put("num", getPara("num"));
		m.put("addtime", getPara("addtime"));
		String isVerified = getPara("isVerified");
		if(StringUtils.isBlank(isVerified)){
			m.remove("state");//用于加载未被删除的试题
		}else{
			m.put("state", Utils.changeObjToInt(isVerified));
		}
		setMapParamSafe(m, "question");
		setMapParamSafe(m, "answer");
		setMapParamSafe(m, "teacher");
		m.put("begindate", String.valueOf(getPara("beginDate")));
		m.put("enddate", String.valueOf(getPara("endDate")));
		if(!"null".equals(String.valueOf(getPara("testNumMin")))){
			setMapParamSafe(m,"testNumMin");
		}
		if(!"null".equals(String.valueOf(getPara("testNumMax")))){
			setMapParamSafe(m,"testNumMax");
		}
		m.put("order", getPara("order"));
		m.put("sort", getPara("sort"));
		return m;
	}

	@RequestMapping("/getDelQuestionList")
	public @ResponseBody Map<String, Object> getDelQuestionList() {
		String cid=getPara("c_id");
		if(!"administrator".equals(getUserInfo().getRole())){
			Map param = new HashMap();
			param.put("uid", getUserID());
			param.put("cid", cid);
			param.put("permission", "question:view");
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0) {
				return null;
			}
		}		
		
		Map m = genQuestionListParamMap(cid);
		m.put("state",2);
		PageUtils pu = getPageUtil();
		return getRes(questionService.getQuestion(m, pu), questionService.getQuestionCount(m));
	}
	
	
	// 获取试题详细信息
	@RequestMapping("/getQuestionDetail")
	public @ResponseBody List<Map<String, Object>> getQuestionDetail() {
		Map m = new HashMap();
		m.put("id", getPara("q_id"));
		List<Map<String, Object>> res = new ArrayList<>();
		res.add(questionService.getQuestionDetail(m).get(0));
		String mqid = getPara("mqid");
		if(!StringUtils.isEmpty(mqid)){
			m.put("id", getPara("mqid"));
			res.add(questionService.getQuestionDetail(m).get(0));
		}
		return res;
	}

	// 获取试题内容
	@RequestMapping("/getQuestionCon")
	public @ResponseBody Map<String, Object> getQuestionCon() {
		Map m = new HashMap();
		m.put("id", getPara("q_id"));
		m.put("version", getPara("version"));
		return questionService.getQuestionCon(m);
	}
		
	/**
	 * 新增试题入口,使用者：编辑试题-新增试题
	 * @author 洪艳
	 * @return String
	 */
	@RequestMapping("/inAddQuestion")
	public String inAddQuestion() {	
		getSession().removeAttribute("eid");
		String cid = getPara("c_id");
		if(!cid.equals(wj_cid)){
			if(!getSubject().hasRole("administrator")){
				Map map = new HashMap();
				map.put("uid",getUserID());
				map.put("cid", cid);
				map.put("permission", "question:add");
				if(questionService.checkQuestionPermission(map,getUserID()+"_"+cid)==0){
					return "jsp/notTheRole"; 
				}
			}
		}		
		
		String mqid = Utils.getNotEmptyVal(getPara("mqid"));
		String iscon = Utils.getNotEmptyVal(getPara("iscon"));
		Map m = new HashMap();
		m.put("c_id", cid);
		if(iscon.equals("1")){
			m.put("id", mqid);
			getRequest().setAttribute("mainQuestion", questionService.getQuestionInfo(m));  //将主题干查询出来
		}	
		getRequest().setAttribute("mqid", mqid);
		getRequest().setAttribute("iscon", iscon);
		
		getRequest().setAttribute("c_id", cid);
		Map<String,Object> courseInfo=courseService.getCourseAttr(cid).get(0);
		getRequest().setAttribute("courseInfo", courseInfo);
		return "jsp/question/addQuestion";
	}
	
	/**
	 * 新增试题
	 * @author 洪艳
	 * @return
	 */
	@RequestMapping("/addQuestion")
	public String addQuestion() {
		String cid = getPara("cid");
		Map param = new HashMap();
		param.put("cid", cid);
		if(!"administrator".equals(getUserInfo().getRole())){
			param.put("uid",getUserID());
			param.put("permission", "question:add");
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0) {
				return "jsp/notTheRole";
			}
		}
		
		String id = questionService.getQuestionID();
		int isMain = Integer.parseInt(getPara("isMain"));
		int iscon = Integer.parseInt(getPara("iscon"));
		int xxdf = Integer.parseInt(getPara("xxdf"));
		String mqid = getPara("mqid");
		
		String cname = getPara("cname");		
		Integer AnswerType = Integer.parseInt(getPara("AnswerType"));
		
		if(iscon == 1 && isMain == 0){//串题+非主题干
			param.put("mqid", mqid);
		}
		param.put("isMain", getPara("isMain"));
		param.put("iscon", getPara("iscon"));
		param.put("id", id);
		param.put("qtid", getPara("questionType"));
		param.put("atid", getPara("AnswerType"));
		param.put("aid", getPara("arrangement"));
		param.put("sourceid", getPara("source"));
		param.put("cognitionid", getPara("cognition"));
		param.put("difficultyid", getPara("difficulty"));
		param.put("knowledgeid", getPara("knowledge"));
		param.put("answertime", getPara("answertime"));
		param.put("cognitionid_b", getPara("cognition_b"));
		param.put("difficultyid_b", getPara("difficulty_b"));
		param.put("knowledgeid_b", getPara("knowledge_b"));
		param.put("answertime_b", getPara("answertime_b"));
		param.put("theme1id", getPara("firstTheme"));
		param.put("theme2id", getPara("secondTheme"));
		param.put("theme3id", getPara("thirdTheme"));
		param.put("content", ImgUtil.saveEditorFomulaPic(getRequest().getParameter("qcontent"), cid));
		param.put("answerexplain", PaperContentUtils.fitForVarchar2_4000Byte(getRequest().getParameter("qexplain")));
		param.put("addtime", new Date()); 
		param.put("answertype", getPara("AnswerType"));
		param.put("creatorid", getUserID());
		param.put("creator", getUserInfo().getRealname());
		param.put("filepath", getPara("filepath"));
		
		if(isMain == 0){
			double qscore=0;
			if(AnswerType<4 || AnswerType==8 || AnswerType==9){
				String correct = getPara("correct");
				String[] correct_array = correct.split(",");
				String answerid = "";
				List<Map> l1 = new ArrayList<Map>();
				for(int i=0;i<100;i++){		
					String aid = "";
					if(getPara("answer"+i)!=null){
						aid = questionService.getAnswerID();
						String answer_content = getRequest().getParameter("answer"+i);		
						Map m = new HashMap();
						if(xxdf==1){
							double score=Double.parseDouble(getPara("score"+i));
							m.put("score", score);
							if(AnswerType==0||AnswerType==2){
								if(score>qscore){
									qscore=score;
								}
							}
						}
						for(int j=0;j<correct_array.length;j++){
							if(!"".equals(correct_array[j])){
								if(i==Integer.parseInt(correct_array[j])){
									answerid += aid+",";
									if(xxdf==1&&(AnswerType==1||AnswerType==3)){
										double score=Double.parseDouble(getPara("score"+i));
										qscore+=score;
									}
								}
							}
						}
						m.put("aid", aid);
						m.put("answer_content", ImgUtil.saveEditorFomulaPic(answer_content,cid));
						m.put("answer_content_6", "");
						l1.add(m);
					}else{
						break;
					}
				}
				if(answerid!=null && !"".equals(answerid)){
					answerid = answerid.substring(0,answerid.length()-1);
				}else{
					answerid = (String)l1.get(l1.size()-1).get("aid");
				}				
				param.put("answer", l1);
				param.put("answerid", answerid);
				if(xxdf==1){
					param.put("score", qscore);
				}
			}else if(AnswerType==4){
				List l3 = new ArrayList();
				Map m = new HashMap();
				m.put("aid", questionService.getAnswerID());
				m.put("answer_content", getPara("answerCon"));
				m.put("answer_content_6", "");
				l3.add(m);
				param.put("answer", l3);
				param.put("answerid", m.get("aid"));
			}else{
				List l3 = new ArrayList();
				Map m = new HashMap();
				m.put("aid", questionService.getAnswerID());
				m.put("answer_content", "");
				String answerCon = getRequest().getParameter("answerCon");
				if(answerCon==null||"".equals(answerCon)){
					answerCon="无标准答案";
				}
				//m.put("answer_content_6", answerCon);
				m.put("answer_content_6", ImgUtil.saveEditorFomulaPic(answerCon,cid));
				l3.add(m);
				param.put("answer", l3);
				param.put("answerid", m.get("aid"));
			}
		}
	
		getRequest().setAttribute("isMain", isMain);
		getRequest().setAttribute("iscon", iscon);
		getRequest().setAttribute("c_id", cid);
		getRequest().setAttribute("c_name", cname);

//		param.put("targetList",getSession().getAttribute("questionTargetList"));
		questionService.insertQuestion(param);
		
		Map m = new HashMap();
		m.put("c_id", cid);
		if(iscon == 0){
			m.put("id", id);					
			getRequest().setAttribute("mainQuestion", questionService.getQuestion_AnswerByQID(m));
		}else if(iscon == 1 && isMain == 1){//串题+主题干
			m.put("id", id);
			Map<String, Object> mainQuestion = questionService.getQuestionPrevew(m);
			getRequest().setAttribute("mqid", id);
			getRequest().setAttribute("mainQuestion", mainQuestion);
			
			int atid = Integer.parseInt(String.valueOf(mainQuestion.get("atid")));
			
			getRequest().setAttribute("questionList",  questionService.getBranchQuestion_AnswerByQID(id,atid));
		}else if(iscon == 1 && isMain == 0){//串题+非主题干
			m.put("id", mqid);
			getRequest().setAttribute("mqid", mqid);
			
			Map<String, Object> mainQuestion = questionService.getQuestionPrevew(m);
			getRequest().setAttribute("mainQuestion", mainQuestion);
			
			int atid = Integer.parseInt(String.valueOf(mainQuestion.get("atid")));
			
			getRequest().setAttribute("questionList",  questionService.getBranchQuestion_AnswerByQID(mqid,atid));			
		}		
		
		//上一道新增试题的参数
		Map lastQuestionParam = (Map) getSession().getAttribute("lastAddParam");
		if(lastQuestionParam == null){
			lastQuestionParam = new HashMap<>();
		}
		lastQuestionParam.put("qtid", getPara("questionType"));
		lastQuestionParam.put("sourceid", getPara("source"));
		lastQuestionParam.put("difficultyid_b", getPara("difficulty_b"));
		lastQuestionParam.put("difficultyid", getPara("difficulty"));
		lastQuestionParam.put("knowledgeid", getPara("knowledge"));
		lastQuestionParam.put("cognitionid", getPara("cognition"));
		lastQuestionParam.put("answertime", getPara("answertime"));
		lastQuestionParam.put("cid", cid);
		getSession().setAttribute("lastAddParam", lastQuestionParam);
		
		getRequest().setAttribute("xxdf", xxdf);
		return  "jsp/question/previewQuestion";
	}
	
	// 预览试题
	@RequestMapping("/previewQuestion")
	public String previewQuestion() {
		String qid = getPara("qid");
		String mqid = getPara("mqid");
		String cid = questionService.getCidByQid(qid);
		if(!"administrator".equals(getUserInfo().getRole())){
			Map param = new HashMap();
			param.put("uid", getUserID());
			param.put("cid", cid);
			param.put("permission", "question:view");
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0) {
				return null;
			}
		}
		String cids = getPara("c_ids");
		Integer isMain = Integer.parseInt(getPara("isMain"));
		Integer iscon = Integer.parseInt(getPara("iscon"));
		String cname = courseService.getCourseCNameByCid(cid);
		String eid = getPara("eid");
		
		getRequest().setAttribute("c_ids", cids);
		getRequest().setAttribute("isB", getPara("isB"));//标识是否从B卷进入
		getRequest().setAttribute("eid", eid);//此处eid用于区分是浏览试卷试题还是浏览课程试题
		getRequest().setAttribute("iscon", iscon);
		getRequest().setAttribute("isMain", isMain);
		getRequest().setAttribute("mqid", mqid);
		getRequest().setAttribute("c_id", cid);
		getRequest().setAttribute("c_name", cname);	
		String edit = getPara("edit");
		getRequest().setAttribute("edit", edit);
		
		Map m = new HashMap();
		m.put("c_id", cid);		
		
		if(iscon == 0){
			m.put("id", qid);
			Map<String, Object> mainQuestion=questionService.getQuestion_AnswerByQID(m);
			getRequest().setAttribute("xxdf", mainQuestion.get("xxdf"));
			getRequest().setAttribute("mainQuestion", mainQuestion);
		}else if(iscon == 1 && isMain == 1){//串题+主题干
			m.put("id", qid);
			Map<String, Object> mainQuestion = questionService.getQuestionPrevew(m);
			getRequest().setAttribute("mqid", qid);
			getRequest().setAttribute("mainQuestion", mainQuestion);
			
			int atid = Integer.parseInt((String)mainQuestion.get("atid"));
			getRequest().setAttribute("xxdf", mainQuestion.get("xxdf"));
			getRequest().setAttribute("questionList",  questionService.getBranchQuestion_AnswerByQID(qid,atid));
		}else if(iscon == 1 && isMain == 0){//串题+非主题干
			m.put("id", mqid);
			getRequest().setAttribute("mqid", mqid);
			
			Map<String, Object> mainQuestion = questionService.getQuestionPrevew(m);
			getRequest().setAttribute("xxdf", mainQuestion.get("xxdf"));
			getRequest().setAttribute("mainQuestion", mainQuestion);
			
			int atid = Integer.parseInt(String.valueOf(mainQuestion.get("atid")));
			
			getRequest().setAttribute("questionList",  questionService.getBranchQuestion_AnswerByQID(mqid,atid));			
		}
		Map mm = genQuestionListParamMap(cid);
		mm.put("id", qid);
		if(iscon==1&&isMain==0){
			mm.put("id", mqid);
		}
		mm.put("isView", 1);
		Map<String,Object> lastAndNextQuestion = questionService.getPrevAndNextQuestion(mm);
		getRequest().setAttribute("lastQuestion", lastAndNextQuestion.get("lastQuestion"));
		getRequest().setAttribute("nextQuestion", lastAndNextQuestion.get("nextQuestion"));
		
		String repeat = getPara("repeat");//查看是否从查看重复试题进入，查看重复试题没有上一题与下一题
		if ("1".equals(repeat)) {
			return "jsp/question/previewRepeatQuestion";
		}else {
			return  "jsp/question/previewQuestion";
		}
	}
	
	/**
	 * 进入试题更新页面
	 * @author 洪艳
	 * @return
	 */
	@RequestMapping("/editQuestion")
	public String editQuestion() {
		String cid = Utils.getNotEmptyVal(getPara("c_id"));
		
		if(!"administrator".equals(getUserInfo().getRole())){
			Map pmap = new HashMap();
			pmap.put("uid", getUserID());
			pmap.put("cid", cid);
			pmap.put("permission", "question:update");
			if(questionService.checkQuestionPermission(pmap,getUserID()+"_"+cid)==0) {
				return "jsp/notTheRole";
			}
		}		
		
		String qid = Utils.getNotEmptyVal(getPara("q_id"));
		String mqid = Utils.getNotEmptyVal(getPara("mqid"));
		String isMain = Utils.getNotEmptyVal(getPara("isMain"));
		String iscon = Utils.getNotEmptyVal(getPara("iscon"));
		
		String eid = getPara("eid");
		getRequest().setAttribute("courseInfo", courseService.getCourseAttr(cid).get(0));

		getRequest().setAttribute("c_id", cid);
		
		Map m = new HashMap();
		m.put("c_id",cid);
		if(iscon.equals("1") && isMain.equals("0")){  //串题&非主题干
			m.put("id", mqid);
			getRequest().setAttribute("MainQuestion", questionService.getQuestionInfo(m));
		}
		getRequest().setAttribute("qid", qid);
		getRequest().setAttribute("mqid", mqid);
		getRequest().setAttribute("iscon", iscon);
		getRequest().setAttribute("isMain", isMain);
		getRequest().setAttribute("eid", eid);//此处eid用于区分是浏览试卷试题还是浏览课程试题
		getRequest().setAttribute("isB", getPara("isB"));//标识是否从B卷进入
		
		Map param = new HashMap();
		param.put("id", getPara("q_id"));
		param.put("c_id", cid);
		param.put("e_id", eid);
		Map<String,Object> questionInfo=questionService.getQuestionInfo(param);
//		List<Map<String,Object>> targetList=(List<Map<String,Object>>)questionInfo.get("targetList");
//		getSession().setAttribute("questionTargetList",targetList);
//		List<Map<String,Object>> targetRtn=new ArrayList<Map<String,Object>>();
//		for(Map<String,Object> target:targetList){
//			if("1".equals(String.valueOf(target.get("TLEVEL")))){
//				targetRtn.add(target);
//			}
//		}
//		questionInfo.put("targetList",targetRtn);
		getRequest().setAttribute("question", questionInfo);
		Map mm = genQuestionListParamMap(cid);
		mm.put("id", qid);
		mm.put("isView", 0);
		Map<String,Object> lastAndNextQuestion = questionService.getPrevAndNextQuestion(mm);
		getRequest().setAttribute("lastQuestion", lastAndNextQuestion.get("lastQuestion"));
		getRequest().setAttribute("nextQuestion", lastAndNextQuestion.get("nextQuestion"));
		
		return "jsp/question/editQuestion";
	}
	
	/**
	 * 修改试题，使用者：editQuestion.jsp
	 * @author 洪艳
	 * @return
	 */
	@RequestMapping("/updateQuestion")
	public String updateQuestion(RedirectAttributes ra) {
		String qid=Utils.getNotEmptyVal(getPara("qid"));
		String cid=Utils.getNotEmptyVal(getPara("cid"));
		Map param = new HashMap();
		if(!"administrator".equals(getUserInfo().getRole())){
			param.put("uid", getUserID());
			param.put("cid", cid);
			param.put("permission", "question:update");
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0) {
				return "jsp/notTheRole";
			}
		}
		
		param.put("CID", Utils.getNotEmptyVal(getPara("cid")));
		param.put("eid", getPara("eid"));
		param.put("id", qid);
		param.put("qtid", Utils.getNotEmptyVal(getPara("questionType")));
		param.put("sourceid", Utils.getNotEmptyVal(getPara("source")));
		param.put("aid", Utils.getNotEmptyVal(getPara("arrangement")));
		param.put("cognitionid", Utils.getNotEmptyVal(getPara("cognition")));
		param.put("difficultyid", Utils.getNotEmptyVal(getPara("difficulty")));
		param.put("knowledgeid", Utils.getNotEmptyVal(getPara("knowledge")));
		param.put("answertime", Utils.getNotEmptyVal(getPara("answertime")));
		param.put("cognitionid_b", Utils.getNotEmptyVal(getPara("cognition_b")));
		param.put("difficultyid_b", Utils.getNotEmptyVal(getPara("difficulty_b")));
		param.put("knowledgeid_b", Utils.getNotEmptyVal(getPara("knowledge_b")));
		param.put("answertime_b", Utils.getNotEmptyVal(getPara("answertime_b")));
		param.put("theme1id", Utils.getNotEmptyVal(getPara("firstTheme")));
		param.put("theme2id", Utils.getNotEmptyVal(getPara("secondTheme")));
		param.put("theme3id", Utils.getNotEmptyVal(getPara("thirdTheme")));
		param.put("content", ImgUtil.saveEditorFomulaPic(getRequest().getParameter("qcontent"),cid));
		param.put("updatorid", getUserID());
		param.put("updatetime", new Date());
		param.put("answerexplain", PaperContentUtils.fitForVarchar2_4000Byte(getRequest().getParameter("qexplain")));
		param.put("answertype", Utils.getNotEmptyVal(getPara("AnswerType")));
		param.put("mqid", Utils.getNotEmptyVal(getPara("mqid")));
		param.put("isMain", Utils.getNotEmptyVal(getPara("isMain")));
		param.put("iscon", Utils.getNotEmptyVal(getPara("iscon")));
		param.put("filepath", getPara("filepath"));
		
		int AnswerType = Integer.parseInt((String)param.get("answertype"));
		int isMain = Integer.parseInt(getPara("isMain"));
		int iscon = Integer.parseInt(getPara("iscon"));
		int xxdf = Integer.parseInt(getPara("xxdf")); 
		
		String mqid = Utils.getNotEmptyVal(getPara("mqid"));
		
		//将原题目的answer查询出来
		List<Map<String, Object>> answerList = questionService.getAnswerByQID(param);
		
		if(isMain == 0){
			double qscore=0;
			if(AnswerType<4|| AnswerType==8 || AnswerType==9){
				String correct = getPara("correct");
				String[] correct_array = correct.split(",");
				String answerid = "";
				List<Map> l1 = new ArrayList<>();//已存在的答案，update
				List<Map<String,Object>> l2= new ArrayList<>();//不存在的答案，insert
				List<Map<String,Object>> l3= new ArrayList<>();//被移除的答案，delete
				int f=0;
				for(int i=0;i<100;i++){
					String aid = "";
					if(getPara("answer"+i)==null){
						break;
					}
					f++;
					if(i<answerList.size()){
						aid = (String) answerList.get(i).get("AID");
						String answer_content = getRequest().getParameter("answer"+i);
						Map m = new HashMap();
						if(xxdf==1){
							double score=Double.parseDouble(getPara("score"+i));
							m.put("score", score);
							if(AnswerType==0||AnswerType==2){
								if(score>qscore){
									qscore=score;
								}
							}
						}
						for(int j=0;j<correct_array.length;j++){
							if(!"".equals(correct_array[j])){
								if(i==Integer.parseInt(correct_array[j])){
									answerid += aid+",";
									if(xxdf==1&&(AnswerType==1||AnswerType==3)){
										double score=Double.parseDouble(getPara("score"+i));
										qscore+=score;
									}
								}
							}
						}
						m.put("aid", aid);
						m.put("answer_content", ImgUtil.saveEditorFomulaPic(answer_content,cid));
						m.put("answer_content_6", "");
						l1.add(m);
					}else{
						aid = questionService.getAnswerID();
						String answer_content = getRequest().getParameter("answer"+i);
						Map m = new HashMap();
						if(xxdf==1){
							double score=Double.parseDouble(getPara("score"+i));
							m.put("score", score);
							if(AnswerType==0||AnswerType==2){
								if(score>qscore){
									qscore=score;
								}
							}
						}
						for(int j=0;j<correct_array.length;j++){
							if(!"".equals(correct_array[j])){
								if(i==Integer.parseInt(correct_array[j])){
									answerid += aid+",";
									if(xxdf==1&&(AnswerType==1||AnswerType==3)){
										double score=Double.parseDouble(getPara("score"+i));
										qscore+=score;
									}
								}
							}
						}
						m.put("aid", aid);
						m.put("answer_content", ImgUtil.saveEditorFomulaPic(answer_content,cid));
						m.put("answer_content_6", "");
						m.put("id", qid);
						m.put("answertype", AnswerType);
						m.put("index", i);
						l2.add(m);
					}
				}
				if(f<answerList.size()){//说明有被移除的选项
					for(;f<answerList.size();f++){
						l3.add(answerList.get(f));
					}
				}
				
				if(answerid!=null && !"".equals(answerid)){
					answerid = answerid.substring(0,answerid.length()-1);
				}else{
					answerid = (String)l1.get(l1.size()-1).get("aid");
				}
				param.put("answer", l1);
				param.put("answerid", answerid);
				param.put("answer_add", l2);
				param.put("answer_delete", l3);
				if(xxdf==1){
					param.put("score", qscore);
				}
			}else if(AnswerType==4){
				List l3 = new ArrayList();
				Map m = new HashMap();
				m.put("aid", (String) answerList.get(0).get("AID"));
				m.put("answer_content", getPara("answerCon"));
				m.put("answer_content_6", "");
				l3.add(m);
				param.put("answer", l3);
				param.put("answerid", m.get("aid"));
			}else{
				List l3 = new ArrayList();
				Map m = new HashMap();
				m.put("aid", (String) answerList.get(0).get("AID"));
				m.put("answer_content", "");
				String answerCon = getRequest().getParameter("answerCon");
				if(answerCon==null||"".equals(answerCon)){
					answerCon="无标准答案";
				}
				m.put("answer_content_6", ImgUtil.saveEditorFomulaPic(answerCon,cid));
				l3.add(m);
				param.put("answer", l3);
				param.put("answerid", m.get("aid"));
			}
		}
//		param.put("targetList",getSession().getAttribute("questionTargetList"));
		questionService.updateQuestionWithNoVersion(param);

		getRequest().setAttribute("iscon", iscon);
		getRequest().setAttribute("isMain", isMain);
		getRequest().setAttribute("mqid", mqid);
		getRequest().setAttribute("c_id", param.get("CID"));
		
		Map m = new HashMap();
		m.put("c_id", param.get("CID"));
		String id = (String)param.get("id");
		if(iscon == 0){
			m.put("id", id);					
			getRequest().setAttribute("mainQuestion", questionService.getQuestion_AnswerByQID(m));
		}else if(iscon == 1 && isMain == 1){//串题+主题干
			m.put("id", id);
			Map<String, Object> mainQuestion = questionService.getQuestionPrevew(m);
			getRequest().setAttribute("mqid", id);
			getRequest().setAttribute("mainQuestion", mainQuestion);
			
			int atid = Integer.parseInt((String)mainQuestion.get("atid"));
			
			getRequest().setAttribute("questionList",  questionService.getBranchQuestion_AnswerByQID(id,atid));
		}else if(iscon == 1 && isMain == 0){//串题+非主题干
			m.put("id", mqid);
			getRequest().setAttribute("mqid", mqid);
			
			Map<String, Object> mainQuestion = questionService.getQuestionPrevew(m);
			getRequest().setAttribute("mainQuestion", mainQuestion);
			
			int atid = Integer.parseInt(String.valueOf(mainQuestion.get("atid")));
			
			getRequest().setAttribute("questionList",  questionService.getBranchQuestion_AnswerByQID(mqid,atid));			
		}
		questionService.clearQuestionNum(qid);
		ra.addAttribute("qid", id);
		ra.addAttribute("mqid", mqid);
		ra.addAttribute("isMain", isMain);
		ra.addAttribute("iscon", iscon);
		return "redirect:/question/previewQuestion";
	}
	
	// 删除试题
	@RequestMapping("/delQuestion")
	public @ResponseBody String delQuestion() {
		String cid = getPara("cid");
		
		if(!"administrator".equals(getUserInfo().getRole())){
			Map pmap = new HashMap();
			pmap.put("uid",getUserID());
			pmap.put("cid", cid);
			pmap.put("permission", "question:del");
			
			if(questionService.checkQuestionPermission(pmap,getUserID()+"_"+cid)==0) {
				return null;
			}
		}		
		
		String qid = getPara("q_id");	
		Map m = new HashMap();
		m.put("cid", cid);
		m.put("qid", qid);
		m.put("ismain", getPara("isMain"));
		m.put("iscon", getPara("iscon"));
		m.put("id", qid);
		m.put("cid", cid);
		/*
		String str = questionService.getFilePath(m);
		List<String> delFile = new ArrayList<String>();
		if(!str.equals("")){
			String[] old_file = str.split(",");					
			String p = getRequest().getSession().getServletContext().getRealPath("/");
			for(int i=0;i<old_file.length;i++){			
				//delFile.add(p+old_file[i]);
				delFile.add(p.substring(0,p.lastIndexOf("\\smuexam"))+old_file[i]);
				delFile.add(filePath+old_file[i]);
			}
		}*/
		m.put("updatorid",getUserID());
		m.put("updatetime", new Date());
		Map<String,Object> rtn = questionService.deleteQuestion(m);
		
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
		
		String name_c = courseService.getCourseCNameByCid(cid);
		
		Map log = new HashMap();
		log.put("content", "暂时删除了课程《"+name_c+"》"+ rtn.get("sum") +"道试题，删除的试题ID为："+rtn.get("del_id"));
		log.put("cid", cid);
		systemService.addSysLog(log);
		
		return  rtn.get("sum")+"";
	}

	// 删除试题
	@RequestMapping("/delQuestionReal")
	public @ResponseBody String delQuestionReal() {
		Map m = new HashMap();
		String qid = getPara("q_id");
		String cid = getPara("cid");
		if(!"administrator".equals(getUserInfo().getRole())){
			Map param = new HashMap();
			param.put("uid", getUserID());
			param.put("cid", cid);
			param.put("permission", "question:del");
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0) {
				return null;
			}
		}		
		m.put("qid", qid);
		m.put("ismain", getPara("isMain"));
		m.put("iscon", getPara("iscon"));
		m.put("cid", cid);
		m.put("id", qid);
		Map<String,Object> rtn = questionService.deleteQuestionReal(m);
		String name_c = courseService.getCourseCNameByCid(cid);
		Map log = new HashMap();
		log.put("content", "永久删除了课程《"+name_c+"》"+ rtn.get("sum") +"道试题，删除的试题ID为："+rtn.get("del_id"));
		log.put("cid", cid);
		systemService.addSysLog(log);

		return  rtn.get("sum")+"";
	}

	// 恢复试题
	@RequestMapping("/recoverQuestion")
	public @ResponseBody String recoverQuestion() {
		Map m = new HashMap();
		String qid = getPara("q_id");
		String cid = getPara("cid");
		if(!"administrator".equals(getUserInfo().getRole())){
			Map param = new HashMap();
			param.put("uid", getUserID());
			param.put("cid", cid);
			param.put("permission", "question:update");
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0) {
				return null;
			}
		}
		m.put("qid", qid);
		m.put("ismain", getPara("isMain"));
		m.put("iscon", getPara("iscon"));
		m.put("cid", cid);
		m.put("id", qid);
		m.put("updatorid",getUserID());
		m.put("updatetime", new Date());
		Map<String,Object> rtn = questionService.recoverSelect(m);
		questionService.call_updateCourseQuestioncount(cid);
		String name_c = courseService.getCourseCNameByCid(cid);
		Map log = new HashMap();
		log.put("content", "恢复了课程《"+name_c+"》"+ rtn.get("sum") +"道试题，恢复的试题ID为："+rtn.get("del_id"));
		log.put("cid", cid);
		systemService.addSysLog(log);

		return  rtn.get("sum")+"";
	}

	//初审 试题入库(状态:3代表已经完成终审)
	@RequestMapping("/verifyQuestion")
	public @ResponseBody String verifyQuestion() {
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid",getUserID());
			map.put("cid", getPara("cid"));
			map.put("permission", "question:verify");
			if(questionService.checkQuestionPermission(map,getUserID()+"_"+getPara("cid"))==0){
				return "jsp/notTheRole"; 
			}
		}
		Map m = new HashMap();
		m.put("uid", ((User) getSubject().getSession().getAttribute("userInfo")).getId());
		m.put("id", getPara("q_id"));
		m.put("isMain", getPara("isMain"));
		m.put("state", getPara("state"));
		if(getPara("verify_suggestion")!=null&&!"".equals(getPara("state"))){
			m.put("verify_suggestion", getPara("verify_suggestion"));
		}else {
			m.put("verify_suggestion", "");
		}
		m.put("time", new Date());
		return  ""+ questionService.verifyQuestion(m);
	}
	
	//终审 试题入库(状态:2尚未初审)
	@RequestMapping("/LastVerifyQuestion")
	public @ResponseBody String LastVerifyQuestion() {
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid",getUserID());
			map.put("cid", getPara("cid"));
			map.put("permission", "question:lastVerify");
			if(questionService.checkQuestionPermission(map,getUserID()+"_"+getPara("cid"))==0){
				return "jsp/notTheRole"; 
			}
		}
		Map param = new HashMap();
		param.put("id",getPara("q_id"));
		param.put("state",3);
		if(questionService.checkQuestionState(param)>0) {
			return "3"; 
		}
		param.put("state",0);
		if(questionService.checkQuestionState(param)>0) {
			return "2";
		}
		Map m = new HashMap();
		m.put("uid", getUserID());
		m.put("id", getPara("q_id"));
		m.put("isMain", getPara("isMain"));
		m.put("state", getPara("state"));
		if(getPara("verify_suggestion")!=null&&!"".equals(getPara("state"))){
			m.put("verify_suggestion", getPara("verify_suggestion"));
		}else {
			m.put("verify_suggestion", "");
		}
		m.put("time", new Date());
		return  ""+ questionService.LastVerifyQuestion(m);
		
	}

	//初审所选试题入库
	@RequestMapping("/verSelect")
	public @ResponseBody String verSelect(@RequestBody Map map) {
		String cid = (String) map.get("cid");
		String uid = getUserID();
		if(!getSubject().hasRole("administrator")){
			Map param = new HashMap();
			param.put("uid",uid);
			param.put("cid", cid);
			param.put("permission", "question:verify");
			if(questionService.checkQuestionPermission(param,uid+"_"+cid)==0){
				return "jsp/notTheRole"; 
			}
		}
		
		ArrayList<LinkedHashMap<String,Object>> list = (ArrayList<LinkedHashMap<String, Object>>) map.get("list");
		for(int i=0; i<list.size(); i++){
			Map m = new HashMap();
			m.put("uid", uid);
			m.put("state",1);
			m.put("verify_suggestion","");
			m.put("id", list.get(i).get("qid"));
			m.put("mqid", list.get(i).get("mqid"));
			m.put("isMain", list.get(i).get("isMain"));
			questionService.verifyQuestion(m);
		}
		return "1";
	}
	
	//终审所选试题入库
	@RequestMapping("/LastVerSelect")
	public @ResponseBody String LastVerSelect(@RequestBody Map map) {
		String cid = (String) map.get("cid");
		String uid = getUserID();
		if(!getSubject().hasRole("administrator")){
			Map param = new HashMap();
			param.put("uid",uid);
			param.put("cid", cid);
			param.put("permission", "question:lastVerify");
			if(questionService.checkQuestionPermission(param,uid+"_"+cid)==0){
				return "jsp/notTheRole"; 
			}
		}
		List<String> mainID=new ArrayList<String>();
		ArrayList<Map<String,Object>> list =(ArrayList<Map<String, Object>>) map.get("list");
		for(int i=0;i<list.size();i++) {
			String ismain=String.valueOf(list.get(i).get("isMain"));
			if("1".equals(ismain)) {
				mainID.add((String)list.get(i).get("qid"));
			}
		}
		if(mainID.size()>0) {
			for(String mid:mainID) {
				for(int i=0;i<list.size();i++) {
					String mqid=String.valueOf(list.get(i).get("mqid"));
					if(mid.equals(mqid)) {
						list.remove(i);
						i--;
					}
				}
			}
		}
		for(int i=0; i<list.size(); i++){
			Map m = new HashMap();
			m.put("uid", uid);
			m.put("state",3);
			m.put("verify_suggestion","");
			m.put("id", list.get(i).get("qid"));
			m.put("mqid", list.get(i).get("mqid"));
			m.put("isMain", list.get(i).get("isMain"));
			
			Map cmap=new HashMap();
			cmap.put("id", m.get("id"));
			cmap.put("state", 0);
			if(questionService.checkQuestionState(cmap)>0) {
				return "2";
			}
			questionService.LastVerifyQuestion(m);
		}
		return "1";
	}

	//删除所有试题
	@RequestMapping("/delAll")
	public @ResponseBody String delAll() {	
		String cid = getPara("cid");
		Map map = new HashMap();
		if(!"administrator".equals(getUserInfo().getRole())){
			map.put("uid",getUserID());
			map.put("cid", cid);
			map.put("permission", "question:del");
			map.put("updatetime",new Date());
			if(questionService.checkQuestionPermission(map,getUserID()+"_"+cid)==0){
				return "jsp/notTheRole"; 
			}
		}else{
			map.put("uid",getUserID());
			map.put("cid", cid);
			map.put("updatetime",new Date());
		}
		
		return questionService.delAll(map,getRequest().getSession().getServletContext().getRealPath("/"))+ "";
	}
	
	//进入查询重复试题
	@RequestMapping("/toFindRepeatQuestions")
	public String findRepeat() {
		String cid = getPara("cid");
		//getSubject().checkPermissions(new String[]{"question:*:"+ cid,"question:update:" + cid});
		getRequest().setAttribute("c_id", cid);
		getRequest().setAttribute("courseInfo", courseService.getCourseAttr(cid));
		return "jsp/question/repeatQuestionList";
	}
	
	//查询重复试题
	@RequestMapping("/findRepeatQuestions")
	public @ResponseBody Map<String, Object> findRepeatQuestions(){
		String cid=getPara("cid");
		if(!"administrator".equals(getUserInfo().getRole())){
			Map param = new HashMap();
			param.put("uid", getUserID());
			param.put("cid", cid);
			param.put("permission", "question:view");
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0) {
				return null;
			}
		}
		Map m = new HashMap();
		m.put("cid", cid);
		m.put("th1id", getPara("th1id"));
		m.put("th2id", getPara("th2id"));
		m.put("th3id", getPara("th3id"));
		m.put("qtid", getPara("qtid"));
		m.put("isVerified", getPara("isVerified"));
		m.put("question", getPara("question"));
		m.put("teacher", getPara("teacher"));
		List<Map<String,Object>> rtn;
		if("1".equals(getPara("sameType"))){//1代表要不仅题目相同，答案也相同的list
			List<Map<String,Object>> repeatQuestionList;
			if(getSession().getAttribute("repeatQuestionList")!=null){
				repeatQuestionList = (List<Map<String,Object>>) getSession().getAttribute("repeatQuestionList");
			}else{
				repeatQuestionList = questionService.findRepeatQuestions(m);
			}
			rtn = questionService.findRepeatQuestionsWithAnswer(repeatQuestionList);
			getSession().removeAttribute("repeatQuestionList");
		}else{
			rtn = questionService.findRepeatQuestions(m);
			getSession().setAttribute("repeatQuestionList",rtn);
		}

		return getRes(rtn, rtn.size());
	}
	
	//删除所选题目（暂时删除）
	@RequestMapping("/delSelectQuestion")
	public @ResponseBody String delSelectQuestion(@RequestBody Map map) {
		if(!"administrator".equals(getUserInfo().getRole())){
			Map pmap = new HashMap();
			pmap.put("uid", getUserID());
			pmap.put("cid", map.get("cid"));
			pmap.put("permission", "question:patchDel");
			if(questionService.checkQuestionPermission(pmap,getUserID()+"_"+map.get("cid"))==0) {	
				return "0";
			}
		}
		
//		String p = getRequest().getSession().getServletContext().getRealPath("/");
		List<Map<String, Object>> list = (List<Map<String, Object>>) map.get("data");
		String del_id="";
		//List<String> delFile = new ArrayList<String>();
		for(int i=0;i<list.size();i++) {
			Map param = new HashMap();
			param.put("qid", list.get(i).get("qid").toString());
			param.put("ismain", list.get(i).get("ismain").toString());
			param.put("iscon", list.get(i).get("iscon").toString());
			param.put("cid", list.get(i).get("cid").toString());
			//param.put("id", list.get(i).get("qid").toString());
			/*
			String str = questionService.getFilePath(param);
			if(!str.equals("")){
				String[] old_file = str.split(",");
				for(int j=0;j<old_file.length;j++){			
					//delFile.add(p+old_file[i]);
					delFile.add(p.substring(0,p.lastIndexOf("\\smuexam"))+old_file[i]);
					delFile.add(filePath+old_file[i]);
				}
			}*/
			param.put("updatorid",getUserID());
			param.put("updatetime", new Date());
			del_id+=questionService.deleteQuestion(param).get("del_id");
		}
		if(del_id.length()>0){
			Map log = new HashMap();
			String qids = del_id.substring(0,del_id.length()-1);
			if(qids.length()>1850){
				qids = qids.substring(0,1850)+"...等";
			}
			log.put("content", "暂时删除课程的所选试题，试题编号为"+qids+"，课程序号为："+map.get("cid"));
			log.put("cid", map.get("cid"));
			systemService.addSysLog(log);
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
		return "1";
	}

	@RequestMapping("/delSelectQuestionReal")
	public @ResponseBody String delSelectQuestionReal(@RequestBody Map map) {
		if(!"administrator".equals(getUserInfo().getRole())){
			Map param = new HashMap();
			param.put("uid", getUserID());
			param.put("cid", getPara("cid"));
			param.put("permission", "question:del");
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+getPara("cid"))==0) {
				return null;
			}
		}

		List<Map<String, Object>> list = (List<Map<String, Object>>) map.get("data");
		String del_id="";
		for(int i=0;i<list.size();i++) {
			Map param = new HashMap();
			param.put("qid", list.get(i).get("qid").toString());
			param.put("ismain", list.get(i).get("ismain").toString());
			param.put("iscon", list.get(i).get("iscon").toString());
			param.put("cid", list.get(i).get("cid").toString());
			param.put("id", list.get(i).get("qid").toString());
			del_id+=questionService.deleteQuestionReal(param).get("del_id");
		}
		if(del_id.length()>0){
			Map log = new HashMap();
			String qids = del_id.substring(0,del_id.length()-1);
			if(qids.length()>1850){
				qids = qids.substring(0,1850)+"...等";
			}
			log.put("content", "永久删除课程的所选试题，试题编号为"+qids+"，课程序号为："+map.get("cid"));
			log.put("cid", map.get("cid"));
			systemService.addSysLog(log);
		}

		return "1";
	}

	//恢复所选题目，恢复到未审核状态
	@RequestMapping("/recoverSelect")
	public @ResponseBody String recoverSelect(@RequestBody Map map) {
		if(!"administrator".equals(getUserInfo().getRole())){
			Map param = new HashMap();
			param.put("uid", getUserID());
			param.put("cid", map.get("cid"));
			param.put("permission", "question:update");
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+map.get("cid"))==0) {
				return null;
			}
		}
		List<Map<String, Object>> list = (List<Map<String, Object>>) map.get("data");
		String del_id="";
		for(int i=0;i<list.size();i++) {
			Map param = new HashMap();
			param.put("qid", list.get(i).get("qid").toString());
			param.put("ismain", list.get(i).get("ismain").toString());
			param.put("iscon", list.get(i).get("iscon").toString());
			param.put("cid", list.get(i).get("cid").toString());
			param.put("id", list.get(i).get("qid").toString());
			del_id+=questionService.recoverSelect(param).get("del_id");
			questionService.call_updateCourseQuestioncount(list.get(i).get("cid").toString());
		}
		if(del_id.length()>0){
			Map log = new HashMap();
			log.put("content", "恢复课程的所选试题，试题编号为"+del_id.substring(0,del_id.length()-1)+"，课程序号为："+map.get("cid"));
			log.put("cid", map.get("cid"));
			systemService.addSysLog(log);
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
		return "1";
	}

	/**
	 * @author li
	 * 进入工作量统计
	 * @return
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping("/inWorkLoad")
	public String inWorkLoad() {
		String cid = getPara("c_id");
		if(!cid.equals(wj_cid)){
			if(!"administrator".equals(getUserInfo().getRole())){
				Map map = new HashMap();
				map.put("uid",getUserID());
				map.put("cid", cid);
				map.put("permission", "question:view");
				if(questionService.checkQuestionPermission(map,getUserID()+"_"+cid)==0){
					return "jsp/notTheRole"; 
				}
			}
		}
		getRequest().setAttribute("c_id", cid);
		getRequest().setAttribute("cname", courseService.getCourseCNameByCid(cid));
		getRequest().setAttribute("name", courseService.getCourseCreator(cid));
		return "jsp/question/workload";
	}
	
	@RequestMapping("/getWorkLoad")
	public @ResponseBody Map<String, Object> getUsedQuestionType(){
		String cid = getPara("cid");
		if(!cid.equals(wj_cid)){
			if(!"administrator".equals(getUserInfo().getRole())){
				Map map = new HashMap();
				map.put("uid",getUserID());
				map.put("cid", cid);
				map.put("permission", "question:view");
				if(questionService.checkQuestionPermission(map,getUserID()+"_"+cid)==0){
					return null; 
				}
			}
		}
		
		Map<String, Object> rs = new HashMap<>();
		//查询课程已被使用的题型
		rs.put("questionType", questionService.getUsedQuestionTypeByCid(cid));
		rs.put("count", questionService.getAllQuestionCountBycid(cid));

		Map m = new HashMap();
		m.put("beginDate", getPara("beginDate"));
		m.put("endDate", getPara("endDate"));
		m.put("cid", cid);
		rs.putAll(questionService.getWorkLoad(m));
		return rs;

	}
	
	/**
	 * 验证是否有对应的试题权限
	 * @author 洪艳
	 * @param map，传入参数（permission[例如：question:update],uid,cid）
	 * @return 1,有 0,无
	 */
	@RequestMapping("/checkQuestionPermission")
	public @ResponseBody int checkQuestionPermission(@RequestBody Map map){
		User u = getUserInfo();
		if(u==null){
			return 0;
		}
		String cid = String.valueOf(map.get("cid"));
		if(cid.equals(wj_cid)){
			if("administrator".equals(u.getRole())||"dean".equals(u.getRole())){
				return 1;
			}else{
				if("question:view".equals(map.get("permission"))){
					return 1;
				}else{
					return 0;
				}
			}
		}
		if(!"administrator".equals(u.getRole())){
			if(cid.indexOf(",")>-1){//多课程试卷，根据qid查询cid
				String cid2 = questionService.getCidByQid((String)map.get("qid"));
				map.put("cid", cid2);
			}
			int rtn = 0;
			map.put("uid", u.getId());
			
			rtn = questionService.checkQuestionPermission(map,u.getId()+"_"+map.get("cid"));
			return rtn;
		}else{
			return 1;
		}
	}
	
	@RequestMapping("/checkQuestionVerifyPermission")
	public @ResponseBody int checkQuestionVerifyPermission(@RequestBody Map map){		
		String cid = String.valueOf(map.get("cid"));
		if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = 0;
			map.put("uid", getUserInfo().getId());
			map.put("permission", "question:verify");
			rtn = questionService.checkQuestionPermission(map,getUserID()+"_"+map.get("cid"));
			if(rtn==0) {
				map.put("permission", "question:lastVerify");
				if(questionService.checkQuestionPermission(map,getUserID()+"_"+map.get("cid"))==1) {
					return 1;
				}
			}
			return rtn;
		}else{
			return 1;
		}
	}
	
	/**
	 * 上传附件
	 * @param "FileUpload"
	 * @param "file"
	 * @return
	 * @throws IOException
	 */
	@RequestMapping("/addFile")
	public @ResponseBody String addFile(FileUpload fileVO,
										@RequestParam("fileToUpload") MultipartFile upfile) {
		String cid = fileVO.getCid();
		if (!getSubject().hasRole("administrator")) {
			Map<String, Object> param = new HashMap<>();
			param.put("uid", getUserID());
			param.put("cid", cid);
			param.put("permission", "question:update");
			if (questionService.checkQuestionPermission(param, getUserID() + "_" + cid) == 0) {
				return "error";
			}
		}
		if (upfile.isEmpty()) {
			return "error";
		}
		String fileName = upfile.getOriginalFilename();
		if (fileName == null || fileName.trim().isEmpty() || !fileName.contains(".")) {
			return "error";
		}
		String suffix = fileName.substring(fileName.lastIndexOf(".")).toLowerCase();
		String[] suffixArray = {".mp4", ".mp3", ".mov", ".flv", ".mpg", ".avi", ".jpg", ".jpeg", ".png", ".gif", ".bmp"};
		if (!Arrays.asList(suffixArray).contains(suffix)) {
			return "error";
		}

		String type = fileName.substring(fileName.lastIndexOf(".") + 1).toLowerCase();
		String nowName = new Date().getTime() + suffix;
		Path dir0 = Paths.get(WebFilePath.getRealPath(), "kaoyi_upload", cid);
		Path dir1 = Paths.get(WebFilePath.getNginxRoot(), "kaoyi_upload", cid);
		try {
			Files.createDirectories(dir0);
			Files.createDirectories(dir1);
			Path path0 = dir0.resolve(nowName);
			Files.copy(upfile.getInputStream(), path0, StandardCopyOption.REPLACE_EXISTING);
			if (!(type.equals("mp4")
					|| type.equals("ogg")
					|| type.equals("webm")
					|| type.equals("mp3")
					|| type.equals("jpg")
					|| type.equals("jpeg")
					|| type.equals("png")
					|| type.equals("gif")
					|| type.equals("bmp"))) {

				Path oldPath0 = path0;
				boolean b = ConvertVideo.process(path0.toString());
				if (b) {
					nowName = nowName.substring(0, nowName.lastIndexOf(".")) + ".mp4";
					path0 = path0.resolveSibling(
							path0.getFileName().toString().substring(0, path0.getFileName().toString().lastIndexOf(".")) + ".mp4"
					);
					Files.deleteIfExists(oldPath0);
				}
			}

			Path path1 = dir1.resolve(nowName);
			Files.copy(path0, path1, StandardCopyOption.REPLACE_EXISTING);
			return "/kaoyi_upload/" + cid + "/" + nowName;
		} catch (Exception e) {
			logger.info("试题上传附件错误，cid={}",cid, e);
			return "error";
		}
	}
	
	@RequestMapping("/getSameAtidQuestionTypeByQid")
	public @ResponseBody List<Map<String, Object>> getSameAtidQuestionTypeByQid(){
		return questionService.getSameAtidQuestionTypeByQid(getPara("qid"));
	}
	
	@RequestMapping("/copyQuestion")
	public String copyQuestion(){
		String qid=getPara("qid");
		Map param=new HashMap();
		param.put("id", qid);
		Map<String,Object> qmap=questionService.getQuestionByQID4CopyQuestion(param);
		if(!qmap.get("cid").equals(wj_cid)){
			if(!getSubject().hasRole("administrator")){
				Map map = new HashMap();
				map.put("uid",getUserID());
				map.put("cid", qmap.get("cid"));
				map.put("permission", "question:add");
				if(questionService.checkQuestionPermission(map,getUserID()+"_"+qmap.get("cid"))==0){
					return "jsp/notTheRole"; 
				}
			}
		}
		
		int iscon=Integer.parseInt(String.valueOf(qmap.get("iscon")));
		int ismain=Integer.parseInt(String.valueOf(qmap.get("ismain")));
		if(iscon==0){
			String[] answerid=(String.valueOf(qmap.get("answerid"))).split(",");
			StringBuffer sb=new StringBuffer();
			int atid=Integer.parseInt(String.valueOf(qmap.get("atid")));
			List<Map<String,Object>> answerList=(List<Map<String, Object>>) qmap.get("answerList");
			if(atid<4||atid==8||atid==9){
				for(Map<String,Object> amap:answerList){
					String aid=questionService.getAnswerID();
					String aid_y=String.valueOf(amap.get("AID"));
					for(int i=0;i<answerid.length;i++){
						if(aid_y.equals(answerid[i])){
							sb.append(aid+",");
						}
					}
					amap.put("aid", aid);
					amap.put("answer_content", amap.get("ACONTENT"));
					amap.put("answertype", amap.get("ATID"));
					amap.put("answer_content_6", amap.get("ACONTENT_6"));
					amap.put("score", amap.get("SCORE"));
				}
			}else{
				Map<String,Object> amap=answerList.get(0);
				String aid=questionService.getAnswerID();
				amap.put("aid", aid);
				amap.put("answer_content", amap.get("ACONTENT"));
				amap.put("answertype", amap.get("ATID"));
				amap.put("answer_content_6", amap.get("ACONTENT_6"));
				sb.append(aid+",");
			}
			
			String id = questionService.getQuestionID();
			param.put("id", id);
			param.put("mqid", qmap.get("mqid"));
			param.put("isMain", qmap.get("ismain"));
			param.put("iscon", qmap.get("iscon"));
			param.put("cid", qmap.get("cid"));
			param.put("qtid",qmap.get("qtid"));
			param.put("atid", qmap.get("atid"));
			param.put("aid", qmap.get("arrangeid"));
			param.put("answerid", sb.substring(0, sb.length()-1));
			param.put("sourceid",  qmap.get("sourceid"));
			param.put("cognitionid", qmap.get("cognitionid"));
			param.put("difficultyid", qmap.get("difficultyid"));
			param.put("knowledgeid", qmap.get("knowledgeid"));
			param.put("answertime", qmap.get("answertime"));
			param.put("cognitionid_b", qmap.get("cognitionid_b"));
			param.put("difficultyid_b", qmap.get("difficultyid_b"));
			param.put("knowledgeid_b", qmap.get("knowledgeid_b"));
			param.put("answertime_b", qmap.get("answertime_b"));
			param.put("theme1id", qmap.get("theme1id"));
			param.put("theme2id", qmap.get("theme2id"));
			param.put("theme3id", qmap.get("theme3id"));
			param.put("content", qmap.get("content"));
			param.put("answerexplain", qmap.get("answerexplain"));
			param.put("addtime",  new Date()); 
			param.put("creatorid", getUserID());
			param.put("creator", getUserInfo().getRealname());
			param.put("filepath", qmap.get("filepath"));
			param.put("realdifficulty", qmap.get("realdifficulty"));
			param.put("num", 0);
			param.put("distinction", qmap.get("distinction"));
			param.put("standardDeviation", qmap.get("standardDeviation"));
			param.put("answerList", answerList);
			
			questionService.insertQuestion4CopyQuestion(param);
			qid = id;
		}else if(iscon==1&&ismain==1){//复制整道串题
			String id = questionService.getQuestionID();
			param.put("id", id);
			param.put("mqid", qmap.get("mqid"));
			param.put("isMain", qmap.get("ismain"));
			param.put("iscon", qmap.get("iscon"));
			param.put("cid", qmap.get("cid"));
			param.put("qtid",qmap.get("qtid"));
			param.put("atid", qmap.get("atid"));
			param.put("aid", qmap.get("arrangeid"));
			param.put("answerid", "");
			param.put("sourceid",  qmap.get("sourceid"));
			param.put("cognitionid", qmap.get("cognitionid"));
			param.put("difficultyid", qmap.get("difficultyid"));
			param.put("knowledgeid", qmap.get("knowledgeid"));
			param.put("answertime", qmap.get("answertime"));
			param.put("cognitionid_b", qmap.get("cognitionid_b"));
			param.put("difficultyid_b", qmap.get("difficultyid_b"));
			param.put("knowledgeid_b", qmap.get("knowledgeid_b"));
			param.put("answertime_b", qmap.get("answertime_b"));
			param.put("theme1id", qmap.get("theme1id"));
			param.put("theme2id", qmap.get("theme2id"));
			param.put("theme3id", qmap.get("theme3id"));
			param.put("content", qmap.get("content"));
			param.put("answerexplain", qmap.get("answerexplain"));
			param.put("addtime",  new Date()); 
			param.put("creatorid", getUserID());
			param.put("creator", getUserInfo().getRealname());
			param.put("filepath", qmap.get("filepath"));
			param.put("realdifficulty", qmap.get("realdifficulty"));
			param.put("num", 0);
			param.put("distinction", qmap.get("distinction"));
			param.put("standardDeviation", qmap.get("standardDeviation"));
			
			questionService.insertQuestion4CopyQuestion(param);
			qid = id;
		}else if(iscon==1&&ismain==0){//复制分支
			
		}
		
		String mqid = String.valueOf(qmap.get("mqid"));
		String cid = String.valueOf(qmap.get("cid"));
		getRequest().setAttribute("courseInfo", courseService.getCourseAttr(cid).get(0));
		getRequest().setAttribute("c_id", cid);
		getRequest().setAttribute("qid", qid);
		getRequest().setAttribute("mqid", mqid);
		getRequest().setAttribute("iscon", iscon);
		getRequest().setAttribute("isMain", ismain);
		getRequest().setAttribute("eid", null);//此处eid用于区分是浏览试卷试题还是浏览课程试题
		getRequest().setAttribute("isB", null);//标识是否从B卷进入
		
		Map m = new HashMap();
		m.put("c_id",cid);
		if(iscon==1 && ismain==0){  //串题&非主题干
			m.put("id", mqid);
			getRequest().setAttribute("MainQuestion", questionService.getQuestionInfo(m));
		}
		m.put("id", qid);
		m.put("c_id", cid);
		m.put("e_id", null);
		Map<String, Object> rtnList=questionService.getQuestionInfo(m);
		getRequest().setAttribute("question", rtnList);
		getRequest().setAttribute("copy", "Y");
		return "jsp/question/editQuestion";
	}

	@RequestMapping("/checkWordFile")
	public @ResponseBody Map<String, Object> checkWordFile(@RequestParam(value="uploadQuestionFile") MultipartFile questionFile) {
		User u = getUserInfo();
		String cid = getPara("cid");
		Map param = new HashMap();
		param.put("uid", u.getId());
		param.put("cid", cid);
		param.put("permission", "question:import");
		Map map = new HashMap();
		if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = questionService.checkQuestionPermission(param,getUserID()+"_"+cid);
			if(rtn==0){
				map.put("code", 1);
				map.put("message", "您没有相关权限");
				return map;
			}
		}

		try{
			map=poiService.checkWordFile(questionFile);
			getSession().setAttribute("filepath",map.get("filepath"));
		}catch(IOException e){
			map.put("code", 1);
			map.put("message", "系统出错");
			return map;
		}

		return map;
	}

	@RequestMapping("/importWord")
	public @ResponseBody Map<String, Object> importWord() {
		User u = getUserInfo();
		String cid = getPara("cid");
		Map param = new HashMap();
		param.put("uid", u.getId());
		param.put("cid", cid);
		param.put("permission", "question:import");
			
		if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = questionService.checkQuestionPermission(param,getUserID()+"_"+cid);
			if(rtn==0){
				Map map = new HashMap();
				map.put("code", 1);
				map.put("message", "您没有相关权限");
				return map;
			}
		}
			
		String repeat = getPara("repeat");
		String filepath=(String)getSession().getAttribute("filepath");
		Map map = poiService.importWord_test(filepath, cid, repeat);
		getRequest().setAttribute("c_id", cid);

		Map log = new HashMap();
		log.put("content", "批量导入课程试题,课程代码为："+cid);
		log.put("cid", cid);
		systemService.addSysLog(log);
		getSession().removeAttribute("filepath");
		return map;
	}
}
