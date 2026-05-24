package com.cx.kaoyi.business.component;

import com.cx.kaoyi.business.domain.FileUpload;
import com.cx.kaoyi.business.domain.Student;
import com.cx.kaoyi.business.service.QuestionService;
import com.cx.kaoyi.framework.base.BaseController;
import com.cx.kaoyi.framework.utils.WebFilePath;
import org.apache.commons.compress.utils.Sets;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.commons.CommonsMultipartFile;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.*;
import java.net.HttpURLConnection;
import java.net.URI;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.*;

@RestController
@RequestMapping("/upload")
public class UploadFileController extends BaseController  {
	
	@Autowired
	public QuestionService questionService;

	@RequestMapping(value="/uploadFile", params="action=catchimage")
	public Map<String, Object> catchImage(HttpServletRequest request,
										  HttpServletResponse response) throws IOException {
		response.setContentType("text/html;charset=UTF-8");
		String cid = getPara("cid");
		if (!"administrator".equals(getUserInfo().getRole())) {
			Map<String, Object> param = new HashMap<>();
			param.put("uid", getUserID());
			param.put("cid", cid);
			param.put("permission", "question:update");
			if (questionService.checkQuestionPermission(param, getUserID() + "_" + cid) == 0) {
				Map<String, Object> deny = new HashMap<>();
				deny.put("state", "FALSE");
				deny.put("list", Collections.emptyList());
				return deny;
			}
		}

		// UEditor 可能传 source[] 或 source
		String[] sources = request.getParameterValues("source[]");
		if (sources == null) sources = request.getParameterValues("source");

		Map<String, Object> ret = new HashMap<>();
		List<Map<String, Object>> list = new ArrayList<>();
		ret.put("state", "SUCCESS");
		ret.put("list", list);

		if (sources == null || sources.length == 0) {
			ret.put("state", "FALSE");
			return ret;
		}

		// 仅允许图片类型（按你 config 的 catcherAllowFiles）
		Set<String> allowExt = new HashSet<>(Arrays.asList("png","jpg","jpeg","gif","bmp"));
		long maxBytes = 2 * 1024 * 1024; // 2MB，跟你 catcherMaxSize 一致

		Path pathTomcat = Paths.get(WebFilePath.getRealPath(), "kaoyi_upload", cid);
		Path pathNginx  = Paths.get(WebFilePath.getNginxRoot(), "kaoyi_upload", cid);
		Files.createDirectories(pathTomcat);
		Files.createDirectories(pathNginx);

		for (String src : sources) {
			Map<String, Object> item = new HashMap<>();
			item.put("source", src);

			try {
				URI uri = URI.create(src);
				String scheme = uri.getScheme();
				if (scheme == null || (!scheme.equalsIgnoreCase("http") && !scheme.equalsIgnoreCase("https"))) {
					throw new IllegalArgumentException("bad scheme");
				}

				// ⚠️ 强烈建议加 SSRF 防护：禁止 localhost / 127.* / 内网 IP / 169.254.* 等
				// 这里先不展开，至少先挡 host 为空
				if (uri.getHost() == null) throw new IllegalArgumentException("bad host");

				HttpURLConnection conn = (HttpURLConnection) uri.toURL().openConnection();
				conn.setConnectTimeout(3000);
				conn.setReadTimeout(8000);
				conn.setInstanceFollowRedirects(false);

				int code = conn.getResponseCode();
				if (code / 100 != 2) throw new IOException("http " + code);

				String ct = conn.getContentType();
				if (ct == null || !ct.toLowerCase().startsWith("image/")) {
					throw new IllegalArgumentException("not image");
				}

				// 从 content-type 推扩展名（也可以从 url path 推）
				String ext = ct.substring("image/".length()).toLowerCase();
				if ("jpeg".equals(ext)) ext = "jpg";
				if (!allowExt.contains(ext)) throw new IllegalArgumentException("ext not allowed");

				byte[] data;
				try (InputStream in = conn.getInputStream();
					 ByteArrayOutputStream bos = new ByteArrayOutputStream()) {
					byte[] buf = new byte[8192];
					long total = 0;
					int n;
					while ((n = in.read(buf)) != -1) {
						total += n;
						if (total > maxBytes) throw new IllegalArgumentException("too large");
						bos.write(buf, 0, n);
					}
					data = bos.toByteArray();
				}

				String nowName = System.currentTimeMillis() + "." + ext;
				Path tomcatFile = pathTomcat.resolve(nowName);
				Files.write(tomcatFile, data);

				Path nginxFile = pathNginx.resolve(nowName);
				Files.copy(tomcatFile, nginxFile, StandardCopyOption.REPLACE_EXISTING);
				item.put("state", "SUCCESS");
				item.put("url", "/kaoyi_upload/" + cid + "/" + nowName);
				item.put("title", nowName);
				item.put("original", nowName);
				item.put("size", data.length);
			} catch (Exception e) {
				item.put("state", "FALSE");
			}
			list.add(item);
		}

		return ret;
	}


