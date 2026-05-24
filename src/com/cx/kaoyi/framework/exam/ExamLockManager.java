package com.cx.kaoyi.framework.exam;

import java.util.concurrent.ConcurrentHashMap;

public final class ExamLockManager {

    // 预分配容量，比如 4096
    private static final ConcurrentHashMap<String, Object> LOCKS =
            new ConcurrentHashMap<>(4096);

    private ExamLockManager() {}

    private static String buildKey(String eid, String sid) {
        return eid + ":" + sid;
    }

    public static Object getLock(String eid, String sid) {
        if(eid==null || sid==null || "".equals(eid.trim()) || "".equals(sid.trim())){
            return new Object();
        }
        String key = buildKey(eid, sid);
        return LOCKS.computeIfAbsent(key, k -> new Object());
    }

    public static void clearExamLocks(String eid) {
        if(eid==null || "".equals(eid.trim())){
            return;
        }
        String prefix = eid + ":";
        LOCKS.keySet().removeIf(k -> k.startsWith(prefix));
    }

    public static void clearExamLock(String eid, String sid) {
        if(eid==null || sid==null || "".equals(eid.trim()) || "".equals(sid.trim())){
            return;
        }
        String key = buildKey(eid, sid);
        LOCKS.remove(key);
    }

    public static void clearAll() {
        LOCKS.clear();
    }
}
