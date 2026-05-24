package com.cx.kaoyi.business.controller.course;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import com.cx.kaoyi.business.service.*;
import com.cx.kaoyi.framework.base.FileDownloadUtils;
import com.cx.kaoyi.framework.utils.*;
import org.apache.commons.lang3.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.core.io.Resource;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.cx.kaoyi.business.domain.Permission;
import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.framework.base.BaseController;

@Controller
@RequestMapping("/course")
public class CourseController extends BaseController {
	@Value("${wj_cid}")
	private String wj_cid;
	
	@Autowired
	public CourseService courseService;

	@Autowired
	public CommonService commonService;
	
	@Autowired
	public UserService userService;

	@Autowired
	public PoiService poiService;
	
	@Autowired
	public SystemService systemService;

	@Autowired
	public PermissionService permissionService;
	
	@Autowired
	public QuestionService questionService;

	/**
	 * 进入课程列表
	 * @param /errorInfo
	 * @return String
	 */
	@RequestMapping("/inCourse")
	public String inCourse() {
		User u = getUserInfo();
		if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
        	u.setcIDs(userService.findAllCids());
        	getRequest().setAttribute("addCoursePermission", 1);
        }else{ //其他角色，查询有浏览课程权限的所有课程
        	u.setcIDs(userService.findCids(u.getId()));
        	String rs = commonService.getAddCoursePermission(u.getId());
    		if("1".equals(rs)){
    			getRequest().setAttribute("addCoursePermission", 1);
    		}else{
    			getRequest().setAttribute("addCoursePermission", 0);
    		}
        }
		Set<String> cIDs = u.getcIDs();
		int cCount = cIDs.size();
		if(wj_cid!=null && !"".equals(wj_cid)){
			cIDs.add(wj_cid);
			if(!wj_cid.equals("-1")){
				cCount++;
			}
		}
		
		getRequest().setAttribute("cCount", cCount);
		
		Map param = new HashMap();
		param.put("cIDs", cIDs.toArray(new String[] {}));

		List<String> cidstrList=getCidStrList(cIDs);
		param.put("cidstr", cidstrList);
//		getRequest().setAttribute("qCount", questionService.getAllQuestionCount(param));
		getRequest().setAttribute("back", getRequest().getParameter("back"));
		
