package com.cx.kaoyi.business.service.serviceImpl;

import com.cx.kaoyi.business.dao.PermissionDao;
import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.service.*;
import com.cx.kaoyi.framework.base.BaseService;
import com.cx.kaoyi.framework.cache.LocalCache;
import com.cx.kaoyi.framework.question.repeat.PaperChangeRecorder;
import com.cx.kaoyi.framework.utils.DateFormatUtils;
import com.cx.kaoyi.framework.utils.PageUtils;
import com.cx.kaoyi.framework.utils.Utils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.math.BigDecimal;
import java.util.*;

//VerifyService实现类，除了已有的注释外，其余请查看相应的xml(与xml的ID相对应)
@Service("verifyService")
public class VerifyServiceImpl extends BaseService implements VerifyService{
	
	@Autowired
    private PaperService paperService;
	
	@Autowired
    private PermissionDao permissionDao;
	@Autowired
    private SystemService systemService;
	@Autowired
	private PaperChangeRecorder paperChangeRecorder;

	public static String namespace = "resources.mappers.verify";

	@Override
	public List<Map<String, Object>> getPaperList(Map param, PageUtils pu) {
		List<Map<String, Object>> list = query(namespace + ".getPaperList", param, pu.getRb());
		/*
		Map m=new HashMap();
		for(Map<String,Object> map:list){
			m.put("eid", map.get("eid"));
			map.put("scount", monitorService.getPaperStudentCount(m));
			String bid=String.valueOf(map.get("bid"));
			if(!"".equals(bid)&&!"null".equals(bid)){
				m.put("eid", bid);
				map.put("bscount", monitorService.getPaperStudentCount(m));
				map.put("bsum", getBNum(bid));
			}else{
				map.put("bscount", 0);
				map.put("bsum", 0);
			}
			
		}*/
		return list;
	}
	
	@Override
	public List<Map<String, Object>> getVerifiedPaperList(Map param) {
		List<Map<String,Object>> list=query(namespace + ".getVerifiedPaperList", param);
		String gid = (String) param.get("gid");
		String spid = (String) param.get("sid");
		List<Map<String, Object>> rtnDataList = new ArrayList<>();
		for(Map<String,Object> map:list){
			List<Map<String,Object>> eo=(List<Map<String, Object>>) map.get("eo");
			Set<String> gset=new HashSet<>();
			Set<String> sset=new HashSet<>();
			Set<String> gidSet = new HashSet<>();
			Set<String> spidSet = new HashSet<>();
			if(eo!=null&&eo.size()>0){
				for(Map<String,Object> em:eo){
					gidSet.add(String.valueOf(em.get("GID")));
					spidSet.add(String.valueOf(em.get("SPID")));
					gset.add(String.valueOf(em.get("GNAME")));
					sset.add(String.valueOf(em.get("SNAME")));
				}

				if(StringUtils.isNotBlank(gid)){
					if(!gidSet.contains(gid)){ //筛选年级条件不存在直接跳过
						continue;
					}
				}

				if(StringUtils.isNotBlank(spid)){
					if(!spidSet.contains(spid)){ //筛选专业条件不存在直接跳过
						continue;
					}
				}

				map.put("GNAME", String.join(",",gset));
				map.put("SNAME", String.join(",", sset));
			}else{
				map.put("GNAME", "");
				map.put("SNAME", "");
			}
			Date begindate = (Date) map.get("begindate");
			Date enddate = (Date) map.get("enddate");
			String examdate_b = DateFormatUtils.formatDate(begindate);
			String examdate_e = DateFormatUtils.formatDate(enddate);
			if(examdate_b.equals(examdate_e)){
				map.put("examDate",examdate_b);
			}else{
				map.put("examDate",examdate_b+"<br/>--"+examdate_e);
			}
			map.put("examTime",DateFormatUtils.formatHourMinute(begindate)+"--"+DateFormatUtils.formatHourMinute(enddate));
			rtnDataList.add(map);
		}
		return rtnDataList;
	}
	
