package com.cx.kaoyi.business.realm;

import org.apache.shiro.authc.UsernamePasswordToken;

public class CustomizedToken extends UsernamePasswordToken {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	//登录类型，判断是普通用户登录，教师登录还是管理员登录
    private String loginType;
    private String ip;

    public CustomizedToken(final String username, final String password,String loginType,String ip) {
        super(username,password);
        this.loginType = loginType;
        this.ip = ip;
    }

    public String getLoginType() {
        return loginType;
    }

    public void setLoginType(String loginType) {
        this.loginType = loginType;
    }

	public String getIp() {
		return ip;
	}

	public void setIp(String ip) {
		this.ip = ip;
	}
    
    
}
