package com.cx.kaoyi.business.controller.paper;

import com.aspose.words.*;
import com.cx.kaoyi.business.service.PaperService;
import com.alibaba.fastjson2.JSON;
import com.cx.kaoyi.business.service.SystemService;
import com.cx.kaoyi.business.service.VerifyService;
import com.cx.kaoyi.framework.base.BaseController;
import com.cx.kaoyi.framework.base.FileDownloadUtils;
import com.cx.kaoyi.framework.handler.PaperExporter;
import com.cx.kaoyi.framework.handler.PaperProcessor;
import com.cx.kaoyi.framework.handler.PaperProcessorYn;
import com.cx.kaoyi.framework.utils.DateFormatUtils;
import com.cx.kaoyi.framework.utils.PaperContentUtils;
import com.cx.kaoyi.framework.utils.Utils;
import com.cx.kaoyi.framework.utils.WebFilePath;
import com.cx.kaoyi.framework.utils.result.GenerateWordUtils;
import org.apache.commons.io.file.PathUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.*;
import java.util.List;

@Controller
@RequestMapping("/viewPaper")
public class ViewPaperController extends BaseController{
	@Autowired
	public PaperService paperService;

	@Autowired
	public SystemService systemService;

	@Autowired
	public VerifyService verifyService;

	@RequestMapping("/seePaper")
	public String seePaper(){
		String eid = getPara("eid");
		if(!verifyService.checkViewPaperPermission(eid)){
			return "jsp/notTheRole";
		}
		getSession().setAttribute("allowViewPaper_"+eid, "Y");
		String school = (String) getApplication().getAttribute("seePaper");
		systemService.addOnlineSysLog("查看了"+eid+"的试卷");
		return "redirect:/viewPaper/seePaper_"+school+"?eid="+getPara("eid")+"&aFlag="+getPara("aFlag")
				+"&needRandomQuestionType="+getPara("needRandomQuestionType")
				+"&needRandomQuestion="+getPara("needRandomQuestion")
				+"&needRandomAnswer="+getPara("needRandomAnswer");
	}
	/**
	 * 预览试卷，适用大部分学校
	 * @return
	 */
	@RequestMapping("/seePaper_normal")
	public String seePaper_normal() {
		String allowViewPaper=String.valueOf(getSession().getAttribute("allowViewPaper_"+getPara("eid")));
		if(!"Y".equals(allowViewPaper)) {
			return "jsp/notTheRole";
		}
		String school = (String) getApplication().getAttribute("seePaper");
		if(!StringUtils.isBlank(school) && !"normal".equalsIgnoreCase(school)){
			getRequest().setAttribute("otherSchool", school);
		}
		String eid = getPara("eid");
		String a = getPara("aFlag");//是否查看答案
		if(a != null && a.equals("1")){
			getRequest().setAttribute("aFlag", 1);
		}else{
			getRequest().setAttribute("aFlag", 0);
		}
		List<Map<String, Object>> questiontype = paperService.getPaperQuestiontypeScore(eid);
		List<Map<String, Object>> list = paperService.getPaper(eid);

		boolean needRandomQuestionType = "1".equals(getPara("needRandomQuestionType"));
		boolean needRandomQuestion = "1".equals(getPara("needRandomQuestion"));
		if (needRandomQuestionType) {
			getRequest().setAttribute("needRandomQuestionType", 1);
			Collections.shuffle(questiontype);
		}
		if (needRandomQuestion) {
			getRequest().setAttribute("needRandomQuestion", 1);
			Collections.shuffle(list);
		}

		if(needRandomQuestionType || needRandomQuestion){
			Map<Object, Integer> questionTypeOrder = new HashMap<>();
			for (int i = 0; i < questiontype.size(); i++) { // 构建 questionType 排序映射
				questionTypeOrder.put(questiontype.get(i).get("QTID"), i);
			}
			list.sort((o1, o2) -> {
				Object qtype1 = o1.get("qtype");
				Object qtype2 = o2.get("qtype");
				Integer order1 = questionTypeOrder.getOrDefault(qtype1, Integer.MAX_VALUE);
				Integer order2 = questionTypeOrder.getOrDefault(qtype2, Integer.MAX_VALUE);
				return order1.equals(order2) ? 0 : order1 - order2;
			});

			int newTh = 1;
			for(Map<String,Object> ques :list){
				ques.put("th",newTh);
				if("0".equals(String.valueOf(ques.get("ismain")))){
					newTh++;
				}
			}
		}

		float score=0;
		Map<String, Map<String, Object>> questionTypeMap = new HashMap<>();
		for(Map<String, Object> qt:questiontype){
			questionTypeMap.put((String) qt.get("QTID"), qt);
			score+=Float.parseFloat(String.valueOf(qt.get("SCORE")));
		}
		String ss=String.valueOf(score);
		if(Integer.parseInt(ss.substring(ss.indexOf(".")+1))>0){
			getRequest().setAttribute("qscore", ss.substring(0,ss.indexOf(".")+2));
		}else{
			getRequest().setAttribute("qscore", ss.substring(0,ss.indexOf(".")));
		}
		List<Map<String,Object>> qnumList=paperService.getQnum_qtid(eid);
		for(Map<String,Object> qMap:qnumList){
			String qtid=String.valueOf(qMap.get("QTID"));
			for(int i=0;i<list.size();i++){
				Map<String,Object> question=list.get(i);
				if(qtid.equals(String.valueOf(question.get("qtype")))&&"0".equals(String.valueOf(question.get("ismain")))){
					qMap.put("qindex", question.get("th"));
					break;
				}
			}
			int qnum=Integer.parseInt(String.valueOf(qMap.get("QNUM")));
			int m=qnum/8;
			int n=qnum%8;
			if(n>0){
				m++;
			}
			qMap.put("row", m);
		}

		for(int i=0;i<list.size();i++) {
			Map<String,Object> res=list.get(i);
			String content=String.valueOf(res.get("content"));
			String qtid=String.valueOf(res.get("qtype"));

			int atid=Integer.parseInt(String.valueOf(res.get("atid")));
			int ismain=Integer.parseInt(String.valueOf(res.get("ismain")));
			content=PaperContentUtils.getQuestionTxt(content, qtid);

			if(ismain==0) {
				BigDecimal nowQuestionscore = (BigDecimal) res.get("score");
				Map<String,Object> questionQt = questionTypeMap.get(qtid);
				BigDecimal curMax = (BigDecimal) questionQt.get("thisQtQuestionMaxScore");
				BigDecimal curMin = (BigDecimal) questionQt.get("thisQtQuestionMinScore");

				BigDecimal newMax = (curMax == null) ? nowQuestionscore : curMax.max(nowQuestionscore);
				BigDecimal newMin = (curMin == null) ? nowQuestionscore : curMin.min(nowQuestionscore);
				questionQt.put("thisQtQuestionMaxScore", newMax);
				questionQt.put("thisQtQuestionMinScore", newMin);

				List<Map<String,Object>> answerList=(List<Map<String, Object>>) res.get("answer");
				if("1".equals(getPara("needRandomAnswer"))){
					getRequest().setAttribute("needRandomAnswer",1);
					Collections.shuffle(answerList);
				}
				boolean xx=false;
				for(int x=0;x<answerList.size();x++){
					Map<String,Object> ans=answerList.get(x);
					String acontent=String.valueOf(ans.get("acontent"));
					String letter=String.valueOf((char)((x+1)+64));
					if(!acontent.equals(letter)){
						xx=true;
						break;
					}
				}

				if(!"155_0_1".equals(qtid)&&(atid<4||atid==8||atid==9)) {
					StringBuilder answerStr=new StringBuilder();
					if(xx) {//已经选项分离
						for(int x=0;x<answerList.size();x++){
							Map<String,Object> ans=answerList.get(x);
							String acontent=String.valueOf(ans.get("acontent"));
							if("".equals(acontent)||"null".equals(acontent)) {
								acontent=String.valueOf(ans.get("acontent_6"));
							}
							answerStr.append("&nbsp;"+ (char) ((x + 1) + 64) +"."+acontent+"<br>");
						}
					}
					String contentTrimEnd = content.replaceAll("(\\s|\\u00A0)+$", "");
					int tailLen = Math.min(6, contentTrimEnd.length());
					String content_last = contentTrimEnd.substring(contentTrimEnd.length() - tailLen);
					boolean endsWithBlockBreak =
							contentTrimEnd.matches("(?is).*(</p>|<br\\s*/?>|/br>)$")
									|| "</p>".equalsIgnoreCase(content_last)
									|| "<br>".equalsIgnoreCase(content_last)
									|| "/br>".equalsIgnoreCase(content_last);
					if (endsWithBlockBreak) {
						content = content + answerStr;
					} else {
						content = content + "<br>" + answerStr;
					}
					content = content.replaceAll("(?i)(?:\\s*(?:<br\\s*/?>))*\\s*$", "");
					while (content.length() >= 4 && "<br>".equalsIgnoreCase(content.substring(content.length() - 4))) {
						content = content.substring(0, content.length() - 4);
					}
				}

				String rightAns="";
				String answerid_ck=String.valueOf(res.get("answerid"));

				if(answerList!=null&&answerList.size()>0){
					if(atid==0||atid==2||atid==8){
						for(int x=0;x<answerList.size();x++){
							Map<String,Object> ans=answerList.get(x);
							if(answerid_ck.equals(String.valueOf(ans.get("aid")))){
								rightAns=String.valueOf((char)((x+1)+64));
							}
						}
					}else if(atid==1||atid==3||atid==9){
						String ck[]=answerid_ck.split(",");
						for(int x=0;x<answerList.size();x++){
							Map<String,Object> ans=answerList.get(x);
							for(String cks:ck){
								if(cks.equals(String.valueOf(ans.get("aid")))){
									rightAns+= (char) ((x + 1) + 64) +",";
								}
							}
						}
						if(rightAns.length()>0){
							rightAns=rightAns.substring(0,rightAns.length()-1);
						}
					}else if(atid==4){
						rightAns=String.valueOf(answerList.get(0).get("acontent"));
						if("true".equals(rightAns)){
							rightAns="对";
						}else{
							rightAns="错";
						}
					}else if(atid==5||atid==6||atid==7||atid==10||atid==11){
						rightAns=String.valueOf(answerList.get(0).get("acontent_6"));
						if("null".equals(rightAns)){
							rightAns="";
						}
					}

					if(atid==5||atid==6||atid==7||atid==10||atid==11){
						if(rightAns.indexOf("<p>")==0){
							rightAns="<p>试题答案:<span style='color:red;'>"+rightAns.substring(3)+"</span>";
						}else{
							rightAns="<p>试题答案:<span style='color:red;'>"+rightAns+"</span></p>";
						}
					}else if(atid==13){
						rightAns=String.valueOf(answerList.get(0).get("acontent_6"));
						Base64.Encoder base64encoder = Base64.getEncoder();
						res.put("codeRightAns",base64encoder.encodeToString(rightAns.getBytes(StandardCharsets.UTF_8)));
					}else{
						rightAns="试题答案:<span style='color:red;'>"+rightAns+"</span>";
					}
					res.put("rightAns", rightAns);
				}
			}else {
				String begin_th="";
				String end_th="";
				String mqid=String.valueOf(res.get("qid"));
				for(int j=0;j<list.size();j++) {
					if(mqid.equals(String.valueOf(list.get(j).get("mqid")))) {
						if("".equals(begin_th)) {
							begin_th=String.valueOf(list.get(j).get("th"));
						}else {
							end_th=String.valueOf(list.get(j).get("th"));
						}
					}
				}
				if("155_0_1".equals(qtid)){
					content=begin_th+"-"+end_th+" 题共用备选项：<br>"+content;
				}else {
					content=begin_th+"-"+end_th+" 题共用题干：<br>"+content;
				}
			}

			res.put("content", content);
		}

		for (Map<String, Object> qt : questiontype) {
			BigDecimal min = (BigDecimal) qt.get("thisQtQuestionMinScore");
			BigDecimal max = (BigDecimal) qt.get("thisQtQuestionMaxScore");
			String info;
			if (min != null && max != null) {
				if (min.compareTo(max) == 0) {
					info = "每题" + min.stripTrailingZeros().toPlainString() + "分";
				} else {
					info = "每题" + min.stripTrailingZeros().toPlainString() + "-" + max.stripTrailingZeros().toPlainString() + "分";
				}
			} else {
				info = "未统计";
			}
			qt.put("qtScoreInfo", info);
		}

		Map<String, Object> examInfo = paperService.getExamInfo(eid);
		if(String.valueOf(examInfo.get("TEACHERID")).equals(getUserID())) {
			//只有南医大用的参数，组卷人
			getRequest().setAttribute("isZJR", "isZJR");
		}else{
			if(Utils.changeObjToInt(examInfo.get("STATE"))==6){
				Map map = new HashMap();
				map.put("uid", getUserID());
				map.put("eid", eid);
				map.put("permission", "paper:view");
				if(verifyService.checkPaperPermission(map)==1){
					getRequest().setAttribute("canPDF", "canPDF");
				}
			}
		}
		getRequest().setAttribute("res", list);
		getRequest().setAttribute("questiontype", questiontype);
		getRequest().setAttribute("examInfo", examInfo);
		getRequest().setAttribute("qnumList", qnumList);

		List<Map<String,Object>> examobject=paperService.getExamObject(eid);
		String sb = examobject.stream()
				.map(m -> {
					String g = (String) m.get("GNAME");
					String s = (String) m.get("SNAME");
					if (g == null || s == null) return null;
					String grade = g.endsWith("级") ? g : g.substring(0, g.length() - 1) + "级";
					return grade + s;
				})
				.filter(java.util.Objects::nonNull)
				.distinct()
				.collect(java.util.stream.Collectors.joining("，"));

		if (sb.length() > 100) sb = sb.substring(0, 100) + "等";
		getRequest().setAttribute("examObject", sb);

		String beginDate=String.valueOf(examInfo.get("BEGINDATE"));
		String endDate=String.valueOf(examInfo.get("ENDDATE"));
		String[] bd=beginDate.split(" ");
		String[] ed=endDate.split(" ");
		if(bd[0].equals(ed[0])){
			getRequest().setAttribute("examdate", bd[0]);
		}else{
			getRequest().setAttribute("examdate", bd[0]+"-"+ed[0]);
		}
		getRequest().setAttribute("examtime", bd[1].substring(0,5)+"-"+ed[1].substring(0,5));

		int time=Integer.parseInt(String.valueOf(examInfo.get("EXAMTIME")));
		String rs=DateFormatUtils.formatDuration(time);
		getRequest().setAttribute("etime", rs);
		getRequest().setAttribute("remark2s", examInfo.get("REMARK2S"));

		return "jsp/paper/seePaper";
	}

