package com.cx.kaoyi.business.controller.News;

import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.service.CommonService;
import com.cx.kaoyi.business.service.NewsService;

import com.cx.kaoyi.framework.base.BaseController;
import com.cx.kaoyi.framework.cache.LocalCache;
import com.cx.kaoyi.framework.shiro.LocalSessionDAO;
import com.cx.kaoyi.framework.utils.PageUtils;
import com.cx.kaoyi.framework.utils.Utils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.*;

//普通类
@Controller
@RequestMapping("/news")
public class NewsController extends BaseController{

	@Autowired
	private NewsService newsService;
	@Autowired
	private LocalSessionDAO localSessionDAO;
	@Autowired
	private CommonService commonService;
	
	@RequestMapping("/newsList")
    public String newsList() {
		User user = getUserInfo();
		if(user==null){
			return "jsp/notTheRole";
		}
		String tid = user.getId();
		getRequest().setAttribute("newsList", newsService.getNewsList4Index(0));
		Map m = new HashMap();
		m.put("tid", tid);
		if(getSubject().hasRole("administrator")) {
			m.put("isAdmin", 1);
		}else{
			m.put("isAdmin", 0);
		}
		getRequest().setAttribute("page", getPara("page"));
		getRequest().setAttribute("rows", getPara("rows"));
		return "/jsp/news/index";
    }

	@PostMapping("/getPendingPaperCount")
	public @ResponseBody Integer getPendingPaperCount(){
		User user = getUserInfo();
		if(user==null){
			return null;
		}
		Map m = new HashMap();
		m.put("tid", user.getId());
		if(getSubject().hasRole("administrator")) {
			m.put("isAdmin", 1);
		}else{
			m.put("isAdmin", 0);
		}
		return Integer.parseInt(newsService.getPaperListCount(m));
	}

	@PostMapping("/getPaperListData")
	public @ResponseBody Map<String,Object> getPaperListData(){
		User user = getUserInfo();
		if(user==null){
			return null;
		}
		Map m = new HashMap();
		m.put("tid", user.getId());
		if(getSubject().hasRole("administrator")) {
			m.put("isAdmin", 1);
		}else{
			m.put("isAdmin", 0);
		}
		return getRes(newsService.getPaperList(m,getPageUtil()), newsService.getPaperListCount(m));
	}

	@RequestMapping("/getQuestionBankData")
	public @ResponseBody Map<String,Object> getQuestionBankData(){
		LocalCache cache = LocalCache.getInstance();
		Map<String,Object> rtn = cache.get("questionBankData",1);
		rtn.put("onlineCount",localSessionDAO.getLoggedInSessionCount());//在线人数要实时更新
		cache.set("questionBankData",1, rtn);
		return rtn;
	}

	@RequestMapping("/refreshQuestionBankData")
	public @ResponseBody Map<String,Object> refreshQuestionBankData(){
		return commonService.calculateQuestionBankData(false);
	}
	
	@RequestMapping("/getNews")
    public String getNews() {  
		String id = getPara("id");
		getRequest().setAttribute("news", newsService.getNewsById(id));
    	return "/jsp/news/previewNews";
    }
	
	@RequestMapping("/newsManage")
	public String newsManage(){
		//getRequest().setAttribute("newsList", newsService.getNewsList());
		return "/jsp/news/newsManage";
	}
	
	//后台获取公告列表
	@RequestMapping("/getNewsList")
	public @ResponseBody Map<String, Object> getNewsList() {
		Map m = new HashMap();
		setMapParamSafe(m, "type");
		PageUtils pu = getPageUtil();
		return getRes(newsService.getNewsList(m,pu), newsService.getNewsCount(m));
	}
	
	/**
	 * 删除公告
	 * @author yoyo
	 */
	@RequestMapping("/delNew")
	public @ResponseBody String delNew() {
		newsService.delNew(getPara("id"));
		return "1";
	}
	
	/**
	 * 新增公告入口
	 * @author yoyo
	 * @return String
	 */
	@RequestMapping("/inAddNew")
	public String inAddNew() {
		return "jsp/news/addNew";
	}
	
	/**
	 * 新增公告
	 * @author yoyo
	 * @return
	 */
	@RequestMapping("/addNew")
	public String addNew() {
		if(getUserInfo()==null){
			return "jsp/notTheRole";
		}
		Map param = new HashMap();		
		param.put("title", getPara("title"));
		param.put("content", getRequest().getParameter("content"));
		param.put("addtime", new Date());
		param.put("type", getPara("type"));
		param.put("fbr", getUserID());
		newsService.addNew(param);		
		getRequest().setAttribute("news", newsService.getNewsById(param.get("id") +""));
		return  "jsp/news/previewNews";
	}
	
	/**
	 * 编辑公告入口
	 * @author yoyo
	 * @return String
	 */
	@RequestMapping("/inEditNew")
	public String inEditNew() {
		String id = getPara("id");
		getRequest().setAttribute("news", newsService.getNewsById(id));
		return "jsp/news/editNew";
	}
	
	/**
	 * 编辑公告
	 * @author yoyo
	 * @return
	 */
	@RequestMapping("/editNew")
	public String editNew() {
		if(getUserInfo()==null){
			return "jsp/notTheRole";
		}
		Map param = new HashMap();		
		param.put("title", getPara("title"));
		param.put("content", getRequest().getParameter("content"));
		param.put("addtime", new Date());
		param.put("type", getPara("type"));
		param.put("fbr", getUserID());
		param.put("id", getPara("id"));
		newsService.editNew(param);		
		return  "jsp/news/newsManage";
	}


	@RequestMapping("/newsList4OperationTeaching")
	public String newsList4OperationTeaching(){
		getRequest().setAttribute("isOperationTeaching", 1);
		return "jsp/news/newsManage";
	}
	
}
