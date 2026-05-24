package com.cx.kaoyi.business.service.serviceImpl;

import com.cx.kaoyi.business.domain.Permission;
import com.cx.kaoyi.business.domain.Theme;
import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.service.*;
import com.cx.kaoyi.framework.base.BaseService;
import com.cx.kaoyi.framework.utils.DateFormatUtils;
import com.cx.kaoyi.framework.utils.PageUtils;
import com.cx.kaoyi.framework.utils.ThemeUtils;
import com.cx.kaoyi.framework.utils.Utils;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.ServletContext;
import java.util.*;

@Service("courseService")
public class CourseServiceImpl extends BaseService implements CourseService{

	@Autowired
    private PermissionService permissionService;

	@Autowired
	private CommonService commonService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private SystemService systemService;
	
	@Autowired
    private QuestionService questionService;

	@Autowired
	private ServletContext servletContext;
	
	public static String namespace = "resources.mappers.course";

	@Override
	public List<Map<String, Object>> getCourse(Map param, PageUtils pu) {
		List<Map<String, Object>> res = query(namespace + ".getCourse", param, pu.getRb());
		for(int i=0; i<res.size(); i++){
			String cid = (String) res.get(i).get("CID");
			User user = (User)SecurityUtils.getSubject().getSession().getAttribute("userInfo");
			List<String> p=new ArrayList<>();
			if(String.valueOf(param.get("uid")).equals(String.valueOf(res.get(i).get("CREATORID")))||"administrator".equals(user.getRole())){
				p.add("*:*");
			}else{
				Map m = new HashMap();
				m.put("uid", param.get("uid"));
				m.put("cid", cid);
				List<Permission> pLs = permissionService.findPerByUIDAndCID(m,param.get("uid")+"_"+cid);
				for(int o=0;o<pLs.size();o++){
					if("course:update".equals(pLs.get(o).getPermission())||"question:view".equals(pLs.get(o).getPermission())||"course:permission".equals(pLs.get(o).getPermission())||"course:del".equals(pLs.get(o).getPermission())){
						p.add(pLs.get(o).getPermission());
					}
				}
			}
			if(String.valueOf(param.get("uid")).equals(String.valueOf(res.get(i).get("CREATORID")))||"administrator".equals(user.getRole())||"dean".equals(user.getRole())){
				p.add("paper:analysis");
			}
			res.get(i).put("permissions", p);
		}
		return res;
	}

	@Override
	public List<Map<String, Object>> getUnVerifiedCourse(Map param, PageUtils pu){
		List<Map<String, Object>> res = query(namespace + ".getUnVerifiedCourse", param, pu.getRb());
		return res;
	}

	@Override
	public Integer getUnVerifiedCourseCount(Map param){
		return Utils.changeObjToInt(query(namespace + ".getUnVerifiedCourseCount", param).get(0).get("COUNT"));
	}

	@Override
	public List<Map<String, Object>> getCourse4TeacherOffice(Map param, PageUtils pu) {
		List<Map<String, Object>> res = query(namespace + ".getCourse4TeacherOffice", param, pu.getRb());
		return res;
	}

	@Override
	public String getCourseCount4TeacherOffice(Map param) {
		return query(namespace + ".getCourseCount4TeacherOffice", param).get(0).get("TAR").toString();
	}

	@Override
	public List<Map<String, Object>> getDelQueCourse(Map param, PageUtils pu) {
		List<Map<String, Object>> res = query(namespace + ".getDelQueCourse", param, pu.getRb());
		for(int i=0; i<res.size(); i++){
			String cid = (String) res.get(i).get("CID");
			//获取课程权限
			User user = (User)SecurityUtils.getSubject().getSession().getAttribute("userInfo");
			List<String> p=new ArrayList<>();
			if(String.valueOf(param.get("uid")).equals(String.valueOf(res.get(i).get("CREATORID")))||"administrator".equals(user.getRole())){
				p.add("*:*");
			}else{
				Map m = new HashMap();
				m.put("uid", param.get("uid"));
				m.put("cid", cid);
				List<Permission> pLs = permissionService.findPerByUIDAndCID(m,param.get("uid")+"_"+cid);
				for(int o=0;o<pLs.size();o++){
					if("course:update".equals(pLs.get(o).getPermission())||"question:view".equals(pLs.get(o).getPermission())||"course:permission".equals(pLs.get(o).getPermission())||"course:del".equals(pLs.get(o).getPermission())){
						p.add(pLs.get(o).getPermission());
					}
				}
			}
			if(String.valueOf(param.get("uid")).equals(String.valueOf(res.get(i).get("CREATORID")))||"administrator".equals(user.getRole())||"dean".equals(user.getRole())){
				p.add("paper:analysis");
			}
			res.get(i).put("permissions", p);
		}
		return res;
	}
	
	@Override
	public List<Map<String, Object>> getQueCourse(Map param, PageUtils pu) {
		List<Map<String, Object>> res = query(namespace + ".getQueCourse", param, pu.getRb());
		return res;
	}

	@Override
	public List<Map<String, Object>> getCourseAttr(String cid) {
		return query(namespace + ".getCourseAttr", cid);
	}

	@Override
	public String getCourseID() {
		return query(namespace + ".getCourseID").get(0).get("KEY").toString();
	}

	@Override
	public String getCount(Map param) {
		return query(namespace + ".getCount", param).get(0).get("TAR").toString();
	}

	/*
	@Override
	public int addQuestionType(Map param) {
		return insert(namespace + ".addQuestionType", param);
	}*/

