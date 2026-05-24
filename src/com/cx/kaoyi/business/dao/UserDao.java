package com.cx.kaoyi.business.dao;



import java.util.List;
import java.util.Map;
import java.util.Set;

import com.cx.kaoyi.business.domain.Student;
import org.apache.ibatis.session.RowBounds;

import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.framework.utils.PageUtils;

public interface UserDao {
    public Set<String> findAllDelQueCids();
    public Set<String> findDelQueCids(Map map);
	public Set<String> findAllCids();
    public Set<String> getCourseOfUnit(Map param);
    public Set<String> findCids(String uid);
    public Set<String> findAllDelCids();
    public Set<String> findDelCids(String uid);  
    public Set<String> findCids4Paper(String uid);
	
    public int createUser(User user);
    public int updateUser(User user);
    public int updateLoginTime(User user);

    User findOne(String userId);

    User findByUsername(String username);

    User findByUsername_includeAll(String username);
    
    User findByUserIdcard(String idcard);
    
    public List<Map<String,Object>> findByRealname(String realname);

    //Set<String> findPermissions(String username);
    
    Set<String> findRoles(String name);
    
    /**
     * 获取不同权限角色所获得的行数
     * @author 洪艳
     * @param param:username
     * @return 行数
     */
    public List<Map<String, Object>> getTeacherCount(Map param);
    
    public List<Map<String, Object>> getCourseByUID(Map param);
    
    public List<Map<String, Object>> getCourseByUIDFromUnit(Map param);
    
    public List<Map<String, Object>> getCourseByUIDFromOtherUnit(Map param);

    public List<Map<String,Object>> findSuperiors(Map param);
    
    public List<Map<String,Object>> findSuperiors_cq(Map param);
    
    public List<Map<String,Object>> findSuperiors4import(Map param);
    
    public List<User> findByRole(Map map,RowBounds rb);
    
    public List<Map<String, Object>> getUserPermission(String tid);
    
    public int delEditUser(String tid);
    
    public int insertEditUser(String tid);
    
    public int isExistPaperAddPermission(Map param);
    
    public int updateUserXls(User user);
    
    public List<User> findTeacherByPer(Map map,RowBounds rb);
    
    public String findTeacherByPerCount(Map map);
    
    public List<User> findTeacherAddPer(Map map, RowBounds rb);
    
    public String findTeacherAddPerCount(Map map);
    
	public List<User> getAllTeacher();
	public int resetPassword(User user);
    List<User> findByEmployeeNum(String num);

    public User findByWxUnionID(String wxUnionID);

    List<User> findByTel(String tel);

    public List<User> findAllTeacherPer(Map map, RowBounds rb);

    public String findAllTeacherPerCount(Map map);
}