package com.cx.kaoyi.business.service.serviceImpl;

import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.domain.download.Progress;
import com.cx.kaoyi.business.service.*;
import com.cx.kaoyi.framework.base.BaseService;


import com.cx.kaoyi.framework.cache.LocalCache;
import com.cx.kaoyi.framework.question.repeat.PaperChangeRecorder;

import com.cx.kaoyi.framework.utils.*;
import net.lingala.zip4j.ZipFile;
import org.apache.poi.hssf.usermodel.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.ss.util.CellRangeAddress;
import org.apache.poi.ss.util.CellRangeAddressList;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.apache.poi.xwpf.model.XWPFHeaderFooterPolicy;
import org.apache.poi.xwpf.usermodel.*;
import org.apache.shiro.SecurityUtils;
import org.jsoup.parser.Parser;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.util.StringUtils;
import org.springframework.web.multipart.MultipartFile;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.annotation.Resource;
import javax.servlet.ServletContext;
import java.io.*;
import java.math.BigDecimal;
import java.nio.channels.FileChannel;
import java.nio.file.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Service("PoiService")
public class PoiServiceImpl extends BaseService implements PoiService {

	@Resource
	public QuestionService questionService;

	@Resource
	public CourseService courseService;

	@Resource
	public SystemService systemService;

	@Resource
	public CommonService commonService;

	@Resource
	public UserService userService;

	@Resource
	public PaperService paperService;
    @Autowired
    private PaperChangeRecorder paperChangeRecorder;
    @Autowired
    private ServletContext servletContext;

	private static final DataFormatter EXCEL_CELL_FORMATTER = new DataFormatter();
	/**
	 * 根据HSSFCell类型设置数据
	 * @param cell
	 * @return
	 */
	private String getCellFormatValue(Cell cell) {
		String cellvalue = "";
		if (cell != null) {
			// 判断当前Cell的Type
			switch (cell.getCellType()) {
				// 如果当前Cell的Type为NUMERIC
				case NUMERIC:
				case FORMULA: {
					// 判断当前的cell是否为Date
					if (DateUtil.isCellDateFormatted(cell)) {
						// 如果是Date类型则，转化为Data格式

						//方法1：这样子的data格式是带时分秒的：2011-10-12 0:00:00
						//cellvalue = cell.getDateCellValue().toLocaleString();

						//方法2：这样子的data格式是不带带时分秒的：2011-10-12
						Date date = cell.getDateCellValue();
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
						cellvalue = sdf.format(date);

					}
					// 如果是纯数字
					else {
						// 取得当前Cell的数值
						//cellvalue = String.valueOf(cell.getNumericCellValue());
						String str=null;
						double doubleValue = cell.getNumericCellValue();
						// 是否为数值型
						if (doubleValue - (int) doubleValue < Double.MIN_VALUE) {
							// 是否为int型
							str = Integer.toString((int) doubleValue);
						} else {
							// 是否为double型
							str = Double.toString(cell.getNumericCellValue());
							DecimalFormat df = new DecimalFormat("#");
							str= df.format(cell.getNumericCellValue());
						}
						cellvalue = "" + str;
					}
					break;
				}
				// 如果当前Cell的Type为STRIN
				case STRING:
					// 取得当前的Cell字符串
					cellvalue = cell.getRichStringCellValue().getString();
					break;
				// 默认的Cell值
				default:
					cellvalue = " ";
			}
		} else {
			cellvalue = "";
		}
		return cellvalue;

	}

	private String getCellFormatIntOrString(Cell cell) {
		if (cell == null) return "";
		return Utils.replaceUnrecognizableChars(EXCEL_CELL_FORMATTER.formatCellValue(cell));
	}

	/**
	 * @author 黎青华
	 * 修改导入主题词
	 * @param mFile
	 * @param cid
	 */
	@Override
	public Map<String, Object> importTheme(MultipartFile mFile, String cid) {
		Map rtn=new HashMap();
		String fileName = mFile.getOriginalFilename();
		String suffix = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
		String ym = DateFormatUtils.getNowDay();
		String filePath = "/uploadFile/excel/theme/" + ym + fileName;
		Path target = Paths.get(WebFilePath.getProjectPath(), filePath);
		try {
			Files.deleteIfExists(target);
			Files.createDirectories(target.getParent());
			mFile.transferTo(target.toFile());
			if (!"xls".equals(suffix.toLowerCase()) && !"xlsx".equals(suffix.toLowerCase())) {
				Files.deleteIfExists(target);
				rtn.put("state", "error");
				rtn.put("mes", "导入文件类型不正确");
				return rtn;
			}
		} catch (IOException e) {
			throw new RuntimeException(e);
		}

		try (InputStream is = Files.newInputStream(target);
			 Workbook wb = WorkbookFactory.create(is)) {
			Sheet sheet = wb.getSheetAt(0);
			Row row = sheet.getRow(0);

			int nums = 0;

			int rowNum = sheet.getLastRowNum();
			for (int i = 1; i <= rowNum; i++) {
				row = sheet.getRow(i);

				String t1name = getCellFormatValue(row.getCell(0)).trim();
				if(!Utils.nullOrEmpty(t1name)) {
					Map m = new HashMap();
					m.put("cid", cid);
					m.put("name", t1name);
					m.put("pid", "-1");
					m.put("tlevel", 1);
					nums += courseService.addThemeFromExcel(m);
				}
				String t2name = getCellFormatValue(row.getCell(1)).trim();
				if(!Utils.nullOrEmpty(t2name)){
					if(Utils.nullOrEmpty(t1name)){
						rtn.put("nums", -1);
						rtn.put("errorRow", i+1);
						return rtn;
					}
					Map m2 = new HashMap();
					m2.put("cid", cid);
					m2.put("pname", t1name);
					m2.put("plevel", 1);
					m2.put("name", t2name);
					String pid = (String) courseService.getParantThemeID(m2).get(0).get("ID");
					if(!Utils.nullOrEmpty(pid)){
						m2.put("pid", pid);
						m2.put("tlevel", 2);
						nums += courseService.addThemeFromExcel(m2);
					}
				}
				String t3name = getCellFormatValue(row.getCell(2)).trim();
				if(!Utils.nullOrEmpty(t3name)){
					//t2name = getCellFormatValue(row.getCell(1));
					if(Utils.nullOrEmpty(t1name) || Utils.nullOrEmpty(t2name)){
						rtn.put("nums", -1);
						rtn.put("errorRow", i+1);
						return rtn;
					}
					Map m3 = new HashMap();
					m3.put("cid", cid);
					m3.put("p1name",t1name);
					m3.put("pname", t2name);
					m3.put("plevel", 2);
					m3.put("name", t3name);
					String pid = (String) courseService.getParantThemeID(m3).get(0).get("ID");
					if(!Utils.nullOrEmpty(pid)){
						m3.put("pid", pid);
						m3.put("tlevel", 3);
						nums += courseService.addThemeFromExcel(m3);
					}
				}
			}
			rtn.put("nums", nums);
			return rtn;
		} catch (Exception e) {
			e.printStackTrace();
			rtn.put("nums", -2);
			return rtn;
		}
	}

	/**
	 * @author 洪艳
	 * 修改导入试题
	 * @param mFile
	 * @param cid
	 */
	@Override
	public Map importQuestion(MultipartFile mFile, String cid, String repeat) {
		int num=0;
		long startTime = System.currentTimeMillis();
		StringBuilder error_qt = new StringBuilder();//题型错误
		StringBuilder error_at = new StringBuilder();//答案错误
		StringBuilder error_th = new StringBuilder();//主题词错误
		StringBuilder error_repeat = new StringBuilder();//题目重复错误
		error_qt.append("因不存在题型，不能导入的行数：");
		error_at.append("因不存在答案，不能导入的行数：");
		error_th.append("因不存在主题词，不能导入的行数：");
		error_repeat.append("因题目重复，不能导入的行数：");
		StringBuilder e_qt = new StringBuilder();
		StringBuilder e_th = new StringBuilder();
		StringBuilder e_at = new StringBuilder();
		StringBuilder e_rt = new StringBuilder();
		Map rtn = new HashMap();
		String fileName = mFile.getOriginalFilename();//获取上传文档原始名字
		String filePath = "uploadFile/excel/question/" + DateFormatUtils.getNowDay() + fileName;

		Path target = Paths.get(WebFilePath.getProjectPath(), filePath);
		try {
			Files.deleteIfExists(target);
			Files.createDirectories(target.getParent());
			mFile.transferTo(target.toFile());
		} catch (IOException e) {
			throw new RuntimeException(e);
		}

		try (InputStream is = Files.newInputStream(target);
			 Workbook wb = WorkbookFactory.create(is)) {
			Sheet sheet = wb.getSheetAt(0);
			Row row;
			Row rowtemp = null;

			//对比excel中题型那些信息是否和课程中一致，避免出现A1填空题
			//获取课程中的题型名称，是否串题，答案类型
			List<Map<String, Object>> questionTypeInfo = courseService.getCourseQuestionInfo(cid);
			boolean exis = true;//判断标识
			String einfo="";
			//存放课程的题型名称，是否串题和答案类型拼接成的字符串，用来和excel中的对比
			ArrayList<String> qtis = new ArrayList<>();
			for (Map<String, Object> s: questionTypeInfo) {
				String qtinfo = s.get("QTNAME").toString() + s.get("ISCON").toString() + s.get("NAME").toString();
				qtis.add(qtinfo);
			}
			int rowNum = sheet.getLastRowNum();//获取工作表最大行数
			ArrayList<Integer> ctNum = new ArrayList<>();

			//把课程的所有题型存放在一个list
			List<Map<String, Object>> questionType = courseService.getCourseQuestionType(cid);
			Map<String ,Map<String,Object>> qtMap = Utils.listToMap(questionType, "QTNAME");
			//获得cognition列表（认知）
			List<Map<String, Object>> cognitionList = courseService.getCourseCognition(cid);
			Map<String ,Map<String,Object>> coMap = Utils.listToMap(cognitionList, "NAME");
			//获得source列表（题源）
			List<Map<String, Object>> sourceList = courseService.getCourseSource(cid);
			Map<String ,Map<String,Object>> sourceMap = Utils.listToMap(sourceList, "NAME");
			//获得knowledge列表（知识点）
			List<Map<String, Object>> knowledgeList = courseService.getCourseKnowledge(cid);
			Map<String ,Map<String,Object>> knowledgeMap = Utils.listToMap(knowledgeList, "NAME");
			//获得difficulty列表（难度）
			List<Map<String, Object>> difficultyList = courseService.getCourseDifficulty(cid);
			Map<String ,Map<String,Object>> diffMap = Utils.listToMap(difficultyList, "NAME");

			for (int i =1 ;i<=rowNum;i++){
				row = sheet.getRow(i);
				String c0 = getCellFormatIntOrString(row.getCell(0)).trim();
				String c1 = getCellFormatIntOrString(row.getCell(1));
				String c2 = getCellFormatIntOrString(row.getCell(2)).trim();
				String c3 = getCellFormatIntOrString(row.getCell(3)).trim();

				String cognition = getCellFormatIntOrString(row.getCell(14)); //认知
				String source = getCellFormatIntOrString(row.getCell(15)); //题源
				String knowledge = getCellFormatIntOrString(row.getCell(16)); //知识点
				String difficulty = getCellFormatIntOrString(row.getCell(17)); //难度

				if(!coMap.containsKey(cognition)) {
					String mes = "第"+i+"行，"+"题型："+c0
							+"，串题标识："+c2
							+"，答案类型："+c3
							+"，认知类型不存在，请在课程中添加或勾选此认知类型";
					long endTime = System.currentTimeMillis();
					rtn.put("times", (float)(endTime-startTime));
					rtn.put("message", mes);
					return rtn;
				}

				if(!sourceMap.containsKey(source)) {
					String mes = "第"+i+"行，"+"题型："+c0
							+"，串题标识："+c2
							+"，答案类型："+c3
							+"，题目来源类型不存在，请在课程中添加或勾选此题目来源";
					long endTime = System.currentTimeMillis();
					rtn.put("times", (float)(endTime-startTime));
					rtn.put("message", mes);
					return rtn;
				}

				if(!knowledgeMap.containsKey(knowledge)) {
					String mes = "第"+i+"行，"+"题型："+c0
							+"，串题标识："+c2
							+"，答案类型："+c3
							+"，知识点类型不存在，请在课程中添加或勾选此知识点类型";
					long endTime = System.currentTimeMillis();
					rtn.put("times", (float)(endTime-startTime));
					rtn.put("message", mes);
					return rtn;
				}

				if(!diffMap.containsKey(difficulty)) {
					String mes = "第"+i+"行，"+"题型："+c0
							+"，串题标识："+c2
							+"，答案类型："+c3
							+"，难度类型不存在，请在课程中添加或勾选此难度类型";
					long endTime = System.currentTimeMillis();
					rtn.put("times", (float)(endTime-startTime));
					rtn.put("message", mes);
					return rtn;
				}

				if(!sourceMap.containsKey(source)) {
					String mes = "第"+i+"行，"+"题型："+c0
							+"，串题标识："+c2
							+"，答案类型："+c3
							+"，题目来源类型不存在，请在课程中添加或勾选此题目来源";
					long endTime = System.currentTimeMillis();
					rtn.put("times", (float)(endTime-startTime));
					rtn.put("message", mes);
					return rtn;
				}

				// 全空行跳过
				if (c0.isEmpty() &&c2.isEmpty() && c3.isEmpty()) {
					continue;
				}

				String ggtg = c1;
				int ct_sign = Utils.changeObjToInt(c2);
				if(!"".equals(ggtg)&&ct_sign >0){
					ctNum.add(i);
					continue;
				}
				//组合excel题目标识
				einfo =c0 +c2 +c3;
				//遍历课程的题型，与excel判断
				for (String cqti : qtis){
					//如果当前行的标识和课程内标识相同，则跳出当前循环继续下一行判断,否则，判断标识为false
					if (cqti.equals(einfo)){
						exis = true;
						break;
					}else{
						exis = false;
					}
				}
				//如果课程题目标识和excel标识对比，最终标识为false，则直接返回错误信息
				if (exis == false){
					i++;
					String mes = "第"+i+"行，"+"题型："+c0
							+"，串题标识："+c2
							+"，答案类型："+c3
							+"，题型不存在，请在课程中添加此题型";
					long endTime = System.currentTimeMillis();
					rtn.put("times", (float)(endTime-startTime));
					rtn.put("message", mes);
					return rtn;
				}
			}
			//遍历串题的题目
			if (ctNum.size()!=0){
				//存放串题的题目类型和答案类型
				ArrayList<String> qtAnswer = new ArrayList<>();
				//存放课程内的题目类型和答案类型
				for (Map<String, Object> s: questionTypeInfo) {
					String qtAndans = s.get("QTNAME").toString() + s.get("NAME").toString();
					qtAnswer.add(qtAndans);
				}
				//组合excel内的串题的题目类型和答案类型
				for (int j=0;j<ctNum.size();j++){
					row = sheet.getRow(ctNum.get(j));
					einfo = getCellFormatIntOrString(row.getCell(0)).trim()
							+getCellFormatIntOrString(row.getCell(3)).trim();
					//对比课程内和excel内的题目类型和答案类型是否存在
					for (String qt_name :qtAnswer) {
						if(qt_name.equals(einfo)){
							exis = true;
							break;
						}else {
							exis = false;
						}
					}
					if (exis == false){
						int numLine = ctNum.get(j)+1;
						String mes = "第"+numLine+"行，"+"题型："+getCellFormatIntOrString(row.getCell(0)).trim()
								+"，答案类型："+getCellFormatIntOrString(row.getCell(3)).trim()
								+"，题型不存在，请在课程中添加此题型";
						long endTime = System.currentTimeMillis();
						rtn.put("times", (float)(endTime-startTime));
						rtn.put("message", mes);

						return rtn;
					}
				}
			}

			//先扫描xls文件是否有不存在的   主题词   ，有则添加到数据库
			List<Map<String, Object>> themePool = new ArrayList<>();
			for(int i = 1; i<= rowNum; i++) {//遍历所有行
				row = sheet.getRow(i);

				String c0 = getCellFormatIntOrString(row.getCell(0)).trim();
				String c2 = getCellFormatIntOrString(row.getCell(2)).trim();
				String c3 = getCellFormatIntOrString(row.getCell(3)).trim();

				// 全空行全跳过
				if (c0.isEmpty() &&c2.isEmpty() && c3.isEmpty()) {
					continue;
				}

				String t1name = getCellFormatIntOrString(row.getCell(11)).trim();//主题词1
				String t2name = getCellFormatIntOrString(row.getCell(12)).trim();//主题词2
				String t3name = getCellFormatIntOrString(row.getCell(13)).trim();//主题词3
				//如果一级主题词非空，
				if(!StringUtils.isEmpty(t1name)) {
					Map t1par = new HashMap();
					t1par.put("th_name", t1name);
					t1par.put("th_pid", "-1");
					t1par.put("th_level", 1);
					t1par.put("th_cid", cid);
					//如果表内主题词不在数据库内，则添加，否则更新此主题的状态（一级一级添加）
					questionService.insertTheme4ImportQuestion(t1par);
					addIntoPool(themePool,t1par);
					if(!StringUtils.isEmpty(t2name)) {
						Map t2par = new HashMap();
						t2par.put("th_name", t2name);
						t2par.put("th_pid", t1par.get("id").toString());
						t2par.put("th_level", 2);
						t2par.put("th_cid", cid);
						questionService.insertTheme4ImportQuestion(t2par);
						addIntoPool(themePool,t2par);
						if(!StringUtils.isEmpty(t3name)) {
							Map t3par = new HashMap();
							t3par.put("th_name", t3name);
							t3par.put("th_pid", t2par.get("id").toString());
							t3par.put("th_level", 3);
							t3par.put("th_cid", cid);
//							t3par.put("th_lastName", t2name);
//							t3par.put("th_lastLevel", 2);
							questionService.insertTheme4ImportQuestion(t3par);
							addIntoPool(themePool,t3par);
						}
					}
				}
			}

			//不存在的主题词已经插入数据库，表格内所有主题词都在themePool，需要主题词直接读取此List便可
			//创建一个List作为暂时存储question的池
			List<Map<String, Object>> questionPool = new ArrayList<>();
			//获取当前课程的属性信息
			//获得教师列表
			List<User> teacherList = userService.getAllTeacher();
			List<Map<String, Object>> atList = commonService.getAnswerTypeList();
			Map<String, Map<String, Object>> atMap = Utils.listToMap(atList, "NAME");
			int len = 100;//每次插入多小条
			int time = rowNum % len == 0 ? rowNum / len : rowNum / len + 1;
			int distance = 0;

			for(int tt = 0; tt < time; tt++) {
				List<Map<String, Object>> insertQuestionPool = new ArrayList<>();
				//创建一个List作为暂时存储answer的池
				List<Map<String, Object>> answerPool = new ArrayList<>();
				int maxSize = (tt + 1) * len > rowNum ? rowNum : (tt + 1) * len;//导入试题最大行数（len的倍数）

				try {
				out :for(int i= (tt * len) + 1; i <= maxSize; i++) {
						if(distance!=0) {
							i+=distance;
							distance=0;
						}
						row = sheet.getRow(i);

						//combin预处理
						int combinRownum = 0;
						rowtemp = sheet.getRow(i+1);
						//公共题干
						String mainContent = getCellFormatIntOrString(row.getCell(1))
								.replaceAll("\\r\\n|\\n|\\r", "<br>");
						//题目内容
						String content = getCellFormatIntOrString(row.getCell(8)).trim();
						//答案
						String tcontent = getCellFormatIntOrString(row.getCell(9)).trim();
						//答案解释
						String answerexplain = getCellFormatIntOrString(row.getCell(10)).trim();
						//存放选项
						Map<String,Object> acontentMap = new HashMap<>();
						int max = row.getLastCellNum()-25;//14（选项开始到结束的距离）
						//遍历选项 把选项内容存入acontentMap
						Set<String> acontentSet = new HashSet<>();
						for(int k = 0; k < max; k++) {
							//选项
							String acontent = getCellFormatIntOrString(row.getCell(k+25)).trim();
							//如果选项存在
							if(!StringUtils.isEmpty(acontent)) {
								acontentMap.put((k+25)+"sel", acontent);

								String compareAcontent = Utils.stripAllHtml4Compare(acontent);
								if(!acontentSet.contains(compareAcontent)){
									acontentSet.add(compareAcontent);
								}else {
									e_rt.append(i).append("【答案选项存在重复】,");
									continue out;
								}
							}
						}
						//
						while(rowtemp!=null && getCellFormatIntOrString(rowtemp.getCell(0)).equals("combin")) {
							combinRownum++;
							rowtemp = sheet.getRow(i+combinRownum+1);
						}
						for(int j=1;j<=combinRownum;j++) {
							rowtemp = sheet.getRow(i+j);
							mainContent += getCellFormatIntOrString(rowtemp.getCell(1));
							content += getCellFormatIntOrString(rowtemp.getCell(8)).trim();
							tcontent += getCellFormatIntOrString(rowtemp.getCell(9)).trim();
							answerexplain += getCellFormatIntOrString(rowtemp.getCell(10)).trim();
							for(int k = 0; k < max; k++) {
								//选项
								String acontent = acontentMap.get((k+25)+"sel").toString() + getCellFormatIntOrString(row.getCell(k+25)).trim();
								//如果选项存在
								if(!StringUtils.isEmpty(acontent)) {
									acontentMap.put((k+25)+"sel", acontent);

									String compareAcontent = Utils.stripAllHtml4Compare(acontent);
									if(!acontentSet.contains(compareAcontent)){
										acontentSet.add(compareAcontent);
									}else {
										e_rt.append(i).append("【答案选项存在重复】,");
										continue out;
									}
								}
							}
						}


						//题型部分
						String qtname = getCellFormatIntOrString(row.getCell(0)).trim();//题型
						String qtid = "";
//						int atid = -1;
//						//题型列为空
						if(StringUtils.isEmpty(qtname)) {
							e_qt.append(i).append("空题型,");
							continue;
						}
						if(qtMap.containsKey(qtname)) qtid = String.valueOf(qtMap.get(qtname).get("QTID"));

						String atname = getCellFormatIntOrString(row.getCell(3)).trim();
						int atid = Utils.changeObjToInt(atMap.get(atname).get("ID"));

						String mainQuestionContent = mainContent;

						//题型不存在于此课程
						int iscon = 0;
						//公共题干不为空，则是题干
						if(mainQuestionContent!=null && !StringUtils.isEmpty(mainQuestionContent.trim())) {
							if(mainQuestionContent.indexOf("<p")!=0&&mainQuestionContent.indexOf("<P")!=0) {
								mainQuestionContent="<p>"+mainQuestionContent+"</p>";
							}
							iscon = 1;
							for (int l =1 ;l<=rowNum;l++){
								String c0 = getCellFormatIntOrString(row.getCell(0)).trim();
								String c2 = getCellFormatIntOrString(row.getCell(2)).trim();
								String c3 = getCellFormatIntOrString(row.getCell(3)).trim();

								// 全空行跳过
								if (c0.isEmpty() &&c2.isEmpty() && c3.isEmpty()) {
									continue;
								}

								//判断是否为串题标识
								String ct_sign=getCellFormatIntOrString(row.getCell(2)).trim();
								if(!ct_sign.equals("1")) {
									ct_sign="1";
								}
								einfo =getCellFormatIntOrString(row.getCell(0)).trim()
										+ct_sign
										+getCellFormatIntOrString(row.getCell(3)).trim();
								for (String cqti : qtis){
									if (cqti.equals(einfo)){
										exis = true;
										break;
									}else{
										exis = false;
									}
								}
								//如果课程题目标识和excel标识对比，最终标识为false，则直接返回错误信息
								if (exis == false){
									l++;
									String mes = "第"+l+"行，"+"题型："+getCellFormatIntOrString(row.getCell(0)).trim()
											+"，串题标识："+getCellFormatIntOrString(row.getCell(2)).trim()
											+"，答案类型："+getCellFormatIntOrString(row.getCell(3)).trim()
											+"，题型不存在，请在课程中添加此题型";
									long endTime = System.currentTimeMillis();
									rtn.put("times", (float)(endTime-startTime));
									rtn.put("message", mes);
									return rtn;
								}
							}
						}


						if("".equals(qtid)) {
							boolean f = false;
							if(atid < 4 || atid == 8 || atid == 9) {
								if(!StringUtils.isEmpty(qtname)){
									f = true;
								}
							}else if(atid == 4) {
								if(!StringUtils.isEmpty(getCellFormatIntOrString(row.getCell(9)))) {
									f = true;
								}
							}else {
								if(!StringUtils.isEmpty(getCellFormatIntOrString(row.getCell(9)))) {
									f = true;
								}
							}

							if(!f) {
								e_qt.append(i).append(",");
								continue;
							}else {
								qtid = courseService.getQuestionTypeId().get(0).get("ID")+"";
								Map param = new HashMap();
								param.put("cid", cid);
								param.put("qtname", qtname);
								param.put("iscon", iscon);
								param.put("atid", atid);
								param.put("qtid", qtid);
								courseService.addCourseQuestionType(param);
								questionType = courseService.getCourseQuestionType(cid);
								qtMap = Utils.listToMap(questionType, "QTNAME");
							}
						}

						//录入者用户名 用户id
						String uid = "";
						String creatorUsername = getCellFormatIntOrString(row.getCell(4)).trim();
						String creatorName = getCellFormatIntOrString(row.getCell(5)).trim();
						if(!StringUtils.isEmpty(creatorUsername)) {
							for(User u:teacherList) {
								if(creatorUsername.equals(u.getUsername())) {
									uid = u.getId();
									creatorName=u.getRealname();
									break;
								}
							}
						}
						if(StringUtils.isEmpty(uid)&&(!StringUtils.isEmpty(creatorName))){
							for(User teacher : teacherList){
								if(creatorName.equals(teacher.getRealname())){
									uid = teacher.getId();
									break;
								}
							}
						}
						if(StringUtils.isEmpty(uid)){
							User user = (User)SecurityUtils.getSubject().getSession().getAttribute("userInfo");
							if(user!=null){
								uid = user.getId();
								creatorName = user.getRealname();
							}
						}

						//审核者用户名 用户id
						String vid = "";
						String verifyUsername = getCellFormatIntOrString(row.getCell(6)).trim();
						String verifyName = getCellFormatIntOrString(row.getCell(7)).trim();
						if(!StringUtils.isEmpty(verifyUsername)) {
							for(User v:teacherList) {
								if(verifyUsername.equals(v.getUsername())) {
									vid = v.getId();
									verifyName=v.getRealname();
									break;
								}
							}
						}else if(StringUtils.isEmpty(vid)&&(!StringUtils.isEmpty(verifyName))){
							for(User teacher : teacherList){
								if(verifyName.equals(teacher.getRealname())){
									vid = teacher.getId();
									break;
								}
							}
						}

						//主题词
						String theme1 = getCellFormatIntOrString(row.getCell(11)).trim();
						String theme2 = getCellFormatIntOrString(row.getCell(12)).trim();
						String theme3 = getCellFormatIntOrString(row.getCell(13)).trim();

						String th1id = "";
						String th2id = "";
						String th3id = "";
						if(!StringUtils.isEmpty(theme1)) {
							th1id = findThemeIDByName(themePool, theme1, "-1");
							if(!StringUtils.isEmpty(theme2)) {
								th2id = findThemeIDByName(themePool, theme2, th1id);
								if(!StringUtils.isEmpty(theme3)) {
									th3id = findThemeIDByName(themePool, theme3, th2id);
								}
							}
						}else {
							e_th.append(i).append(",");
							continue;
						}

						String cognition = getCellFormatIntOrString(row.getCell(14)); //认知
						String source = getCellFormatIntOrString(row.getCell(15)); //题源
						String knowledge = getCellFormatIntOrString(row.getCell(16)); //知识点
						String difficulty = getCellFormatIntOrString(row.getCell(17)); //难度

						String cognitionid="1";
						if(coMap.get(cognition)!=null){
							cognitionid = String.valueOf(coMap.get(cognition).get("ID"));
						}

						String sourceid="1";
						if(sourceMap.get(source)!=null){
							sourceid = String.valueOf(sourceMap.get(source).get("ID"));
						}

						String knowledgeid="1";
						if(knowledgeMap.get(knowledge)!=null){
							knowledgeid = String.valueOf(knowledgeMap.get(knowledge).get("ID"));
						}

						String difficultyid = "1";;
						if(diffMap.get(difficulty)!=null){
							difficultyid = String.valueOf(diffMap.get(difficulty).get("ID"));
						}

						String isconId = getCellFormatIntOrString(row.getCell(2)).trim();

						//答题用时
						String answertime = "45"; //默认45秒

						String t = getCellFormatIntOrString(row.getCell(18)).trim();
						if(!StringUtils.isEmpty(t) && Utils.isNumeric(t)) {
//		                	answertime = commonService.getNearSystemTimeId(t);
							answertime = t;
						}

						String realdifficulty = "0"; //实测难度
						if(!StringUtils.isEmpty(getCellFormatIntOrString(row.getCell(19)).trim())) {
							String val = getCellFormatIntOrString(row.getCell(19)).trim();
							Matcher isNums = Pattern.compile("[0]\\.{0,1}[0-9]{0,3}|[1]\\.{0,1}[0]{0,3}").matcher(val);
							if(isNums.matches()) {
								realdifficulty = val;
							}
						}

						String count = "0";
						if(!StringUtils.isEmpty(getCellFormatIntOrString(row.getCell(20)).trim())) {
							String val = getCellFormatIntOrString(row.getCell(20)).trim();
							if(Utils.isNumeric(val)) {
								count = val;
							}
						}

						String distinction = "0";
						if(!StringUtils.isEmpty(getCellFormatIntOrString(row.getCell(21)).trim())) {
							String val = getCellFormatIntOrString(row.getCell(21)).trim();
							Matcher isNums = Pattern.compile("[0]\\.{0,1}[0-9]{0,3}|[1]\\.{0,1}[0]{0,3}").matcher(val);
							if(isNums.matches()) {
								distinction = val;
							}
						}

						int nums = 0;
						if(!StringUtils.isEmpty(getCellFormatIntOrString(row.getCell(22)).trim())) {
							String val = getCellFormatIntOrString(row.getCell(22)).trim();
							if(Utils.isNumeric(val)) {
								nums = Integer.parseInt(val);
							}
						}

						String mqid = "";

						if(iscon==1) {
							//公共题干栏不为空
							Map mainQuestion = new HashMap();
							mainQuestion.put("cid", cid);
							mainQuestion.put("qtiscon", iscon);
							mainQuestion.put("addtime", new Date());
							mainQuestion.put("ismain", 1);
							mainQuestion.put("answertime", answertime);
							mainQuestion.put("realdifficulty",realdifficulty);
							mainQuestion.put("distinction", distinction);
							mainQuestion.put("count", count);
							mainQuestion.put("qtid", qtid);
							mainQuestion.put("creatorid", uid);
							mainQuestion.put("verifyid", vid);
							mainQuestion.put("creatorname", creatorName);
							mainQuestion.put("verifyname", verifyName);
							if(verifyName.equals("")||verifyName.isEmpty()){
								if(vid.equals("")||vid.isEmpty()){
									mainQuestion.put("state", 0);
								}
							}else{
								mainQuestion.put("state", 1);
							}
							mainQuestion.put("content", mainQuestionContent);
							mainQuestion.put("isconId", isconId);
							mainQuestion.put("theme1id", th1id);
							mainQuestion.put("theme2id", th2id);
							mainQuestion.put("theme3id", th3id);
							mainQuestion.put("filepath", getCellFormatIntOrString(row.getCell(23)).equals("") ? "" : getCellFormatIntOrString(row.getCell(23)));
							mainQuestion.put("mqid", "");
							mainQuestion.put("difficultyid", difficultyid);
							mainQuestion.put("knowledgeid", knowledgeid);
							mainQuestion.put("cognitionid", cognitionid);
							mainQuestion.put("sourceid", sourceid);
							mainQuestion.put("arrangeid", 4);
							mainQuestion.put("atid", atid);
							mainQuestion.put("num", nums);
							Map rs = null;
							if("0".equals(repeat)) {
								rs = getQuestionExist(questionPool, mainQuestion, "2");
							}else {
								rs = getQuestionExist(questionPool, mainQuestion, repeat);
							}

							mainQuestion.put("id", rs.get("id"));
							mainQuestion.put("answerid", "");
							mainQuestion.put("answerexplain", "");
							mqid = rs.get("id").toString();

							if(StringUtils.isEmpty(rs.get("exist"))) {
								addIntoPool(questionPool, mainQuestion);
								addIntoPool(insertQuestionPool, mainQuestion);
							}
						}
						String questionContent = content;
						if(questionContent.indexOf("<p")!=0&&questionContent.indexOf("<P")!=0) {
							questionContent="<p>"+questionContent+"</p>";
						}
						if(!StringUtils.isEmpty(questionContent)) {
							Map question = new HashMap();
							question.put("cid", cid);
							question.put("qtid", qtid);
							question.put("content", questionContent);
							question.put("ismain", 0);
							question.put("isconId", isconId);
							question.put("atid", atid);
							if(!"0".equals(repeat)) {
								int amax = row.getLastCellNum()-25;
								StringBuilder sb=new StringBuilder();
								//String[] c = new String[amax];
								for(int i1 = 0 ; i1 < amax; i1++) {
									String acontent = getCellFormatIntOrString(row.getCell(i1+25)).trim();
									if(!StringUtils.isEmpty(acontent)) {
										sb.append(getCellFormatIntOrString(row.getCell(i1+25)).trim()+"!!!!!");
									}
								}
								String str=sb.substring(0, sb.length());
								String[] c=str.split("!!!!!");
								question.put("acontent", c);

							}
							Map m = getQuestionExist(questionPool,question,repeat);//此方法返回id和exist
							if(StringUtils.isEmpty(m.get("exist"))) {
								//exist不存在则表明题目不存在数据库
								String qid = (String) m.get("id");
								question.put("id", qid);
								question.put("addtime", new Date());
								question.put("answertime", answertime);
								question.put("realdifficulty", realdifficulty);
								question.put("distinction", distinction);
								question.put("count", count);
								question.put("creatorid", uid);
								question.put("verifyid", vid);
								question.put("creatorname", creatorName);
								question.put("verifyname", verifyName);
								if(verifyName.equals("")||verifyName.isEmpty()){
									if(vid.equals("")||vid.isEmpty()){
										question.put("state", 0);
									}
								}else{
									question.put("state", 1);
								}
								question.put("theme1id", th1id);
								question.put("theme2id", th2id);
								question.put("theme3id", th3id);
								question.put("difficultyid", difficultyid);
								question.put("knowledgeid", knowledgeid);
								question.put("cognitionid", cognitionid);
								question.put("sourceid", sourceid);
								question.put("arrangeid", 4);
								question.put("filepath", getCellFormatIntOrString(row.getCell(24)));
								question.put("mfilepath", getCellFormatIntOrString(row.getCell(23)));
								question.put("num", nums);

								if(iscon == 1) {
									question.put("mqid", mqid);
									question.put("qtiscon", 1);
								}else {
									question.put("mqid", "");
									question.put("qtiscon", 0);
								}
								//处理答案
								String trueAnswerId = "";
//								String tcontent = getCellFormatIntOrString(row.getCell(9)).trim();
								if(atid < 4 || atid == 8 || atid == 9) {
//									max = row.getLastCellNum()-25;
									String[] aids = new String[max];
//									for(int j = 0; j < max; j++) {
									for(int j = 0; j < max; j++) {
										if(!StringUtils.isEmpty(acontentMap.get((j+25)+"sel"))) {//去掉无用的空白选项
											String acontent = acontentMap.get((j+25)+"sel").toString();
											String aid = questionService.getAnswerID();
											aids[j] = aid;
											Map answer = new HashMap();
											answer.put("qid", qid);
											answer.put("atid", atid);
											answer.put("aid", aid);
											answer.put("content", acontent);
											answer.put("content_6","");
											if(acontent.length()>=4000){
												answer.remove("content");
												answer.put("content_6",acontent);
												System.out.println("Exception: qid="+qid+"答案长度过长："+acontent);
											}
											answerPool.add(answer);
										}
									}
									char[] correct = tcontent.toCharArray();
									StringBuilder sb = new StringBuilder();
									for(char cc:correct) {
										int index = (int)cc-65;
										if(index >= 0 && index < aids.length) {
											sb.append(aids[index]).append(",");
										}
									}
									if(sb!=null&&sb.length()>0){
										trueAnswerId = sb.toString().substring(0,sb.toString().length()-1);
									}else{
										trueAnswerId = "";
									}

								}else if(atid == 4) {
									String aid = questionService.getAnswerID();
									String acontent = "false";
									if(tcontent.equals("对") || tcontent.equals("是") || tcontent.equals("√")) {
										acontent = "true";
									}
									Map answer = new HashMap();
									answer.put("qid", qid);
									answer.put("atid", atid);
									answer.put("aid", aid);
									answer.put("content", acontent);
									answer.put("content_6", "");

									answerPool.add(answer);
									trueAnswerId = aid;
								}else if(atid > 4 && atid < 8 || atid > 9) {
									String aid = questionService.getAnswerID();
									Map answer = new HashMap();
									answer.put("qid", qid);
									answer.put("atid", atid);
									answer.put("aid", aid);
									answer.put("content", "");
									answer.put("content_6", tcontent);

									answerPool.add(answer);
									trueAnswerId= aid;
								}

								if(!"".equals(trueAnswerId)) {
									question.put("answerid", trueAnswerId);
									//						String answerexplain = getCellFormatIntOrString(row.getCell(10)).trim();//答案解释
									if(StringUtils.isEmpty(answerexplain)) {
										answerexplain = "";
									}
									question.put("answerexplain", answerexplain);
									addIntoPool(questionPool, question);
									addIntoPool(insertQuestionPool, question);
								}else {
									e_at.append(i).append(",");
								}
							} else {
								e_rt.append(i).append(",");
							}
						}
						i+=combinRownum;
						if(i>=maxSize) {
							distance = i-maxSize;
						}
					}

					if(insertQuestionPool.size() > 0) {
						questionService.insertQuestionForImportQuestion(insertQuestionPool);
						questionService.insertAnswerForImportQuestion(answerPool);
						num += insertQuestionPool.size();
					}

				} catch (Exception e) {
					System.out.println(tt);
					e.printStackTrace();
				}
			}

			questionService.call_updateCourseQuestioncount(cid);
		}catch (Exception e) {
			e.printStackTrace();
		}

		rtn.put("code", 0);
		String mes = "已导入"+num+"条试题。<br/>";
		if(!StringUtils.isEmpty(e_qt.toString())) {
			mes += error_qt.toString() + e_qt.toString();
		}
		if(!StringUtils.isEmpty(e_th.toString())) {
			mes += error_th.toString() + e_th.toString();
		}
		if(!StringUtils.isEmpty(e_at.toString())) {
			mes += error_at.toString() + e_at.toString();
		}
		if(!StringUtils.isEmpty(e_rt.toString())) {
			mes += error_repeat.toString() + e_rt.toString();
		}

		long endTime = System.currentTimeMillis();
		rtn.put("times", (float)(endTime-startTime));
		rtn.put("message", mes);
		return rtn;
	}

