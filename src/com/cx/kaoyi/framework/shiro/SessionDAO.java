package com.cx.kaoyi.framework.shiro;


import com.cx.kaoyi.framework.cache.LocalCache;
import org.apache.shiro.session.Session;
import org.apache.shiro.session.mgt.eis.EnterpriseCacheSessionDAO;
import org.apache.shiro.subject.SimplePrincipalCollection;
import org.apache.shiro.subject.support.DefaultSubjectContext;
import org.springframework.stereotype.Component;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class SessionDAO extends EnterpriseCacheSessionDAO{

    @Override
    protected Serializable doCreate(Session session) {
        Serializable sessionId = super.doCreate(session);
        return sessionId;
    }

    @Override
    protected Session doReadSession(Serializable sessionId) {
        return super.doReadSession(sessionId);
    }

    @Override
    protected void doUpdate(Session session) {
        ShiroSession ssession = (ShiroSession) session;
        Object isAuthenticated = ssession.getAttribute(DefaultSubjectContext.AUTHENTICATED_SESSION_KEY);
        if (isAuthenticated == null) {
            super.doUpdate(ssession);
            return;
        }

        Object principalObj = ssession.getAttribute(DefaultSubjectContext.PRINCIPALS_SESSION_KEY);
        if (!(principalObj instanceof SimplePrincipalCollection)) {
            super.doUpdate(ssession);
            return;
        }

        String sessionId = ssession.getId().toString();
        String username = principalObj.toString();
        Date lastAccessTime = ssession.getLastAccessTime();
        Date createTime = ssession.getStartTimestamp();

        LocalCache cache = LocalCache.getInstance();
        Map<String, Object> map = cache.getMap(ShiroConstants.SESSION_CACHE_NAME, sessionId);
        if (map != null) {
            map.put("lastAccessTime", lastAccessTime);
            long totalAlive = lastAccessTime.getTime() - ((Date) map.get("logintime")).getTime();
            map.put("totalAliveMillis", totalAlive);
            cache.setMap(ShiroConstants.SESSION_CACHE_NAME, sessionId, map);
        } else {
            if (Boolean.parseBoolean(isAuthenticated.toString())) {
                Map<String, Object> newSession = new HashMap<>();
                newSession.put("id", sessionId);
                newSession.put("name", username);
                newSession.put("logintime", new Date()); //登录时间
                newSession.put("createTime", createTime); //第一次访问但未必登录时间
                newSession.put("lastAccessTime", lastAccessTime);
                newSession.put("totalAliveMillis", 0L);
                Object rolemark = session.getAttribute("rolemark");
                newSession.put("rolemark", rolemark == null ? 2 : rolemark);
                cache.setMap(ShiroConstants.SESSION_CACHE_NAME, sessionId, newSession);
            }
        }

        super.doUpdate(ssession);
    }


    @Override
    protected void doDelete(Session session) {
        String sessionId = session.getId().toString();
        LocalCache.getInstance().evict(ShiroConstants.SESSION_CACHE_NAME, sessionId); // 清除用户登录态缓存
        super.doDelete(session); // Shiro 清除 session 缓存
    }
}