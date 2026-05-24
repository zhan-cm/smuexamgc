package com.cx.kaoyi.business.service.serviceImpl;

import com.cx.kaoyi.business.domain.Student;
import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.service.SystemService;
import com.cx.kaoyi.framework.base.BaseService;


import com.cx.kaoyi.framework.cache.LocalCache;
import com.cx.kaoyi.framework.utils.DateFormatUtils;
import com.cx.kaoyi.framework.utils.PageUtils;
import com.cx.kaoyi.framework.utils.Utils;
import org.apache.shiro.SecurityUtils;
import org.springframework.stereotype.Service;

import java.util.*;

@Service("systemService")
public class SystemServiceImpl extends BaseService implements SystemService{

	public static String namespace = "resources.mappers.system";

	@Override
	public int addSchoolYear(Map param){
		return insert(namespace + ".addSchoolYear", param);
	}

	@Override
	public String getSchoolYearByName(Map param){
		return queryOne(namespace + ".getSchoolYearByName",param);
	}

	@Override
	public List<Map<String, Object>> getUnitList(Map param, PageUtils pu) {
		// TODO Auto-generated method stub
		return query(namespace + ".getUnitList", param, pu.getRb());
	}

	@Override
	public List<Map<String, Object>> getAllUnit(Map param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getUnitList", param);
	}

	@Override
	public List<Map<String, Object>> getDepartmentList(Map param, PageUtils pu) {
		// TODO Auto-generated method stub
		return query(namespace + ".getDepartmentList", param, pu.getRb());
	}

	@Override
	public String getDefaultQuestionTypeCount(Map param) {
		return query(namespace + ".getDefaultQuestionTypeCount", param).get(0).get("NUM").toString();
	}

	@Override
	public int insertQuestionType(Map param) {
		return insert(namespace + ".addQuestionType", param);
	}

	@Override
	public String getUnitCount(Map param) {
		return query(namespace + ".getUnitCount", param).get(0).get("NUM").toString();
	}

	@Override
	public String getDepartmentCount(Map param) {
		return query(namespace + ".getDepartmentCount", param).get(0).get("NUM").toString();
	}

	@Override
	public int insertUnit(Map param) {
		return insert(namespace + ".addUnit", param);
	}

	@Override
	public List<String> getServerNameList() {
		List<String> list = queryList(namespace + ".getServerNameList");
		return list==null ? new ArrayList<>(): list;
	}

	@Override
	public int addServerName(String serverName) {
		return insert(namespace + ".addServerName", serverName);
	}

	@Override
	public int deleteServerName(String serverName) {
		return delete(namespace + ".deleteServerName", serverName);
	}

	@Override
	public int insertDepartment(Map param) {
		return insert(namespace + ".addDepartment", param);
	}

	@Override
	public int updateDep(Map param) {
		return update(namespace + ".updateDep", param);
	}

	@Override
	public int updateUnit(Map param) {
		update(namespace + ".updateUnit", param);
		return update(namespace + ".updateUnitName", param);
	}

	@Override
	public List<Map<String, Object>> getSpecialtyList(Map param, PageUtils pu) {
		// TODO Auto-generated method stub
		return query(namespace + ".getSpecialtyList", param, pu.getRb());
	}

	@Override
	public String getSpecialtyCount(Map param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getSpecialtyCount", param).get(0).get("NUM").toString();
	}
	
	@Override
	public String getExamtypeCount(Map param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getExamtypeCount", param).get(0).get("NUM").toString();
	}

	@Override
	public int insertSpecialty(Map param) {
		// TODO Auto-generated method stub
		return insert(namespace + ".addSpecialty", param);
	}
	
	@Override
	public int insertExamtype(Map param) {
		// TODO Auto-generated method stub
		return insert(namespace + ".insertExamtype", param);
	}
	
	@Override
	public int insertGrade(String gname) {
		return insert(namespace + ".addGrade", gname);
	}

	@Override
	public int updateSpecialty(Map param) {
		update(namespace + ".updateSpecialty", param); //更新专业名
		return update(namespace + ".updateAllStudentSpecialty", param); //更新所有学生相关专业名字段
	}
	
	@Override
	public int updateExamtype(Map param) {
		return update(namespace + ".updateExamtype", param);
	}
	
	@Override
	public String getAddrCount(Map param) {
		return query(namespace + ".getAddrCount", param).get(0).get("NUM").toString();
	}

	@Override
	public int insertAddr(Map param) {
		return insert(namespace + ".addAddr", param);
	}

	@Override
	public int updateAddr(Map param) {
		return update(namespace + ".updateAddr", param);
	}

	@Override
	public int delUnit(Map param) {
		return update(namespace + ".delUnit", param);
	}

