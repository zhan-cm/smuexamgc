package com.cx.kaoyi.framework.shiro;

import org.apache.shiro.session.mgt.SimpleSession;
import org.apache.shiro.subject.support.DefaultSubjectContext;

import java.io.Serializable;
import java.util.Date;
import java.util.Map;

public class ShiroSession extends SimpleSession implements Serializable {
    private static final long serialVersionUID = 122220L;
    private boolean isChanged;

    public ShiroSession(){
        super();
        this.setChanged(true);
    }

    public ShiroSession(String host){
        super(host);
        this.setChanged(true);
    }

    @Override
    public void setId(Serializable id) {
        super.setId(id);
        this.setChanged(true);
    }

    @Override
    public void setStopTimestamp(Date stopTimestamp) {
        super.setStopTimestamp(stopTimestamp);
        this.setChanged(true);
    }

    @Override
    public void setExpired(boolean expired) {
        super.setExpired(expired);
        this.setChanged(true);
    }

    @Override
    public void setTimeout(long timeout) {
        super.setTimeout(timeout);
        this.setChanged(true);
    }

    @Override
    public void setHost(String host) {
        super.setHost(host);
        this.setChanged(true);
    }

    @Override
    public void setAttributes(Map<Object, Object> attributes) {
        super.setAttributes(attributes);
        this.setChanged(false);
    }

    @Override
    public void setAttribute(Object key, Object value) {
        super.setAttribute(key, value);
        if(DefaultSubjectContext.AUTHENTICATED_SESSION_KEY.equals(key)){
            this.setChanged(true);
        }else{
            this.setChanged(false);
        }
    }

    @Override
    public void stop(){
        super.stop();
        this.setChanged(true);
    }

    public boolean isChanged(){
        return isChanged;
    }

    public void setChanged(boolean isChanged){
        this.isChanged=isChanged;
    }

}