	@Override
	public List<Map<String, Object>> getAppointTeacher(Set param) {
		// TODO Auto-generated method stub		
		return query(namespace + ".getAppointTeacher", param);		
	}
	
	@Override
	public List<Map<String, Object>> getAllAuthorizedTeacher(Map param, PageUtils pu) {
		// TODO Auto-generated method stub		
		return query(namespace + ".getAllAuthorizedTeacher",param, pu.getRb());		
	}
	
	@Override
	public String getAllAuthorTeacherCount(Map param) {
		// TODO Auto-generated method stub
		return (String) queryOne(namespace+".getAllAuthorTeacherCount", param);
	}
	
	@Override
	public List<Map<String, Object>> getTeacherPermission(Map param) {	
		return query(namespace + ".getTeacherPermission", param);		
	}
	
	@Override
	public List<Map<String, Object>> getAuthorPermission(Map param) {	
		return query(namespace + ".getAuthorPermission", param);		
	}
	
	@Override
	public List<Map<String,Object>> getAudit_first(String eid){
		return query(namespace + ".getAudit_first", eid);		
	}
	
	@Override
	public List<Map<String,Object>> getAudit_last(String eid){
		return query(namespace + ".getAudit_last", eid);		
	}
//	@Override
//	public List<Map<String, Object>> getAppointTeacher_roleid(Map param) {
//		// TODO Auto-generated method stub		
//		return query(namespace + ".getAppointTeacher_roleid", param);		
//	}

	@Override
	public int deletePaperPerByUIDAndEID(Map param) {
		// TODO Auto-generated method stub
		return delete(namespace + ".deletePaperPerByUIDAndEID", param);
	}
	
	@Override
	public int deleteAuthorPaperPerByUIDAndEID(Map param) {
		// TODO Auto-generated method stub
		return delete(namespace + ".deleteAuthorPaperPerByUIDAndEID", param);
	}

	@Override
	public int insertPaperPer(Map param) {
		return insert(namespace + ".insertPaperPer", param);
	}

