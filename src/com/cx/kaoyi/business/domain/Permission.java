package com.cx.kaoyi.business.domain;

public class Permission {
	private String id;
	private String name;
	private String permission; // 权限标识 程序中判断使用,如"user:create"
	private String type;
	private Boolean state = Boolean.TRUE; // 是否可用,如果不可用将不会添加给用户

	public Permission(){}//kryo缓存必备

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPermission() {
		return permission;
	}

	public void setPermission(String permission) {
		this.permission = permission;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public Boolean getState() {
		return state;
	}

	public void setState(Boolean state) {
		this.state = state;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return "Permission [id=" + id + ", name=" + name + ", permission=" + permission + ", type=" + type + ", state="
				+ state + "]";
	}
}
