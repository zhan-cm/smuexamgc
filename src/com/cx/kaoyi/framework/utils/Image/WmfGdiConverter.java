package com.cx.kaoyi.framework.utils.Image;

import com.sun.jna.Memory;
import com.sun.jna.Native;
import com.sun.jna.Pointer;
import com.sun.jna.ptr.IntByReference;
import com.sun.jna.ptr.PointerByReference;
import com.sun.jna.win32.W32APIOptions;
import com.sun.jna.platform.win32.*;
import com.sun.jna.platform.win32.WinDef.*;
import com.sun.jna.platform.win32.WinGDI.*;
import com.sun.jna.platform.win32.WinNT.HANDLE;

import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.RandomAccessFile;
import java.nio.ByteBuffer;
import java.nio.ByteOrder;
import java.nio.file.*;
import java.util.*;
import java.util.stream.Stream;

public final class WmfGdiConverter {

    private static String FONT_BASE; // WAR 解包后的 /resources/fonts 物理路径
    private static final Set<String> LOADED_FONT_FILES = Collections.synchronizedSet(new HashSet<>());
    private static final float PX96_SCALE_FACTOR = 1.1f; // 跟 WMF2SVG 代码保持一致：小图放大一点

    static {
        FONT_BASE = resolveFontBase();
    }

    private static String resolveFontBase() {
        try {
            // 注意：这里用 "" 而不是 "/"
            java.net.URL root = Thread.currentThread()
                    .getContextClassLoader()
                    .getResource("");  // e.g. file:/E:/.../WEB-INF/classes/
            if (root != null) {
                // 关键：通过 URI 转 Path，自动处理 Windows 盘符、URL 编码、斜杠方向等
                java.nio.file.Path classesDir = java.nio.file.Paths.get(root.toURI());
                java.nio.file.Path fontsDir = classesDir.resolve("resources").resolve("fonts").normalize();
                // 仅作可读性日志（可留可删）
                System.out.println("[fonts] resolved FONT_BASE = " + fontsDir);
                return fontsDir.toString();
            }
        } catch (Exception ignore) {
            // fall through
        }
        // 兜底：项目运行目录/resources/fonts
        java.nio.file.Path fallback = java.nio.file.Paths.get(
                System.getProperty("user.dir"), "resources", "fonts").normalize();
        System.out.println("[fonts] fallback FONT_BASE = " + fallback);
        return fallback.toString();
    }

    private WmfGdiConverter() {}

