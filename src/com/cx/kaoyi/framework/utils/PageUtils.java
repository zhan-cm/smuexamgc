package com.cx.kaoyi.framework.utils;

import org.apache.ibatis.session.RowBounds;

public class PageUtils {

	@Override
	public String toString() {
		return "PageUtils [page=" + page + ", rows=" + rows + ", rb=" + rb + "]";
	}

	private int page;
	private int rows;
	private String sort;
	private String order;
	private RowBounds rb;

	public PageUtils(String p, String r, String sort, String order){
		this.page = Integer.parseInt(p);
		this.rows = Integer.parseInt(r);
		this.sort = sort;
		this.order = order;
		setRb(new RowBounds((page-1)*rows, rows));
	}
	
	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	public String getOrder() {
		return order;
	}

	public void setOrder(String order) {
		this.order = order;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public int getRows() {
		return rows;
	}

	public void setRows(int rows) {
		this.rows = rows;
	}

	public RowBounds getRb() {
		return rb;
	}

	public void setRb(RowBounds rb) {
		this.rb = rb;
	}

}
