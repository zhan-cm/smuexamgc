package com.cx.kaoyi.business.service.serviceImpl;

import com.cx.kaoyi.business.dao.UserDao;
import com.cx.kaoyi.business.domain.User;
import com.cx.kaoyi.business.service.PasswordHelper;
import com.cx.kaoyi.business.service.PermissionService;
import com.cx.kaoyi.business.service.UserService;
import com.cx.kaoyi.framework.base.BaseService;


import com.cx.kaoyi.framework.cache.LocalCache;

import com.cx.kaoyi.framework.utils.PageUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.servlet.ServletContext;
import java.util.*;


@Service("userService")
public class UserServiceImpl extends BaseService implements UserService {
    @Autowired
    private UserDao userDao;
    @Autowired
    private PasswordHelper passwordHelper;
    @Autowired
    private PermissionService permissionService;
	@Autowired
	private ServletContext servletContext;
    
    public static String namespace = "com.cx.kaoyi.business.dao.UserDao";

    
    private static final Set ALLPERMISSION = new HashSet() {{
    	add("*:*:*");
	}}; 
    /**
     * 创建用户
     * @param user
     */
    public int createUser(User user) {
        //加密密码
        passwordHelper.encryptPassword(user);
        return userDao.createUser(user);
    }

    @Override
    public int updateUser(User user) {
//		passwordHelper.encryptPassword(user);
        return userDao.updateUser(user);
    }

	public int alterUserState(User user){
		return update(namespace + ".alterUserState", user);
	}
    
    @Override
    public int resetPass(User user) {
    	User u = findOne(user.getId());
    	if(!user.getPassword().equals(u.getPassword())){
    		passwordHelper.encryptPassword(user);
    	}
    	return userDao.resetPassword(user);
    }

    @Override
    public void deleteUser(String tid) {
		delete(namespace + ".deleteUserTeacherClassPermission", tid);
		delete(namespace + ".deleteUserTeacherQuestionPermission", tid);
		delete(namespace + ".deleteUserTeacherScoreReviewPermission", tid);
		delete(namespace + ".deleteUserPaperPermission", tid);
		delete(namespace + ".deleteUserCoursePermission", tid);
		delete(namespace + ".deleteUser", tid);
    }

    /**
     * 修改密码
     * @param userId
     * @param newPassword
     */
    public void changePassword(String userId, String newPassword) {
        User user =userDao.findOne(userId);
        user.setPassword(newPassword);
        passwordHelper.encryptPassword(user);
        userDao.updateUser(user);
    }

    @Override
    public User findOne(String userId) {
        return userDao.findOne(userId);
    }

    /**
     * 根据用户名查找用户
     * @param username
     * @return
     */
    public User findByUsername(String username) {
        return userDao.findByUsername(username);
    }

	public List<User> findByEmployeeNum(String num) {
		return userDao.findByEmployeeNum(num);
	}

	public User findByUsername_includeAll(String username) {
		return userDao.findByUsername_includeAll(username);
	}
	
	public User findByUserIdcard(String idcard) {
		return userDao.findByUserIdcard(idcard);
	}
    
    /**
     * 根据用户真实姓名查找用户
     * @param realname
     * @return
     */
    public List<Map<String,Object>> findByRealname(String realname) {
        return userDao.findByRealname(realname);
    }

    /**
     * 根据用户名查找其角色
     * @param username
     * @return
     */
    public Set<String> findRoles(String username) {
		LocalCache cache = LocalCache.getInstance();
		Set<String> element = cache.get("roles", username);
		if (element != null) {
		    return element;
		} else {
			Set<String> rtn=userDao.findRoles(username);
			cache.set("roles",username,rtn);
			return rtn;
		}
    }