	/**
	  * SpringMVC 用的是 的MultipartFile来进行文件上传
	  * 这里用@RequestParam()来指定上传文件为MultipartFile
	  * @throws IOException
	  */
	@RequestMapping(value="/uploadFile", params="action=normal")
	public Map<String, String> uploadFile(@RequestParam("upfile") CommonsMultipartFile upfile,
										  HttpServletResponse response) throws IOException {
		Map<String, String> result = new HashMap<>();
		response.setHeader("Content-Type", "text/html");

		String cid = getPara("cid");

		if (!"administrator".equals(getUserInfo().getRole())) {
			Map<String, Object> param = new HashMap<>();
			param.put("uid", getUserID());
			param.put("cid", cid);
			param.put("permission", "question:update");
			if (questionService.checkQuestionPermission(param, getUserID() + "_" + cid) == 0) {
				return null;
			}
		}

		String originalFileName = upfile.getOriginalFilename();
		if (originalFileName == null || originalFileName.isEmpty()) {
			result.put("state", "FALSE");
			return result;
		}

		String suffix = originalFileName.substring(originalFileName.lastIndexOf("."));
		String extension = suffix.substring(1).toLowerCase();

		// 白名单过滤
		Set<String> whitelist = new HashSet<>(Arrays.asList(
				"png", "jpg", "jpeg", "flv", "mpeg", "mov", "mp4", "webm", "mp3",
				"xls", "xlsx", "doc", "docx", "pdf", "svg"
		));
		if (!whitelist.contains(extension)) {
			result.put("state", "FALSE");
			return result;
		}

		String nowName = System.currentTimeMillis() + suffix;

		if (!upfile.isEmpty()) {
			Path pathTomcat = Paths.get(WebFilePath.getRealPath(), "kaoyi_upload", cid);
			Path pathNginx = Paths.get(WebFilePath.getNginxRoot(), "kaoyi_upload", cid);
			Files.createDirectories(pathTomcat);
			Files.createDirectories(pathNginx);

			Path tomcatFile = pathTomcat.resolve(nowName);
			upfile.transferTo(tomcatFile.toFile());

			// 转码逻辑
			if (Sets.newHashSet("flv","mpeg","mov","avi","mpg","rm","rmvb","mkv").contains(extension)) {
				boolean converted = ConvertVideo.process(tomcatFile.toString());
				if (converted) {
					Files.deleteIfExists(tomcatFile); // 删除原文件
					nowName = nowName.substring(0, nowName.lastIndexOf(".")) + ".mp4";
					tomcatFile = pathTomcat.resolve(nowName);
					extension = "mp4";
				}
			}

			// 万一转码了nginx 路径也要更新
			Path nginxFile = pathNginx.resolve(nowName);
			try {
				Files.copy(tomcatFile, nginxFile, StandardCopyOption.REPLACE_EXISTING);
			} catch (IOException e) {
				e.printStackTrace();
				result.put("state", "FALSE");
				return result;
			}
		}

		result.put("state", "SUCCESS");
		result.put("title", nowName);
		result.put("original", originalFileName);
		result.put("type", extension);
		result.put("url", "/kaoyi_upload/" + cid + "/" + nowName);
		result.put("size", String.valueOf(Files.size(Paths.get(WebFilePath.getRealPath(), "kaoyi_upload", cid, nowName))));
		return result;
	}

	@RequestMapping(value = "/uploadAudio")
	public String uploadAudio(FileUpload fileVO,
							  @RequestParam(value = "audioData", required = false) MultipartFile upfile) {

		String eid = fileVO.getEid();
		String qid = fileVO.getQid();
		String num = fileVO.getNum();

		if (num == null || num.trim().isEmpty() || "undefined".equals(num)) {
			Student s = getStudentInfo();
			num = s.getNum();
		}

		if (upfile == null || upfile.isEmpty()) {
			return "error";
		}

		String nowName = num + "-" + qid + ".mp3";
		Path pathTomcat = Paths.get(WebFilePath.getRealPath(), "kaoyi_upload", "audio", eid, num);
		Path pathNginx = Paths.get(WebFilePath.getNginxRoot(), "kaoyi_upload", "audio", eid, num);

		try {
			Files.createDirectories(pathTomcat);
			Files.createDirectories(pathNginx);
		} catch (IOException e) {
			e.printStackTrace();
			return "error";
		}

		Path tomcatFile = pathTomcat.resolve(nowName);
		Path nginxFile = pathNginx.resolve(nowName);
		try {
			upfile.transferTo(tomcatFile.toFile()); // 保存到 tomcat 路径
			Files.copy(tomcatFile, nginxFile, StandardCopyOption.REPLACE_EXISTING); // 复制到 nginx 路径
		} catch (IOException e) {
			e.printStackTrace();
			return "error";
		}
		return "/kaoyi_upload/audio/" + eid + "/" + num + "/" + nowName;
	}


	@RequestMapping("/uploadImg")
	public String uploadImg(@RequestBody Map<String, Object> map) {
		String eid = (String) getSession().getAttribute("eid");
		String base64Image = String.valueOf(map.get("image"));

		// 去掉前缀和收尾引号（如果是 "data:image/png;base64,...."）
		if (base64Image.startsWith("\"")) {
			base64Image = base64Image.substring(1, base64Image.length() - 1);
		}
		if (base64Image.contains(",")) {
			base64Image = base64Image.split(",")[1];
		}

		String picName = UUID.randomUUID().toString() + ".png";
		Path nginxDir = Paths.get(WebFilePath.getNginxRoot(), "answerPic", eid);
		Path tomcatDir = Paths.get(WebFilePath.getRealPath(), "answerPic", eid);
		try {
			Files.createDirectories(nginxDir);
			Files.createDirectories(tomcatDir);
		} catch (IOException e) {
			e.printStackTrace();
			return "error";
		}
		Path nginxFile = nginxDir.resolve(picName);
		Path tomcatFile = tomcatDir.resolve(picName);
		try {
			byte[] decodedBytes = Base64.getDecoder().decode(base64Image);
			try (OutputStream out1 = new FileOutputStream(nginxFile.toFile());
				 OutputStream out2 = new FileOutputStream(tomcatFile.toFile())) {
				out1.write(decodedBytes);
				out2.write(decodedBytes);
			}
		} catch (IOException e) {
			e.printStackTrace();
			return "error";
		}
		return "/answerPic/" + eid + "/" + picName;
	}
}