    /**
     * WMF -> PNG（Windows-only）
     * 1) 在 PlayMetaFile 前私有加载字体（支持 System Prop/Env 覆盖）
     * 2) 返回 map: { wPx, hPx }（基于 Placeable 头，按 96dpi*1.1 计算；无 Placeable 头则不返回这两项）
     */
    public static Map<String,String> convertWmfToPng(String wmfPath, String outPngPath, int targetDpi) throws Exception {
        if (!isWindows()) {
            throw new UnsupportedOperationException("WMF->PNG(GDI) 仅支持 Windows 环境。");
        }

        loadFontsFromFolderIfPresent(FONT_BASE);

        Map<String,String> meta = new HashMap<>();

        // 2) 读取 & 跳过 Placeable 头（22字节）
        byte[] all = readAll(wmfPath);
        PlaceableHeader apm = parsePlaceableHeader(all);
        int off = (apm != null ? 22 : 0);
        int len = all.length - off;
        if (len <= 0) throw new RuntimeException("无效 WMF：placeable 头后没有数据。");

        // 3) 从内存创建 HMETAFILE（支持 placeable）
        Memory mem = new Memory(len);
        mem.write(0, all, off, len);
        HMETAFILE hmf = GDI32X.INSTANCE.SetMetaFileBitsEx(len, mem);
        if (hmf == null || Pointer.nativeValue(hmf.getPointer()) == 0) {
            throw new RuntimeException("SetMetaFileBitsEx 失败：" + Kernel32Util.getLastErrorMessage());
        }

        // 4) 输出像素尺寸（用于 PNG）；并且计算 96dpi 下的 wPx/hPx（返回前端用）
        final int logicalW, logicalH;
        final int pxW, pxH;
        if (apm != null) {
            logicalW = apm.right - apm.left;
            logicalH = apm.bottom - apm.top;

            double inchW = logicalW / (double) apm.inch;
            double inchH = logicalH / (double) apm.inch;

            // PNG 实际像素，以目标 DPI 输出
            pxW = Math.max(1, (int)Math.ceil(inchW * targetDpi));
            pxH = Math.max(1, (int)Math.ceil(inchH * targetDpi));

            // 96dpi 的 CSS 像素（按你的逻辑再 *1.1 返回）
            double px96w = inchW * 96.0 * PX96_SCALE_FACTOR;
            double px96h = inchH * 96.0 * PX96_SCALE_FACTOR;
            meta.put("wPx", String.format(Locale.ROOT, "%.3f", px96w));
            meta.put("hPx", String.format(Locale.ROOT, "%.3f", px96h));
        } else {
            // 没有 placeable 头：PNG 兜底像素；logical 跟像素等同
            pxW = 1600; pxH = 1200;
            logicalW = pxW; logicalH = pxH;
            // 无 placeable 就不返回 wPx/hPx（你也可改成放默认值）
        }

        // 5) DC & DIB
        HDC hdcScreen = User32.INSTANCE.GetDC(null);
        if (hdcScreen == null) throw new RuntimeException("GetDC 失败");
        HDC hdcMem = GDI32.INSTANCE.CreateCompatibleDC(hdcScreen);
        if (hdcMem == null) {
            User32.INSTANCE.ReleaseDC(null, hdcScreen);
            throw new RuntimeException("CreateCompatibleDC 失败");
        }

        BITMAPINFO bmi = new BITMAPINFO();
        bmi.bmiHeader.biSize = bmi.bmiHeader.size();
        bmi.bmiHeader.biWidth = pxW;
        bmi.bmiHeader.biHeight = -pxH; // top-down
        bmi.bmiHeader.biPlanes = 1;
        bmi.bmiHeader.biBitCount = 32;
        bmi.bmiHeader.biCompression = WinGDI.BI_RGB;

        PointerByReference ppBits = new PointerByReference();
        HBITMAP hBmp = GDI32.INSTANCE.CreateDIBSection(hdcScreen, bmi, DIB_RGB_COLORS, ppBits, null, 0);
        if (hBmp == null) {
            cleanupDC(hdcScreen, hdcMem, null, null, hmf);
            throw new RuntimeException("CreateDIBSection 失败：" + Kernel32Util.getLastErrorMessage());
        }
        HANDLE hOld = GDI32.INSTANCE.SelectObject(hdcMem, hBmp);
        if (hOld == null) {
            cleanupDC(hdcScreen, hdcMem, hBmp, null, hmf);
            throw new RuntimeException("SelectObject 失败");
        }

        // 6) 白底
        RECT rc = new RECT();
        rc.left = 0; rc.top = 0; rc.right = pxW; rc.bottom = pxH;
        HANDLE whiteBrush = GDI32X.INSTANCE.GetStockObject(WHITE_BRUSH);
        User32X.INSTANCE.FillRect(hdcMem, rc, whiteBrush);

        // 7) 映射：逻辑 -> 像素
        GDI32X.INSTANCE.SetMapMode(hdcMem, MM_ANISOTROPIC);
        GDI32X.INSTANCE.SetWindowOrgEx(hdcMem, 0, 0, null);
        GDI32X.INSTANCE.SetWindowExtEx(hdcMem, logicalW, logicalH, null);
        GDI32X.INSTANCE.SetViewportOrgEx(hdcMem, 0, 0, null);
        GDI32X.INSTANCE.SetViewportExtEx(hdcMem, pxW, pxH, null);
        GDI32X.INSTANCE.SetBkMode(hdcMem, TRANSPARENT);

        // 8) 播放 WMF
        boolean ok = GDI32X.INSTANCE.PlayMetaFile(hdcMem, hmf);
        if (!ok) {
            cleanupDC(hdcScreen, hdcMem, hBmp, hOld, hmf);
            throw new RuntimeException("PlayMetaFile 失败：" + Kernel32Util.getLastErrorMessage());
        }

        // 9) BGRA -> ARGB 并保存 PNG
        BufferedImage img = new BufferedImage(pxW, pxH, BufferedImage.TYPE_INT_ARGB);
        int[] dst = ((java.awt.image.DataBufferInt) img.getRaster().getDataBuffer()).getData();
        Pointer bits = ppBits.getValue();
        ByteBuffer buf = bits.getByteBuffer(0, (long)pxW * pxH * 4).order(ByteOrder.LITTLE_ENDIAN);
        for (int i = 0; i < pxW * pxH; i++) {
            int b = buf.get() & 0xFF;
            int g = buf.get() & 0xFF;
            int r = buf.get() & 0xFF;
            buf.get(); // alpha（多数为0）
            dst[i] = (0xFF << 24) | (r << 16) | (g << 8) | b;
        }
        File out = new File(outPngPath);
        out.getParentFile().mkdirs();
        ImageIO.write(img, "png", out);

        // 10) 清理
        cleanupDC(hdcScreen, hdcMem, hBmp, hOld, hmf);

        return meta;
    }