	/**
	 * 预览试卷
	 * @return
	 */
	@RequestMapping("/seePaper_haijun")
	public String seePaper_haijun() {
		String allowViewPaper=String.valueOf(getSession().getAttribute("allowViewPaper_"+getPara("eid")));
		if(!"Y".equals(allowViewPaper)) {
			return "jsp/notTheRole";
		}
		String school = (String) getApplication().getAttribute("seePaper");
		if(!StringUtils.isBlank(school) && !"normal".equalsIgnoreCase(school)){
			getRequest().setAttribute("otherSchool", school);
		}
		String eid = getPara("eid");
		String a = getPara("aFlag");//是否查看答案
		if(a != null && a.equals("1")){
			getRequest().setAttribute("aFlag", 1);
		}else{
			getRequest().setAttribute("aFlag", 0);
		}
		List<Map<String, Object>> questiontype = paperService.getPaperQuestiontypeScore(eid);
		List<Map<String, Object>> list = paperService.getPaper(eid);

		boolean needRandomQuestionType = "1".equals(getPara("needRandomQuestionType"));
		boolean needRandomQuestion = "1".equals(getPara("needRandomQuestion"));
		if (needRandomQuestionType) {
			getRequest().setAttribute("needRandomQuestionType", 1);
			Collections.shuffle(questiontype);
		}
		if (needRandomQuestion) {
			getRequest().setAttribute("needRandomQuestion", 1);
			Collections.shuffle(list);
		}

		if(needRandomQuestionType || needRandomQuestion){
			Map<Object, Integer> questionTypeOrder = new HashMap<>();
			for (int i = 0; i < questiontype.size(); i++) { // 构建 questionType 排序映射
				questionTypeOrder.put(questiontype.get(i).get("QTID"), i);
			}
			list.sort((o1, o2) -> {
				Object qtype1 = o1.get("qtype");
				Object qtype2 = o2.get("qtype");
				Integer order1 = questionTypeOrder.getOrDefault(qtype1, Integer.MAX_VALUE);
				Integer order2 = questionTypeOrder.getOrDefault(qtype2, Integer.MAX_VALUE);
				return order1.equals(order2) ? 0 : order1 - order2;
			});

			int newTh = 1;
			for(Map<String,Object> ques :list){
				ques.put("th",newTh);
				if("0".equals(String.valueOf(ques.get("ismain")))){
					newTh++;
				}
			}
		}

		float score=0;
		Map<String, Map<String, Object>> questionTypeMap = new HashMap<>();
		for(Map<String, Object> qt:questiontype){
			questionTypeMap.put((String) qt.get("QTID"), qt);
			score+=Float.parseFloat(String.valueOf(qt.get("SCORE")));
		}
		String ss=String.valueOf(score);
		if(Integer.parseInt(ss.substring(ss.indexOf(".")+1))>0){
			getRequest().setAttribute("qscore", ss.substring(0,ss.indexOf(".")+2));
		}else{
			getRequest().setAttribute("qscore", ss.substring(0,ss.indexOf(".")));
		}
		List<Map<String,Object>> qnumList=paperService.getQnum_qtid(eid);
		for(Map<String,Object> qMap:qnumList){
			String qtid=String.valueOf(qMap.get("QTID"));
			for(int i=0;i<list.size();i++){
				Map<String,Object> question=list.get(i);
				if(qtid.equals(String.valueOf(question.get("qtype")))&&"0".equals(String.valueOf(question.get("ismain")))){
					qMap.put("qindex", question.get("th"));
					break;
				}
			}
			int qnum=Integer.parseInt(String.valueOf(qMap.get("QNUM")));
			int m=qnum/8;
			int n=qnum%8;
			if(n>0){
				m++;
			}
			qMap.put("row", m);
		}

		for(int i=0;i<list.size();i++) {
			Map<String,Object> res=list.get(i);
			String content=String.valueOf(res.get("content"));
			String qtid=String.valueOf(res.get("qtype"));

			int atid=Integer.parseInt(String.valueOf(res.get("atid")));
			int ismain=Integer.parseInt(String.valueOf(res.get("ismain")));
			content=PaperContentUtils.getQuestionTxt(content, qtid);

			if(ismain==0) {
				BigDecimal nowQuestionscore = (BigDecimal) res.get("score");
				Map<String,Object> questionQt = questionTypeMap.get(qtid);
				BigDecimal curMax = (BigDecimal) questionQt.get("thisQtQuestionMaxScore");
				BigDecimal curMin = (BigDecimal) questionQt.get("thisQtQuestionMinScore");

				BigDecimal newMax = (curMax == null) ? nowQuestionscore : curMax.max(nowQuestionscore);
				BigDecimal newMin = (curMin == null) ? nowQuestionscore : curMin.min(nowQuestionscore);
				questionQt.put("thisQtQuestionMaxScore", newMax);
				questionQt.put("thisQtQuestionMinScore", newMin);

				List<Map<String,Object>> answerList=(List<Map<String, Object>>) res.get("answer");
				if("1".equals(getPara("needRandomAnswer"))){
					getRequest().setAttribute("needRandomAnswer",1);
					Collections.shuffle(answerList);
				}
				boolean xx=false;
				for(int x=0;x<answerList.size();x++){
					Map<String,Object> ans=answerList.get(x);
					String acontent=String.valueOf(ans.get("acontent"));
					String letter=String.valueOf((char)((x+1)+64));
					if(!acontent.equals(letter)){
						xx=true;
						break;
					}
				}

				if(!"155_0_1".equals(qtid)&&(atid<4||atid==8||atid==9)) {
					StringBuilder answerStr=new StringBuilder();
					if(xx) {//已经选项分离
						for(int x=0;x<answerList.size();x++){
							Map<String,Object> ans=answerList.get(x);
							String acontent=String.valueOf(ans.get("acontent"));
							if("".equals(acontent)||"null".equals(acontent)) {
								acontent=String.valueOf(ans.get("acontent_6"));
							}
							answerStr.append("&nbsp;"+ (char) ((x + 1) + 64) +"."+acontent+"<br>");
						}
					}
					String contentTrimEnd = content.replaceAll("(\\s|\\u00A0)+$", "");
					int tailLen = Math.min(6, contentTrimEnd.length());
					String content_last = contentTrimEnd.substring(contentTrimEnd.length() - tailLen);
					boolean endsWithBlockBreak =
							contentTrimEnd.matches("(?is).*(</p>|<br\\s*/?>|/br>)$")
									|| "</p>".equalsIgnoreCase(content_last)
									|| "<br>".equalsIgnoreCase(content_last)
									|| "/br>".equalsIgnoreCase(content_last);
					if (endsWithBlockBreak) {
						content = content + answerStr;
					} else {
						content = content + "<br>" + answerStr;
					}
					content = content.replaceAll("(?i)(?:\\s*(?:<br\\s*/?>))*\\s*$", "");
					while (content.length() >= 4 && "<br>".equalsIgnoreCase(content.substring(content.length() - 4))) {
						content = content.substring(0, content.length() - 4);
					}
				}

				String rightAns="";
				String answerid_ck=String.valueOf(res.get("answerid"));

				if(answerList!=null&&answerList.size()>0){
					if(atid==0||atid==2||atid==8){
						for(int x=0;x<answerList.size();x++){
							Map<String,Object> ans=answerList.get(x);
							if(answerid_ck.equals(String.valueOf(ans.get("aid")))){
								rightAns=String.valueOf((char)((x+1)+64));
							}
						}
					}else if(atid==1||atid==3||atid==9){
						String ck[]=answerid_ck.split(",");
						for(int x=0;x<answerList.size();x++){
							Map<String,Object> ans=answerList.get(x);
							for(String cks:ck){
								if(cks.equals(String.valueOf(ans.get("aid")))){
									rightAns+= (char) ((x + 1) + 64) +",";
								}
							}
						}
						if(rightAns.length()>0){
							rightAns=rightAns.substring(0,rightAns.length()-1);
						}
					}else if(atid==4){
						rightAns=String.valueOf(answerList.get(0).get("acontent"));
						if("true".equals(rightAns)){
							rightAns="对";
						}else{
							rightAns="错";
						}
					}else if(atid==5||atid==6||atid==7||atid==10||atid==11){
						rightAns=String.valueOf(answerList.get(0).get("acontent_6"));
						if("null".equals(rightAns)){
							rightAns="";
						}
					}

					if(atid==5||atid==6||atid==7||atid==10||atid==11){
						if(rightAns.indexOf("<p>")==0){
							rightAns="<p>试题答案:<span style='color:red;'>"+rightAns.substring(3)+"</span>";
						}else{
							rightAns="<p>试题答案:<span style='color:red;'>"+rightAns+"</span></p>";
						}
					}else if(atid==13){
						rightAns=String.valueOf(answerList.get(0).get("acontent_6"));
						Base64.Encoder base64encoder = Base64.getEncoder();
						res.put("codeRightAns",base64encoder.encodeToString(rightAns.getBytes(StandardCharsets.UTF_8)));
					}else{
						rightAns="试题答案:<span style='color:red;'>"+rightAns+"</span>";
					}
					res.put("rightAns", rightAns);
				}
			}else {
				String begin_th="";
				String end_th="";
				String mqid=String.valueOf(res.get("qid"));
				for(int j=0;j<list.size();j++) {
					if(mqid.equals(String.valueOf(list.get(j).get("mqid")))) {
						if("".equals(begin_th)) {
							begin_th=String.valueOf(list.get(j).get("th"));
						}else {
							end_th=String.valueOf(list.get(j).get("th"));
						}
					}
				}
				if("155_0_1".equals(qtid)){
					content=begin_th+"-"+end_th+" 题共用备选项：<br>"+content;
				}else {
					content=begin_th+"-"+end_th+" 题共用题干：<br>"+content;
				}
			}

			res.put("content", content);
		}

		for (Map<String, Object> qt : questiontype) {
			BigDecimal min = (BigDecimal) qt.get("thisQtQuestionMinScore");
			BigDecimal max = (BigDecimal) qt.get("thisQtQuestionMaxScore");
			String info;
			if (min != null && max != null) {
				if (min.compareTo(max) == 0) {
					info = "每题" + min.stripTrailingZeros().toPlainString() + "分";
				} else {
					info = "每题" + min.stripTrailingZeros().toPlainString() + "-" + max.stripTrailingZeros().toPlainString() + "分";
				}
			} else {
				info = "未统计";
			}
			qt.put("qtScoreInfo", info);
		}

		Map<String, Object> examInfo = paperService.getExamInfo(eid);
		if(Utils.changeObjToInt(examInfo.get("STATE"))==6){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("eid", eid);
			map.put("permission", "paper:view");
			if(verifyService.checkPaperPermission(map)==1){
				getRequest().setAttribute("canPDF", "canPDF");
			}
		}
		getRequest().setAttribute("res", list);
		getRequest().setAttribute("questiontype", questiontype);
		getRequest().setAttribute("examInfo", examInfo);
		getRequest().setAttribute("qnumList", qnumList);

		List<Map<String,Object>> examobject=paperService.getExamObject(eid);
		if(examobject!=null&&examobject.size()>0){
			Set<String> grade= new HashSet<>();
			Set<String> specialty= new HashSet<>();
			for(Map<String,Object> m:examobject){
				grade.add((String)m.get("GNAME"));
				specialty.add((String)m.get("SNAME"));
			}
			StringBuilder sb = new StringBuilder();
			String examObject=null;
			out:for(String sp:specialty){
				for(String g:grade){
					if(sb.length() + g.length()>100){
						examObject = sb.substring(0,sb.length()-1)+"等";
						break out;
					}
					if(g.charAt(g.length()-1)=='级'){
						sb.append(sp+g+"、");
					}else{
						sb.append(sp+g+"级、");
					}
				}
			}

			examObject = examObject==null?sb.substring(0,sb.length()-1):examObject;
			getRequest().setAttribute("examObject", examObject);
		}

		String beginDate=String.valueOf(examInfo.get("BEGINDATE"));
		String endDate=String.valueOf(examInfo.get("ENDDATE"));
		String[] bd=beginDate.split(" ");
		String[] ed=endDate.split(" ");
		if(bd[0].split("-").length==3){
			String[] tmp = bd[0].split("-");
			bd[0] = tmp[0]+"年"+tmp[1]+"月"+tmp[2]+"日";
		}
		if(ed[0].split("-").length==3){
			String[] tmp = ed[0].split("-");
			ed[0] = tmp[0]+"年"+tmp[1]+"月"+tmp[2]+"日";
		}
		if(bd[0].equals(ed[0])){
			getRequest().setAttribute("examdate", bd[0]);
		}else{
			getRequest().setAttribute("examdate", bd[0]+"-"+ed[0]);
		}
		getRequest().setAttribute("examtime", bd[1].substring(0,5)+"-"+ed[1].substring(0,5));

		int time=Integer.parseInt(String.valueOf(examInfo.get("EXAMTIME")));
		String rs=DateFormatUtils.formatDuration(time);
		getRequest().setAttribute("etime", rs);
		getRequest().setAttribute("remark2s", examInfo.get("REMARK2S"));
		getRequest().setAttribute("resJson", JSON.toJSONString(list));
		getRequest().setAttribute("questiontypeJson", JSON.toJSONString(questiontype));
		getRequest().setAttribute("examInfoJson", JSON.toJSONString(examInfo));

		return "jsp/paper/seePaper-haijun";
	}