	@Override
	public int insertCourse(Map param) {
		//适应层次
		List<Map<String, Object>> arrlist = (List<Map<String, Object>>) param.get("arrangement");
		List<Map<String, Object>> narrlist = new ArrayList<Map<String, Object>>();
		for(int i=0;i<arrlist.size();i++) {
			if(arrlist.get(i).get("ISDEFAULT")!=null){
				narrlist.add(arrlist.get(i));
			}
		}
		if(narrlist.size()>0){
			Map narrmap = new HashMap();
			narrmap.put("arrangement", narrlist);
			addArrangement(narrmap);
		}
		
		
		//考试类别
		List<Map<String, Object>> etlist = (List<Map<String, Object>>) param.get("examType");
		List<Map<String, Object>> netlist = new ArrayList<Map<String, Object>>();
		for(int i=0;i<etlist.size();i++) {
			if(etlist.get(i).get("ISDEFAULT")!=null){
				netlist.add(etlist.get(i));
			}
		}
		if(netlist.size()>0){
			Map nemap = new HashMap();
			nemap.put("examtype", netlist);
			addExamType(nemap);
		}
		
		//难度
		List<Map<String, Object>> dflist = (List<Map<String, Object>>) param.get("difficulty");
		List<Map<String, Object>> ndflist = new ArrayList<Map<String, Object>>();
		for(int i=0;i<dflist.size();i++) {
			if(dflist.get(i).get("ISDEFAULT")!=null){
				ndflist.add(dflist.get(i));
			}
		}
		if(ndflist.size()>0){
			Map ndfmap = new HashMap();
			ndfmap.put("difficulty", ndflist);
			addDifficulty(ndfmap);
		}
		
		//知识点分布
		List<Map<String, Object>> kllist = (List<Map<String, Object>>) param.get("knowledge");
		List<Map<String, Object>> nkllist = new ArrayList<Map<String, Object>>();
		for(int i=0;i<kllist.size();i++) {
			if(kllist.get(i).get("ISDEFAULT")!=null){
				nkllist.add(kllist.get(i));
			}
		}
		if(nkllist.size()>0){
			Map nklmap = new HashMap();
			nklmap.put("knowledge", nkllist);
			addKnowledge(nklmap);
		}
		
		//认知类别
		List<Map<String, Object>> ctList = (List<Map<String, Object>>) param.get("cognition");
		List<Map<String, Object>> nctList = new ArrayList<Map<String, Object>>();
		for(int i=0;i<ctList.size();i++) {
			if(ctList.get(i).get("ISDEFAULT")!=null){
				nctList.add(ctList.get(i));
			}
		}
		if(nctList.size()>0){
			Map nctmap = new HashMap();
			nctmap.put("cognition", nctList);
			addCognition(nctmap);
		}
		
		//题源
		List<Map<String, Object>> sclist = (List<Map<String, Object>>) param.get("source");
		List<Map<String, Object>> nsclist = new ArrayList<Map<String, Object>>();
		for(int i=0;i<sclist.size();i++) {
			if(sclist.get(i).get("ISDEFAULT")!=null){
				nsclist.add(sclist.get(i));
			}
		}
		if(nsclist.size()>0){
			Map nscmap = new HashMap();
			nscmap.put("source", nsclist);
			addSource(nscmap);
		}
		
		User user = (User)SecurityUtils.getSubject().getSession().getAttribute("userInfo");
		insert(namespace + ".insertCourse", param);
		insert(namespace + ".insertArrangement", param);
		insert(namespace + ".insertQuestionType", param);
		//insert(namespace + ".insertCourseTarget", param);
		insert(namespace + ".insertExamType", param);
		insert(namespace + ".insertSpecialty", param);
		insert(namespace + ".insertDifficulty", param);
		insert(namespace + ".insertKnowledge", param);
		insert(namespace + ".insertCognition", param);
		insert(namespace + ".insertSource", param);
		insert(namespace + ".insertCourseQuesPageTotal",param);
		//添加课程与用户的关系
		Map m = new HashMap();
		m.put("uid", user.getId());
		m.put("cid", param.get("id"));
		m.put("state", 0);
		permissionService.addTeacherCourse(m);
		
		Map p = new HashMap();
		p.put("uid", user.getId());
		p.put("deptId", param.get("deptId"));
		p.put("unitId", param.get("unitId"));
		if(SecurityUtils.getSubject().hasRole("teacher")){
			p.put("role", "teacher");
		}else if(SecurityUtils.getSubject().hasRole("secretary")){
			p.put("role", "secretary");
		}else if(SecurityUtils.getSubject().hasRole("director")){
			p.put("role", "director");
		}else if(SecurityUtils.getSubject().hasRole("teachingoffice")){
			p.put("role", "teachingoffice");
		}
		List<Map<String, Object>> ls= userService.findSuperiors(p);
		//获取系统的角色权限
		List<Map<String,Object>> rolePermission=permissionService.findRolePermission();
		Map cmap = new HashMap();
		cmap.put("cid", param.get("id"));
		for(int i=0;i<ls.size();i++){
			Map<String, Object> s = ls.get(i);
			String rid=(String)s.get("ROLEID");
			if("1".equals(rid)){
				continue;
			}
			cmap.put("uid", s.get("ID"));
			List<String> l = new ArrayList<>();
			for(Map<String,Object> rp:rolePermission){
				if(rid!=null && rid.equals(String.valueOf(rp.get("RID")))){
					l.add(String.valueOf(rp.get("PID")));
				}
			}
			if(l.size()==0){
				continue;
			}
			cmap.put("cper", l);
			permissionService.addTeacherPermission(cmap);
		}
		if(!SecurityUtils.getSubject().hasRole("administrator")){
			//添加本人的
			cmap.put("uid", user.getId());
			List<String> cper = new ArrayList<String>();
			cper.add("11");
			cper.add("12");
			cper.add("15");
			cper.add("21");
			cper.add("22");
			cper.add("23");
			cper.add("24");
			cper.add("25");
			cper.add("26");
			cper.add("27");
			cper.add("28");
			cper.add("29");
			cper.add("32");
			cper.add("35");
			cmap.put("cper", cper);
			permissionService.addTeacherPermission(cmap);
		}
		return 1;
	}
	
