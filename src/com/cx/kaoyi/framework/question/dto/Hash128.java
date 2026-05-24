package com.cx.kaoyi.framework.question.dto;

import com.fasterxml.jackson.annotation.JsonProperty;

import java.io.Serializable;
import java.nio.ByteBuffer;
import java.util.UUID;

public final class Hash128 implements Serializable, Comparable<Hash128> {
    public final long hi;   // 高64位
    public final long lo;   // 低64位

    public Hash128(long hi, long lo) { this.hi = hi; this.lo = lo; }

    @JsonProperty("hex")
    public String getHex(){ return toHex(); }

    /** ZAH 0.16 的 xx128() 返回两个 long。常见约定是 {lo, hi}，你可统一成自己的顺序即可。*/
    public static Hash128 fromXX128(long[] h) {
        if (h == null || h.length < 2) throw new IllegalArgumentException("xx128 result must have length 2");
        return new Hash128(/*hi=*/h[1], /*lo=*/h[0]);
    }

    public static Hash128 fromHex(String hex) {
        if (hex == null) {
            throw new IllegalArgumentException("hex is null");
        }
        String s = hex.trim();
        if (s.length() != 32) {
            throw new IllegalArgumentException("Hash128 hex length must be 32, but was " + s.length());
        }
        long hi = Long.parseUnsignedLong(s.substring(0, 16), 16);
        long lo = Long.parseUnsignedLong(s.substring(16, 32), 16);
        return new Hash128(hi, lo);
    }

    @Override public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Hash128)) return false;
        Hash128 x = (Hash128) o;
        return hi == x.hi && lo == x.lo;
    }
    @Override public int hashCode() {
        return (int)(hi ^ (hi >>> 32) ^ lo ^ (lo >>> 32));
    }
    @Override public int compareTo(Hash128 o) {
        int c = Long.compare(this.hi, o.hi);
        return (c != 0) ? c : Long.compare(this.lo, o.lo);
    }

    public UUID toUUID() { return new UUID(hi, lo); }      // 方便打印/JSON
    public byte[] toBytes() {
        return ByteBuffer.allocate(16).putLong(hi).putLong(lo).array();
    }
    public String toHex() {
        byte[] b = toBytes();
        char[] out = new char[b.length * 2];
        final char[] HEX = "0123456789abcdef".toCharArray();
        for (int i=0, j=0; i<b.length; i++) { int v=b[i]&0xFF; out[j++]=HEX[v>>>4]; out[j++]=HEX[v&0x0F]; }
        return new String(out);
    }
}
