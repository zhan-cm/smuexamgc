package com.cx.kaoyi.framework.shiro;

import com.cx.kaoyi.framework.utils.IpUtils;
import org.apache.shiro.session.Session;
import org.apache.shiro.session.mgt.SessionContext;
import org.apache.shiro.session.mgt.SessionFactory;
import org.apache.shiro.web.session.mgt.WebSessionContext;

import javax.servlet.http.HttpServletRequest;

public class ShiroSessionFactory implements SessionFactory {

    public Session createSession(SessionContext initData){
        ShiroSession session=new ShiroSession();
        if(initData!=null && initData instanceof WebSessionContext){
            WebSessionContext sessionContext=(WebSessionContext)initData;
            HttpServletRequest request=(HttpServletRequest)sessionContext.getServletRequest();
            if(request!=null){
                session.setHost(IpUtils.getAllValidIpToString(request));
            }
        }
        return session;
    }

}
