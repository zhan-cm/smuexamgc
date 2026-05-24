package com.cx.kaoyi.framework.base;

import org.apache.ibatis.session.ExecutorType;
import org.apache.ibatis.session.RowBounds;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;

import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

/**
 * 基础service
 */
public class BaseService {

	@Autowired
	protected DaoHelper daoHelper;

	//获取mybatis的Session,可用于获取Connection
	public SqlSession getSqlSession() {
		return this.daoHelper.getSqlSession();
	}

	//获取Connection，类比jdbc的Connection（与数据库的连接）
	public Connection getConnection() {
		return getSqlSession().getConnection();
	}

	//删除
	public <T> int delete(String _mybitsId, T obj) {
		return getSqlSession().delete(_mybitsId, obj);
	}

	//插入
	public <T> int insert(String _mybitsId, T obj) {
		return getSqlSession().insert(_mybitsId, obj);
	}

	public <T> int insertBatch(String _mybitsId, T obj, int batchSize) {
		int affectedRows = 0;
		if (obj instanceof List) {
			List<?> list = (List<?>) obj;
			int total = list.size();
			for (int i = 0; i < total; i += batchSize) { // 分批插入
				int end = Math.min(total, i + batchSize);
				List<?> batchList = list.subList(i, end);
				affectedRows += getSqlSession().insert(_mybitsId, batchList);
			}
		} else {
			affectedRows += getSqlSession().insert(_mybitsId, obj);
		}
		return affectedRows;
	}

	public <T> int insertBatchHighAmount(String mybatisId, T obj, int batchSize) {
		//一次性批量插入很多行比如 800以上，推荐这个，PreparedStatement.addBatch() 累积起来再一次性发给数据库，batchSize在即便要插入clob时也可以设300以上
		//但注意这里虽然失败了会回滚，但是sqlsession是从sqlsessionFactory拿出来新的连接（所以还会多耗一条连接），如果commit成功了，别的sql失败了这里可回滚不了
		if (obj == null) return 0;
		SqlSession session = null;
		try {
			session = daoHelper.getSqlSessionFactory().openSession(ExecutorType.BATCH, false);
			if (!(obj instanceof List)) {
				session.insert(mybatisId, obj);
				session.flushStatements();
				session.commit();
				return 1;
			}
			List<?> list = (List<?>) obj;
			if (list.isEmpty()) return 0;
			if (batchSize <= 0) batchSize = 300;

			int pending = 0;
			for (Object row : list) {
				session.insert(mybatisId, row);
				if (++pending % batchSize == 0) {
					session.flushStatements();
					session.clearCache();
				}
			}
			session.flushStatements();
			session.clearCache();
			session.commit();
			return list.size();
		} catch (Exception e) {
			if (session != null) {
				try { session.rollback(); } catch (Exception ignore) {}
			}
			throw e;
		} finally {
			if (session != null) {
				try { session.close(); } catch (Exception ignore) {}
			}
		}
	}

	//更新
	public <T> int update(String _mybitsId, T obj) {
		return getSqlSession().update(_mybitsId, obj);
	}

	public <T> int updateBatch(String _mybitsId, T obj, int batchSize) {
		int affectedRows = 0;

		if (obj instanceof List) {
			List<?> list = (List<?>) obj;
			int total = list.size();

			for (int i = 0; i < total; i += batchSize) {
				int end = Math.min(total, i + batchSize);
				List<?> batchList = list.subList(i, end);
				affectedRows += getSqlSession().update(_mybitsId, batchList);
			}
		} else {
			affectedRows = getSqlSession().update(_mybitsId, obj);
		}

		return affectedRows;
	}


	//分页查询
	public <T> List<T> query(String _mybitsId, Map<String, Object> _params, RowBounds rb) {
		return getSqlSession().selectList(_mybitsId, _params, rb);
	}

	public <T> List<T> queryList(String _mybitsId) {
		return getSqlSession().selectList(_mybitsId);
	}

	public <T> List<T> queryList(String _mybitsId, Object _params) {
		return getSqlSession().selectList(_mybitsId, _params);
	}

	public <T> List<T> queryList(String mybatisId, String param) {
		return getSqlSession().selectList(mybatisId, param);
	}

	public <T> List<T> queryListByList(String mybatisId, List<?> list, int size) {
		List<T> result = new ArrayList<>();
		if (list == null || list.isEmpty()) return result;

		for (int i = 0; i < list.size(); i += size) {
			int end = Math.min(i + size, list.size());
			List<?> batch = list.subList(i, end);
			// 注意这里的泛型 O 由外面的接收类型推断
			List<T> part = this.queryList(mybatisId, batch);
			if (part != null && !part.isEmpty()) {
				result.addAll(part);
			}
		}
		return result;
	}


	//查询，结果为集合列表，查询参数为字符串
	public List<Map<String, Object>> query(String _mybitsId, Object _params) {
		return getSqlSession().selectList(_mybitsId, _params);
	}
	
	//查询，结果为集合列表
	public List<Map<String, Object>> query(String _mybitsId) {
		return getSqlSession().selectList(_mybitsId);
	}

	public <T> T queryOne(String _mybitsId, Object object) {
		return getSqlSession().selectOne(_mybitsId, object);
	}

	public <T> T queryOne(String _mybitsId) {
		return getSqlSession().selectOne(_mybitsId);
	}

}