	@Override
	public int updatePaperPer(Map map) {
		LocalCache cache = LocalCache.getInstance();
		String eid = (String) map.get("eid");
		List<Map<String,Object>> permission_old= (List<Map<String, Object>>) map.get("permission_old");
		Map<String, List<String>> idToName_old = new HashMap<>();
		for (Map<String, Object> sm : permission_old) {
			String id = String.valueOf(sm.get("tid"));
			List<String> name = (List<String>) sm.get("pidList");
			idToName_old.put(id, name);
		}

		List<Map<String, Object>> system_permission= (List<Map<String, Object>>) map.get("system_permission");
		Map<String, String> idToNameMap = new HashMap<>();
		for (Map<String, Object> sm : system_permission) {
			String id = String.valueOf(sm.get("ID"));
			String name = (String) sm.get("NAME");
			idToNameMap.put(id, name);
		}

		Map log = new HashMap();
		log.put("cid", "");

		ArrayList<LinkedHashMap> teacherList = (ArrayList) map.get("teacherList");
		if(teacherList.size() == 0){
			return 0;
		}else{
			List<Map<String,Object>> permission_new=new ArrayList<Map<String,Object>>();
			for(LinkedHashMap lhm: teacherList){
				String uid= (String)lhm.get("uid");
				Map param = new HashMap();
				param.put("eid", eid);
				param.put("uid",uid);
				ArrayList<String> perList = (ArrayList<String>) lhm.get("perList");
				param.put("perList", perList);

				if(perList.size() == 0){
					deletePaperPerByUIDAndEID(param);
					List<String> per_old=idToName_old.get(uid);
					if(per_old==null || per_old.size()==0){
						continue;
					}
					log.put("content", "为“"+lhm.get("tname")+"（"+lhm.get("username")+")”在《"+map.get("ename")+"》试卷，清空了所有权限。");
					systemService.addSysLog(log);
				}else{
					deletePaperPerByUIDAndEID(param);
					insertPaperPer(param);

					LinkedHashSet<String> pid_add = new LinkedHashSet<>();
					LinkedHashSet<String> pid_del = new LinkedHashSet<>();

					List<String> per_old=idToName_old.get(uid);
					for(String pid:perList){
						if (!per_old.contains(pid)) {
							pid_add.add(pid);
						}
					}
					for(String pid:per_old){
						if (!perList.contains(pid)) {
							pid_del.add(pid);
						}
					}
//					for(Map<String,Object> pm:permission_old){
//						if(uid.equals((String)pm.get("tid"))){
//							List<String> per_old= (List<String>) pm.get("pidList");
//							for(String pid:perList){
//								if (!per_old.contains(pid)) {
//									pid_add.add(pid);
//								}
//							}
//							for(String pid:per_old){
//								if (!perList.contains(pid)) {
//									pid_del.add(pid);
//								}
//							}
//						}
//					}


					StringBuilder sb_add=new StringBuilder();
					for(String pid:pid_add){
						String name = idToNameMap.get(pid);
						if (name != null) {
							sb_add.append(name).append(",");
						}
					}

					StringBuilder sb_del=new StringBuilder();
					for(String pid:pid_del){
						String name = idToNameMap.get(pid);
						if (name != null) {
							sb_del.append(name).append(",");
						}
					}

					if (sb_add.length() > 0) {
						sb_add.deleteCharAt(sb_add.length() - 1);
					}
					if (sb_del.length() > 0) {
						sb_del.deleteCharAt(sb_del.length() - 1);
					}

					if(sb_add.length()>0||sb_del.length()>0){
						String logStr="为“"+lhm.get("tname")+"("+lhm.get("username")+")”在《"+map.get("ename")+"》试卷";
						if(sb_add.length()>0){
							logStr+="，增加了权限："+sb_add.toString();
						}
						if(sb_del.length()>0){
							logStr+="，减少了权限："+sb_del.toString();
						}
						log.put("content", logStr);
						systemService.addSysLog(log);
					}
				}
				Map<String,Object> pmap=new HashMap<String,Object>();
				pmap.put("tid",uid);
				pmap.put("pidList",perList);
				permission_new.add(pmap);
				if (cache != null) {
					cache.evict("permissions", "up_"+lhm.get("uid")+"_"+eid);
					cache.evict("permissions", "ue_"+lhm.get("uid")+"_"+eid);
					cache.evict("permissions", "uePermission_"+lhm.get("uid")+"_"+eid);
				}
			}
			HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
			request.getSession().setAttribute(eid+"_teacher_permission",permission_new);
			String bid=queryOne(namespace+".getBid",eid);
			if(bid!=null&&!"".equals(bid)&&!"null".equals(bid)){
				for(LinkedHashMap lhm: teacherList){
					Map param = new HashMap();
					param.put("eid", bid);
					param.put("uid", lhm.get("uid"));
					ArrayList perList = (ArrayList) lhm.get("perList");
					param.put("perList", perList);
					if(perList.size() == 0){
						deletePaperPerByUIDAndEID(param);
					}else{
						deletePaperPerByUIDAndEID(param);
						insertPaperPer(param);
					}
					if (cache != null) {
						cache.evict("permissions", "up_"+lhm.get("uid")+"_"+eid);
						cache.evict("permissions", "ue_"+lhm.get("uid")+"_"+eid);
						cache.evict("permissions", "uePermission_"+lhm.get("uid")+"_"+eid);
					}
				}
			}

			String cpid=queryOne(namespace+".getCid",eid);
			if(cpid!=null&&!"".equals(cpid)&&!"null".equals(cpid)){
				for(LinkedHashMap lhm: teacherList){
					Map param = new HashMap();
					param.put("eid", cpid);
					param.put("uid", lhm.get("uid"));
					ArrayList perList = (ArrayList) lhm.get("perList");
					param.put("perList", perList);
					if(perList.size() == 0){
						deletePaperPerByUIDAndEID(param);
					}else{
						deletePaperPerByUIDAndEID(param);
						insertPaperPer(param);
					}
					if (cache != null) {
						cache.evict("permissions", "up_"+lhm.get("uid")+"_"+eid);
						cache.evict("permissions", "ue_"+lhm.get("uid")+"_"+eid);
						cache.evict("permissions", "uePermission_"+lhm.get("uid")+"_"+eid);
					}
				}
			}
			
			return 1;
		}
		
		
	}
	