	@Override
	public int delDep(Map param) {
		// TODO Auto-generated method stub
		return update(namespace + ".delDep", param);
	}
	
	@Override
	public int delAddr(String id){
		return delete(namespace + ".delAddr", id);
	}

	@Override
	public int delSpecialty(Map param) {
		// TODO Auto-generated method stub
		return update(namespace + ".delSpecialty", param);
	}
	
	@Override
	public int delExamtype(Map param) {
		// TODO Auto-generated method stub
		return update(namespace + ".delExamtype", param);
	}
	
	@Override
	public int del(Map param) {
		// TODO Auto-generated method stub
		return update(namespace + ".del", param);
	}

	@Override
	public int delQuestionType(Map param) {
		// TODO Auto-generated method stub
		return update(namespace + ".delQuestionType", param);
	}

	@Override
	public int addOnlineSysLog(String content) {
		Map param = new HashMap();
		User user = (User) SecurityUtils.getSubject().getSession().getAttribute("userInfo");
		param.put("ip", user.getIp());
		param.put("name", user.getUsername());
		param.put("cid", "");
		String addtime = DateFormatUtils.getNowTime();
		param.put("addtime", addtime);
		param.put("content", addtime+" "+user.getRealname()+content);

		return insert(namespace + ".addSysLog", param);
	}

	@Override
	public int addOnlineStuSysLog(String content) {
		Map param = new HashMap();
		Student student = (Student) SecurityUtils.getSubject().getSession().getAttribute("student");
		param.put("ip", student.getIp());
		param.put("name", student.getNum());
		param.put("cid", "");
		String addtime = DateFormatUtils.getNowTime();
		param.put("addtime", addtime);
		param.put("content", addtime+" "+student.getNum()+" "+student.getName()+content);

		return insert(namespace + ".addSysLog", param);
	}

	@Override
	public int addSysLog(Map param) {
		User user = (User) SecurityUtils.getSubject().getSession().getAttribute("userInfo");
		param.put("ip", user.getIp());
		param.put("name", user.getUsername());

		String addtime = DateFormatUtils.getNowTime();
		param.put("addtime", addtime);
		param.put("content", addtime+" "+user.getRealname()+param.get("content"));
		
		return insert(namespace + ".addSysLog", param);
	}

	@Override
	public int addAnySysLog(Map param){
		return insert(namespace + ".addSysLog", param);
	}

	@Override
	public int addDelQuestionSysLog(Map param) {

		param.put("ip", "127.0.0.1");
		param.put("name", "定时任务");

		String addtime = DateFormatUtils.getNowTime();
		param.put("addtime", addtime);
		param.put("content", addtime+" "+"QuestionTaskJob"+param.get("content"));

		return insert(namespace + ".addSysLog", param);
	}
	
	@Override
	public int addSysLog_student(Map param) {
		String addtime = DateFormatUtils.getNowTime();
		param.put("addtime", addtime);
		param.put("content", addtime+" "+param.get("content"));
		
		return insert(namespace + ".addSysLog", param);
	}

	@Override
	public int addSysLog_noLogin(Map map) {
		User user=(User)map.get("user");
		Map param = new HashMap();
		param.put("ip", user.getIp()!=null? user.getIp():Utils.getIp());
		param.put("name", user.getUsername());
		String addtime = DateFormatUtils.getNowTime();

		param.put("addtime", addtime);
		param.put("content", addtime+map.get("content"));
		param.put("cid", 0);
		return insert(namespace + ".addSysLog", param);
	}

	@Override
	public List<Map<String, Object>> getLogsList(Map param,PageUtils pu) {
		return query(namespace + ".getLogsList",param,pu.getRb());
	}

	@Override
	public String getLogsCount(Map param) {
		return query(namespace + ".getLogsCount",param).get(0).get("NUM").toString();
	}

	@Override
	public List<Map<String, Object>> getLogsListBefore(String time) {
		return query(namespace + ".getLogsListBefore",time);
	}

	@Override
	public int delLogsBefore(String time) {
		return delete(namespace+".delLogsBefore",time);
	}

	@Override
	public int delCourseSpecialty(Map param) {
		return update(namespace+".delCourseSpecialty", param);
	}

