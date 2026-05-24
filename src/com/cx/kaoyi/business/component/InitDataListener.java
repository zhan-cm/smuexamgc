package com.cx.kaoyi.business.component;

import com.cx.kaoyi.business.service.CommonService;
import com.cx.kaoyi.business.service.QuestionService;
import com.cx.kaoyi.business.service.SystemService;
import com.cx.kaoyi.framework.GPT.generateDTO.business.QuestionGenerateThreadPool;
import com.cx.kaoyi.framework.GPT.generateDTO.business.QuestionGeneratorConfig;


import com.cx.kaoyi.framework.utils.*;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.context.ServletContextAware;

import javax.servlet.ServletContext;
import java.io.File;
import java.math.BigDecimal;
import java.util.*;

/*初始化监听器，初始化系统相关数据*/
@Component("init")
public class InitDataListener implements InitializingBean, ServletContextAware {

	
	@Autowired
	public CommonService commonService;
	
	@Autowired
	public QuestionService questionService;
	
	@Autowired
	public SystemService systemService;

	@Value("${filepath}")
	private String nginxRoot;

	@Value("${projectName}")
	private String projectName;

	@Value("${graphicsMagickPath}")
	private String graphicsMagickPath;//graphicsMagickPath路径

	@Value("${latexToSVGNodePath}")
	private String latexToSVGNodePath;//latexToSVGNodePath路径

	@Value("${openFindRepeatSystem:0}")
	private Integer openFindRepeatSystem;

	@Override
	public void setServletContext(ServletContext arg0) {
		WebFilePath.initSystemPath(arg0.getRealPath(File.separator), projectName, nginxRoot);
		arg0.setAttribute("openFindRepeatSystem", openFindRepeatSystem);
		arg0.setAttribute("arrangementList", commonService.defaultArrangement());	//默认适应层次列表
		arg0.setAttribute("questionTypeList", commonService.defaultQuestionType());	//默认题型列表
		arg0.setAttribute("examTypeList", commonService.defaultExamType());	//默认考试类型列表
		arg0.setAttribute("difficultyList", commonService.defaultDifficulty());	//默认难度列表
		arg0.setAttribute("knowledgeList", commonService.defaultKnowledge());	//默认知识点列表
		arg0.setAttribute("cognitionList", commonService.defaultCognition());	//默认认知列表
		arg0.setAttribute("sourceList", commonService.defaultSource());	//默认题源列表

		commonService.calculateQuestionBankData(false);
		commonService.initSpecialtyAndUnit();
		commonService.initGlobalPermissions();
		UserAgentUtils.parseDevice("Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36");//预热，把初始化的大头干掉
		WordReadTextWithFormulasAsHTML.setImportWordParam(graphicsMagickPath,latexToSVGNodePath);
		arg0.setAttribute("roles", commonService.getRoles());	//系统角色

		arg0.setAttribute("schoolYear", commonService.getSchoolYear());	//学年
		arg0.setAttribute("term", commonService.getTerm());	//学期
		arg0.setAttribute("examWay", commonService.getExamWay());	//开闭卷
		List<Map<String,Object>> gradeList = commonService.getGrade();
		arg0.setAttribute("grade", gradeList);//年级
		Map<String, String> gradeMap = new HashMap<>();
		for(Map<String,Object> grade : gradeList){
			gradeMap.put(String.valueOf(grade.get("ID")), String.valueOf(grade.get("NAME")));
		}
		arg0.setAttribute("gradeMap", gradeMap);//年级
		List<Map<String,Object>> systemTime = commonService.getSystemTime();
		Map<String, Object> systemTimeMap = new HashMap<>();
		for(Map<String,Object> map:systemTime){
			int time = ((BigDecimal) map.get("NAME")).intValue();
			String id = String.valueOf(map.get("ID"));
			String timeStr = DateFormatUtils.formatDuration(time);
			map.put("NAME", timeStr);
			systemTimeMap.put(id+"_val", time);
			systemTimeMap.put(id+"_name", timeStr);
		}

		arg0.setAttribute("systemTime2", systemTime);	//系统时间(时分秒)
		arg0.setAttribute("systemTimeMap", systemTimeMap);	//系统时间(时分秒)
		arg0.setAttribute("queryScore", commonService.getQueryScore());	//查询成绩方式
		arg0.setAttribute("queryPaper", commonService.getQueryPaper());	//查询答案方式
		
		arg0.setAttribute("testMode", commonService.getTestMode());		//考试方式方式
		
		arg0.setAttribute("answerSequence", commonService.getAnswerSequence());	//题型题目顺序
		arg0.setAttribute("correctPaper", commonService.getCorrectPaper());	//改卷方式
		arg0.setAttribute("forbidDay", commonService.getForbidDay());	//禁止时间
		Map<String,Map<String,Object>> systemParams = systemService.getAllSystemParam();
		arg0.setAttribute("organizationinfo", systemParams.get("organization_info"));
		arg0.setAttribute("organizationinfo_en", systemParams.get("organization_info_en"));
		arg0.setAttribute("pass_switch", systemParams.get("pass_switch").get("YL_1"));
		arg0.setAttribute("question_use_time", systemParams.get("question_use_time").get("YL_1"));
		arg0.setAttribute("question_used_day", systemParams.get("question_used_day").get("YL_1"));
		arg0.setAttribute("limit4Isreview", systemParams.get("limit4Isreview").get("YL_1"));
		arg0.setAttribute("beginexam_switch", systemParams.get("beginexam_switch").get("YL_1"));
		arg0.setAttribute("paperdate_switch", systemParams.get("paperdate_switch").get("YL_1"));
		arg0.setAttribute("seePaper", systemParams.get("seePaper").get("YL_1"));

		String aiV2Switch = initAISecrectV2(systemParams.get("AI_V2_switch"));
		arg0.setAttribute("AI_V2_switch", aiV2Switch);
		arg0.setAttribute("AI_exampaper_test_switch", "1".equals(aiV2Switch)?systemParams.get("AI_V2_switch").get("YL_3"):"0");
		arg0.setAttribute("AI_En_TTS", systemParams.get("AI_En_TTS_switch"));
	}

	@Override
	public void afterPropertiesSet() {

	}

	private String initAISecrectV2(Map<String, Object> map){
		if(!"1".equals(String.valueOf(map.get("YL_1")))){
			return "0";
		}
		String APIKeyV2;
		if(StringUtils.isNotBlank((String)map.get("YL_5"))){
			String originKey = String.valueOf(map.get("YL_5")).trim();
			try {
				originKey = AES.aesDecrypt(originKey);
				if(StringUtils.isNotBlank((String)map.get("YL_2"))){
					APIKeyV2 = AES.aesDecryptGCM(map.get("YL_2").toString(), originKey);
					QuestionGeneratorConfig.setAPIKeyV2(APIKeyV2);
					QuestionGenerateThreadPool.getInstance();
				}
			} catch (Exception e) {
				e.printStackTrace();
				return "0";
			}
		}

		return "1";
	}
}
