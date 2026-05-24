package com.cx.kaoyi.framework.utils;

import java.sql.CallableStatement;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import org.apache.ibatis.type.JdbcType;
import org.apache.ibatis.type.TypeHandler;

import com.alibaba.druid.proxy.jdbc.ClobProxyImpl;

import oracle.sql.CLOB;

public class OracleClobTypeHandler implements TypeHandler<Object> {
	public Object valueOf(String param) {
		return null;
	}

	public Object getResult(ResultSet arg0, String arg1) throws SQLException {
		
		ClobProxyImpl cp  = (ClobProxyImpl)arg0.getClob(arg1);
		if(cp == null){
			return null;
		}
		CLOB clob = (CLOB)cp.getRawClob();
		return (clob == null || clob.length() == 0) ? null : clob.getSubString(1, (int) clob.length());
	}

	public Object getResult(ResultSet arg0, int arg1) {
		return null;
	}

	public Object getResult(CallableStatement arg0, int arg1) {
		return null;
	}

	public void setParameter(PreparedStatement arg0, int arg1, Object arg2, JdbcType arg3) throws SQLException {
		CLOB clob = CLOB.empty_lob();
		clob.setString(1, (String) arg2);
		arg0.setClob(arg1, clob);
	}
}
