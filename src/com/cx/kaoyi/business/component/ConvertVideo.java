package com.cx.kaoyi.business.component;

import org.apache.commons.io.FilenameUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.*;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Paths;
import java.util.*;
import java.util.concurrent.Executors;
import java.util.concurrent.Future;
import java.util.function.Consumer;

/**
 * FFmpeg 6.1.2 桥接工具
 * <p>
 * ‑ 保持旧接口(方法名、签名)不变，内部实现跨平台、线程安全、日志统一到 Log4j2。
 * ‑ JDK 8 兼容。
 */
public class ConvertVideo {

	/* ------------------------------ Logger ------------------------------ */
	private static final Logger logger = LogManager.getLogger(ConvertVideo.class);

	/* -------------------------- FFmpeg 路径解析 ------------------------- */
	private static String ffmpegPath = "";          // 旧目录前缀(保持不变)
	private static String FFMPEG_BIN;                // 解析后的可执行完整路径

	static {
		try {
			String currPath = Thread.currentThread()
					.getContextClassLoader()
					.getResource("/")
					.getPath();
			ffmpegPath = URLDecoder.decode(currPath, "UTF-8") + "com/cx/kaoyi/business/component/ffmpeg";

			boolean windows = System.getProperty("os.name").toLowerCase(Locale.ENGLISH).contains("win");
			FFMPEG_BIN = Paths.get(ffmpegPath, windows ? "ffmpeg.exe" : "ffmpeg").toString();
		} catch (Exception e) {
			logger.warn("[ConvertVideo] 初始化 FFmpeg 路径失败: {}", e.getMessage());
			FFMPEG_BIN = "ffmpeg";   // 回退 PATH 查找
		}
	}

	/**
	 * 根据文件后缀判断并转成 MP4。
	 */
	public static boolean process(String inputPath) {
		int type = checkContentType(inputPath);
		switch (type) {
			case 0:
				String suffix = FilenameUtils.getExtension(inputPath).toLowerCase(Locale.ENGLISH);
				if ("flv".equals(suffix)) {
					return processFLV2MPEG4(inputPath);
				} else if ("wmv".equals(suffix)) {
					return processWMV2MPEG4(inputPath);
				} else {
					return processMPEG4(inputPath);
				}
			case 1:     // 旧 RealMedia、wmv9 – 已不再支持
			default:
				logger.warn("不支持的输入格式或已弃用: {}", inputPath);
				return false;
		}
	}

	/**
	 * 合并多个 MP3 文件
	 */
	public static void mergeMp3Files(List<String> mp3FilePaths, String outputFilePath)
			throws IOException, InterruptedException {
		if (mp3FilePaths == null || mp3FilePaths.isEmpty()) {
			throw new IllegalArgumentException("mp3FilePaths 不能为空");
		}
		List<String> cmd = new ArrayList<>();
		cmd.add(FFMPEG_BIN);
		mp3FilePaths.forEach(p -> {
			cmd.add("-i");
			cmd.add(p);
		});
		cmd.add("-filter_complex");
		cmd.add("concat=n=" + mp3FilePaths.size() + ":v=0:a=1");
		cmd.add("-y");
		cmd.add(outputFilePath);

		int exit = runProcess(cmd);
		if (exit != 0) {
			throw new IOException("FFmpeg merge 失败, exit=" + exit);
		}
	}

	/* =================================================================== */
	// ===========================  私有实现  ==============================
	/* =================================================================== */

	private static int checkContentType(String inputPath) {
		String type = FilenameUtils.getExtension(inputPath).toLowerCase(Locale.ENGLISH);
		switch (type) {
			case "avi":
			case "mpg":
			case "wmv":
			case "3gp":
			case "mov":
			case "mp4":
			case "asf":
			case "asx":
			case "flv":
				return 0;
			case "wmv9":
			case "rm":
			case "rmvb":
				return 1;
			default:
				return 9;
		}
	}

	private static boolean processMPEG4(String src) {
		String dst = FilenameUtils.removeExtension(src) + ".mp4";
		List<String> cmd = Arrays.asList(
				FFMPEG_BIN, "-y", "-i", src,
				"-c:v", "libx264", "-preset", "medium", "-crf", "23",
				"-c:a", "aac", "-b:a", "128k",
				dst);
		return runProcess(cmd) == 0;
	}

	private static boolean processFLV2MPEG4(String src) {
		String dst = FilenameUtils.removeExtension(src) + ".mp4";
		List<String> cmd = Arrays.asList(
				FFMPEG_BIN, "-y", "-i", src,
				"-c:v", "libx264", "-preset", "fast", "-crf", "25",
				"-c:a", "aac", "-b:a", "96k",
				dst);
		return runProcess(cmd) == 0;
	}

	private static boolean processWMV2MPEG4(String src) {
		String dst = FilenameUtils.removeExtension(src) + ".mp4";
		List<String> cmd = Arrays.asList(
				FFMPEG_BIN, "-y", "-i", src,
				"-c:v", "libx264", "-preset", "medium", "-crf", "24",
				"-c:a", "aac", "-b:a", "128k",
				dst);
		return runProcess(cmd) == 0;
	}

	/**
	 * 统一执行外部进程，并使用 StreamGobbler 记录输出。
	 */
	private static int runProcess(List<String> command) {
		try {
			ProcessBuilder pb = new ProcessBuilder(command);
			pb.redirectErrorStream(true);
			Process p = pb.start();

			StreamGobbler gobbler = new StreamGobbler(p.getInputStream(), line -> logger.info("[ffmpeg] {}", line));
			Future<?> future = Executors.newSingleThreadExecutor().submit(gobbler);

			int exit = p.waitFor();
			future.get();
			if (exit != 0) {
				logger.error("FFmpeg 执行失败, exitCode={}, cmd={}", exit, command);
			}
			return exit;
		} catch (Exception e) {
			logger.error("执行 FFmpeg 过程异常", e);
			return -1;
		}
	}

	/* ---------------------------- Log helper --------------------------- */

	private static class StreamGobbler implements Runnable {
		private final InputStream stream;
		private final Consumer<String> consumer;

		StreamGobbler(InputStream stream, Consumer<String> consumer) {
			this.stream = stream;
			this.consumer = consumer;
		}

		@Override
		public void run() {
			try (BufferedReader br = new BufferedReader(new InputStreamReader(stream, StandardCharsets.UTF_8))) {
				String line;
				while ((line = br.readLine()) != null) {
					consumer.accept(line);
				}
			} catch (IOException e) {
				logger.debug("StreamGobbler 关闭: {}", e.getMessage());
			}
		}
	}
}