    /**
     * 根据用户名查找其权限
     * @param username
     * @return
     */
    public Set<String> findPermissions(String username) {
        User user = findByUsername(username);
        if(user == null) {
            return Collections.EMPTY_SET;
        }
        //管理员获得所有权限
        if(user.getRoleID().equals("1")){
        	return ALLPERMISSION;        
        }
        //Set<String> s= permissionService.findPermissionsByUID(uid);
        return permissionService.findPermissionsByUID(user.getId());
        //return findPermissionsByUID(user.getId());
    }
    
    /*
    public Set<String> findPermissionsByUID(String uid) {
        User user = findOne(uid);
        if(user == null) {
            return Collections.EMPTY_SET;
        }
        if(findOne(uid).getRoleID().equals("0")){
        	return ALLPERMISSION;
        }
        //Set<String> s= permissionService.findPermissionsByUID(uid);
        return permissionService.findPermissionsByUID(uid);
    }*/
	
	@Override
	public  List<String> getPermissionIdByType(String param) {
		// TODO Auto-generated method stub
		return queryList(namespace + ".getPermissionIdByType", param);
	}
	
	@Override
	public List<Map<String, Object>> getPermissionsByType(Map param) {
		// TODO Auto-generated method stub
		return query(namespace + ".getPermissionsByType", param);
	}



	@Override
	public List<Map<String, Object>> getCourseByUID(String uid) {
		Map param=new HashMap();
		param.put("uid",uid);
		return userDao.getCourseByUID(param);
	}
	
	@Override
	public List<String> getPermissionsCid(Map map) {		    
		return queryList(namespace + ".getPermissionsCid", map);
	}
	
	@Override
	public List<Map<String, Object>> getCourseByUID(Map param,PageUtils pu) {
		return query(namespace+".getCourseByUID", param, pu.getRb());
	}
	
	public List<String> getTeacherTid(Map param){
		return queryList(namespace+".getTeacherTid",param);
	}

	@Override
	public String getCourseByUIDCount(String uid) {
		Map param = new HashMap();
		param.put("uid", uid);
		return query(namespace+".getCourseByUIDCount", param).get(0).get("NUM").toString();
	}
	
	@Override
	public void updatePermissions(Map m, String username) {
		LocalCache cache = LocalCache.getInstance();
		cache.removeAll("permissions");
		String uid = (String) m.get("uid");
		ArrayList alist  =  (ArrayList) m.get("data");
		
		for(int i = 0 ; i< alist.size(); i++){
			LinkedHashMap per = (LinkedHashMap) alist.get(i);
			String cid = (String) per.get("cid");
			ArrayList cper = (ArrayList) per.get("cper");
			Map param = new HashMap();
			param.put("uid", uid);
			param.put("cid", cid);
			param.put("cper", cper);
			if(cper.size() == 0){
				permissionService.deleteTeacherCourse(param);
				//当没有选中权限时顺带删除teacher_permission中用户权限
				permissionService.deletePermissionByTIDAndCID(param);
			}else{
				//先清空所有权限
				permissionService.deletePermissionByTIDAndCID(param);
				param.put("state", 0);
				permissionService.addTeacherCourse(param);
				permissionService.updatePermissionByTIDAndCID(param);
				permissionService.addTeacherPermission(param);
			}
		}
	}
	
	@Override
	public List<Map<String, Object>> getCourseByUIDFromUnit(Map param) {
		return userDao.getCourseByUIDFromUnit(param);
	}

	@Override
	public List<Map<String, Object>> getCourseByUIDFromUnit(Map param,PageUtils pu) {
		return query(namespace+".getCourseByUIDFromUnit", param, pu.getRb());
	}
	
	@Override
	public String getCourseByUIDFromUnitCount(Map param) {
		return query(namespace+".getCourseByUIDFromUnitCount", param).get(0).get("NUM").toString();
	}

	@Override
	public int updateLoginTime(User user) {
		return userDao.updateLoginTime(user);
	}
	
	@Override
	public List<Map<String, Object>> getCourseByUIDFromOtherUnit(Map param) {
		return userDao.getCourseByUIDFromOtherUnit(param);
	}