	private String findParamInList(List<Map<String, Object>> list, String name) {
		String id = "";
		for(Map m:list) {
			if (m.get("NAME")!=null) {
				if(name.equals(m.get("NAME").toString())) {
					id = m.get("ID").toString();
					break;
				}
			}
		}
		return id;
	}

	private Map<String, String> getQuestionExist(List<Map<String, Object>> questionPool, Map Question, String repeat) {
		String id = "";
		Map rs = new HashMap();
		if("1".equals(repeat) || "2".equals(repeat)) {
			String QuestionContent = Question.get("content").toString();
			String isconID = Question.get("isconId").toString();
			boolean b = false;
			for(Map m : questionPool) {
				//查看池中是否有此题干
				String[] aContent = (String[]) Question.get("acontent");
				if(QuestionContent.equals(m.get("content").toString())) {
					if("0".equals(Question.get("ismain").toString()) && aContent.length > 0) {
						//子题或题目
						String[] otherAContnet = (String[]) m.get("acontent");
						//选项数量相同则对比
						if(aContent.length == otherAContnet.length) {
							int times = 0; //相同条目
							for(int l=0;l<aContent.length;l++) {
								for(int k=0;k<otherAContnet.length;k++) {
									if(aContent[l].equals(otherAContnet[k])) {
										times++;
										break;
									}
								}
							}
							if(aContent.length == times) {
								//全部选项相同
								rs.put("exist", "y");
								id = m.get("id").toString();
								b = true;
								break;
							}
						}
					} else {
						//串题题干的情况
						if(isconID.equals(m.get("isconId").toString())){
							rs.put("exist", "y");
							id = m.get("id").toString();
							b = true;
							break;
						}
					}
				}
			}
			if(b == false) {
				//没有则查询数据库
				if("1".equals(repeat)) {
					if(Question.get("content").toString().length() < 3000) {
						List<Map<String, Object>> ls = questionService.getRepeatQuestionForImportQuestion(Question);
						if(ls.size() > 0) {
							//数据库有结果,返回id
							String[] aContent = (String[]) Question.get("acontent");
							if("0".equals(Question.get("ismain").toString()) && aContent.length > 0) {
								boolean flag = true; //默认选项不一致
								for(int k=0;k<ls.size();k++) {
									String qid = ls.get(k).get("QID").toString();
									Map param = new HashMap();
									param.put("list", aContent);
									param.put("qid", qid);
									// 查询相同选项数量
									List t = questionService.getRepeatAnswerContent(param);
									if(t.size() >= aContent.length || t.size() == 0) {
										flag = false; //有一致的选项
										rs.put("exist", "y");
										id = qid;
										break;
									}
								}
								if(flag) {
									id = questionService.getQuestionID();
								}
							} else {
								//串题题干、判断题、主观题只判断题干，内容相同则取id
								rs.put("exist", "y");
								id = ls.get(0).get("QID").toString();
							}
						} else {
							//数据库没结果,生成id
							id = questionService.getQuestionID();
						}
					} else {
						//数据库没结果,生成id
						id = questionService.getQuestionID();
					}
				} else {
					id = questionService.getQuestionID();
				}
			}
		} else {
			id = questionService.getQuestionID();
		}
		rs.put("id", id);
		return rs;
	}

	private void addIntoPool(List<Map<String, Object>> Pool, Map param) {
		boolean b = false;
		for(Map m:Pool) {
			//查看池里面是否有这个id
			if((param.get("id").toString()).equals(m.get("id"))) {
				b = true;
				break;
			}
		}
		if(b == false) {
			//没有则添加数据
			Pool.add(param);
		}
	}

	private String findThemeIDByName(List<Map<String, Object>> themePool, String theme, String pid) {
		String thid = "";
		for(Map m:themePool) {
			if(theme.equals(m.get("th_name").toString()) && pid.equals(m.get("th_pid").toString())) {
				thid = m.get("id").toString();
				break;
			}
		}
		return thid;
	}

	@Override
	public HSSFWorkbook exportQuestion(Map m, String[] qids){
//		Map m = new HashMap();
//		m.put("cid", cid);
		String cid=String.valueOf(m.get("cid"));
		if(qids!=null && qids.length>0){
			m.put("qids", qids);
		}
		int gs=0;
		try{
			gs=Integer.parseInt(String.valueOf(m.get("gs")));
		}catch(Exception e){}

		List<Map<String, Object>> res =  questionService.writeQuestionXls(m);

		List<Map<String,Object>> answerType = commonService.getAnswerTypeList();
		List<Map<String,Object>> allQuestion = new ArrayList<>();
		for(Map mm:res){
			int iscon = Integer.parseInt(mm.get("qtiscon").toString());
			if(iscon==1) {
				Map param = new HashMap();
				param.put("mqid", mm.get("qid"));
				param.put("cid", cid);
				List<Map<String, Object>> qls = questionService.getQuestionBranch4Xls(param);
				for(Map mq : qls) {
					Map par = new HashMap();
					par.put("id", mq.get("qid").toString());

					mq.put("mainContent", mm.get("content"));
					mq.put("mfilepath", mm.get("filepath"));
					mq.put("answer",questionService.getAnswerByQID(par));
					allQuestion.add(mq);
				}
			}else {
				Map par = new HashMap();
				par.put("id", mm.get("qid").toString());

				mm.put("mainContent", "");
				mm.put("mfilepath", "");
				mm.put("answer", questionService.getAnswerByQID(par));
				allQuestion.add(mm);
			}
		}
		return createQuestionExcel(allQuestion,gs,answerType);
	}

	@Override
	public HSSFWorkbook exportAllPaperQuestion(Map m){
		String eid=String.valueOf(m.get("eid"));
		int gs=0;
		try{
			gs=Integer.parseInt(String.valueOf(m.get("gs")));
		}catch(Exception e){}

		List<Map<String, Object>> res =  paperService.getExampaperQuestionList4xls(m);

		List<Map<String,Object>> answerType = commonService.getAnswerTypeList();
		List<Map<String,Object>> allQuestion = new ArrayList<>();
		for(Map mm:res){
			int iscon = Integer.parseInt(mm.get("qtiscon").toString());
			if(iscon==1) {
				Map param = new HashMap();
				param.put("mqid", mm.get("qid"));
				param.put("eid", eid);
				List<Map<String, Object>> qls = paperService.getPaperQuestionBranch4Xls(param);
				for(Map mq : qls) {
					Map par = new HashMap();
					par.put("id", mq.get("qid").toString());
					par.put("eid", eid);

					mq.put("mainContent", mm.get("content"));
					mq.put("mfilepath", mm.get("filepath"));
					mq.put("answer",paperService.getAnswerByQID_Version(par));
					allQuestion.add(mq);
				}
			}else {
				Map par = new HashMap();
				par.put("id", mm.get("qid").toString());

				mm.put("mainContent", "");
				mm.put("mfilepath", "");
				mm.put("answer", questionService.getAnswerByQID(par));
				allQuestion.add(mm);
			}
		}
		return createQuestionExcel(allQuestion,gs,answerType);
	}

