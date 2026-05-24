package com.cx.kaoyi.framework.shiro;

import com.alibaba.fastjson2.JSON;
import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.realm.CustomizedToken;
import com.cx.kaoyi.business.realm.LoginType;
import com.cx.kaoyi.business.service.SystemService;
import com.cx.kaoyi.business.service.UserService;


import com.cx.kaoyi.framework.cache.LocalCache;
import com.cx.kaoyi.framework.shiro.dto.PasswordWrongRecord;
import com.cx.kaoyi.framework.utils.*;
import com.cx.kaoyi.framework.utils.serialize.FastJsonTypeRefs;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.crypto.hash.SimpleHash;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.util.ByteSource;
import org.apache.shiro.web.filter.authc.FormAuthenticationFilter;
import org.apache.shiro.web.util.WebUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.util.StringUtils;

import javax.servlet.ServletContext;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.time.temporal.ChronoUnit;
import java.util.*;

public class KaptchaFormAuthenticationFilter extends FormAuthenticationFilter {
    @Autowired
    private UserService userService;
    @Autowired
    private SystemService systemService;
    @Autowired
    private ServletContext servletContext;

    private static final String USER_LOGIN_TYPE = LoginType.ADMIN.toString();

    private String kaptchaParam = "kaptcha";

    public String getKaptchaParam() {
        return kaptchaParam;
    }

    protected String getKaptcha(ServletRequest request) {
        return WebUtils.getCleanParam(request, getKaptchaParam());
    }
   
    @Override
    protected AuthenticationToken createToken(ServletRequest request,
                                              ServletResponse response) {
        String username = getUsername(request);
        String password = getPassword(request);
        String kaptcha = getKaptcha(request);
        boolean rememberMe = isRememberMe(request);
        String host = getHost(request);
        return new KaptchaAuthenticationToken(username, password, rememberMe,
                host, kaptcha);
    }

    // 验证码校验
    protected void doKaptchaValidate(HttpServletRequest request, KaptchaAuthenticationToken token) {
        String kaptcha = (String) request.getSession().getAttribute(ShiroConstants.KAPTCHA_SESSION_KEY);

        if (StringUtils.isEmpty(token.getKaptcha()) || !token.getKaptcha().equalsIgnoreCase(kaptcha)) {
            throw new IncorrectKaptchaException("error_kaptcha");
        }
    }

