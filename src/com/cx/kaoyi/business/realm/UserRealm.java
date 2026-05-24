package com.cx.kaoyi.business.realm;

import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.service.SystemService;

import com.cx.kaoyi.business.service.UserService;
import com.cx.kaoyi.framework.utils.IpUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.authc.*;
import org.apache.shiro.authz.AuthorizationInfo;
import org.apache.shiro.authz.SimpleAuthorizationInfo;
import org.apache.shiro.realm.AuthorizingRealm;
import org.apache.shiro.session.Session;
import org.apache.shiro.subject.PrincipalCollection;
import org.apache.shiro.util.ByteSource;
import org.springframework.beans.factory.annotation.Autowired;

import javax.servlet.http.HttpServletRequest;
import java.util.Date;


public class UserRealm extends AuthorizingRealm {

    @Autowired
    private UserService userService;

    @Autowired
    private SystemService systemService;

    @Autowired
    private HttpServletRequest request;

    @Override
    public String getName() {
        return "userRealm";
    }

    @Override
    protected AuthorizationInfo doGetAuthorizationInfo(PrincipalCollection principals) {
        String username = (String)principals.getPrimaryPrincipal();
        SimpleAuthorizationInfo authorizationInfo = new SimpleAuthorizationInfo();
        authorizationInfo.setRoles(userService.findRoles(username));
        return authorizationInfo;
    }

    @Override
    protected AuthenticationInfo doGetAuthenticationInfo(AuthenticationToken token) throws AuthenticationException {
//        Session session=SecurityUtils.getSubject().getSession();
//        User user=(User)session.getAttribute("user");
//        String username=user.getUsername();
        Session session = SecurityUtils.getSubject().getSession();
        User user=(User)session.getAttribute("userInfo");
        Integer roleMark = 0;
        if(session.getAttribute("WxUser")!=null){
            roleMark = 5;
        }
        session.setAttribute("rolemark", roleMark);

        //交给AuthenticatingRealm使用CredentialsMatcher进行密码匹配，如果觉得人家的不好可以自定义实现
        SimpleAuthenticationInfo authenticationInfo = new SimpleAuthenticationInfo(
                user.getUsername(), //用户名
                user.getPassword(), //密码
                ByteSource.Util.bytes(user.getCredentialsSalt()),//salt=username+salt
                getName()  //realm name
        );
        return authenticationInfo;
    }
    
    protected void assertCredentialsMatch(AuthenticationToken token, AuthenticationInfo info) throws AuthenticationException {
        Session session=SecurityUtils.getSubject().getSession();
        User user_session=(User)session.getAttribute("userInfo");
    	User user=userService.findByUsername(user_session.getUsername());
    	if(user == null) {
            throw new UnknownAccountException();//没找到帐号
        }
        if(Boolean.FALSE.equals(user.getState())) {
            throw new LockedAccountException(); //帐号锁定
        }
        if(!user.getPassword().equals(user_session.getPassword())){
        	throw new IncorrectCredentialsException();
        }

        Date now = new Date();

        request.setAttribute("userInfo", user);
        String loginRecordStr = "登录系统。登录设备检测为："+user_session.getDevice();

        systemService.addOnlineSysLog(loginRecordStr);
        user.setLoginTime(now);
        user.setIp(IpUtils.getAllValidIpToString(request));
        userService.updateLoginTime(user);
    }

    @Override
    public void clearCachedAuthorizationInfo(PrincipalCollection principals) {
        super.clearCachedAuthorizationInfo(principals);
    }

    @Override
    public void clearCachedAuthenticationInfo(PrincipalCollection principals) {
        super.clearCachedAuthenticationInfo(principals);
    }

    @Override
    public void clearCache(PrincipalCollection principals) {
        super.clearCache(principals);
    }

    public void clearAllCachedAuthorizationInfo() {
        getAuthorizationCache().clear();
    }

    public void clearAllCachedAuthenticationInfo() {
        getAuthenticationCache().clear();
    }

    public void clearAllCache() {
        clearAllCachedAuthenticationInfo();
        clearAllCachedAuthorizationInfo();
    }

}