    /** 自检：是否能在当前环境使用 JNA+GDI 播放 WMF（Windows、gdi32/user32、DIB 创建、函数可解析） */
    public static boolean isWmfGdiAvailable() {
        try {
            if (!isWindows()) return false;

            // 基础 GDI 能力：创建 DC、DIBSection
            HDC hdcScreen = User32.INSTANCE.GetDC(null);
            if (hdcScreen == null) return false;
            HDC hdcMem = GDI32.INSTANCE.CreateCompatibleDC(hdcScreen);
            if (hdcMem == null) { User32.INSTANCE.ReleaseDC(null, hdcScreen); return false; }

            BITMAPINFO bmi = new BITMAPINFO();
            bmi.bmiHeader.biSize = bmi.bmiHeader.size();
            bmi.bmiHeader.biWidth = 2;
            bmi.bmiHeader.biHeight = -2;
            bmi.bmiHeader.biPlanes = 1;
            bmi.bmiHeader.biBitCount = 32;
            bmi.bmiHeader.biCompression = WinGDI.BI_RGB;

            PointerByReference ppBits = new PointerByReference();
            HBITMAP hBmp = GDI32.INSTANCE.CreateDIBSection(hdcScreen, bmi, DIB_RGB_COLORS, ppBits, null, 0);
            boolean dibOk = (hBmp != null && ppBits.getValue() != null);

            if (hBmp != null) GDI32.INSTANCE.DeleteObject(hBmp);
            GDI32.INSTANCE.DeleteDC(hdcMem);
            User32.INSTANCE.ReleaseDC(null, hdcScreen);
            if (!dibOk) return false;

            // 函数符号探测：使用“返回 Pointer”的探针接口，避免句柄实例化权限问题
            try {
                Memory dummy = new Memory(1);
                Pointer ph = GDI32Probe.INSTANCE.SetMetaFileBitsEx(1, dummy);
                // 返回 NULL 正常，此处只验证符号解析与调用链无异常
            } catch (UnsatisfiedLinkError ule) {
                return false;
            } catch (Throwable t) {
                // 极端情况下出错，仍视为不可用
                return false;
            }

            return true;
        } catch (Throwable t) {
            return false;
        }
    }

    /** 扫描并加载 FONT_BASE 下的 .ttf/.otf/.ttc（进程私有，不污染系统），只加载一次 */
    private static void loadFontsFromFolderIfPresent(String base) {
        if (!isWindows()) return;
        if (base == null || base.trim().isEmpty()) return;

        try {
            Path dir = Paths.get(base).normalize();
            if (!Files.isDirectory(dir)) return;

            int addedCount = 0;
            try (Stream<Path> s = Files.walk(dir)) {
                for (Iterator<Path> it = s.iterator(); it.hasNext(); ) {
                    Path p = it.next();
                    if (!Files.isRegularFile(p)) continue;
                    String name = p.getFileName().toString().toLowerCase(Locale.ROOT);
                    if (!(name.endsWith(".ttf") || name.endsWith(".otf") || name.endsWith(".ttc"))) continue;

                    String abs = p.toAbsolutePath().toString();
                    if (LOADED_FONT_FILES.contains(abs)) continue;

                    int added = GDI32X.INSTANCE.AddFontResourceEx(abs, FR_PRIVATE | FR_NOT_ENUM, null);
                    if (added > 0) {
                        LOADED_FONT_FILES.add(abs);
                        addedCount += added;
                    } else {
                        System.err.println("[fonts] AddFontResourceEx 失败: " + abs +
                                " (err=" + Kernel32Util.getLastErrorMessage() + ")");
                    }
                }
            }
            if (addedCount > 0) {
                System.out.println("[fonts] 已加载私有字体 " + addedCount + " 个（进程内有效），目录：" + dir);
            }
        } catch (Throwable e) {
            System.err.println("[fonts] 扫描/加载字体异常： " + e.getMessage());
        }
    }

    private static boolean isWindows() {
        String os = System.getProperty("os.name", "").toLowerCase();
        return os.contains("win");
    }

    private static void cleanupDC(HDC hdcScreen, HDC hdcMem, HBITMAP hBmp, HANDLE hOld, HMETAFILE hmf) {
        try { if (hOld != null) GDI32.INSTANCE.SelectObject(hdcMem, hOld); } catch (Throwable ignore) {}
        try { if (hBmp != null) GDI32.INSTANCE.DeleteObject(hBmp); } catch (Throwable ignore) {}
        try { if (hdcMem != null) GDI32.INSTANCE.DeleteDC(hdcMem); } catch (Throwable ignore) {}
        try { if (hdcScreen != null) User32.INSTANCE.ReleaseDC(null, hdcScreen); } catch (Throwable ignore) {}
        try { if (hmf != null && Pointer.nativeValue(hmf.getPointer()) != 0) GDI32X.INSTANCE.DeleteMetaFile(hmf); } catch (Throwable ignore) {}
    }

