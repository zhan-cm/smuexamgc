package com.cx.kaoyi.framework.utils;

import org.apache.commons.lang3.StringUtils;

import java.time.*;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.time.temporal.ChronoUnit;
import java.util.Date;

public class DateFormatUtils {

	private static final DateTimeFormatter YEAR_FORMATTER = DateTimeFormatter.ofPattern("yyyy");
	private static final DateTimeFormatter DATE_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd");
	private static final DateTimeFormatter DATE_FORMATTER_ZW = DateTimeFormatter.ofPattern("yyyy年MM月dd日");
	private static final DateTimeFormatter HOUR_MINUTE_FORMATTER = DateTimeFormatter.ofPattern("HH:mm");
	private static final DateTimeFormatter DATETIME_NOYEAR_FORMATTER = DateTimeFormatter.ofPattern("HH:mm:ss");
	private static final DateTimeFormatter DATETIME_NOYEAR_FORMATTER_ZW = DateTimeFormatter.ofPattern("HH时mm分ss秒");
	private static final DateTimeFormatter DATETIME_FORMATTER = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
	private static final DateTimeFormatter DATETIME_FORMATTER_ZW = DateTimeFormatter.ofPattern("yyyy年MM月dd日 HH时mm分ss秒");
	private static final DateTimeFormatter HOUR_MINUTE_FORMATTER_ZW = DateTimeFormatter.ofPattern("HH时mm分");

	private static final ZoneId ZONE = ZoneId.systemDefault();

	public static LocalTime date2LocalTime(Date date) {
		if (date == null) {
			return null;
		}
		return date.toInstant().atZone(ZONE).toLocalTime();
	}

	/**
	 * 解析 yyyy-MM-dd HH:mm:ss 格式的字符串为 java.util.Date
	 */
	public static Date parseDateTime(String dateTimeStr) {
		if(StringUtils.isNotBlank(dateTimeStr) && dateTimeStr.endsWith(".0")){
			dateTimeStr = dateTimeStr.replace(".0","");
		}
		LocalDateTime ldt = LocalDateTime.parse(dateTimeStr, DATETIME_FORMATTER);
		return Date.from(ldt.atZone(ZONE).toInstant());
	}

	public static Date parseDateTime4ZhCN(String dateTimeStr) {
		LocalDateTime ldt = LocalDateTime.parse(dateTimeStr, DATETIME_FORMATTER_ZW);
		return Date.from(ldt.atZone(ZONE).toInstant());
	}

	/**
	 * 解析 yyyy-MM-dd 格式的字符串为 java.util.Date（00:00:00）
	 */
	public static Date parseDate(String dateStr) {
		LocalDate ld = LocalDate.parse(dateStr, DATE_FORMATTER);
		return Date.from(ld.atStartOfDay(ZONE).toInstant());
	}

	public static Date parseDate4ZhCN(String dateStr) {
		LocalDate ld = LocalDate.parse(dateStr, DATE_FORMATTER_ZW);
		return Date.from(ld.atStartOfDay(ZONE).toInstant());
	}

	/**
	 * 解析 yyyy 格式的字符串为 java.util.Date（年初 1月1日 00:00:00）
	 */
	public static Date parseYear(String yearStr) {
		LocalDate ld = Year.parse(yearStr, YEAR_FORMATTER).atDay(1);
		return Date.from(ld.atStartOfDay(ZONE).toInstant());
	}

	/**
	 * 解析 HH:mm:ss 字符串为 java.util.Date，默认补上“今天”的年月日
	 */
	public static Date parseDateTimeNoYear(String timeStr) {
		LocalTime lt = LocalTime.parse(timeStr, DATETIME_NOYEAR_FORMATTER);
		LocalDate today = LocalDate.now();
		LocalDateTime ldt = LocalDateTime.of(today, lt);
		return Date.from(ldt.atZone(ZONE).toInstant());
	}

	public static Date parseDateTimeNoYear4ZhCN(String timeStr) {
		LocalTime lt = LocalTime.parse(timeStr, DATETIME_NOYEAR_FORMATTER_ZW);
		LocalDate today = LocalDate.now();
		LocalDateTime ldt = LocalDateTime.of(today, lt);
		return Date.from(ldt.atZone(ZONE).toInstant());
	}


	/**
	 * 将 java.util.Date 格式化为 yyyy-MM-dd HH:mm:ss 字符串
	 */
	public static String formatDateTime(Date date) {
		if (date == null) return null;
		LocalDateTime ldt = LocalDateTime.ofInstant(date.toInstant(), ZONE);
		return ldt.format(DATETIME_FORMATTER);
	}

	public static String formatDateTime(LocalDateTime date) {
		if (date == null) return null;
		return date.format(DATETIME_FORMATTER);
	}

	public static String formatDateTime4ZhCN(Date date) {
		if (date == null) return null;
		LocalDateTime ldt = LocalDateTime.ofInstant(date.toInstant(), ZONE);
		return ldt.format(DATETIME_FORMATTER_ZW);
	}