    // 认证 鉴权
    @Override
    protected boolean executeLogin(ServletRequest request, ServletResponse response) throws Exception {
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;
        HttpSession httpSession=httpServletRequest.getSession();
        KaptchaAuthenticationToken token = (KaptchaAuthenticationToken) createToken(request, response);
        String ip = IpUtils.getAllValidIpToString(httpServletRequest);
        httpServletRequest.getSession().setAttribute("ip", ip);
        String device = "";
        try {

            Subject subject = getSubject(request, response);
            if (!subject.isAuthenticated()) {
                String password;
                String username=request.getParameter("username_aec");
                username= (AES.aesDecrypt(username)).trim();
                User user = userService.findByUsername_includeAll(username.toLowerCase());
                if(user==null){
                    return onLoginFailure(token, new AuthenticationException("error_login"), request, response);
                }

                int state = Integer.parseInt(String.valueOf(user.getState()));
                if(state==0){
                    return onLoginFailure(token, new AuthenticationException("error_lock"), request, response);
                }
                int lockLimit = 20;
                LocalCache cache = LocalCache.getInstance();
                String retryKey = user.getUsername();
                String password_unDecrypt= AES.aesDecrypt(request.getParameter("password"));
                password = new SimpleHash("SHA-256",password_unDecrypt,ByteSource.Util.bytes(user.getCredentialsSalt()),3).toHex();
                PasswordWrongRecord passwordWrongRecord = cache.get(ShiroConstants.RETRY_PSW_KEY, retryKey);
                passwordWrongRecord = passwordWrongRecord == null ? new PasswordWrongRecord() : passwordWrongRecord;
                Date now = new Date();
                if(passwordWrongRecord.getWrongCount()>=3
                        && DateFormatUtils.plus(passwordWrongRecord.getLastWrongTime(), 5, ChronoUnit.MINUTES).after(now)){
                    String errorType = "error_login_3";
                    if(!password.equals(user.getPassword())){
                        passwordWrongRecord.addWrongCountAndRefreshTime();
                        if (passwordWrongRecord.getWrongCount() >= lockLimit) { // 超过20次永久锁定
                            user.setState("0");
                            userService.alterUserState(user);
                            errorType = "error_lock";
                            Map log = new HashMap();
                            String addtime = DateFormatUtils.getNowTime();
                            log.put("addtime", addtime);
                            log.put("name", username);
                            log.put("cid" ,"");
                            log.put("ip", ip);
                            log.put("content", username+" "+user.getRealname()+"登录教师端连续密码错误"+lockLimit+"次，账号拟删除封禁。");
                            systemService.addAnySysLog(log);
                        }
                    }
                    cache.set(ShiroConstants.RETRY_PSW_KEY, retryKey, passwordWrongRecord);
                    return onLoginFailure(token, new AuthenticationException(errorType), request, response);
                }

                if(!password.equals(user.getPassword())){
                    if(DateFormatUtils.plus(passwordWrongRecord.getLastWrongTime(), 5, ChronoUnit.MINUTES).before(new Date())){
                        //最后一次错误时间+5分钟比当前时间早则置空
                        passwordWrongRecord.setWrongCount(0);
                    }
                    passwordWrongRecord.addWrongCountAndRefreshTime();
                    String errorType = "error_login";
                    if (passwordWrongRecord.getWrongCount() >= lockLimit) { // 超过20次永久锁定
                        user.setState("0");
                        userService.alterUserState(user);
                        errorType = "error_lock";
                        Map log = new HashMap();
                        String addtime = DateFormatUtils.getNowTime();
                        log.put("addtime", addtime);
                        log.put("name", username);
                        log.put("cid" ,"");
                        log.put("ip", ip);
                        log.put("content", username+" "+user.getRealname()+"登录教师端连续密码错误"+lockLimit+"次，账号拟删除封禁。");
                        systemService.addAnySysLog(log);
                    }else if (passwordWrongRecord.getWrongCount() >= 3) {
                        errorType = "error_login_3";
                    }
                    cache.set(ShiroConstants.RETRY_PSW_KEY, retryKey, passwordWrongRecord);
                    return onLoginFailure(token, new AuthenticationException(errorType), request, response);
                }

                if("1".equals(String.valueOf(servletContext.getAttribute("pass_switch")))){
                    if (!(password_unDecrypt.length()>=8&&(password_unDecrypt.matches(".*[a-z]{1,}.*") || password_unDecrypt.matches(".*[A-Z]{1,}.*"))&& password_unDecrypt.matches(".*\\d{1,}.*")&&password_unDecrypt.matches(".*[~！!@#$%^&*()_+|<>,.?/:;'\\[\\]{}\"\\-]+.*"))) {
                        return onLoginFailure(token, new AuthenticationException("error_passweak_8"), request, response);
                    }
                    //密码不能包含用户名
                    if(password_unDecrypt.contains(username)){
                        return onLoginFailure(token, new AuthenticationException("error_passcontainname"), request, response);
                    }
                }else{
                    if (!(password.length()>5&&(password.matches(".*[a-z]{1,}.*") || password.matches(".*[A-Z]{1,}.*"))&& password.matches(".*\\d{1,}.*"))) {
                        return onLoginFailure(token, new AuthenticationException("error_passweak_6"), request, response);
                    }
                }

                cache.evict(ShiroConstants.RETRY_PSW_KEY, retryKey); //密码对了直接去掉错误记录

                if(user.getLoginTime()==null){
                    return onLoginFailure(token, new AuthenticationException("error_firstLogin"), request, response);
                }
                device = UserAgentUtils.parseDevice(httpServletRequest.getHeader("User-Agent"));
                user.setUsername(user.getUsername());
                user.setPassword(password);
                user.setDevice(device);
                user.setIp(ip);
                httpSession.setAttribute("userInfo", user);
                httpServletRequest.setAttribute("user",user);
                CustomizedToken customizedToken = new CustomizedToken(user.getUsername(), password, USER_LOGIN_TYPE,ip);
                customizedToken.setRememberMe(false);
                subject.login(customizedToken);
            }

            return onLoginSuccess(token, subject, request, response);
        }catch (AuthenticationException e) {
            HttpServletRequest httpServletRequest1 = (HttpServletRequest) request;
            httpServletRequest1.setAttribute("errorInfo", e.getMessage());
            return onLoginFailure(token, e, request, response);
        }
    }
    