	@RequestMapping("/seePaper_chongqing")
	public String seePaper_chongqing() {
		String eid = getPara("eid");
		String allowViewPaper=String.valueOf(getSession().getAttribute("allowViewPaper_"+eid));
		if(!"Y".equals(allowViewPaper)) {
			return "jsp/notTheRole";
		}
		getRequest().setAttribute("eid", eid);
		Map<String, Object> examInfo = paperService.getExamInfo(eid);
		getRequest().setAttribute("ename", examInfo.get("ENAME"));
		getRequest().setAttribute("cid", examInfo.get("CID"));
		return "jsp/paper/seePaper-chongqing";
	}

	@RequestMapping("/getDocxInfo")
	public void getDocxInfo(HttpServletResponse response) {
		String eid = getPara("eid");
		String allowViewPaper=String.valueOf(getSession().getAttribute("allowViewPaper_"+eid));
		if(!"Y".equals(allowViewPaper)) {
			return;
		}

		boolean showAns = false;
		if(StringUtils.isNotBlank(getPara("showAns"))){ //是否查看答案
			showAns = true;
		}
		boolean isPreview = false;
		if("yes".equals(getPara("isPreview"))){
			isPreview = true;
		}
		List<Map<String, Object>> questiontype = paperService.getPaperQuestiontypeScore(eid);
		List<Map<String, Object>> list = paperService.getPaper(eid);

		boolean needRandomQuestionType = "1".equals(getPara("needRandomQuestionType"));
		boolean needRandomQuestion = "1".equals(getPara("needRandomQuestion"));
		if (needRandomQuestionType) {
			Collections.shuffle(questiontype);
		}
		if (needRandomQuestion) {
			Collections.shuffle(list);
		}

		if(needRandomQuestionType || needRandomQuestion){
			Map<Object, Integer> questionTypeOrder = new HashMap<>();
			for (int i = 0; i < questiontype.size(); i++) { // 构建 questionType 排序映射
				questionTypeOrder.put(questiontype.get(i).get("QTID"), i);
			}
			list.sort((o1, o2) -> {
				Object qtype1 = o1.get("qtype");
				Object qtype2 = o2.get("qtype");
				Integer order1 = questionTypeOrder.getOrDefault(qtype1, Integer.MAX_VALUE);
				Integer order2 = questionTypeOrder.getOrDefault(qtype2, Integer.MAX_VALUE);
				return order1.equals(order2) ? 0 : order1 - order2;
			});

			int newTh = 1;
			for(Map<String,Object> ques :list){
				ques.put("th",newTh);
				if("0".equals(String.valueOf(ques.get("ismain")))){
					newTh++;
				}
			}
		}

		List<Map<String,Object>> qnumList=paperService.getQnum_qtid(eid);
		for(Map<String,Object> qMap:qnumList){
			String qtid=String.valueOf(qMap.get("QTID"));
			for(int i=0;i<list.size();i++){
				Map<String,Object> question=list.get(i);
				if(qtid.equals(String.valueOf(question.get("qtype")))&&"0".equals(String.valueOf(question.get("ismain")))){
					qMap.put("qindex", question.get("th"));
					break;
				}
			}
			int qnum=Integer.parseInt(String.valueOf(qMap.get("QNUM")));
			int m=qnum/8;
			int n=qnum%8;
			if(n>0){
				m++;
			}
			qMap.put("row", m);
		}

		for(int i=0;i<list.size();i++) {
			Map<String,Object> res=list.get(i);
			String content=String.valueOf(res.get("content"));
			String qtid=String.valueOf(res.get("qtype"));
			int atid=Integer.parseInt(String.valueOf(res.get("atid")));
			int ismain=Integer.parseInt(String.valueOf(res.get("ismain")));
			content=PaperContentUtils.getQuestionTxt(content, qtid);

			if(ismain==0) {
				content+="（"+ res.get("score") +"分）";
				List<Map<String,Object>> answerList=(List<Map<String, Object>>) res.get("answer");
				if("1".equals(getPara("needRandomAnswer"))){
					Collections.shuffle(answerList);
				}
				boolean xx=false;
				for(int x=0;x<answerList.size();x++){
					Map<String,Object> ans=answerList.get(x);
					String acontent=String.valueOf(ans.get("acontent"));
					String letter=String.valueOf((char)((x+1)+64));
					if(!acontent.equals(letter)){
						xx=true;
						break;
					}
				}

				if(!"155_0_1".equals(qtid)&&(atid<4||atid==8||atid==9)) {
					StringBuilder answerStr=new StringBuilder();
					if(xx) {//已经选项分离
						for(int x=0;x<answerList.size();x++){
							Map<String,Object> ans=answerList.get(x);
							String acontent=String.valueOf(ans.get("acontent"));
							if("".equals(acontent)||"null".equals(acontent)) {
								acontent=String.valueOf(ans.get("acontent_6"));
							}
							answerStr.append("&nbsp;"+ (char) ((x + 1) + 64) +"."+acontent+"<br>");
						}
					}
					String contentTrimEnd = content.replaceAll("(\\s|\\u00A0)+$", "");
					int tailLen = Math.min(6, contentTrimEnd.length());
					String content_last = contentTrimEnd.substring(contentTrimEnd.length() - tailLen);
					boolean endsWithBlockBreak =
							contentTrimEnd.matches("(?is).*(</p>|<br\\s*/?>|/br>)$")
									|| "</p>".equalsIgnoreCase(content_last)
									|| "<br>".equalsIgnoreCase(content_last)
									|| "/br>".equalsIgnoreCase(content_last);
					if (endsWithBlockBreak) {
						content = content + answerStr;
					} else {
						content = content + "<br>" + answerStr;
					}
					content = content.replaceAll("(?i)(?:\\s*(?:<br\\s*/?>))*\\s*$", "");
					while (content.length() >= 4 && "<br>".equalsIgnoreCase(content.substring(content.length() - 4))) {
						content = content.substring(0, content.length() - 4);
					}

				}

				String rightAns="";
				String answerid_ck=String.valueOf(res.get("answerid"));

				if(answerList!=null&&answerList.size()>0){
					if(atid==0||atid==2||atid==8){
						for(int x=0;x<answerList.size();x++){
							Map<String,Object> ans=answerList.get(x);
							if(answerid_ck.equals(String.valueOf(ans.get("aid")))){
								rightAns=String.valueOf((char)((x+1)+64));
							}
						}
					}else if(atid==1||atid==3||atid==9){
						String ck[]=answerid_ck.split(",");
						for(int x=0;x<answerList.size();x++){
							Map<String,Object> ans=answerList.get(x);
							for(String cks:ck){
								if(cks.equals(String.valueOf(ans.get("aid")))){
									rightAns+= (char) ((x + 1) + 64) +",";
								}
							}
						}
						if(rightAns.length()>0){
							rightAns=rightAns.substring(0,rightAns.length()-1);
						}
					}else if(atid==4){
						rightAns=String.valueOf(answerList.get(0).get("acontent"));
						if("true".equals(rightAns)){
							rightAns="对";
						}else{
							rightAns="错";
						}
					}else if(atid==5||atid==6||atid==7||atid==10||atid==11){
						rightAns=String.valueOf(answerList.get(0).get("acontent_6"));
						if("null".equals(rightAns)){
							rightAns="";
						}
					}

					if(atid==5||atid==6||atid==7||atid==10||atid==11){
						if(rightAns.indexOf("<p>")==0){
							rightAns="<p>试题答案:<span style='color:red;'>"+rightAns.substring(3)+"</span>";
						}else{
							rightAns="<p>试题答案:<span style='color:red;'>"+rightAns+"</span></p>";
						}
					}else if(atid==13){
						rightAns=String.valueOf(answerList.get(0).get("acontent_6"));
						Base64.Encoder base64encoder = Base64.getEncoder();
						res.put("codeRightAns",base64encoder.encodeToString(rightAns.getBytes(StandardCharsets.UTF_8)));
					}else{
						rightAns="试题答案:<span style='color:red;'>"+rightAns+"</span>";
					}
					res.put("rightAns", rightAns);
				}
			}else {
				String begin_th="";
				String end_th="";
				String mqid=String.valueOf(res.get("qid"));
				for(int j=0;j<list.size();j++) {
					if(mqid.equals(String.valueOf(list.get(j).get("mqid")))) {
						if("".equals(begin_th)) {
							begin_th=String.valueOf(list.get(j).get("th"));
						}else {
							end_th=String.valueOf(list.get(j).get("th"));
						}
					}
				}
				if("155_0_1".equals(qtid)){
					content=begin_th+"-"+end_th+" 题共用备选项：<br>"+content;
				}else {
					content=begin_th+"-"+end_th+" 题共用题干：<br>"+content;
				}
			}

			res.put("content", content);
		}

		Map<String, Object> examInfo = paperService.getExamInfo(eid);
		List<Map<String,Object>> examobject=paperService.getExamObject(eid);
		StringBuilder sb = new StringBuilder();
		for(Map<String,Object> eo:examobject){
			sb.append(String.valueOf(eo.get("GNAME")) + eo.get("SNAME")+",");
		}
		if(sb.length()>0){
			sb.setLength(sb.length()-1);
		}
		examInfo.put("examObject", sb.toString());

		String schoolYear = String.valueOf(examInfo.get("SCHOOLYEAR"));
		List<Map<String,Object>> yearList = (List<Map<String,Object>>) getApplication().getAttribute("schoolYear");
		for (Map<String,Object> year : yearList){
			if(schoolYear.equals(year.get("ID").toString())){
				examInfo.put("schoolYear", year.get("NAME"));
				break;
			}
		}

		int time=Integer.parseInt(String.valueOf(examInfo.get("EXAMTIME")));
		String rs=DateFormatUtils.formatDuration(time);
		examInfo.put("etime",rs);
		try {
			String tmpDocxPath = WebFilePath.getRealPath() +"tmpDocx/"+eid+"/"+new Date().getTime();
			PaperExporter paperExporter = new PaperExporter("chongqing");
			paperExporter.createPaperTmpDir(tmpDocxPath);
			Map<String, Object> rtn = new PaperProcessor(tmpDocxPath, isPreview).processPaper(questiontype, list, examInfo, showAns);
			paperExporter.exportPaper(rtn, tmpDocxPath);
			PathUtils.delete(Paths.get(tmpDocxPath));
			File file = new File(tmpDocxPath+".docx");
			if(!file.exists()){
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "文件未找到");
				return;
			}
			response.setContentType("application/vnd.openxmlformats-officedocument.wordprocessingml.document");
			response.setHeader("Content-Length", String.valueOf(file.length()));
			try (InputStream is = new FileInputStream(file);
				 OutputStream os = response.getOutputStream()) {
				byte[] buffer = new byte[4096];
				int bytesRead;
				while ((bytesRead = is.read(buffer)) != -1) {
					os.write(buffer, 0, bytesRead);
				}
			}
			getSession().setAttribute(eid+"_tmpDocx", file.getAbsolutePath());
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			try {
				response.getWriter().write("文件生成失败: " + e.getMessage());
			} catch (IOException ex) {
				ex.printStackTrace();
			}
			e.printStackTrace();
		}
	}

	@RequestMapping("/seePaper_yunnancj")
	public String seePaper_yunnancj() {
		String eid = getPara("eid");
		String allowViewPaper=String.valueOf(getSession().getAttribute("allowViewPaper_"+eid));
		if(!"Y".equals(allowViewPaper)) {
			return "jsp/notTheRole";
		}
		getRequest().setAttribute("eid", eid);
		Map<String, Object> examInfo = paperService.getExamInfo(eid);
		getRequest().setAttribute("ename", examInfo.get("ENAME"));
		getRequest().setAttribute("cid", examInfo.get("CID"));
		return "jsp/paper/seePaper-yunnancj";
	}

	@RequestMapping("/getDocxInfo_yunnancj")
	public void getDocxInfo_yunnancj(HttpServletResponse response) {
		String eid = getPara("eid");
		String allowViewPaper=String.valueOf(getSession().getAttribute("allowViewPaper_"+eid));
		if(!"Y".equals(allowViewPaper)) {
			return;
		}

		boolean showAns = false;
		if(StringUtils.isNotBlank(getPara("showAns"))){ //是否查看答案
			showAns = true;
		}
		List<Map<String, Object>> questiontype = paperService.getPaperQuestiontypeScore(eid);
		List<Map<String, Object>> list = paperService.getPaper(eid);

		boolean needRandomQuestionType = "1".equals(getPara("needRandomQuestionType"));
		boolean needRandomQuestion = "1".equals(getPara("needRandomQuestion"));
		if (needRandomQuestionType) {
			Collections.shuffle(questiontype);
		}
		if (needRandomQuestion) {
			Collections.shuffle(list);
		}

		if(needRandomQuestionType || needRandomQuestion){
			Map<Object, Integer> questionTypeOrder = new HashMap<>();
			for (int i = 0; i < questiontype.size(); i++) { // 构建 questionType 排序映射
				questionTypeOrder.put(questiontype.get(i).get("QTID"), i);
			}
			list.sort((o1, o2) -> {
				Object qtype1 = o1.get("qtype");
				Object qtype2 = o2.get("qtype");
				Integer order1 = questionTypeOrder.getOrDefault(qtype1, Integer.MAX_VALUE);
				Integer order2 = questionTypeOrder.getOrDefault(qtype2, Integer.MAX_VALUE);
				return order1.equals(order2) ? 0 : order1 - order2;
			});

			int newTh = 1;
			for(Map<String,Object> ques :list){
				ques.put("th",newTh);
				if("0".equals(String.valueOf(ques.get("ismain")))){
					newTh++;
				}
			}
		}

		List<Map<String,Object>> qnumList=paperService.getQnum_qtid(eid);
		for(Map<String,Object> qMap:qnumList){
			String qtid=String.valueOf(qMap.get("QTID"));
			for(int i=0;i<list.size();i++){
				Map<String,Object> question=list.get(i);
				if(qtid.equals(String.valueOf(question.get("qtype")))&&"0".equals(String.valueOf(question.get("ismain")))){
					qMap.put("qindex", question.get("th"));
					break;
				}
			}
			int qnum=Integer.parseInt(String.valueOf(qMap.get("QNUM")));
			int m=qnum/8;
			int n=qnum%8;
			if(n>0){
				m++;
			}
			qMap.put("row", m);
		}

		for(int i=0;i<list.size();i++) {
			Map<String,Object> res=list.get(i);
			String content=String.valueOf(res.get("content"));
			String qtid=String.valueOf(res.get("qtype"));
			int atid=Integer.parseInt(String.valueOf(res.get("atid")));
			int ismain=Integer.parseInt(String.valueOf(res.get("ismain")));
			content=PaperContentUtils.getQuestionTxt(content, qtid);

			if(ismain==0) {
				List<Map<String,Object>> answerList=(List<Map<String, Object>>) res.get("answer");
				if("1".equals(getPara("needRandomAnswer"))){
					Collections.shuffle(answerList);
				}
				boolean xx=false;
				for(int x=0;x<answerList.size();x++){
					Map<String,Object> ans=answerList.get(x);
					String acontent=String.valueOf(ans.get("acontent"));
					String letter=String.valueOf((char)((x+1)+64));
					if(!acontent.equals(letter)){
						xx=true;
						break;
					}
				}

				if(!"155_0_1".equals(qtid)&&(atid<4||atid==8||atid==9)) {
					StringBuilder answerStr=new StringBuilder();
					if(xx) {//已经选项分离
						for(int x=0;x<answerList.size();x++){
							Map<String,Object> ans=answerList.get(x);
							String acontent=String.valueOf(ans.get("acontent"));
							if("".equals(acontent)||"null".equals(acontent)) {
								acontent=String.valueOf(ans.get("acontent_6"));
							}
							answerStr.append("&nbsp;"+ (char) ((x + 1) + 64) +"."+acontent+"<br>");
						}
					}
					String contentTrimEnd = content.replaceAll("(\\s|\\u00A0)+$", "");
					int tailLen = Math.min(6, contentTrimEnd.length());
					String content_last = contentTrimEnd.substring(contentTrimEnd.length() - tailLen);
					boolean endsWithBlockBreak =
							contentTrimEnd.matches("(?is).*(</p>|<br\\s*/?>|/br>)$")
									|| "</p>".equalsIgnoreCase(content_last)
									|| "<br>".equalsIgnoreCase(content_last)
									|| "/br>".equalsIgnoreCase(content_last);
					if (endsWithBlockBreak) {
						content = content + answerStr;
					} else {
						content = content + "<br>" + answerStr;
					}
					content = content.replaceAll("(?i)(?:\\s*(?:<br\\s*/?>))*\\s*$", "");
					while (content.length() >= 4 && "<br>".equalsIgnoreCase(content.substring(content.length() - 4))) {
						content = content.substring(0, content.length() - 4);
					}

				}

				String rightAns="";
				String answerid_ck=String.valueOf(res.get("answerid"));

				if(answerList!=null&&answerList.size()>0){
					if(atid==0||atid==2||atid==8){
						for(int x=0;x<answerList.size();x++){
							Map<String,Object> ans=answerList.get(x);
							if(answerid_ck.equals(String.valueOf(ans.get("aid")))){
								rightAns=String.valueOf((char)((x+1)+64));
							}
						}
					}else if(atid==1||atid==3||atid==9){
						String ck[]=answerid_ck.split(",");
						for(int x=0;x<answerList.size();x++){
							Map<String,Object> ans=answerList.get(x);
							for(String cks:ck){
								if(cks.equals(String.valueOf(ans.get("aid")))){
									rightAns+= (char) ((x + 1) + 64) +",";
								}
							}
						}
						if(rightAns.length()>0){
							rightAns=rightAns.substring(0,rightAns.length()-1);
						}
					}else if(atid==4){
						rightAns=String.valueOf(answerList.get(0).get("acontent"));
						if("true".equals(rightAns)){
							rightAns="对";
						}else{
							rightAns="错";
						}
					}else if(atid==5||atid==6||atid==7||atid==10||atid==11){
						rightAns=String.valueOf(answerList.get(0).get("acontent_6"));
						if("null".equals(rightAns)){
							rightAns="";
						}
					}

					if(atid==5||atid==6||atid==7||atid==10||atid==11){
						if(rightAns.indexOf("<p>")==0){
							rightAns="<p>试题答案:<span style='color:red;'>"+rightAns.substring(3)+"</span>";
						}else{
							rightAns="<p>试题答案:<span style='color:red;'>"+rightAns+"</span></p>";
						}
					}else{
						rightAns="试题答案:<span style='color:red;'>"+rightAns+"</span>";
					}
					res.put("rightAns", rightAns);
				}
			}else {
				String begin_th="";
				String end_th="";
				String mqid=String.valueOf(res.get("qid"));
				for(int j=0;j<list.size();j++) {
					if(mqid.equals(String.valueOf(list.get(j).get("mqid")))) {
						if("".equals(begin_th)) {
							begin_th=String.valueOf(list.get(j).get("th"));
						}else {
							end_th=String.valueOf(list.get(j).get("th"));
						}
					}
				}
				if("155_0_1".equals(qtid)){
					content=begin_th+"-"+end_th+" 题共用备选项：<br>"+content;
				}else {
					content=begin_th+"-"+end_th+" 题共用题干：<br>"+content;
				}
			}

			res.put("content", content);
		}

		Map<String, Object> examInfo = paperService.getExamInfo(eid);

		String schoolYear = String.valueOf(examInfo.get("SCHOOLYEAR"));
		List<Map<String,Object>> yearList = (List<Map<String,Object>>) getApplication().getAttribute("schoolYear");
		for (Map<String,Object> year : yearList){
			if(schoolYear.equals(year.get("ID").toString())){
				String yearName = (String) year.get("NAME");
				if(yearName!=null && yearName.contains("-") && yearName.endsWith("学年")){
					yearName = yearName.replace("学年","");
					String[] years = yearName.split("-");
					examInfo.put("schoolYear1", years[0]);
					examInfo.put("schoolYear2", years[1]);
				}
				break;
			}
		}
		String termname = (String) examInfo.get("TERMNAME");
		if(termname.endsWith("学期")){
			termname = termname.replace("学期","");
			examInfo.put("TERMNAME1", termname);
		}

		int time=Integer.parseInt(String.valueOf(examInfo.get("EXAMTIME")));
		String rs=DateFormatUtils.formatDuration(time);
		examInfo.put("etime",rs);
		try {
			String tmpDocxPath = WebFilePath.getRealPath() +"tmpDocx/"+eid+"/"+System.currentTimeMillis();
			PaperExporter paperExporter = new PaperExporter("yunnan");
			paperExporter.createPaperTmpDir(tmpDocxPath);
			Map<String, Object> rtn = new PaperProcessorYn(tmpDocxPath, false).processPaper(questiontype, list, examInfo, showAns);
			paperExporter.exportPaperPdf(rtn, tmpDocxPath);
			PathUtils.delete(Paths.get(tmpDocxPath));
			File file = new File(tmpDocxPath+".pdf");
			if(!file.exists()){
				response.sendError(HttpServletResponse.SC_NOT_FOUND, "文件未找到");
				return;
			}
			response.setContentType(MediaType.APPLICATION_PDF_VALUE);
			response.setHeader("Content-Length", String.valueOf(file.length()));
			try (InputStream is = new FileInputStream(file);
				 OutputStream os = response.getOutputStream()) {
				byte[] buffer = new byte[4096];
				int bytesRead;
				while ((bytesRead = is.read(buffer)) != -1) {
					os.write(buffer, 0, bytesRead);
				}
			}
			getSession().setAttribute(eid+"_tmpDocx", file.getAbsolutePath());
		} catch (Exception e) {
			response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
			try {
				response.getWriter().write("文件生成失败: " + e.getMessage());
			} catch (IOException ex) {
				ex.printStackTrace();
			}
			e.printStackTrace();
		}
	}

	@RequestMapping("/exportTmpDocxPDF_yunnancj")
	public ResponseEntity<Resource> exportTmpDocxPDF_yunnancj() {
		String eid = getPara("eid");
		String fileType = getPara("type");
		String tmpDocxPath = (String) getSession().getAttribute(eid+"_tmpDocx");
		if(StringUtils.isAnyBlank(eid,fileType,tmpDocxPath)){
			return FileDownloadUtils.errorResponse("参数错误");
		}
		if("docx".equalsIgnoreCase(fileType)){
			tmpDocxPath = tmpDocxPath.replace(".pdf", ".docx");
		}
		return FileDownloadUtils.download(tmpDocxPath);
	}

	@RequestMapping("/exportTmpDocxPDF")
	public ResponseEntity<Resource> exportTmpDocxPDF() {
		String eid = getPara("eid");
		try (ByteArrayOutputStream pdfBaos = new ByteArrayOutputStream()) {
			if(getSession().getAttribute(eid+"_tmpDocx")==null){
				return ResponseEntity.status(HttpStatus.UNAUTHORIZED).build();
			}
			String tmpDocxPath = (String) getSession().getAttribute(eid+"_tmpDocx");
			Document doc = new Document(tmpDocxPath);
			doc.save(pdfBaos, SaveFormat.PDF);
			byte[] pdfBytes = pdfBaos.toByteArray();
			return FileDownloadUtils.download(pdfBytes, "exampaper_"+eid+".pdf");
		} catch (Exception ex) {
			return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
		}
	}

	@PostMapping(value = "/examPaperDocx", consumes = "multipart/form-data")
	public ResponseEntity<Resource> examPaperDocx(
			@RequestParam("file") MultipartFile file,
			@RequestParam String eid,
			@RequestParam(value = "filename", required = false) String filename
	) {
		if (getUserInfo() == null || !"Y".equals(getSession().getAttribute("allowViewPaper_" + eid))) {
			return FileDownloadUtils.errorResponse("下载失败，您没有权限");
		}
		Map<String, Object> examInfo = paperService.getExamInfo(eid);
		systemService.addOnlineSysLog("下载了" + eid + "的word预览试卷");
		String baseName = (filename != null && !filename.isEmpty())
				? filename.replaceAll("(?i)\\.(doc|docx|mhtml|pdf|html)$", "")
				: "export";

		try (InputStream is = file.getInputStream()) {
			LoadOptions lo = new LoadOptions();
			Document doc = new Document(is, lo);
			// 保存为 .docx
			ByteArrayOutputStream out = new ByteArrayOutputStream(512 * 1024);
			OoxmlSaveOptions opt = new OoxmlSaveOptions(SaveFormat.DOCX);
			opt.setCompliance(OoxmlCompliance.ISO_29500_2008_STRICT);

			doc.save(out, opt);

			String outName = baseName + ".docx";
			return FileDownloadUtils.download(out.toByteArray(), outName);
		} catch (Exception e) {
			logger.error("导出 Word 失败：{}", e.getMessage(), e);
			return FileDownloadUtils.errorResponse("导出失败，请联系管理员：\n" + e.getMessage());
		}
	}

	@RequestMapping("/exportHaijunPaper")
	public ResponseEntity<Resource> exportHaijunPaper(@RequestBody Map<String,Object> map) {
		try (InputStream inputStream = GenerateWordUtils.exportDocAsStream(map, "haijunPaper/haijunPaper4doc.ftl")){
			ByteArrayOutputStream buffer = new ByteArrayOutputStream();
			int nRead;
			byte[] bufferBytes = new byte[2048];
			while ((nRead=inputStream.read(bufferBytes,0,bufferBytes.length))!=-1){
				buffer.write(bufferBytes,0,nRead);
			}
			buffer.flush();
			byte[] fileContent = buffer.toByteArray();
			buffer.close();
			return FileDownloadUtils.download(fileContent, "haijunPaper.doc");
		} catch (IOException e) {
			e.printStackTrace();
			return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
		}
	}

}
