package com.cx.kaoyi.framework.cache;

import java.net.URL;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.cx.kaoyi.framework.utils.Utils;
import com.cx.kaoyi.framework.utils.serialize.KryoPoolUtils;
import org.apache.logging.log4j.Logger;
import org.apache.logging.log4j.LogManager;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

/**
 * 本地缓存，基于ehcache实现
 *
 */
public class LocalCache {

	private static CacheManager cacheManager;

	private static volatile Object locker = new Object();
	private static final Logger log = LogManager.getLogger(LocalCache.class);

	static {
		URL url = LocalCache.class.getClassLoader().getResource("resources/ehcache/ehcache.xml");
		LocalCache.cacheManager = CacheManager.create(url);
	}

	private static final LocalCache instance = new LocalCache();

	public static LocalCache getInstance() {
		return instance;
	}

	static Cache getOrAddCache(String cacheName) {
		Cache cache = cacheManager.getCache(cacheName);
		if (cache == null) {
			synchronized (locker) {
				cache = cacheManager.getCache(cacheName);
				if (cache == null) {
					log.warn("Could not find cache config [" + cacheName + "], using default.");
					cacheManager.addCacheIfAbsent(cacheName);
					cache = cacheManager.getCache(cacheName);
					log.debug("Cache [" + cacheName + "] started.");
				}
			}
		}
		return cache;
	}

	public <T> T get(String cacheName, Object key) {
		Element element = getOrAddCache(cacheName).get(key);
		if (element == null) return null;
		Object rawValue = element.getObjectValue();
		Object safeValue = KryoPoolUtils.deepCopy(rawValue); //深拷贝，避免引用污染
		return (T) safeValue;
	}

	public <T> T getRaw(String cacheName, Object key) {
		Element element = getOrAddCache(cacheName).get(key);
		if (element == null) return null;
		//全局都用它的引用
		return (T) element.getObjectValue();
	}

	
	public void set(String cacheName, Object key, Object value) {
		// 先深拷贝一次，保证缓存里存的是快照
		Object safeValue = KryoPoolUtils.deepCopy(value);
		getOrAddCache(cacheName).put(new Element(key, safeValue));
	}

	public void setRaw(String cacheName, Object key, Object value) {
		//全局都用它的引用
		getOrAddCache(cacheName).put(new Element(key, value));
	}

	
	public void evict(String cacheName, Object key) {
		getOrAddCache(cacheName).remove(key);
	}

	
	public void evictByPrefix(String cacheName, String keyPrefix) {

		Cache cache = getOrAddCache(cacheName);
		List<String> keys = cache.getKeys();          // Ehcache 已把 key 序列化为 List
		for (Object kObj : keys) {
			String k = String.valueOf(kObj);
			if (k.startsWith(keyPrefix)) {
				cache.remove(k);
			}
		}
	}


	
	public void removeAll(String cacheName) {
		getOrAddCache(cacheName).removeAll();
	}

	
	public List keys(String cacheName) {
		return getOrAddCache(cacheName).getKeys();
	}

	
	public synchronized boolean getOrSet(String cacheName, String key, Object value) {
		if(get(cacheName,key)!=null){
			return true;
		}
		set(cacheName,key,value);
		return false;
	}

	
	public void setMap(String cacheName, String key, Map<String, Object> map) { //保留深拷贝是为了操作map线程安全
		// 深拷贝保证线程隔离
		Map<String, Object> safeMap = KryoPoolUtils.deepCopy(map);
		getOrAddCache(cacheName).put(new Element(key, safeMap));
	}

	
	public void setMap(String cacheName, String key, Map<String, Object> map, boolean keepMapKeyCase) { //保留深拷贝是为了操作map线程安全
		// 深拷贝保证线程隔离
		if(!keepMapKeyCase){
			map = Utils.replaceKeysToUpperCase(map);
		}
		Map<String, Object> safeMap = KryoPoolUtils.deepCopy(map);
		getOrAddCache(cacheName).put(new Element(key, safeMap));
	}

	
	public Map<String, Object> getMap(String cacheName, String key) {
		Element element = getOrAddCache(cacheName).get(key);
		if (element == null) {
			return null;
		}
		Map<String, Object> raw = (Map<String, Object>) element.getObjectValue();
		return KryoPoolUtils.deepCopy(raw); // 返回副本，防止外部修改
	}

