package com.cx.kaoyi.business.service.serviceImpl;

import com.cx.kaoyi.business.service.NewsService;
import com.cx.kaoyi.framework.base.BaseService;
import com.cx.kaoyi.framework.utils.PageUtils;
import org.springframework.stereotype.Service;

import java.util.*;

@Service("newsService")
public class NewsServiceImpl extends BaseService implements NewsService {

	public static String namespace = "resources.mappers.news";
	
	@Override
	public List<Map<String,Object>> getNewsList4Index(Integer type){
		return query(namespace+".getNewsList4Index", type);
	}
	
	@Override
	public List<Map<String,Object>> getNewsList(Map param, PageUtils pu){
		return query(namespace+".getNewsList", param, pu.getRb());
	}
	
	@Override
	public String getNewsCount(Map param) {
		return query(namespace + ".getNewsCount", param).get(0).get("NUM").toString();
	}

	@Override
	public Map<String, Object> getNewsById(String id) {
		return (Map<String, Object>) queryOne(namespace+".getNewsById",id);
	}

	@Override
	public void delNew(String id) {
		delete(namespace+".delNew",id);
	}

	@Override
	public void addNew(Map param) {
		insert(namespace+".addNew",param);
	}

	@Override
	public void editNew(Map param) {
		update(namespace+".editNew",param);
		
	}
	
	@Override
	public List<Map<String, Object>> getPaperList(Map param, PageUtils pu) {
		List<Map<String, Object>> list = query(namespace + ".getPaperList",param,pu.getRb());
		List<Map<String, Object>> rtn = new ArrayList<>();
		for(Map<String, Object> map:list){
			List<Map<String,Object>> eo = (List<Map<String, Object>>) map.get("eo");	
			Set<String> grade_set = new HashSet<>();
			Set<String> special_set = new HashSet<>();
			if(eo!=null && eo.size()>0){
				for(Map<String,Object> mm:eo){
					grade_set.add((String)mm.get("GNAME"));
					special_set.add((String)mm.get("SNAME"));
				}
				StringBuilder grade = new StringBuilder();
				StringBuilder special = new StringBuilder();
				for(String g:grade_set){					
					grade.append(g+",");
				}
				for(String s:special_set){
					special.append(s+",");
				}
				String gstr=grade.substring(0,grade.length()-1);
				String sstr=special.substring(0,special.length()-1);
				if(gstr.length()>20){
					gstr=gstr.substring(0,20)+"...";
				}
				if(sstr.length()>20){
					sstr=sstr.substring(0,20)+"...";
				}
				map.put("grade", gstr);
				map.put("special", sstr);
			}else{
				map.put("grade", "");
				map.put("special", "");
			}
			
			String bdate = (String.valueOf(map.get("begindate")).split(" "))[0];
			String edate = (String.valueOf(map.get("enddate")).split(" "))[0];
			if(bdate.equals(edate)){
				map.put("exam_date", bdate);
			}else{
				map.put("exam_date", bdate + "--" + edate);
			}
			
			if(map.get("bid")!=null){
				String b_snum = (String) queryOne(namespace + ".getSum", map);
				if(b_snum==null){
					b_snum="0";
				}
				map.put("b_snum", b_snum);
			}
			rtn.add(map);
		}
		return rtn;
	}

	@Override
	public String getPaperListCount(Map param){
		return String.valueOf(query(namespace+".getPaperListCount",param).get(0).get("NUM"));
	}
}