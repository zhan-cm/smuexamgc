package com.cx.kaoyi.framework.utils;

import com.cx.kaoyi.framework.GPT.utils.AIUtils;
import org.apache.commons.lang3.StringUtils;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.nodes.Entities;
import org.jsoup.parser.Tag;
import org.jsoup.safety.Safelist;
import org.jsoup.select.Elements;

import java.math.BigDecimal;
import java.math.RoundingMode;
import java.net.Inet4Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Utils {

	public static final Pattern EXAM_TRIM_PATTERN = Pattern.compile(
			"(?:<p>(?:\\s*<br\\s*/?>\\s*)*</p>|\\s*<br\\s*/?>)+$",
	Pattern.CASE_INSENSITIVE
	); //去掉前后 <p></p>或者<br>等空换行标签

	private static final Safelist WORD_IMPORT_ALLOW_TAGS = new Safelist()
			.addTags("strong", "em", "sub", "sup", "u");

	public static final Pattern IMG_TAG_SRC_PATTERN = Pattern.compile(
			"(?i)<img\\s+[^>]*src=['\"](.*?)['\"][^>]*>");//img标签包含src元素

	public static String stripAllHtml4Compare(String content) {
		if (content == null || content.isEmpty()) return "";

		Safelist safelist = Safelist.none()
				.addTags("img", "audio", "video", "source")
				.addAttributes("img", "src")
				.addAttributes("audio", "src")
				.addAttributes("video", "src")
				.addAttributes("source", "src")
				.preserveRelativeLinks(true);

		String s = Jsoup.clean(content, safelist);
		s = Entities.unescape(s).replace('\u00A0', ' ');

		// 只删“语文标点”
		// 注意：这里刻意不包含 '.' '-' '%'（避免误伤小数/负数/百分数）
		final String PUNCT_BLACKLIST =
				"[、，,。．!?！？;；:：\"“”'‘’~～—–…·【】\\[\\]（）《》〈〉]";
		s = s.replaceAll(PUNCT_BLACKLIST, "");
		// 想保留词边界：用一个空格折叠
		s = s.trim().replaceAll("\\s+", " ");
		return s.toLowerCase(Locale.ROOT);
	}

	public static String stripHtmlExcept4Img(String content) {
		if (StringUtils.isBlank(content)) {
			return "";
		}

		// 构建白名单（Safelist）
		Safelist safelist = new Safelist()
				.addTags(AIUtils.getKeepHtmlTagListWithImg())
				.addAttributes("img", "src")
				.preserveRelativeLinks(true);

		String cleaned = Jsoup.clean(content, safelist);
		return cleaned.replaceAll("\\s+", " ").replace("&nbsp;"," ").replace("<BR>","\n").trim();
	}

	public static String stripHtmlIncludeImg(String content) {
		if (StringUtils.isBlank(content)) {
			return "";
		}

		// 构建白名单（Safelist）
		Safelist safelist = new Safelist()
				.addTags(AIUtils.getKeepHtmlTagListNoImg())
				.preserveRelativeLinks(true);

		String cleaned = Jsoup.clean(content, safelist);
		return cleaned.replaceAll("\\s+", " ").trim();
	}

	public static String stripHtml4WordImport(String html) {
		if (html == null || html.trim().isEmpty()) return "";

		final Map<String, String> tokenToImg = new LinkedHashMap<>();
		final String prefix = "__IMG_PLACEHOLDER_" + UUID.randomUUID().toString().replace("-", "") + "_";
		Matcher m = IMG_TAG_SRC_PATTERN.matcher(html);

		StringBuffer sb = new StringBuffer(html.length());
		int idx = 0;
		while (m.find()) {
			String rawImgTag = m.group();
			String token = prefix + (idx++) + "__";
			tokenToImg.put(token, rawImgTag);
			m.appendReplacement(sb, Matcher.quoteReplacement(token));
		}
		m.appendTail(sb);

		String withPlaceholders = sb.toString();

		// 2) 这里做你原来的“无脑转义/清洗”
		//    注意：WORD_IMPORT_ALLOW_TAGS 继续用你现有的 Safelist（不需要把 img 放进去）
		String cleaned = Jsoup.clean(
				withPlaceholders,
				"",
				WORD_IMPORT_ALLOW_TAGS,
				new Document.OutputSettings()
						.prettyPrint(false)
						.escapeMode(Entities.EscapeMode.base) // 会转义 & < > "
						.charset(StandardCharsets.UTF_8)
		);

		// 3) 再把 img 标签原样放回去（不经过 jsoup 的 escape）
		for (Map.Entry<String, String> e : tokenToImg.entrySet()) {
			cleaned = cleaned.replace(e.getKey(), e.getValue());
		}

		return cleaned;
	}

	public static String replaceUnrecognizableChars(String content){
		if (content == null) {
			return null;
		}
		//删除常见0宽字符、软连字符、方向控制符，都是不可见的字符
		content = content.replaceAll("[\\u200B\\u200C\\u200D\\u2060\\uFEFF\\u00AD\\u202A-\\u202E\\u2066-\\u2069]", "");
		content = content.replace('\u00A0', ' ').
				replace('\u3000', ' ').
				replace('\u001C', ' ')
				.replace('\u001D', ' ')
				.replace('\u001E', ' ')
				.replace('\u001F', ' '); //首尾的不换行空格、全角空格、记录分隔符、单元分隔符等要换成普通空格才能trim掉
		content = content.replace('\u000B', '\n');//将手动换行符^l 给变成普通换行符
		return content;
	}

	public static String trimContent(String content) {
		if (StringUtils.isBlank(content)) {
			return content;
		}
		return EXAM_TRIM_PATTERN.matcher(content).replaceAll("");
	}

	public static String transformRichTextWithMedia(String qid, String html) {
		if (html == null || html.isEmpty()) return "";

		Document doc = Jsoup.parseBodyFragment(html);
		// 尽量减少输出格式化导致的内容变化
		doc.outputSettings()
				.prettyPrint(false)
				.escapeMode(Entities.EscapeMode.base)
				.charset(StandardCharsets.UTF_8);

		Elements medias = doc.select("video,audio");

		for (Element el : medias) {
			String type = el.tagName(); // jsoup 会规范成小写：video/audio

			// 1) 取 src：优先标签自身 src，其次第一个 <source src=...>
			String src = el.hasAttr("src") ? el.attr("src").trim() : "";
			if (src.isEmpty()) {
				Element source = el.selectFirst("source[src]");
				if (source != null) src = source.attr("src").trim();
			}

			// 没有 src：按考试业务，建议直接移除
			if (src.isEmpty()) {
				el.remove();
				continue;
			}

			// 2) video 可选 poster
			String poster = "";
			if ("video".equals(type) && el.hasAttr("poster")) {
				poster = el.attr("poster").trim();
			}

			// 3) 保留 width/height（只有原标签有属性时才写入占位符）
			String width = el.hasAttr("width") ? el.attr("width").trim() : "";
			String height = el.hasAttr("height") ? el.attr("height").trim() : "";

			// 4) 生成占位符
			Element ph = new Element(Tag.valueOf("span"), "");
			ph.addClass("kaoyi-exam-media");
			ph.attr("data-type", type);
			ph.attr("data-src", src);
			ph.attr("data-qid", qid);

			if (!poster.isEmpty()) ph.attr("data-poster", poster);
			if (!width.isEmpty()) ph.attr("data-width", width);
			if (!height.isEmpty()) ph.attr("data-height", height);

			// 给前端兜底提示：如果 JS 没跑起来至少有文字
			ph.text("Loading Media…");
			el.replaceWith(ph);
		}
		return doc.body().html();
	}

	public static boolean isNumeric(String s) {
		if (s == null || s.isEmpty()) return false;
		int i = 0, len = s.length();
		if (s.charAt(0)=='-' && len>1) i = 1;
		for (; i < len; i++) {
			char c = s.charAt(i);
			if (c < '0' || c > '9') return false;
		}
		return true;
	}

	public static int changeObjToInt(Object obj){
		return changeObjToInt(obj, 0);
	}

	public static int changeObjToInt(Object obj, int defaultValue){
		if (obj instanceof Number) {
			return ((Number) obj).intValue();
		}
		String strVal = String.valueOf(obj);
		return isNumeric(strVal) ? Integer.parseInt(strVal) : defaultValue;
	}

	/**
	 * 判断是否为空或null，如果是，返回""
	 * @param param
	 * @return
	 */
	public static <T> T getNotEmptyVal(Object param) {
		return (T) ((param == null || param.equals("") || param.toString().equalsIgnoreCase("null")) ? "" : param);
	}

	/**
	 * 判断字符串数组里任意一个值是否为null或空，如果是，返回false
	 * @param strings
	 * @return
	 */
	public static boolean nullOrEmpty(String... strings) {
		if (strings == null)
			return true;
		for (String param : strings)
			if (param != null && !"".equals(param.trim()) && !"null".equalsIgnoreCase(param.trim()))
				return false;
		return true;
	}

	public static <T> List<T> paginate(List<T> sourceList, int page, int pageSize) {
		if (sourceList == null || sourceList.isEmpty()) {
			return Collections.emptyList();
		}
		if (pageSize <= 0) {
			throw new IllegalArgumentException("pageSize must be greater than zero");
		}
		// 1-based page 转 0-based index
		int fromIndex = (page - 1) * pageSize;
		if (fromIndex < 0 || fromIndex >= sourceList.size()) {
			return Collections.emptyList();
		}
		int toIndex = Math.min(fromIndex + pageSize, sourceList.size());
		return sourceList.subList(fromIndex, toIndex);
	}

	public static String get32PrimaryKey() {
		return UUID.randomUUID().toString().replace("-", "");
	}

	static final String num[] = {"零", "一", "二", "三", "四", "五", "六", "七", "八", "九"};
	static final String unit[] = {"", "十", "百", "千", "万", "十", "百", "千", "亿", "十", "百", "千"};

	public static String int2chineseNum(int src) {
		if(src==0){
			return "零";
		}
		String dst = "";
		int count = 0;
		while (src > 0) {
			int currentDigit = src % 10;
			String currentNum = num[currentDigit];
			String currentUnit = unit[count];
			// 处理最高位的十位为1的情况（如10 → 十，而非一十）
			boolean isSpecialCase = currentDigit == 1 && currentUnit.equals("十") && (src / 10 == 0);
			if (isSpecialCase) {
				dst = currentUnit + dst;
			} else {
				dst = currentNum + currentUnit + dst;
			}
			src = src / 10;
			count++;
		}
		return dst.replaceAll("零[千百十]", "零")
				.replaceAll("零+万", "万")
				.replaceAll("零+亿", "亿")
				.replaceAll("亿万", "亿零")
				.replaceAll("零+", "零")
				.replaceAll("零$", "");
	}

	/**
	 * 只有所有的都不为空返回才是true,其他条件返回为false
	 * 
	 * @param strings
	 * @return
	 */
	public static boolean NotEmpty(String... strings) {
		if (strings == null)
			return false;
		for (String param : strings)
			if (param == null || "".equals(param.trim()) || "null".equalsIgnoreCase(param.trim()))
				return false;
		return true;
	}

	public static String percentOf(BigDecimal divisor, BigDecimal dividend) {
		if (divisor == null || divisor.compareTo(BigDecimal.ZERO) == 0) {
			return "0%";
		}
		if (dividend == null || dividend.compareTo(BigDecimal.ZERO) == 0) {
			return "0%";
		}
		BigDecimal percent = divisor
				.divide(dividend, 6, RoundingMode.HALF_UP)
				.multiply(new BigDecimal("100"))
				.setScale(2, RoundingMode.HALF_UP);
		return percent.toPlainString() + "%";
	}

	public static Date getDateFromStr(String s, String format) throws ParseException {
		if (s == null) {
			return null;
		}
		SimpleDateFormat formatter = new SimpleDateFormat(format);
		return formatter.parse(s);
	}
    
    /**
	  * 获取ip地址
	  * @return
	  */
    public static String getIp(){
    	try {
			InetAddress ip4 = Inet4Address.getLocalHost();
			 return ip4.getHostAddress().toString();	
		} catch (UnknownHostException e) {
			e.printStackTrace();
			return "获取ip出错"; 
		}		
	  
    }

    public static boolean checkForScriptTag(String input) {
    	//String scriptTagRegex="(?i)<script[^>]*>.*?</script>";
    	String htmlRegex = "<[^>]+>";
    	if(input!=null&&!"".equals(input)&&input.matches(".*"+htmlRegex+".*")) {
    		return true;
    	}else {
    		return false;
    	}
    }

	public static Map<String ,Map<String,Object>> listToMap(List<Map<String ,Object>> list, String keyName){
		Map<String ,Map<String,Object>> rtn = new HashMap<>();
		if(list==null || list.isEmpty()){
			return rtn;
		}
		for(Map<String,Object> item : list){
			if(item.containsKey(keyName)){
				rtn.put(String.valueOf(item.get(keyName)), item);
			}
		}
		return rtn;
	}

	public static <V> Map<String, V> replaceKeysToUpperCase(Map<String, V> original) {
		Map<String, V> result = new LinkedHashMap<>(original.size());
		for (Map.Entry<String, V> entry : original.entrySet()) {
			result.put(entry.getKey().toUpperCase(), entry.getValue());
		}
		return result;
	}
}