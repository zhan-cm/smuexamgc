package com.cx.kaoyi.business.service.serviceImpl;

import com.cx.kaoyi.business.dao.PermissionDao;
import com.cx.kaoyi.business.domain.Permission;
import com.cx.kaoyi.business.service.PermissionService;
import com.cx.kaoyi.business.service.SystemService;
import com.cx.kaoyi.framework.cache.LocalCache;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import javax.servlet.http.HttpServletRequest;
import java.util.*;

@Service("permissionService")
public class PermissionServiceImpl implements PermissionService {

	@Autowired
	private SystemService systemService;
    
	@Autowired
    private PermissionDao permissionDao;

    public int createPermission(Permission permission) {
		LocalCache cache = LocalCache.getInstance();
		cache.removeAll("permissions");
        return permissionDao.createPermission(permission);
    }

    public void deletePermission(Long permissionId) {
		LocalCache cache = LocalCache.getInstance();
		cache.removeAll("permissions");
        permissionDao.deletePermission(permissionId);
    }

	@Override
	public Set<String> findPermissionsByUID(String userId) {
		// TODO Auto-generated method stub
		return permissionDao.findPermissionsByUID(userId);
	}

	@Override
	public List<Permission> findPerByRID(String rid) {
		LocalCache cache = LocalCache.getInstance();
		List<Permission> permissions = cache.get("permissions", "role_per_"+rid);
		if(permissions==null){
			permissions = permissionDao.findPerByRID(rid);
			cache.set("permissions", "role_per_"+rid,permissions);
		}
		return permissions;
	}

	@Override
	public int deletePermissionByTIDAndCID(Map param) {
		LocalCache cache = LocalCache.getInstance();
		cache.removeAll("permissions");
		return permissionDao.deletePermissionByTIDAndCID(param);
	}

	@Override
	public int updatePermissionByTIDAndCID(Map param) {
		LocalCache cache = LocalCache.getInstance();
		cache.removeAll("permissions");
		return permissionDao.updatePermissionByTIDAndCID(param);
	}

	@Override
	public int deleteTeacherCourse(Map param) {
		return permissionDao.deleteTeacherCourse(param);
	}

	@Override
	public int addTeacherPermission(Map param) {
		LocalCache cache = LocalCache.getInstance();
		cache.removeAll("permissions");
		return permissionDao.addTeacherPermission(param);
	}

	@Override
	public int addTeacherCourse(Map param) {
		// TODO Auto-generated method stub
		return permissionDao.addTeacherCourse(param);
	}

	@Override
	public List<Permission> findPerByUIDAndCID(Map param, String uid_cid) {
		LocalCache cache = LocalCache.getInstance();
		List<Permission> cachedPermissions = cache.get("permissions", "uc_" + uid_cid);
		if (cachedPermissions != null) {
			return cachedPermissions;
		} else {
			List<Permission> rtn = permissionDao.findPerByUIDAndCID(param);
			cache.set("permissions", "uc_" + uid_cid, rtn);
			return rtn;
		}
	}

	@Override
	public int addTeacherPaperPermission(Map param,String uid) {
		return permissionDao.addTeacherPaperPermission(param);
	}

	@Override
	public List<Permission> findPaperPerByUIDAndEID(Map param,String uid_eid) {
		LocalCache cache = LocalCache.getInstance();
		List<Permission> rtn = cache.get("permissions","uePermission_"+uid_eid);
		if (rtn != null) {
		    return rtn;
		} else {
			rtn = permissionDao.findPaperPerByUIDAndEID(param);
			cache.set("permissions", "uePermission_"+uid_eid, rtn);
			return rtn;
		}
	}

	@Override
	public int addTeacherBPaperPermission(Map param) {
		return permissionDao.addTeacherBPaperPermission(param);
	}
	
	public List<Map<String, Object>> getPaperPermission4Course(){
		return permissionDao.getPaperPermission4Course();
	}
	
//	@Override
//	public List<Map<String, Object>> getPermissionByCourseOffered(Map param) {
//		// TODO Auto-generated method stub
//		return permissionDao.getPermissionByCourseOffered(param);
//	}

	@Override
	public List<Permission> checkPermissionsByUID_PID(Map param,String uid_pid) {
		LocalCache cache = LocalCache.getInstance();
		List<Permission> rtn = cache.get("permissions", "up_"+uid_pid);
		if (rtn != null) {
		    return rtn;
		} else {
			rtn=permissionDao.checkPermissionsByUID_PID(param);
			cache.set("permissions", "up_"+uid_pid, rtn);
			return rtn;
		}
	}
	
