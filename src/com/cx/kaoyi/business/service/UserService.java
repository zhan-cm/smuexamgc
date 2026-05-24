package com.cx.kaoyi.business.service;



import java.util.List;
import java.util.Map;
import java.util.Set;

import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.framework.utils.PageUtils;


public interface UserService {

    /**
     * 创建用户
     * @param user
     */
    public int createUser(User user);

    public int updateUser(User user);
    
    public int updateLoginTime(User user);

	public int alterUserState(User user);
    
    public void deleteUser(String userId);
    /**
     * 修改密码
     * @param userId
     * @param newPassword
     */
    public void changePassword(String userId, String newPassword);

    User findOne(String userId);

    /**
     * 根据用户名查找用户
     * @param username
     * @return
     */
    public User findByUsername(String username);

	List<User> findByEmployeeNum(String num);

	public User findByUsername_includeAll(String username);
    
    public List<Map<String,Object>> findByRealname(String realname);

    /**
     * 根据用户名查找其角色
     * @param username
     * @return
     */
    public Set<String> findRoles(String username);
    
    /**
     * 查询所有正常的课程
     * @return
     */
    public Set<String> findAllCids();

	/**
	 * 查询所有被删除过试题的课程
	 */
	public Set<String> findAllDelQueCids();

	/**
	 * 查询用户拥有的流汗课程权限的所有被删除过试题的课程
	 * @return
	 */
	public Set<String> findDelQueCids(Map map);

	/**
     * 查询用户拥有浏览课程权限的所有正常的课程
     * @return
     */
    public Set<String> findCids(String uid);    
    
    public Set<String> findDelCids(String uid);

    public Set<String> findAllDelCids();  

    /**
     * 根据用户名查找其权限
     * @param username
     * @return
     */
    public Set<String> findPermissions(String username);
    
    //public Set<String> findPermissionsByUID(String uid);
    
    public List<Map<String, Object>> getCourseByUID(String uid);
    
    public List<Map<String, Object>> getCourseByUID(Map param,PageUtils pu);
    
    public String getCourseByUIDCount(String uid);
    
    public void updatePermissions(Map m, String username);
    
    public List<Map<String, Object>> getCourseByUIDFromUnit(Map param);
    
    public String getCourseByUIDFromUnitCount(Map param);
    
    public List<Map<String, Object>> getCourseByUIDFromUnit(Map param,PageUtils pu);
    
    public List<Map<String, Object>> getCourseByUIDFromOtherUnit(Map param);
    
    public String getCourseByUIDFromOtherUnitCount(Map param);
    
    public List<Map<String, Object>> getCourseByUIDFromOtherUnit(Map param,PageUtils pu);
    
	public List<String> getPermissionsCid(Map map);
    
    public Object getTeacherTid(Map param);
    
	public  List<String> getPermissionIdByType(String param);
	
	public  List<Map<String, Object>> getPermissionsByType(Map param);

    /**
     * 获取用户的所有上级，添加课程-添加课程权限的时候用到
     * @author 洪艳
     * @param param，包含uid，role（teacher|secretary|director|teachingoffice）
     * @return List<Map<String,Object>> 包含uid，roleid
     */
    public List<Map<String,Object>> findSuperiors(Map param);
    
    public List<Map<String,Object>> findSuperiors_cq(Map param);
    
    public List<Map<String, Object>> findSuperiors4import(Map param);

    /**@author 黎青华,洪艳
     * 查询用户列表，不同角色获取的列表不同，搜索条件：所属学院、所属角色
     * @param pu
     * @return list<User>
     */
    public List<User> getUserList(Map param,PageUtils pu);

    /**@author 黎青华，洪艳
     * 查询用户列表总记录数，不同角色获取的列表不同，搜索条件：所属学院、所属角色
     * @param Map
     * @return 行数
     */
    public String getTeacherCount(Map param);
    
	//删除用户新增、编辑用户权限
	public int delEditUser(String tid);
	
	//给予用户新增、编辑用户权限
	public int insertEditUser(String tid);
	
	/**
	 * 新增，查询用户是否有添加、编辑用户权限和新增课程权限
	 * @author 黎青华
	 * @param tid
	 * @return
	 */
	public List<Map<String, Object>> getUserPermission(String tid);
	
	/**
	 * 查询有“添加试卷”权限的课程列表
	 * @param uid
	 * @return 课程cid的集合
	 */
	public Set<String> findCids4Paper(String uid);
	
	/**
	 * 查询是否有添加试卷的权限
	 * @param param
	 * @return
	 */
	public boolean isExistPaperAddPermission(Map param);
	
	public int updateUserXls(User user);
	
	public List<User> findTeacherByPer(Map map,PageUtils pu);
	
	public String findTeacherByPerCount(Map map);
	
	public List<User> findTeacherAddPer(Map map, PageUtils pu);
	
	public String findTeacherAddPerCount(Map map);
	
	public User findUserByUid(String uid);

	public List<User> getAllTeacher();

	public List<Map<String, Object>> getTeacherInCourse(Map param);

	public List<Map<String,Object>> getUserEmail(String username);
	
	public int updateEmailLock(Map param);
	
	public List<Map<String,Object>> getUsersByName(String name);
	
	public int checkLoginPer(String tid);

	public String getUserIdByName(String name);
	
	public String getUserIdByIdcard(String idcard);

	public int updateUserWithNoPass(User u);
	
	public int resetPass(User user);
	
	public List<Map<String,Object>> getCourseByDept(String uid);
	
	public List<Map<String,Object>> getCourseByUnit(String uid);
	
	public int addTeacherPermission(Map param);
	
	public User findByUserIdcard(String idcard);
	
	public int updateUserEmail_lock(String id);

	User findByWxUnionID(String wxUnionID);

	User findByTel(String tel);

	public Set<String> getCourseOfUnit(Map param);

	public List<User> findAllTeacherPer(Map map, PageUtils pu);

	public String findAllTeacherPerCount(Map map);
}