	@Override
	public int updateAuthorPaperPer(Map map) {
		String eid = (String) map.get("eid");

		List<Map<String,Object>> permission_old= (List<Map<String, Object>>) map.get("permission_old");
		Map<String, List<String>> idToName_old = new HashMap<>();
		for (Map<String, Object> sm : permission_old) {
			String id = String.valueOf(sm.get("tid"));
			List<String> name = (List<String>) sm.get("pidList");
			idToName_old.put(id, name);
		}

		List<Map<String, Object>> system_permission= (List<Map<String, Object>>) map.get("system_permission");
		Map<String, String> idToNameMap = new HashMap<>();
		for (Map<String, Object> sm : system_permission) {
			String id = String.valueOf(sm.get("ID"));
			String name = (String) sm.get("NAME");
			idToNameMap.put(id, name);
		}

		Map<String, Object> examInfo = paperService.getExamInfo(eid);
		String cid = examInfo.get("CID").toString();
		Map m = new HashMap();
        String[] parts = cid.split(",");  
        String[] strArray = new String[parts.length];  
        for (int i = 0; i < parts.length; i++) {  
        	strArray[i] = String.valueOf(parts[i].trim());  
        }
        m.put("cids",strArray);
        m.put("cid", cid);
	    m.put("state",0);
	    m.put("pid", 32);

		Map log = new HashMap();
		log.put("cid", "");

		ArrayList<LinkedHashMap> teacherList = (ArrayList) map.get("teacherList");
		if(teacherList.size() == 0){
			return 0;
		}else{
			for(LinkedHashMap lhm: teacherList){
				String uid= (String)lhm.get("uid");
				Map param = new HashMap();
				param.put("eid", eid);
				param.put("uid", uid);
				m.put("uid", uid);
				ArrayList<String> perList = (ArrayList<String>) lhm.get("perList");
				param.put("perList", perList);
				if(perList.size() == 0){
					deleteAuthorPaperPerByUIDAndEID(param);
					List<String> per_old=idToName_old.get(uid);
					if(per_old.size()==0){
						continue;
					}

					log.put("content", "为“"+lhm.get("realname")+"（"+lhm.get("username")+")”在《"+examInfo.get("ENAME")+"》试卷，清空了所有权限。");
					systemService.addSysLog(log);
				}else{
					deleteAuthorPaperPerByUIDAndEID(param);
					deletePermissionByTIDAndCID(m);
					deletePermissionByTIDAndCIDS(m);
					insertPaperPer(param);
					addTeacherCourse(m);
					updatePermissionByTIDAndCID(m);
					if(cid.contains(",")) {
						addTeacherPermission_authors(m);
					}else {
						addTeacherPermission_author(m);
					}

					LinkedHashSet<String> pid_add = new LinkedHashSet<>();
					LinkedHashSet<String> pid_del = new LinkedHashSet<>();

					List<String> per_old=idToName_old.get(uid);
					for(String pid:perList){
						if (!per_old.contains(pid)) {
							pid_add.add(pid);
						}
					}
					for(String pid:per_old){
						if (!perList.contains(pid)) {
							pid_del.add(pid);
						}
					}


					StringBuilder sb_add=new StringBuilder();
					for(String pid:pid_add){
						String name = idToNameMap.get(pid);
						if (name != null) {
							sb_add.append(name).append(",");
						}
					}

					StringBuilder sb_del=new StringBuilder();
					for(String pid:pid_del){
						String name = idToNameMap.get(pid);
						if (name != null) {
							sb_del.append(name).append(",");
						}
					}

					if (sb_add.length() > 0) {
						sb_add.deleteCharAt(sb_add.length() - 1);
					}
					if (sb_del.length() > 0) {
						sb_del.deleteCharAt(sb_del.length() - 1);
					}

					if(sb_add.length()>0||sb_del.length()>0){
						String logStr="为“"+lhm.get("realname")+"("+lhm.get("username")+")”在《"+examInfo.get("ENAME")+"》试卷";
						if(sb_add.length()>0){
							logStr+="，增加了权限："+sb_add.toString();
						}
						if(sb_del.length()>0){
							logStr+="，减少了权限："+sb_del.toString();
						}
						log.put("content", logStr);
						systemService.addSysLog(log);
					}
				}
			}
			String bid=queryOne(namespace+".getBid",eid);
			if(bid!=null&&!"".equals(bid)&&!"null".equals(bid)){
				for(LinkedHashMap lhm: teacherList){
					Map param = new HashMap();
					param.put("eid", bid);
					param.put("uid", lhm.get("uid"));
					ArrayList perList = (ArrayList) lhm.get("perList");
					param.put("perList", perList);
					if(perList.size() == 0){
						deleteAuthorPaperPerByUIDAndEID(param);
					}else{
						deleteAuthorPaperPerByUIDAndEID(param);
						insertPaperPer(param);
					}
				}
			}

			String cpid=queryOne(namespace+".getCid",eid);
			if(cpid!=null&&!"".equals(cpid)&&!"null".equals(cpid)){
				for(LinkedHashMap lhm: teacherList){
					Map param = new HashMap();
					param.put("eid", cpid);
					param.put("uid", lhm.get("uid"));
					ArrayList perList = (ArrayList) lhm.get("perList");
					param.put("perList", perList);
					if(perList.size() == 0){
						deleteAuthorPaperPerByUIDAndEID(param);
					}else{
						deleteAuthorPaperPerByUIDAndEID(param);
						insertPaperPer(param);
					}
				}
			}
			
			return 1;
		}
		
		
	}
	