	@Override
	public int updateCourse(Map param) {
		String cid=String.valueOf(param.get("id"));
		//包含题型
		/*
		List<Map<String, Object>> qtlist = (List<Map<String, Object>>) param.get("questionType");
		List<Map<String, Object>> nqtlist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> notDefaultqtlist = new ArrayList<Map<String, Object>>();
		for(int i=0;i<qtlist.size();i++) {
			if("2".equals(String.valueOf(qtlist.get(i).get("ISDEFAULT")))){
				nqtlist.add(qtlist.get(i));
			}
			if("0".equals(String.valueOf(qtlist.get(i).get("ISDEFAULT")))){
				notDefaultqtlist.add(qtlist.get(i));
			}
		}
		if(nqtlist.size()>0){
			Map nqtmap = new HashMap();
			nqtmap.put("questionType", nqtlist);
			addQuestionType(nqtmap);
		}
		
		if(notDefaultqtlist.size()>0){
			for(Map<String,Object> map:notDefaultqtlist){
				update(namespace+".updateQuestionType",map);
			}
		}*/
		
		//适应层次
		List<Map<String, Object>> arrlist = (List<Map<String, Object>>) param.get("arrangement");
		List<Map<String, Object>> narrlist = new ArrayList<Map<String, Object>>();
		for(int i=0;i<arrlist.size();i++) {
			if(arrlist.get(i).get("ISDEFAULT")!=null){
				narrlist.add(arrlist.get(i));
			}
		}
		if(narrlist.size()>0){
			Map narrmap = new HashMap();
			narrmap.put("arrangement", narrlist);
			addArrangement(narrmap);
		}
		
		
		//考试类别
		List<Map<String, Object>> etlist = (List<Map<String, Object>>) param.get("examType");
		List<Map<String, Object>> netlist = new ArrayList<Map<String, Object>>();
		//getRequest().getSession().removeAttribute("examTypeList");
		for(int i=0;i<etlist.size();i++) {
			if(etlist.get(i).get("ISDEFAULT")!=null){
				netlist.add(etlist.get(i));
			}
		}
		if(netlist.size()>0){
			Map nemap = new HashMap();
			nemap.put("examtype", netlist);
			addExamType(nemap);
		}
		
		//难度
		List<Map<String, Object>> dflist = (List<Map<String, Object>>) param.get("difficulty");
		List<Map<String, Object>> ndflist = new ArrayList<Map<String, Object>>();
		for(int i=0;i<dflist.size();i++) {
			if(dflist.get(i).get("ISDEFAULT")!=null){
				ndflist.add(dflist.get(i));
			}
		}
		if(ndflist.size()>0){
			Map ndfmap = new HashMap();
			ndfmap.put("difficulty", ndflist);
			addDifficulty(ndfmap);
		}
		
		//知识点分布
		List<Map<String, Object>> kllist = (List<Map<String, Object>>) param.get("knowledge");
		List<Map<String, Object>> nkllist = new ArrayList<Map<String, Object>>();
		for(int i=0;i<kllist.size();i++) {
			if(kllist.get(i).get("ISDEFAULT")!=null){
				nkllist.add(kllist.get(i));
			}
		}
		if(nkllist.size()>0){
			Map nklmap = new HashMap();
			nklmap.put("knowledge", nkllist);
			addKnowledge(nklmap);
		}
		
		//认知类别
		List<Map<String, Object>> ctList = (List<Map<String, Object>>) param.get("cognition");
		List<Map<String, Object>> nctList = new ArrayList<Map<String, Object>>();
		for(int i=0;i<ctList.size();i++) {
			if(ctList.get(i).get("ISDEFAULT")!=null){
				nctList.add(ctList.get(i));
			}
		}
		if(nctList.size()>0){
			Map nctmap = new HashMap();
			nctmap.put("cognition", nctList);
			addCognition(nctmap);
		}
		
		//题源
		List<Map<String, Object>> sclist = (List<Map<String, Object>>) param.get("source");
		List<Map<String, Object>> nsclist = new ArrayList<Map<String, Object>>();
		for(int i=0;i<sclist.size();i++) {
			if(sclist.get(i).get("ISDEFAULT")!=null){
				nsclist.add(sclist.get(i));
			}
		}
		if(nsclist.size()>0){
			Map nscmap = new HashMap();
			nscmap.put("source", nsclist);
			addSource(nscmap);
		}
		//处理课程与题型的关系
		List<Map<String,Object>> qlist=(List<Map<String,Object>>)param.get("questionType");
		//1.获取现有的关系
		List<Map<String,Object>> nqlist=query(namespace+".selectCourseQTGx",cid);
		List<Map<String,Object>> delqlist=new ArrayList<Map<String,Object>>();//被移除的关系
		List<Map<String,Object>> updateqlist=new ArrayList<Map<String,Object>>();//更新关系
		for(int x=0;x<nqlist.size();x++){
			Map<String,Object> nqMap=nqlist.get(x);
			boolean exists=false;
			for(int y=0;y<qlist.size();y++){
				if(String.valueOf(nqMap.get("ID")).equals(String.valueOf(qlist.get(y).get("ID")))){
					updateqlist.add(qlist.get(y));
					qlist.remove(y);
					exists=true;
					break;
				}
			}
			if(!exists){
				delqlist.add(nqMap);
			}
		}
		for(Map<String,Object> delMap:delqlist){
			//判断是否有试题关联，如果没有，直接删除，否则改变状态
			Map pm=new HashMap();
			pm.put("cid", cid);
			pm.put("qtid", delMap.get("ID"));
			List<Map<String,Object>> gx=query(namespace+".getQuestionQTGX",pm);
			if(gx==null||gx.size()==0){
				delete(namespace+".deleteCourseQTGX",pm);
			}else{
				update(namespace+".deleteCourseQTGX_state",pm);
			}
		}
		
		for(Map<String,Object> qtMap:updateqlist){
			qtMap.put("state", 0);
			qtMap.put("cid", cid);
			if(qtMap.get("SXB")!=null&&String.valueOf(qtMap.get("SXB")).equals("undefined")){
				qtMap.remove("SXB");
			}
			update(namespace+".updateCourseQTGX",qtMap);
			
		}
		
		if(qlist.size()>0){
			for(Map<String,Object> qtMap:qlist){
				qtMap.put("state", 0);
			}
			param.put("questionType", qlist);
			insert(namespace + ".insertQuestionType", param);
		}		
		
		delete(namespace + ".deleteArrangement", cid);
//		delete(namespace + ".deleteQuestionType", param);
		delete(namespace + ".deleteExamType", cid);
		delete(namespace + ".deleteSpecialty", cid);
		delete(namespace + ".deleteDifficulty", cid);
		delete(namespace + ".deleteKnowledge", cid);
		delete(namespace + ".deleteCognition", cid);
		delete(namespace + ".deleteSource", cid);
		
		insert(namespace + ".updateCourse", param);		
		insert(namespace + ".insertArrangement", param);
//		insert(namespace + ".insertQuestionType", param);
		insert(namespace + ".insertExamType", param);
		insert(namespace + ".insertSpecialty", param);
		insert(namespace + ".insertDifficulty", param);
		insert(namespace + ".insertKnowledge", param);
		insert(namespace + ".insertCognition", param);
		insert(namespace + ".insertSource", param);
		return 1;
	}