	/* ========== 新增实现：单字段读写 ========== */

	
	public <T> T getMapField(String cacheName, String key, String field, Class<T> clazz) {
		Element element = getOrAddCache(cacheName).get(key);
		if (element == null) {
			return null;
		}
		Map<String, Object> raw = (Map<String, Object>) element.getObjectValue();
		Object value = raw.get(field);
		return value == null ? null : (T) KryoPoolUtils.deepCopy(value);
	}

	
	public void setMapField(String cacheName, String key, String field, Object value) { //保留深拷贝是为了操作map线程安全
		Cache cache = getOrAddCache(cacheName);
		Element element = cache.get(key);

		Map<String, Object> map;
		if (element == null) {
			map = new HashMap<>();
		} else {
			map = KryoPoolUtils.deepCopy((Map<String, Object>) element.getObjectValue());
		}
		map.put(field, KryoPoolUtils.deepCopy(value));

		cache.put(new Element(key, map));
	}

	
	public void setMapField(String cacheName, String key, String field, Object value, boolean keepMapKeyCase) { //保留深拷贝是为了操作map线程安全
		Cache cache = getOrAddCache(cacheName);
		Element element = cache.get(key);

		Map<String, Object> map;
		if (element == null) {
			map = new HashMap<>();
		} else {
			map = KryoPoolUtils.deepCopy((Map<String, Object>) element.getObjectValue());
		}
		if(!keepMapKeyCase){
			field = field.toUpperCase();
		}
		map.put(field, KryoPoolUtils.deepCopy(value));

		cache.put(new Element(key, map));
	}

	
	public void setMapFields(String cacheName, String key, Map<String, Object> fieldsToPut, boolean keepMapKeyCase) {
		if (fieldsToPut == null || fieldsToPut.isEmpty()) return;

		Cache cache = getOrAddCache(cacheName);
		Element element = cache.get(key);

		Map<String, Object> map;
		if (element == null) {
			map = new HashMap<>();
		} else {
			map = KryoPoolUtils.deepCopy((Map<String, Object>) element.getObjectValue());
		}
		// 合并：深拷贝各字段，避免外部持引用
		if(!keepMapKeyCase){
			fieldsToPut.forEach((f, v) -> map.put(f.toUpperCase(), KryoPoolUtils.deepCopy(v)));
		}else {
			fieldsToPut.forEach((f, v) -> map.put(f, KryoPoolUtils.deepCopy(v)));
		}

		cache.put(new Element(key, map));
	}

	
	public void setMapFields(String cacheName, String key, Map<String, Object> fieldsToPut) {
		if (fieldsToPut == null || fieldsToPut.isEmpty()) return;

		Cache cache = getOrAddCache(cacheName);
		Element element = cache.get(key);

		Map<String, Object> map;
		if (element == null) {
			map = new HashMap<>();
		} else {
			map = KryoPoolUtils.deepCopy((Map<String, Object>) element.getObjectValue());
		}
		// 合并：深拷贝各字段，避免外部持引用
		fieldsToPut.forEach((f, v) -> map.put(f, KryoPoolUtils.deepCopy(v)));

		cache.put(new Element(key, map));
	}

	
	public void removeMapField(String cacheName, String key, String field) { //保留深拷贝是为了操作map线程安全
		Cache cache = getOrAddCache(cacheName);
		Element element = cache.get(key);
		if (element == null) {
			return;
		}
		Map<String, Object> map = KryoPoolUtils.deepCopy((Map<String, Object>) element.getObjectValue());
		map.remove(field);

		if (map.isEmpty()) {
			cache.remove(key);          // 整个 Map 已空，干脆删 Key
		} else {
			cache.put(new Element(key, map));
		}
	}
}