	private int addTeacherCourse(Map m) {
		// TODO Auto-generated method stub
		return permissionDao.addTeacherCourse(m);
	}

	@Override
	public List<Map<String, Object>> getTeacherPaPers(String eid) {
		// TODO Auto-generated method stub
		return query(namespace + ".getTeacherPaPers", eid);
	}

	@Override
	public String paperPerCount(Map param) {
		// TODO Auto-generated method stub
		return ((Map<String,Object>)query(namespace + ".paperPerCount", param).get(0)).get("NUM").toString();
	}
	
	@Override
	public String getExamtype(String type) {	
		// TODO Auto-generated method stub
		return queryOne(namespace + ".getExamtype", type).toString();
	}

	@Override
	public List<Map<String, Object>> getPaperRight(String eid) {
		// TODO Auto-generated method stub
		return query(namespace + ".getPaperRight", eid);
	}

	@Override
	public List<Map<String, Object>> getSubjectiveQuestion(String eid) {
		List<Map<String,Object>> list = query(namespace + ".getSubjectiveQuestion", eid);
		if(list==null){
			return new ArrayList<>();
		}
		for(Map<String,Object> question : list){
			String th = String.valueOf(question.get("th"));
			String content = (String) question.get("content");
			if(StringUtils.isNotBlank(content)){
				content = Utils.stripHtmlIncludeImg(content).trim();
				if(content.length()>33){
					content = content.substring(0,30) + "...";
				}
				if(StringUtils.isBlank(content)){
					content = "【题干无纯文字内容，可能含有多媒体信息】";
				}
				question.put("content", "<span style='font-weight: bold;'>第"+th+"题：</span> "+content);
			}
		}
		return list;
	}

	@Override
	public int insertCorrectPer(Map param) {
		// TODO Auto-generated method stub
		delete(namespace + ".deleteCorrectPer", param);
		return insert(namespace + ".insertCorrectPer", param);
	}
	
	@Override
	public int insertCorrectCla(Map param) {
		// TODO Auto-generated method stub
		delete(namespace + ".deleteCorrectCla", param);
		return insert(namespace + ".insertCorrectCla", param);
	}