	@Override
	public List<Map<String, Object>> getThemeList(Map param) {
		return query(namespace + ".getThemeList", param);
	}

	@Override
	public int insertTheme(Map param) {
		int sum = 0;
		String[] th_name = (String[]) param.get("th_names");
		for(String tname:th_name){			
			param.put("th_name", tname);
			List<Map<String, Object>> ls = getSameTheme(param);
			if (ls.size() > 0) {
				int state = Integer.parseInt(String.valueOf(ls.get(0).get("STATE")));
				String thid = (String) ls.get(0).get("THID");
				if(state == 0){
					update(namespace + ".updateThemeState", thid);
					sum++;
				}
				continue;
			}else{
				param.put("id", (int)queryOne(namespace + ".getThemeID", ""));
				insert(namespace + ".insertTheme", param);
			}
			sum++;
		}
		return sum;
	}
	
	private List<Map<String, Object>> getSameTheme(Map param){
		return query(namespace + ".getSameTheme", param);
	}

	@Override
	public String getThemeCount(Map param) {
		return ((Map<String,Object>)query(namespace + ".getThemeCount", param).get(0)).get("TAR").toString();
	}

	@Override
	public int deleteTheme(String  th_id) {
		return delete(namespace + ".deleteTheme3", th_id) + delete(namespace + ".deleteTheme2", th_id) + delete(namespace + ".deleteTheme", th_id);
	}

	
	@Override
	public int updateTheme(Map param) {
		return update(namespace + ".updateTheme", param);
	}

	@Override
	public int deleteCourse(String cid) {
		String cname = getCourseCNameByCid(cid);
		Map log = new HashMap();
		log.put("content", "删除课程《"+cname+"》(编号"+cid+")");
		log.put("cid", cid);
		systemService.addSysLog(log);
		Map param=new HashMap();
		param.put("cid", cid);
		param.put("state", 0);
		return update(namespace + ".updateCourseState", param);
	}

	@Override
	public int updateCourseState(String cid, int state, String remark) {
		String cname = getCourseCNameByCid(cid);

		String stateDescription = "state为"+state+"的状态";
		if(state==4){
			remark = StringUtils.isBlank(remark)?"无":remark.trim();
			stateDescription += "，其原因为："+ remark;
			String creatorid = getCourseCreatorId(cid);
		}else if(state==2){
			stateDescription = "尚未提交审核的状态";
		}else if(state==3){
			stateDescription = "提交审核后待教务处审核的状态";
		}else if(state==1){
			stateDescription = "通过审核可以使用的状态";
			String creatorid = getCourseCreatorId(cid);
		}else if(state==0){
			stateDescription = "拟删除的状态";
		}

		Map param=new HashMap();
		param.put("cid", cid);
		param.put("state", state);
		param.put("remark", Objects.toString(remark, ""));
		update(namespace + ".updateCourseRemark", param);

		Map log = new HashMap();
		log.put("content", "将课程《"+cname+"》(编号"+cid+")调整为"+stateDescription);
		log.put("cid", cid);
		systemService.addSysLog(log);

		return update(namespace + ".updateCourseState", param);
	}

	@Override
	public List<Map<String, Object>> getExplainQuestionType(Map param) {
		return query(namespace + ".getExplainQuestionType", param);
	}

	@Override
	public List<Map<String, Object>> getCourseCount_cidList(Map param) {
		return query(namespace + ".getCourseCount_cidList", param);
	}

	@Override
	public String getCourseCount(Map param) {
		return query(namespace + ".getCourseCount", param).get(0).get("TAR").toString();
	}
	
	@Override
	public List<Map<String, Object>> getCourse(Map param) {
		List<Map<String, Object>> res = query(namespace + ".getCourse", param);
		return res;
	}

	/**
	 * 获取被删除的试题的课程列表
	 */
	@Override
	public List<String> getCourseByDelQue() {
		List res = query(namespace + ".getCourseByDelQue");
		return res;
	}

	@Override
	public int addThemeFromExcel(Map param) {
		// TODO Auto-generated method stub
		int i = 0;
		List<Map<String, Object>> ls = query(namespace + ".getThemeXls", param);
		if(ls.size() > 0) {
			String id = (String) ls.get(0).get("ID");
			int beforeState= Integer.parseInt(String.valueOf(ls.get(0).get("STATE")));
			update(namespace + ".updateThemeXls", id);
			if(beforeState==0){
				i++;
			}
		}else {
//			int tid=(int)queryOne(namespace + ".getThemeID","");
//			param.put("id", tid);
			i += insert(namespace + ".addThemeFromExcel", param);
		}
		return i;
	}

	@Override
	public List<Map<String, Object>> getParantThemeID(Map param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getParantThemeID", param);
	}

	@Override
	public int addArrangement(Map param) {
		// TODO Auto-generated method stub
		return insert(namespace + ".addArrangement", param);
	}

	@Override
	public int addExamType(Map param) {
		// TODO Auto-generated method stub
		return insert(namespace + ".addExamType", param);
	}

	@Override
	public int addDifficulty(Map param) {
		// TODO Auto-generated method stub
		return insert(namespace + ".addDifficulty", param);
	}

	@Override
	public int addKnowledge(Map param) {
		// TODO Auto-generated method stub
		return insert(namespace + ".addKnowledge", param);
	}

	@Override
	public int addCognition(Map param) {
		// TODO Auto-generated method stub
		return insert(namespace + ".addCognition", param);
	}

	@Override
	public int addSource(Map param) {
		// TODO Auto-generated method stub
		return insert(namespace + ".addSource", param);
	}
	
	@Override
	public List<Map<String, Object>> getCourseList(Map param) {
		return query(namespace + ".getCourseList", param);
	}

	@Override
	public List<Map<String, Object>> getCourseListByUnid(Map param) {
		return query(namespace + ".getCourseListByUnid", param);
	}

	@Override
	public String getCourseCNameByCid(String cid) {
		return (String)queryOne(namespace + ".getCourseCNameByCid",cid);
	}
	
	@Override
	public String getCourseCreator(String cid) {
		return (String)queryOne(namespace + ".getCourseCreator",cid);
	}

	@Override
	public String getCourseCreatorId(String cid) {
		return (String)queryOne(namespace + ".getCourseCreatorId",cid);
	}