	@Override
	public List<Map<String, Object>> getCourseByUIDFromOtherUnit(Map param,PageUtils pu) {
		return query(namespace+".getCourseByUIDFromOtherUnit", param, pu.getRb());
	}
	
	@Override
	public String getCourseByUIDFromOtherUnitCount(Map param) {
		return query(namespace+".getCourseByUIDFromOtherUnitCount", param).get(0).get("NUM").toString();
	}

	@Override
	public Set<String> findAllCids() {
		return userDao.findAllCids();
	}

	@Override
	public Set<String> getCourseOfUnit(Map param) {
		return userDao.getCourseOfUnit(param);
	}
	
	@Override
	public Set<String> findCids(String uid) {
		return userDao.findCids(uid);
	}

	@Override
	public Set<String> findAllDelQueCids(){
		return userDao.findAllDelQueCids();
	}

	@Override
	public Set<String> findDelQueCids(Map map){
		return userDao.findDelQueCids(map);
	}

	@Override
	public Set<String> findAllDelCids() {
		return userDao.findAllDelCids();
	}
	
	@Override
	public Set<String> findDelCids(String uid) {
		return userDao.findDelCids(uid);
	}

	@Override
	public List<Map<String, Object>> findSuperiors(Map param) {
		return userDao.findSuperiors(param);
	}
	
	@Override
	public List<Map<String, Object>> findSuperiors_cq(Map param) {
		return userDao.findSuperiors_cq(param);
	}
	
	@Override
	public List<Map<String, Object>> findSuperiors4import(Map param) {
		return userDao.findSuperiors4import(param);
	}

	@Override
	public List<User> getUserList(Map param,PageUtils pu) {
		return userDao.findByRole(param,pu.getRb());
	}

	@Override
	public String getTeacherCount(Map param) {
		return userDao.getTeacherCount(param).get(0).get("TAR").toString();
	}
	
	@Override
	public List<Map<String, Object>> getUserPermission(String tid) {
		return userDao.getUserPermission(tid);
	}

	@Override
	public int delEditUser(String tid) {
		return userDao.delEditUser(tid);
	}

	@Override
	public int insertEditUser(String tid) {
		return userDao.insertEditUser(tid);
	}

	@Override
	public Set<String> findCids4Paper(String uid) {
		return userDao.findCids4Paper(uid);
	}

	@Override
	public boolean isExistPaperAddPermission(Map param) {
		int s = userDao.isExistPaperAddPermission(param);
		if(s==0){
			return false;
		}
		return true;
	}

	@Override
	public int updateUserXls(User user) {
		// TODO Auto-generated method stub
		passwordHelper.encryptPassword(user);
		return userDao.updateUserXls(user);
	}

	@Override
	public List<User> findTeacherByPer(Map map, PageUtils pu) {
		// TODO Auto-generated method stub
		return userDao.findTeacherByPer(map, pu.getRb());
	}

	@Override
	public String findTeacherByPerCount(Map map) {
		// TODO Auto-generated method stub
		return userDao.findTeacherByPerCount(map);
	}

	@Override
	public List<User> findTeacherAddPer(Map map, PageUtils pu) {
		// TODO Auto-generated method stub
		return userDao.findTeacherAddPer(map, pu.getRb());
	}

	@Override
	public String findTeacherAddPerCount(Map map) {
		// TODO Auto-generated method stub
		return userDao.findTeacherAddPerCount(map);
	}

	@Override
	public User findUserByUid(String uid) {
		// TODO Auto-generated method stub
		return userDao.findOne(uid);
	}

	@Override
	public List<User> getAllTeacher() {
		return userDao.getAllTeacher();
	}