	@Override
	public Map<String,Map<String,Object>> getAllSystemParam(){
		List<Map<String,Object>> list = query(namespace+".getAllSystemParam");
		Map<String,Map<String,Object>> rtn = new HashMap<>();
		for(Map<String,Object> param : list){
			Map<String,Object> innerParam = new HashMap<>();
			rtn.put((String) param.get("NAME"), innerParam);
			if(param.get("YL_1")!=null && !"".equals(param.get("YL_1"))){
				innerParam.put("YL_1", param.get("YL_1"));
			}
			if(param.get("YL_2")!=null && !"".equals(param.get("YL_2"))){
				innerParam.put("YL_2", param.get("YL_2"));
			}
			if(param.get("YL_3")!=null && !"".equals(param.get("YL_3"))){
				innerParam.put("YL_3", param.get("YL_3"));
			}
			if(param.get("YL_4")!=null && !"".equals(param.get("YL_4"))){
				innerParam.put("YL_4", param.get("YL_4"));
			}
			if(param.get("YL_5")!=null && !"".equals(param.get("YL_5"))){
				innerParam.put("YL_5", param.get("YL_5"));
			}
			if(param.get("STATE")!=null && !"".equals(param.get("STATE"))){
				innerParam.put("STATE", param.get("STATE"));
			}
			if(param.get("PARAM")!=null && !"".equals(param.get("PARAM"))){
				innerParam.put("PARAM", param.get("PARAM"));
			}
		}
		return rtn;
	}
	
	@Override
	public Map<String,Object> getSystemParam(String name){
		return queryOne(namespace+".getSystemParam",name);
	}
	
	@Override
	public int updateSystemParam(Map param){
		return update(namespace+".updateSystemParam",param);
	}

	@Override
	public String getUnitNameById(String unitId) {
		return queryOne(namespace+".getUnitNameById",unitId)+"";
	}

	@Override
	public String getAddrByID(String id) {
		return queryOne(namespace+".getAddrByID", id).toString();
	}

	@Override
	public String getSpNameByID(String id) {
		return queryOne(namespace+ ".getSpNameByID",id)+"";
	}
	
	@Override
	public String getEmNameByID(String id) {
		return queryOne(namespace+ ".getEmNameByID",id)+"";
	}

	@Override
	public int updateQuestionTypeOrder(String[] qtids) {
		int rs = 0;
		for(int i=0;i<qtids.length;i++) {
			Map<String, Object> param = new HashMap<>();
			param.put("qorder", i+1);
			param.put("qtid", qtids[i]);
			rs+=update(namespace + ".updateQuestionTypeOrder", param);
		}
		return rs;
	}
	
	@Override
	public int updateQuestionType(Map param){
		/*
		String id=String.valueOf(param.get("id"));
		int iscon=Integer.parseInt(String.valueOf(param.get("iscon")));
		String atid=String.valueOf(param.get("atid"));
		List<Map<String,Object>> defaultList=defaultQuestionType();
		for(Map<String,Object> map:defaultList){
			String qtid=String.valueOf(map.get("ID"));
			if(qtid.equals(id)){
				if(iscon!=Integer.parseInt(String.valueOf(map.get("ISCON")))||!atid.equals(String.valueOf(map.get("ANSWERTYPEID")))){
					Map m = new HashMap();
					m.put("name", param.get("name"));
					m.put("desc", param.get("desc"));		
					m.put("iscon", iscon);
					m.put("answertypeid", atid);
					m.put("isdefault", 1);
					m.put("qorder", map.get("QORDER"));
					insert(namespace + ".addQuestionType", m);
					
					Map mm = new HashMap();
					mm.put("id", id);
					update(namespace + ".delQuestionType", mm);
				}else{
					Map m = new HashMap();
					m.put("name", param.get("name"));
					m.put("desc", param.get("desc"));
					m.put("id", id);
					update(namespace + ".updateQtname_qtdesc", m);
				}
				break;
			}
		}
		return 1;*/
		return update(namespace+".updateDefaultQuestionType",param);
	}

	@Override
	public int recSpecialty(String id) {
		return update(namespace + ".recSpecialty", id);
	}

	@Override
	public int updateStudentSpecialtyInSelf(){
		return update(namespace+".updateStudentSpecialtyInSelf", null);
	}
	
	@Override
	public int recExamtype(String id) {
		return update(namespace + ".recExamtype", id);
	}

	@Override
	public int getRepeatSpecialty(Map map) {
		return (int) queryOne(namespace + ".getRepeatSpecialty", map);
	}
	
	@Override
	public int getRepeatExamtype(Map map) {
		return (int) queryOne(namespace + ".getRepeatExamtype", map);
	}

	@Override
	public int getRepeatUnit(Map param) {
		return (int) queryOne(namespace + ".getRepeatUnit", param);
	}

//	@Override
//	public int delDepByUid(String uid) {
//		// TODO Auto-generated method stub
//		return update(namespace + ".delDepByUid", uid);
//	}

	@Override
	public int getRepeatDep(Map param) {
		return (int) queryOne(namespace + ".getRepeatDep", param);
	}

	@Override
	public int recUnit(String id) {
		return update(namespace + ".recUnit", id);
	}

	@Override
	public int recDep(String id) {
		return update(namespace + ".recDep", id);
	}

	@Override
	public String getDeptByID(String para) {
		return (String) query(namespace + ".getDeptByID", para).get(0).get("NAME");
	}