    private static byte[] readAll(String path) throws Exception {
        RandomAccessFile raf = new RandomAccessFile(path, "r");
        byte[] b = new byte[(int)raf.length()];
        raf.readFully(b); raf.close(); return b;
    }

    /** Placeable WMF (Aldus) 头 */
    private static class PlaceableHeader {
        int left, top, right, bottom; // 逻辑坐标
        int inch;                     // 每英寸逻辑单位
    }

    private static PlaceableHeader parsePlaceableHeader(byte[] data) {
        if (data == null || data.length < 22) return null;
        int key = (data[0] & 0xFF) | ((data[1] & 0xFF) << 8) | ((data[2] & 0xFF) << 16) | ((data[3] & 0xFF) << 24);
        if (key != 0x9AC6CDD7) return null; // 非 placeable
        int left   = (short)((data[6]  & 0xFF) | ((data[7]  & 0xFF) << 8));
        int top    = (short)((data[8]  & 0xFF) | ((data[9]  & 0xFF) << 8));
        int right  = (short)((data[10] & 0xFF) | ((data[11] & 0xFF) << 8));
        int bottom = (short)((data[12] & 0xFF) | ((data[13] & 0xFF) << 8));
        int inch   = ((data[14] & 0xFF) | ((data[15] & 0xFF) << 8)) & 0xFFFF;
        PlaceableHeader h = new PlaceableHeader();
        h.left = left; h.top = top; h.right = right; h.bottom = bottom; h.inch = (inch == 0 ? 1440 : inch);
        return h;
    }

    // ---------------- JNA 接口/常量 ----------------

    private static final int MM_ANISOTROPIC = 8;
    private static final int TRANSPARENT    = 1;
    private static final int DIB_RGB_COLORS = 0;
    private static final int WHITE_BRUSH    = 0;
    private static final int FR_PRIVATE     = 0x10;
    private static final int FR_NOT_ENUM    = 0x20;

    /** 一定要 public + static + public 构造器，JNA 才能正常实例化 */
    public static class HMETAFILE extends HANDLE {
        public HMETAFILE() {}
        public HMETAFILE(Pointer p) { super(p); }
    }

    /** 主 GDI 接口（返回 HMETAFILE） */
    private interface GDI32X extends com.sun.jna.Library {
        GDI32X INSTANCE = Native.load("gdi32", GDI32X.class, W32APIOptions.UNICODE_OPTIONS);

        int     SetMapMode(HDC hdc, int iMode);
        boolean SetWindowOrgEx(HDC hdc, int X, int Y, POINT lppt);
        boolean SetWindowExtEx(HDC hdc, int X, int Y, WinUser.SIZE lpsz);
        boolean SetViewportOrgEx(HDC hdc, int X, int Y, POINT lppt);
        boolean SetViewportExtEx(HDC hdc, int X, int Y, WinUser.SIZE lpsz);
        int     SetBkMode(HDC hdc, int iBkMode);

        HMETAFILE SetMetaFileBitsEx(int cbBuffer, Pointer lpData);
        boolean   PlayMetaFile(HDC hdc, HMETAFILE hmf);
        boolean   DeleteMetaFile(HMETAFILE hmf);

        HANDLE GetStockObject(int fnObject);
        int     AddFontResourceEx(String lpszFilename, int fl, Pointer pdv);
        boolean RemoveFontResourceEx(String lpszFilename, int fl, Pointer pdv);
        HANDLE  AddFontMemResourceEx(Pointer pbFont, int cbFont, Pointer pdv, IntByReference pcFonts);
        boolean RemoveFontMemResourceEx(HANDLE h);
    }

    /** 探针接口：同名函数，但返回 Pointer，用于 isWmfGdiAvailable 自检时避免句柄实例化 */
    private interface GDI32Probe extends com.sun.jna.Library {
        GDI32Probe INSTANCE = Native.load("gdi32", GDI32Probe.class, W32APIOptions.UNICODE_OPTIONS);
        Pointer SetMetaFileBitsEx(int cbBuffer, Pointer lpData);
    }

    /** User32: FillRect */
    private interface User32X extends com.sun.jna.Library {
        User32X INSTANCE = Native.load("user32", User32X.class, W32APIOptions.DEFAULT_OPTIONS);
        int FillRect(HDC hdc, RECT lprc, HANDLE hbr);
    }
}