	private HSSFWorkbook createQuestionExcel(List<Map<String, Object>> allQuestion,int gs,List<Map<String,Object>> answerType ){
		HSSFWorkbook book = new HSSFWorkbook();
		CellStyle style = PoiServiceImpl.getStyle(book);
		try {
			HSSFSheet sheet = book.createSheet("Sheet1");
			sheet.autoSizeColumn(1, true);// 自适应列宽度
			HSSFRow firstRow = sheet.createRow(0);//（从0开始）
			HSSFCell cell0 = firstRow.createCell(0);
			cell0.setCellValue("题目类型");
			cell0.setCellStyle(style);

			HSSFCell cell1 = firstRow.createCell(1);
			cell1.setCellValue("公共题干");
			cell1.setCellStyle(style);

			HSSFCell cell2 = firstRow.createCell(2);
			cell2.setCellValue("串题标识");
			cell2.setCellStyle(style);

			HSSFCell cell3 = firstRow.createCell(3);
			cell3.setCellValue("答案类型");
			cell3.setCellStyle(style);

			HSSFCell cell4 = firstRow.createCell(4);
			cell4.setCellValue("录入者用户名");
			cell4.setCellStyle(style);

			HSSFCell cell5 = firstRow.createCell(5);
			cell5.setCellValue("录入者");
			cell5.setCellStyle(style);

			HSSFCell cell6 = firstRow.createCell(6);
			cell6.setCellValue("审核者用户名");
			cell6.setCellStyle(style);

			HSSFCell cell7 = firstRow.createCell(7);
			cell7.setCellValue("审核者");
			cell7.setCellStyle(style);

			HSSFCell cell8 = firstRow.createCell(8);
			cell8.setCellValue("内容");
			cell8.setCellStyle(style);

			HSSFCell cell9 = firstRow.createCell(9);
			cell9.setCellValue("答案");
			cell9.setCellStyle(style);

			HSSFCell cell10 = firstRow.createCell(10);
			cell10.setCellValue("答案解析");
			cell10.setCellStyle(style);

			HSSFCell cell11 = firstRow.createCell(11);
			cell11.setCellValue("主题词一");
			cell11.setCellStyle(style);

			HSSFCell cell12 = firstRow.createCell(12);
			cell12.setCellValue("主题词二");
			cell12.setCellStyle(style);

			HSSFCell cell13 = firstRow.createCell(13);
			cell13.setCellValue("主题词三");
			cell13.setCellStyle(style);

			HSSFCell cell14 = firstRow.createCell(14);
			cell14.setCellValue("认知");
			cell14.setCellStyle(style);

			HSSFCell cell15 = firstRow.createCell(15);
			cell15.setCellValue("题源");
			cell15.setCellStyle(style);

			HSSFCell cell16 = firstRow.createCell(16);
			cell16.setCellValue("知识点");
			cell16.setCellStyle(style);

			HSSFCell cell17 = firstRow.createCell(17);
			cell17.setCellValue("难度");
			cell17.setCellStyle(style);

			HSSFCell cell18 = firstRow.createCell(18);
			cell18.setCellValue("答题时间（秒）");
			cell18.setCellStyle(style);

			HSSFCell cell19 = firstRow.createCell(19);
			cell19.setCellValue("实测难度");
			cell19.setCellStyle(style);

			HSSFCell cell20 = firstRow.createCell(20);
			cell20.setCellValue("应答人数");
			cell20.setCellStyle(style);

			HSSFCell cell21 = firstRow.createCell(21);
			cell21.setCellValue("区分度");
			cell21.setCellStyle(style);

			HSSFCell cell22 = firstRow.createCell(22);
			cell22.setCellValue("已考次数");
			cell22.setCellStyle(style);

			HSSFCell cell23 = firstRow.createCell(23);
			cell23.setCellValue("公共题干附件");
			cell23.setCellStyle(style);

			HSSFCell cell24 = firstRow.createCell(24);
			cell24.setCellValue("附件路径");
			cell24.setCellStyle(style);
			for(int i = 0; i < 15; i++) {
				HSSFCell cellA = firstRow.createCell(25+i);
				cellA.setCellStyle(style);
				cellA.setCellValue("选项"+(char)(65+i));
			}

			int sum = 0;
			Map<String,Object> mqids = new HashMap<String,Object>();

			StringBuilder out = new StringBuilder();
			StringBuilder err_qids = new StringBuilder();
			Map<String,Object> combin = new HashMap<String,Object>();
			boolean combinFlag = false;
			int extraRownum = 0;
			int selcount = 0;

			for (int i = 0; i < allQuestion.size(); i++) {
				try {
					Map<String,Object> question = allQuestion.get(i);
					int atid = Integer.parseInt(question.get("atid")+"");

					if(combinFlag == true) {

						combinFlag = false;
						HSSFRow row = sheet.createRow(i + 1 + extraRownum);// index：第几行

						HSSFCell _cell0 = row.createCell(0);
						_cell0.setCellValue("combin");
						_cell0.setCellStyle(style);

						if(combin.get("mainContent")!=null) {
							HSSFCell _cell1 = row.createCell(1);
							String mainContent = combin.get("mainContent").toString();
							if(gs==1){
								mainContent=getQuestionTxt(mainContent);
							}
							if(!StringUtils.isEmpty(mainContent) && mainContent.length()>32766) {
								combin.put("mainContent",mainContent.substring(32766));
								mainContent = mainContent.substring(0,32766);
								combinFlag = true;
							}
							_cell1.setCellValue(mainContent);
							_cell1.setCellStyle(style);
						}

						if(combin.get("content")!=null) {
							HSSFCell _cell8 = row.createCell(8);
							String content = combin.get("content").toString();
							if(gs==1){
								content=getQuestionTxt(content);
							}
							if(content.length()>32766) {
								combin.put("content", content.substring(32766));
								content = content.substring(0, 32766);
								combinFlag = true;
							}
							_cell8.setCellValue(content);
							_cell8.setCellStyle(style);
						}

						if(combin.get("acontent")!=null) {
							HSSFCell _cell9 = row.createCell(9);
							String acontent = combin.get("acontent").toString();
							if(acontent.length()>32766) {
								combin.put("acontent", acontent.substring(32766));
								acontent = acontent.substring(0, 32766);
								combinFlag = true;
							}
							_cell9.setCellValue(acontent);
							_cell9.setCellStyle(style);
						}

						if(combin.get("answerexplain")!=null) {
							HSSFCell _cell10 = row.createCell(10);
							String answerexplain = combin.get("answerexplain").toString();
							if(answerexplain.length()>32766) {
								combin.put("answerexplain", answerexplain.substring(32766));
								answerexplain = answerexplain.substring(0, 32766);
								combinFlag = true;
							}
							_cell10.setCellValue(answerexplain);
							_cell10.setCellStyle(style);
						}

						for(int seli=0;seli<selcount;seli++) {
							if(combin.get(seli+"sel")!=null) {
								HSSFCell _cellC = row.createCell(seli+25);
								String sel = combin.get(seli+"sel").toString();
								if(sel.length()>32766) {
									combin.put(seli+"sel", sel.substring(32766));
									sel = sel.substring(0, 32766);
									combinFlag = true;
								}
								_cellC.setCellValue(sel);
								_cellC.setCellStyle(style);
							}
						}

						if(combinFlag == true) {
							extraRownum++;
							i--;
						}
					}else {
						combinFlag = false;

						HSSFRow row = sheet.createRow(i + 1 + extraRownum);// index：第几行

						HSSFCell _cell0 = row.createCell(0);
						_cell0.setCellValue(String.valueOf(question.get("qtname")));
						_cell0.setCellStyle(style);


						HSSFCell _cell1 = row.createCell(1);
						String mainContent = String.valueOf(question.get("mainContent"));
						if(gs==1){
							mainContent=getQuestionTxt(mainContent);
						}
						if(!StringUtils.isEmpty(mainContent) && mainContent.length()>32766) {
							combin.put("mainContent",mainContent.substring(32766));
							mainContent = mainContent.substring(0,32766);
							combinFlag = true;
						}
						_cell1.setCellValue(mainContent);
						_cell1.setCellStyle(style);


						HSSFCell _cell2 = row.createCell(2);
						if ("1".equals(question.get("qtiscon")+"")) {
							String mqid = (String)question.get("mqid");
							if(mqids.get(mqid)==null){
								sum++;
								_cell2.setCellValue(sum+"");
								mqids.put(mqid, sum+"");
							}else{
								_cell2.setCellValue(String.valueOf(mqids.get(mqid)));
							}
						}else{
							_cell2.setCellValue(0);
						}
						_cell2.setCellStyle(style);

						HSSFCell _cell3 = row.createCell(3);
						for(Map at:answerType) {
							int id = Integer.parseInt(at.get("ID").toString());
							if(atid == id) {
								_cell3.setCellValue(at.get("NAME").toString());
								break;
							}
						}

						_cell3.setCellStyle(style);

						HSSFCell _cell4 = row.createCell(4);
						if (!StringUtils.isEmpty(question.get("creatorname"))) {
							_cell4.setCellValue(String.valueOf(question.get("creatorname")));
						}else {
							_cell4.setCellValue("");
						}
						_cell4.setCellStyle(style);

						HSSFCell _cell5 = row.createCell(5);
						if (!StringUtils.isEmpty(question.get("creator"))) {
							_cell5.setCellValue(String.valueOf(question.get("creator")));
						}else if(!StringUtils.isEmpty(question.get("qcreatorname"))){
							_cell5.setCellValue(String.valueOf(question.get("qcreatorname")));
						}
						else{
							_cell5.setCellValue("");
						}
						_cell5.setCellStyle(style);

						HSSFCell _cell6 = row.createCell(6);
						if (!StringUtils.isEmpty(question.get("verifyname"))) {
							_cell6.setCellValue(String.valueOf(question.get("verifyname")));
						}else {
							_cell6.setCellValue("");
						}
						_cell6.setCellStyle(style);

						HSSFCell _cell7 = row.createCell(7);
						if (!StringUtils.isEmpty(question.get("verifyrealname"))) {
							_cell7.setCellValue(String.valueOf(question.get("verifyrealname")));
						}else if(!StringUtils.isEmpty(question.get("qverifyname"))){
							_cell7.setCellValue(String.valueOf(question.get("qverifyname")));
						}else {
							_cell7.setCellValue("");
						}
						_cell7.setCellStyle(style);

						HSSFCell _cell8 = row.createCell(8);
						if(question.get("content")==null) {
							_cell8.setCellValue("");
						}else {
							String content = String.valueOf(question.get("content"));
							if(gs==1){
								content=getQuestionTxt(content);
							}
							if(content.length()>32766) {
								combin.put("content", content.substring(32766));
								content = content.substring(0, 32766);
								combinFlag = true;
							}
							_cell8.setCellValue(content);
						}
						_cell8.setCellStyle(style);

						HSSFCell _cell9 = row.createCell(9);
						ArrayList<Map<String, String>> list = (ArrayList<Map<String, String>>) question.get("answer");
						String rs = "";
						if (atid < 4||atid==8||atid==9) {
							StringBuilder sb = new StringBuilder();
							if (question.get("answerid")==null) {
								rs = "";
							}else {
								String[] rightAid = (question.get("answerid")+"").split(",");
								for(int j=0;j<list.size();j++) {
									HSSFCell _cellC_ = row.createCell(25+j);
									String sel = String.valueOf(list.get(j).get("ACONTENT"));
									if(sel.length()>32766) {
										combin.put((25+j)+"sel", sel.substring(32766));
										sel = sel.substring(0, 32766);
										combinFlag = true;
									}
									_cellC_.setCellValue(sel);
									_cellC_.setCellStyle(style);
									for(int k=0;k<rightAid.length;k++) {
										if (rightAid[k].equals(list.get(j).get("AID"))) {
											sb.append((char)(j+65));
											break;
										}
									}
									selcount = j+1;
								}
							}
							rs = sb.toString();
						}else if (atid == 4) {
							for(int j=0;j<list.size();j++) {
								if (question.get("answerid").equals(list.get(j).get("AID"))) {
									if ("true".equals(list.get(j).get("ACONTENT").toString())) {
										rs = "对";
									}else {
										rs = "错";
									}
								}
							}
						}else {
							for(int j=0;j<list.size();j++) {
								if (question.get("answerid").equals(list.get(j).get("AID"))) {
									rs = list.get(j).get("ACONTENT_6")==null?"":list.get(j).get("ACONTENT_6");
									String acontent = rs;
									if(gs==1){
										acontent=getQuestionTxt(acontent);
									}
									if(acontent.length()>32766) {
										combin.put("acontent", acontent.substring(32766));
										acontent = acontent.substring(0, 32766);
										combinFlag = true;
									}
									_cell9.setCellValue(acontent);
									rs = acontent;
								}
							}
						}
						_cell9.setCellValue(rs);
						_cell9.setCellStyle(style);

						HSSFCell _cell10 = row.createCell(10);
						if (!StringUtils.isEmpty(question.get("answerexplain"))) {
//							_cell10.setCellValue(String.valueOf(question.get("answerexplain")));

							String answerexplain = String.valueOf(question.get("answerexplain"));
							if(answerexplain.length()>32766) {
								combin.put("answerexplain", answerexplain.substring(32766));
								answerexplain = answerexplain.substring(0, 32766);
								combinFlag = true;
							}
							_cell10.setCellValue(answerexplain);


						}else {
							_cell10.setCellValue("");
						}
						_cell10.setCellStyle(style);

						HSSFCell _cell11 = row.createCell(11);
						if (!StringUtils.isEmpty(question.get("t1name"))) {
							_cell11.setCellValue(String.valueOf(question.get("t1name")));
						}else {
							_cell11.setCellValue("");
						}
						_cell11.setCellStyle(style);

						HSSFCell _cell12 = row.createCell(12);
						if (!StringUtils.isEmpty(question.get("t2name"))) {
							_cell12.setCellValue(String.valueOf(question.get("t2name")));
						}else {
							_cell12.setCellValue("");
						}
						_cell12.setCellStyle(style);

						HSSFCell _cell13 = row.createCell(13);
						if (!StringUtils.isEmpty(question.get("t3name"))) {
							_cell13.setCellValue(String.valueOf(question.get("t3name")));
						}else {
							_cell13.setCellValue("");
						}
						_cell13.setCellStyle(style);

						HSSFCell _cell14 = row.createCell(14);
						if (!StringUtils.isEmpty(question.get("coname"))) {
							_cell14.setCellValue(question.get("coname").toString());
						}else {
							_cell14.setCellValue("");
						}
						_cell14.setCellStyle(style);

						HSSFCell _cell15 = row.createCell(15);
						if (!StringUtils.isEmpty(question.get("soname"))) {
							_cell15.setCellValue(question.get("soname").toString());
						}else {
							_cell15.setCellValue("");
						}
						_cell15.setCellStyle(style);

						HSSFCell _cell16 = row.createCell(16);
						if (!StringUtils.isEmpty(question.get("kname"))) {
							_cell16.setCellValue(question.get("kname").toString());
						}else {
							_cell16.setCellValue("");
						}
						_cell16.setCellStyle(style);

						HSSFCell _cell17 = row.createCell(17);
						if (!StringUtils.isEmpty(question.get("dname"))) {
							_cell17.setCellValue(question.get("dname").toString());
						}else {
							_cell17.setCellValue("");
						}
						_cell17.setCellStyle(style);

						HSSFCell _cell18 = row.createCell(18);
						_cell18.setCellValue(String.valueOf(question.get("STTIME")));
						//					int sec = Integer.parseInt(String.valueOf(question.get("STTIME")));
						//					if (sec < 60) {
						//						_cell15.setCellValue(sec+"秒");
						//					}else if (60 <= sec && sec < 3600) {
						//						_cell15.setCellValue((sec/60)+"分");
						//					}else {
						//						_cell15.setCellValue((sec/3600)+"小时");
						//					}
						_cell18.setCellStyle(style);

						HSSFCell _cell19 = row.createCell(19);
						if (!StringUtils.isEmpty(question.get("realdifficulty"))) {
							_cell19.setCellValue(new BigDecimal(String.valueOf(question.get("realdifficulty"))).setScale(3,BigDecimal.ROUND_HALF_UP).doubleValue()+"");
						}else {
							_cell19.setCellValue("");
						}
						_cell19.setCellStyle(style);

						HSSFCell _cell20 = row.createCell(20);
						if (!StringUtils.isEmpty(question.get("qcount"))) {
							_cell20.setCellValue(question.get("qcount")+"");
						}else {
							_cell20.setCellValue("");
						}
						_cell20.setCellStyle(style);

						HSSFCell _cell21 = row.createCell(21);
						if (!StringUtils.isEmpty(question.get("distinction"))) {
							_cell21.setCellValue(new BigDecimal(String.valueOf(question.get("distinction"))).setScale(3,BigDecimal.ROUND_HALF_UP).doubleValue()+"");
						}else {
							_cell21.setCellValue("");
						}
						_cell21.setCellStyle(style);

						HSSFCell _cell22 = row.createCell(22);
						if(!StringUtils.isEmpty(question.get("num"))) {
							_cell22.setCellValue(question.get("num").toString());
						}else {
							_cell22.setCellStyle(style);
						}
						_cell22.setCellStyle(style);

						HSSFCell _cell23 = row.createCell(23);
						_cell23.setCellValue(question.get("mfilepath") == null ? "" : question.get("mfilepath").toString());
						_cell23.setCellStyle(style);

						HSSFCell _cell24 = row.createCell(24);
						if(question.get("filepath")==null) {
							_cell24.setCellValue("");
						}else {
							_cell24.setCellValue(question.get("filepath").toString());
						}
						_cell24.setCellStyle(style);
						if(combinFlag == true) {
							extraRownum++;
							i--;
						}
					}
				}catch (Exception e){
					System.err.println("具体报错：");
					out.append(i+2+",");
					err_qids.append(allQuestion.get(i).get("qid") + ",");
					e.printStackTrace();
					continue;
				}
			}

			if(!"".equals(out.toString())) {
				HSSFCellStyle error = PoiServiceImpl.getErrorStyle(book);
				HSSFRow lastRow = sheet.createRow(allQuestion.size() + 3);
				Cell lastCell0 = lastRow.createCell(0);
				lastCell0.setCellValue("有问题的试题行数为:"+out.toString());
				lastCell0.setCellStyle(error);
				Cell lastCell1 = lastRow.createCell(1);
				lastCell1.setCellValue("有问题的试题id:"+err_qids.toString());
				lastCell1.setCellStyle(error);
			}
			sheet.setDefaultColumnWidth(15);
			sheet.setColumnWidth(1, 80 * 256);
			sheet.setColumnWidth(8, 100 * 256);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return book;
	}

	/*private String getQuestionTxt(String content){
		int index1=content.indexOf("<");
		int e_index1=content.indexOf(">",index1);
		StringBuilder str=new StringBuilder(content);
		if(index1>=0 && e_index1>=0){
			str=str.replace(index1,e_index1+1,"");
		}
		String newContent=str.toString();
		int index3=newContent.indexOf("<");
		int index4=newContent.indexOf(">",index3);
		if(index3>=0 && index4>=0){
			newContent=getQuestionTxt(newContent);
		}
		return newContent.replaceAll("&nbsp;","");
	}*/


	private String getQuestionTxt(String content){
		Pattern p_enter = Pattern.compile("<br/>", Pattern.CASE_INSENSITIVE);//下面三行是将HTML中的换行符<br/>替换成"\n"
		Matcher m_enter = p_enter.matcher(content);
		content = m_enter.replaceAll("%br/%");

		Pattern p_enter2 = Pattern.compile("<br>", Pattern.CASE_INSENSITIVE);//下面三行是将HTML中的换行符<br/>替换成"\n"
		Matcher m_enter2 = p_enter2.matcher(content);
		content = m_enter2.replaceAll("%br/%");

		String REGEX_HTML = "<[^>]+>";
		Pattern p_html = Pattern.compile(REGEX_HTML, Pattern.CASE_INSENSITIVE);//下面三行是过滤html标签
		Matcher m_html = p_html.matcher(content);
		content = m_html.replaceAll("");

		content=content.replaceAll("%br/%","<br/>");
		return content;
	}

	private static HSSFCellStyle getErrorStyle(HSSFWorkbook book){
		// 样式设置
		HSSFCellStyle style = book.createCellStyle();
		style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
		style.setBorderBottom(BorderStyle.THIN);
		style.setBorderLeft(BorderStyle.THIN);
		style.setBorderRight(BorderStyle.THIN);
		style.setBorderTop(BorderStyle.THIN);
		style.setAlignment(HorizontalAlignment.CENTER);
		// 生成一个字体
		HSSFFont font = book.createFont();
		font.setColor(IndexedColors.RED.getIndex());
		font.setFontHeightInPoints((short) 16);
		//font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		// 把字体应用到当前的样式
		style.setFont(font);

		return style;
	}

	private static CellStyle getStyle(Workbook book){
		// 样式设置
		CellStyle style = book.createCellStyle();
		style.setFillForegroundColor(IndexedColors.WHITE.getIndex());
		style.setBorderBottom(BorderStyle.THIN);
		style.setBorderLeft(BorderStyle.THIN);
		style.setBorderRight(BorderStyle.THIN);
		style.setBorderTop(BorderStyle.THIN);
		style.setAlignment(HorizontalAlignment.CENTER);
		// 生成一个字体
		Font font = book.createFont();
		font.setColor(IndexedColors.BLACK.getIndex());
		font.setFontHeightInPoints((short) 12);
		//font.setBoldweight(HSSFFont.BOLDWEIGHT_BOLD);
		// 把字体应用到当前的样式
		style.setFont(font);

		return style;
	}

	private void setRowCellValue(Row row, int cellIndex, String value, CellStyle style){
		Cell cell0 = row.createCell(cellIndex);
		cell0.setCellValue(value);
		cell0.setCellStyle(style);
	}

	@Override
	public HSSFWorkbook exportTheme(String cid) {
		List<Map<String, Object>> res = courseService.getExportThemeExcel(cid);
		HSSFWorkbook workbook = new HSSFWorkbook();
		CellStyle style = PoiServiceImpl.getStyle(workbook);

		HSSFSheet sheet = workbook.createSheet("Sheet1");
		sheet.setDefaultColumnWidth(30);
		sheet.autoSizeColumn(1, true);// 自适应列宽度

		HSSFRow firstRow = sheet.createRow(0);
		HSSFCell cell0 = firstRow.createCell(0);
		cell0.setCellValue("主题词一");
		cell0.setCellStyle(style);

		HSSFCell cell1 = firstRow.createCell(1);
		cell1.setCellValue("主题词二");
		cell1.setCellStyle(style);

		HSSFCell cell2 = firstRow.createCell(2);
		cell2.setCellValue("主题词三");
		cell2.setCellStyle(style);

		for (int i = 0; i < res.size(); i++) {
			HSSFRow row = sheet.createRow(i+1);
			Map m = res.get(i);

			HSSFCell _cell0 = row.createCell(0);
			_cell0.setCellValue(m.get("T1NAME").toString());
			_cell0.setCellStyle(style);

			HSSFCell _cell1 = row.createCell(1);
			if (m.get("T2NAME")!=null) {
				_cell1.setCellValue(m.get("T2NAME").toString());
			}else{
				_cell1.setCellValue("");
			}
			_cell1.setCellStyle(style);

			HSSFCell _cell2 = row.createCell(2);
			if (m.get("T3NAME")!=null) {
				_cell2.setCellValue(m.get("T3NAME").toString());
			}else{
				_cell2.setCellValue("");
			}
			_cell2.setCellStyle(style);
		}
		return workbook;
	}
/*	public static String numToLetter(String param) {
		char[] arr = param.toCharArray();
		String res = "";
		//char mark = ',';
        for(int i=0; i<arr.length; i++){
        	if(arr[i] == ','){
        		res += ",";
        	}else{
        		res += ((char)(Character.getNumericValue(arr[i]) + 65));
        	}
        }
        return res;
    }  */

	@Override
	public HSSFWorkbook importQuestionMonel(String cid) {
		// TODO Auto-generated method stub
		HSSFWorkbook book = new HSSFWorkbook();
		CellStyle style = PoiServiceImpl.getStyle(book);
		try {
			HSSFSheet sheet = book.createSheet("Sheet1");
			//sheet.setDefaultColumnWidth(35);
			sheet.autoSizeColumn(1, true);// 自适应列宽度
			HSSFRow firstRow = sheet.createRow(0);//（从0开始）
			HSSFCell cell0 = firstRow.createCell(0);
			cell0.setCellValue("题型");
			cell0.setCellStyle(style);

			HSSFCell cell1 = firstRow.createCell(1);
			cell1.setCellValue("公共题干");
			cell1.setCellStyle(style);

			HSSFCell cell2 = firstRow.createCell(2);
			cell2.setCellValue("录入者");
			cell2.setCellStyle(style);

			HSSFCell cell3 = firstRow.createCell(3);
			cell3.setCellValue("内容");
			cell3.setCellStyle(style);

			HSSFCell cell4 = firstRow.createCell(4);
			cell4.setCellValue("正确答案");
			cell4.setCellStyle(style);

			HSSFCell cell5 = firstRow.createCell(5);
			cell5.setCellValue("答案解析");
			cell5.setCellStyle(style);

			HSSFCell cell6 = firstRow.createCell(6);
			cell6.setCellValue("主题词一");
			cell6.setCellStyle(style);

			HSSFCell cell7 = firstRow.createCell(7);
			cell7.setCellValue("主题词二");
			cell7.setCellStyle(style);

			HSSFCell cell8 = firstRow.createCell(8);
			cell8.setCellValue("主题词三");
			cell8.setCellStyle(style);

			HSSFCell cell9 = firstRow.createCell(9);
			cell9.setCellValue("认知");
			cell9.setCellStyle(style);

			HSSFCell cell10 = firstRow.createCell(10);
			cell10.setCellValue("题源");
			cell10.setCellStyle(style);

			HSSFCell cell11 = firstRow.createCell(11);
			cell11.setCellValue("适用层次");
			cell11.setCellStyle(style);

			HSSFCell cell12 = firstRow.createCell(12);
			cell12.setCellValue("知识点分布");
			cell12.setCellStyle(style);

			HSSFCell cell13 = firstRow.createCell(13);
			cell13.setCellValue("答题时间");
			cell13.setCellStyle(style);

			HSSFCell cell14 = firstRow.createCell(14);
			cell14.setCellValue("难度");
			cell14.setCellStyle(style);

			HSSFCell cell15 = firstRow.createCell(15);
			cell15.setCellValue("实测难度");
			cell15.setCellStyle(style);

			HSSFCell cell16 = firstRow.createCell(16);
			cell16.setCellValue("已考次数");
			cell16.setCellStyle(style);

			HSSFCell cell17 = firstRow.createCell(17);
			cell17.setCellValue("应答人数");
			cell17.setCellStyle(style);

			HSSFCell cell18 = firstRow.createCell(18);
			cell18.setCellValue("区分度");
			cell18.setCellStyle(style);

/*			HSSFCell cell19 = firstRow.createCell(19);
			cell19.setCellValue("答案解析");
			cell19.setCellStyle(style);*/

			HSSFCell cell19 = firstRow.createCell(19);
			cell19.setCellValue("试题答案");
			cell19.setCellStyle(style);

			HSSFRow row = sheet.createRow(1);

			HSSFCell _cell1_0 = row.createCell(0);
			_cell1_0.setCellValue("");
			_cell1_0.setCellStyle(style);
			List<Map<String,Object>> questionType = courseService.selectEditQuestionType(cid);
			String[] qt = new String[questionType.size()];
			for(int i=0;i<questionType.size();i++){
				qt[i] = (String) questionType.get(i).get("NAME");
			}
			HSSFDataValidation qt_validation_list = setDataValidationList(qt,(short)1,(short)1,(short)0,(short)0);
			sheet.addValidationData(qt_validation_list);

			HSSFCell _cell1_1 = row.createCell(1);
			_cell1_1.setCellValue("串题提干，非串题留空");
			_cell1_1.setCellStyle(style);

			HSSFCell _cell1_2 = row.createCell(2);
			_cell1_2.setCellValue("录入者名字");
			_cell1_2.setCellStyle(style);

			HSSFCell _cell1_3 = row.createCell(3);
			_cell1_3.setCellValue("试题问题");
			_cell1_3.setCellStyle(style);

			HSSFCell _cell1_4 = row.createCell(4);
			_cell1_4.setCellValue("正确答案，选择题答案为ABCDE，判断题答案为对、错，主观题答案输入文字即可");
			_cell1_4.setCellStyle(style);

			HSSFCell _cell1_5 = row.createCell(5);
			_cell1_5.setCellValue("");
			_cell1_5.setCellStyle(style);

			HSSFCell _cell1_6 = row.createCell(6);
			_cell1_6.setCellValue("");
			_cell1_6.setCellStyle(style);
			List<Map<String,Object>> theme = courseService.selectTheme(cid);
			String[] t1 = new String[theme.size()];
			for(int i=0;i<theme.size();i++){
				t1[i] = (String) theme.get(i).get("NAME");
			}
			HSSFDataValidation t1_validation_list = setDataValidationList(t1,(short)1,(short)1,(short)6,(short)6);
			sheet.addValidationData(t1_validation_list);

			HSSFCell _cell1_7 = row.createCell(7);
			_cell1_7.setCellValue("");
			_cell1_7.setCellStyle(style);
			List<Map<String,Object>> theme2 = courseService.selectTheme2(cid);
			String[] t2 = new String[theme2.size()];
			for(int i=0;i<theme2.size();i++){
				t2[i] = (String) theme2.get(i).get("NAME");
			}
			HSSFDataValidation t2_validation_list = setDataValidationList(t2,(short)1,(short)1,(short)7,(short)7);
			sheet.addValidationData(t2_validation_list);

			HSSFCell _cell1_8 = row.createCell(8);
			_cell1_8.setCellValue("");
			_cell1_8.setCellStyle(style);
			List<Map<String,Object>> theme3 = courseService.selectTheme3(cid);
			String[] t3 = new String[theme3.size()];
			for(int i=0;i<theme3.size();i++){
				t3[i] = (String) theme3.get(i).get("NAME");
			}
			HSSFDataValidation t3_validation_list = setDataValidationList(t3,(short)1,(short)1,(short)8,(short)8);
			sheet.addValidationData(t3_validation_list);

			HSSFCell _cell1_9 = row.createCell(9);
			_cell1_9.setCellValue("");
			_cell1_9.setCellStyle(style);
			List<Map<String,Object>> cognition = courseService.selectEditCognition(cid);
			String[] cog = new String[cognition.size()];
			for(int i=0;i<cognition.size();i++){
				cog[i] = (String) cognition.get(i).get("NAME");
			}
			HSSFDataValidation cog_validation_list = setDataValidationList(cog,(short)1,(short)1,(short)9,(short)9);
			sheet.addValidationData(cog_validation_list);

			HSSFCell _cell1_10 = row.createCell(10);
			_cell1_10.setCellValue("");
			_cell1_10.setCellStyle(style);
			List<Map<String,Object>> source = courseService.selectEditSource(cid);
			String[] so = new String[source.size()];
			for(int i=0;i<source.size();i++){
				so[i] = (String) source.get(i).get("NAME");
			}
			HSSFDataValidation so_validation_list = setDataValidationList(so,(short)1,(short)1,(short)10,(short)10);
			sheet.addValidationData(so_validation_list);

			HSSFCell _cell1_11 = row.createCell(11);
			_cell1_11.setCellValue("");
			_cell1_11.setCellStyle(style);
			List<Map<String,Object>> arrangement = courseService.selectEditArrangement(cid);
			String[] arr = new String[arrangement.size()];
			for(int i=0;i<arrangement.size();i++){
				arr[i] = (String) arrangement.get(i).get("NAME");
			}
			HSSFDataValidation arr_validation_list = setDataValidationList(arr,(short)1,(short)1,(short)11,(short)11);
			sheet.addValidationData(arr_validation_list);

			HSSFCell _cell1_12 = row.createCell(12);
			_cell1_12.setCellValue("");
			_cell1_12.setCellStyle(style);
			List<Map<String,Object>> knowledge = courseService.selectEditKnowledge(cid);
			String[] know = new String[knowledge.size()];
			for(int i=0;i<knowledge.size();i++){
				know[i] = (String) knowledge.get(i).get("NAME");
			}
			HSSFDataValidation know_validation_list = setDataValidationList(know,(short)1,(short)1,(short)12,(short)12);
			sheet.addValidationData(know_validation_list);

			HSSFCell _cell1_13 = row.createCell(13);
			_cell1_13.setCellValue("");
			_cell1_13.setCellStyle(style);
			String[] time = {"15秒","30秒","45秒","1分","2分","3分","4分","5分"};
			HSSFDataValidation time_validation_list = setDataValidationList(time,(short)1,(short)1,(short)13,(short)13);
			sheet.addValidationData(time_validation_list);


			HSSFCell _cell1_14 = row.createCell(14);
			_cell1_14.setCellValue("");
			_cell1_14.setCellStyle(style);
			List<Map<String,Object>> difficulty = courseService.selectEditDifficulty(cid);
			String[] diff = new String[difficulty.size()];
			for(int i=0;i<difficulty.size();i++){
				diff[i] = (String) difficulty.get(i).get("NAME");
			}
			HSSFDataValidation diff_validation_list = setDataValidationList(diff,(short)1,(short)1,(short)14,(short)14);
			sheet.addValidationData(diff_validation_list);

			HSSFCell _cell1_15 = row.createCell(15);
			_cell1_15.setCellValue("0");
			_cell1_15.setCellStyle(style);

			HSSFCell _cell1_16 = row.createCell(16);
			_cell1_16.setCellValue("0");
			_cell1_16.setCellStyle(style);

			HSSFCell _cell1_17 = row.createCell(17);
			_cell1_17.setCellValue("0");
			_cell1_17.setCellStyle(style);

			HSSFCell _cell1_18 = row.createCell(18);
			_cell1_18.setCellValue("0");
			_cell1_18.setCellStyle(style);

			HSSFCell _cell1_19 = row.createCell(19);
			_cell1_19.setCellValue("选项1");
			_cell1_19.setCellStyle(style);

			HSSFCell _cell1_20 = row.createCell(20);
			_cell1_20.setCellValue("选项2");
			_cell1_20.setCellStyle(style);

			HSSFCell _cell1_21 = row.createCell(21);
			_cell1_21.setCellValue("选项3");
			_cell1_21.setCellStyle(style);

			HSSFCell _cell1_22 = row.createCell(22);
			_cell1_22.setCellValue("选项4");
			_cell1_22.setCellStyle(style);

			HSSFCell _cell1_23 = row.createCell(23);
			_cell1_23.setCellValue("选项5");
			_cell1_23.setCellStyle(style);

		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return book;
	}

	public HSSFDataValidation setDataValidationList(String[] textlist,short firstRow,short firstCol,short endRow, short endCol){
		//加载下拉列表内容
		DVConstraint constraint=DVConstraint.createExplicitListConstraint(textlist);
		//设置数据有效性加载在哪个单元格上。

		//四个参数分别是：起始行、终止行、起始列、终止列
		CellRangeAddressList regions=new CellRangeAddressList(firstRow,firstCol,endRow,endCol);
		//数据有效性对象
		HSSFDataValidation data_validation_list = new HSSFDataValidation(regions, constraint);

		return data_validation_list;
	}

	@Override
	public HSSFWorkbook exportLogs(String time) {
		List<Map<String, Object>> res = systemService.getLogsListBefore(time);
		HSSFWorkbook workbook = new HSSFWorkbook();
		CellStyle style = PoiServiceImpl.getStyle(workbook);

		HSSFSheet sheet = workbook.createSheet("Sheet1");
		/*sheet.setDefaultColumnWidth(35);*/
		sheet.autoSizeColumn(1, true);// 自适应列宽度

		HSSFRow firstRow = sheet.createRow(0);
		HSSFCell cell0 = firstRow.createCell(0);
		cell0.setCellValue("序号");
		cell0.setCellStyle(style);

		HSSFCell cell1 = firstRow.createCell(1);
		cell1.setCellValue("用户名");
		cell1.setCellStyle(style);

		HSSFCell cell2 = firstRow.createCell(2);
		cell2.setCellValue("ip地址");
		cell2.setCellStyle(style);

		HSSFCell cell3 = firstRow.createCell(3);
		cell3.setCellValue("操作内容");
		cell3.setCellStyle(style);

		for (int i = 0; i < res.size(); i++) {
			HSSFRow row = sheet.createRow(i+1);
			Map m = res.get(i);

			HSSFCell _cell0 = row.createCell(0);
			_cell0.setCellValue(i+1);
			_cell0.setCellStyle(style);

			HSSFCell _cell1 = row.createCell(1);
			_cell1.setCellValue(String.valueOf(m.get("NAME")));
			_cell1.setCellStyle(style);

			HSSFCell _cell2 = row.createCell(2);
			_cell2.setCellValue(String.valueOf(m.get("IP")));
			_cell2.setCellStyle(style);

			HSSFCell _cell3 = row.createCell(3);
			_cell3.setCellValue(String.valueOf(m.get("CONTENT")));
			_cell3.setCellStyle(style);
		}
		return workbook;
	}

	@Override
	public HSSFWorkbook exportCourse(Map param){
		List<Map<String, Object>> res =  courseService.getCourse4Export(param);

		HSSFWorkbook book = new HSSFWorkbook();
		CellStyle style = PoiServiceImpl.getStyle(book);
		try {
			HSSFSheet sheet = book.createSheet("Sheet1");
			sheet.setDefaultColumnWidth(30);
			sheet.autoSizeColumn(1, true);// 自适应列宽度
			HSSFRow firstRow = sheet.createRow(0);//（从0开始）
			HSSFCell cell0 = firstRow.createCell(0);
			cell0.setCellValue("课程名称");
			cell0.setCellStyle(style);

			HSSFCell cell1 = firstRow.createCell(1);
			cell1.setCellValue("英文名称");
			cell1.setCellStyle(style);

			HSSFCell cell2 = firstRow.createCell(2);
			cell2.setCellValue("课程代码");
			cell2.setCellStyle(style);


			HSSFCell cell4 = firstRow.createCell(3);
			cell4.setCellValue("授课单位");
			cell4.setCellStyle(style);

			HSSFCell cell5 = firstRow.createCell(4);
			cell5.setCellValue("所属科室");
			cell5.setCellStyle(style);

			HSSFCell cell6 = firstRow.createCell(5);
			cell6.setCellValue("题目总数");
			cell6.setCellStyle(style);

			HSSFCell cell7 = firstRow.createCell(6);
			cell7.setCellValue("最大学时数");
			cell7.setCellStyle(style);

			HSSFCell cell8 = firstRow.createCell(7);
			cell8.setCellValue("适用专业");
			cell8.setCellStyle(style);

			HSSFCell cell9 = firstRow.createCell(8);
			cell9.setCellValue("适用层次");
			cell9.setCellStyle(style);

			HSSFCell cell10 = firstRow.createCell(9);
			cell10.setCellValue("创建人");
			cell10.setCellStyle(style);


			for (int i = 0; i < res.size(); i++) {
				Map<String,Object> course = res.get(i);
				String cid=String.valueOf(course.get("CID"));

				HSSFRow row = sheet.createRow(i + 1);// index：第几行
				HSSFCell _cell0 = row.createCell(0);
				_cell0.setCellValue(String.valueOf(course.get("NAME_C")));
				_cell0.setCellStyle(style);

				HSSFCell _cell1 = row.createCell(1);
				if (!StringUtils.isEmpty(course.get("NAME_E"))){
					_cell1.setCellValue(String.valueOf(course.get("NAME_E")));
				}else{
					_cell1.setCellValue("");
				}
				_cell1.setCellStyle(style);

				HSSFCell _cell2 = row.createCell(2);
				if (!StringUtils.isEmpty(course.get("CODE"))){
					_cell2.setCellValue(String.valueOf(course.get("CODE")));
				}else{
					_cell2.setCellValue("");
				}
				_cell2.setCellStyle(style);

				HSSFCell _cell3 = row.createCell(3);
				if (!StringUtils.isEmpty(course.get("UNAME"))){
					_cell3.setCellValue(String.valueOf(course.get("UNAME")));
				}else{
					_cell3.setCellValue("");
				}
				_cell3.setCellStyle(style);

				HSSFCell _cell4 = row.createCell(4);
				if (!StringUtils.isEmpty(course.get("DNAME"))){
					_cell4.setCellValue(String.valueOf(course.get("DNAME")));
				}else{
					_cell4.setCellValue("");
				}
				_cell4.setCellStyle(style);

				HSSFCell _cell5 = row.createCell(5);
				_cell5.setCellValue(String.valueOf(course.get("QCOUNT")));
				_cell5.setCellStyle(style);

				HSSFCell _cell6 = row.createCell(6);
				_cell6.setCellValue(String.valueOf(course.get("PERIOD")));
				_cell6.setCellStyle(style);

				HSSFCell _cell7 = row.createCell(7);
				List<Map<String,Object>> specialtyList=courseService.selectSpecialty(cid);
				StringBuilder sp=new StringBuilder();
				if(specialtyList!=null && specialtyList.size()>0){
					for(Map<String,Object> sm:specialtyList){
						sp.append(sm.get("SPNAME")+",");
					}
					_cell7.setCellValue(sp.substring(0, sp.length()-1));
				}
				_cell7.setCellStyle(style);

				List<Map<String,Object>> arrangementList=courseService.selectArrangement(cid);
				StringBuilder sab=new StringBuilder();
				if(arrangementList!=null && arrangementList.size()>0){
					for(Map<String,Object> sm:arrangementList){
						sab.append(sm.get("ANAME")+",");
					}
				}
				HSSFCell _cell8 = row.createCell(8);
				_cell8.setCellValue(sab.substring(0, sab.length()-1));
				_cell8.setCellStyle(style);

				HSSFCell _cell9 = row.createCell(9);
				if (!StringUtils.isEmpty(course.get("CREATOR"))){
					_cell9.setCellValue(String.valueOf(course.get("CREATOR")));
				}else{
					_cell9.setCellValue("");
				}
				_cell9.setCellStyle(style);
			}
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return book;
	}

	@Override
	public Map importQuestionToPaper(MultipartFile mFile, String cids, String eid){
		int num=0;
		long startTime = System.currentTimeMillis();
		List<Map<String,Object>> answerType = commonService.getAnswerTypeList();
		Map<String, Map<String,Object>> atMap = Utils.listToMap(answerType, "NAME");
		List<Map<String,Object>> courseList = courseService.getCourseNameById(cids.split(","));
		String cid = null;
		Map rtn = new HashMap();
		String fileName = mFile.getOriginalFilename();
		String filePath = "uploadFile/excel/question/" + DateFormatUtils.getNowDay() + fileName;

		Path target = Paths.get(WebFilePath.getProjectPath(), filePath);
		try {
			Files.deleteIfExists(target);
			Files.createDirectories(target.getParent());
			mFile.transferTo(target.toFile());
		} catch (IOException e) {
			throw new RuntimeException(e);
		}

		try (InputStream is = Files.newInputStream(target);
			 Workbook wb = WorkbookFactory.create(is)) {

			Sheet sheet =  wb.getSheetAt(0);
			Row row = sheet.getRow(0);

			/*导入试题-开始*/
			int rowNum=sheet.getLastRowNum();

			List<Map<String,Object>> questiontypepool=new ArrayList<>();
			List<Map<String, Object>> courseQT;
			big:for(int i=1;i<=rowNum;i++){
				row=sheet.getRow(i);
				/*Double score = 0.0; //题目分数
	            if(!StringUtils.isEmpty(row.getCell(2).toString().trim())) {
	                String val = row.getCell(2).toString().trim();
	                Matcher isNums = Pattern.compile("^\\d+(\\.\\d+)?$").matcher(val);
	                if(isNums.matches()) {
	                	score = Double.parseDouble(val);
	                }
	            }*/
				Map<String,Object> param=new HashMap<>();
				param.put("EID", eid);
				cid=null;
				String cnameInExcel = getCellFormatIntOrString(row.getCell(0)).trim();
				String cell2 = getCellFormatIntOrString(row.getCell(1)).trim();
				String cell3 = getCellFormatIntOrString(row.getCell(2)).trim();
				if("".equals(cnameInExcel) && "".equals(cell2) && "".equals(cell3)){
					continue ;
				}
				for(int ii=0;ii<courseList.size();ii++){
					if(courseList.get(ii).get("NAME_C").equals(cnameInExcel)){
						cid=courseList.get(ii).get("ID").toString();
					}
				}

				if(cid==null || cid.equals("")){
					rtn.put("code", -1);
					rtn.put("message", "课程“"+getCellFormatIntOrString(row.getCell(0)).trim()+"”不存在，先在题库中补充该课程后组卷。");
					long endTime = System.currentTimeMillis();
					rtn.put("times", (float)(endTime-startTime));
					return rtn;
				}

				courseQT=courseService.getCourseQuestionType(cid);
				String qtname = getCellFormatIntOrString(row.getCell(1)).trim();

				String qtid = null;
				String qtdesc = null;
				String atid = null;
				String e_qtname=null;
				String e_qtdesc=null;
				String iscon = null;
				List<Map<String,Object>> qt_temp=new ArrayList<>();//存放有几个同名题型的qtid和atid
				for(Map m:courseQT) { //判断该课程中有没有该题型
					if(m.get("QTNAME")!=null && qtname.equals(m.get("QTNAME").toString().trim())) {
						qtid = m.get("QTID").toString();
						atid = m.get("ATID").toString();
						iscon = m.get("ISCON").toString();
						Map mm = new HashMap<>();
						mm.put("qtid", qtid);
						mm.put("atid", atid);
						mm.put("iscon", iscon);
						if(m.get("QTDESC")!=null){
							qtdesc = m.get("QTDESC").toString();
						}
						if(m.get("E_QTNAME")!=null){
							e_qtname = m.get("E_QTNAME").toString();
						}
						if(m.get("E_QTDESC")!=null){
							e_qtdesc = m.get("E_QTDESC").toString();
						}
						qt_temp.add(mm); //一般只执行一次，除非有课程有同名题型
					}
				}

				if(qt_temp.size()==0) {//如果题型不存在
					rtn.put("code", -1);
					rtn.put("message", "题目类型“"+qtname+"”不存在，先补充该答案类型。");
					long endTime = System.currentTimeMillis();
					rtn.put("times", (float)(endTime-startTime));
					return rtn;
				}

				int qtiscon=0; //是否串题
				String maincontent=getCellFormatIntOrString(row.getCell(3));
				if(maincontent!=null&&!"".equals(maincontent)){
					qtiscon=1;
				}

				boolean qtNotExist=true;
				String atname=getCellFormatIntOrString(row.getCell(5)).trim();
				Map<String,Object> atNow = atMap.get(atname);
				for(Map at_qt:qt_temp) { //判断所有同名题型中有没有相对应的 atid和iscon
					if(at_qt.get("atid").equals(atNow.get("ID")) && at_qt.get("iscon").equals(String.valueOf(qtiscon))) {
						param.put("ATID", atNow.get("ID"));
						param.put("QTID_Q", at_qt.get("qtid"));
						param.put("ISCON", at_qt.get("iscon"));
						param.put("QTID", at_qt.get("qtid")+"_"+atNow.get("ID")+"_"+at_qt.get("iscon"));
						qtNotExist=false;
						break;
					}
				}

				if(qtNotExist){
					rtn.put("code", -1);
					rtn.put("message", "答案类型“"+atname+"”或串题类型与对应的题目类型“"+qtname+"”不存在，确认该题型与答案类型是否匹配。");
					long endTime = System.currentTimeMillis();
					rtn.put("times", (float)(endTime-startTime));
					return rtn;
				}

				if(param.get("ATID")==null||"".equals(param.get("ATID"))){ //如果答案不存在
					rtn.put("code", -1);
					rtn.put("message", "答案类型“"+atname+"”不存在，先补充该答案类型");
					long endTime = System.currentTimeMillis();
					rtn.put("times", (float)(endTime-startTime));
					return rtn;
				}

				param.put("QTNAME", qtname);
				//param.put("score", Integer.parseInt(getCellFormatIntOrString(row.getCell(2)).trim()));
				param.put("QTDESC", qtdesc);
				param.put("E_QTDESC", e_qtdesc);
				param.put("E_QTNAME", e_qtname);
				param.put("SXB", 0);

				if(questiontypepool.size()>0){
					boolean countFlag = true;
					for(int j=0;j<questiontypepool.size();j++){
						if(String.valueOf(questiontypepool.get(j).get("QTID_Q")).equals(param.get("QTID_Q"))){
							int qcount=1;
							if(questiontypepool.get(j).get("QCOUNT")!=null && !questiontypepool.get(j).get("QCOUNT").equals("")){
								qcount = Integer.parseInt(questiontypepool.get(j).get("QCOUNT").toString())+1; //题型已存在，题型数量+1
							}
							param.put("QCOUNT", qcount);
							questiontypepool.remove(j);
							questiontypepool.add(param);
							continue big;
						}
					}
					if(countFlag){
						param.put("QCOUNT", 1);//没有查找到该题型时，该题型时数量为1
					}
				}else{
					param.put("QCOUNT", 1); //题型表为空时，该题型数量为1
				}

				questiontypepool.add(param);
			}

			List<Map<String, Object>> existQtid = query("resources.mappers.paper.getQtidFromExampaperQuestionType", eid);
			int qtorder=existQtid.size();

			for(Map q: questiontypepool){

				boolean flag = false;//exampaper_questiontype有题型不存在
				for(Map qq: existQtid) { //长度为0的existQtid不会报空指针异常
					if((String.valueOf(qq.get("QTID"))).equals(String.valueOf(q.get("QTID")))) {
						q.put("QCOUNT", Integer.parseInt(q.get("QCOUNT").toString())+Integer.parseInt(qq.get("QUESTIONCOUNT").toString()));
						q.put("SCORE", Double.parseDouble(qq.get("SCORE").toString()));
						flag = true;
						break;
					}
				}
				if(flag==true) {//此题型存在
					update("resources.mappers.paper.updateExampaperQuestiontype", q);
				}else {//此题型不存在
					q.put("QTORDER", qtorder++);
					insert("resources.mappers.paper.insertExampaperQuestionType", q);
				}
			}

			//先扫描xls文件是否有不存在的主题词，有则添加到数据库
			List<Map<String, Object>> themePool = new ArrayList<>();
			for(int i = 1; i<= rowNum; i++) {
				row = sheet.getRow(i);

				for(int ii=0;ii<courseList.size();ii++){
					if(courseList.get(ii).get("NAME_C").equals(getCellFormatIntOrString(row.getCell(0)).trim())){
						cid=courseList.get(ii).get("ID").toString();
					}
				}

				String t1name = getCellFormatIntOrString(row.getCell(13)).trim(); //主题词一
				String t2name = getCellFormatIntOrString(row.getCell(14)).trim(); //主题词二
				String t3name = getCellFormatIntOrString(row.getCell(15)).trim(); //主题词三

				if(!StringUtils.isEmpty(t1name)) {
					Map t1par = new HashMap();
					t1par.put("th_name", t1name);
					t1par.put("th_pid", "-1");
					t1par.put("th_level", 1);
					t1par.put("th_cid", cid);
					questionService.insertTheme4ImportQuestion(t1par);
					addIntoPool(themePool,t1par);
					if(!StringUtils.isEmpty(t2name)) {
						Map t2par = new HashMap();
						t2par.put("th_name", t2name);
						t2par.put("th_pid", t1par.get("id").toString());
						t2par.put("th_level", 2);
						t2par.put("th_cid", cid);
						questionService.insertTheme4ImportQuestion(t2par);
						addIntoPool(themePool,t2par);
						if(!StringUtils.isEmpty(t3name)) {
							Map t3par = new HashMap();
							t3par.put("th_name", t3name);
							t3par.put("th_pid", t2par.get("id").toString());
							t3par.put("th_level", 3);
							t3par.put("th_cid", cid);
							questionService.insertTheme4ImportQuestion(t3par);
							addIntoPool(themePool,t3par);
						}
					}
				}
			}

			//不存在的主题词已经插入数据库，表格内所有主题词都在themePool，需要主题词直接读取此List便可
			//获得cognition列表
			List<Map<String, Object>> cognitionList = courseService.getCourseCognition(cid);
			//获得source列表
			List<Map<String, Object>> sourceList = courseService.getCourseSource(cid);
			//获得knowledge列表
			List<Map<String, Object>> knowledgeList = courseService.getCourseKnowledge(cid);
			//获得difficulty列表
			List<Map<String, Object>> difficultyList = courseService.getCourseDifficulty(cid);
			//获得教师列表
			List<User> teacherList = userService.getAllTeacher();

			int len = 20;//每次插入多小条
			int time = rowNum % len == 0 ? rowNum / len : rowNum / len + 1;

			int ct=0;
			String mqid = "";
			int th = paperService.getMaxThFromExampaperquestion(eid) + 1;
			for(int tt = 0; tt < time; tt++) {
				List<Map<String, Object>> insertQuestionPool = new ArrayList<Map<String, Object>>();
				//创建一个List作为暂时存储answer的池
				List<Map<String, Object>> answerPool = new ArrayList<Map<String, Object>>();

				int maxSize = (tt + 1) * len > rowNum ? rowNum : (tt + 1) * len;
				try {
					for(int i= (tt * len) + 1; i <= maxSize; i++) {

						row = sheet.getRow(i);

						String mainContent = getCellFormatIntOrString(row.getCell(3));
						String content = getCellFormatIntOrString(row.getCell(10)).trim();
						String tcontent = getCellFormatIntOrString(row.getCell(11)).trim();

						String qtname = getCellFormatIntOrString(row.getCell(1)).trim();
						String qtid = "";
						String atname = getCellFormatIntOrString(row.getCell(5)).trim();

						int atid = Utils.changeObjToInt(atMap.get(atname).get("ID"));

						int iscon = 0;
						String maincontent=getCellFormatIntOrString(row.getCell(3));
						if(maincontent!=null&&!"".equals(maincontent)){
							iscon=1;
						}

						for(Map m:questiontypepool) {
							if(qtname.equals(m.get("QTNAME").toString().trim())
									&& m.get("ATID").equals(String.valueOf(atid))
									&& m.get("ISCON").equals(String.valueOf(iscon))) {
								qtid = m.get("QTID_Q").toString();
								atid = Integer.parseInt(m.get("ATID").toString());
								iscon = Integer.parseInt(m.get("ISCON").toString());
								break;
							}
						}

						//录入者用户名 用户id
						String uid = "";
						String creatorUsername = getCellFormatIntOrString(row.getCell(6)).trim();
						String creatorName = getCellFormatIntOrString(row.getCell(7)).trim();
						if(creatorName.isEmpty()){
							creatorName="";
						}
						if(!StringUtils.isEmpty(creatorUsername)) {
							for(User u:teacherList) {
								if(creatorUsername.equals(u.getUsername())) {
									uid = u.getId();
									creatorName=u.getRealname();
									break;
								}
							}
						}
						if(StringUtils.isEmpty(uid)&&(!StringUtils.isEmpty(creatorName))){
							//如果想在用户名不存在，实名存在的情况下只导入实名，，则将上面这个if的uid换为creatorUsername
							List<Map<String, Object>> tryUserList = userService.findByRealname(creatorName);
							if(tryUserList.size()==1){
								uid=tryUserList.get(0).get("ID").toString();
							}else if(tryUserList.size()>1){
								//如果有多个同名的教师账户名，选择登录时间最新的那个
								int sortUserNum=tryUserList.size(),tmp=0,b;
								Long iTime=0L;
								Long latestTime=0L;
								if(userService.findOne(tryUserList.get(0).get("ID").toString()).getLoginTime()!=null){
									iTime=userService.findOne(tryUserList.get(0).get("ID").toString()).getLoginTime().getTime();
								}
								for(b=1;b<sortUserNum;b++){
									if(userService.findOne(tryUserList.get(b).get("ID").toString()).getLoginTime()!=null){
										latestTime=userService.findOne(tryUserList.get(b).get("ID").toString()).getLoginTime().getTime();
									}else{
										continue;
									}
									if(latestTime>iTime){
										iTime=latestTime;
										tmp=b;
									}
								}
								uid=tryUserList.get(tmp).get("ID").toString();
							}
						}

						//审核者用户名 用户id
						String vid = "";
						String verifyUsername = getCellFormatIntOrString(row.getCell(8)).trim();
						String verifyName = getCellFormatIntOrString(row.getCell(9)).trim();
						if(verifyName.isEmpty()){
							verifyName="";
						}
						if(!StringUtils.isEmpty(verifyUsername)) {
							for(User v:teacherList) {
								if(verifyUsername.equals(v.getUsername())) {
									vid = v.getId();
									verifyName=v.getRealname();
									break;
								}
							}
						}
						if(StringUtils.isEmpty(vid)&&(!StringUtils.isEmpty(verifyName))){
							//如果想在用户名不存在，实名存在的情况下只导入实名，则将上面这个if的vid换为verifyUsername
							List<Map<String, Object>> tryUserList = userService.findByRealname(verifyName);
							if(tryUserList.size()==1){
								vid=tryUserList.get(0).get("ID").toString();
							}else if(tryUserList.size()>1){
								//如果有多个同名的教师账户名，选择登录时间最新的那个
								int sortUserNum=tryUserList.size(),tmp=0,b;
								Long latestTime=0L;
								Long iTime=0L;
								if(userService.findOne(tryUserList.get(0).get("ID").toString()).getLoginTime()!=null){
									iTime=userService.findOne(tryUserList.get(0).get("ID").toString()).getLoginTime().getTime();
								}
								for(b=1;b<sortUserNum;b++){
									if(userService.findOne(tryUserList.get(b).get("ID").toString()).getLoginTime()!=null){
										latestTime=userService.findOne(tryUserList.get(b).get("ID").toString()).getLoginTime().getTime();
									}else{
										continue;
									}
									if(latestTime>iTime){
										iTime=latestTime;
										tmp=b;
									}
								}
								vid=tryUserList.get(tmp).get("ID").toString();
							}
						}


						//主题词
						String theme1 = getCellFormatIntOrString(row.getCell(13)).trim();
						String theme2 = getCellFormatIntOrString(row.getCell(14)).trim();
						String theme3 = getCellFormatIntOrString(row.getCell(15)).trim();

						String th1id = "";
						String th2id = "";
						String th3id = "";
						if(!StringUtils.isEmpty(theme1)) {
							th1id = findThemeIDByName(themePool, theme1, "-1");
							if(!StringUtils.isEmpty(theme2)) {
								th2id = findThemeIDByName(themePool, theme2, th1id);
								if(!StringUtils.isEmpty(theme3)) {
									th3id = findThemeIDByName(themePool, theme3, th2id);
								}
							}
						}

						String cognition = getCellFormatIntOrString(row.getCell(16)); //认知
						String source = getCellFormatIntOrString(row.getCell(17)); //题源
						String knowledge = getCellFormatIntOrString(row.getCell(18)); //知识点
						String difficulty = getCellFormatIntOrString(row.getCell(19)); //难度

						String cognitionid=findParamInList(cognitionList, cognition);
						if(cognitionid==null || "".equals(cognitionid)){
							cognitionid = "1";
						}

						String sourceid= findParamInList(sourceList, source);
						if(sourceid==null || "".equals(sourceid)){
							sourceid = "1";
						}

						String knowledgeid=findParamInList(knowledgeList, knowledge);
						if(knowledgeid==null || "".equals(knowledgeid)){
							knowledgeid = "1";
						}

						String difficultyid = findParamInList(difficultyList, difficulty);
						if(difficultyid==null || "".equals(difficultyid)){
							difficultyid = "1";
						}

						String isconId = getCellFormatIntOrString(row.getCell(4)).trim();

						Double score = 0.0; //题目分数
						if(!StringUtils.isEmpty(row.getCell(2).toString().trim())) {
							String val = row.getCell(2).toString().trim();
							Matcher isNums = Pattern.compile("^\\d+(\\.\\d+)?$").matcher(val);
							if(isNums.matches()) {
								score = Double.parseDouble(val);
							}
						}

						//答题用时
						String answertime = "45"; //默认45秒

						String t = getCellFormatIntOrString(row.getCell(20)).trim();
						Matcher isNum = Pattern.compile("[0-9]*").matcher(t);
						if(!StringUtils.isEmpty(t) && isNum.matches()) {
							answertime = t;
						}

						String realdifficulty = "0"; //实测难度
						if(!StringUtils.isEmpty(getCellFormatIntOrString(row.getCell(21)).trim())) {
							String val = getCellFormatIntOrString(row.getCell(21)).trim();
							Matcher isNums = Pattern.compile("[0]\\.{0,1}[0-9]{0,3}|[1]\\.{0,1}[0]{0,3}").matcher(val);
							if(isNums.matches()) {
								realdifficulty = val;
							}
						}

						String count = "0";
						if(!StringUtils.isEmpty(getCellFormatIntOrString(row.getCell(22)).trim())) {
							String val = getCellFormatIntOrString(row.getCell(22)).trim();
							Matcher isNums = Pattern.compile("[0-9]*").matcher(val);
							if(isNums.matches()) {
								count = val;
							}
						}

						String distinction = "0";
						if(!StringUtils.isEmpty(getCellFormatIntOrString(row.getCell(23)).trim())) {
							String val = getCellFormatIntOrString(row.getCell(23)).trim();
							Matcher isNums = Pattern.compile("[0]\\.{0,1}[0-9]{0,3}|[1]\\.{0,1}[0]{0,3}").matcher(val);
							if(isNums.matches()) {
								distinction = val;
							}
						}

						int nums = 0;
						if(!StringUtils.isEmpty(getCellFormatIntOrString(row.getCell(24)).trim())) {
							String val = getCellFormatIntOrString(row.getCell(24)).trim();
							Matcher isNums = Pattern.compile("[0-9]*").matcher(val);
							if(isNums.matches()) {
								nums = Integer.parseInt(val);
							}
						}

						if(iscon==1) {
							int ctN=Integer.parseInt(getCellFormatIntOrString(row.getCell(4)).trim());
							if(ctN!=ct){
								Map mainQuestion = new HashMap();
								mainQuestion.put("cid", cid);
								mainQuestion.put("qtiscon", iscon);
								mainQuestion.put("ismain", 1);
								mainQuestion.put("answertime", answertime);
								mainQuestion.put("realdifficulty",realdifficulty);
								mainQuestion.put("distinction", distinction);
								mainQuestion.put("count", count);
								mainQuestion.put("qtid_q", qtid);
								mainQuestion.put("qtid", qtid+"_"+atid+"_"+iscon);
								mainQuestion.put("state", 0);
								mainQuestion.put("content", mainContent);
								mainQuestion.put("qtiscon", 1);
								mainQuestion.put("theme1id", th1id);
								mainQuestion.put("theme2id", th2id);
								mainQuestion.put("theme3id", th3id);
								mainQuestion.put("creatorid", uid);
								mainQuestion.put("verifyid", vid);
								mainQuestion.put("score", score);
								mainQuestion.put("filepath", getCellFormatIntOrString(row.getCell(26)).equals("") ? "" : getCellFormatIntOrString(row.getCell(26)));
								mainQuestion.put("mqid", "");
								mainQuestion.put("difficultyid", difficultyid);
								mainQuestion.put("knowledgeid", knowledgeid);
								mainQuestion.put("cognitionid", cognitionid);
								mainQuestion.put("sourceid", sourceid);
								mainQuestion.put("arrangeid", 4);
								mainQuestion.put("atid", atid);
								mainQuestion.put("num", nums);
								String qid=questionService.getQuestionID();
								mainQuestion.put("qid", qid);
								mainQuestion.put("eid", eid);
								mainQuestion.put("answerid", "");
								mainQuestion.put("answerexplain", "");
								mainQuestion.put("th", th);
								mqid = qid;

								insertQuestionPool.add(mainQuestion);

								ct=ctN;
							}
						}
						String questionContent = content;
						if(!StringUtils.isEmpty(questionContent)) {
							Map question = new HashMap();
							question.put("cid", cid);
							question.put("eid", eid);
							question.put("qtid_q", qtid);
							question.put("qtid", qtid+"_"+atid+"_"+iscon);
							question.put("content", questionContent);
							question.put("ismain", 0);
							question.put("atid", atid);
							String qid = questionService.getQuestionID();
							question.put("qid", qid);
							question.put("answertime", answertime);
							question.put("realdifficulty", realdifficulty);
							question.put("distinction", distinction);
							question.put("count", count);
							question.put("state", 0);
							question.put("theme1id", th1id);
							question.put("theme2id", th2id);
							question.put("theme3id", th3id);
							question.put("creatorid", uid);
							question.put("verifyid", vid);
							question.put("difficultyid", difficultyid);
							question.put("knowledgeid", knowledgeid);
							question.put("cognitionid", cognitionid);
							question.put("sourceid", sourceid);
							question.put("arrangeid", 4);
							question.put("score", score);
							question.put("filepath", getCellFormatIntOrString(row.getCell(26)).equals("") ? "" : getCellFormatIntOrString(row.getCell(26)));
							question.put("mfilepath", getCellFormatIntOrString(row.getCell(25)).equals("") ? "" : getCellFormatIntOrString(row.getCell(25)));
							question.put("num", nums);
							question.put("th", th);
							String answerexplain = getCellFormatIntOrString(row.getCell(12)).trim();//答案解释
							if(StringUtils.isEmpty(answerexplain)) {
								answerexplain = "";
							}
							question.put("answerexplain", answerexplain);

							if(iscon == 1) {
								question.put("mqid", mqid);
								question.put("qtiscon", 1);
							}else {
								question.put("mqid", "");
								question.put("qtiscon", 0);
							}
							//处理答案
							String trueAnswerId = "";
							if(atid < 4 || atid == 8 || atid == 9) {
								String aidStr="";
								Set<String> acontentSet = new HashSet<>();
								for(int j=27;j<42;j++){
									String acontent=getCellFormatIntOrString(row.getCell(j)).trim();
									if(acontent!=null&&!"".equals(acontent)){
										String compareAcontent = Utils.stripAllHtml4Compare(acontent);
										if(!acontentSet.contains(compareAcontent)){
											acontentSet.add(compareAcontent);
										}else {
											rtn.put("code", -1);
											rtn.put("message", "第“"+i+"”题选项内容存在重复。");
											long endTime = System.currentTimeMillis();
											rtn.put("times", (float)(endTime-startTime));
											return rtn;
										}
										String aid = questionService.getAnswerID();
										Map answer = new HashMap();
										answer.put("qid", qid);
										answer.put("atid", atid);
										answer.put("aid", aid);
										answer.put("content", acontent);
										answer.put("content_6","");
										answer.put("eid", eid);

										answerPool.add(answer);
										aidStr+=aid+",";
									}
								}
								aidStr=aidStr.substring(0,aidStr.length()-1);
								String[] aids=aidStr.split(",");
								char[] correct = tcontent.replaceAll("&nbsp;", "").toCharArray();
								StringBuilder sb = new StringBuilder();
								for(char cc:correct) {
									int index = (int)cc-65;
									if(index >= 0 && index < aids.length) {
										sb.append(aids[index]+",");
									}
								}
								if(sb!=null&&sb.length()>0){
									trueAnswerId = sb.toString().substring(0,sb.toString().length()-1);
								}else{
									trueAnswerId = "";
								}

							}else if(atid == 4) {
								String aid = questionService.getAnswerID();
								String acontent = "false";
								if(tcontent.equals("对") || tcontent.equals("是") || tcontent.equals("√")) {
									acontent = "true";
								}
								Map answer = new HashMap();
								answer.put("qid", qid);
								answer.put("atid", atid);
								answer.put("aid", aid);
								answer.put("content", acontent);
								answer.put("content_6", "");
								answer.put("eid", eid);

								answerPool.add(answer);
								trueAnswerId = aid;
							}else if(atid > 4 && atid < 8 || atid > 9) {
								String aid = questionService.getAnswerID();
								Map answer = new HashMap();
								answer.put("qid", qid);
								answer.put("atid", atid);
								answer.put("aid", aid);
								answer.put("content", "");
								answer.put("content_6", tcontent);
								answer.put("eid", eid);

								answerPool.add(answer);
								trueAnswerId= aid;
							}

							if(!"".equals(trueAnswerId)) {
								question.put("answerid", trueAnswerId);
								insertQuestionPool.add(question);
								th=th+1;
							}
						}
					}

					if(insertQuestionPool.size() > 0) {
						num += paperService.insertPaperQuestion(insertQuestionPool);
						paperService.insertAnswerForUnion(answerPool);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
		}
		Map<String, Object> examInfo = paperService.getExamInfo(eid);
		int examState = Utils.changeObjToInt(examInfo.get("STATE"));
		Map param = new HashMap();
		param.put("ei_id", eid);
		param.put("subjectsum", Integer.parseInt(paperService.getPaperQuestionCountForCheckList(param)));
		if(examState==0 || examState==1 || examState==2){
			param.put("state", 0);
			param.put("autotest", 0);
		}
		paperService.updateRawExamInfo(param); //更新题目数量，未通过终审的回到尚未提交审核且自动测试重置
		List<Map<String,Object>> qtscore = paperService.getPaperQuestiontypeScore(eid);
		if(qtscore.size()==0){
			rtn.put("code", -1);
			rtn.put("message", "试卷题目类型更新分数失败，请手动为题型赋分");
			long endTime = System.currentTimeMillis();
			rtn.put("times", (float)(endTime-startTime));
			return rtn;
		}
		for(int i=0;i<qtscore.size();i++){ //最后更新题型分数
			qtscore.get(i).put("SCORE",Double.parseDouble(qtscore.get(i).get("SCORE").toString())/Double.parseDouble(qtscore.get(i).get("QCOUNT").toString()));
			qtscore.get(i).put("EID", eid);
			update("resources.mappers.paper.updateExampaperQuestiontype", qtscore.get(i));
		}
		paperChangeRecorder.recordPaperChange(eid);
		rtn.put("code", 0);
		String mes = "已导入"+num+"条试题。<br/>";
		long endTime = System.currentTimeMillis();
		rtn.put("times", (float)(endTime-startTime));
		rtn.put("message", mes);
		return rtn;
	}

	@Override
	public HSSFWorkbook exportPaperQuestion(Map m){
		String cid=String.valueOf(m.get("cid"));
		String eid=String.valueOf(m.get("eid"));

		int gs=0;
		try{
			gs=Integer.parseInt(String.valueOf(m.get("gs")));
		}catch(Exception e){}

		HSSFWorkbook book = new HSSFWorkbook();
		CellStyle style = PoiServiceImpl.getStyle(book);
		try {
			HSSFSheet sheet = book.createSheet("Sheet1");
			sheet.autoSizeColumn(1, true);// 自适应列宽度
			HSSFRow firstRow = sheet.createRow(0);//（从0开始）
			HSSFCell cell0 = firstRow.createCell(0);
			cell0.setCellValue("课程名称");
			cell0.setCellStyle(style);

			HSSFCell cell1 = firstRow.createCell(1);
			cell1.setCellValue("题目类型");
			cell1.setCellStyle(style);

			HSSFCell cell2 = firstRow.createCell(2);
			cell2.setCellValue("分值");
			cell2.setCellStyle(style);

			HSSFCell cell3 = firstRow.createCell(3);
			cell3.setCellValue("公共题干");
			cell3.setCellStyle(style);

			HSSFCell cell4 = firstRow.createCell(4);
			cell4.setCellValue("串题标识");
			cell4.setCellStyle(style);

			HSSFCell cell5 = firstRow.createCell(5);
			cell5.setCellValue("答案类型");
			cell5.setCellStyle(style);

			HSSFCell cell6 = firstRow.createCell(6);
			cell6.setCellValue("录入者用户名");
			cell6.setCellStyle(style);

			HSSFCell cell7 = firstRow.createCell(7);
			cell7.setCellValue("录入者");
			cell7.setCellStyle(style);

			HSSFCell cell8 = firstRow.createCell(8);
			cell8.setCellValue("审核者用户名");
			cell8.setCellStyle(style);

			HSSFCell cell9 = firstRow.createCell(9);
			cell9.setCellValue("审核者");
			cell9.setCellStyle(style);

			HSSFCell cell10 = firstRow.createCell(10);
			cell10.setCellValue("内容");
			cell10.setCellStyle(style);

			HSSFCell cell11 = firstRow.createCell(11);
			cell11.setCellValue("答案");
			cell11.setCellStyle(style);

			HSSFCell cell12 = firstRow.createCell(12);
			cell12.setCellValue("答案解析");
			cell12.setCellStyle(style);

			HSSFCell cell13 = firstRow.createCell(13);
			cell13.setCellValue("主题词一");
			cell13.setCellStyle(style);

			HSSFCell cell14 = firstRow.createCell(14);
			cell14.setCellValue("主题词二");
			cell14.setCellStyle(style);

			HSSFCell cell15 = firstRow.createCell(15);
			cell15.setCellValue("主题词三");
			cell15.setCellStyle(style);

			HSSFCell cell16 = firstRow.createCell(16);
			cell16.setCellValue("认知");
			cell16.setCellStyle(style);

			HSSFCell cell17 = firstRow.createCell(17);
			cell17.setCellValue("题源");
			cell17.setCellStyle(style);

			HSSFCell cell18 = firstRow.createCell(18);
			cell18.setCellValue("知识点");
			cell18.setCellStyle(style);

			HSSFCell cell19 = firstRow.createCell(19);
			cell19.setCellValue("难度");
			cell19.setCellStyle(style);

			HSSFCell cell20 = firstRow.createCell(20);
			cell20.setCellValue("答题时间（秒）");
			cell20.setCellStyle(style);

			HSSFCell cell21 = firstRow.createCell(21);
			cell21.setCellValue("实测难度");
			cell21.setCellStyle(style);

			HSSFCell cell22 = firstRow.createCell(22);
			cell22.setCellValue("应答人数");
			cell22.setCellStyle(style);

			HSSFCell cell23 = firstRow.createCell(23);
			cell23.setCellValue("区分度");
			cell23.setCellStyle(style);

			HSSFCell cell24 = firstRow.createCell(24);
			cell24.setCellValue("已考次数");
			cell24.setCellStyle(style);

			HSSFCell cell25 = firstRow.createCell(25);
			cell25.setCellValue("公共题干附件");
			cell25.setCellStyle(style);

			HSSFCell cell26 = firstRow.createCell(26);
			cell26.setCellValue("附件路径");
			cell26.setCellStyle(style);
			for(int i = 0; i < 15; i++) {
				HSSFCell cellA = firstRow.createCell(27+i);
				cellA.setCellStyle(style);
				cellA.setCellValue("选项"+(char)(65+i));
			}

			List<Map<String,Object>> allQuestion = new ArrayList<>();
			List<Map<String,Object>> answerType = commonService.getAnswerTypeList();

			List<Map<String, Object>> res =  paperService.getExampaperQuestionList4xls(m);
			for(Map mm:res){
				int iscon = Integer.parseInt(mm.get("qtiscon").toString());
				if(iscon==1) {
					Map param = new HashMap();
					param.put("mqid", mm.get("qid"));
					param.put("eid", eid);
					List<Map<String, Object>> qls = paperService.getPaperQuestionBranch4Xls(param);
					for(Map mq : qls) {
						Map par = new HashMap();
						par.put("id", mq.get("qid").toString());
						par.put("eid", eid);
						mq.put("mainContent", mm.get("content"));
						mq.put("mfilepath", mm.get("filepath"));
						mq.put("creatorname", mm.get("creator"));
						mq.put("creatorusername", mm.get("creatorname"));
						mq.put("verifyname", mm.get("verifyrealname"));
						mq.put("verifyusername", mm.get("verifyname"));
						mq.put("answer",paperService.getAnswerByQID_Version(par));
						allQuestion.add(mq);
					}
				}else {
					Map par = new HashMap();
					par.put("id", mm.get("qid").toString());
					par.put("eid", eid);
					mm.put("mainContent", "");
					mm.put("mfilepath", "");
					mm.put("answer", paperService.getAnswerByQID_Version(par));
					allQuestion.add(mm);
				}
			}

			int sum = 0;
			Map<String,Object> mqids = new HashMap<String,Object>();

			StringBuilder out = new StringBuilder();
			StringBuilder err_qids = new StringBuilder();
			Map<String,Object> combin = new HashMap<String,Object>();
			boolean combinFlag = false;
			int extraRownum = 0;
			int selcount = 0;

			for (int i = 0; i < allQuestion.size(); i++) {
				try {
					Map<String,Object> question = allQuestion.get(i);
					int atid = Integer.parseInt(question.get("atid")+"");

					if(combinFlag == true) {

						combinFlag = false;
						HSSFRow row = sheet.createRow(i + 1 + extraRownum);// index：第几行

						HSSFCell _cell0 = row.createCell(1);
						_cell0.setCellValue("combin");
						_cell0.setCellStyle(style);

						if(combin.get("mainContent")!=null) {
							HSSFCell _cell1 = row.createCell(1);
							String mainContent = combin.get("mainContent").toString();
							if(gs==1){
								mainContent=getQuestionTxt(mainContent);
							}
							if(!StringUtils.isEmpty(mainContent) && mainContent.length()>32766) {
								combin.put("mainContent",mainContent.substring(32766));
								mainContent = mainContent.substring(0,32766);
								combinFlag = true;
							}
							_cell1.setCellValue(mainContent);
							_cell1.setCellStyle(style);
						}

						if(combin.get("content")!=null) {
							HSSFCell _cell10 = row.createCell(10);
							String content = combin.get("content").toString();
							if(gs==1){
								content=getQuestionTxt(content);
							}
							if(content.length()>32766) {
								combin.put("content", content.substring(32766));
								content = content.substring(0, 32766);
								combinFlag = true;
							}
							_cell10.setCellValue(content);
							_cell10.setCellStyle(style);
						}

						if(combin.get("acontent")!=null) {
							HSSFCell _cell11 = row.createCell(11);
							String acontent = combin.get("acontent").toString();
							if(gs==1){
								acontent=getQuestionTxt(acontent);
							}
							if(acontent.length()>32766) {
								combin.put("acontent", acontent.substring(32766));
								acontent = acontent.substring(0, 32766);
								combinFlag = true;
							}
							_cell11.setCellValue(acontent);
							_cell11.setCellStyle(style);
						}

						if(combin.get("answerexplain")!=null) {
							HSSFCell _cell12 = row.createCell(12);
							String answerexplain = combin.get("answerexplain").toString();
							if(answerexplain.length()>32766) {
								combin.put("answerexplain", answerexplain.substring(32766));
								answerexplain = answerexplain.substring(0, 32766);
								combinFlag = true;
							}
							_cell12.setCellValue(answerexplain);
							_cell12.setCellStyle(style);
						}

						for(int seli=0;seli<selcount;seli++) {
							if(combin.get(seli+"sel")!=null) {
								HSSFCell _cellC = row.createCell(seli+25);
								String sel = combin.get(seli+"sel").toString();
								if(sel.length()>32766) {
									combin.put(seli+"sel", sel.substring(32766));
									sel = sel.substring(0, 32766);
									combinFlag = true;
								}
								_cellC.setCellValue(sel);
								_cellC.setCellStyle(style);
							}
						}

						if(combinFlag == true) {
							extraRownum++;
							i--;
						}
					}else {
						combinFlag = false;

						HSSFRow row = sheet.createRow(i + 1 + extraRownum);// index：第几行

						HSSFCell _cell0 = row.createCell(0);
						_cell0.setCellValue(String.valueOf(question.get("cname")));
						_cell0.setCellStyle(style);

						HSSFCell _cell1 = row.createCell(1);
						_cell1.setCellValue(String.valueOf(question.get("qtname")));
						_cell1.setCellStyle(style);

						HSSFCell _cell2 = row.createCell(2);
						if (!StringUtils.isEmpty(question.get("score"))) {
							_cell2.setCellValue(String.valueOf(question.get("score")));
						}else {
							_cell2.setCellValue("");
						}
						_cell2.setCellStyle(style);

						HSSFCell _cell3 = row.createCell(3);
						String mainContent = String.valueOf(question.get("mainContent"));
						if(gs==1){
							mainContent=getQuestionTxt(mainContent);
						}
						if(!StringUtils.isEmpty(mainContent) && mainContent.length()>32766) {
							combin.put("mainContent",mainContent.substring(32766));
							mainContent = mainContent.substring(0,32766);
							combinFlag = true;
						}
						_cell3.setCellValue(mainContent);
						_cell3.setCellStyle(style);

						HSSFCell _cell4 = row.createCell(4);
						if ("1".equals(question.get("qtiscon")+"")) {
							String mqid = (String)question.get("mqid");
							if(mqids.get(mqid)==null){
								sum++;
								_cell4.setCellValue(sum+"");
								mqids.put(mqid, sum+"");
							}else{
								_cell4.setCellValue(String.valueOf(mqids.get(mqid)));
							}
						}else{
							_cell4.setCellValue(0);
						}
						_cell4.setCellStyle(style);

						HSSFCell _cell5 = row.createCell(5);
						for(Map at:answerType) {
							int id = Integer.parseInt(at.get("ID").toString());
							if(atid == id) {
								_cell5.setCellValue(at.get("NAME").toString());
								break;
							}
						}

						_cell5.setCellStyle(style);

						HSSFCell _cell6 = row.createCell(6);
						if (!StringUtils.isEmpty(question.get("creatorusername"))) {
							_cell6.setCellValue(String.valueOf(question.get("creatorusername")));
						}else {
							_cell6.setCellValue("");
						}
						_cell6.setCellStyle(style);

						HSSFCell _cell7 = row.createCell(7);
						if (!StringUtils.isEmpty(question.get("creatorname"))) {
							_cell7.setCellValue(String.valueOf(question.get("creatorname")));
						}else{
							_cell7.setCellValue("");
						}
						_cell7.setCellStyle(style);

						HSSFCell _cell8 = row.createCell(8);
						if (!StringUtils.isEmpty(question.get("verifyusername"))) {
							_cell8.setCellValue(String.valueOf(question.get("verifyusername")));
						}else {
							_cell8.setCellValue("");
						}
						_cell8.setCellStyle(style);

						HSSFCell _cell9 = row.createCell(9);
						if (!StringUtils.isEmpty(question.get("verifyname"))) {
							_cell9.setCellValue(String.valueOf(question.get("verifyname")));
						}else {
							_cell9.setCellValue("");
						}
						_cell9.setCellStyle(style);

						HSSFCell _cell10 = row.createCell(10);
						if(question.get("content")==null) {
							_cell10.setCellValue("");
						}else {
							String content = String.valueOf(question.get("content"));
							if(gs==1){
								content=getQuestionTxt(content);
							}
							if(content.length()>32766) {
								combin.put("content", content.substring(32766));
								content = content.substring(0, 32766);
								combinFlag = true;
							}
							_cell10.setCellValue(content);
						}
						_cell10.setCellStyle(style);

						HSSFCell _cell11 = row.createCell(11);
						ArrayList<Map<String, String>> list = (ArrayList<Map<String, String>>) question.get("answer");
						String rs = "";
						if (atid < 4||atid==8||atid==9) {
							StringBuilder sb = new StringBuilder();
							if (question.get("answerid")==null) {
								rs = "";
							}else {
								String[] rightAid = (question.get("answerid")+"").split(",");
								for(int j=0;j<list.size();j++) {
									HSSFCell _cellC_ = row.createCell(27+j);
									String sel = String.valueOf(list.get(j).get("ACONTENT"));
									if(sel.length()>32766) {
										combin.put((25+j)+"sel", sel.substring(32766));
										sel = sel.substring(0, 32766);
										combinFlag = true;
									}
									_cellC_.setCellValue(sel);
									_cellC_.setCellStyle(style);
									for(int k=0;k<rightAid.length;k++) {
										if (rightAid[k].equals(list.get(j).get("AID"))) {
											sb.append((char)(j+65));
											break;
										}
									}
									selcount = j+1;
								}
							}
							rs = sb.toString();
						}else if (atid == 4) {
							for(int j=0;j<list.size();j++) {
								if (question.get("answerid").equals(list.get(j).get("AID"))) {
									if ("true".equals(list.get(j).get("ACONTENT").toString())) {
										rs = "对";
									}else {
										rs = "错";
									}
								}
							}
						}else {
							for(int j=0;j<list.size();j++) {
								if (question.get("answerid").equals(list.get(j).get("AID"))) {
									rs = list.get(j).get("ACONTENT_6")==null?"":list.get(j).get("ACONTENT_6");
									String acontent = rs;
									if(gs==1){
										acontent=getQuestionTxt(acontent);
									}
									if(acontent.length()>32766) {
										combin.put("acontent", acontent.substring(32766));
										acontent = acontent.substring(0, 32766);
										combinFlag = true;
									}
									_cell11.setCellValue(acontent);
									rs = acontent;
								}
							}
						}
						_cell11.setCellValue(rs);
						_cell11.setCellStyle(style);

						HSSFCell _cell12 = row.createCell(12);
						if (!StringUtils.isEmpty(question.get("answerexplain"))) {
							String answerexplain = String.valueOf(question.get("answerexplain"));
							if(answerexplain.length()>32766) {
								combin.put("answerexplain", answerexplain.substring(32766));
								answerexplain = answerexplain.substring(0, 32766);
								combinFlag = true;
							}
							_cell12.setCellValue(answerexplain);
						}else {
							_cell12.setCellValue("");
						}
						_cell12.setCellStyle(style);

						HSSFCell _cell13 = row.createCell(13);
						if (!StringUtils.isEmpty(question.get("t1name"))) {
							_cell13.setCellValue(String.valueOf(question.get("t1name")));
						}else {
							_cell13.setCellValue("");
						}
						_cell13.setCellStyle(style);

						HSSFCell _cell14 = row.createCell(14);
						if (!StringUtils.isEmpty(question.get("t2name"))) {
							_cell14.setCellValue(String.valueOf(question.get("t2name")));
						}else {
							_cell14.setCellValue("");
						}
						_cell14.setCellStyle(style);

						HSSFCell _cell15 = row.createCell(15);
						if (!StringUtils.isEmpty(question.get("t3name"))) {
							_cell15.setCellValue(String.valueOf(question.get("t3name")));
						}else {
							_cell15.setCellValue("");
						}
						_cell15.setCellStyle(style);

						HSSFCell _cell16 = row.createCell(16);
						if (!StringUtils.isEmpty(question.get("coname"))) {
							_cell16.setCellValue(question.get("coname").toString());
						}else {
							_cell16.setCellValue("");
						}
						_cell16.setCellStyle(style);

						HSSFCell _cell17 = row.createCell(17);
						if (!StringUtils.isEmpty(question.get("soname"))) {
							_cell17.setCellValue(question.get("soname").toString());
						}else {
							_cell17.setCellValue("");
						}
						_cell17.setCellStyle(style);

						HSSFCell _cell18 = row.createCell(18);
						if (!StringUtils.isEmpty(question.get("kname"))) {
							_cell18.setCellValue(question.get("kname").toString());
						}else {
							_cell18.setCellValue("");
						}
						_cell18.setCellStyle(style);

						HSSFCell _cell19 = row.createCell(19);
						if (!StringUtils.isEmpty(question.get("dname"))) {
							_cell19.setCellValue(question.get("dname").toString());
						}else {
							_cell19.setCellValue("");
						}
						_cell19.setCellStyle(style);

						HSSFCell _cell20 = row.createCell(20);
						if (!StringUtils.isEmpty(question.get("answertime"))) {
							_cell20.setCellValue(String.valueOf(question.get("answertime")));
						}else {
							_cell20.setCellValue("45");
						}
						_cell20.setCellStyle(style);

						HSSFCell _cell21 = row.createCell(21);
						if (!StringUtils.isEmpty(question.get("realdifficulty"))) {
							_cell21.setCellValue(new BigDecimal(String.valueOf(question.get("realdifficulty"))).setScale(3,BigDecimal.ROUND_HALF_UP).doubleValue()+"");
						}else {
							_cell21.setCellValue("");
						}
						_cell21.setCellStyle(style);

						HSSFCell _cell22 = row.createCell(22);
						if (!StringUtils.isEmpty(question.get("scount"))) {
							_cell22.setCellValue(question.get("scount")+"");
						}else {
							_cell22.setCellValue("");
						}
						_cell22.setCellStyle(style);

						HSSFCell _cell23 = row.createCell(23);
						if (!StringUtils.isEmpty(question.get("distinction"))) {
							_cell23.setCellValue(new BigDecimal(String.valueOf(question.get("distinction"))).setScale(3,BigDecimal.ROUND_HALF_UP).doubleValue()+"");
						}else {
							_cell23.setCellValue("");
						}
						_cell23.setCellStyle(style);

						HSSFCell _cell24 = row.createCell(24);
						if(!StringUtils.isEmpty(question.get("num"))) {
							_cell24.setCellValue(question.get("num").toString());
						}else {
							_cell24.setCellStyle(style);
						}
						_cell24.setCellStyle(style);

						HSSFCell _cell25 = row.createCell(25);
						_cell25.setCellValue(question.get("mfilepath") == null ? "" : question.get("mfilepath").toString());
						_cell25.setCellStyle(style);

						HSSFCell _cell26 = row.createCell(26);
						if(question.get("filepath")==null) {
							_cell26.setCellValue("");
						}else {
							_cell26.setCellValue(question.get("filepath").toString());
						}
						_cell26.setCellStyle(style);
						if(combinFlag == true) {
							extraRownum++;
							i--;
						}
					}
				}catch (Exception e){
					System.err.println("具体报错：");
					out.append(i+2+",");
					err_qids.append(allQuestion.get(i).get("qid") + ",");
					e.printStackTrace();
					continue;
				}
			}

			if(!"".equals(out.toString())) {
				HSSFCellStyle error = PoiServiceImpl.getErrorStyle(book);
				HSSFRow lastRow = sheet.createRow(allQuestion.size() + 3);
				Cell lastCell0 = lastRow.createCell(0);
				lastCell0.setCellValue("有问题的试题行数为:"+out.toString());
				lastCell0.setCellStyle(error);
				Cell lastCell1 = lastRow.createCell(1);
				lastCell1.setCellValue("有问题的试题id:"+err_qids.toString());
				lastCell1.setCellStyle(error);
			}
			sheet.setDefaultColumnWidth(15);
			sheet.setColumnWidth(1, 80 * 256);
			sheet.setColumnWidth(8, 100 * 256);
		} catch (Exception ex) {
			ex.printStackTrace();
		}
		return book;
	}

	@Override
	public Map checkWordFile(MultipartFile questionFile) throws IOException{
		Map<String,Object> rtn=new HashMap<>();
		FileInputStream is = null;
		XWPFDocument doc = null;
		try{
			String qFileName = questionFile.getOriginalFilename();
			String suffix1 = qFileName.substring(qFileName.lastIndexOf(".") + 1, qFileName.length());
//			String ym = DateFormatUtils.getNowDay();
			String qFilePath = "/uploadFile/word/question/" + new Date().getTime() + qFileName;

			File qFile = new File(WebFilePath.getProjectPath() + qFilePath);
			if (qFile.exists()) {
				qFile.delete();
			}
			qFile.mkdirs();
			questionFile.transferTo(qFile);

			if ("docx".equals(suffix1.toLowerCase())) {
				String paperText = "";
				int qtIndex = 0;
				int qIndex = 0;
				is = new FileInputStream(qFile);
				doc = new XWPFDocument(is);


				XWPFHeaderFooterPolicy headerFooterPolicy = doc.getHeaderFooterPolicy();
//				CTDocument1 ctdoc = doc.getDocument();

				List<XWPFParagraph> paras = doc.getParagraphs();
				List<Map<String, String>> list = getParagraph(paras.get(0));
				Iterator<IBodyElement> iter = doc.getBodyElementsIterator();

				IBodyElement telement = iter.next();
				XWPFParagraph tpara = (XWPFParagraph) telement;
				String theme = Utils.replaceUnrecognizableChars(tpara.getText());
				if(theme==null||"".equals(theme)) {
					rtn.put("code","001");
					rtn.put("message", "文档第一行内容应为主题词，请按要求编辑文档。");
					return rtn;
				}
				if ("##".equals(theme.substring(0, 2)) && "##".equals(theme.substring(theme.length() - 2))) {
					String themeTxt = theme.substring(2, theme.length() - 2);
					if("".equals(themeTxt)){
						rtn.put("code","001");
						rtn.put("message", "主题词内容为空，请补充后再导入。");
						return rtn;
					}
				}else {
					rtn.put("code","001");
					rtn.put("message", "主题词内容为空，请补充后再导入。");
					return rtn;
				}
				while (iter.hasNext()) {
					IBodyElement element = iter.next();
					if (element instanceof XWPFParagraph) {
						XWPFParagraph para = (XWPFParagraph) element;
						List<XWPFRun> runsLists = para.getRuns();
						for (XWPFRun run : runsLists) {
							Node runNode = run.getCTR().getDomNode();
//							if(WordReadTextWithFormulasAsHTML.checkNode(runNode,"w:numPr")) {
//								rtn.put("code","001");
//								rtn.put("message", "第"+(qtIndex+1)+"个题型或第"+(qIndex+1)+"道试题的序号为自动编号，请检查后去掉自动编号后再导入。");
//								return rtn;
//							}
						}
						String content = Utils.replaceUnrecognizableChars(para.getText());
						if (content==null || "".equals(content)) {
							continue;
//							StringBuilder conSB=new StringBuilder();
//							for (XWPFRun run : runsLists) {
//								Node runNode = run.getCTR().getDomNode();
//								conSB.append(WordReadTextWithFormulasAsHTML.checkText(run, runNode));
//							}
//							content=conSB.toString();
//							if("".equals(content)) {
//								continue;
//							}
						}
						if(content.indexOf("#主题干#")==0){
							content=content.substring(5);
						}
						String[] fj = content.split("、");
						if (fj.length > 0) {
							if (fj[0].equals(Utils.int2chineseNum(qtIndex + 1))) {
								qtIndex++;
							} else if (fj[0].equals((qIndex + 1) + "")) {
								qIndex++;
							}
						}
					}
				}
				rtn.put("filepath",qFilePath);
				if(qtIndex>0&&qIndex==0) {
					rtn.put("code","001");
					rtn.put("message", "系统未检测到试题，请检查试题序号是否符合要求，注意：试题序号不能使用自动排序生成。");
				}else if(qtIndex>0) {
					rtn.put("code","002");
					rtn.put("message", "系统检测到，文档包含"+qtIndex+"个题型，"+qIndex+"道试题（不包含串题分支），请确认是否正确，点击确定按钮继续导入。");
				}else if(qtIndex==0) {
					rtn.put("code","001");
					rtn.put("message", "系统未检测到题型，请检查题型序号是否符合要求，注意：题型序号不能使用自动排序生成。");
				}
				return rtn;
			}else{
				rtn.put("code","001");
				rtn.put("message", "导入文档要求docx格式");
				return rtn;
			}
		}catch(Exception e){
			e.printStackTrace();
			rtn.put("code","001");
			rtn.put("message", "导入文档要求docx格式");
			return rtn;
		}finally{
			if(doc!=null) {
				doc.close();
			}
			if(is!=null) {
				is.close();
			}
		}
	}

	@Override
	public Map importWord_test(String qFilePath,String cid, String repeat) {
		Random random = new Random();
		String picUrl = WebFilePath.getRealPath();
		long startTime = System.currentTimeMillis();
		Map rtn = new HashMap();

		List<Map<String,Object>> answerPool = new ArrayList<>();
		List<Map<String,Object>> questionPool = new ArrayList<>();
		List<Map<String, Object>> insertQuestionPool = new ArrayList<>();
		File qFile = new File(WebFilePath.getProjectPath() + qFilePath);
		try (FileInputStream is = new FileInputStream(qFile);
			 XWPFDocument doc = new XWPFDocument(is)){
			List<XWPFParagraph> paras = doc.getParagraphs();
			Iterator<IBodyElement> iter = doc.getBodyElementsIterator();

			List<Map<String, Object>> questionType = courseService.getCourseQuestionType(cid);
			Map<String ,Map<String,Object>> qtMapFromCourse = Utils.listToMap(questionType, "QTNAME");
			List<Map<String, Object>> knowledgeList = courseService.getCourseKnowledge(cid);
			Map<String ,Map<String,Object>> knowledgeMap = Utils.listToMap(knowledgeList, "NAME");
			List<Map<String,Object>> cognitionList=courseService.getCourseCognition(cid);
			Map<String ,Map<String,Object>> coMap = Utils.listToMap(cognitionList, "NAME");
			List<Map<String,Object>> difficultyList=courseService.getCourseDifficulty(cid);
			Map<String ,Map<String,Object>> diffMap = Utils.listToMap(difficultyList, "NAME");
			String schoolName = (String) ((Map<String,Object>) servletContext.getAttribute("organizationinfo")).get("PARAM");
			List<Map<String,Object>> qtList=new ArrayList<>();
			List<Map<String,Object>> qList=new ArrayList<>();
			List<Map<String,Object>> answerList=new ArrayList<>();

			String qtid="";
			String atid="";
			int iscon=0;//0，非串题，1，串题
			int qtIndex=0;
			int qIndex=0;
			int aIndex=0;
			int branchIndex=0;
			int flag=-1;//标记目前写入的是题型还是题干还是答案，0，题型，1，题干，2，答案
			IBodyElement telement = iter.next();
			XWPFParagraph tpara = (XWPFParagraph) telement;
			String theme=tpara.getText().trim();

			String th1id = "";
			String th2id = "";
			String th3id = "";
			if("##".equals(theme.substring(0,2))&&"##".equals(theme.substring(theme.length()-2))){
				String themeTxt=theme.substring(2,theme.length()-2);
				String theme1="";
				String theme2="";
				String theme3="";
				if(themeTxt==null||"".equals(themeTxt)){
					long endTime = System.currentTimeMillis();
					rtn.put("times", (float)(endTime-startTime));
					rtn.put("message", "主题词格式设置出错，请修改后再导入");
					return rtn;
				}else{
					if(themeTxt.contains("|")){
						String[] themeStr=themeTxt.split("\\|");
						theme1=themeStr[0].trim();
						if(themeStr.length>1&&themeStr[1]!=null&&!"".equals(themeStr[1])){
							theme2=themeStr[1].trim();
						}
						if(themeStr.length>2&&themeStr[2]!=null&&!"".equals(themeStr[2])){
							theme3=themeStr[2].trim();
						}
					}else{
						theme1=themeTxt;
					}
				}

				List<Map<String, Object>> themePool = new ArrayList<>();
				Map t1par = new HashMap();
				t1par.put("th_name", theme1);
				t1par.put("th_pid", "-1");
				t1par.put("th_level", 1);
				t1par.put("th_cid", cid);
				questionService.insertTheme4ImportQuestion(t1par);
				addIntoPool(themePool,t1par);
				th1id = t1par.get("id").toString();
				if(!"".equals(theme2)){
					Map t2par = new HashMap();
					t2par.put("th_name", theme2);
					t2par.put("th_pid", t1par.get("id").toString());
					t2par.put("th_level", 2);
					t2par.put("th_cid", cid);
					questionService.insertTheme4ImportQuestion(t2par);
					addIntoPool(themePool,t2par);
					th2id = t2par.get("id").toString();
					if(!"".equals(theme3)){
						Map t3par = new HashMap();
						t3par.put("th_name", theme3);
						t3par.put("th_pid", t2par.get("id").toString());
						t3par.put("th_level", 3);
						t3par.put("th_cid", cid);
						questionService.insertTheme4ImportQuestion(t3par);
						addIntoPool(themePool,t3par);
						th3id = t3par.get("id").toString();
					}
				}
			}else{
				long endTime = System.currentTimeMillis();
				rtn.put("times", (float)(endTime-startTime));
				rtn.put("message", "主题词内容为空，请补充后再导入");
				return rtn;
			}
			String pathToImage=picUrl + "/kaoyi_upload/"+cid+"/";
			int firstBranchIndex = 0;
			int secondBranchIndex = 0;
			int branchAllCount = 0;
			while (iter.hasNext()) {
				IBodyElement element = iter.next();
				if (element instanceof XWPFParagraph) {
					XWPFParagraph para = (XWPFParagraph) element;
					List<XWPFRun> runsLists = para.getRuns();
					String filePath="";
					StringBuilder conSB=new StringBuilder();
					String nginxFileDirName = WebFilePath.getNginxRoot()+"kaoyi_upload/"+cid+"/";
					File file=new File(picUrl + "/kaoyi_upload/"+cid);
					if(!file.exists()) {
						file.mkdirs();
					}
					File nginxFile = new File(nginxFileDirName);
					if (!nginxFile.exists()){
						nginxFile.mkdirs();
					}
					for (XWPFRun run : runsLists) {
						List<XWPFPicture> pictures = run.getEmbeddedPictures();
						if (pictures.size() > 0) {
							XWPFPicture picture = pictures.get(0);
							XWPFPictureData pictureData = picture.getPictureData();
							if(pictureData==null){ //可能是url
								continue;
							}
							byte[] bytev = pictureData.getData();
							if (bytev.length > 300) {
								String fileName=pictureData.getFileName();
								String suffix=fileName.substring(fileName.lastIndexOf(".")+1);
								String imgName=System.currentTimeMillis()+random.nextInt(1000)+"";
								String nowName=imgName+ "."+suffix;
								FileOutputStream fos1 = new FileOutputStream(pathToImage+nowName);
								fos1.write(bytev);
								fos1.close();
								Map<String, String> picRtn = null;
								if("emf".equalsIgnoreCase(suffix)) {
									WordReadTextWithFormulasAsHTML.emfToPng(pathToImage+nowName, pathToImage+imgName+".png");
									nowName=imgName+ ".png";
									File emf=new File(pathToImage+imgName+"."+suffix);
									emf.delete();
								}else if("tif".equalsIgnoreCase(suffix) || "tiff".equalsIgnoreCase(suffix)){
									WordReadTextWithFormulasAsHTML.localHardPicToPngWithGraphicsMagick(pathToImage+nowName, pathToImage+imgName+".png");
									nowName=imgName+ ".png";
									File emf=new File(pathToImage+imgName+"."+suffix);
									emf.delete();
								}else if("wmf".equalsIgnoreCase(suffix)){
									picRtn = WordReadTextWithFormulasAsHTML.convertWmf(pathToImage+nowName);
									nowName=imgName+ picRtn.get("suffix");
									File emf=new File(pathToImage+imgName+"."+suffix);
									emf.delete();
								}

								filePath="/kaoyi_upload/"+cid+"/"+nowName;
								Files.copy(Paths.get(picUrl+filePath), Paths.get(nginxFileDirName+nowName), StandardCopyOption.REPLACE_EXISTING);
								if(picRtn!=null && !StringUtils.isEmpty(picRtn.get("wPx")) && !StringUtils.isEmpty(picRtn.get("hPx"))){
									conSB.append("<img src='"+filePath+"' style='width: "+picRtn.get("wPx")+"px;height:"+picRtn.get("hPx")+"px;'/>");
								}else{
									conSB.append("<img src='"+filePath+"' style='max-width: 1000px;max-height:650px;'/>");
								}
							}
						}else{
//								conSB.append(run.getText(0));
							Node runNode = run.getCTR().getDomNode();
							conSB.append(WordReadTextWithFormulasAsHTML.getText(runNode)); //纯文本内容
							Node parentNode = run.getCTR().getDomNode().getParentNode();
							if (parentNode.getNodeName().equals("w:p")) {
								// 遍历 w:p 节点下的所有子节点
								NodeList childNodes = parentNode.getChildNodes();
								// 查找当前 w:r 节点的位置
								for (int i = 0; i < childNodes.getLength(); i++) {
									Node childNode = childNodes.item(i);
									if (childNode == run.getCTR().getDomNode()) {
										if (i + 1 < childNodes.getLength()) { //只找同级w:r的下一级节点
											Node nextSibling = childNodes.item(i + 1);
											if (nextSibling.getNodeName().equals("m:oMath")) {
												String svgFileName = new Date().getTime()+".svg";
												String latexEncode = WordReadTextWithFormulasAsHTML.extractLatexFromNode(nextSibling,picUrl+"/kaoyi_upload/"+cid+"/"+svgFileName);
												if(!StringUtils.isEmpty(latexEncode)){
													//conSB.append("<img src='/kaoyi_upload/"+cid+"/"+svgFileName+"' data-formula-image='"+latexEncode+"' style='height:32px;height:auto; width:auto;'/>");
													conSB.append("<img src='/kaoyi_upload/"+cid+"/"+svgFileName+"' style='height:32px;'/>");//现在是不把latex信息写入内容的版本，上面写入进去，如果在答案中内容会过长，但是以后可修改latex
													Path sourcePath = Paths.get(picUrl, "kaoyi_upload", cid, svgFileName);
													Path targetPath = Paths.get(nginxFileDirName, svgFileName);
													Files.copy(sourcePath, targetPath, StandardCopyOption.REPLACE_EXISTING);
												}
											}
										}
									}
								}
							}
							Map<String,String> smallImageRtn = WordReadTextWithFormulasAsHTML.getSmallImage(run, runNode,picUrl + "/kaoyi_upload/"+cid);
							String imgPath = smallImageRtn.get("rtnName");
							if(!StringUtils.isEmpty(imgPath)){
								Path rtnPicPath = Paths.get(pathToImage+imgPath);
								//复制给nginx
								Files.copy(rtnPicPath, Paths.get(nginxFileDirName+rtnPicPath.getFileName().toString()), StandardCopyOption.REPLACE_EXISTING);
								if(smallImageRtn.get("wPx")!=null && smallImageRtn.get("hPx")!=null){
									conSB.append("<img src='/kaoyi_upload/"+cid+"/"+imgPath+"' style='height:"+smallImageRtn.get("hPx")+"px;width:"+smallImageRtn.get("wPx")+"px'/>");
								}else{
									conSB.append("<img src='/kaoyi_upload/"+cid+"/"+imgPath+"' style='max-height:32px;'/>");
								}
							}
						}
					}
//						String content=para.getText().trim();
					String content=conSB.toString();
					if("".equals(content)){
						continue;
					}
					//判断是不是串题
					if(content.indexOf("#主题干#")==0){
						if(iscon==0){
							long endTime = System.currentTimeMillis();
							rtn.put("times", (float)(endTime-startTime));
							rtn.put("message", "文档中"+qtList.get(qtList.size()-1).get("qtName")+"题型的串题格式不正确，请调整后再导入");
							return rtn;
						}
						content=content.substring(5);
						branchIndex=0;
						qtList.get(qtList.size()-1).put("iscon",1);
					}
					if(iscon==0){
						firstBranchIndex = 0;
						secondBranchIndex = 0;
					}

					content = Utils.replaceUnrecognizableChars(content);
					if(content.startsWith("答案：") || content.startsWith("答案:")){
						qList.get(qList.size()-1).put("answer",content.substring(3));
						flag=3;
					}else{
						String[] fj=content.split("、");
						if(fj.length>1){
							if(fj[1].indexOf("答案：")>0){//中文冒号
								qList.get(qList.size()-1).put("answer",fj[1].substring(fj[1].indexOf("答案：")+3));
							}else if(fj[1].indexOf("答案:")>0){//英文冒号
								qList.get(qList.size()-1).put("answer",fj[1].substring(fj[1].indexOf("答案:")+3));
							}
							if(fj[0].equals(Utils.int2chineseNum(qtIndex+1))){
								Map<String,Object> qtMap=new HashMap<>();
								String fjCon=String.valueOf(fj[1].trim());
								String cleanedText = Utils.replaceUnrecognizableChars(fjCon);
								Map<String,Object> m = qtMapFromCourse.get(cleanedText);
								if(m==null){
									long endTime = System.currentTimeMillis();
									rtn.put("times", (float)(endTime-startTime));
									rtn.put("message", "文档中"+fj[1]+"题型不存在，请添加该题型后再导入");
									return rtn;
								}
								qtMap.put("qtid",m.get("QTID"));
								qtMap.put("atid",m.get("ATID"));
								qtMap.put("iscon",m.get("ISCON"));
								qtid=(String)m.get("QTID");
								atid=(String)m.get("ATID");
								iscon=Integer.parseInt(String.valueOf(m.get("ISCON")));
								qtIndex++;
								qtMap.put("qtIndex",qtIndex);
								StringBuilder sb=new StringBuilder();
								for(int i=1;i<fj.length;i++){
									sb.append(fj[i]+"、");
								}
								if(sb.length()>0){
									qtMap.put("qtName",sb.substring(0,sb.length()-1));
								}else{
									qtMap.put("qtName","");
								}
								qtList.add(qtMap);
								flag=0;
								aIndex=0;
							}else if(
									(iscon==0 && !"近年来尽快".equals(schoolName) && fj[0].equals((qIndex+1)+"")) ||
									(iscon==0 && "12后即可h3123".equals(schoolName) && fj[0].equals((qIndex+1+branchAllCount)+"")) ||
									(iscon==1 && !"1就 23123".equals(schoolName) && fj[0].equals((qIndex+1)+"")) ||
									(iscon==1 && "123接口路接口l132".equals(schoolName) && Pattern.compile("^(\\[(\\d+)-(\\d+)])").matcher(fj[0]).matches())
							){
								if(content.indexOf("A、")>0&&!"155".equals(qtid)&&!"156".equals(qtid)) {
									long endTime = System.currentTimeMillis();
									rtn.put("times", (float)(endTime-startTime));
									rtn.put("message", "第"+(qIndex+1)+"题的题干与选项的回车符号错误，重新编辑回车后再导入。<br>可尝试采用快速替换“CTRL+H”的方法：^l替换^p<br>");
									return rtn;
								}
								qIndex++;
								Map<String,Object> qMap= new HashMap<>();
								qMap.put("qtid",qtid);
								qMap.put("atid",atid);
								qMap.put("qtIndex",qtIndex);
								qMap.put("qIndex",qIndex);
								StringBuilder sb=new StringBuilder();
								for(int i=1;i<fj.length;i++){
									sb.append(fj[i]+"、");
								}
								if(sb.length()>0){
									qMap.put("qcontent",sb.substring(0,sb.length()-1));
								}else{
									qMap.put("qcontent","");
								}
								qMap.put("iscon",iscon);
								qList.add(qMap);
								flag=1;
								aIndex=0;
							}else if(
									fj[0].equals(qIndex+"."+(branchIndex+1))
							){//分支
								branchIndex++;
								Map<String,Object> qMap=new HashMap<>();
								qMap.put("qtid",qtid);
								qMap.put("atid",atid);
								qMap.put("qtIndex",qtIndex);
								qMap.put("qIndex",qIndex);
								qMap.put("branchIndex",branchIndex);
								StringBuilder sb=new StringBuilder();
								for(int i=1;i<fj.length;i++){
									sb.append(fj[i]+"、");
								}
								if(sb.length()>0){
									qMap.put("qcontent",sb.substring(0,sb.length()-1));
								}else{
									qMap.put("qcontent","");
								}
								qMap.put("iscon",1);
								qList.add(qMap);
								flag=1;
								aIndex=0;
							}else if(fj[0].equals(numberToLetter(aIndex+1))){
								if(content.indexOf(numberToLetter(aIndex+2)+"、")>0) {
									long endTime = System.currentTimeMillis();
									rtn.put("times", (float)(endTime-startTime));
									rtn.put("message", "第"+(qIndex)+"题的"+numberToLetter(aIndex+1)+"选项与"+numberToLetter(aIndex+2)+"选项之间的回车符号错误，重新编辑回车后再导入。<br>可尝试采用快速替换的方法：^l替换^p<br>");
									return rtn;
								}
								aIndex++;
								Map<String,Object> aMap= new HashMap<>();
								aMap.put("qIndex",qIndex);
								aMap.put("aIndex",aIndex);
								StringBuilder sb=new StringBuilder();
								for(int i=1;i<fj.length;i++){
									sb.append(fj[i]+"、");
								}
								if(sb.length()>0){
									aMap.put("acontent",sb.substring(0,sb.length()-1));
								}else{
									aMap.put("acontent","");
								}
								if(iscon==1){
									aMap.put("branchIndex",branchIndex);
								}
								answerList.add(aMap);
								flag=2;
							}else{
								if(flag==0){
									String str=(String)qtList.get(qtList.size()-1).get("qtName");
									str=str+content;
									qtList.get(qtList.size()-1).put("qtName",str);
								}else if(flag==1){
									String str=(String)qList.get(qList.size()-1).get("qcontent");
									str=str+"<br>"+content;
									qList.get(qList.size()-1).put("qcontent",str);
								}else if(flag==2){
									String str=(String)answerList.get(answerList.size()-1).get("acontent");
									str=str+"<br>"+content;
									answerList.get(answerList.size()-1).put("acontent",str);
								}else if(flag==3) {
									String str=(String)qList.get(qList.size()-1).get("answer");
									str=str+"<br>"+content;
									qList.get(qList.size()-1).put("answer",str);
								}
							}
						}else{
							if(flag==0){
								String str=(String)qtList.get(qtList.size()-1).get("qtName");
								str=str+content;
								qtList.get(qtList.size()-1).put("qtName",str);
							}else if(flag==1){
								String str=(String)qList.get(qList.size()-1).get("qcontent");
								str=str+"<br>"+content;
								qList.get(qList.size()-1).put("qcontent",str);
							}else if(flag==2){
								String str=(String)answerList.get(answerList.size()-1).get("acontent");
								str=str+content;
								answerList.get(answerList.size()-1).put("acontent",str);
							}else if(flag==3) {
								String str=(String)qList.get(qList.size()-1).get("answer");
								str=str+"<br>"+content;
								qList.get(qList.size()-1).put("answer",str);
							}
						}
					}

				}
			}
			for(Map qtMap:qtList){
				String qtid_=(String)qtMap.get("qtid");
				int atid_=Integer.parseInt(String.valueOf(qtMap.get("atid")));
				int iscon_=Integer.parseInt(String.valueOf(qtMap.get("iscon")));
				for(int i=0;i<qList.size();i++){
					Map<String,Object> qMap=qList.get(i);
					if(qtid_.equals(String.valueOf(qMap.get("qtid")))){
						String mqid="";
						int mqindex=0;
						if(iscon_==1){
							Map mainQuestion = new HashMap();
							mainQuestion.put("knowledgeid", "1");
							mainQuestion.put("cognitionid", "1");
							mainQuestion.put("difficultyid", "1");

							String questionContent=String.valueOf(qMap.get("qcontent"));
							questionContent=questionContent.trim();

							if(questionContent.lastIndexOf("]")==questionContent.length()-1) {
								try {
									String csString=questionContent.substring(questionContent.lastIndexOf("[")+1,questionContent.length()-1);
									String[] csStr=csString.split("\\|");
									questionContent=questionContent.substring(0,questionContent.lastIndexOf("["));
									Map<String,Object> kmap = knowledgeMap.get(csStr[0]);
									if(kmap==null){
										long endTime = System.currentTimeMillis();
										rtn.put("times", (float)(endTime-startTime));
										rtn.put("message", "第"+mqindex+"题的知识点类型不存在，请在课程中添加或勾选此知识点类型");
										return rtn;
									}
									mainQuestion.put("knowledgeid", kmap.get("ID"));
									Map<String,Object> cmap = coMap.get(csStr[1]);
									if(cmap==null){
										long endTime = System.currentTimeMillis();
										rtn.put("times", (float)(endTime-startTime));
										rtn.put("message", "第"+mqindex+"题的认知类型不存在，请在课程中添加或勾选此认知类型");
										return rtn;
									}
									mainQuestion.put("cognitionid", cmap.get("ID"));
									Map<String,Object> dmap = diffMap.get(csStr[2]);
									if(dmap==null){
										long endTime = System.currentTimeMillis();
										rtn.put("times", (float)(endTime-startTime));
										rtn.put("message", "第"+mqindex+"题的难度类型不存在，请在课程中添加或勾选此难度类型");
										return rtn;
									}
									mainQuestion.put("difficultyid", dmap.get("ID"));
								}catch(Exception e) {}
							}
							questionContent = Utils.stripHtml4WordImport(questionContent);
							String mcontent="<p><span style='font-family: \"Times New Roman\", 宋体; font-size: 16px;'>"+questionContent+"</span></p>";
							int answerNum=0;
							if("155".equals(qtid_)||"156".equals(qtid_)){ //B1型题
								while(answerNum<26){
									String str=String.valueOf((char)('A'+answerNum))+"、";
									if(mcontent.indexOf(str)>=0){
										answerNum++;
									}else{
										break;
									}
								}
								if(answerNum<2){
									long endTime = System.currentTimeMillis();
									rtn.put("times", (float)(endTime-startTime));
									rtn.put("message", "文档中B1题型的主题干没有按要求（选项由大写字母+中文符号“、”组成，如：A、B、C、）设置选项格式。<br>");
									return rtn;
								}

							}

							mainQuestion.put("cid", cid);
							mainQuestion.put("qtiscon", iscon_);
							mainQuestion.put("addtime", new Date());
							mainQuestion.put("ismain", 1);
							mainQuestion.put("answertime", 45);
							mainQuestion.put("realdifficulty",0);
							mainQuestion.put("distinction", 0);
							mainQuestion.put("count", 0);
							mainQuestion.put("qtid", qtid_);
							mainQuestion.put("creatorid", ((User) SecurityUtils.getSubject().getSession().getAttribute("userInfo")).getId());
							mainQuestion.put("creatorname", ((User) SecurityUtils.getSubject().getSession().getAttribute("userInfo")).getRealname());
							mainQuestion.put("verifyid", "");
							mainQuestion.put("verifyname", "");
							mainQuestion.put("state", 0);
							mainQuestion.put("content", mcontent);
							mainQuestion.put("isconId", i);
							mainQuestion.put("theme1id", th1id);
							mainQuestion.put("theme2id", th2id);
							mainQuestion.put("theme3id", th3id);
							mainQuestion.put("filepath", "");
							mainQuestion.put("mqid", "");
							mainQuestion.put("sourceid",1);
							mainQuestion.put("arrangeid", 4);
							mainQuestion.put("atid", atid_);
							mainQuestion.put("num",0);
							Map rs = null;
							if("0".equals(repeat)) {
								rs = getQuestionExist(questionPool, mainQuestion, "2");
							}else {
								rs = getQuestionExist(questionPool, mainQuestion, repeat);
							}

							mainQuestion.put("id", rs.get("id"));
							mainQuestion.put("answerid", "");
							mainQuestion.put("answerexplain", "");
							mqid = rs.get("id").toString();
							mqindex=(Integer)qMap.get("qIndex");

							if(StringUtils.isEmpty(rs.get("exist"))) {
								addIntoPool(questionPool, mainQuestion);
								addIntoPool(insertQuestionPool, mainQuestion);
							}

							for(int j=i+1;j<qList.size();j++){
								Map bMap=qList.get(j);
								if(mqindex==(Integer)bMap.get("qIndex")){
									int branchIndex_=(Integer)bMap.get("branchIndex");
									i++;

									Map question = new HashMap();
									String bcontent=(String)bMap.get("qcontent");
									bcontent=bcontent.trim();
									question.put("knowledgeid", "1");
									question.put("cognitionid", "1");
									question.put("difficultyid", "1");

									if(bcontent.lastIndexOf("]")==bcontent.length()-1) {
										try {
											String csString=bcontent.substring(bcontent.lastIndexOf("[")+1,bcontent.length()-1);
											String[] csStr=csString.split("\\|");
											bcontent=bcontent.substring(0,bcontent.lastIndexOf("["));

											Map<String,Object> kmap = knowledgeMap.get(csStr[0]);
											if(kmap==null){
												long endTime = System.currentTimeMillis();
												rtn.put("times", (float)(endTime-startTime));
												rtn.put("message", "第"+mqindex+"题的第"+branchIndex_+"个分支知识点类型不存在，请在课程中添加或勾选此知识点类型");
												return rtn;
											}
											question.put("knowledgeid", kmap.get("ID"));
											Map<String,Object> cmap = coMap.get(csStr[1]);
											if(cmap==null){
												long endTime = System.currentTimeMillis();
												rtn.put("times", (float)(endTime-startTime));
												rtn.put("message", "第"+mqindex+"题的第"+branchIndex_+"个认知类型不存在，请在课程中添加或勾选此认知类型");
												return rtn;
											}
											question.put("cognitionid", cmap.get("ID"));
											Map<String,Object> dmap = diffMap.get(csStr[2]);
											if(dmap==null){
												long endTime = System.currentTimeMillis();
												rtn.put("times", (float)(endTime-startTime));
												rtn.put("message", "第"+mqindex+"题的第"+branchIndex_+"个难度类型不存在，请在课程中添加或勾选此难度类型");
												return rtn;
											}
											question.put("difficultyid", dmap.get("ID"));
										}catch(Exception e) {}
									}

									List<Map<String,Object>> answerList_ = new ArrayList<>();
									if("155".equals(qtid_)||"156".equals(qtid_)){ //B1型题
										for(int ii=0;ii<answerNum;ii++){
											Map<String,Object> aMap= new HashMap<>();
											aMap.put("aIndex",ii+1);
											aMap.put("acontent",String.valueOf((char)('A'+ii)));
											answerList_.add(aMap);
										}
									}else{
										for(int ii=0;ii<answerList.size();ii++){
											if(mqindex==(Integer)answerList.get(ii).get("qIndex")&&branchIndex_==(Integer)answerList.get(ii).get("branchIndex")){
												answerList_.add(answerList.get(ii));
											}
										}
									}
									if(atid_ < 4 || atid_ == 8 || atid_ == 9) {
										if(answerList_.size()==0){
											long endTime = System.currentTimeMillis();
											rtn.put("times", (float)(endTime-startTime));
											rtn.put("message", "第"+mqindex+"题的第"+branchIndex_+"个分支答案格式不正确。");
											return rtn;
										}
									}

									String tcontent = String.valueOf(bMap.get("answer"));//正确答案

									question.put("content", "<p><span style='font-family: \"Times New Roman\", 宋体; font-size: 16px;'>"+bcontent+"</span></p>");

									question.put("cid", cid);
									question.put("qtid", qtid_);
									question.put("ismain", 0);
									question.put("isconId", j);
									question.put("atid", atid_);
									if(!"0".equals(repeat)) {
										int amax = answerList_.size();
										StringBuilder sb=new StringBuilder();
										for(int i1 = 0 ; i1 < amax; i1++) {
											String acontent = (String)answerList_.get(i1).get("acontent");
											if(!StringUtils.isEmpty(acontent)) {
												sb.append(acontent+"!!!!!");
											}
										}
										String str=sb.substring(0, sb.length()-5);
										String[] c=str.split("!!!!!");
										question.put("acontent", c);
									}
									Map m = getQuestionExist(questionPool,question,repeat);//此方法返回id和exist
									if(StringUtils.isEmpty(m.get("exist"))) {
										//exist不存在则表明题目不存在数据库
										String qid = (String) m.get("id");
										question.put("id", qid);
										question.put("addtime", new Date());
										question.put("answertime", 45);
										question.put("realdifficulty",0);
										question.put("distinction",0);
										question.put("count",0);
										question.put("creatorid", ((User) SecurityUtils.getSubject().getSession().getAttribute("userInfo")).getId());
										question.put("creatorname", ((User) SecurityUtils.getSubject().getSession().getAttribute("userInfo")).getRealname());
										question.put("verifyid", "");
										question.put("verifyname", "");
										question.put("state", 0);
										question.put("theme1id", th1id);
										question.put("theme2id", th2id);
										question.put("theme3id", th3id);
										question.put("sourceid", 1);
										question.put("arrangeid", 4);
										question.put("filepath", "");
										question.put("mfilepath","");
										question.put("num",0);
										question.put("mqid", mqid);
										question.put("qtiscon", 1);
										//处理答案
										String trueAnswerId = "";
										if(atid_ < 4 || atid_ == 8 || atid_ == 9) {
											int max = answerList_.size();
											String[] aids = new String[max];
											Set<String> acontentSet = new HashSet<>();
											for(int jj = 0; jj < max; jj++) {
												String acontent = (String) answerList_.get(jj).get("acontent");
												if(acontent!=null){
													acontent = Utils.stripHtml4WordImport(acontent);
												}
												if(!acontentSet.contains(acontent)){
													acontentSet.add(acontent);
												}else {
													rtn.put("code", -1);
													rtn.put("message", "第"+mqindex+"题的第"+branchIndex_+"个分支选项内容存在重复。");
													long endTime = System.currentTimeMillis();
													rtn.put("times", (float)(endTime-startTime));
													return rtn;
												}
												String aid = questionService.getAnswerID();
												aids[jj] = aid;
												Map answer = new HashMap();
												answer.put("qid", qid);
												answer.put("atid", atid_);
												answer.put("aid", aid);
												if(acontent.length()>3999) {
													answer.put("content", "");
													answer.put("content_6",acontent);
												}else {
													answer.put("content", acontent);
													answer.put("content_6","");
												}

												answerPool.add(answer);
											}
											char[] correct = tcontent.toCharArray();
											StringBuilder sb = new StringBuilder();
											for(char cc:correct) {
												int index = (int)cc-65;
												if(index >= 0 && index < aids.length) {
													sb.append(aids[index]+",");
												}
											}
											if(sb!=null&&sb.length()>0){
												trueAnswerId = sb.toString().substring(0,sb.toString().length()-1);
												//答案排序
												if(trueAnswerId.indexOf(",")>0){
													String[] trueA=trueAnswerId.split(",");
													Arrays.sort(trueA);
													trueAnswerId="";
													for(String str:trueA){
														trueAnswerId+=str+",";
													}
													trueAnswerId=trueAnswerId.substring(0,trueAnswerId.length()-1);
												}
											}else{
												trueAnswerId = "";
											}

										}else if(atid_ == 4) {
											String aid = questionService.getAnswerID();
											String acontent = "false";
											if(tcontent.substring(0,1).equals("对") || tcontent.substring(0,1).equals("是") || tcontent.substring(0,1).equals("√")) {
												acontent = "true";
											}
											Map answer = new HashMap();
											answer.put("qid", qid);
											answer.put("atid", atid_);
											answer.put("aid", aid);
											answer.put("content", acontent);
											answer.put("content_6", "");

											answerPool.add(answer);
											trueAnswerId = aid;
										}else if(atid_ > 4 && atid_ < 8 || atid_ > 9) {
											String aid = questionService.getAnswerID();
											Map answer = new HashMap();
											answer.put("qid", qid);
											answer.put("atid", atid_);
											answer.put("aid", aid);
											answer.put("content", "");
											answer.put("content_6", tcontent);

											answerPool.add(answer);
											trueAnswerId= aid;
										}
										if(!"".equals(trueAnswerId)) {
											question.put("answerid", trueAnswerId);
											question.put("answerexplain","");
											addIntoPool(questionPool, question);
											addIntoPool(insertQuestionPool, question);
										}
									}
								}
							}
						}else{//非串题
							Map question = new HashMap();
							question.put("knowledgeid", "1");
							question.put("cognitionid", "1");
							question.put("difficultyid", "1");

							String qcontent=String.valueOf(qMap.get("qcontent"));
							qcontent=qcontent.trim();
							if(qcontent.lastIndexOf("]")==qcontent.length()-1) {
								try {
									String csString=qcontent.substring(qcontent.lastIndexOf("[")+1,qcontent.length()-1);
									String[] csStr=csString.split("\\|");
									qcontent=qcontent.substring(0,qcontent.lastIndexOf("["));
									Map<String,Object> kmap = knowledgeMap.get(csStr[0]);
									if(kmap==null){
										long endTime = System.currentTimeMillis();
										rtn.put("times", (float)(endTime-startTime));
										rtn.put("message", "第"+qMap.get("qIndex")+"题的分支知识点类型不存在，请在课程中添加或勾选此知识点类型");
										return rtn;
									}
									question.put("knowledgeid", kmap.get("ID"));
									Map<String,Object> cmap = coMap.get(csStr[1]);
									if(cmap==null){
										long endTime = System.currentTimeMillis();
										rtn.put("times", (float)(endTime-startTime));
										rtn.put("message", "第"+qMap.get("qIndex")+"题的认知类型不存在，请在课程中添加或勾选此认知类型");
										return rtn;
									}
									question.put("cognitionid", cmap.get("ID"));
									Map<String,Object> dmap = diffMap.get(csStr[2]);
									if(dmap==null){
										long endTime = System.currentTimeMillis();
										rtn.put("times", (float)(endTime-startTime));
										rtn.put("message", "第"+qMap.get("qIndex")+"题的难度类型不存在，请在课程中添加或勾选此难度类型");
										return rtn;
									}
									question.put("difficultyid", dmap.get("ID"));
								}catch(Exception e) {}
							}

							qcontent ="<p><span style='font-family: \"Times New Roman\", 宋体; font-size: 16px;'>"+qcontent+"</span></p>";
							String tcontent =(String)qMap.get("answer"); //正确答案
							int qIndex_=(Integer)qMap.get("qIndex");
							List<Map<String,Object>> answerList_ = new ArrayList<>();

							if(atid_ == 0 || atid_ == 1) {
								for(int ii=0;ii<answerList.size();ii++){
									if(qIndex_==(Integer)answerList.get(ii).get("qIndex")){
										answerList_.add(answerList.get(ii));
									}
								}
								if(answerList_.size()==0){
									long endTime = System.currentTimeMillis();
									rtn.put("times", (float)(endTime-startTime));
									rtn.put("message", "第"+qIndex_+"题的答案格式不正确。");
									return rtn;
								}
								if(!"0".equals(repeat)) {
									int amax = answerList_.size();
									StringBuilder sb=new StringBuilder();
									for(int i1 = 0 ; i1 < amax; i1++) {
										String acontent = (String)answerList_.get(i1).get("acontent");
										if(!StringUtils.isEmpty(acontent)) {
											sb.append(answerList_.get(i1)+"!!!!!");
										}
									}
									String str=sb.substring(0, sb.length()-5);
									String[] c=str.split("!!!!!");
									question.put("acontent", c);
								}
							}

							Map m = getQuestionExist(questionPool,question,repeat);//此方法返回id和exist
							if(StringUtils.isEmpty(m.get("exist"))) {
								//exist不存在则表明题目不存在数据库
								String qid = (String) m.get("id");
								question.put("id", qid);
								question.put("cid", cid);
								question.put("qtid", qtid_);
								question.put("ismain", 0);
								question.put("isconId","");
								question.put("atid", atid_);
								question.put("content", qcontent);
								question.put("addtime", new Date());
								question.put("answertime", 45);
								question.put("realdifficulty",0);
								question.put("distinction",0);
								question.put("count",0);
								question.put("creatorid", ((User) SecurityUtils.getSubject().getSession().getAttribute("userInfo")).getId());
								question.put("creatorname", ((User) SecurityUtils.getSubject().getSession().getAttribute("userInfo")).getRealname());
								question.put("verifyid", "");
								question.put("verifyname", "");
								question.put("state", 0);
								question.put("theme1id", th1id);
								question.put("theme2id", th2id);
								question.put("theme3id", th3id);
								question.put("sourceid", 1);
								question.put("arrangeid", 4);
								question.put("filepath", "");
								question.put("mfilepath","");
								question.put("num",0);
								question.put("mqid","");
								question.put("qtiscon", 0);
								//处理答案
								String trueAnswerId = "";
								if(atid_ < 4 || atid_ == 8 || atid_ == 9) {
									int max = answerList_.size();
									String[] aids = new String[max];
									Set<String> acontentSet = new HashSet<>();
									for(int jj = 0; jj < max; jj++) {
//											String acontent = getQuestionTxt((String)answerList_.get(jj).get("acontent"));
										String acontent = (String)answerList_.get(jj).get("acontent");
										if(acontent!=null){
											acontent = Utils.stripHtml4WordImport(acontent);
										}
										if(!acontentSet.contains(acontent)){
											acontentSet.add(acontent);
										}else {
											rtn.put("code", -1);
											rtn.put("message", "第“"+qMap.get("qIndex")+"”题选项内容存在重复。");
											long endTime = System.currentTimeMillis();
											rtn.put("times", (float)(endTime-startTime));
											return rtn;
										}
										String aid = questionService.getAnswerID();
										aids[jj] = aid;
										Map answer = new HashMap();
										answer.put("qid", qid);
										answer.put("atid", atid_);
										answer.put("aid", aid);
										if(acontent.length()>3999) {
											answer.put("content", "");
											answer.put("content_6",acontent);
										}else {
											answer.put("content", acontent);
											answer.put("content_6","");
										}

										answerPool.add(answer);
									}
									char[] correct = tcontent.toCharArray();
									StringBuilder sb = new StringBuilder();
									for(char cc:correct) {
										int index = (int)cc-65;
										if(index >= 0 && index < aids.length) {
											sb.append(aids[index]+",");
										}
									}
									if(sb!=null&&sb.length()>0){
										trueAnswerId = sb.toString().substring(0,sb.toString().length()-1);
										//答案排序
										if(trueAnswerId.indexOf(",")>0){
											String[] trueA=trueAnswerId.split(",");
											Arrays.sort(trueA);
											trueAnswerId="";
											for(String str:trueA){
												trueAnswerId+=str+",";
											}
											trueAnswerId=trueAnswerId.substring(0,trueAnswerId.length()-1);
										}
									}else{
										trueAnswerId = "";
									}

								}else if(atid_ == 4) {
									String aid = questionService.getAnswerID();
									String acontent = "false";
									if(tcontent.substring(0,1).equals("对") || tcontent.substring(0,1).equals("是") || tcontent.substring(0,1).equals("√")) {
										acontent = "true";
									}
									Map answer = new HashMap();
									answer.put("qid", qid);
									answer.put("atid", atid_);
									answer.put("aid", aid);
									answer.put("content", acontent);
									answer.put("content_6", "");

									answerPool.add(answer);
									trueAnswerId = aid;
								}else if(atid_ > 4 && atid_ < 8 || atid_ > 9) {
									String aid = questionService.getAnswerID();
									Map answer = new HashMap();
									answer.put("qid", qid);
									answer.put("atid", atid_);
									answer.put("aid", aid);
									answer.put("content", "");
									answer.put("content_6", tcontent);

									answerPool.add(answer);
									trueAnswerId= aid;
								}
								if(!"".equals(trueAnswerId)) {
									question.put("answerid", trueAnswerId);
									question.put("answerexplain","");
									addIntoPool(questionPool, question);
									addIntoPool(insertQuestionPool, question);
								}
							}
						}
					}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		if(insertQuestionPool.size() > 0) {
			questionService.insertQuestionForImportQuestion(insertQuestionPool);
			questionService.insertAnswerForImportQuestion(answerPool);
		}
		rtn.put("code", 0);
		String mes = "已导入"+insertQuestionPool.size()+"条试题。<br/>";
		long endTime = System.currentTimeMillis();
		rtn.put("times", (float)(endTime-startTime));
		rtn.put("message", mes);
		questionService.call_updateCourseQuestioncount(cid);
		return rtn;
	}

	@Override
	public String importCourse(MultipartFile mFile) {
		String fileName = mFile.getOriginalFilename();
		String suffix = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length());
		String ym = DateFormatUtils.getNowDay();
		String filePath = "/uploadFile/excel/course/" + ym + fileName;
		Path target = Paths.get(WebFilePath.getProjectPath(), filePath);
		try {
			Files.deleteIfExists(target);
			Files.createDirectories(target.getParent());
			mFile.transferTo(target.toFile());
			if (!"xls".equals(suffix.toLowerCase()) && !"xlsx".equals(suffix.toLowerCase())) {
				Files.deleteIfExists(target);
				return "导入文件类型不正确";
			}
		} catch (IOException e) {
			throw new RuntimeException(e);
		}

		try (InputStream is = Files.newInputStream(target);
			 Workbook wb = WorkbookFactory.create(is)) {
			Sheet sheet = wb.getSheetAt(0);
			int rowNum = sheet.getLastRowNum();
			//检查课程名称、所属学院以及学时数是否为空
			List<Map<String, Object>> uList = new ArrayList<>();
			List<Map<String, Object>> dList = new ArrayList<>();
			for (int i = 1; i <= rowNum; i++) {
				Row row = sheet.getRow(i);
				if (Utils.nullOrEmpty(getCellFormatValue(row.getCell(0))) || Utils.nullOrEmpty(getCellFormatValue(row.getCell(2))) || Utils.nullOrEmpty(getCellFormatValue(row.getCell(6)))) {
					return "-1";
				}
				String name_c = getCellFormatValue(row.getCell(0));
				Map cm = new HashMap();
				cm.put("val", name_c);
				if (Integer.parseInt(courseService.getCount(cm)) > 0) {    //检查该课程是否已经存在或为空
					return i + "c";
				}
				String uname = getCellFormatValue(row.getCell(2));
				Map<String, Object> uMap = commonService.getUnitByName(uname);
				if (uMap != null) {
					uList.add(uMap);
					String deptname = getCellFormatValue(row.getCell(3));
					if (deptname != null && !"".equals(deptname)) {
						Map dm = new HashMap<String, Object>();
						dm.put("dname", deptname);
						dm.put("uid", uMap.get("ID"));
						String deptId = commonService.getDeptByName(dm);

						if (deptId == null || "".equals(deptId)) {
							continue;
						} else {
							dm.put("deptId", deptId);
							dList.add(dm);
						}
					}
				} else {
					return i + "d";
				}
			}
			List<Map<String, Object>> qtList = commonService.defaultQuestionType();
			List<Map<String, Object>> etlist = commonService.defaultExamType();
			List<Map<String, Object>> splist = commonService.defaultSpecialty();
			List<Map<String, Object>> dflist = commonService.defaultDifficulty();
			List<Map<String, Object>> kllist = commonService.defaultKnowledge();
			List<Map<String, Object>> sclist = commonService.defaultSource();
			List<Map<String, Object>> ctList = commonService.defaultCognition();
			for (int i = 1; i <= rowNum; i++) {
				Row row = sheet.getRow(i);
				Map course = new HashMap();
				String cid = courseService.getCourseID();
				course.put("id", cid);

				String name_c = getCellFormatValue(row.getCell(0));
				course.put("val", name_c);
				if (Utils.nullOrEmpty(name_c) || Integer.parseInt(courseService.getCount(course)) > 0) {    //检查该课程是否已经存在或为空
					continue;
				}
				course.put("name_c", name_c);
				course.put("code", getCellFormatValue(row.getCell(1)));
				String uname = getCellFormatValue(row.getCell(2));
				for (Map<String, Object> um : uList) {
					if (uname.equals(um.get("NAME"))) {
						course.put("unitId", um.get("ID"));
						break;
					}
				}
				String deptname = getCellFormatValue(row.getCell(3));
				course.put("deptId", "");
				if (deptname != null && !"".equals(deptname)) {
					for (Map<String, Object> dm : dList) {
						if (deptname.equals(dm.get("dname"))) {
							course.put("deptId", dm.get("deptId"));
							break;
						}
					}
				}

				String contact = getCellFormatValue(row.getCell(4));
				List<Map<String, Object>> tList = userService.findByRealname(contact);
				course.put("contact", contact);
				if (tList != null && tList.size() > 0) {
					course.put("contactid", tList.get(0).get("ID"));
				}
				course.put("tel", getCellFormatValue(row.getCell(5)));
				course.put("period", getCellFormatValue(row.getCell(6)));

				course.put("name_e", "");
				course.put("shortname", "");
				course.put("open", 0);

				List<Map<String, Object>> arrlist = new ArrayList<>();
				Map<String, Object> arrMap = new HashMap<>();
				arrMap.put("ID", 4);
				arrMap.put("NAME", "本科生");
				arrlist.add(arrMap);
				course.put("arrangement", arrlist);

				course.put("questionType", qtList);
				course.put("examType", etlist);
				course.put("specialty", splist);
				course.put("difficulty", dflist);

				course.put("knowledge", kllist);
				course.put("cognition", ctList);
				course.put("source", sclist);
				course.put("creator", "");
				course.put("creatorid", "");
				course.put("creattime", new Date());

				courseService.importCourse(course);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "0";
	}

	public static String numberToLetter(int num) {
		if (num <= 0) {
			return null;
		}
		String letter = "";
		num--;
		do {
			if (letter.length() > 0) {
				num--;
			}
			letter = ((char) (num % 26 + (int) 'A')) + letter;
			num = (int) ((num - num % 26) / 26);
		} while (num > 0);

		return letter;
	}

	private static List<Map<String, String>> getParagraph(XWPFParagraph para) {
		List<XWPFRun> runsLists = para.getRuns();
		List<Map<String, String>> list = new ArrayList<>();
		Map<String, String> titile = new HashMap<>();
		titile.put("Text", para.getText());//本段全部内容
		titile.put("Alignment", para.getAlignment().toString());
		titile.put("SpacingBetween", para.getSpacingBetween() + "");//行距
		titile.put("SpacingBeforeLines", para.getSpacingBeforeLines() + "");//段前
		titile.put("SpacingAfterLines", para.getSpacingAfterLines() + "");//段后
		titile.put("NumLevelText", para.getNumLevelText() + "");//自动编号格式

		list.add(titile);
		//先判断缩进方式再进行数值计算
		double ind = -1, ind_left = -1, ind_right = -1, ind_hang = -1;
		String ind_type = "";
		if (para.getIndentationHanging() != -1) {//悬挂缩进
			ind_type = "hang";
			if (para.getIndentationHanging() % 567 == 0) {//悬挂单位为厘米
				ind = para.getIndentationHanging() / 567.0;
				ind_left = (para.getIndentationLeft() - 567.0 * ind) / 210;
			} else {//悬挂单位为字符
				ind = para.getIndentationHanging() / 240;
				ind_left = (para.getIndentationLeft() - para.getIndentationHanging()) / 210;
			}
			ind_right = para.getIndentationRight() / 210.0;
		} else {//首行缩进或者无
			ind_type = "first";
			if (para.getFirstLineIndent() == -1) {
				ind_type = "none";
				ind = 0;
			} else {
				ind = para.getFirstLineIndent() % 567.0 == 0 ? para.getFirstLineIndent() / 567.0 : para.getFirstLineIndent() / 240.0;
			}
			ind_left = para.getIndentationLeft() / 210;
			ind_right = para.getIndentationRight() / 210.0;
		}

		//System.out.println(ind_type+","+ind+","+ind_left+","+ind_right);

		for (XWPFRun run : runsLists) {

			List<XWPFPicture> pictures = run.getEmbeddedPictures();
			if (pictures.size() > 0) {
				XWPFPicture picture = pictures.get(0);


				XWPFPictureData pictureData = picture.getPictureData();
				//System.out.println(pictureData.getPictureType());
				// System.out.println(picture);
				//实现不了查询图片环绕方式
				Base64.Encoder encoder = Base64.getEncoder();
				System.out.println(encoder.encode(pictureData.getData()));
			}

			Map<String, String> titile_map = new HashMap<>();
			titile_map.put("content", run.getText(0));
			String Bold = Boolean.toString(run.isBold());//加粗
			titile_map.put("Bold", Bold);
			String color = run.getColor();//字体颜色
			titile_map.put("Color", color);

			String FontFamily = run.getFontFamily(XWPFRun.FontCharRange.hAnsi);//字体
			titile_map.put("FontFamily", FontFamily);

			String FontName = run.getFontName();//字体
			titile_map.put("FontName", FontName);

			String FontSize = run.getFontSize() + "";//字体大小
			titile_map.put("FontSize", FontSize);

			String Underline = run.getUnderline().name();//字下加线
			titile_map.put("Underline", Underline);

			String UnderlineColor = run.getUnderlineColor();//字下加线颜色
			titile_map.put("UnderlineColor", UnderlineColor);

			String Italic = Boolean.toString(run.isItalic());//字体倾斜
			titile_map.put("Italic", Italic);
			list.add(titile_map);

		}
		return list;
	}

	@Override
	public void exportWorkloadExcelZipOnlyTotal(String username, Map<String,Object> param){
		Path userFolder = Paths.get(
				WebFilePath.getProjectPath(),
				"tmpUser",
				username,
				"workloadExcelZip"
		);
		LocalCache cache = LocalCache.getInstance();
		try {
			if (!Files.exists(userFolder) || !Files.isDirectory(userFolder)) {
				Files.deleteIfExists(userFolder);
				Files.createDirectories(userFolder);
			}
			List<Map<String, Object>> workLoadTotalAll = questionService.getWorkLoadTotalAll(param);
			Progress progress = new Progress(workLoadTotalAll.size());
			cache.set("analysis_mission", username + "_exportWorkload", progress);
			try (XSSFWorkbook book = new XSSFWorkbook()) {
				Path out = userFolder.resolve("课程新增、更新工作量汇总.xlsx");
				String sheetName = "全部时间段";
				Map<String,Object> param2 = new HashMap<>();
				if(param.get("beginDate")!=null && param.get("endDate")!=null){
					param2.put("beginDate", param.get("beginDate"));
					param2.put("endDate", param.get("endDate"));
					Date beginDate = DateFormatUtils.parseDate(String.valueOf(param.get("beginDate")));
					Date endDate = DateFormatUtils.parseDate(String.valueOf(param.get("endDate")));
					sheetName = "筛选自 "+DateFormatUtils.formatDate4ZhCN(beginDate)+"至"+DateFormatUtils.formatDate4ZhCN(endDate);
				}
				Sheet sheet = book.createSheet(sheetName);
				Row row0 = sheet.createRow(0);
				row0.createCell(0).setCellValue("课程名称");
				row0.createCell(1).setCellValue("所属单位");
				row0.createCell(2).setCellValue("所属科室");
				row0.createCell(3).setCellValue("新增试题");
				row0.createCell(4).setCellValue("更新试题");
				for(int i=0;i<workLoadTotalAll.size();i++) {
					Map<String,Object> workload = workLoadTotalAll.get(i);
					String cid = String.valueOf(workload.get("CID"));
					String cname = Parser.unescapeEntities(String.valueOf(workload.get("CNAME")), false);
					param2.put("cid", cid);
					Row row = sheet.createRow(i+1);
					row.createCell(0).setCellValue(cname);
					row.createCell(1).setCellValue(Objects.toString(workload.get("UNAME"),""));
					row.createCell(2).setCellValue(Objects.toString(workload.get("DEPTNAME"),""));
					row.createCell(3).setCellValue(Utils.changeObjToInt(workload.get("QCOUNT")));
					row.createCell(4).setCellValue(Utils.changeObjToInt(workload.get("UQCOUNT")));
					progress.addProgressNum();
					cache.set("analysis_mission", username + "_exportWorkload", progress);
				}
				try (OutputStream os = Files.newOutputStream(out, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING)) {
					book.write(os);
				}
			} catch (Exception e){
				throw e;
			}

			List<File> excelFiles;
			try (Stream<Path> stream = Files.list(userFolder)) {
				excelFiles = stream
						.filter(Files::isRegularFile)
						.filter(p -> p.getFileName().toString().toLowerCase().endsWith(".xlsx"))// 只打包 Excel
						.map(Path::toFile)
						.collect(Collectors.toList());
			}

			if (!excelFiles.isEmpty()) {
				String zipName = "课程新增、更新工作量汇总 "+DateFormatUtils.getNowTime4ZhCN() + ".zip";
				Path zipPath = userFolder.resolve(zipName);
				ZipFile zipFile = new ZipFile(zipPath.toFile());
				zipFile.addFiles(excelFiles);
				try (FileChannel ch = FileChannel.open(zipPath, StandardOpenOption.READ)) {
					ch.force(true);
				} catch (Exception ignore) { /* 可忽略 */ }
			}

			try (java.util.stream.Stream<Path> paths = Files.list(userFolder)) {
				paths.filter(Files::isRegularFile)
						.filter(p -> {
							String n = p.getFileName().toString().toLowerCase();
							return n.endsWith(".xlsx") || n.endsWith(".xls");
						})
						.forEach(p -> {
							try { Files.deleteIfExists(p); }
							catch (Exception e) { e.printStackTrace(); }
						});
			}
		} catch (Exception e){
			e.printStackTrace();
		}finally {
			cache.evict("analysis_mission", username + "_exportWorkload");
		}
	}

	@Override
	public void exportWorkloadExcelZip(String username, Map<String,Object> param) {
		Path userFolder = Paths.get(
				WebFilePath.getProjectPath(),
				"tmpUser",
				username,
				"workloadExcelZip"
		);
		LocalCache cache = LocalCache.getInstance();
		try {
			if(!Files.exists(userFolder) || !Files.isDirectory(userFolder)){
				Files.deleteIfExists(userFolder);
				Files.createDirectories(userFolder);
			}
			List<Map<String,Object>> courseList = courseService.getCourse(param);
			Progress progress = new Progress(courseList.size());
			cache.set("analysis_mission", username + "_exportWorkload", progress);
			String[] workLoadTypes = {"createWork","updateWork","verifyWork","lastVerifyWork"};
			Map<String, String> workTypeName = new LinkedHashMap<>();
			workTypeName.put("createWork", "新增");
			workTypeName.put("updateWork", "更新");
			workTypeName.put("verifyWork", "审核");
			workTypeName.put("lastVerifyWork", "终审");

			Map<String,Object> param2 = new HashMap<>();
			String sheetName = "全部时间段";
			if(param.get("beginDate")!=null && param.get("endDate")!=null){
				param2.put("beginDate", param.get("beginDate"));
				param2.put("endDate", param.get("endDate"));
				Date beginDate = DateFormatUtils.parseDate(String.valueOf(param.get("beginDate")));
				Date endDate = DateFormatUtils.parseDate(String.valueOf(param.get("endDate")));
				sheetName = "筛选自 "+DateFormatUtils.formatDate4ZhCN(beginDate)+"至"+DateFormatUtils.formatDate4ZhCN(endDate);
			}

			for(Map<String,Object> course : courseList) {
				String cid = String.valueOf(course.get("CID"));
				String cname = String.valueOf(course.get("NAME_C"));
				param2.put("cid", cid);
				try (XSSFWorkbook book = new XSSFWorkbook()) {
					String safeCname = Parser.unescapeEntities(cname, false)
							.replaceAll("[\\\\/:*?\"<>|\\p{Cntrl}]", "_");
					Path out = userFolder.resolve("《"+safeCname+"》工作量.xlsx");
					// 字体
					Font boldFont = book.createFont(); boldFont.setBold(true);
					Font normalFont = book.createFont();

					// 表头样式
					CellStyle header = book.createCellStyle();
					header.setAlignment(HorizontalAlignment.CENTER);
					header.setVerticalAlignment(VerticalAlignment.CENTER);
					header.setBorderTop(BorderStyle.THIN);
					header.setBorderBottom(BorderStyle.THIN);
					header.setBorderLeft(BorderStyle.THIN);
					header.setBorderRight(BorderStyle.THIN);
					header.setFont(boldFont);
					header.setWrapText(true);

					// 普通居中单元格
					CellStyle cellCenter = book.createCellStyle();
					cellCenter.setAlignment(HorizontalAlignment.CENTER);
					cellCenter.setVerticalAlignment(VerticalAlignment.CENTER);
					cellCenter.setBorderTop(BorderStyle.THIN);
					cellCenter.setBorderBottom(BorderStyle.THIN);
					cellCenter.setBorderLeft(BorderStyle.THIN);
					cellCenter.setBorderRight(BorderStyle.THIN);
					cellCenter.setFont(normalFont);

					// 合计行
					CellStyle sumRow = book.createCellStyle();
					sumRow.cloneStyleFrom(cellCenter);
					sumRow.setFillPattern(FillPatternType.SOLID_FOREGROUND);
					sumRow.setFillForegroundColor(IndexedColors.GREY_25_PERCENT.getIndex());
					sumRow.setFont(boldFont);
					sumRow.setWrapText(true);

					List<Map<String,Object>> questionType = questionService.getUsedQuestionTypeByCid(cid);
					if(questionType==null || questionType.isEmpty()) {
						try (OutputStream os = Files.newOutputStream(out, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING)) {
							book.write(os);
						}
						progress.addProgressNum();
						cache.set("analysis_mission", username + "_exportWorkload", progress);
						continue;
					}

					List<String> qtNames = new ArrayList<>();
					for (Map<String,Object> qt : questionType) {
						qtNames.add(String.valueOf(qt.get("QTNAME")));
					}
					int allCount = questionService.getAllQuestionCountBycid(cid);

					Sheet sheet = book.createSheet(sheetName);
					sheet.setDefaultColumnWidth(16);
					sheet.setColumnWidth(0, 12 * 256); // 工作类型
					sheet.setColumnWidth(1, 16 * 256); // 用户实名
					sheet.setColumnWidth(2 + qtNames.size(), 22 * 256); // 总计（更新率会换行）
					sheet.createFreezePane(2, 2); // 冻结前两列两行
					sheet.setDefaultRowHeightInPoints(20);

					// 表头两行
					Row row0 = sheet.createRow(0);
					Row row1 = sheet.createRow(1);

					// 工作类型、用户实名
					Cell c00 = row0.createCell(0); c00.setCellValue("工作类型"); c00.setCellStyle(header);
					Cell c10 = row1.createCell(0); c10.setCellValue("工作类型"); c10.setCellStyle(header);
					Cell c01 = row0.createCell(1); c01.setCellValue("用户实名"); c01.setCellStyle(header);
					Cell c11 = row1.createCell(1); c11.setCellValue("用户实名"); c11.setCellStyle(header);
					sheet.addMergedRegion(new CellRangeAddress(0,1,0,0));
					sheet.addMergedRegion(new CellRangeAddress(0,1,1,1));

					// 题型题量 & 题型名
					for(int i=0;i<qtNames.size();i++){
						Cell cellTop = row0.createCell(2+i);
						cellTop.setCellValue("题型题量");
						cellTop.setCellStyle(header);
						Cell cellBottom = row1.createCell(2+i);
						cellBottom.setCellValue(qtNames.get(i));
						cellBottom.setCellStyle(header);
					}
					if(qtNames.size()>1){
						sheet.addMergedRegion(new CellRangeAddress(0,0,2,2+qtNames.size()-1));
					}

					// 总计
					Cell cTotalTop = row0.createCell(2+qtNames.size());
					cTotalTop.setCellValue("总计"); cTotalTop.setCellStyle(header);
					Cell cTotalBottom = row1.createCell(2+qtNames.size());
					cTotalBottom.setCellValue("总计"); cTotalBottom.setCellStyle(header);
					sheet.addMergedRegion(new CellRangeAddress(0,1, 2+qtNames.size(), 2+qtNames.size()));

					int rowsIndex = 2;
					Map<String, List<Map<String, Object>>> workloadAll = questionService.getWorkLoad(param2);
					for(String workLoadType : workLoadTypes){
						if(workloadAll==null || workloadAll.isEmpty()) continue;
						List<Map<String, Object>> workload = workloadAll.get(workLoadType);
						if(workload==null || workload.isEmpty()) continue;

						int startMergeRow = rowsIndex; // 工作类型列合并起点
						int[] qtSums = new int[qtNames.size()];

						for (int i=0;i<workload.size();i++){
							Map<String,Object> work = workload.get(i);
							Row row = sheet.createRow(rowsIndex+i);

							Cell cellType = row.createCell(0);
							cellType.setCellValue(workTypeName.get(workLoadType));
							cellType.setCellStyle(cellCenter);

							// 用户实名
							Cell nameCell = row.createCell(1);
							nameCell.setCellValue("noResult".equals(work.get("name"))?"未知用户":String.valueOf(work.get("name")));
							nameCell.setCellStyle(cellCenter);

							List<Map<String, Object>> qtcountInfo = (List<Map<String, Object>>) work.get("qtcount");
							int peopleSum = 0;

							for(int j=0;j<qtNames.size();j++){
								Cell vCell = row.createCell(2+j);
								vCell.setCellStyle(cellCenter);
								vCell.setCellValue(0);

								if(qtcountInfo!=null){
									for(Map<String,Object> qtcount : qtcountInfo){
										if(qtNames.get(j).equals(qtcount.get("qtname"))){
											int qcount = Utils.changeObjToInt(qtcount.get("qcount"));
											vCell.setCellValue(qcount);
											peopleSum += qcount;
											qtSums[j] += qcount;
											break;
										}
									}
								}
							}

							Cell sumCell = row.createCell(2+qtNames.size());
							sumCell.setCellStyle(cellCenter);
							sumCell.setCellValue(peopleSum);
						}

						// 合计行
						Row row = sheet.createRow(rowsIndex+workload.size());
						Cell t0 = row.createCell(0); t0.setCellValue(workTypeName.get(workLoadType)); t0.setCellStyle(sumRow);
						Cell t1 = row.createCell(1); t1.setCellValue("合计"); t1.setCellStyle(sumRow);

						int totalSum = 0;
						for(int i=0;i<qtSums.length;i++){
							Cell c = row.createCell(2+i);
							c.setCellValue(qtSums[i]);
							c.setCellStyle(sumRow);
							totalSum += qtSums[i];
						}

						Cell totalCell = row.createCell(2+qtSums.length);
						totalCell.setCellStyle(sumRow);
						if("updateWork".equals(workLoadType)){
							String text = totalSum+"（试题更新率："+ String.format("%.2f%%", (allCount==0?0.0: (double)totalSum/allCount * 100)) +"）";
							totalCell.setCellValue(text);
						}else{
							totalCell.setCellValue(totalSum);
						}

						// 合并左侧“工作类型”列（含合计行）
						sheet.addMergedRegion(new CellRangeAddress(startMergeRow, rowsIndex+workload.size(), 0, 0));
						rowsIndex = rowsIndex + workload.size() + 1;
					}


					// 最后一行：试题新增、更新合计占比
					int createUpdateTotal = 0;
					List<Map<String, Object>> createUpdateList = workloadAll.get("create_updateWork");
					if (createUpdateList != null && !createUpdateList.isEmpty()) {
						Map<String, Object> firstRow = createUpdateList.get(0);
						List<Map<String, Object>> qtcountList = (List<Map<String, Object>>) firstRow.get("qtcount");
						if (qtcountList != null && !qtcountList.isEmpty()) {
							createUpdateTotal = Utils.changeObjToInt(qtcountList.get(0).get("qcount"));
						}
					}

					Row finalRow = sheet.createRow(rowsIndex);
					Cell finalLabelCell = finalRow.createCell(0);
					finalLabelCell.setCellValue("试题新增、更新合计占比");
					finalLabelCell.setCellStyle(sumRow);
					sheet.addMergedRegion(new CellRangeAddress(rowsIndex, rowsIndex, 0, 1 + qtNames.size()));
					for (int i = 1; i <= 1 + qtNames.size(); i++) { // 给被合并区域内的其他单元格也补样式，避免边框/底色丢失
						Cell c = finalRow.createCell(i);
						c.setCellStyle(sumRow);
					}
					Cell finalPercentCell = finalRow.createCell(2 + qtNames.size());
					finalPercentCell.setCellStyle(sumRow);
					finalPercentCell.setCellValue(Utils.percentOf(new BigDecimal(createUpdateTotal), new BigDecimal(allCount)));

					try (OutputStream os = Files.newOutputStream(out, StandardOpenOption.CREATE, StandardOpenOption.TRUNCATE_EXISTING)) {
						book.write(os);
					}
					progress.addProgressNum();
					cache.set("analysis_mission", username + "_exportWorkload", progress);
				} catch (Exception exception) {
					throw exception;
				}
			}
			List<File> excelFiles;
			try (Stream<Path> stream = Files.list(userFolder)) {
				excelFiles = stream
						.filter(Files::isRegularFile)
						.filter(p -> p.getFileName().toString().toLowerCase().endsWith(".xlsx"))// 只打包 Excel
						.map(Path::toFile)
						.collect(Collectors.toList());
			}
			if (!excelFiles.isEmpty()) {
				String zipName = "课程工作量 "+DateFormatUtils.getNowTime4ZhCN() + ".zip";
				Path zipPath = userFolder.resolve(zipName);
				ZipFile zipFile = new ZipFile(zipPath.toFile());
				zipFile.addFiles(excelFiles);
			}

			try (java.util.stream.Stream<Path> paths = Files.list(userFolder)) {
				paths.filter(Files::isRegularFile)
						.filter(p -> {
							String n = p.getFileName().toString().toLowerCase();
							return n.endsWith(".xlsx") || n.endsWith(".xls");
						})
						.forEach(p -> {
							try { Files.deleteIfExists(p); }
							catch (Exception e) { e.printStackTrace(); }
						});
			}
		}catch (Exception e){
			e.printStackTrace();
		}finally {
			cache.evict("analysis_mission", username + "_exportWorkload");
		}
	}
}