	/**
	 * 将 java.util.Date 格式化为 yyyy-MM-dd 字符串
	 */
	public static String formatDate(Date date) {
		if (date == null) return null;
		LocalDate ld = date.toInstant().atZone(ZONE).toLocalDate();
		return ld.format(DATE_FORMATTER);
	}

	public static String formatDate4ZhCN(Date date) {
		if (date == null) return null;
		LocalDate ld = date.toInstant().atZone(ZONE).toLocalDate();
		return ld.format(DATE_FORMATTER_ZW);
	}

	/**
	 * 将 java.util.Date 格式化为 yyyy 字符串
	 */
	public static String formatYear(Date date) {
		if (date == null) return null;
		LocalDate ld = date.toInstant().atZone(ZONE).toLocalDate();
		return ld.format(YEAR_FORMATTER);
	}

	/**
	 * 将 java.util.Date 格式化为 HH:mm 字符串
	 */
	public static String formatHourMinute(Date date) {
		if (date == null) return null;
		LocalTime lt = date.toInstant().atZone(ZONE).toLocalTime();
		return lt.format(HOUR_MINUTE_FORMATTER);
	}

	/**
	 * 将 java.util.Date 格式化为 HH时mm分 字符串
	 */
	public static String formatHourMinute_ZW (Date date) {
		if (date == null) return null;
		LocalTime lt = date.toInstant().atZone(ZONE).toLocalTime();
		return lt.format(HOUR_MINUTE_FORMATTER_ZW);
	}

	/**
	 * 将 java.util.Date 格式化为 HH:mm:ss 字符串
	 */
	public static String formatDateTimeNoYear(Date date) {
		if (date == null) return null;
		LocalTime lt = date.toInstant().atZone(ZONE).toLocalTime();
		return lt.format(DATETIME_NOYEAR_FORMATTER);
	}

	public static String formatDateTimeNoYear4ZhCN(Date date) {
		if (date == null) return null;
		LocalTime lt = date.toInstant().atZone(ZONE).toLocalTime();
		return lt.format(DATETIME_NOYEAR_FORMATTER_ZW);
	}

	/**
	 * 获取当前年份字符串（yyyy）
	 */
	public static String getNowYear() {
		return LocalDate.now().format(YEAR_FORMATTER);
	}

	/**
	 * 获取当前日期字符串（yyyy-MM-dd）
	 */
	public static String getNowDay() {
		return LocalDate.now().format(DATE_FORMATTER);
	}

	public static String getNowDay4ZhCN() {
		return LocalDate.now().format(DATE_FORMATTER_ZW);
	}

	/**
	 * 获取当前时间字符串（yyyy-MM-dd HH:mm:ss）
	 */
	public static String getNowTime() {
		return LocalDateTime.now().format(DATETIME_FORMATTER);
	}

	public static String getNowTime4ZhCN() {
		return LocalDateTime.now().format(DATETIME_FORMATTER_ZW);
	}

	/**
	 * 获取指定时间增加任意单位后的时间
	 */
	public static Date plus(Date date, long amountToAdd, ChronoUnit unit) {
		if (date == null || unit == null) return null;
		Instant instant = date.toInstant().plus(amountToAdd, unit);
		return Date.from(instant);
	}

	/**
	 * 核心逻辑方法：判断当前时间是否在指定的日期范围内，并且在每天的特定时间段内。
	 * @Author wxj
	 * @param beginDateTime 考试开始日期时间
	 * @param endDateTime   考试结束日期时间
	 * @return 如果当前时间符合条件，返回 true；否则返回 false
	 */
	private static boolean isWithinRange(LocalDateTime beginDateTime, LocalDateTime endDateTime) {
		if (endDateTime.toLocalDate().isBefore(beginDateTime.toLocalDate())) {
			return false;
		}

		LocalDate beginDate = beginDateTime.toLocalDate();
		LocalDate endDate = endDateTime.toLocalDate();

		LocalTime windowStart = beginDateTime.toLocalTime();
		LocalTime windowEnd = endDateTime.toLocalTime();

		if (windowEnd.isBefore(windowStart)) {
			return false;
		}

		LocalDateTime now = LocalDateTime.now();
		LocalDate today = now.toLocalDate();
		LocalTime currentTime = now.toLocalTime();

		return !today.isBefore(beginDate)
				&& !today.isAfter(endDate)
				&& !currentTime.isBefore(windowStart)
				&& !currentTime.isAfter(windowEnd);
	}

