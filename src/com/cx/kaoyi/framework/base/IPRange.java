package com.cx.kaoyi.framework.base;

import java.util.Map;

public class IPRange {
    private final long start;
    private final long end;
    private final String id;

    private IPRange(String id, long start, long end) {
        this.id = id;
        this.start = start;
        this.end = end;
    }

    public String getId() {
        return id;
    }

    public boolean contains(String ip) {
        long v = ipToLong(ip);
        return v >= start && v <= end;
    }

    public static IPRange fromMap(Map<String,Object> rec) {
        String id    = String.valueOf(rec.get("ID"));
        String minIp = rec.get("MINIP").toString();
        String maxIp = rec.get("MAXIP").toString();
        return new IPRange(id, ipToLong(minIp), ipToLong(maxIp));
    }

    private static long ipToLong(String ip) {
        String[] parts = ip.split("\\.");
        long num = 0;
        for (String p : parts) {
            num = (num << 8) | (Integer.parseInt(p) & 0xFF);
        }
        return num;
    }
}