	@Override
	public int insertReviewPer(Map param) {
		// TODO Auto-generated method stub
		delete(namespace + ".deleteReviewPer", param);
		return insert(namespace + ".insertReviewPer", param);
	}

	@Override
	public Map<String, Object> getCorrectAndReviewPers(String eid) {
		// TODO Auto-generated method stub
		Map<String, Object> res = new HashMap<String, Object>();
		res.put("correctPers", query(namespace + ".getCorrectPers", eid));
		res.put("reviewPers", query(namespace + ".getReviewPers", eid));
		return res;
	}

	@Override
	public int deletePaper(String eid, int state) {
		Map<String,Object> examinfo = paperService.getExamInfo(eid);
		String[] cids = ((String)examinfo.get("CID")).split(",");
		String bid = (String) examinfo.get("BID");
		String cpid = (String) examinfo.get("CPID");
		Map<String, Object> updateStateMap = new HashMap<>();
		updateStateMap.put("state", state);
		int page_num = 0;
		int aorb = Utils.changeObjToInt(examinfo.get("AORB"));
		Map<String, Object> updateBorCidMap = new HashMap<>();
		if(aorb==0){  //A卷，如果存在C卷，没考过的C卷彻底删除
			updateBorCidMap.put("eid", eid);
			if(StringUtils.isNotBlank(cpid)){
				//获取B卷的考生数，如果有考生，更新状态，如果没有，直接删除
				int num = queryOne(namespace + ".getPaperStudentCount", cpid);
				if(num>0){
					updateStateMap.put("ei_id", cpid);
					paperService.updateRawExamInfo(updateStateMap);
				}else{
					this.completeDel((String)examinfo.get("CPID"));
				}
				updateBorCidMap.put("cpid", cpid);
				update(namespace + ".updateCPidtoBlank", updateBorCidMap);
				paperChangeRecorder.recordPaperChange(cpid);
				page_num++;
			}//A卷，如果存在B卷，没考过的B卷彻底删除
			if(StringUtils.isNotBlank(bid)){
				//获取B卷的考生数，如果有考生，更新状态，如果没有，直接删除
				int num = queryOne(namespace + ".getPaperStudentCount", bid);
				if(num>0){
					updateStateMap.put("ei_id", bid);
					paperService.updateRawExamInfo(updateStateMap);
				}else{
					this.completeDel((String)examinfo.get("BID"));
				}
				updateBorCidMap.put("bid", bid);
				update(namespace + ".updateBidtoBlank", updateBorCidMap);
				paperChangeRecorder.recordPaperChange(bid);
				page_num++;
			}
			updateStateMap.put("ei_id", eid);
			paperService.updateRawExamInfo(updateStateMap);
			page_num++;
		}else if(aorb==1){//B卷
			//获取B卷的考生数，如果有考生，更新状态，如果没有，直接删除
			int num = queryOne(namespace + ".getPaperStudentCount", eid);
			if(num>0){
				updateStateMap.put("ei_id", eid);
				paperService.updateRawExamInfo(updateStateMap);
			}else{
				this.completeDel(eid);
			}
			updateBorCidMap.put("eid", bid);
			updateBorCidMap.put("bid", eid);
			update(namespace + ".updateBidtoBlank", updateBorCidMap);
			page_num++;
		}else {//C卷
			//获取C卷的考生数，如果有考生，更新状态，如果没有，直接删除
			int num = queryOne(namespace + ".getPaperStudentCount", eid);
			if(num>0){
				updateStateMap.put("ei_id", eid);
				paperService.updateRawExamInfo(updateStateMap);
			}else{
				this.completeDel(eid);
			}
			updateBorCidMap.put("cpid", eid);
			updateBorCidMap.put("eid", bid);
			update(namespace + ".updateCPidtoBlank", updateBorCidMap);
			updateBorCidMap.put("eid", cpid);
			update(namespace + ".updateCPidtoBlank", updateBorCidMap);
			page_num++;
		}
		//更新课程的试卷数
		for(String cid:cids){
			paperService.call_updateCoursePapercount(cid);
		}
		paperChangeRecorder.recordPaperChange(eid);
		//添加系统日志
		Map m = new HashMap();
		m.put("num", page_num);
		if(aorb==0){
			m.put("content", "拟删除《"+examinfo.get("ENAME")+"》试卷（A卷），其在试卷库中原序号为："+eid);
		}else if(aorb==1){
			m.put("content", "删除《"+examinfo.get("ENAME")+"》试卷（B卷），其在试卷库中原序号为："+eid);
		}else {
			m.put("content", "删除《"+examinfo.get("ENAME")+"》试卷（C卷），其在试卷库中原序号为："+eid);
		}
		m.put("cid", examinfo.get("CID"));
		systemService.addSysLog(m);
		
		return 1;
	}
	

