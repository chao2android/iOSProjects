package com.iyouxun.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.Locale;

/**
 * 时间工具
 */
public class TimeUtil {
	// 时间格式模板
	/** yyyy-MM-dd */
	public static final String TIME_FORMAT_ONE = "yyyy-MM-dd";
	/** yyyy-MM-dd HH:mm */
	public static final String TIME_FORMAT_TWO = "yyyy-MM-dd HH:mm";
	/** yyyy-MM-dd HH:mmZ */
	public static final String TIME_FORMAT_THREE = "yyyy-MM-dd HH:mmZ";
	/** yyyy-MM-dd HH:mm:ss */
	public static final String TIME_FORMAT_FOUR = "yyyy-MM-dd HH:mm:ss";
	/** yyyy-MM-dd HH:mm:ss.SSSZ */
	public static final String TIME_FORMAT_FIVE = "yyyy-MM-dd HH:mm:ss.SSSZ";
	/** yyyy-MM-dd'T'HH:mm:ss.SSSZ */
	public static final String TIME_FORMAT_SIX = "yyyy-MM-dd'T'HH:mm:ss.SSSZ";
	/** HH:mm:ss */
	public static final String TIME_FORMAT_SEVEN = "HH:mm:ss";
	/** HH:mm:ss.SS */
	public static final String TIME_FORMAT_EIGHT = "HH:mm:ss.SS";
	/** yyyy.MM.dd */
	public static final String TIME_FORMAT_9 = "yyyy.MM.dd";
	/** yyyy-MM-dd'T'HH:mm:ss */
	public static final String TIME_FORMAT_10 = "yyyy-MM-dd'T'HH:mm:ss";
	/** MM-dd HH:mm */
	public static final String TIME_FORMAT_11 = "MM-dd HH:mm";
	/** MM-dd */
	public static final String TIME_FORMAT_12 = "MM-dd";

	/**
	 * 根据时间格式获得当前时间
	 */
	public static String getCurrentTime(String formater) {
		Date date = new Date(System.currentTimeMillis());
		SimpleDateFormat dateFormat = new SimpleDateFormat(formater, Locale.SIMPLIFIED_CHINESE);
		return dateFormat.format(date);
	}

	/** 格式化时间 */
	public static String formatTime(long time, String format) {
		return new SimpleDateFormat(format).format(new Date(time));
	}

	/** 判断是否是合法的时间 */
	public static boolean isValidDate(String dateString, String format) {
		return parseTime(dateString, format) > -1;
	}

	/** 日期转换 */
	public static long parseTime(String dateString, String format) {
		if (dateString == null || dateString.length() == 0) {
			return -1;
		}
		try {
			return new SimpleDateFormat(format).parse(dateString).getTime();
		} catch (ParseException e) {

		}
		return -1;
	}

	public static int getDaysBetween(String date1, String date2, String format) {
		return getDaysBetween(parseTime(date1, format), parseTime(date2, format));
	}

	public static int getDaysBetween(long date1, long date2) {
		Calendar c1 = Calendar.getInstance();
		c1.setTimeInMillis(date1);
		c1.set(Calendar.HOUR_OF_DAY, 0);
		c1.set(Calendar.MINUTE, 0);
		c1.set(Calendar.SECOND, 0);
		c1.set(Calendar.MILLISECOND, 0);

		Calendar c2 = Calendar.getInstance();
		c2.setTimeInMillis(date2);
		c2.set(Calendar.HOUR_OF_DAY, 0);
		c2.set(Calendar.MINUTE, 0);
		c2.set(Calendar.SECOND, 0);
		c2.set(Calendar.MILLISECOND, 0);

		return (int) ((c2.getTimeInMillis() - c1.getTimeInMillis()) / (24 * 3600 * 1000));
	}