		return "jsp/course/courseList";
	}

	/**
	 * 进入已删除课程列表
	 * @return String
	 */
	@RequestMapping("/inDelCourse")
	public String inDelCourse() {
		return "jsp/course/delCourseList";
	}
	
	@RequestMapping("/getCourse_QuestionCount")
	public @ResponseBody Map<String, Object> getCourse_QuestionCount() {
        User u = getUserInfo();
	    List<String> cids=new ArrayList<>();
	    String state=getPara("state");
	    if("2".equals(state)){
            cids=(List<String>)getSession().getAttribute("delQuestion_cids");
        }else{
            if(u.getcIDs()==null){
                if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
                    u.setcIDs(userService.findAllCids());
                }else{ //其他角色，查询有浏览课程权限的所有课程
                    u.setcIDs(userService.findCids(u.getId()));
                }
            }
            Set<String> cIDs = u.getcIDs();
            if(wj_cid!=null && !"".equals(wj_cid)){
                cIDs.add(wj_cid);
            }
            cids.addAll(cIDs);
        }
		Map param = new HashMap();
		param.put("owner", getPara("owner")); //使用者，课程列表/试题/组卷
		param.put("cname", getRequest().getParameter("cname"));	//课程名
		param.put("unitid", getPara("unitid"));		//单位ID	
		param.put("depid", getPara("depid"));		//部门ID	
		param.put("arrangeid", getPara("arrangeid")); //层次id
		param.put("uid", u.getId());
		param.put("begindate", String.valueOf(getPara("beginDate")));
		param.put("enddate", String.valueOf(getPara("endDate")));
		param.put("bdate", String.valueOf(getPara("bdate")));
		param.put("edate", String.valueOf(getPara("edate")));
		param.put("cIDs", cids.toArray(new String[] {}));

		param.put("cidstr", getCidStrList(cids));
		Map<String,Object> rtn=new HashMap<>();
		List<Map<String,Object>> cidList=courseService.getCourseCount_cidList(param);
		rtn.put("cCount", cidList.size());

		List<String> cidstrList = new ArrayList<>();
		String cidstr="";
		int i=0;
		for(int j=0;j<cidList.size();j++){
			String cc=(String)cidList.get(j).get("CID");
			if(i==50){
				cidstr=cidstr.substring(0,cidstr.length()-1);
				cidstrList.add(cidstr);
				cidstr="";
				i=0;
			}
			cidstr+=cc+",";
			i++;
		}
		if(cidstr.length()>0){
			cidstr=cidstr.substring(0,cidstr.length()-1);
		}
		cidstrList.add(cidstr);
		param.put("cidstr", cidstrList);

		param.put("state",getPara("state"));
		rtn.put("qCount", questionService.getAllQuestionCount(param));

		return rtn;
	}

	/**
	 * 获取课程列表，使用者：【题库管理端】课程列表、编辑试题
	 * @author 洪艳
	 * @param
	 * @return Map<String, Object>
	 */
	@RequestMapping("/getCourseList")
	public @ResponseBody Map<String, Object> getCourseList() {
		User u = getUserInfo();
		if(u.getcIDs()==null){
			if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
	        	u.setcIDs(userService.findAllCids());
	        }else{ //其他角色，查询有浏览课程权限的所有课程
	        	u.setcIDs(userService.findCids(u.getId()));
	        }
		}
		Set<String> cIDs = u.getcIDs();
		if(!StringUtils.isBlank(wj_cid)){
			cIDs.add(wj_cid);
		}
		
		Map param = new HashMap();
		PageUtils pu = getPageUtil();
		param.put("order", pu.getOrder());
		param.put("sort", pu.getSort());

		param.put("owner", getPara("owner")); //使用者，课程列表/试题/组卷
		setMapParamSafe(param, "cname");	//课程名
		param.put("unitid", getPara("unitid"));		//单位ID	
		param.put("depid", getPara("depid"));		//科室ID	
		param.put("arrangeid", getPara("arrangeid")); //层次id
		param.put("uid", u.getId());
		param.put("condition", 1); //是否模糊查询
		param.put("begindate", String.valueOf(getPara("beginDate")));
		param.put("enddate", String.valueOf(getPara("endDate")));
		param.put("bdate", String.valueOf(getPara("bdate")));
		param.put("edate", String.valueOf(getPara("edate")));
		Map<String, Object> res = new HashMap<>();
		param.put("cIDs", cIDs.toArray(new String[] {}));
		List<String> cidstrList=getCidStrList(cIDs);
		param.put("cidstr", cidstrList);
		res.put("rows", courseService.getCourse(param, pu));
		res.put("total", Integer.parseInt(courseService.getCourseCount(param)));
		return res;
	}


	/**
	 * 获取被删除了试题的课程列表，使用者：【题库管理端】课程列表、暂时被删除的试题
	 * @author
	 * @param
	 * @return Map<String, Object>
	 */
	@RequestMapping("/getDelQueCourseList")
	public @ResponseBody Map<String, Object> getDelQueCourseList() {
		//查询出被删除的试题的课程id
		List<String> cids = courseService.getCourseByDelQue();
        getSession().setAttribute("delQuestion_cids",cids);
		Map map = new HashMap();
		map.put("cids",cids);
		//获取用户信息判断显示的列表
        User u = getUserInfo();
        PageUtils pu = getPageUtil();
        Map param = new HashMap();
        param.put("owner", getPara("owner")); //使用者，课程列表/试题/组卷
        param.put("cname", getRequest().getParameter("cname"));	//课程名
        param.put("unitid", getPara("unitid"));		//单位ID
        param.put("arrangeid", getPara("arrangeid")); //层次id
        param.put("uid", u.getId());
        param.put("condition", 1); //是否模糊查询
        Map<String, Object> res = new HashMap<String, Object>();
        param.put("cIDs", cids.toArray(new String[] {}));
        List<String> cidstrList=getCidStrList(cids);
        param.put("cidstr", cidstrList);
		param.put("state",2);
		res.put("rows", courseService.getDelQueCourse(param, pu));
		res.put("total", Integer.parseInt(courseService.getCourseCount(param)));
        return res;
	}
	
	@RequestMapping("/getQueCourseList")
	public @ResponseBody Map<String, Object> getQueCourseList() {
		User u = getUserInfo();
		if(u.getcIDs()==null){
			if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
	        	u.setcIDs(userService.findAllCids());
	        }else{ //其他角色，查询有浏览课程权限的所有课程
	        	u.setcIDs(userService.findCids(u.getId()));
	        }
		}
		Set<String> cIDs = u.getcIDs();
		if(wj_cid!=null && !"".equals(wj_cid)){
			cIDs.add(wj_cid);
		}
		
		Map param = new HashMap();
		PageUtils pu = getPageUtil();
		param.put("order", pu.getOrder());
		param.put("sort", pu.getSort());

		param.put("owner", getPara("owner")); //使用者，课程列表/试题/组卷
		setMapParamSafe(param,"cname");//课程名
		param.put("unitid", getPara("unitid"));		//单位ID	
		param.put("depid", getPara("depid"));		//科室ID	
		param.put("arrangeid", getPara("arrangeid")); //层次id
		param.put("uid", u.getId());
		param.put("condition", 1); //是否模糊查询
		param.put("begindate", String.valueOf(getPara("beginDate")));
		param.put("enddate", String.valueOf(getPara("endDate")));
		param.put("bdate", String.valueOf(getPara("bdate")));
		param.put("edate", String.valueOf(getPara("edate")));
		Map<String, Object> res = new HashMap<String, Object>();
		param.put("cIDs", cIDs.toArray(new String[] {}));
		List<String> cidstrList=getCidStrList(cIDs);
		param.put("cidstr", cidstrList);
		res.put("rows", courseService.getQueCourse(param, pu));
		res.put("total", Integer.parseInt(courseService.getCourseCount(param)));
		return res;
	}
	
	/**
	 * 获取被删除的课程列表，使用者：【题库管理端】课程列表、暂时被删除的试题
	 * @author
	 * @param
	 * @return Map<String, Object>
	 */
	@RequestMapping("/getDelCourseList")
	public @ResponseBody Map<String, Object> getDelCourseList() {
		User u = getUserInfo();
		Set<String> cIDs = new HashSet<String>();
		if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
			cIDs=userService.findAllDelCids();
        }else{ //其他角色，查询有浏览课程权限的所有课程
        	cIDs=userService.findDelCids(u.getId());
        }
		if(wj_cid!=null && !"".equals(wj_cid)){
			cIDs.add(wj_cid);
		}
		PageUtils pu = getPageUtil();
		Map param = new HashMap();
		param.put("owner", getPara("owner")); //使用者，课程列表/试题/组卷
		param.put("cname", getPara("cname"));	//课程名
		param.put("unitid", getPara("unitid"));		//单位ID
		param.put("arrangeid", getPara("arrangeid")); //层次id
		param.put("uid", u.getId());
		Map<String, Object> res = new HashMap<String, Object>();
		param.put("cIDs", cIDs.toArray(new String[] {}));
		List<String> cidstrList=getCidStrList(cIDs);
		param.put("cidstr", cidstrList);
		res.put("rows", courseService.getDelCourse(param, pu));
		res.put("total", Integer.parseInt(courseService.getDelCourseCount(param)));
		return res;
	}

	// 编辑课程信息
	@RequestMapping("/editCourse")
	public String editCourse() {
		User user = getUserInfo();
		if(user==null){
			return "jsp/notTheRole";
		}
		String c_id = getPara("c_id");
		List<Map<String, Object>> courseAttr = courseService.getEditCourseAttr(c_id);	//课程参数
		Map<String, Object> res = courseAttr.get(0);
		if(!getSubject().hasRole("administrator")){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("cid", c_id);
			map.put("permission", "course:update");
			if(!user.getId().equals(res.get("creatorid")) && courseService.checkCoursePermission(map,user.getId()+"_"+c_id)!=1) {
				return "0";
			}
		}
		
		List<Map<String, Object>> arrangementList = (List<Map<String, Object>>) res.get("arrangementList");	//课程适应层次列表
		ArrayList<Map<String, Object>> al=(ArrayList<Map<String, Object>>) commonService.defaultArrangement();
		for(int i=0; i<al.size(); i++){		//课程适应层次与系统适应层次对比，加入没选中的选项
			if(!arrangementList.contains(al.get(i))){ 
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("use", 0);
				map.put("ID", al.get(i).get("ID"));
				map.put("NAME", al.get(i).get("NAME"));
				arrangementList.add(map);
			}
		}
		res.put("arrangementList", arrangementList);
		getRequest().getSession().setAttribute("arrangementList", arrangementList);
		
		List<Map<String, Object>> questionTypeList = (List<Map<String, Object>>) res.get("questionTypeList");	//课程题型列表
		List<Map<String,Object>> qtl_exists= new ArrayList<>();
		List<Map<String,Object>> qtl_nonexists= new ArrayList<>();
		for(Map<String, Object> mm:questionTypeList){
			if("1".equals(String.valueOf(mm.get("STATE")))){
				mm.put("use", 0);
				qtl_nonexists.add(mm);
			}else{
				qtl_exists.add(mm);
			}
		}
		ArrayList<Map<String, Object>> qtl;
		if(c_id.equals(wj_cid)){
			//将问卷调查的所有题型查询出来
			qtl=(ArrayList<Map<String, Object>>) courseService.getWjQuestiontype();
		}else{
			qtl=(ArrayList<Map<String, Object>>) commonService.defaultQuestionType();
		}
		
		boolean flag = true; //两数组对比id，有相同ID默认为true
		for(int i=0; i<qtl.size(); i++){	//课程题型与系统题型对比，加入没选中的选项
			for(int j=0; j<questionTypeList.size(); j++) {
				if (questionTypeList.get(j).get("ID").equals(qtl.get(i).get("ID"))) {
					flag = true;
					break;//证明有相同ID，不加入questionTypeList
				}else {
					flag = false;
				}
			}
			if(flag==false){
				Map<String,Object> map = new HashMap<>();
				map.putAll(qtl.get(i));
				map.put("use", 0);
				//map.put("ISDEFAULT", qtl.get(i).get("ISDEFAULT"));
				qtl_exists.add(map);
			}
		}
		for(Map<String, Object> mm:qtl_nonexists){
			qtl_exists.add(mm);
		}
		res.put("questionTypeList", qtl_exists);
		getRequest().getSession().setAttribute("questionTypeList", qtl_exists);
		
		List<Map<String, Object>> examTypeList = (List<Map<String, Object>>) res.get("examTypeList");	//课程考试类型列表
		ArrayList<Map<String, Object>> etl =(ArrayList<Map<String, Object>>) commonService.defaultExamType();
		for(int i=0; i<etl.size(); i++){	//课程考试类型与系统考试类型对比，加入没选中的选项
			if(!examTypeList.contains(etl.get(i))){
				Map<String,Object> map = new HashMap<>();
				map.put("use", 0);
				map.put("ID", etl.get(i).get("ID"));
				map.put("NAME", etl.get(i).get("NAME"));
				examTypeList.add(map);
			}
		}
		res.put("examTypeList", examTypeList);
		getRequest().getSession().setAttribute("examTypeList", examTypeList);
		
		List<Map<String, Object>> specialtyListRs = new ArrayList<>();
		List<Map<String, Object>> specialtyList = (List<Map<String, Object>>) res.get("specialtyList");	//课程专业列表
		ArrayList<Map<String, Object>> ssl=(ArrayList<Map<String, Object>>) commonService.defaultSpecialty();
		for(int i=0;i<specialtyList.size();i++){
			boolean b = false;
			for(int j=0;j<ssl.size();j++){
				if (ssl.get(j).get("ID").equals(specialtyList.get(i).get("ID"))) {
					specialtyListRs.add(ssl.get(j));
					ssl.remove(j);
					b = true;
					break;
				}
			}
			if (!b) {
				specialtyListRs.add(specialtyList.get(i));
			}
		}
		for(int i=0;i<ssl.size();i++){
			ssl.get(i).put("use",0);
			specialtyListRs.add(ssl.get(i));
		}
		res.put("specialtyList", specialtyListRs);
		getRequest().getSession().setAttribute("specialtyList", specialtyListRs);
		
		List<Map<String, Object>> difficultyList = (List<Map<String, Object>>) res.get("difficultyList");	//课程难度列表
		ArrayList<Map<String, Object>> dl = (ArrayList<Map<String, Object>>) commonService.defaultDifficulty();
		for(int i=0; i<dl.size(); i++){	//课程难度与系统难度对比，加入没选中的选项
			if(!difficultyList.contains(dl.get(i))){
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("use", 0);
				map.put("ID", dl.get(i).get("ID"));
				map.put("NAME", dl.get(i).get("NAME"));
				difficultyList.add(map);
			}
		}
		res.put("difficultyList", difficultyList);
		getRequest().getSession().setAttribute("difficultyList", difficultyList);
		
		List<Map<String, Object>> knowledgeList = (List<Map<String, Object>>) res.get("knowledgeList");	//课程知识点列表
		ArrayList<Map<String, Object>> kl =(ArrayList<Map<String, Object>>) commonService.defaultKnowledge();
		for(int i=0; i<kl.size(); i++){	//课程知识点与系统知识点对比，加入没选中的选项
			if(!knowledgeList.contains(kl.get(i))){
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("use", 0);
				map.put("ID", kl.get(i).get("ID"));
				map.put("NAME", kl.get(i).get("NAME"));
				knowledgeList.add(map);
			}
		}
		res.put("knowledgeList", knowledgeList);
		getRequest().getSession().setAttribute("knowledgeList", knowledgeList);
		
		List<Map<String, Object>> cognitionList = (List<Map<String, Object>>) res.get("cognitionList");	//课程认知列表
		ArrayList<Map<String, Object>> cl =(ArrayList<Map<String, Object>>) commonService.defaultCognition();
		for(int i=0; i<cl.size(); i++){	//课程认知与系统认知对比，加入没选中的选项
			if(!cognitionList.contains(cl.get(i))){
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("use", 0);
				map.put("ID", cl.get(i).get("ID"));
				map.put("NAME", cl.get(i).get("NAME"));
				cognitionList.add(map);
			}
		}
		res.put("cognitionList", cognitionList);
		getRequest().getSession().setAttribute("cognitionList", cognitionList);
		
		List<Map<String, Object>> sourceList = (List<Map<String, Object>>) res.get("sourceList");	//课程题源列表
//		ArrayList<Map<String, Object>> sl = (ArrayList<Map<String, Object>>)Utils.deepCloneListMap((ArrayList<Map<String, Object>>) getApplication().getAttribute("sourceList"));
		ArrayList<Map<String, Object>> sl =(ArrayList<Map<String, Object>>) commonService.defaultSource();
		for(int i=0; i<sl.size(); i++){	//课程题源与系统题源对比，加入没选中的选项
			if(!sourceList.contains(sl.get(i))){
				Map<String,Object> map = new HashMap<String,Object>();
				map.put("use", 0);
				map.put("ID", sl.get(i).get("ID"));
				map.put("NAME", sl.get(i).get("NAME"));
				sourceList.add(map);
			}
		}
		res.put("sourceList", sourceList);
		getRequest().getSession().setAttribute("sourceList", sourceList);

		getRequest().setAttribute("c_id", c_id);
		getRequest().setAttribute("courseInfo", courseAttr);
		return "jsp/course/editCourse";
	}

	// 进入添加课程
	// 黎青华修改，把用户信息查出，自动填写到联系人与联系人电话
	// 把默认值存到session
	@RequestMapping("/toAddCourse")
	public String toAddCourse() {
		if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = 0;
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("pid", "14");
			rtn = courseService.checkCoursePermissionWithPID(map,getUserID()+"_p14");			
			if(rtn==0){
				return "jsp/notTheRole"; 
			}
		}
		User user = userService.findOne(getUserID());
		String c_id = courseService.getCourseID();
		getRequest().setAttribute("c_id", c_id);
		getRequest().setAttribute("contact", user.getRealname());
		getRequest().setAttribute("tel", user.getTel());
		getRequest().setAttribute("unitid", user.getUnitID());
		
		List<Map<String, Object>> questiontype=commonService.defaultQuestionType();
		getRequest().getSession().setAttribute("questionTypeList", questiontype);
		
		List<Map<String, Object>> arrangementList=commonService.defaultArrangement();
		getRequest().getSession().setAttribute("arrangementList", arrangementList);
		
		List<Map<String, Object>> examTypeList=commonService.defaultExamType();
		getRequest().getSession().setAttribute("examTypeList", examTypeList);
		
		List<Map<String, Object>> specialtyList=commonService.defaultSpecialty();
		getRequest().getSession().setAttribute("specialtyList", specialtyList);
		
		List<Map<String, Object>> difficultyList=commonService.defaultDifficulty();
		getRequest().getSession().setAttribute("difficultyList", difficultyList);
		
		List<Map<String, Object>> knowledgeList=commonService.defaultKnowledge();
		getRequest().getSession().setAttribute("knowledgeList", knowledgeList);
		
		List<Map<String, Object>> cognitionList=commonService.defaultCognition();
		getRequest().getSession().setAttribute("cognitionList", cognitionList);
		
		List<Map<String, Object>> sourceList=commonService.defaultSource();
		getRequest().getSession().setAttribute("sourceList", sourceList);
		
		return "jsp/course/addCourse";
	}

	/**
	 * 点击添加题型时添加问题类型到questiontype表
	 * @author 黎青华
	 * @return id
	 */
	@RequestMapping("/addQuestionType")
	public @ResponseBody String addQuestionType() {
		List<Map<String, Object>> param =(List<Map<String, Object>>) 
				getRequest().getSession().getAttribute("questionTypeList");
		
		String name = getRequest().getParameter("qt_name").trim();
		for(int i=0;i<param.size();i++){
			if(name.equals(param.get(i).get("NAME"))){
				return "-1";
			}
		}
		String e_qtname = "";
		if(getRequest().getParameter("e_qt_name")!=null){
			e_qtname=getRequest().getParameter("e_qt_name").trim();
		}
		String id = courseService.getQuestionTypeId().get(0).get("ID")+"";
		
		Integer iscon = Integer.parseInt(getRequest().getParameter("qt_iscon"));
		String answertypeid = getRequest().getParameter("qt_answertypeid");
		String desc = getRequest().getParameter("qt_desc");
		String e_qtdesc = getRequest().getParameter("e_qt_desc");
		int sxb=0;
		if(getPara("qt_sxb")!=null&&!"".equals(getPara("qt_sxb"))){
			sxb=Integer.parseInt(getPara("qt_sxb"));
		}
		Map<String, Object> map = new HashMap<>();
		map.put("ID", id);
		map.put("NAME", name);
		map.put("E_QTNAME",e_qtname);
		map.put("QDESC", desc);
		map.put("E_QTDESC", e_qtdesc);
		map.put("ANSWERTYPEID", answertypeid);
		map.put("ISCON", iscon);
		map.put("ISDEFAULT", 2);
		map.put("SXB", sxb);
		map.put("XXDF", Utils.changeObjToInt(getPara("qt_xxdf")));
		map.put("MEDIASET", Utils.changeObjToInt(getPara("qt_mediaSet")));
		param.add(map);
		getRequest().getSession().removeAttribute("questionTypeList");
		getRequest().getSession().setAttribute("questionTypeList", param);
		return id;
	}
	
	/*// 添加题型，返回题型ID
	@RequestMapping("/addQuestionType")
	public @ResponseBody String addQuestionType() {		
		String qt_name = getPara("qt_name");
		if(StringUtils.isBlank(qt_name)){
			return null;
		}else{
			Map param = new HashMap();		
			param.put("name", qt_name);
			param.put("iscon", getPara("qt_iscon"));
			param.put("answertypeid", getPara("qt_answertypeid"));
			param.put("desc", getPara("qt_desc"));
			courseService.insertQuestionType(param);
			return param.get("id") + "";
		}	
	}*/
	
	// 更新课程，参数参考课程数据库字段
	// 黎青华改动，从session中获取数据，然后与已选中的多选框做对比
	@RequestMapping("/updateCourse")
	public @ResponseBody String updateCourse() {
		String cid = getPara("c_id");
		if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = 0;
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("cid", cid);
			map.put("permission", "course:update");
			rtn = courseService.checkCoursePermission(map,getUserID()+"_"+cid);	
			if(rtn==0){
				return "jsp/notTheRole";
			}
		}
		
		Map course = new HashMap();
		String name_e = Utils.getNotEmptyVal(getPara("name_e"));
		String name_c = Utils.getNotEmptyVal(getPara("name_c1")).toString().trim();
		if(Utils.nullOrEmpty(name_c.trim())) {
			return "-3";
		}
		Map param = new HashMap();
		param.put("thiscid",cid);
		param.put("val", name_c);
		if (Integer.parseInt(courseService.getCount(param)) > 0) {
			return "-1";
		}
		String shortname = Utils.getNotEmptyVal(getPara("shortname"));
		String code = Utils.getNotEmptyVal(getPara("code"));
		String unitId = Utils.getNotEmptyVal(getPara("unitId"));
		String deptId = Utils.getNotEmptyVal(getPara("deptId"));
		String contact = Utils.getNotEmptyVal(getPara("contact"));
		String tel = Utils.getNotEmptyVal(getPara("tel"));
		String period = Utils.getNotEmptyVal(getPara("period"));
		String open = Utils.getNotEmptyVal(getPara("open"));
		String[] arrangement = getRequest().getParameterValues("arrangement");
		String[] questionType = getRequest().getParameterValues("questionType");
		String[] examType = getRequest().getParameterValues("examType");
		String[] specialty = getRequest().getParameterValues("specialty");
		String[] difficulty = getRequest().getParameterValues("difficulty");
		String[] knowledge = getRequest().getParameterValues("knowledge");
		String[] cognition = getRequest().getParameterValues("cognition");
		String[] source = getRequest().getParameterValues("source");
		
		//当各参数列表其中一个没选参数，则更新失败
		if (Utils.nullOrEmpty(arrangement) || Utils.nullOrEmpty(questionType) || Utils.nullOrEmpty(examType)
				|| Utils.nullOrEmpty(specialty) || Utils.nullOrEmpty(difficulty) || Utils.nullOrEmpty(knowledge)
				|| Utils.nullOrEmpty(cognition) || Utils.nullOrEmpty(source)) {
			return "-2";
		}
		
		List<Map<String, Object>> alist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> al = (List<Map<String, Object>>) getRequest().getSession().getAttribute("arrangementList");
		for(int i=0;i<al.size();i++) {
			for(int j=0;j<arrangement.length;j++) {
				if (arrangement[j].equals(al.get(i).get("ID"))) {
					alist.add(al.get(i));
				}
			}
		}		
		
		List<Map<String, Object>> qtlist = new ArrayList<>();
		List<Map<String, Object>> qlist = (List<Map<String, Object>>)getRequest().getSession().getAttribute("questionTypeList");
		
		try{
			for(int i=0;i<questionType.length;i++){
				for(int j=0;j<qlist.size();j++){
					Map<String,Object> qm=qlist.get(j);
					String qtid=String.valueOf(qm.get("ID"));
					if (questionType[i].equals(qtid)){
						qtlist.add(qm);
						break;
					}
				}
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
		
		List<Map<String, Object>> elist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> el = (List<Map<String, Object>>) getRequest().getSession().getAttribute("examTypeList");
		for(int i=0;i<el.size();i++) {
			for(int j=0;j<examType.length;j++) {
				if (examType[j].equals(el.get(i).get("ID"))) {
					elist.add(el.get(i));
				}
			}
		}
		
		List<Map<String, Object>> splist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> spl = (List<Map<String, Object>>) getRequest().getSession().getAttribute("specialtyList");
		for(int i=0;i<spl.size();i++) {
			for(int j=0;j<specialty.length;j++) {
				if (specialty[j].equals(spl.get(i).get("ID"))) {
					splist.add(spl.get(i));
				}
			}
		}
		
		List<Map<String, Object>> dlist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> dl = (List<Map<String, Object>>) getRequest().getSession().getAttribute("difficultyList");
		for(int i=0;i<dl.size();i++) {
			for(int j=0;j<difficulty.length;j++) {
				if (difficulty[j].equals(dl.get(i).get("ID"))) {
					dlist.add(dl.get(i));
				}
			}
		}
		
		List<Map<String, Object>> klist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> kl = (List<Map<String, Object>>) getRequest().getSession().getAttribute("knowledgeList");
		for(int i=0;i<kl.size();i++) {
			for(int j=0;j<knowledge.length;j++) {
				if (knowledge[j].equals(kl.get(i).get("ID"))) {
					klist.add(kl.get(i));
				}
			}
		}
		
		List<Map<String, Object>> clist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> cl = (List<Map<String, Object>>) getRequest().getSession().getAttribute("cognitionList");
		for(int i=0;i<cl.size();i++) {
			for(int j=0;j<cognition.length;j++) {
				if (cognition[j].equals(cl.get(i).get("ID"))) {
					clist.add(cl.get(i));
				}
			}
		}
		
		List<Map<String, Object>> slist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> sl = (List<Map<String, Object>>) getRequest().getSession().getAttribute("sourceList");
		for(int i=0;i<sl.size();i++) {
			for(int j=0;j<source.length;j++) {
				if (source[j].equals(sl.get(i).get("ID"))) {
					slist.add(sl.get(i));
				}
			}
		}
		
		course.put("id", cid);
		course.put("name_e", name_e);
		course.put("name_c", name_c);
		course.put("shortname", shortname);
		course.put("code", code);
		course.put("unitId", unitId);
		course.put("deptId", deptId);
		course.put("contact", contact);
		course.put("tel", tel);
		course.put("period", period);
		course.put("open", open);
		course.put("arrangement", alist);
		course.put("questionType", qtlist);
		course.put("examType", elist);
		course.put("specialty", splist);
		course.put("difficulty", dlist);
		course.put("knowledge", klist);
		course.put("cognition", clist);
		course.put("source", slist);
		course.put("updatorid", getUserID());
		course.put("updatime",new Date());		
		Map log = new HashMap();
		log.put("content", "编辑课程《"+name_c+"》，课程序号为："+cid);
		log.put("cid", cid);
		systemService.addSysLog(log);
		
		try{
			courseService.updateCourse(course);
		}catch(Exception e){
			e.printStackTrace();
			return "0";	
		}
		return "4";					
	}

	// 删除课程
	@RequestMapping("/delCourse")
	public @ResponseBody String delCourse(){
		String cid = getPara("c_id");
		courseService.deleteCourse(cid);
		
		return null;
	}
	
	// 删除所选课程
	@RequestMapping("/delSelect")
	public @ResponseBody String delSelect(){
		String[] cids = getParaValues("cids");
		if(cids==null || cids.length == 0){
			return null;
		}else{
			for(String cid:cids){
				if(!getSubject().hasRole("administrator")){
					//getSubject().checkPermission("course:del:" + cid);	//检查用户删除课程权限
					Map map = new HashMap();
					map.put("uid", getUserID());
					map.put("cid", cid);
					map.put("permission", "course:del");
					if(courseService.checkCoursePermission(map,getUserID()+"_"+cid)==0){
						continue;
					}
				}				
				courseService.deleteCourse(cid);				
			}
			return null;
		}		
	}
	
	// 添加适应层次，返回ID
	@RequestMapping("/addArrangement")
	public @ResponseBody String addArrangement() {
		String arrangement = getPara("arrangement").trim();
		if(StringUtils.isBlank(arrangement)){
			return null;
		}else{
			String aid = courseService.getArrangementId().get(0).get("ID")+"";
			List<Map<String, Object>> list = (List<Map<String, Object>>)
					getRequest().getSession().getAttribute("arrangementList");
			Map m = new HashMap();
			m.put("NAME", arrangement);
			m.put("ID", aid);
			m.put("ISDEFAULT", 0);
			list.add(m);
			//getRequest().getSession().removeAttribute("arrangementList");
			//getRequest().getSession().setAttribute("arrangementList", list);
			return aid;
		}
	}
	
	// 添加考试类别，返回ID
	@RequestMapping("/addExamType")
	public @ResponseBody String addExamType() {
		String examType = getPara("examType").trim();
		if(StringUtils.isBlank(examType)){
			return null;
		}else{
			String eid = courseService.getExamTypeId().get(0).get("ID")+"";
			List<Map<String, Object>> list = (List<Map<String, Object>>)getRequest().getSession().getAttribute("examTypeList");
			Map m = new HashMap();
			m.put("NAME", examType);
			m.put("ID", eid);
			m.put("ISDEFAULT", 0);
			list.add(m);
			//getRequest().getSession().removeAttribute("examTypeList");
			//getRequest().getSession().setAttribute("examTypeList", list);
			return eid;
		}
	}	
	
	// 添加难度，返回ID
	@RequestMapping("/addDifficulty")
	public @ResponseBody String addDifficulty() {
		String difficulty = getPara("difficulty").trim();
		if(StringUtils.isBlank(difficulty)){
			return null;
		}else{
			String did = courseService.getDifficultyId().get(0).get("ID")+"";
			List<Map<String, Object>> list = (List<Map<String, Object>>) 
					getRequest().getSession().getAttribute("difficultyList");
			Map m = new HashMap();
			m.put("NAME", difficulty);
			m.put("ID", did);
			m.put("ISDEFAULT", 0);
			list.add(m);
			//getRequest().getSession().removeAttribute("difficultyList");
			//getRequest().getSession().setAttribute("difficultyList", list);
			return did;
		}		
	}

	// 添加知识点，返回ID
	@RequestMapping("/addKnowledge")
	public @ResponseBody String addKnowledge() {
		String knowledge = getPara("knowledge").trim();
		if(StringUtils.isBlank(knowledge)){
			return null;
		}else{
			String kid = courseService.getKnowlegeId().get(0).get("ID")+"";
			List<Map<String, Object>> list = (List<Map<String, Object>>)
					getRequest().getSession().getAttribute("knowledgeList");
			Map m = new HashMap();
			m.put("NAME", knowledge);
			m.put("ID", kid);
			m.put("ISDEFAULT", 0);
			list.add(m);
			//getRequest().getSession().removeAttribute("knowledgeList");
			//getRequest().getSession().setAttribute("knowledgeList", list);
			return kid;
		}
		
	}
	
	// 添加认知，返回ID
	@RequestMapping("/addCognition")
	public @ResponseBody String addCognition() {
		String cognition = getPara("cognition").trim();
		if(StringUtils.isBlank(cognition)){
			return null;
		}else{
			String id = courseService.getCognitionId().get(0).get("ID")+"";
			List<Map<String, Object>> list = (List<Map<String, Object>>)
					getRequest().getSession().getAttribute("cognitionList");
			Map m = new HashMap();
			m.put("NAME", cognition);
			m.put("ID", id);
			m.put("ISDEFAULT", 0);
			list.add(m);
			//getRequest().getSession().removeAttribute("cognitionList");
			//getRequest().getSession().setAttribute("cognitionList", list);
			return id;
		}		
	}
	
	// 添加题源，返回ID
	@RequestMapping("/addSource")
	public @ResponseBody String addSource() {
		String source = getPara("source").trim();
		if(StringUtils.isBlank(source)){
			return null;
		}else{
			String id = courseService.getSourceId().get(0).get("ID")+"";
			List<Map<String, Object>> list = (List<Map<String, Object>>) 
					getRequest().getSession().getAttribute("sourceList");
			Map m = new HashMap();
			m.put("NAME", source);
			m.put("ID", id);
			m.put("ISDEFAULT", 0);
			list.add(m);
			//getRequest().getSession().removeAttribute("sourceList");
			//getRequest().getSession().setAttribute("sourceList", list);
			return id;
		}		
	}	

	//题型说明
	//黎青华改动
	//获取addCourse中选中的题型，并传入session
	@RequestMapping("/explainQuestionType")
	public String explainQuestionType() {
//		String[] qids = getPara("qid").split(",");
//		getRequest().getSession().setAttribute("qids", qids);
		getRequest().setAttribute("cid", getPara("cid"));
//		if (getPara("q_type")!=null || "".equals(getPara("q_type"))) {
//			getRequest().setAttribute("q_type", getPara("q_type"));
//		}
		return "jsp/course/explainQuestionType";
	}

	// 获取题型说明
	// 黎青华改动
	// 从session中获取全部题型和选中题型,遍历出选中题型的详细信息
	@RequestMapping(value = "/getExplainQuestionType")
	public @ResponseBody List<Map<String, Object>> getExplainQuestionType() {
		String cid=getPara("cid");
		List<Map<String,Object>> list=(List<Map<String, Object>>) getRequest().getSession().getAttribute("questionTypeList");
		//获取该题型下是否有试题
		Map<String,Object> param=new HashMap<String,Object>();
		param.put("cid", cid);
		for(Map<String,Object> map:list){		
			param.put("qtid", map.get("ID"));
			List<Map<String,Object>> qtList=courseService.getQuestionQTGX(param);
			if(qtList!=null&&qtList.size()>0){
				map.put("qcount", qtList.size());
			}else{
				map.put("qcount", 0);
			}
		}
		return list;
	}

	// 获取题型列表
	@RequestMapping("/getQTlist_haveQuestion")
	public @ResponseBody Map<String,Object> getQTlist_haveQuestion() {
		String cid = getPara("cid");
		Map<String,Object> rtn = new HashMap<>();
		if(!"administrator".equals(getUserInfo().getRole())){
			Map param = new HashMap();
			param.put("uid", getUserInfo().getId());
			param.put("cid", cid);
			param.put("permission", "question:update");
			
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0){
				rtn.put("error","notTheRole");
				return rtn; 
			}
		}
		
		
		ArrayList<Map<String,Object>> questionTypeList_HQ = new ArrayList<>(); //有题目的题型
		ArrayList<Map<String,Object>> questionTypeList = (ArrayList)courseService.getCourseQuestionType(cid);//课程全题型
		rtn.put("questionTypeList", questionTypeList);
		getSession().setAttribute("questionTypeList", questionTypeList);
//		getRequest().getSession().setAttribute("questionTypeList", Utils.deepCloneListMap(questionTypeList));
		
		Map<String,Object> param= new HashMap<>();
		param.put("cid", cid);
		for(Map<String,Object> map:questionTypeList){
			param.put("qtid", map.get("QTID"));
			List<Map<String,Object>> qtList=courseService.getQuestionQTGX(param);
			if(qtList!=null && qtList.size()>0){
				questionTypeList_HQ.add(map);
			}
		}
		rtn.put("questionTypeList_HQ", questionTypeList_HQ);
		return rtn;
	}
	
	// 获取题型的类型是否一致
	@RequestMapping("/isSameQT")
	public @ResponseBody int isSameQT() {
		String cid=getPara("cid");
		String newQtid=getPara("new");
		String newAtid="-99";
		String newIscon="-123";
		String originalQtid=getPara("original");
		String originalAtid="-1";
		String originalIscon="-2";
		List<Map<String,Object>> list=(List<Map<String, Object>>) getSession().getAttribute("questionTypeList");
		if(list.size()>0){
			for(Map m:list){
				if(m.get("QTID").equals(originalQtid)){
					originalAtid=m.get("ATID").toString();
					originalIscon=m.get("ISCON").toString();
					break;
				}
			}
			for(Map mm:list){
				if(mm.get("QTID").equals(newQtid)){
					newAtid=mm.get("ATID").toString();
					newIscon=mm.get("ISCON").toString();
					break;
				}
			}
		}
		
		if(newAtid.equals(originalAtid) && newIscon.equals(originalIscon)){
			return 1;
		}
		return 0;
	}
	
	//题型替换
	@RequestMapping("/replaceQT")
	public @ResponseBody int replaceQT() {
		String cid=getPara("cid");
		String newQtid=getPara("new");
		String originalQtid=getPara("original");
		Map m = new HashMap();
		m.put("cid", cid);
		m.put("newQtid", newQtid);
		m.put("originalQtid", originalQtid);
		return courseService.updateCQ_QT(m);
	}
	// 获取所属科室列表
	@RequestMapping(value = "/getDeptList")
	public @ResponseBody List<Map<String, Object>> getDeptList() {
		return commonService.getDeptList(getPara("u_id"));
	}

	/**
	 * 添加课程，包括添加课程与用户的关系，课程与用户（包括上级）的权限关系
	 * @author 洪艳、黎青华
	 * 补充contactId字段
	 * 读取存放题型的session，并与选中的题型id对比，被选中的题型存放到course_questiontype
	 * questiontype表用作读取默认题型
	 * course_questiontype表用作读取和存储某个课程有哪些题型
	 * @return String（-1：课程名重复；-2：参数不符合规则；-3:系统错误；-4：联系人信息与数据库不一致；1：添加成功）
     */
	@RequestMapping("/addCourse")
	public @ResponseBody String addCourse() {
		if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = 0;
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("pid", "14");
			rtn = courseService.checkCoursePermissionWithPID(map,getUserID()+"_p14");			
			if(rtn==0){
				return "jsp/notTheRole"; 
			}
		}
		String cid = getPara("c_id");
		String name_c = Utils.getNotEmptyVal(getPara("name_c"));
		name_c=name_c.trim();
		Map param = new HashMap();
		param.put("val", name_c);
		if(Utils.nullOrEmpty(name_c)) {
			return "-3";
		}
		if (Integer.parseInt(courseService.getCount(param)) > 0) {	//检查该课程是否已经存在或为空
			return "-1";
		}
		Map course = new HashMap();
		String name_e = Utils.getNotEmptyVal(getPara("name_e"));
		String shortname = Utils.getNotEmptyVal(getPara("shortname"));
		String code = Utils.getNotEmptyVal(getPara("code"));
		String unitId = Utils.getNotEmptyVal(getPara("unitId"));
		String deptId = Utils.getNotEmptyVal(getPara("deptId"));
		String contact = Utils.getNotEmptyVal(getPara("contact"));
		String open = Utils.getNotEmptyVal(getPara("open"));
		String contactId = getUserID();
		String tel = Utils.getNotEmptyVal(getPara("tel"));
		String period = Utils.getNotEmptyVal(getPara("period"));
		String[] arrangement = getRequest().getParameterValues("arrangement");
		String[] questionType = getRequest().getParameterValues("questionType");
		String[] examType = getRequest().getParameterValues("examType");
		String[] specialty = getRequest().getParameterValues("specialty");
		String[] difficulty = getRequest().getParameterValues("difficulty");
		String[] knowledge = getRequest().getParameterValues("knowledge");
		String[] cognition = getRequest().getParameterValues("cognition");
		String[] source = getRequest().getParameterValues("source");
		//当各参数列表其中一个没选参数，则添加失败
		if (Utils.nullOrEmpty(arrangement) || Utils.nullOrEmpty(questionType) || Utils.nullOrEmpty(examType)
				|| Utils.nullOrEmpty(specialty) || Utils.nullOrEmpty(difficulty) || Utils.nullOrEmpty(knowledge)
				|| Utils.nullOrEmpty(cognition) || Utils.nullOrEmpty(source)) {
			return "-2";
		}
		
		//对比session中的数据与多选框选择
		//包含题型
		List<Map<String, Object>> qtlist = new ArrayList<>();
		List<Map<String, Object>> qlist = (List<Map<String, Object>>)getRequest().getSession().getAttribute("questionTypeList");
		
		for(int i=0;i<questionType.length;i++){
			for(int j=0;j<qlist.size();j++){
				Map<String,Object> qm=qlist.get(j);
				String qtid=String.valueOf(qm.get("ID"));
				
				if (questionType[i].equals(qtid)){	
					qm.put("QTORDER", i);
					qtlist.add(qm);
					break;
				}
			}
		}
		
		//适应层次
		List<Map<String, Object>> arrlist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> alist = (List<Map<String, Object>>)
				getRequest().getSession().getAttribute("arrangementList");
		for(int i=0;i<alist.size();i++) {
			for(int j=0;j<arrangement.length;j++) {
				if (arrangement[j].equals(alist.get(i).get("ID"))) {
					arrlist.add(alist.get(i));
				}
			}
		}
		
		//考试类别
		List<Map<String, Object>> etlist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> elist = (List<Map<String, Object>>)
				getRequest().getSession().getAttribute("examTypeList");
		for(int i=0;i<elist.size();i++) {
			for(int j=0;j<examType.length;j++) {
				if (examType[j].equals(elist.get(i).get("ID"))) {
					etlist.add(elist.get(i));
				}
			}
		}
		
		//适用专业
		List<Map<String, Object>> splist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> slist = (List<Map<String, Object>>) 
				getRequest().getSession().getAttribute("specialtyList");
		for(int i=0;i<slist.size();i++) {
			for(int j=0;j<specialty.length;j++) {
				if (specialty[j].equals(slist.get(i).get("ID"))) {
					splist.add(slist.get(i));
				}
			}
		}
		
		//难度
		List<Map<String, Object>> dflist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> dlist = (List<Map<String, Object>>)
				getRequest().getSession().getAttribute("difficultyList");
		for(int i=0;i<dlist.size();i++) {
			for(int j=0;j<difficulty.length;j++) {
				if (difficulty[j].equals(dlist.get(i).get("ID"))) {
					dflist.add(dlist.get(i));
				}
			}
		}
		
		//知识点分布
		List<Map<String, Object>> kllist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> klist = (List<Map<String, Object>>) 
				getRequest().getSession().getAttribute("knowledgeList");
		for(int i=0;i<klist.size();i++) {
			for(int j=0;j<knowledge.length;j++) {
				if (knowledge[j].equals(klist.get(i).get("ID"))) {
					kllist.add(klist.get(i));
				}
			}
		}
		
		//认知类别
		List<Map<String, Object>> ctList = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> clist = (List<Map<String, Object>>)
				getRequest().getSession().getAttribute("cognitionList");
		for(int i=0;i<clist.size();i++) {
			for(int j=0;j<cognition.length;j++) {
				if (cognition[j].equals(clist.get(i).get("ID"))) {
					ctList.add(clist.get(i));
				}
			}
		}
		
		//题源
		List<Map<String, Object>> sclist = new ArrayList<Map<String, Object>>();
		List<Map<String, Object>> list = (List<Map<String, Object>>) 
				getRequest().getSession().getAttribute("sourceList");
		for(int i=0;i<list.size();i++) {
			for(int j=0;j<source.length;j++) {
				if (source[j].equals(list.get(i).get("ID"))) {
					sclist.add(list.get(i));
				}
			}
		}

		course.put("id", cid);
		course.put("name_c", name_c);
		course.put("name_e", name_e);
		course.put("shortname", shortname);
		course.put("code", code);
		course.put("unitId", unitId);
		course.put("deptId", deptId);
		course.put("contact", contact);
		course.put("contactid", contactId);
		course.put("open", open);
		course.put("tel", tel);
		course.put("period", period);
		course.put("arrangement", arrlist);
		course.put("questionType", qtlist);
		course.put("examType", etlist);
		course.put("specialty", splist);
		course.put("difficulty", dflist);
		course.put("knowledge", kllist);
		course.put("cognition", ctList);
		course.put("source", sclist);
		course.put("creator", getUsername());
		course.put("creatorid", getUserID());
		course.put("creattime", new Date());
		int rtn = courseService.insertCourse(course);
		if(rtn==1){
			User u = getUserInfo();
			Set<String> cids = u.getcIDs();
			if(cids==null){
				cids = new HashSet<String>();
			}
			cids.add(cid);
			u.setcIDs(cids);
			getSession().setAttribute("userInfo", u);
			
			Map log = new HashMap();
			log.put("content", "新建课程《"+name_c+"》，课程序号为："+cid);
			log.put("cid", cid);
			systemService.addSysLog(log);
		}
		return rtn+"";
	}

	// 获取主题词列表
	@RequestMapping("/getThemeList")
	public @ResponseBody List<Map<String, Object>> getThemeList() {
		Map param = new HashMap();
		param.put("th_level", getPara("th_level"));
		param.put("th_pid", getPara("th_pid"));
		param.put("id", getPara("c_id"));
		return courseService.getThemeList(param);
	}

	@RequestMapping("/getCourseQuestionAIModuleInfo")
	public @ResponseBody Map<String, Object> getCourseQuestionAIModuleInfo() {
		Map<String,Object> rtn = new HashMap<>();
		String cid = getPara("cid");
		rtn.put("themeTree", courseService.getThemeTree(cid, -1L));
		rtn.put("courseQuestionType", courseService.getCourseQuestionType(cid));
		return rtn;
	}

	// 添加主题词
	@RequestMapping("/addTheme")
	public @ResponseBody String addTheme() {
		String th_cid = getPara("c_id");
		if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = 0;
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("pid", "14");
			rtn = courseService.checkCoursePermissionWithPID(map,getUserID()+"_p14");			
			if(rtn==0){
				map.put("cid", th_cid);
				map.put("permission", "course:update");
				rtn = courseService.checkCoursePermission(map,getUserID()+"_"+th_cid);
				if(rtn==0){
					return "jsp/notTheRole";
				}
			}
		}
		String[] th_name = getPara("th_name").split(",");
		String th_pid = getPara("th_pid");
		String th_level = getPara("th_level");
		Map param = new HashMap();
		param.put("th_names", th_name);
		param.put("th_cid", th_cid);
		param.put("th_pid", th_pid);
		param.put("th_level", th_level);
		
		String rtn=courseService.insertTheme(param)+"";
		
		String flag=getPara("flag");
		if("edit".equals(flag)) {
			String name_c = courseService.getCourseCNameByCid(th_cid);
			Map log = new HashMap();
			log.put("content", "课程《"+name_c+"》新增主题词：“"+getPara("th_name")+"”,课程编号为："+th_cid);
			log.put("cid", th_cid);
			systemService.addSysLog(log);
		}
		return rtn;
	}

	// 删除主题词
	@RequestMapping("/delTheme")
	public @ResponseBody int delTheme() {
		String thVal=getPara("th_id");
		int rtn=0;
		if(thVal!=null&&!"".equals(thVal)){
			String[] tids=thVal.split(",");
			for(String tid:tids){
				rtn=rtn+courseService.deleteTheme(tid);
			}
		}
		
		String flag=getPara("flag");
		if("edit".equals(flag)) {
			String cid=getPara("c_id");
			String name_c = courseService.getCourseCNameByCid(cid);
			Map log = new HashMap();
			log.put("content", "课程《"+name_c+"》删除主题词：“"+getPara("thText")+"”,课程编号为："+cid);
			log.put("cid", cid);
			systemService.addSysLog(log);
		}
		return rtn;
	}

	@RequestMapping("/checkThemeHasQuestion")
	public @ResponseBody boolean checkThemeHasQuestion() {
		String thid = getPara("thid");
		String cid = getPara("cid");
		Map<String,Object> searchMap = new HashMap<>();
		searchMap.put("cid", cid);
		if("-1".equals(thid)){
			Map param = new HashMap();
			param.put("th_level", 1);
			param.put("th_pid", thid);
			param.put("id", cid);
			List<Map<String,Object>> firstLevelThemeList = courseService.getThemeList(param);
			for(Map<String,Object> firstLevelTheme : firstLevelThemeList){
				searchMap.put("thid", String.valueOf(firstLevelTheme.get("ID")));
				searchMap.put("tlevel", Integer.parseInt(String.valueOf(firstLevelTheme.get("TLEVEL"))));
				if(courseService.isThemeInQuestionOrExampaper(searchMap)){
					return true;
				}
			}
			return false;
		}

		searchMap.put("thid", thid);
		searchMap.put("tlevel", Utils.changeObjToInt(getPara("tlevel"),1));
		return courseService.isThemeInQuestionOrExampaper(searchMap);
	}

	// 更新主题词
	@RequestMapping("/updateTheme")
	public @ResponseBody String updateTheme() {
		Map theme = new HashMap();
		theme.put("th_id", getPara("th_id"));
		theme.put("th_name", getPara("th_name"));
		return courseService.updateTheme(theme) + "";
	}

	// 导入主题词
	@RequestMapping("/importTheme")
	public @ResponseBody Map importTheme(@RequestParam(value="file") MultipartFile mFile) {
		String cid = getPara("cid");
		User user = getUserInfo();
		if(user==null){
			return null;
		}
		List<Map<String,Object>> res = courseService.getCourseAttr(cid);
		if(res!=null && !res.isEmpty()){ //非纯新课程
			Map<String,Object> courseAttr = courseService.getCourseAttr(cid).get(0);
			if(!getSubject().hasRole("administrator") && !user.getId().equals(courseAttr.get("creatorid"))) {
				Map map = new HashMap();
				map.put("uid", getUserID());
				map.put("pid", "14");
				int rtn = courseService.checkCoursePermissionWithPID(map,getUserID()+"_p14");
				if(rtn==0){
					map.put("cid", cid);
					map.put("permission", "course:update");
					rtn = courseService.checkCoursePermission(map,getUserID()+"_"+cid);
					if(rtn==0){
						return null;
					}
				}
			}
		}
		Map<String,Object> rtn = poiService.importTheme(mFile, cid);
		return rtn;
	}
	
	/**
	 * 导入主题词模版
	 * @author 黎青华
	 * @return
	 * @throws IOException 
	 * @throws UnsupportedEncodingException 
	 */
	@RequestMapping("/importThemeMonel")
	public ResponseEntity<Resource> importThemeMonel() {
		return FileDownloadUtils.download(WebFilePath.getProjectPath()+"mb/themesmd.xls");
	}

	// 根据课程id获取课程专业
	@RequestMapping("/getSpecialtyList")
	public @ResponseBody List<Map<String, Object>> getSpecialtyList() {
		return commonService.defaultSpecialty();
	}
	
	/**
	 * 获取答案分类
	 * @author 黎青华
	 * @return 返回一个json
	 */
	@RequestMapping("/getAnswerType")
	public @ResponseBody List<Map<String, Object>> getAnswerType(){
		return commonService.getAnswerTypeList();
	}
	
	/**
	 * 获取题目类型id
	 * @author 黎青华
	 * 没用的方法
	 * @return id
	 */
