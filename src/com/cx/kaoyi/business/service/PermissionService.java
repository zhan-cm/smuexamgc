package com.cx.kaoyi.business.service;

import java.util.List;
import java.util.Map;
import java.util.Set;

import com.cx.kaoyi.business.domain.Permission;


public interface PermissionService {
	public int createPermission(Permission permission);

	public void deletePermission(Long permissionId);

	public Set<String> findPermissionsByUID(String userId);

	public List<Permission> findPerByRID(String rid);

    public int deleteTeacherCourse(Map param);

    public int deletePermissionByTIDAndCID(Map param);

    public int updatePermissionByTIDAndCID(Map param);

    public int addTeacherPermission(Map param);

    public int addTeacherCourse(Map param);
    
    public List<Permission> findPerByUIDAndCID(Map param,String uid_cid);
    
    //public List<Permission> getQuestionPermissionsByUIDAndCID(Map param,String username_cid);
    
    public int addTeacherPaperPermission(Map param,String uid);
    
    public List<Permission> findPaperPerByUIDAndEID(Map param,String uid);
    
    public int addTeacherBPaperPermission(Map param);
    
//    public List<Map<String, Object>> getPermissionByCourseOffered(Map param);
    
    public List<Map<String, Object>> getPaperPermission4Course();
    
    public List<Permission> checkPermissionsByUID_PID(Map param,String uid_pid);
    
    public List<Permission> getPermissionsByRID_uid_cid(String rid,String uid,String cid);

	public int updateCoursePermission(Map map);
	
	public List<Map<String,Object>> findPaperCorrectPer2(Map param);
	
	public List<Map<String,Object>> findRolePermission();
}