	@Override
	public List<Map<String, Object>> getQuestionTypeId() {
		// TODO Auto-generated method stub
		return query(namespace + ".getQuestionTypeId");
	}

	@Override
	public List<Map<String, Object>> getArrangementId() {
		// TODO Auto-generated method stub
		return query(namespace + ".getArrangementId");
	}

	@Override
	public List<Map<String, Object>> getExamTypeId() {
		// TODO Auto-generated method stub
		return query(namespace + ".getExamTypeId");
	}

	@Override
	public List<Map<String, Object>> getSpecialtyId() {
		// TODO Auto-generated method stub
		return query(namespace + ".getSpecialtyId");
	}

	@Override
	public List<Map<String, Object>> getDifficultyId() {
		// TODO Auto-generated method stub
		return query(namespace + ".getDifficultyId");
	}

	@Override
	public List<Map<String, Object>> getKnowlegeId() {
		// TODO Auto-generated method stub
		return query(namespace + ".getKnowlegeId");
	}

	@Override
	public List<Map<String, Object>> getCognitionId() {
		// TODO Auto-generated method stub
		return query(namespace + ".getCognitionId");
	}

	@Override
	public List<Map<String, Object>> getSourceId() {
		// TODO Auto-generated method stub
		return query(namespace + ".getSourceId");
	}

	@Override
	public List<Map<String, Object>> getEditCourseAttr(String c_id) {
		return query(namespace + ".getEditCourseAttr", c_id);
	}