	/**
	 * 获取时间戳 ，格式2010-1-4 16:21:4，如果是一位数的话，那么前面不加0
	 */
	public static String getTimeStamp() {
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH) + 1;
		int day = calendar.get(Calendar.DAY_OF_MONTH);
		int hour = calendar.get(Calendar.HOUR_OF_DAY);
		int minute = calendar.get(Calendar.MINUTE);
		int second = calendar.get(Calendar.SECOND);
		return (year + "-" + month + "-" + day + " " + hour + ":" + minute + ":" + second);
	}

	/**
	 * 获取当前时间所对应的日期
	 * 
	 * @return String 返回类型
	 * @param @return 参数类型
	 * @author likai
	 */
	public static String getCurrentDate() {
		Calendar calendar = Calendar.getInstance();
		int year = calendar.get(Calendar.YEAR);
		int month = calendar.get(Calendar.MONTH) + 1;
		int day = calendar.get(Calendar.DAY_OF_MONTH);
		return (year + "-" + month + "-" + day);
	}

	/**
	 * Unix时间戳转换成日期
	 */
	public static String timeStamp2Date(String timestampString, String formater) {
		Long timestamp = Long.parseLong(timestampString) * 1000;
		String date = new SimpleDateFormat(formater, Locale.SIMPLIFIED_CHINESE).format(new Date(timestamp));
		return date;
	}

	/**
	 * 将60000 转化为 01:00
	 * 
	 * @param currentTime
	 * @return
	 */
	public static String formatPlayTime(long time) {
		time /= 1000;
		int minute = (int) (time / 60);
		int second = (int) (time % 60);
		minute %= 60;
		return String.format("%02d:%02d", minute, second);
	}

	/**
	 * 获取倒计时剩余时间的格式化内容
	 * 
	 * @return String 返回类型
	 * @param millisInFuture 剩余的时间
	 * @return 倒计时剩余时间的格式化内容
	 * @author likai
	 */
	public static String formatCountDownTime(long millisInFuture) {
		if (millisInFuture <= 0) {
			return "0天00:00:00";
		}
		long oneDayMillis = 24 * 60 * 60 * 1000;
		long oneHourMillis = 60 * 60 * 1000;
		long oneMinMillis = 60 * 1000;
		long futureDay = millisInFuture / oneDayMillis;
		long futureHour = (millisInFuture - futureDay * oneDayMillis) / oneHourMillis;
		long futureMin = (millisInFuture - futureDay * oneDayMillis - futureHour * oneHourMillis) / oneMinMillis;
		long futureSec = millisInFuture - futureDay * oneDayMillis - futureHour * oneHourMillis - futureMin * oneMinMillis;

		return String.format("%d天 %02d:%02d:%02d", futureDay, futureHour, futureMin, futureSec / 1000);
	}

	/**
	 * 1小时内，都展示"N分钟前"
	 * 
	 * 1小时以上，24小时内，展示"N小时前"。 比如 1小时30分钟，展示"1小时前"。
	 * 
	 * 24小时以上，4天以内，展示"N天前"。
	 * 
	 * 4天以上展示具体的"年月日"。
	 * 
	 * @param timeStr 时间戳(秒/毫秒)
	 * 
	 * @return
	 */
	public static String getStandardDate(String timeStr) {
		if (Util.isBlankString(timeStr)) {
			return "";
		}
		StringBuffer sb = new StringBuffer();
		// 转换为long类型
		long t = Long.parseLong(timeStr);
		long timeStamp = t;
		if (timeStr.length() == 10) {
			// 转换为毫秒
			timeStamp = t * 1000;
		}
		// 当前时间
		long now = System.currentTimeMillis();

		// 1分钟的毫秒数
		long oneMinuteMillis = 60 * 1000;
		// 1小时的毫秒数
		long oneHourMillis = 60 * oneMinuteMillis;
		// 24小时的毫秒数
		long oneDayHourMillis = 24 * oneHourMillis;
		// 4天的毫秒数
		long fourDayHourMillis = 4 * oneDayHourMillis;

		if (now - timeStamp < oneMinuteMillis) {
			// 1分钟以内
			sb.append("刚刚");
		} else if (now - timeStamp < oneHourMillis) {
			// 1小时以内
			int howMinute = (int) ((now - timeStamp) / oneMinuteMillis);
			sb.append(howMinute + "分钟前");
		} else if (now - timeStamp < oneDayHourMillis) {
			// 1小时以上，24小时以内
			int howHour = (int) ((now - timeStamp) / oneHourMillis);
			sb.append(howHour + "小时前");
		} else if (now - timeStamp < fourDayHourMillis) {
			// 24小时以上，4天以内
			int howDay = (int) ((now - timeStamp) / oneDayHourMillis);
			sb.append(howDay + "天前");
		} else {
			// 4天以上
			sb.append(new SimpleDateFormat("MM-dd HH:mm").format(new Date(timeStamp)));
		}

		return sb.toString();
	}

	/**
	 * 获取周一开始时间的时间戳
	 * 
	 * */
	private static long getThisWeekMondayTimestamp() {
		long tmStamp = 0;
		// 获取本周周一日期
		String mondayDate = getMondayOFWeek();

		// 将日期转化为时间戳
		Date date = null;
		try {
			String myDate = new String(mondayDate);
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			date = format.parse(myDate);
			if (date != null) {
				tmStamp = date.getTime(); // fetch the time as milliseconds from
											// Jan 1, 1970
			}
		} catch (ParseException e) {
			e.printStackTrace();
		}
		return tmStamp;
	}

	/**
	 * 获取本周一的日期
	 * 
	 * */
	private static String getMondayOFWeek() {
		int mondayPlus = getMondayPlus();
		GregorianCalendar currentDate = new GregorianCalendar();
		currentDate.add(GregorianCalendar.DATE, mondayPlus);
		Date monday = currentDate.getTime();

		SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
		String preMonday = df.format(monday);
		return preMonday;
	}

	private static int getMondayPlus() {
		Calendar cd = Calendar.getInstance();
		// 获得今天是一周的第几天，星期日是第一天，星期二是第二天......
		int dayOfWeek = cd.get(Calendar.DAY_OF_WEEK) - 1; // 因为按中国礼拜一作为第一天所以这里减1
		if (dayOfWeek == 1) {
			return 0;
		} else {
			return 1 - dayOfWeek;
		}
	}
}