/*	@RequestMapping("/getQuestionTypeId") 
	public @ResponseBody List<Map<String, Object>> getQuestionTypeId() {
		return courseService.getQuestionTypeId();
	}*/
	
	/**
	 * 修改题型说明
	 * @author 黎青华
	 * 只修改是否串题与答案类型
	 * 
	 */
	@RequestMapping("/updateQuestionType")
	public @ResponseBody String updateQuestionType(){
		String[] ids = getPara("ids").split(",");
		String[] atid = getPara("atid").split(",");
		String[] iscon = getPara("iscon").split(",");
		String[] desc = getPara("desc").split("!@#");
		String[] e_qtdesc = getPara("e_qtdesc").split("!@#");
		String[] qtname = getPara("qtname").split(",");
		String[] e_qtname = getPara("e_qtname").split(",");
		String[] sxb=getPara("sxb").split(",");
		String[] xxdf=getPara("xxdf").split(",");
		String[] mediaSet=getPara("mediaSet").split(",");
		List<Map<String, Object>> list = 
				(List<Map<String, Object>>) getRequest().getSession().getAttribute("questionTypeList");
		List<Map<String,Object>> lastList=new ArrayList<>();
		
		qtname[0]=qtname[0].replace("&nbsp;","").trim();
		if(qtname[0].isEmpty()){
			return "-1";
		}
		for(int i=0;i<list.size()-1;i++) {
			for(int j=i+1; j<list.size();j++){
				if(i==0){
					qtname[j]=qtname[j].replace("&nbsp;","").trim();
				}
				if(qtname[j].isEmpty()||qtname[i].equals(qtname[j])){
					return "-1";
				}
			}
		}
		
		for(int i=0;i<list.size();i++) {
			for(int j=0;j<ids.length;j++) {
				if (ids[j].equals(list.get(i).get("ID"))) {
					Map<String, Object> map = new HashMap<>();
					map.put("ID", ids[j]);
					map.put("NAME", qtname[j]);
					map.put("E_QTNAME", e_qtname[j]);
					map.put("QDESC", desc[j]);
					map.put("E_QTDESC", e_qtdesc[j]);
					map.put("ANSWERTYPEID", atid[j]);
					map.put("ISCON", Integer.parseInt(iscon[j]));
					map.put("SXB", sxb[j]);
					map.put("XXDF",xxdf[j]);
					map.put("ISDEFAULT", list.get(i).get("ISDEFAULT"));
					map.put("MEDIASET", mediaSet[j]);
					lastList.add(map);
					break;
				}
			}
		}
		getRequest().getSession().removeAttribute("questionTypeList");
		getRequest().getSession().setAttribute("questionTypeList", lastList);
		return "1";
	}
	
	/**
	 * 组卷时，获取有添加试卷权限的课程列表，使用者：【题库管理端】结构化组卷、多课程组卷
	 * @author 洪艳
	 * @param
	 * @return Map<String, Object>
	 */
	@RequestMapping("/getCourseList4Paper")
	public @ResponseBody Map<String, Object> getCourseList4Paper() {
		User u = getUserInfo();
		if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
//        	u.setcIDs(userService.findAllCids());
			if(u.getcIDs()!=null&&u.getcIDs().size()>0) {
				u.setpCIDs(u.getcIDs());
			}else {
				Set<String> cids=userService.findAllCids();
				u.setcIDs(cids);
				u.setpCIDs(cids);
			}			
        }else{ //其他角色，查询有添加试卷权限的所有课程
//        	u.setcIDs(userService.findCids4Paper(u.getId()));
        	u.setpCIDs(userService.findCids4Paper(u.getId()));
        }
		Set<String> cIDs = u.getpCIDs();
		PageUtils pu = getPageUtil();
		Map param = new HashMap();
		param.put("owner", getPara("owner")); //使用者，课程列表/试题/组卷
		param.put("cname", (getPara("cname") !=null)?getPara("cname").trim():getPara("cname"));	//课程名
		param.put("condition", getPara("condition")); //是否模糊查询
		param.put("unitid", getPara("unitid"));		//单位ID	
		param.put("uid", u.getId());
		Map<String, Object> res = new HashMap<String, Object>();
		param.put("cIDs", cIDs.toArray(new String[] {}));
		List<String> cidstrList=getCidStrList(cIDs);
		param.put("cidstr", cidstrList);
		res.put("rows", courseService.getCourse(param, pu));
		res.put("total", Integer.parseInt(courseService.getCourseCount(param)));
		return res;
	}
	
	/**
	 * 生成形成性评价
	 * @author 洪艳
	 * @param
	 * @return Map<String, Object>
	 */
	@RequestMapping("/getCourseList4Evaluation")
	public @ResponseBody Map<String, Object> getCourseList4Evaluation() {
		User u = getUserInfo();
		if(getSubject().hasRole("administrator")){  //如果是管理员，查询所有课程
        	u.setcIDs(userService.findAllCids());
        }else{ //其他角色，查询有添加试卷权限的所有课程
        	Set<String> cIDSet=userService.findCids4Paper(u.getId());
        	if(wj_cid!=null&&!"".equals(wj_cid)){
        		cIDSet.add(wj_cid);
        	}
        	u.setcIDs(cIDSet);
        }
		Set<String> cIDs = u.getcIDs();
		PageUtils pu = getPageUtil();
		if(getPara("sort")==null||"".equals(getPara("sort"))){
			pu.setSort("NAME_C");
		}
		Map param = new HashMap();
		param.put("owner", getPara("owner")); //使用者，课程列表/试题/组卷
		param.put("cname", getPara("cname"));	//课程名
		param.put("condition", getPara("condition")); //是否模糊查询
		param.put("unitid", getPara("unitid"));		//单位ID	
		param.put("uid", u.getId());
		List<String> cidstrList=getCidStrList(cIDs);
		param.put("cidstr", cidstrList);
		Map<String, Object> res = new HashMap<String, Object>();
		param.put("cIDs", cIDs.toArray(new String[] {}));
		res.put("rows", courseService.getCourse(param, pu));
		res.put("total", Integer.parseInt(courseService.getCourseCount(param)));
		return res;
	}
	
	/**
	 * 导出主题词
	 * @author 黎青华
	 */
	@RequestMapping("/exportTheme")
	public ResponseEntity<Resource> exportTheme() {
		String cid = getPara("cid");
		HSSFWorkbook workbook = poiService.exportTheme(cid);
		String fileName;
		List<Map<String,Object>> attr = courseService.getCourseAttr(cid);
		if(attr.size()==0) {
			fileName = "导出主题词.xls";
		}else {
			fileName = attr.get(0).get("name_c")+ "主题词" +".xls";
		}
		return FileDownloadUtils.download(workbook, fileName);
	}
	
	/**
	 * 查询当前用户是否有课程权限设置的权限
	 * @author li
	 * 
	 */
	@RequestMapping("/getPermissionCid")
	public @ResponseBody String getPermissionCid(){
		User user = (User) getSubject().getSession().getAttribute("userInfo");
		Map m = new HashMap();
		m.put("cid", getPara("cid"));
		m.put("uid", user.getId());
		m.put("permission", "course:permission");
		if (courseService.checkCoursePermission(m,getUserID()+"_"+getPara("c_id"))==1 || getSubject().hasRole("administrator")) {
			return "1";
		}
		return "";
	}
	
	@RequestMapping("/inCoursePermission")
	public String inCoursePermission() {
		User user = getUserInfo();
		String cid=getPara("c_id");
		List<Map<String, Object>> res = courseService.getEditCourseAttr(cid);	//课程参数
		if(user==null || res==null || res.isEmpty()){
			return "jsp/notTheRole";
		}

		Map<String,Object> courseAttr = res.get(0);
		if(!getSubject().hasRole("administrator")) {
			int courseState = Utils.changeObjToInt(courseAttr.get("state"));
			if(courseState==2 && !getSubject().hasRole("teachingoffice")){
				return "jsp/notTheRole";
			}else if(courseState==3 && !getSubject().hasRole("dean")){
				return "jsp/notTheRole";
			}else if(courseState!=2 && courseState!=3){
				Map m = new HashMap();
				m.put("cid", cid);
				m.put("uid", user.getId());
				m.put("permission", "course:permission");

				if (courseService.checkCoursePermission(m,getUserID()+"_"+cid)!=1) {
					return "jsp/notTheRole";
				}
			}
		}

		getRequest().setAttribute("cid", cid);
		getRequest().setAttribute("cname", courseAttr.get("name_c"));
		return "jsp/course/coursePermission";
	}

	@RequestMapping("/getTeacherInCourse")
	public @ResponseBody Map<String, Object> getTeacherInCourse(){
		User user=getUserInfo();		
		String cid = getPara("cid");
		
		Map param = new HashMap();
		param.put("uid", getUserID());
		param.put("cid", cid);
		param.put("permission", "course:permission");
		Map<String,Object> cMap=courseService.getCourseByCID(cid);
		PageUtils pu = getPageUtil();
		param.put("depid", getPara("depid"));
		setMapParamSafe(param, "uname");
		param.put("unitid", getPara("unitid"));
		param.put("roleid", getPara("roleid"));
		if (getSubject().hasRole("administrator")) {
			param.put("role", "1");
		} else if (getSubject().hasRole("dean")) {
			param.put("role", "2");
		} else if (getSubject().hasRole("teachingoffice")) {
			param.put("role", "3");
		} else if (getSubject().hasRole("director")) {
			if(!user.getUnitID().equals(String.valueOf(cMap.get("UNITID")))){
				param.put("deptLimit", "1");
			}
			param.put("role", "6");
		} else if (getSubject().hasRole("secretary")) {
			param.put("role", "4");
		} else if (getSubject().hasRole("teacher")) {
			param.put("role", "5");
		} else if (getSubject().hasRole("collegedirector")){
			param.put("role", "7");
		}

		List<Map<String,Object>> data = userService.getTeacherInCourse(param);
		int total = data.size();
		List<Map<String,Object>> rtn = Utils.paginate(data, pu.getPage(), pu.getRows());
		getSession().setAttribute(cid+"_teacher_permission",rtn);
		return getRes(rtn, total);
	}
	
	/**
	 * 新增教师权限到本课程
	 * @author li
	 */
	@RequestMapping("/inAddCoursePermission")
	public String inAddCoursePermission() {
		getRequest().setAttribute("cid", getPara("cid"));
		getRequest().setAttribute("cname", courseService.getCourseCNameByCid(getPara("cid")));
		return "jsp/course/courseAddPermission";
	}
	
	/**
	 * 获取拥有权限的教师列表
	 * @author li 
	 */
	@RequestMapping("/getTeacherByPer")
	public @ResponseBody Map<String, Object> getTeacherByPer(){
		User user = getUserInfo();
		Map param = new HashMap();
		param.put("courseEnter", "courseEnter"); //标识从课程入口进入
		param.put("unitid", getPara("unitid"));
		param.put("roleid", getPara("roleid"));
		param.put("uname", getPara("uname"));
		param.put("rname", getPara("rname"));
		
		param.put("uid", user.getId());
		param.put("cid", getPara("cid"));
		param.put("username", user.getUsername());
		if (getSubject().hasRole("administrator")) {
			param.put("role", "1");
		} else if (getSubject().hasRole("dean")) {
			param.put("role", "2");
		} else if (getSubject().hasRole("teachingoffice")) {
			param.put("role", "3");
		} else if (getSubject().hasRole("director")) {
			param.put("role", "6");
		} else if (getSubject().hasRole("secretary")) {
			param.put("role", "4");
		} else if (getSubject().hasRole("teacher")) {
			param.put("role", "5");
		}
		PageUtils pu = getPageUtil();
		return getRes(userService.findTeacherByPer(param, pu), userService.findTeacherByPerCount(param));
	}
	
	/**
	 * 获取每个教师的原有的权限
	 * @author li
	 */
	@RequestMapping("/getPerByUIDAndCID")
	public @ResponseBody List<Permission> getPerByUIDAndCID(){
		String uid = getPara("uid");
		String cid = getPara("cid");
		Map m = new HashMap();
		m.put("uid", uid);
		m.put("cid", cid);
		return permissionService.findPerByUIDAndCID(m,uid+"_"+cid);
	}
	
	/**
	 * 修改已有教师课程权限
	 * @author li
	 */
	@RequestMapping("/editCoursePermission")
	public @ResponseBody String editCoursePermission(@RequestBody Map map) {
		String cid = map.get("cid").toString();
		if(!getSubject().hasRole("administrator")){
			Map m = new HashMap();
			m.put("cid", cid);
			m.put("uid", getUserID());
			m.put("permission", "course:permission");
			if (courseService.checkCoursePermission(m,getUserID()+"_"+cid)==0 ) {
				return "0";
			}
		}
		map.put("system_permission",getApplication().getAttribute("permissions"));
		String name_c = courseService.getCourseCNameByCid(cid);
		map.put("cname",name_c);
		courseService.updatePermissions(map);

		return "1";
	}
	
	/**
	 * 获取新增课程权限的用户列表
	 * @author li
	 * 
	 */
	@RequestMapping("/getTeacherAddPer")
	public @ResponseBody Map<String, Object> getTeacherAddPer(){
		Map param = new HashMap();
		User u = getUserInfo();
		if(u==null){
			return param;
		}
		param.put("unitid", getPara("unitid"));
		param.put("roleid", getPara("roleid"));
		param.put("search", getPara("search"));
		param.put("depid", getPara("depid"));
		setMapParamSafe(param, "uname");
		param.put("uid", getUserID());
		param.put("cid", getPara("cid"));
//		param.put("username", user.getUsername());
		param.put("role", u.getRoleID());
		PageUtils pu = getPageUtil();
		return getRes(userService.findTeacherAddPer(param, pu), userService.findTeacherAddPerCount(param));
	}
	
	
	/**
	 * 删除所有主题词
	 * @author Sam
	 * 
	 */
	@RequestMapping("delAllTheme")
	public @ResponseBody int delAllTheme() {
		if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = 0;
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("cid", getPara("cid"));
			map.put("permission", "course:update");
			rtn = courseService.checkCoursePermission(map,getUserID()+"_"+getPara("cid"));	
			if(rtn==0){
				return 0;
			}
		}
		return courseService.deleteAllTheme(getPara("cid"));
	}
	
	@RequestMapping("delAllThemeForNewCourse")
	public @ResponseBody int delAllThemeForNewCourse() {
		if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = 0;
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("pid", "14");
			rtn = courseService.checkCoursePermissionWithPID(map,getUserID()+"_p14");			
			if(rtn==0){
				return 0; 
			}
		}
		return courseService.delAllThemeForNewCourse(getPara("cid"));
	}
	
	/**
	 * 验证是否有对应的课程权限
	 * @author 洪艳
	 * @param map，传入参数（permission[例如：course:add],uid,cid）
	 * @return 1,有 0,无
	 */
	@RequestMapping("/checkCoursePermission")
	public @ResponseBody int checkCoursePermission(@RequestBody Map map){
		String permission = (String)map.get("permission");
		if(!"administrator".equals(getUserInfo().getRole())){
			String cid = (String)map.get("cid");
			if(cid.equals(wj_cid)){
				return 0;
			}
			int rtn = 0;
			map.put("uid", getUserInfo().getId());
			rtn = courseService.checkCoursePermission(map,getUserInfo().getId()+"_"+map.get("cid"));
			return rtn;
		}else{
			return 1;
		}
	}
	
	/**
	 * 验证是否有添加课程的权限
	 * @author 洪艳
	 * @param /map，传入参数
	 * @return 1,有 0,无
	 */
	@RequestMapping("/checkAddCoursePermission")
	public @ResponseBody int checkAddCoursePermission(){		
		if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = 0;
			Map map = new HashMap();
			map.put("uid", getUserInfo().getId());
			map.put("pid", "14");
			rtn = courseService.checkCoursePermissionWithPID(map,getUserInfo().getId()+"_p14");			
			return rtn;
		}else{
			return 1;
		}
	}
	
	/**
	 * 获取课程已有的专业
	 * 
	 */
	@RequestMapping("/getCourseSpecialtyList")
	public @ResponseBody List<Map<String, Object>> getCourseSpecialtyList(){
		String[] cids = getPara("c_id").split(",");
		List<Map<String, Object>> specialtyList = new ArrayList<>();
		if (cids.length==1) {
			specialtyList = courseService.getCourseSpecialtyList(cids[0]);
		}else {
			for(int i=0;i<cids.length;i++) {
				List<Map<String, Object>> spList = courseService.getCourseSpecialtyList(cids[i]);
				for(Map<String, Object> m:spList) {
					boolean b = true;
					for(Map<String, Object> mm:specialtyList) {
						if (m.get("ID").equals(mm.get("ID"))) {
							b = false;
							break;
						}
					}
					if (b) {
						specialtyList.add(m);
					}
				}
			}
		}
		return specialtyList;
	}
	
	/**
	 * 课程信息预览
	 */
	@RequestMapping("/viewCourse")
	public String viewCourse() {
		User user = getUserInfo();
		if(user==null){
			return "jsp/notTheRole";
		}
		String c_id=getPara("c_id");
		Map<String, Object> res = courseService.getCourseAttr(c_id).get(0);
		Map map = new HashMap();
		map.put("uid", getUserID());
		map.put("cid", c_id);
		map.put("permission", "course:view");
		if(!getSubject().hasRole("administrator")){
			if(!user.getId().equals(res.get("creatorid")) && courseService.checkCoursePermission(map,user.getId()+"_"+c_id)!=1) {
				return "jsp/notTheRole";
			}
		}

		List<Map<String, Object>> splist = (List<Map<String, Object>>) res.get("specialtyList");
		List<Map<String, Object>> specialty = commonService.defaultSpecialty();
		//这里新增一个list是为了过滤null值
		
		List<String> specialtyList = new ArrayList<>();
		for(Map m:splist) {
			String name = "";
			for(Map mm:specialty) {
				if((m.get("SPID").toString()).equals(mm.get("ID").toString())) {
					name = String.valueOf(mm.get("NAME"));
					break;
				}
			}
			if(!"null".equals(name) && !"".equals(name)) {
				specialtyList.add(name);
			}
		}
//		res.put("unitName", commonService.getUnitById(res.get("unitid").toString()).get("NAME"));
		res.put("specialtyList", specialtyList);
		getRequest().setAttribute("res", res);
		return "jsp/course/viewCourse";
	}
	
	//导出所有课程
	@RequestMapping("/exportAll")  
    public ResponseEntity<Resource> exportAll() {
		String unitid=getPara("unitid");
		String arrangeid=getPara("arrangeid");
		String depid=getPara("depid");
		String cname=getRequest().getParameter("cname");
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

		Map param = new HashMap();
		List<String> cidstrList = getCidStrList(cIDs);
		param.put("cidstr",cidstrList);
		param.put("cIDs", cIDs.toArray(new String[] {}));
		param.put("unitid", unitid);
		param.put("depid", depid);
		param.put("arrangeid", arrangeid);
		param.put("cname", cname);

		String fileName = "课程列表"+ DateFormatUtils.getNowDay() +".xls";
		HSSFWorkbook workbook = poiService.exportCourse(param);
		return FileDownloadUtils.download(workbook, fileName);
	} 
	
	@RequestMapping("/getCourseDifficult")
	public @ResponseBody List<Map<String, Object>> getCourseDifficult(){
		return courseService.getCourseDifficult(getPara("cid"));
	}
	
	@RequestMapping("/gotoPaperAnalysis")
	public String gotoPaperAnalysis() {
		String cid=getPara("cid");
		if(!"administrator".equals(getUserInfo().getRole())){
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("cid", cid);
			map.put("permission", "course:view");
			if(courseService.checkCoursePermission(map,getUserID()+"_"+cid)==0) {
				return "jsp/notTheRole";
			}	
		}
		
		getRequest().setAttribute("cid", getPara("cid"));
		getRequest().setAttribute("uid", getUserID());
		return "jsp/course/detailList";
	}
	
	//  获取试卷统计信息
	@RequestMapping("/getDetailList")
	public @ResponseBody Map<String, Object> getDetailList() {
		Map param = new HashMap();
		param.put("cid", getPara("cid"));
		if(!"administrator".equals(getUserInfo().getRole())){			
			param.put("uid", getUserID());
			param.put("permission", "course:view");
			if(courseService.checkCoursePermission(param,getUserID()+"_"+getPara("cid"))==0) {
				return null;
			}
		}			
		
		PageUtils pu = getPageUtil();
		Enumeration<String> paramNames = getRequest().getParameterNames(); 
		while(paramNames.hasMoreElements()) {  
			String key = paramNames.nextElement();  			
			String value = getRequest().getParameter(key);
			param.put(key, value); 
		}
		return getRes(courseService.getDetailList(param, pu), courseService.getPaperCount(param));
	}
	
	//年度分析
		@RequestMapping("/ndfx")
		public String ndfx() {	   	
	    	 getRequest().setAttribute("cid", getPara("cid"));
			return "jsp/course/iconAnalysis";
		}

		// 获得年度分析
		@RequestMapping("/getCourseRecordList")
		public @ResponseBody List<Map<String, List<String>>> getCourseRecordList(){				
		    String cid = getPara("cid");
		    List<Map<String, List<String>>> list =courseService.getCourseRecordList(cid);
			return list;
		}
	
	// 删除课程
	@RequestMapping("/recoverCourse")
	public @ResponseBody String recoverCourse(){
		String cid = getPara("c_id");
		if(!getSubject().hasRole("administrator")){
			return "无相关权限"; 
		}

		courseService.recoverCourse(cid);
		return null;
	}
	
	@RequestMapping("/updateCourseTeacherPermission")
	public @ResponseBody int updateCourseTeacherPermission(@RequestBody Map map) {
		String cid=(String)map.get("cid");
		if(!getSubject().hasRole("administrator")){
			Map m = new HashMap();
			m.put("cid", cid);
			m.put("uid", getUserID());
			m.put("permission", "course:permission");
			if (courseService.checkCoursePermission(m,getUserID()+"_"+cid)==0) {
				return 0;
			}
		}

		String cname = courseService.getCourseCNameByCid((String)map.get("cid"));
		map.put("cname",cname);
		map.put("username",getUsername());
		map.put("permission_old",getSession().getAttribute(cid+"_teacher_permission"));
		map.put("system_permission",getApplication().getAttribute("permissions"));
		permissionService.updateCoursePermission(map);

		return 1;
	}
	
	//彻底删除课程
	@RequestMapping("/delCourseAll")
	public @ResponseBody String delCourseAll(){
		String cid = getPara("cid");
		
		if(!"administrator".equals(getUserInfo().getRole())){
			String uid=getUserID();
			int rtn = 0;
			Map map = new HashMap();
			map.put("uid", uid);
			map.put("cid", cid);
			List<Map<String,Object>> list=courseService.getCourseByUID_CID(map);
			if(list==null||list.size()==0){
				return "无相关权限"; 
			}
		}
		courseService.deleteCourseAll(cid);
		
		return null;
	}
	
	//彻底删除课程，不包含试卷及成绩
	@RequestMapping("/delCourseNotPaper")
	public @ResponseBody String delCourseNotPaper(){
		String cid = getPara("cid");
		
		if(!"administrator".equals(getUserInfo().getRole())){
			String uid=getUserID();
			int rtn = 0;
			Map map = new HashMap();
			map.put("uid", uid);
			map.put("cid", cid);
			List<Map<String,Object>> list=courseService.getCourseByUID_CID(map);
			if(list==null||list.size()==0){
				return "无相关权限"; 
			}
		}
		courseService.delCourseNotPaper(cid);
		
		return null;
	}
	
	@RequestMapping("/importCourse")
	public @ResponseBody String importCourse(@RequestParam(value="uploadFile") MultipartFile mFile) {
		User u = getUserInfo();
		Map map = new HashMap();
		if(!"administrator".equals(getUserInfo().getRole())){
			map.put("code", 1);
			map.put("message", "您没有相关权限");
			return "-2";
		}

		String rtn = poiService.importCourse(mFile);
		
		Map log = new HashMap();
		log.put("content", "批量导入课程");
		log.put("cid", "");
		systemService.addSysLog(log);
		
		if(rtn.contains("c")){
			return "第"+rtn.substring(0,rtn.length()-1)+"行的课程名称已存在！";
		}else if(rtn.contains("d")){
			return "第"+rtn.substring(0,rtn.length()-1)+"行的学院以及科室不存在！";
		}else{
			return rtn;
		}
		
	}
	
	//从Excel导入课程，模板下载
	@RequestMapping("/importCourseTemplate")
    public ResponseEntity<Resource> importCourseTemplate() {
		return FileDownloadUtils.download(WebFilePath.getProjectPath()+"mb/couse.xlsx");
    }
    
    @RequestMapping("/separateOption")
	public @ResponseBody int separateOption() {
		String cid=getPara("cid");
		
		if(!"administrator".equals(getUserInfo().getRole())){
			Map param = new HashMap();
			param.put("uid", getUserID());
			param.put("cid", cid);
			param.put("permission", "question:edit");
			if(questionService.checkQuestionPermission(param,getUserID()+"_"+cid)==0) {
				return 0;
			}
		}	
		
		String all=getPara("all");
		Map<String,Object> param=new HashMap<String,Object>();
		param.put("cid", cid);
		if("1".equals(all)) {
			String[] qids = getParaValues("qids");
			param.put("qids", qids);
		}
		
		return courseService.separateOption(param);
	}

    @RequestMapping("/setThemeOrder")
	public @ResponseBody String setThemeOrder(@RequestBody Map param) {
    	if(!"administrator".equals(getUserInfo().getRole())){
			int rtn = 0;
			Map map = new HashMap();
			map.put("uid", getUserID());
			map.put("cid", param.get("cid"));
			map.put("permission", "course:update");
			rtn = courseService.checkCoursePermission(map,getUserID()+"_"+param.get("cid"));	
			if(rtn==0){
				return "jsp/notTheRole";
			}
		}
    	ArrayList themeID=(ArrayList) param.get("data");
    	try {
    		courseService.setThemeOrder(param);
    	}catch(Exception e) {e.printStackTrace();}
    	
		return "success";
	}

	@RequestMapping("/inAddTeacherPermission")
	public String inAddTeacherPermission() {
		getRequest().setAttribute("cid", getPara("cid"));
		getRequest().setAttribute("cname", courseService.getCourseCNameByCid(getPara("cid")));
		return "jsp/course/addTeacherPermission";
	}

	@RequestMapping("/getAllTeacherPer")
	public @ResponseBody Map<String, Object> getAllTeacherPer(){
		Map param = new HashMap();
		param.put("unitid", getPara("unitid"));
		param.put("roleid", getPara("roleid"));
		param.put("search", getPara("search"));
		param.put("depid", getPara("depid"));
		param.put("uname", (getPara("uname") !=null)?getPara("uname").trim():getPara("uname"));
		param.put("uid", getUserID());
		param.put("cid", getPara("cid"));
		PageUtils pu = getPageUtil();
		return getRes(userService.findAllTeacherPer(param, pu), userService.findAllTeacherPerCount(param));
	}

	@RequestMapping("/toEditCoursePermission")
	public String toEditCoursePermission() {
		if(getSubject().hasRole("administrator")||getSubject().hasRole("teachingoffice")){
			getRequest().setAttribute("unitid", getUserInfo().getUnitID());
			return "jsp/course/editCoursePermission";
		}else{
			return "";
		}
	}

	@RequestMapping("/getCourseList4Teachingoffice")
	public @ResponseBody Map<String, Object> getCourseList4Teachingoffice() {
		User u = getUserInfo();

		if(!getSubject().hasRole("administrator") && !getSubject().hasRole("teachingoffice")){
			return null;
		}
		Map param = new HashMap();
		PageUtils pu = getPageUtil();
		param.put("order", pu.getOrder());
		param.put("sort", pu.getSort());

		param.put("tid",u.getId());

		param.put("owner", getPara("owner")); //使用者，课程列表/试题/组卷
		setMapParamSafe(param,"cname");
		param.put("unitid", getPara("unitid"));		//单位ID
		param.put("depid", getPara("depid"));		//科室ID
		param.put("arrangeid", getPara("arrangeid")); //层次id
		param.put("uid", u.getId());
		param.put("condition", 1); //是否模糊查询
		param.put("begindate", String.valueOf(getPara("beginDate")));
		param.put("enddate", String.valueOf(getPara("endDate")));
		param.put("bdate", String.valueOf(getPara("bdate")));
		param.put("edate", String.valueOf(getPara("edate")));
		Map<String, Object> res = new HashMap<>();
		res.put("rows", courseService.getCourse4TeacherOffice(param, pu));
		res.put("total", Integer.parseInt(courseService.getCourseCount4TeacherOffice(param)));
		return res;
	}

	@RequestMapping("/inCoursePermission_teachingoffice")
	public String inCoursePermission_teachingoffice() {
		User user = getUserInfo();
		if(user==null){
			return "jsp/notTheRole";
		}
		String cid=getPara("c_id");
		Map<String, Object> res = courseService.getCourseAttr(cid).get(0);
		Map param = new HashMap();
		param.put("uid", getUserID());
		param.put("cid", cid);
		param.put("permission", "course:permission");
		if(!getSubject().hasRole("administrator")) {
			/*if (getSubject().hasRole("teachingoffice")) {
				if (!user.getUnitID().equals(res.get("unitid")) && !user.getId().equals(res.get("creatorid"))) {
					return "jsp/notTheRole";
				}
			}else{
				return "jsp/notTheRole";
			}*/
			if(!user.getId().equals(res.get("creatorid")) && courseService.checkCoursePermission(param,user.getId()+"_"+cid)!=1) {
				return "jsp/notTheRole";
			}
		}
		getRequest().setAttribute("cid", cid);
		getRequest().setAttribute("cname", res.get("name_c"));
		return "jsp/course/coursePermission_teachingoffice";
	}

	@RequestMapping("/updatePermission_teachingoffice")
	public @ResponseBody int updatePermission_teachingoffice(@RequestBody Map map) {
		User user = getUserInfo();
		if(user==null){
			return 0;
		}
		String cid=(String)map.get("cid");
		Map<String, Object> res = courseService.getCourseAttr(cid).get(0);
		Map param = new HashMap();
		param.put("uid", getUserID());
		param.put("cid", cid);
		param.put("permission", "course:permission");
		if(!getSubject().hasRole("administrator")) {
			/*if (getSubject().hasRole("teachingoffice")) {
				if (!user.getUnitID().equals(res.get("unitid")) && !user.getId().equals(res.get("creatorid"))) {
					return 0;
				}
			}else{
				return 0;
			}*/
			if(!user.getId().equals(res.get("creatorid")) && courseService.checkCoursePermission(param,user.getId()+"_"+cid)!=1) {
				return 0;
			}
		}

		map.put("cname",res.get("name_c"));
		map.put("username",user.getUsername());
		map.put("permission_old",getSession().getAttribute(cid+"_teacher_permission"));
		map.put("system_permission",getApplication().getAttribute("permissions"));
		permissionService.updateCoursePermission(map);

		return 1;
	}

	@RequestMapping("/editCoursePermission_teachingoffice")
	public @ResponseBody String editCoursePermission_teachingoffice(@RequestBody Map map) {
		User user = getUserInfo();
		if(user==null){
			return "0";
		}
		String cid = map.get("cid").toString();
		Map<String, Object> res = courseService.getCourseAttr(cid).get(0);
		Map param = new HashMap();
		param.put("uid", getUserID());
		param.put("cid", cid);
		param.put("permission", "course:permission");
		if(!getSubject().hasRole("administrator")) {
			/*if (getSubject().hasRole("teachingoffice")) {
				if (!user.getUnitID().equals(res.get("unitid")) && !user.getId().equals(res.get("creatorid"))) {
					return "0";
				}
			}else{
				return "0";
			}*/
			if(!user.getId().equals(res.get("creatorid")) && courseService.checkCoursePermission(param,user.getId()+"_"+cid)!=1) {
				return "0";
			}
		}
		map.put("system_permission",getApplication().getAttribute("permissions"));
		map.put("cname",res.get("name_c"));
		courseService.updatePermissions(map);

		return "1";
	}

	@RequestMapping("/getTeacherInCourse_teachingoffice")
	public @ResponseBody Map<String, Object> getTeacherInCourse_teachingoffice(){
		User user=getUserInfo();
		String cid = getPara("cid");
		Map<String, Object> res = courseService.getCourseAttr(cid).get(0);

		Map param = new HashMap();
		param.put("uid", getUserID());
		param.put("cid", cid);
		param.put("permission", "course:permission");
		if(!getSubject().hasRole("administrator")){
			if(!user.getId().equals(res.get("creatorid")) && courseService.checkCoursePermission(param,user.getId()+"_"+cid)!=1) {
				return null;
			}
		}
		PageUtils pu = getPageUtil();
		param.put("depid", getPara("depid"));
		setMapParamSafe(param, "uname");
		param.put("unitid", getPara("unitid"));
		param.put("roleid", getPara("roleid"));
		if (getSubject().hasRole("administrator")) {
			param.put("role", "1");
		} else if (getSubject().hasRole("dean")) {
			param.put("role", "2");
		} else if (getSubject().hasRole("teachingoffice")) {
			if (getUserInfo().getUnitID().equals((String) res.get("unitid"))) {
				param.put("role", "2");
			}else{
				param.put("role", "3");
			}

		} else if (getSubject().hasRole("director")) {
			if(!user.getUnitID().equals(String.valueOf(res.get("unitid")))){
				param.put("deptLimit", "1");
			}
			param.put("role", "6");
		} else if (getSubject().hasRole("secretary")) {
			param.put("role", "4");
		} else if (getSubject().hasRole("teacher")) {
			param.put("role", "5");
		} else if (getSubject().hasRole("collegedirector")){
			param.put("role", "7");
		}
		List<Map<String,Object>> data = userService.getTeacherInCourse(param);
		int total = data.size();
		List<Map<String,Object>> rtn = Utils.paginate(data, pu.getPage(), pu.getRows());
		getSession().setAttribute(cid+"_teacher_permission",rtn);
		return getRes(rtn, total);
	}
}