	@Override
	public String getBNum(String eid) {
		return query(namespace + ".getBNum", eid).get(0).get("NUM").toString();
	}

	@Override
	public String getPaperCount(Map param) {
		return query(namespace + ".getPaperCount", param).get(0).get("NUM").toString();
	}
	
	@Override
	public String getVerifiedPaperCount(Map param) {
		return query(namespace + ".getVerifiedPaperCount", param).get(0).get("NUM").toString();
	}

	@Override
	public boolean checkViewPaperPermission(String eid){
		User user = (User) SecurityUtils.getSubject().getSession().getAttribute("userInfo");
		if(user==null){
			return false;
		}
		return true;
	}
	@Override
	public int deleteCorrectPer(Map param) {
		return delete(namespace + ".deleteCorrectPer", param);
	}
	@Override
	public int deleteCorrectCla(Map param) {
		return delete(namespace + ".deleteCorrectCla", param);
	}
	@Override
	public int deleteReviewPer(Map param) {
		return delete(namespace + ".deleteReviewPer", param);
	}
	@Override
	public List<Map<String, Object>> getCourseList(Map param) {
		return query(namespace + ".getCourseList", param);		
	}
	
	/**
	 * 验证是否有对应的试卷权限,使用者：试卷列表
	 * @author 洪艳
	 * @param /map/，传入参数（permission[例如：paper:view],uid,eid）
	 * @return 1,有 0,无
	 */
	@Override
	public int checkPaperPermission(Map param) {
		return 1;
	}

	@Override
	public int toCompleteDel(String eid) {
		Map<String,Object> examinfo = paperService.getExamInfo(eid);

		int aorb = ((BigDecimal)examinfo.get("AORB")).intValue();
		if(aorb==0){  //A卷，如果存在B卷彻底删除
			if(examinfo.get("BID")!=null && !"".equals((String)examinfo.get("BID"))){
				completeDel((String)examinfo.get("BID"));
			}
			completeDel(eid);
		}else{//B卷
			//获取B卷的考生数，如果有考生，更新状态，如果没有，直接删除
			completeDel(eid);
			Map<String, Object> updateBorCidMap = new HashMap<>();
			updateBorCidMap.put("eid", examinfo.get("BID"));
			updateBorCidMap.put("bid", eid);
			update(namespace + ".updateBidtoBlank", updateBorCidMap);
		}
		//添加系统日志
		Map param = new HashMap();
		if(aorb==0){
			param.put("content", "彻底删除《"+examinfo.get("ENAME")+"》试卷1套（A卷），其在试卷库中原序号为："+eid);
		}else{
			param.put("content", "彻底删除《"+examinfo.get("ENAME")+"》试卷1套（B卷），其在试卷库中原序号为："+eid);
		}
		param.put("cid", examinfo.get("CID"));
		systemService.addSysLog(param);
		
		return 1;
	}
	