	/**
	 * 判断当前时间是否在指定的日期范围内，并且在每天的特定时间段内。
	 * @Author wxj
	 * @param beginDateStr 考试开始日期时间字符串，格式："yyyy-MM-dd HH:mm:ss"
	 * @param endDateStr   考试结束日期时间字符串，格式："yyyy-MM-dd HH:mm:ss"
	 * @return 如果当前时间符合条件，返回 true；否则返回 false
	 */
	public static boolean isCurrentTimeWithinRange(String beginDateStr, String endDateStr) {
		try {
			LocalDateTime beginDateTime = LocalDateTime.parse(beginDateStr, DATETIME_FORMATTER);
			LocalDateTime endDateTime = LocalDateTime.parse(endDateStr, DATETIME_FORMATTER);
			return isWithinRange(beginDateTime, endDateTime);
		} catch (DateTimeParseException e) {
			e.printStackTrace();
			return false;
		}
	}

	public static boolean isCurrentTimeWithinRange(Instant beginInstant, Instant endInstant) {
		LocalDateTime beginDateTime = LocalDateTime.ofInstant(beginInstant, ZONE);
		LocalDateTime endDateTime = LocalDateTime.ofInstant(endInstant, ZONE);
		return isWithinRange(beginDateTime, endDateTime);
	}

	/**
	 * 判断当前时间是否在指定的日期范围内，并且在每天的特定时间段内。
	 * @Author wxj
	 * @param beginDate 考试开始日期时间
	 * @param endDate   考试结束日期时间
	 * @return 如果当前时间符合条件，返回 true；否则返回 false
	 */
	public static boolean isCurrentTimeWithinRange(Date beginDate, Date endDate) {
		return isCurrentTimeWithinRange(beginDate.toInstant(), endDate.toInstant());
	}

	/**
	 * 通用格式化：pattern 如 "yyyy/MM/dd HH:mm"
	 * @param date    要格式化的 Date；如果为 null，则格式化当前时刻
	 * @param pattern 格式串，不能为空
	 * @return 格式化结果
	 */
	public static String format(Date date, String pattern) {
		if (pattern == null || pattern.isEmpty()) {
			throw new IllegalArgumentException("pattern 必须非空");
		}
		// 每次都新建 Formatter
		DateTimeFormatter fmt = DateTimeFormatter.ofPattern(pattern);
		LocalDateTime ldt = (date == null)
				? LocalDateTime.now()
				: LocalDateTime.ofInstant(date.toInstant(), ZONE);
		return ldt.format(fmt);
	}

	/**
	 * 通用解析：pattern 如 "yyyy/MM/dd HH:mm"
	 * 支持三种模式：
	 *   1) 含日期+时间 → LocalDateTime.parse
	 *   2) 仅日期       → LocalDate.parse，时间补 00:00:00
	 *   3) 仅时间       → LocalTime.parse，日期补“今天”
	 * @param text    要解析的字符串
	 * @param pattern 格式串，不能为空
	 * @return 解析后的 Date
	 * @throws DateTimeParseException 当解析失败时抛出
	 */
	public static Date parse(String text, String pattern) {
		if (pattern == null || pattern.isEmpty()) {
			throw new IllegalArgumentException("pattern 必须非空");
		}
		DateTimeFormatter fmt = DateTimeFormatter.ofPattern(pattern);

		// 先尝试日期+时间
		try {
			LocalDateTime ldt = LocalDateTime.parse(text, fmt);
			return Date.from(ldt.atZone(ZONE).toInstant());
		} catch (DateTimeParseException ex1) {
			// 再尝试纯日期
			try {
				LocalDate ld = LocalDate.parse(text, fmt);
				return Date.from(ld.atStartOfDay(ZONE).toInstant());
			} catch (DateTimeParseException ex2) {
				// 最后尝试纯时间
				LocalTime lt = LocalTime.parse(text, fmt);
				LocalDateTime ldt = LocalDateTime.of(LocalDate.now(), lt);
				return Date.from(ldt.atZone(ZONE).toInstant());
			}
		}
	}

	public static long isEndDateExceedsMonths(String endDate) {
		//获取当前日期时间
		LocalDateTime currentDate = LocalDateTime.now();
		//创建考试结束日期时间
		LocalDateTime examEndDate = LocalDateTime.parse(endDate, DATETIME_FORMATTER);
		//计算当前日期时间到考试结束日期时间的差距（以月为单位）
		long monthsDifference = ChronoUnit.MONTHS.between(examEndDate, currentDate);
		return monthsDifference;
	}

	public static String formatDuration(long totalSeconds) {
		long seconds      = totalSeconds % 60;
		long totalMinutes = totalSeconds / 60;
		long minutes      = totalMinutes % 60;
		long totalHours   = totalMinutes / 60;
		long hours        = totalHours % 24;
		long days         = totalHours / 24;

		StringBuilder sb = new StringBuilder();
		if (days    > 0) sb.append(days).append("天");
		if (hours   > 0) sb.append(hours).append("小时");
		if (minutes > 0) sb.append(minutes).append("分");
		// 如果前面都没有任何单位，或者秒数>0，都要显示秒
		if (sb.length() == 0 || seconds > 0) {
			sb.append(seconds).append("秒");
		}
		return sb.toString();
	}
}