	@Override
	public List<Map<String, Object>> getExportThemeExcel(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".getExportThemeExcel", cid);
	}

	@Override
	public List<Map<String, Object>> selectEditQuestionType(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".selectEditQuestionType", cid);
	}
	
	@Override
	public List<Map<String, Object>> selectEditCognition(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".selectEditCognition", cid);
	}
	
	@Override
	public List<Map<String, Object>> selectEditArrangement(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".selectEditArrangement", cid);
	}
	
	@Override
	public List<Map<String, Object>> selectEditDifficulty(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".selectEditDifficulty", cid);
	}
	
	@Override
	public List<Map<String, Object>> selectEditKnowledge(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".selectEditKnowledge", cid);
	}
	
	@Override
	public List<Map<String, Object>> selectEditSource(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".selectEditSource", cid);
	}
	
	@Override
	public List<Map<String, Object>> selectTheme(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".selectTheme", cid);
	}
	
	@Override
	public List<Map<String, Object>> selectTheme2(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".selectTheme2", cid);
	}
	
	@Override
	public List<Map<String, Object>> selectTheme3(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".selectTheme3", cid);
	}

	@Override
	public void updatePermissions(Map m) {
		String username= (String) m.get("username");
		ArrayList alist = (ArrayList) m.get("data");
		String cid = (String) m.get("cid");

		List<Map<String, Object>> system_permission= (List<Map<String, Object>>) m.get("system_permission");
		Map<String, String> idToNameMap = new HashMap<>();
		for (Map<String, Object> sm : system_permission) {
			String id = String.valueOf(sm.get("ID"));
			String name = (String) sm.get("NAME");
			idToNameMap.put(id, name);
		}

		Map log = new HashMap();
		log.put("cid", cid);

		for(int i=0; i< alist.size(); i++) {
			LinkedHashMap per = (LinkedHashMap) alist.get(i);
			String uid = (String) per.get("uid");
			ArrayList<String> cper = (ArrayList<String>) per.get("cper");
			Map param = new HashMap();
			param.put("uid", uid);
			param.put("cid", cid);
			param.put("cper", cper);
			if (cper.size() == 0) {
				//do nothing
//				permissionService.deleteTeacherCourse(param);
//				permissionService.deletePermissionByTIDAndCID(param);
			}else{
				permissionService.deletePermissionByTIDAndCID(param);
				param.put("state", 0);
				permissionService.addTeacherCourse(param);
				permissionService.updatePermissionByTIDAndCID(param);
				permissionService.addTeacherPermission(param);

				StringBuilder sb =new StringBuilder();
				for(String pid:cper){
					sb.append(idToNameMap.get(pid)).append(",");
				}
				String logStr="为“"+per.get("tname")+"("+per.get("username")+")”在《"+m.get("cname")+"》课程，增加了权限：";
				if (sb.length() > 0) {
					sb.deleteCharAt(sb.length() - 1);
				}
				logStr+=sb.toString();
				log.put("content", logStr);
				systemService.addSysLog(log);
			}
		}
	}

	@Override
	public int deleteAllTheme(String cid) {
		// TODO Auto-generated method stub
		return update(namespace + ".delAllTheme", cid);
	}
	
	@Override
	public int delAllThemeForNewCourse(String cid) {
		return delete(namespace + ".delAllThemeForNewCourse", cid);
	}
	
	/**
	 * 验证是否有对应的课程权限,使用者：课程列表
	 * @author 洪艳
	 * @param map，传入参数（permission[例如：course:update],uid,cid）
	 * @return 1,有 2,无
	 */
	@Override
	public int checkCoursePermission(Map param,String uid_cid) {
		if(checkCreatorID(param)){
			return 1;
		}
		List<Permission> pLs = permissionService.findPerByUIDAndCID(param,uid_cid); 
		if(pLs!=null){
			String permission = (String)param.get("permission");
			if("course:view".equals(permission)){//浏览课程的权限，拥有pid:10,11
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==10||pid==11){
						return 1;
					}
				}
			}
			if("course:update".equals(permission)){//修改课程的权限，拥有pid:10,12
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==10||pid==12){
						return 1;
					}
				}
			}
			if("course:del".equals(permission)){//删除课程的权限，拥有pid:10,13
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==10||pid==13){
						return 1;
					}
				}
			}
			if("course:permission".equals(permission)){//课程权限的设置权限，拥有pid:10,15
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==10||pid==15){
						return 1;
					}
				}
			}
			if("course:add".equals(permission)){//添加课程的权限，拥有pid:10，14
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==10||pid==14){
						return 1;
					}
				}
			}
			if("paper:add".equals(permission)){//添加试卷的权限，拥有pid:32
				for(int i=0;i<pLs.size();i++){
					int pid = Integer.parseInt(pLs.get(i).getId());
					if(pid==32){
						return 1;
					}
				}
			}
		}
		return 0;
		
		/*
11	浏览课程	course	course:view	
12	修改课程	course	course:update	
13	删除课程	course	course:del	
15	课程权限设置	course	course:permission	
14	添加课程	course	course:add	
10	所有课程权限	course	course:*	
		 */
	}
	
	/**
	 * 验证是否有对应的课程权限,使用者：课程列表
	 * @author 洪艳
	 * @param map，传入参数（permission[例如：course:update],uid,cid）
	 * @return 1,有 0,无
	 */
	@Override
	public int checkCoursePermissionWithPID(Map param,String uid_pid) {
		List<Permission> pLs = permissionService.checkPermissionsByUID_PID(param,uid_pid); 
		if(pLs!=null && pLs.size()>0){
			return 1;
		}else{
			return 0;
		}
	}

	@Override
	public List<Map<String, Object>> getCourseSpecialtyList(String cid) {
		List<Map<String,Object>> list=query(namespace + ".getCourseSpecialtyList", cid);
		Map<String,Object> map=null;
		for(int i=0;i<list.size();i++){
			if("所有专业".equals(String.valueOf(list.get(i).get("NAME")))){
				map=list.get(i);
				list.remove(i);
			}
		}
		if(map!=null){
			list.add(0,map);
		}
		return list;
	}
	
	@Override
	public List<Map<String,Object>> getWjQuestiontype(){
		return query(namespace+".getWjQuestiontype");
	}

	@Override
	public List<Map<String,Object>> getCourseNameById(String[] cid) {
		// TODO Auto-generated method stub
		return query(namespace+".getCourseNameById",cid);
	}
	
	@Override
	public List<Map<String, Object>> getCourse4Export(Map param) {
		List<Map<String, Object>> res = query(namespace + ".getCourse", param);
//		for(int i=0; i<res.size(); i++){
//			String cid = (String) res.get(i).get("CID");
//			Map map = (Map) queryOne(namespace + ".getQuestionExamCountByCid", cid);
//
//			if(map!=null){
//				res.get(i).put("QCOUNT",map.get("QCOUNT"));
//				res.get(i).put("PAPERCOUNT",map.get("PCOUNT"));
//			}else{
//				res.get(i).put("QCOUNT",0);
//				res.get(i).put("PAPERCOUNT",0);
//			}
//		}
		return res;
	}
	
	@Override
	public List<Map<String, Object>> selectSpecialty(String id){
		return query(namespace+".selectSpecialty",id);
	}
	
	@Override
	public List<Map<String, Object>> selectArrangement(String id){
		return query(namespace+".selectArrangement",id);
	}
	
	/*
	@Override
	public Map<String,Object> selectQuestionTypeByID(String id){
		List<Map<String,Object>> list = query(namespace+".selectQuestionTypeByID",id);
		if(list==null||list.size()==0){
			return null;
		}
		return list.get(0);
	}*/

	@Override
	public List<Map<String, Object>> getCourseQuestionType(String cid) {
		return query(namespace + ".getCourseQuestionType", cid);
	}

	@Override
	public List<Map<String, Object>> getCourseQuestionInfo(String cid) {
		return query(namespace + ".getCourseQuestionInfo", cid);
	}

	@Override
	public List<Map<String, Object>> getStudentCourseList(Map param, PageUtils pu) {
		return query(namespace + ".getStudentCourseList",param, pu.getRb());
	}

	@Override
	public String getStudentCourseListCount(Map param){
		return query(namespace + ".getStudentCourseListCount", param).get(0).get("NUM").toString();
	}
	
	@Override
	public List<Map<String,Object>> getQuestionQTGX(Map param){
		return query(namespace+".getQuestionQTGX",param);
	}

	@Override
	public List<Map<String, Object>> getCourseDifficult(String cid) {
		return query(namespace + ".getCourseDifficult", cid);
	}

	@Override
	public List<Map<String, Object>> getQuestionTypeByQtids(List qtids) {
		return query(namespace + ".getQuestionTypeByQtids", qtids);
	}
	
	@Override
	public List<Map<String,List<String>>> getCourseRecordList(String cid) {			
		 List<String> list =queryList(namespace + ".getCourseRecord", cid); 
		 List<Map<String,Object>> lists =query(namespace + ".getCourseRecordList", cid);		 
		 List<Map<String,List<String>>> lists1 = new ArrayList<>();
		     for(int i=0;i<list.size();i++) {
		    	   String begindate = list.get(i);
		    	   Map<String,List<String>> map = new HashMap<>();
		    	   List<String> list_averagescore = new ArrayList<>();
	    		   List<String> list_ename = new ArrayList<>();
	    		   List<String> list_begindate = new ArrayList<>();
		    	   for(int j=0;j<lists.size();j++) {
		    		   String begindate1 = lists.get(j).get("BEGINDATE").toString();  		    		  
		    		   if(begindate.equals(begindate1)) {
		    			   list_averagescore.add(lists.get(j).get("AVERAGESCORE").toString());
		    			   list_ename.add(lists.get(j).get("ENAME").toString());
		    		   }	
		    		   map.put("x", list_ename);
		    		   map.put("y", list_averagescore);		    		  
		    		  }	 
		    	     list_begindate.add(begindate);
		    	     map.put("BEGINDATE",list_begindate);
		    	     lists1.add(map);
		     } 
		return lists1;
	}	
	
	@Override
	public List<Map<String, Object>> getDetailList(Map param, PageUtils pu) {
		List<Map<String,Object>> list=query(namespace + ".getDetailList", param, pu.getRb());
		//获取试卷的应答时长
		for(Map<String,Object> map:list){
			String timeid = Objects.toString(map.get("TIMEID"),"");
			map.put("TIME", commonService.getSystemTimeStrByID(timeid));
			
			String mut=String.valueOf(query(namespace+".getPaperUsetime",map.get("ID")).get(0).get("USETIME"));
			if(mut.indexOf(".")>-1){
				mut=mut.substring(0,mut.indexOf("."));
			}
			int maxUserTime=Integer.parseInt(mut);
			if(maxUserTime==0){
				map.put("usertime", "");
			}else{
				map.put("usertime", DateFormatUtils.formatDuration(maxUserTime));
			}
			
		}
		return list;		
	}
	
	@Override
	public String getPaperCount(Map param) {
		return query(namespace + ".getPaperCount", param).get(0).get("NUM").toString();
	}
	
	@Override
	public int getThemeID(){
		return (int)queryOne(namespace + ".getThemeID","");
	}
	
	@Override
	public List<Map<String, Object>> getDelCourse(Map param, PageUtils pu) {
		List<Map<String, Object>> res = query(namespace + ".getDelCourse", param, pu.getRb());
//		for(int i=0; i<res.size(); i++){
//			String cid = (String) res.get(i).get("CID");
//			Map map = (Map) queryOne(namespace + ".getQuestionExamCountByCid", cid);
//
//			if(map!=null){
//				res.get(i).put("QCOUNT",map.get("QCOUNT"));
//				res.get(i).put("PAPERCOUNT",map.get("PCOUNT"));
//			}else{
//				res.get(i).put("QCOUNT",0);
//				res.get(i).put("PAPERCOUNT",0);
//			}
//		}
		return res;
	}
	
	@Override
	public String getDelCourseCount(Map param) {
		// TODO Auto-generated method stub
		return ((Map<String,Object>)query(namespace + ".getDelCourseCount", param).get(0)).get("TAR").toString();
	}
	
	@Override
	public int recoverCourse(String cid) {
		String cname = getCourseCNameByCid(cid);
		Map log = new HashMap();
		log.put("content", "恢复删除课程《"+cname+"》(编号"+cid+")");
		log.put("cid", cid);
		systemService.addSysLog(log);
		Map param=new HashMap();
		param.put("cid", cid);
		param.put("state", 1);
		return update(namespace + ".updateCourseState", param);
	}
	
	@Override
	public List<Map<String, Object>> getCourseCognition(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".getCourseCognition", cid);
	}

	@Override
	public List<Map<String, Object>> getCourseSource(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".getCourseSource", cid);
	}

	@Override
	public List<Map<String, Object>> getCourseKnowledge(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".getCourseKnowledge", cid);
	}

	@Override
	public List<Map<String, Object>> getCourseDifficulty(String cid) {
		// TODO Auto-generated method stub
		return query(namespace + ".getCourseDifficulty", cid);
	}

	@Override
	public int addCourseQuestionType(Map param) {
		// TODO Auto-generated method stub
		return insert(namespace + ".addCourseQuestionType", param);
	}
	
	@Override
	public List<Map<String,Object>> getCourseByUID_CID(Map param){
		return query(namespace+".getCourseByUID_CID",param);
	}
	
	@Override
	public int deleteCourseAll(String cid) {
		String cname = getCourseCNameByCid(cid);
		
		//删除所有与课程相关的学生答题记录
		delete(namespace + ".delSexam4DropCourse", cid);
		delete(namespace + ".delSanswer4DropCourse", cid);
		delete(namespace + ".delSanswerquestion4DropCourse", cid);
		delete(namespace + ".delPaperAnswer4DropCourse", cid);
		delete(namespace + ".delPaperQt4DropCourse", cid);
		delete(namespace + ".delPaperParam4DropCourse", cid);
		delete(namespace + ".delPaperCourse4DropCourse", cid);
		delete(namespace + ".delPaperQuestion4DropCourse", cid);
		delete(namespace + ".delExamObject4DropCourse", cid);
		delete(namespace + ".delExaminfo4DropCourse", cid);
		delete(namespace + ".delPermission4DropCourse", cid);
		delete(namespace + ".delAnswer4DropCourse", cid);
		delete(namespace + ".delQuestion4DropCourse", cid);
		
		delete(namespace + ".delArrangement4DropCourse", cid);
		delete(namespace + ".delCognition4DropCourse", cid);
		delete(namespace + ".delDifficulty4DropCourse", cid);
		delete(namespace + ".delExamtype4DropCourse", cid);
		delete(namespace + ".delKnowledge4DropCourse", cid);
		delete(namespace + ".delQuestiontype4DropCourse", cid);
		delete(namespace + ".delSource4DropCourse", cid);
		delete(namespace + ".delSpecialty4DropCourse", cid);
		delete(namespace + ".delQuesPageTotal4DropCourse", cid);
		delete(namespace + ".delCourse4DropCourse", cid);
		
		//删除主题词，如果有别的试卷关联了主题词，不删除，否则删除
		Map m=new HashMap();
		m.put("cid", cid);
		delete(namespace + ".delTheme4DropCourse", m);
		
		Map log = new HashMap();
		log.put("content", "彻底删除课程《"+cname+"》(编号"+cid+")");
		log.put("cid", cid);
		systemService.addSysLog(log);
		return 1;
	}
	
	@Override
	public int delCourseNotPaper(String cid) {
		String cname = getCourseCNameByCid(cid);
		Map log = new HashMap();
		log.put("content", "彻底删除课程《"+cname+"》(编号"+cid+"),不包含试卷及成绩");
		log.put("cid", cid);
		systemService.addSysLog(log);
		
		//删除所有与课程相关的学生答题记录
		delete(namespace + ".delPaperCourse4DropCourse", cid);
		delete(namespace + ".delPermission4DropCourse", cid);
		delete(namespace + ".delQuestion4DropCourse", cid);
		
		delete(namespace + ".delArrangement4DropCourse", cid);
		delete(namespace + ".delCognition4DropCourse", cid);
		delete(namespace + ".delDifficulty4DropCourse", cid);
		delete(namespace + ".delExamtype4DropCourse", cid);
		delete(namespace + ".delKnowledge4DropCourse", cid);
		delete(namespace + ".delQuestiontype4DropCourse", cid);
		delete(namespace + ".delSource4DropCourse", cid);
		delete(namespace + ".delSpecialty4DropCourse", cid);
		delete(namespace + ".delQuesPageTotal4DropCourse", cid);
		delete(namespace + ".delCourse4DropCourse", cid);
		
		//删除主题词，如果有别的试卷关联了主题词，不删除，否则删除
		Map m=new HashMap();
		m.put("cid", cid);
		delete(namespace + ".delTheme4DropCourse", m);
		return 1;
	}
	
	public Map<String,Object> getCourseByCID(String cid){
		return query(namespace+".getCourseByCID",cid).get(0);
	}
	
	@Override
	public int updateCQ_QT(Map m){
		return update(namespace+".updateCQ_QT",m);
	}
	
	@Override
	public int importCourse(Map param) {
		User user = (User)SecurityUtils.getSubject().getSession().getAttribute("userInfo");
		insert(namespace + ".insertCourse", param);
		insert(namespace + ".insertArrangement", param);
		insert(namespace + ".insertQuestionType", param);
		insert(namespace + ".insertExamType", param);
		insert(namespace + ".insertSpecialty", param);
		insert(namespace + ".insertDifficulty", param);
		insert(namespace + ".insertKnowledge", param);
		insert(namespace + ".insertCognition", param);
		insert(namespace + ".insertSource", param);
		insert(namespace + ".insertCourseQuesPageTotal",param);
		try{
//			List<String>  list =  (List<String>)userService.getTeacherTid(param);
//			if(list!=null&&list.size()>0) {
//				Map m2 = new HashMap();
//				m2.put("cper",list);
//				m2.put("cid", param.get("id"));
//				m2.put("pid", "11");
//				m2.put("getperbyrole", "0");
//				insert(namespace + ".addTeacherPermission", m2);	
//			}
			//添加权限关系
			if(!"".equals(param.get("unitId"))){
				Map p = new HashMap();
				p.put("uid", user.getId());
				p.put("unitid", param.get("unitId"));
				if(!"".equals(param.get("deptId"))){
					p.put("depid", param.get("deptId"));
				}
				
				List<Map<String, Object>> ls = userService.findSuperiors4import(p);
				//获取系统的角色权限
				List<Map<String,Object>> rolePermission=permissionService.findRolePermission();
				if(ls!=null&&ls.size()>0){
					Map cmap = new HashMap();
					cmap.put("cid", param.get("id"));
					for(int i=0;i<ls.size();i++){
						Map<String, Object> s = ls.get(i);
						String rid=(String)s.get("ROLEID");
						if(rid.equals("1")){
							continue;
						}
						cmap.put("uid", s.get("ID"));
						List<String> l = new ArrayList<String>();
						for(Map<String,Object> rp:rolePermission){
							if(rid.equals(String.valueOf(rp.get("RID")))){
								l.add(String.valueOf(rp.get("PID")));
							}
						}
						cmap.put("cper", l);
						permissionService.addTeacherPermission(cmap);
					}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return 1;
	}
	
	@Override
	public String getCourse_UnitID(String cid) {
		return queryOne(namespace + ".getCourse_UnitID",cid);
	}
	
	@Override
	public int separateOption(Map param) {
		int rtn=0;
		List<Map<String,Object>> qList=query(namespace+".getQuestionAnswerList",param);
		
		for(int i=0;i<qList.size();i++) {
			try {
				Map<String,Object> qmap=qList.get(i);
				String qtid=String.valueOf(qmap.get("qtid"));
				if("155".equals(qtid)){
					continue;
				}
				List<Map<String,Object>> answer=(List<Map<String, Object>>) qmap.get("answer");
				boolean b=false;
				for(int j=0;j<answer.size();j++) {
					String acontent=String.valueOf(answer.get(j).get("acontent"));
					if(acontent.equals((char)(j+65)+"")) {
						continue;
					}else {
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
					}
					String detail_content=details.substring(0,details.indexOf("A"+fgf));
					qmap.put("content", detail_content);
					
					Map<String,Object> mm=new HashMap<String,Object>();
					mm.put("cid", param.get("cid"));
					for(int j=0;j<20;j++){
						String letter=(char)(j+65)+"";
						String letter_next=(char)(j+66)+"";
						if(details.indexOf(letter_next+fgf)>0){
							String detail_letter=details.substring(details.indexOf(letter+fgf)+(fgf.length()+1),details.indexOf(letter_next+fgf));
							if(j==answer.size()) {
								String aid=questionService.getAnswerID();
								mm.put("aid", aid);
								mm.put("qid", qList.get(i).get("qid"));
								mm.put("answer_content", detail_letter);
								mm.put("answer_content_6", "");
								mm.put("answertype", qList.get(i).get("atid"));
								mm.put("index", aid);
								update(namespace+".insertAnswer",mm);
							}else {
								mm.put("aid", answer.get(j).get("aid"));
								mm.put("qid", qList.get(i).get("qid"));
								mm.put("answer_content", detail_letter);
								mm.put("answer_content_6", "");
								update(namespace+".updateAnswer",mm);
							}
						}else{
							String detail_letter=details.substring(details.indexOf(letter+fgf)+(fgf.length()+1));
							if(j==answer.size()) {
								String aid=questionService.getAnswerID();
								mm.put("aid", aid);
								mm.put("qid", qList.get(i).get("qid"));
								mm.put("answer_content", detail_letter);
								mm.put("answer_content_6", "");
								mm.put("answertype", qList.get(i).get("atid"));
								mm.put("index", aid);
								update(namespace+".insertAnswer",mm);
							}else {
								mm.put("aid", answer.get(j).get("aid"));
								mm.put("qid", qList.get(i).get("qid"));
								mm.put("answer_content", detail_letter);
								mm.put("answer_content_6", "");
								update(namespace+".updateAnswer",mm);
							}
							break;
						}
					}
					update(namespace + ".updateQuestionContent", qmap);
					rtn++;
				}
			}catch(Exception e) {
				continue;
			}
		}
		return rtn;
	}
	private String getText(String content){
        String txtcontent = content.replaceAll("</?[^>]+>", "");
        txtcontent = txtcontent.replaceAll("<a>\\s*|\t|\r|\n|</a>", "");
         return txtcontent;
    }

	@Override
	public boolean checkCreatorID(Map param){
		List<Map<String,Object>> list=query(namespace+".checkCreatorID",param);
		if(list!=null&&list.size()>0){
			return true;
		}else{
			return false;
		}
	}

	@Override
	public int setThemeOrder(Map param) {
		return update(namespace+".setThemeOrder",param);
	}


	@Override
	public List<Map<String,Object>> findCourseCode(String[] cids){
		return query(namespace+".findCourseCode",cids);
	}

	@Override
	public List<Theme> getThemeTree(String cid, Long searchPid){
		List<Theme> allThemes = queryList(namespace+".getCourseAllThemes",cid);
		return ThemeUtils.buildThemeTree(allThemes, searchPid);
	}

	@Override
	public boolean isThemeInQuestionOrExampaper(Map<String,Object> param){
		List<String> qids = queryList(namespace+".findThemeIdsInQuestionOrExampaper", param);
		if (qids == null || qids.isEmpty()) {
			return false;
		}
		int exists = Utils.changeObjToInt(qids.get(0));
		return exists==1;
	}
}
