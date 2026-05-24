package com.cx.kaoyi.framework.shiro;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.cx.kaoyi.business.domain.Student;
import com.cx.kaoyi.framework.utils.DateFormatUtils;
import com.cx.kaoyi.framework.utils.IpUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authz.AuthorizationFilter;

public class LoadFilter extends AuthorizationFilter {

    private static final Logger logger = LogManager.getLogger(LoadFilter.class);
	 /**
     * 教师端登录地址
     */
    static final String ADMIN_LOGIN_URL = "/login";
    /**
     * 考试端列表
     */
    static final String STU_LOGIN_URL = "/exam/testList";
    
	@Override
    protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) {
		String url = ((HttpServletRequest)request).getRequestURL().toString();
		Subject subject = getSubject(request, response);
        if (subject.getPrincipal() == null) {// 表示没有登录，重定向到登录页面
            saveRequest(request);
            if("XMLHttpRequest".equalsIgnoreCase(((HttpServletRequest)request).getHeader("X-Requested-With"))){
        		response.setCharacterEncoding("UTF-8");
                //在响应头设置session状态
        		((HttpServletResponse)response).setHeader("session-status", "timeout");
                return true;
        	}else if("THYHttpRequest".equalsIgnoreCase(((HttpServletRequest)request).getHeader("THY-Requested-With"))){
                response.setCharacterEncoding("UTF-8");
                //在响应头设置session状态
                ((HttpServletResponse)response).setHeader("session-status", "timeout");
                return true;
            }else{
        		if(url.contains("/exam/")){
                	this.setLoginUrl(STU_LOGIN_URL);
//                	WebUtils.issueRedirect(request, response, STU_LOGIN_URL);
                    return false;
                }else{
                	this.setLoginUrl(ADMIN_LOGIN_URL);
                	return false;            	
                }
        	}                        
        } else if (url.contains("/uploadFile/") || url.contains("/tmpDocx")) {
            if (subject.getSession().getAttribute("userInfo")==null) {
                String addtime = DateFormatUtils.getNowTime();
                String ip = IpUtils.getAllValidIpToString((HttpServletRequest) request);
                String name = "未知用户";
                if(subject.getSession().getAttribute("student")!=null){
                    Student student = (Student) subject.getSession().getAttribute("student");
                    name = student.getName() + "（" + student.getNum() + "）";
                }
                logger.info(name+"在"+addtime+" "+ip+"的地址尝试访问："+url);
                this.setLoginUrl(ADMIN_LOGIN_URL);
                return false;
            }
        }
        return true;
    }
}
