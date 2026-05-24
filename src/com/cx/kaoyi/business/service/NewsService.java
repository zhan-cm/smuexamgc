package com.cx.kaoyi.business.service;

import com.cx.kaoyi.framework.utils.PageUtils;

import java.util.List;
import java.util.Map;

public interface NewsService {
	List<Map<String,Object>> getNewsList4Index(Integer type);
	
	List<Map<String,Object>> getNewsList(Map param, PageUtils pu);
	
	String getNewsCount(Map param);
	
	Map<String,Object> getNewsById(String id);
	
	void delNew(String id);
	
	void addNew(Map param);
	
	void editNew(Map param);
	
	List<Map<String, Object>> getPaperList(Map param, PageUtils pu);

	String getPaperListCount(Map param);
}