	@Override
	public List<Map<String, Object>> getTeacherInCourse(Map param) {
		String userid = (String) param.get("uid");
		List<Map<String, Object>> ls = query(namespace + ".getTeacherInCourse", param);
		List<Map<String, Object>> roles = (List<Map<String, Object>>) servletContext.getAttribute("roles");
		Map<String, String> roleMap = new HashMap<>();
		for(Map<String, Object> r : roles){
			roleMap.put(String.valueOf(r.get("ID")), String.valueOf(r.get("CNAME")));
		}
		List<Map<String, Object>> pls = query(namespace + ".getTeacherInCoursePermission", param);

		List<Map<String, Object>> rtn = new ArrayList<>();
		for(Map<String, Object> m : ls){
			String rid = String.valueOf(m.get("RID"));
			String tid = String.valueOf(m.get("TID"));
			if("1".equals(rid) || userid.equals(tid)){
				continue;
			}
			m.put("RNAME", roleMap.get(m.get("RID")));
			List<String> per = new ArrayList<>();
			for(Map mm:pls) {
				if(tid.equals(String.valueOf(mm.get("TID")))) {
					per.add(String.valueOf(mm.get("PID")));
				}
			}
			m.put("per", per);
			rtn.add(m);
		}
		return rtn;
	}

	@Override
	public List<Map<String,Object>> getUserEmail(String username) {
		return query(namespace + ".getUserEmail", username);
	}
	
	@Override
	public int updateEmailLock(Map param){
		return update(namespace+".updateEmailLock",param);
	}

	public List<Map<String,Object>> getUsersByName(String name){
		Map<String,Object> param=new HashMap<String,Object>();
		param.put("name", name);
		return query(namespace+".getUsersByName",param);
	}
	
	public int checkLoginPer(String tid){
		List<Map<String,Object>> list=query(namespace+".checkLoginPer",tid);
		if(list!=null&&list.size()>0){
			return 1;
		}else{
			return 0;
		}
	}

	@Override
	public String getUserIdByName(String name) {
		// TODO Auto-generated method stub
		List<Map<String,Object>> ls = query(namespace + ".getUserIdByName", name);
		if(ls.size() > 0) {
			return ls.get(0).get("ID").toString();
		}else {
			return null;
		}
	}
	
	@Override
	public String getUserIdByIdcard(String idcard) {
		// TODO Auto-generated method stub
		List<Map<String,Object>> ls = query(namespace + ".getUserIdByIdcard", idcard);
		if(ls.size() > 0) {
			return ls.get(0).get("ID").toString();
		}else {
			return null;
		}
	}

	@Override
	public int updateUserWithNoPass(User u) {
		return userDao.updateUser(u);
	}
	
	@Override
	public List<Map<String,Object>> getCourseByDept(String uid){
		return query(namespace + ".getCourseByDept", uid);
	}
	
	@Override
	public List<Map<String,Object>> getCourseByUnit(String uid){
		return query(namespace + ".getCourseByUnit", uid);
	}
	
	@Override
	public int addTeacherPermission(Map param) {
		return insert(namespace + ".addTeacherPermission", param);
	}
	
	@Override
	public int updateUserEmail_lock(String id) {
		return update(namespace + ".updateUserEmail_lock",id);
	}

	@Override
	public User findByWxUnionID(String wxUnionID){
		return userDao.findByWxUnionID(wxUnionID);
	}

	@Override
	public User findByTel(String tel){
		List<User> userList = userDao.findByTel(tel);
		if(userList==null){
			return null;
		}
		User user = null;
		for(User u : userList){
			if(user!=null){
				if(user.getLoginTime()==null){
					user = u;
				}else{
					if(u.getLoginTime()!=null && u.getLoginTime().after(user.getLoginTime())){
						user = u;
					}
				}
			}else{
				user = u;
			}
		}
		return user;
	}

	@Override
	public List<User> findAllTeacherPer(Map map, PageUtils pu) {
		return userDao.findAllTeacherPer(map, pu.getRb());
	}

	@Override
	public String findAllTeacherPerCount(Map map) {
		return userDao.findAllTeacherPerCount(map);
	}
}
