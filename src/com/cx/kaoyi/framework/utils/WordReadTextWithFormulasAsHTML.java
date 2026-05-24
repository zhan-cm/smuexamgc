package com.cx.kaoyi.framework.utils;

import com.cx.kaoyi.framework.utils.Image.WmfGdiConverter;
import net.arnx.wmf2svg.gdi.svg.SvgGdi;
import net.arnx.wmf2svg.gdi.wmf.WmfParser;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.lang3.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import org.apache.poi.openxml4j.opc.PackagePart;
import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.apache.poi.xwpf.usermodel.XWPFRun;
import org.w3c.dom.*;

import javax.xml.transform.*;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import java.io.*;
import java.net.URLEncoder;
import java.util.Date;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.GZIPOutputStream;


public class WordReadTextWithFormulasAsHTML {
	private static String graphicsMagickPath =  null;

	private static String latexToSVGNodePath =  null;

	private static final String xmlConvertorPath = "resources/convertor/mml2tex/";

	private static final Logger logger = LogManager.getLogger(WordReadTextWithFormulasAsHTML.class);

	public static void setImportWordParam(String graphicsMagickPathInput, String latexToSVGNodePathInput){
		if(StringUtils.isNotBlank(graphicsMagickPathInput)){
			if(new File(graphicsMagickPathInput+"gm.exe").exists()){
				graphicsMagickPath = graphicsMagickPathInput;
			}else if(new File(graphicsMagickPathInput+"/gm.exe").exists()){
				graphicsMagickPath = graphicsMagickPathInput + "/";
			}
		}
		if(StringUtils.isNotBlank(latexToSVGNodePathInput)){
			if(new File(latexToSVGNodePathInput+"node_modules").exists()
				&& new File(latexToSVGNodePathInput+"math.js").exists()){
				latexToSVGNodePath = latexToSVGNodePathInput;
			}else if(new File(latexToSVGNodePathInput+"/node_modules").exists()
				&& new File(latexToSVGNodePathInput+"/math.js").exists()){
				latexToSVGNodePath = latexToSVGNodePathInput + "/";
			}
		}
	}

	public static String getText(Node runNode) {
		Node vertAlign = getChildNode(runNode, "w:vertAlign");
		String vertTag = "";
		if (vertAlign != null && vertAlign.getAttributes() != null) {
			Node valNode = vertAlign.getAttributes().getNamedItem("w:val");
			if (valNode != null) {
				String mmVal = valNode.getNodeValue();
				if ("subscript".equals(mmVal)) {
					vertTag = "sub";
				} else if ("superscript".equals(mmVal)) {
					vertTag = "sup";
				}
			}
		}

		boolean isIncline = getChildNode(runNode, "w:i") != null;
		boolean isBold = getChildNode(runNode, "w:b") != null;

		// 新增：下划线
		boolean isUnderline = false;
		Node underlineNode = getChildNode(runNode, "w:u");
		if (underlineNode != null && underlineNode.getAttributes() != null) {
			Node valNode = underlineNode.getAttributes().getNamedItem("w:val");
			if (valNode == null || !"none".equalsIgnoreCase(valNode.getNodeValue())) {
				isUnderline = true;
			}
		}

		// 把 run 下所有 w:t 拼起来，不只取第一个
		StringBuilder sb = new StringBuilder();
		collectTextNodes(runNode, sb);

		String rtn = sb.toString();
		if (rtn.isEmpty()) {
			return "";
		}

		// 保留空格，否则 HTML 会折叠
		rtn = rtn.replace(" ", "&nbsp;")
				.replace("\t", "&nbsp;&nbsp;&nbsp;&nbsp;");

		if (isIncline) {
			rtn = "<em>" + rtn + "</em>";
		}
		if (isBold) {
			rtn = "<strong>" + rtn + "</strong>";
		}
		if (isUnderline) {
			rtn = "<u>" + rtn + "</u>";
		}
		if (!"".equals(vertTag)) {
			rtn = "<" + vertTag + ">" + rtn + "</" + vertTag + ">";
		}

		return rtn;
	}