	@Override
	public List<Permission> getPermissionsByRID_uid_cid(String rid,String uid,String cid) {
		Map map = new HashMap();
		map.put("uid", uid);
		map.put("cid", cid);
//		List<Permission> existsPer=findPerByUIDAndCID(map,uid+"_"+cid);
		List<Permission> existsPer=permissionDao.findPerByUIDAndCID(map);
		List<Permission> perList=permissionDao.findPerByRID(rid);
		for(Permission vo:existsPer){
			boolean b=false;
			for(int i=0;i<perList.size();i++){
				if(vo.getId().equals(perList.get(i).getId())){
					b=true;
					break;
				}
			}
			if(!b){
				perList.add(vo);
			}
		}
		return perList;
	}

	@Override
	public int updateCoursePermission(Map map) {
//    	String username= (String) map.get("username");
    	List<Map<String,Object>> permission_old= (List<Map<String, Object>>) map.get("permission_old");
		String cid = (String) map.get("cid");

		List<Map<String, Object>> system_permission= (List<Map<String, Object>>) map.get("system_permission");
		Map<String, String> idToNameMap = new HashMap<>();
		for (Map<String, Object> sm : system_permission) {
			String id = String.valueOf(sm.get("ID"));
			String name = (String) sm.get("NAME");
			idToNameMap.put(id, name);
		}

		LocalCache cache = LocalCache.getInstance();
		List<Map<String, Object>> ls = (List<Map<String, Object>>) map.get("data");
		Map log = new HashMap();
		log.put("cid", cid);

		List<Map<String,Object>> permission_new=new ArrayList<Map<String,Object>>();
		for(Map m:ls) {
			if (cache != null) {
	            cache.evict("permissions","uc_"+m.get("uid")+"_"+cid);
	            cache.evict("permissions","up_"+m.get("uid")+"_"+cid);
	        }
			m.put("cid", cid);
			List per = (List) m.get("cper");
			if(per.size() == 0) {
				deleteTeacherCourse(m);
				deletePermissionByTIDAndCID(m);
				log.put("content", "为“"+m.get("name")+"("+m.get("username")+")”在《"+map.get("cname")+"》课程，清空了所有权限。");
				systemService.addSysLog(log);
			}else {
				String tid=String.valueOf(m.get("uid"));
				List<String> cper= (List<String>) m.get("cper");
				List<String> pid_add=new ArrayList<String>();
				List<String> pid_del=new ArrayList<String>();
				for(Map<String,Object> pm:permission_old){
					if(tid.equals((String)pm.get("TID"))){
						List<String> per_old= (List<String>) pm.get("per");
						for(String pid:cper){
							if (!per_old.contains(pid)) {
								pid_add.add(pid);
							}
						}
						for(String pid:per_old){
							if (!cper.contains(pid)) {
								pid_del.add(pid);
							}

						}
					}
				}

				StringBuilder sb_add=new StringBuilder();
				for(String pid:pid_add){
					String name = idToNameMap.get(pid);
					if (name != null) {
						sb_add.append(name).append(",");
					}
				}

				StringBuilder sb_del=new StringBuilder();
				for(String pid:pid_del){
					String name = idToNameMap.get(pid);
					if (name != null) {
						sb_del.append(name).append(",");
					}
				}

				if (sb_add.length() > 0) {
					sb_add.deleteCharAt(sb_add.length() - 1);
				}
				if (sb_del.length() > 0) {
					sb_del.deleteCharAt(sb_del.length() - 1);
				}

				deletePermissionByTIDAndCID(m);
				m.put("state",0);
				addTeacherCourse(m);
				updatePermissionByTIDAndCID(m);
				addTeacherPermission(m);

				if(sb_add.length()>0||sb_del.length()>0){
					String logStr="为“"+m.get("name")+"("+m.get("username")+")”在《"+map.get("cname")+"》课程";
					if(sb_add.length()>0){
						logStr+="，增加了权限："+sb_add.toString();
					}
					if(sb_del.length()>0){
						logStr+="，减少了权限："+sb_del.toString();
					}
					log.put("content", logStr);
					systemService.addSysLog(log);
				}
				Map<String,Object> pmap=new HashMap<String,Object>();
				pmap.put("TID",tid);
				pmap.put("per",cper);
				permission_new.add(pmap);
			}
		}
		HttpServletRequest request = ((ServletRequestAttributes) RequestContextHolder.getRequestAttributes()).getRequest();
		request.getSession().setAttribute(cid+"_teacher_permission",permission_new);
		return 0;
	}
	
	@Override
	public List<Map<String,Object>> findPaperCorrectPer2(Map param) {
		return permissionDao.findPaperCorrectPer2(param);
	}
	
	@Override
	public List<Map<String,Object>> findRolePermission(){
		return permissionDao.findRolePermission(); 
	}
}