    /**
     * 当登录成功
     * @param token
     * @param subject
     * @param request
     * @param response
     * @return
     * @throws Exception
     */
    @Override
    protected boolean onLoginSuccess(AuthenticationToken token, Subject subject, ServletRequest request, ServletResponse response) throws Exception {
        HttpServletRequest httpServletRequest = (HttpServletRequest) request;
        HttpServletResponse httpServletResponse = (HttpServletResponse) response;

        if (!"XMLHttpRequest".equalsIgnoreCase(httpServletRequest
                .getHeader("X-Requested-With"))) {// 不是ajax请求
            issueSuccessRedirect(request, response);
        } else {
            httpServletResponse.setCharacterEncoding("UTF-8");
            PrintWriter out = httpServletResponse.getWriter();
            out.println("{\"success\":true}");
            out.flush();
            out.close();
        }
        return false;
    }

     /**
     * 当登录失败
     * @param token
     * @param e
     * @param request
     * @param response
     * @return
     */
     @Override
     protected boolean onLoginFailure(AuthenticationToken token, AuthenticationException e, ServletRequest request, ServletResponse response) {
         if (!"XMLHttpRequest".equalsIgnoreCase(((HttpServletRequest) request)
                 .getHeader("X-Requested-With"))) { // 不是 Ajax 请求
             setFailureAttribute(request, e);
             return true;
         }

         response.setCharacterEncoding("UTF-8");
         Map<String, Object> result = new HashMap<>();
         result.put("success", false);

         if(request.getAttribute("ticket")!=null) {result.put("ticket", request.getAttribute("ticket"));}
         if(request.getAttribute("phoneMask")!=null){result.put("phoneMask", request.getAttribute("phoneMask"));}

         try (PrintWriter out = response.getWriter()) {
             String message = e.getMessage();
             switch (message) {
                 case "error_kaptcha":
                     result.put("code", "error_kaptcha");
                     result.put("message", "验证码错误");
                     break;
                 case "error_noApply":
                     result.put("code", "error_noApply");
                     result.put("message", "系统未授权或系统已过期，请复制机器码联系管理员进行授权");
                     break;
                 case "error_login":
                     result.put("code", "error_login");
                     result.put("message", "用户名或密码错误，请重新输入，连续输入错误3次，账户会被锁定5分钟");
                     break;
                 case "error_login_3":
                     result.put("code", "error_login_3");
                     result.put("message", "当前用户登录密码连续输错三次已锁定，请5分钟后重试");
                     break;
                 case "error_lock":
                     result.put("code", "error_lock");
                     result.put("message", "账号已锁定，请联系管理员解锁");
                     break;
                 case "error_passweak_8":
                     result.put("code", "error_passweak_8");
                     result.put("message", "密码强度过弱，密码必须包含字母、数字和特殊符号，且不少于8个字符，请修改密码后再登录");
                     break;
                 case "error_passcontainname":
                     result.put("code", "error_passcontainname");
                     result.put("message", "密码不可包含用户名，请联系管理员修改密码后再登录");
                     break;
                 case "error_passweak_6":
                     result.put("code", "error_passweak_6");
                     result.put("message", "密码强度过弱，密码必须包含字母和数字，且不少于6个字符，请修改密码后再登录");
                     break;
                 case "error_firstLogin":
                     result.put("code", "error_firstLogin");
                     result.put("message", "首次登录系统需要修改密码！");
                     break;
                 case "error_forbidden_login":
                     result.put("code", "error_forbidden_login");
                     Object fm = request.getAttribute("forbiddenMessage");
                     result.put("message", fm != null ? String.valueOf(fm) : "系统暂时禁止登录");
                     break;
                 default:
                     result.put("code", "error_login");
                     result.put("message", "登录失败");
                     break;
             }
             String json = JSON.toJSONString(result);
             out.println(json);
             out.flush();
         } catch (IOException e1) {
             e1.printStackTrace();
         }

         return false;
     }

    @Override
    protected boolean isAccessAllowed(ServletRequest request, ServletResponse response, Object mappedValue) {
        try {
            // 先判断是否是登录操作
            if (isLoginSubmission(request, response)) {
                return false;
            }
        } catch (Exception e) {
        }
        Subject subject = getSubject(request,response);
//	    System.out.println(subject.isAuthenticated());
        return super.isAccessAllowed(request, response, mappedValue);
    }
}