	private static void collectTextNodes(Node node, StringBuilder sb) {
		if (node == null) {
			return;
		}
		if ("w:t".equals(node.getNodeName())) {
			Node child = node.getFirstChild();
			if (child != null) {
				sb.append(child.getNodeValue());
			}
			return;
		}

		NodeList children = node.getChildNodes();
		if (children == null) {
			return;
		}
		for (int i = 0; i < children.getLength(); i++) {
			collectTextNodes(children.item(i), sb);
		}
	}

	public static Map<String, String> getSmallImage(XWPFRun run, Node runNode, String path) throws Exception {
		Map<String, String> rtn = new HashMap<>();
		rtn.put("rtnName", "");
		String rtnName = "";
		Node objectNode = getChildNode(runNode, "w:object");
		if (objectNode == null) {
			return rtn;
		}
		Node shapeNode = getChildNode(objectNode, "v:shape");
		if (shapeNode == null) {
			return rtn;
		}
		Node imageNode = getChildNode(shapeNode, "v:imagedata");
		if (imageNode == null) {
			return rtn;
		}
		Node binNode = getChildNode(objectNode, "o:OLEObject");
		if (binNode == null) {
			return rtn;
		}

		XWPFDocument word = run.getDocument();

		NamedNodeMap imageAttrs = imageNode.getAttributes();
		String imageRid = imageAttrs.getNamedItem("r:id").getNodeValue();
		PackagePart imgPart = word.getPartById(imageRid);
		String imageExtension = imgPart.getPartName().getExtension(); // 获取实际扩展名
		String fileName = new Date().getTime() + "";
		String filePath = path + "/" + fileName + "."+imageExtension;
		File file = new File(filePath);

		try (InputStream in = imgPart.getInputStream();
			 FileOutputStream fo = new FileOutputStream(file)) {
			byte[] b = new byte[1024];
			int len;
			while ((len = in.read(b)) != -1) {
				fo.write(b, 0, len);
			}
		}

		// 如果是 WMF 或 EMF 格式，进行转换
		if ("wmf".equalsIgnoreCase(imageExtension)) {
			Map<String, String> pxInfo = convertWmf(filePath);
			file.delete(); // 删除原始 WMF文件
			rtnName = fileName + pxInfo.get("suffix");
			if(pxInfo.get("wPx")!=null && pxInfo.get("hPx")!=null){
				rtn.put("wPx", pxInfo.get("wPx"));
				rtn.put("hPx", pxInfo.get("hPx"));
			}
		}else if("emf".equalsIgnoreCase(imageExtension)){
			String dest = path + "//" + fileName + ".png";
			emfToPng(filePath, dest);
			file.delete(); // 删除原始 WMF/EMF 文件
			rtnName = fileName + ".png";
		}else if("tif".equalsIgnoreCase(imageExtension) || "tiff".equalsIgnoreCase(imageExtension)){
			if(StringUtils.isNotBlank(graphicsMagickPath) && new File(graphicsMagickPath+"gm.exe").exists()){
				String dest = path + "//" + fileName + ".png";
				localHardPicToPngWithGraphicsMagick(filePath, dest);
				file.delete(); // 删除原始 WMF/EMF 文件
				rtnName = fileName + ".png";
			}
		}else{
			rtnName = fileName + imageExtension; // 其他格式直接返回文件名
		}
		rtn.put("rtnName", rtnName);
		return rtn;
	}

	public static Map<String, String> convertWmf(String src) {
		Map<String,String> rtn = new HashMap<>();
		String suffix;
		if(WmfGdiConverter.isWmfGdiAvailable()){
			suffix = ".png";
            try {
				rtn.putAll(WmfGdiConverter.convertWmfToPng(src, FilenameUtils.removeExtension(src) + suffix, 300));
            } catch (Exception e) {
				logger.error("JNA导出wmf图Exception {}", e);
				suffix = ".svg";
				rtn.putAll(wmfToSvg(src, FilenameUtils.removeExtension(src) + suffix));
            }
        }else {
			suffix = ".svg";
			rtn.putAll(wmfToSvg(src, FilenameUtils.removeExtension(src) + suffix));
		}
		rtn.put("suffix", suffix);
		return rtn;
	}

