package com.cx.kaoyi.business.domain;

import java.util.List;

public class Theme {
    private Long id;
    private String name;
    private Integer tlevel;
    private Long pid;
    private Long torder;
    private String cid;
    private List<Theme> childList;

    public void setId(Long id) {
        this.id = id;
    }

    public Long getId() {
        return id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public Long getPid() {
        return pid;
    }

    public void setPid(Long pid) {
        this.pid = pid;
    }

    public List<Theme> getChildList() {
        return childList;
    }

    public void setChildList(List<Theme> childList) {
        this.childList = childList;
    }

    public Long getTorder() {
        return torder;
    }

    public void setTorder(Long torder) {
        this.torder = torder;
    }

    public Integer getTlevel() {
        return tlevel;
    }

    public void setTlevel(Integer tlevel) {
        this.tlevel = tlevel;
    }

    public String getCid() {
        return cid;
    }

    public void setCid(String cid) {
        this.cid = cid;
    }
}