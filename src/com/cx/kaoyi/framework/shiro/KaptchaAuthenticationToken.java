package com.cx.kaoyi.framework.shiro;

import org.apache.shiro.authc.UsernamePasswordToken;

public class KaptchaAuthenticationToken extends UsernamePasswordToken {

	private String kaptcha;

	public KaptchaAuthenticationToken() {
	}

	public KaptchaAuthenticationToken(String username, String password, boolean rememberMe, String host,
			String kaptcha) {
		super(username, password, rememberMe, host);
		this.kaptcha = kaptcha;
	}

	public void setKaptcha(String kaptcha) {
		this.kaptcha = kaptcha;
	}

	public String getKaptcha() {
		return this.kaptcha;
	}
}
