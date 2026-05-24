package com.cx.kaoyi.framework.shiro;

import org.apache.shiro.session.Session;
import org.apache.shiro.session.mgt.eis.CachingSessionDAO;
import org.apache.shiro.subject.support.DefaultSubjectContext;

import java.io.Serializable;
import java.util.Collection;
import java.util.Date;

public class LocalSessionDAO extends CachingSessionDAO {
    private SessionDAO sessionDAO;

    public void setSessionDAO(SessionDAO sessionDAO){
        this.sessionDAO=sessionDAO;
    }

    @Override
    protected void doUpdate(Session session){
        sessionDAO.update(session);
    }

    @Override
    protected void doDelete(Session session){
        sessionDAO.delete(session);
    }

    @Override
    protected Serializable doCreate(Session session){
        Serializable sessionId=generateSessionId(session);
        assignSessionId(session,sessionId);
        return sessionId;
    }

    @Override
    protected Session doReadSession(Serializable sessionId){
        return sessionDAO.readSession(sessionId);
    }

    public int getLoggedInSessionCount() {
        int loggedInCount = 0;
        Collection<Session> activeSessions = sessionDAO.getActiveSessions();
        for (Session session : activeSessions) {
            // 检查会话中是否存在 PRINCIPALS_SESSION_KEY 属性
            Object principalCollection = session.getAttribute(DefaultSubjectContext.PRINCIPALS_SESSION_KEY);
            if (principalCollection != null) { // 该会话已登录
                if(new Date().getTime()-session.getLastAccessTime().getTime()>session.getTimeout()){ //该会话超时
                    //TODO 删除之类的操作，但是要分布式session后完成才好，否则负载均衡情况可能出问题
                    continue;
                }
                loggedInCount++;
            }
        }
        return loggedInCount;
    }

    public int getLoggedInStudentCount() {
        int loggedInCount = 0;
        Collection<Session> activeSessions = sessionDAO.getActiveSessions();
        for (Session session : activeSessions) {
            // 检查会话中是否存在 PRINCIPALS_SESSION_KEY 属性
            Object principalCollection = session.getAttribute(DefaultSubjectContext.PRINCIPALS_SESSION_KEY);
            if (principalCollection != null && session.getAttribute("student")!=null) {
                //session.getAttribute("rolemark") 再加一个这个判断？
                if(new Date().getTime()-session.getLastAccessTime().getTime()>session.getTimeout()){ //该会话超时
                    //TODO 删除之类的操作，但是要分布式session后完成才好，否则负载均衡情况可能出问题
                    continue;
                }
                loggedInCount++;
            }
        }
        return loggedInCount;
    }

}
