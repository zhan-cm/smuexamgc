package com.cx.kaoyi.framework.base;

import com.cx.kaoyi.business.domain.Student;
import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.framework.utils.PageUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authz.AuthorizationException;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.Subject;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.safety.Safelist;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;
import org.springframework.web.servlet.FlashMap;
import org.springframework.web.servlet.support.RequestContextUtils;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.net.URI;
import java.util.*;

/**
 * 基础类
 * 
 */
public class BaseController {

	protected Logger logger = LogManager.getLogger(this.getClass());

	// 获取HttpServletRequest
	protected HttpServletRequest getRequest() {
		return ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();

	}

	// 获取HttpServletResponse
	protected HttpServletResponse getResponse() {
		return ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getResponse();

	}

	// 获取Application
	protected ServletContext getApplication() {
		return getRequest().getServletContext();

	}

	// 获取Session，注意这是shiro的session
	protected Session getSession() {
		return SecurityUtils.getSubject().getSession();

	}

	// 获取登录用户主体（属于shiro核心之一，望关注）
	protected Subject getSubject() {
		return SecurityUtils.getSubject();
	}

	// 获取登录后的用户（教师）信息
	protected User getUserInfo() {
		return (User) getSession().getAttribute("userInfo");
	}

	// 获取登录后的学生信息
	protected Student getStudentInfo() {
		return (Student) getSession().getAttribute("student");
	}

	protected boolean isStudentEnd() {
		Integer rolemark = (Integer) getSession().getAttribute("rolemark");
		return rolemark==3 || rolemark==4;
	}

	// 获取登录后的用户（教师）ID
	protected String getUserID() {
		return getUserInfo().getId();

	}

	// 获取登录后的用户（教师）名
	protected String getUsername() {
		return getUserInfo().getUsername();

	}

	// 获取登录后的学生ID
	protected String getStudentID() {
		return getStudentInfo().getId();

	}

	// 获取登录后的学生名
	protected String getStudentname() {
		return getStudentInfo().getName();
	}

	public String getPara(String para) {
		String value = getRequest().getParameter(para);
		if (value == null || value.isEmpty()) return value;
		// 关闭 prettyPrint，保留原始换行
		Document.OutputSettings out = new Document.OutputSettings().prettyPrint(false);
		String safe = Jsoup.clean(value, "", Safelist.simpleText(), out);
		return safe;
	}

	public void setMapParamSafe(Map<String,Object> param, String paraKey){
		if(param!=null){
			if(!StringUtils.isBlank(getPara(paraKey))){
				param.put(paraKey,getPara(paraKey).trim());
			}
		}
	}

	public void setMapParamSafe(Map<String,Object> param, String setParaKey, String getParaKey){
		if(param!=null){
			if(!StringUtils.isBlank(getPara(getParaKey))){
				param.put(setParaKey,getPara(getParaKey).trim());
			}
		}
	}

	// 获取传递的参数（为空的话，用默认值代替）
	public String getPara(String name, String defaultValue) {
		String result = getRequest().getParameter(name);
		return StringUtils.isBlank(result) ? defaultValue : result.trim();
	}

	// 获取传递的数据集合
	public String[] getParaValues(String name) {
		return getRequest().getParameterValues(name);
	}

	// 获取easyui datagrid分页属性，从左到右依次为页码，条数，排序属性，正反序
	public PageUtils getPageUtil() {
		return new PageUtils(getPara("page"), getPara("rows"), getPara("sort"), getPara("order"));
	}

	// easyUI分页结果
	public Map<String, Object> getRes(Object o, String total) {
		Map<String, Object> res = new HashMap<>();
		res.put("rows", o); // 分页数据
		res.put("total", Integer.valueOf(total)); // 总条数
		return res;
	}

	public Map<String, Object> getRes(Object o, int total) {
		Map<String, Object> res = new HashMap<>();
		res.put("rows", o); // 分页数据
		res.put("total", total); // 总条数
		return res;
	}

	/**
	 * 将字符串集合按每200个元素拼接成字符串，并用逗号分隔
	 * @param elements 字符串集合（支持Set/List等任何Collection子类）
	 * @return 分段拼接后的字符串列表
	 */
	public List<String> getCidStrList(Collection<String> elements) {
		List<String> result = new ArrayList<>();
		StringBuilder segment = new StringBuilder();
		int count = 0;

		for (String element : elements) {
			if (count == 200) {
				// 移除末尾多余的逗号并添加到结果
				result.add(segment.deleteCharAt(segment.length() - 1).toString());
				segment.setLength(0); // 清空
				count = 0;
			}
			segment.append(element).append(",");
			count++;
		}

		// 处理剩余部分
		if (segment.length() > 0) {
			result.add(segment.deleteCharAt(segment.length() - 1).toString());
		}
		return result;
	}

	@ExceptionHandler(Exception.class)
	@ResponseBody
	public ResponseEntity<Map<String, Object>> exp(HttpServletRequest request, Exception ex) {
		Map<String, Object> result = new HashMap<>();
		String err = ex instanceof AuthorizationException ? "没有权限" : "系统错误";
		logger.error("全局异常捕获", ex);
		result.put("code", 500);
		result.put("msg", err);

		// 判断是否 AJAX 请求
		if (!"XMLHttpRequest".equalsIgnoreCase(request.getHeader("x-requested-with"))
		 && !"THYHttpRequest".equalsIgnoreCase(request.getHeader("THY-Requested-With"))) {
			// 同步请求：把错误信息放进 FlashMap，重定向到 referer
			FlashMap flashMap = RequestContextUtils.getOutputFlashMap(request);
			if (flashMap != null) {
				flashMap.put("errorInfo", err);
			}
			String referer = request.getHeader("Referer");
			if (referer == null || referer.isEmpty()) {
				referer = "/jsp/default";
			}
			return ResponseEntity.status(HttpStatus.FOUND)
					.location(URI.create(referer))  // 302 重定向
					.build();
		}

		// 异步请求：直接返回 JSON 内容
		return ResponseEntity
				.status(HttpStatus.INTERNAL_SERVER_ERROR)
				.body(result);
	}
}
