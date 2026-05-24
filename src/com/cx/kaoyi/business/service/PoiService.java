package com.cx.kaoyi.business.service;

import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.framework.utils.PageUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.springframework.web.multipart.MultipartFile;

import java.io.File;
import java.io.IOException;
import java.util.List;
import java.util.Map;

public interface PoiService{

	public Map<String, Object> importTheme(MultipartFile mFile, String cid);

/*	public void importThemeXls(File file, String cid) throws IOException ;
	
	public void importThemeXlsx(File file, String cid) throws IOException;*/

	public Map importQuestion(MultipartFile mFile, String cid, String repeat);

//	public void importQuestionXls(File file, String cid) throws IOException ;
//	
//	public void importQuestionXlsx(File file, String cid) throws IOException;
	
	//public void exportFile(HttpServletResponse response);
//	public HSSFWorkbook exportFile();
	
	public HSSFWorkbook exportQuestion(Map m, String[] qids);
	
	public HSSFWorkbook exportTheme(String cid);
	
	public HSSFWorkbook exportLogs(String time);

	//public void setSheetHeader(XSSFWorkbook xWorkbook, XSSFSheet xSheet);

	//public void setSheetContent(XSSFWorkbook xWorkbook, XSSFSheet xSheet); 
	
	public HSSFWorkbook importQuestionMonel(String cid);
	
	HSSFWorkbook exportCourse(Map param);
	
//	Map importQuestion2(MultipartFile mFile, String rootPath, String cid);
	
	Map importQuestionToPaper(MultipartFile mFile, String cids, String eid);
	
	HSSFWorkbook exportPaperQuestion(Map m);
	
	String importCourse(MultipartFile mFile);

	public Map checkWordFile(MultipartFile questionFile) throws IOException;

	public Map importWord_test(String filePath, String cid, String repeat);

	public HSSFWorkbook exportAllPaperQuestion(Map m);

	void exportWorkloadExcelZipOnlyTotal(String username, Map<String,Object> param);

	void exportWorkloadExcelZip(String username, Map<String,Object> param);
}
