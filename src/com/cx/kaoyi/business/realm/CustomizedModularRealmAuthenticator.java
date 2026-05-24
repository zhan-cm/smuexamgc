package com.cx.kaoyi.business.realm;

import java.util.Collection;
import java.util.Map;

import org.apache.shiro.SecurityUtils;
import org.apache.shiro.ShiroException;
import org.apache.shiro.authc.AuthenticationException;
import org.apache.shiro.authc.AuthenticationInfo;
import org.apache.shiro.authc.AuthenticationToken;
import org.apache.shiro.authc.IncorrectCredentialsException;
import org.apache.shiro.authc.LockedAccountException;
import org.apache.shiro.authc.UnknownAccountException;
import org.apache.shiro.authc.pam.ModularRealmAuthenticator;
import org.apache.shiro.authz.UnauthorizedException;
import org.apache.shiro.realm.Realm;
import org.apache.shiro.session.Session;
import org.apache.shiro.util.CollectionUtils;

/**
 * @author 洪艳 
 * 自定义Authenticator
 * 注意，当需要分别定义处理普通用户和管理员验证的Realm时，对应Realm的全类名应该包含字符串“Student”，或者“User”。
 * 并且，他们不能相互包含，例如，处理普通用户验证的Realm的全类名中不应该包含字符串"Admin"。
 */
public class CustomizedModularRealmAuthenticator extends ModularRealmAuthenticator {
	private Map<String, Object> definedRealms;  

    /** 
     * 多个realm实现 
     */  
    @Override  
    protected AuthenticationInfo doMultiRealmAuthentication(Collection<Realm> realms, AuthenticationToken token) {  
        return super.doMultiRealmAuthentication(realms, token);  
    }  
    /** 
     * 调用单个realm执行操作 
     */  
    @Override  
    protected AuthenticationInfo doSingleRealmAuthentication(Realm realm,AuthenticationToken token) {  

        // 如果该realms不支持(不能验证)当前token  
        if (!realm.supports(token)) {
            throw new ShiroException("token错误!");  
        }  
        AuthenticationInfo info = null;  
        try {  
            info = realm.getAuthenticationInfo(token);  

            if (info == null) {  
                throw new ShiroException("token不存在!");  
            }  
        }catch (UnknownAccountException ice) {
//            System.out.println("用户不存在!");
            //throw new AuthenticationException("用户不存在!请确定账号之后重新登录");
            Session session = SecurityUtils.getSubject().getSession();
            String loginType=String.valueOf(session.getAttribute("loginType"));
            if("student".equals(loginType)){
                throw new AuthenticationException("学号姓名或密码不正确，请重新输入");
            }else{
                throw new AuthenticationException("用户名或密码不正确，请重新输入");
            }
        }catch (IncorrectCredentialsException ice) {
//            System.out.println("密码不匹配！");
            //throw new AuthenticationException("密码不匹配！");
            throw new AuthenticationException("用户名或密码不正确，请重新输入");
        }catch (UnauthorizedException ice) {
//            System.out.println(ice.getMessage());
            throw new AuthenticationException(ice.getMessage()); 
        } catch (LockedAccountException lae) {
//            System.out.println("账户已被冻结！");
            throw new AuthenticationException("账户已被冻结！"); 
        }catch (Exception e) {
        	e.printStackTrace();
        	throw new AuthenticationException(e.getMessage());  
        }
        return info;  
    } 


    /** 
     * 判断登录类型执行操作 
     */  
    @Override  
    protected AuthenticationInfo doAuthenticate(AuthenticationToken authenticationToken)throws AuthenticationException {  
        this.assertRealmsConfigured();  
        Realm realm = null; 
        try{
        	CustomizedToken token = (CustomizedToken) authenticationToken;  
            //判断是否是后台用户
             if (token.getLoginType().equals("User")) {  
                 realm = (Realm) this.definedRealms.get("userRealm");  
             }else if(token.getLoginType().equals("Student")){
                 realm = (Realm) this.definedRealms.get("studentRealm");  
             }else if(token.getLoginType().equals("Visitor")){
                 realm = (Realm) this.definedRealms.get("visitorRealm");  
             }else if(token.getLoginType().equals("MobileStudent")) {
             	realm = (Realm) this.definedRealms.get("mobileStudentRealm");  
             }
        }catch(Exception e){
            realm = (Realm) this.definedRealms.get("userRealm");
        }
        return this.doSingleRealmAuthentication(realm, authenticationToken);  
    }  

    /** 
     * 判断realm是否为空 
     */  
    @Override  
    protected void assertRealmsConfigured() throws IllegalStateException {  
        this.definedRealms = this.getDefinedRealms();  
        if (CollectionUtils.isEmpty(this.definedRealms)) {  
            throw new ShiroException("值传递错误!");  
        }  
    }  

    public Map<String, Object> getDefinedRealms() {  
        return this.definedRealms;  
    }  

    public void setDefinedRealms(Map<String, Object> definedRealms) {  
        this.definedRealms = definedRealms;  
    }  


}
