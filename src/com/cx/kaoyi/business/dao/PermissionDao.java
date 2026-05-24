package com.cx.kaoyi.business.dao;

import java.util.List;
import java.util.Map;
import java.util.Set;

import com.cx.kaoyi.business.domain.Permission;

/**
 * <p>User: Zhang Kaitao
 * <p>Date: 14-1-28
 * <p>Version: 1.0
 */
public interface PermissionDao {

    public int createPermission(Permission permission);

    public void deletePermission(Long permissionId);
    
    public Set<String> findPermissionsByUID(String userId);

    public List<Permission> findPerByRID(String rid);

    public int deletePermissionByTIDAndCID(Map param);
    
    public int deletePermissionByTIDAndCIDS(Map param);

    public int deleteTeacherCourse(Map param);

    public int updatePermissionByTIDAndCID(Map param);

    public int addTeacherPermission(Map param);
    
    public int addTeacherPermission_author(Map param);
    
    public int addTeacherPermission_authors(Map param);

    public int addTeacherCourse(Map param);

    public List<Permission> findPerByUIDAndCID(Map param);
    
    public List<Permission> getQuestionPermissionsByUIDAndCID(Map param);
    
    public int addTeacherPaperPermission(Map param);
    
    public List<Permission> findPaperPerByUIDAndEID(Map param);
    
    public int addTeacherBPaperPermission(Map param);
    
    public List<Map<String, Object>> getPaperPermission4Course();
    
    public List<Map<String, Object>> getPermissionByCourseOffered(Map param);
    
    public List<Permission> checkPermissionsByUID_PID(Map param);
    
    public List<Map<String,Object>> findPaperCorrectPer2(Map param);
    
    public List<Map<String,Object>> findRolePermission();
}