	@Override
	public int completeDel(String eid) {
		delete(namespace+".completeDel_studentExam",eid);
		delete(namespace+".completeDel_studentAnswerQuestion",eid);
		delete(namespace+".completeDel_studentAnswerQuestionType",eid);
		delete(namespace+".completeDel_studentAnswer",eid);
		delete(namespace+".completeDel_studentExamExam",eid);
		delete(namespace+".completeDel_studentAnswerQuestionExam",eid);
		delete(namespace+".completeDel_studentAnswerQtypeExam",eid);
		delete(namespace+".completeDel_studentAnswerExam",eid);
		delete(namespace+".completeDel_examobject",eid);
		delete(namespace+".completeDel_exampaperQuestiontype",eid);
		delete(namespace+".completeDel_exampaperQuestionparam",eid);
		delete(namespace+".completeDel_exampaperQuestion",eid);
		delete(namespace+".completeDel_exampaperAnswer",eid);
		delete(namespace+".completeDel_exampaperCourse",eid);
		
		delete(namespace+".completeDel_teacherPaper",eid);
		Map<String,Object> param = new HashMap<>();
		param.put("eid", eid);
		delete(namespace+".deleteReviewPer",param);
		delete(namespace+".deleteCorrectPer",param);
		return delete(namespace+".completeDel_examinfo",eid);
	}

	@Override
	public int cancelDelPaper(String eid) {
		Map param = new HashMap();
		param.put("state", 0);
		param.put("ei_id", eid);
		paperService.updateRawExamInfo(param);
		Map<String,Object> examinfo = paperService.getExamInfo(eid);
		String[] cids = ((String)examinfo.get("CID")).split(",");
		for(String cid:cids){
			paperService.call_updateCoursePapercount(cid);
		}
		paperChangeRecorder.recordPaperChange(eid);
		return 0;
	}
	
	@Override
	public List<Map<String,Object>> getStudentClass(String eid){
		return query(namespace+".getStudentClass",eid);
	}
	
	@Override
	public int updateCorrectCla(Map param) {
		return update(namespace + ".updateCorrectCla", param);
	}
	
	@Override
	public List<Map<String,Object>> getTeacherClass(String eid){
		return query(namespace+".getTeacherClass",eid);
	}
	
	@Override
	public List<Map<String, Object>> getPaperList4XP(Map param, PageUtils pu) {
		List<Map<String, Object>> list = query(namespace + ".getPaperList4XP", param, pu.getRb());
		return list;
	}
	
	@Override
	public String getPaperCount4XP(Map param) {
		return query(namespace + ".getPaperCount4XP", param).get(0).get("NUM").toString();
	}

	@Override
	public List<Map<String,Object>> wxGetUnSubmitPaperList(Map param, PageUtils pu){
		return query(namespace + ".wxGetUnSubmitPaperList", param, pu.getRb());
	}

	public int updatePermissionByTIDAndCID(Map param) {
		LocalCache cache = LocalCache.getInstance();
		cache.removeAll("permissions");
		return permissionDao.updatePermissionByTIDAndCID(param);
	}

	public int addTeacherPermission_author(Map param) {
		LocalCache cache = LocalCache.getInstance();
		cache.removeAll("permissions");
		return permissionDao.addTeacherPermission_author(param);
	}

	public int addTeacherPermission_authors(Map param) {
		LocalCache cache = LocalCache.getInstance();
		cache.removeAll("permissions");
		return permissionDao.addTeacherPermission_authors(param);
	}

	public int deletePermissionByTIDAndCID(Map param) {
		LocalCache cache = LocalCache.getInstance();
		cache.removeAll("permissions");
		return permissionDao.deletePermissionByTIDAndCID(param);
	}

	public int deletePermissionByTIDAndCIDS(Map param) {
		LocalCache cache = LocalCache.getInstance();
		cache.removeAll("permissions");
		return permissionDao.deletePermissionByTIDAndCIDS(param);
	}

	@Override
	public List<Map<String, Object>> getPaperListOfUnit(Map param, PageUtils pu) {
		List<Map<String, Object>> list = query(namespace + ".getPaperListOfUnit", param, pu.getRb());
		return list;
	}

	@Override
	public String getPaperOfUnitCount(Map param) {
		return queryOne(namespace + ".getPaperOfUnitCount", param).toString();
	}

	@Override
	public Map<String,Object> getPaperUnit(String eid){
		return queryOne(namespace+".getPaperUnit",eid);
	}
}