	@Override
	public int deleteUnit(String id) {
		//删除教训单位
		int r = delete(namespace + ".deleteUnit", id);
		//删除部门
		r =delete(namespace + ".deleteDepartment", id);
		return r;
	}

	@Override
	public List<Map<String, Object>> getCourseNameByUnit(String id) {
		return query(namespace + ".getCourseNameByUnit", id);
	}

	@Override
	public List<Map<String, Object>> getTeacherNameByUnit(String id) {
		return query(namespace + ".getTeacherNameByUnit", id);
	}

	@Override
	public String getDepartmentNameByUnit(String id) {
		String rs = "";
		List<Map<String, Object>> ls = query(namespace + ".getDepartmentNameByUnit", id);
		if(ls.size() > 0) {
			for(Map m:ls) {
				rs += m.get("NAME")+",";
			}
			rs.substring(0, rs.length()-1);
		}
		return rs;
	}

	@Override
	public int delDepByUid(Map param) {
		return update(namespace + ".delDepByUid", param);
	}
	
	@Override
	public int updateTeacherPermission(Map m){
		ArrayList alist  =  (ArrayList) m.get("data");
		LocalCache cache = LocalCache.getInstance();
		for(int i = 0 ; i< alist.size(); i++){
			LinkedHashMap perList = (LinkedHashMap) alist.get(i);
			String rid = (String) perList.get("rid"); 
			ArrayList per = (ArrayList) perList.get("per");
			Map param = new HashMap();
			param.put("rid", rid);
			param.put("per", per);
			cache.evict("permissions", "role_per_"+rid);
			delete(namespace+".deleteRolePermission",param);
			if(per.size() != 0){	
				insert(namespace+".insertRolePermission",param);
			}
		}
		return 1;
	}

	@Override
	public Object getStudentLoginRecord(Map m, PageUtils pu) {
		return query(namespace + ".getStudentLoginRecord", m, pu.getRb());
	}

	@Override
	public String getStudentLoginRecordTotal(Map m) {
		return queryOne(namespace + ".getStudentLoginRecordTotal", m).toString();
	}
	@Override
	public List<Map<String,Object>> getMenuPermission(){
		return query(namespace + ".getMenuPermission");
	}

	@Override
	public List<Map<String,Object>> getAllMenuRole(){
		return query(namespace+".getAllMenuRole");
	}

	@Override
	public int saveMenuPermission(Map param){
		delete(namespace + ".delMenuRole", param.get("mid"));
		if((param.get("rids")!=null&&((String[])param.get("rids")).length>0)){
			return insert(namespace + ".insertMenuRole", param);  
		}
		return 0; 
	}

	@Override
	public int saveMenuOrder(String mid, String direction) {
		List<Map<String,Object>> list = query(namespace + ".getMenuOrder");
		if (list == null || list.size() == 0) {
			return 0;
		}
		int index = -1;
		for (int i = 0; i < list.size(); i++) {
			if (mid.equals(String.valueOf(list.get(i).get("ID")))) {
				index = i;
				break;
			}
		}
		if (index == -1) {
			return 0;
		}
		int targetIndex;
		if ("up".equals(direction)) {
			targetIndex = index - 1;
		} else if ("down".equals(direction)) {
			targetIndex = index + 1;
		} else {
			return 0;
		}
		if (targetIndex < 0 || targetIndex >= list.size()) {
			return 0;
		}
		Map<String,Object> current = list.get(index);
		Map<String,Object> target = list.get(targetIndex);
		// 只能同级交换
		if (!String.valueOf(current.get("MLEVEL")).equals(String.valueOf(target.get("MLEVEL")))) {
			return 0;
		}
		String currentOrder = String.valueOf(current.get("MORDER"));
		String targetOrder = String.valueOf(target.get("MORDER"));
		target.put("morder", Integer.parseInt(currentOrder));
		target.put("id", target.get("ID"));
		update(namespace + ".updateMenuOrder", target);
		current.put("morder", Integer.parseInt(targetOrder));
		current.put("id", current.get("ID"));
		update(namespace + ".updateMenuOrder", current);
		return 1;
	}

	@Override
	public int delByDate(Map param) {
		return delete(namespace + ".delByDate", param);
	}
	
	@Override
	public List<Map<String,Object>> findAllTeacher(){
		return query(namespace + ".findAllTeacher");
	}
	
	@Override
	public void resetPass(Map param){
		update(namespace + ".resetPass",param);
	}

    @Override
    public List<Map<String,Object>> findNotLoginTeacher(){
        return query(namespace + ".findNotLoginTeacher");
    }

	@Override
	public int clearListeningRecord(){
		return delete(namespace + ".clearListeningRecord", Collections.EMPTY_MAP);
	}
}