	public static Map<String, String> wmfToSvg(String src, String dest) {
		Map<String, String> rtn = new HashMap<>();
		boolean compatible = false;
		try (InputStream in = new FileInputStream(src)) {
			WmfParser parser = new WmfParser();
			final SvgGdi gdi = new SvgGdi(compatible);
			parser.parse(in, gdi);
			Document doc = gdi.getDocument();
			Element root = doc.getDocumentElement();
			if (root != null) {
				Float wPx = parseCssLengthToPx(root.getAttribute("width"));   // 以 96dpi 换算
				Float hPx = parseCssLengthToPx(root.getAttribute("height"));

				if (wPx != null && hPx != null && wPx > 0 && hPx > 0) {
					float biggerPx = 1.1f; //放大倍数，因为原图太小
					rtn.put("wPx", String.format("%.3f", wPx*biggerPx));
					rtn.put("hPx", String.format("%.3f", hPx*biggerPx));
				}

				root.setAttribute("preserveAspectRatio", "xMidYMid meet");
				if (root.hasAttribute("width"))  root.removeAttribute("width");
				if (root.hasAttribute("height")) root.removeAttribute("height");
			}
			try (OutputStream out = dest.endsWith(".svgz")
					? new GZIPOutputStream(new FileOutputStream(dest))
					: new FileOutputStream(dest)) {
				output(doc, out);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return rtn;
	}

	/** 把 "1.4166in"、"0.4305in"、"136px"、"12pt"、"210mm"、"21cm" 等换算为 px（96dpi） */
	private static Float parseCssLengthToPx(String s) {
		if (s == null || s.trim().isEmpty()) return null;
		String str = s.trim().toLowerCase(Locale.ROOT);
		Pattern p = Pattern.compile("^([+-]?\\d+(?:\\.\\d+)?)(px|pt|pc|mm|cm|in)?$");
		Matcher m = p.matcher(str);
		if (!m.find()) return null;
		float val = Float.parseFloat(m.group(1));
		String unit = m.group(2);
		if (unit == null || "px".equals(unit)) return val;
		switch (unit) {
			case "pt": return val * (96f / 72f);   // 1pt = 1/72in
			case "pc": return val * 16f;           // 1pc = 12pt = 16px
			case "in": return val * 96f;           // 1in = 96px
			case "cm": return val * (96f / 2.54f);
			case "mm": return val * (96f / 25.4f);
			default:   return null;
		}
	}

	public static void emfToPng(String src, String dest){
		if(StringUtils.isNotBlank(graphicsMagickPath) && new File(graphicsMagickPath+"gm.exe").exists()){
			localHardPicToPngWithGraphicsMagick(src,dest);
		}else {
			try {
				emfToPngWithGroupDocs(src, dest);
			}catch(Exception e) {
				e.printStackTrace();
			} finally {
				File before = new File(src);
				String filePath = before.getParentFile().getAbsolutePath();
				String fileName = before.getName().substring(0,before.getName().lastIndexOf("."));
				File transferedFileByGroupdocs = new File(filePath+"/"+fileName+ "1.png");
				if(transferedFileByGroupdocs.exists()){ //只有groupdocs转出来的文件需要
					File newFile = new File(filePath+"/"+fileName+ ".png");
					transferedFileByGroupdocs.renameTo(newFile);
				}
			}
		}
	}

	//适用于emf、tif、tiff，但一定要windows环境，config要配置graphicsMagickPath参数
	public static void localHardPicToPngWithGraphicsMagick(String src, String dest){
		if(StringUtils.isBlank(graphicsMagickPath) || !new File(graphicsMagickPath+"gm.exe").exists()){
			return;
		}
		String command = String.format("\"%s/gm.exe\" convert \"%s\" \"%s\"", graphicsMagickPath, src, dest);
		try {
			Process process = Runtime.getRuntime().exec(command);
			int exitCode = process.waitFor();
			if (exitCode != 0) {
				logger.error("GraphicsMagick conversion failed with exit code {}", exitCode);
				try (InputStream errorStream = process.getErrorStream()) {
					StringBuilder errorMessage = new StringBuilder();
					int byteRead;
					while ((byteRead = errorStream.read()) != -1) {
						errorMessage.append((char) byteRead);
					}
					logger.error("GraphicsMagick error stream: {}", errorMessage.toString());
				}
			}
		} catch (Exception e) {
			logger.error("Error executing GraphicsMagick command", e);
		}
	}

	public static void emfToPngWithGroupDocs(String src, String dest){
		/*Converter converter = new Converter(src);
		ImageConvertOptions convertOptions = new ImageConvertOptions();
		convertOptions.setFormat(ImageFileType.Png);
		converter.convert(dest, convertOptions);*/
	}

	private static void output(Document doc, OutputStream out) throws Exception {
		TransformerFactory factory = TransformerFactory.newInstance();
		Transformer transformer = factory.newTransformer();
		transformer.setOutputProperty(OutputKeys.METHOD, "xml");
		transformer.setOutputProperty(OutputKeys.ENCODING, "UTF-8");
		transformer.setOutputProperty(OutputKeys.INDENT, "yes");
		transformer.setOutputProperty(OutputKeys.DOCTYPE_PUBLIC, "-//W3C//DTD SVG 1.0//EN");
		transformer.setOutputProperty(OutputKeys.DOCTYPE_SYSTEM,
				"http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd");
		transformer.transform(new DOMSource(doc), new StreamResult(out));
		out.flush();
		out.close();
	}

	public static String getMathPic(String latex, String svgPath) { //latex字符串转图片
		if(StringUtils.isBlank(latex) || StringUtils.isBlank(svgPath)){
			return "";
		}
		String[] command = {"node", "--no-warnings", latexToSVGNodePath+"math.js", latex, svgPath};
		try {
			Process process = new ProcessBuilder(command).start();
			process.waitFor();
		} catch (IOException | InterruptedException e) {
			e.printStackTrace();
			return "";
		}
		if(!new File(svgPath).exists()){
			return "";
		}
		return svgPath;
	}

	public static String extractLatexFromNode(Node runNode, String svgPath) throws TransformerException, UnsupportedEncodingException { // 获取公式内容，转换为 LaTeX
		String latex = "";
		if (runNode.getNodeName().equals("m:oMath")) {
			StringWriter writer = new StringWriter();
			Transformer transformer = TransformerFactory.newInstance().newTransformer();
			transformer.transform(new DOMSource(runNode), new StreamResult(writer));
			String ommlXml = writer.toString();
			String mathml = xslConvert(ommlXml, xmlConvertorPath+"OMML2MML.XSL", null);//OMML到MathML
			latex = convertMML2Latex(mathml);
		}
		while (latex.length()>1 && latex.startsWith("$") && latex.endsWith("$")){
			latex = latex.substring(1, latex.length() - 1);
		}
		String rtn = getMathPic(latex, svgPath);
		if(StringUtils.isBlank(rtn)){
			return "";
		}
		return URLEncoder.encode(latex, "UTF-8").replace("+", "%20");
	}

	private static String convertMML2Latex(String mml) {//MathML 到 LaTeX
		if(StringUtils.isBlank(mml)){
			return "";
		}
		mml = mml.substring(mml.indexOf("?>") + 2, mml.length()); // 去掉 XML 头节点
		URIResolver r = (href, base) -> {
			InputStream inputStream = WordReadTextWithFormulasAsHTML.class.getClassLoader().getResourceAsStream(xmlConvertorPath + href);
			return new StreamSource(inputStream);
		};
		return xslConvert(mml, xmlConvertorPath+"mmltex.xsl", r);
	}

	public static String xslConvert(String s, String xslpath, URIResolver uriResolver) {
		TransformerFactory tFac = TransformerFactory.newInstance();
		if (uriResolver != null) {
			tFac.setURIResolver(uriResolver);
		}
		StreamSource xslSource = new StreamSource(WordReadTextWithFormulasAsHTML.class.getClassLoader().getResourceAsStream(xslpath));
		StringWriter writer = new StringWriter();
		try {
			Transformer t = tFac.newTransformer(xslSource);
			Source source = new StreamSource(new StringReader(s));
			Result result = new StreamResult(writer);
			t.transform(source, result);
		} catch (TransformerException e) {
			e.printStackTrace();
		}
		return writer.getBuffer().toString();
	}

	private static Node getChildNode(Node node, String nodeName) {
		if (!node.hasChildNodes()) {
			return null;
		}
		NodeList childNodes = node.getChildNodes();
		for (int i = 0; i < childNodes.getLength(); i++) {
			Node childNode = childNodes.item(i);
			if (nodeName.equals(childNode.getNodeName())) {
				return childNode;
			}
			childNode = getChildNode(childNode, nodeName);
			if (childNode != null) {
				return childNode;
			}
		}
		return null;
	}
}