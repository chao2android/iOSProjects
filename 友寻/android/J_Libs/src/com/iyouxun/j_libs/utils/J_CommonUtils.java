package com.iyouxun.j_libs.utils;

import java.io.File;
import java.io.InputStream;
import java.io.OutputStream;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.ActivityManager;
import android.content.ClipboardManager;
import android.content.ContentResolver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.StatFs;
import android.provider.MediaStore;
import android.provider.MediaStore.Images;
import android.provider.MediaStore.MediaColumns;
import android.telephony.TelephonyManager;
import android.text.TextPaint;

import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.managers.J_FileManager;

/**
 * @author dingli
 * 
 */
public class J_CommonUtils {

	/**
	 * dip转像素
	 * 
	 * @param context
	 * @param dip
	 * @return
	 */
	public static int dip2px(Context context, float dip) {
		float scale = context.getResources().getDisplayMetrics().density;
		return (int) (dip * scale + 0.5f);
	}

	/**
	 * 像素转dip
	 * 
	 * @param context
	 * @param px
	 * @return
	 */
	public static int px2dip(Context context, float px) {
		float scale = context.getResources().getDisplayMetrics().density;
		return (int) (px / scale + 0.5f);
	}

	/**
	 * 判断父Json对象中某一个子对象是否为JsonArray
	 * 
	 * @param obj 父Json对象
	 * @param name 子对象的名称
	 * @return
	 */
	public static boolean isJsonArray(JSONObject obj, String name) {

		boolean re = true;

		try {
			obj.getJSONArray(name);
		} catch (JSONException e) {
			re = false;
		} finally {
			return re;
		}
	}

	/**
	 * 判断父Json对象中某一个子对象是否为JsonArray
	 * 
	 * @param obj 父Json对象
	 * @param name 子对象的名称
	 * @return
	 */
	public static boolean isJsonArray(String src) {

		boolean re = true;

		try {
			new JSONArray(src);
		} catch (JSONException e) {
			re = false;
		} finally {
			return re;
		}
	}

	/**
	 * 判断String是否是Json格式
	 * 
	 * @return
	 */
	public static boolean isJsonObject(String src) {

		boolean re = true;

		try {
			new JSONObject(src);
		} catch (JSONException e) {
			re = false;
		} finally {
			return re;
		}
	}

	/**
	 * 判断字符串是否为空
	 * 
	 * @param str
	 * @return
	 */
	public static boolean isEmpty(String str) {
		if (str != null && !str.trim().equals("")) {
			return false;
		}
		return true;
	}

	public static boolean isBlankString(String str) {
		if (str == null || str.trim().length() == 0 || str.equals("") || str.equals("null")) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 指定长度截取字符显示
	 * 
	 * @param string
	 * @param length
	 * @return
	 */
	public static String subStr(String string, int length) {
		if (isEmpty(string)) {
			return "";
		}

		if (string.length() > length) {
			return string.substring(0, length) + "...";
		} else {
			return string;
		}
	}

	/**
	 * 将元转换成分
	 * 
	 * @param yuan float类型的字符串
	 * @return int 的字符串
	 */
	public static String yuan2fen(String yuan) {
		return ((int) ((Float.parseFloat(yuan)) * 100)) + "";
	}

	/**
	 * 将元转换成分
	 * 
	 * @param yuan float类型的字符串
	 * @return
	 */
	public static String yuan2fen(float yuan) {
		return ((int) (yuan * 100)) + "";
	}

	/**
	 * 将分转换成元
	 * 
	 * @param fen float类型的字符串
	 * @return
	 */
	public static String fen2yuan(String fen) {
		float temp = Float.parseFloat(fen);
		String tempStr = (temp / 100) + "";
		return tempStr;
	}

	/**
	 * 将分转换成元
	 * 
	 * @param fen float类型的字符串
	 * @return
	 */
	public static String fen2yuan(float fen) {
		String tempStr = (fen / 100) + "";
		return tempStr;
	}

	/**
	 * 快速获取String
	 * 
	 * @param context
	 * @param id
	 * @return
	 */
	public static String getString(Context context, int id) {
		return context.getResources().getString(id);
	}

	/**
	 * String填值
	 * 
	 * @param context
	 * @param id
	 * @param formatArgs
	 * @return
	 */
	public static String getString(Context context, int id, Object... formatArgs) {

		String s1 = context.getResources().getString(id);
		String s2 = String.format(s1, formatArgs);
		return s2;
	}

	/**
	 * 快速获取Color
	 * 
	 * @param context
	 * @param id
	 * @return
	 */
	public static int getColor(Context context, int id) {
		return context.getResources().getColor(id);
	}

	/**
	 * 自动分割文本
	 * 
	 * @param content 需要分割的文本
	 * @param p 画笔，用来根据字体测量文本的宽度
	 * @param width 指定的宽度
	 * @return 一个指定行宽多行字符串
	 */
	public static String autoSplit(String content, TextPaint p, float width) {
		int length = content.length();
		float textWidth = 0;
		textWidth = p.measureText(content);
		if (textWidth <= width) {
			return content;
		}
		StringBuffer sb = new StringBuffer();
		int start = 0, end = 1;
		String tempStr = "";
		while (start < length) {
			if (p.measureText(content, start, end) > width) { // 文本宽度超出控件宽度时
				tempStr = (String) content.subSequence(start, end) + "\n";
				sb.append(tempStr);
				start = end;
			}
			if (end == length) { // 不足一行的文本
				tempStr = (String) content.subSequence(start, end) + "\n";
				sb.append(tempStr);
				break;
			}
			end += 1;
		}
		return sb.toString();
	}

	/**
	 * 实现文本复制功能 add by wangqianzhou
	 * 
	 * @param content
	 */
	@SuppressLint("NewApi")
	public static void copy(String content, Context context) {
		// 得到剪贴板管理器
		ClipboardManager cmb = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);
		cmb.setText(content.trim());
	}

	/**
	 * 实现粘贴功能 add by wangqianzhou
	 * 
	 * @param context
	 * @return
	 */
	@SuppressLint("NewApi")
	public static String paste(Context context) {
		// 得到剪贴板管理器
		ClipboardManager cmb = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);
		return cmb.getText().toString().trim();
	}

	/**
	 * 安装一个apk文件
	 * 
	 * @param context
	 * @param fileName
	 */
	public static void installAPK(Context context, String fileName) {
		Uri uri = Uri.fromFile(new File(fileName));
		// 创建Intent意图
		Intent intent = new Intent(Intent.ACTION_VIEW);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);// 启动新的activity
		// 设置Uri和类型
		intent.setDataAndType(uri, "application/vnd.android.package-archive");
		// 执行安装
		context.startActivity(intent);
	}

	/**
	 * 获取手机IMEI或者MEID
	 * 
	 * @param context
	 * @return
	 */
	public static String getIMEI(Context context) {
		return ((TelephonyManager) context.getSystemService(Context.TELEPHONY_SERVICE)).getDeviceId();
	}

	/**
	 * 将当前系统时间格式化为特定的格式，格式参考 SimpleDateFormat 所使用的格式
	 * 
	 * @param formater 例如："yyyy-MM-dd HH"
	 * @return 根据给定的格式返回当前系统时间的字符串 <br/>
	 *         例如：输入格式为 "yyyy-MM-dd HH" 则返回字符串为 2011-07-20 13
	 */
	public static String formatTime(String formater) {
		return formatTime(formater, new Date());
	}

	/**
	 * 将时间格式化为特定的格式，格式参考 SimpleDateFormat 所使用的格式
	 * 
	 * @param formater 例如："yyyy-MM-dd HH"
	 * @param time 时间的long形式
	 * @return 根据给定的格式返回time 指定时间的字符串 <br/>
	 *         例如：输入格式为 "yyyy-MM-dd HH" 则返回字符串为 2011-07-20 13
	 */
	public static String formatTime(String formater, Long time) {
		return formatTime(formater, new Date(time));
	}

	@SuppressLint("SimpleDateFormat")
	public static String formatTime(String formater, Date date) {
		return new SimpleDateFormat(formater).format(date);
	}

	/**
	 * 年月日
	 */
	@SuppressLint("SimpleDateFormat")
	public static String formatTime(long convertime) {
		SimpleDateFormat d = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		String nowtime = formatTime("yyyy-MM-dd HH:mm:ss", new Date());
		String s = "";
		try {
			long result = (d.parse(nowtime).getTime() - convertime * 1000);
			long second = result / 1000;
			long minute = result / 60000;
			long hour = result / 3600000;
			if (second < 60) {
				s = "刚刚";
				return s;
			} else if (minute <= 60 && minute >= 1) {
				s = minute + "分前";
				return s;
			} else if (hour < 24 && hour >= 1) {
				s = hour + "小时前";
				return s;
			} else if (hour >= 24) {
				s = J_CommonUtils.formatTime("MM月dd日", convertime * 1000);
				return s;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return s;
	}

	/**
	 * 判断当前是否有SD卡
	 * 
	 * @return
	 */
	public static boolean isSDCardExists() {
		return android.os.Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED);
	}

	/**
	 * 获得当前SD卡可用空间（KB）
	 */
	public static long getSDCardAvailableAtKB() {
		StatFs sfs = new StatFs(Environment.getExternalStorageDirectory().getPath());
		long availableCount = sfs.getAvailableBlocks();
		long blockSizea = sfs.getBlockSize();
		return (availableCount * blockSizea) / 1024;
	}

	/**
	 * 获得当前SD卡可用空间（MB）
	 */
	public static long getSDCardAvailableAtMB() {
		return getSDCardAvailableAtKB() / 1024;
	}

	/**
	 * 将图片按照地址创建成为 Bitmap 并且将Bitmap按照Size的比例压缩
	 * 
	 * @param path 图片路径
	 * @param size 压缩比例
	 * @return
	 */
	public static Bitmap zipImage(String path, int size) {
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inSampleSize = size;
		return BitmapFactory.decodeFile(path, options);
	}

	/**
	 * 按路径创建Bitmap, 压缩至size * size的矩形区域内
	 * 
	 * @param path
	 * @param size
	 * @return
	 */
	public static Bitmap getCompressBitmap(String path, int size) {
		if (isEmpty(path)) {
			return null;
		}
		File t = new File(path);
		if (t.isDirectory()) {
			return null;
		}

		if (size <= 0) {
			return null;
		}
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeFile(path, options);
		int temp = Math.max(options.outWidth, options.outHeight);
		options.inJustDecodeBounds = false;
		options.inPreferredConfig = Bitmap.Config.ARGB_4444;
		options.inPurgeable = true;
		options.inInputShareable = true;
		options.inSampleSize = (temp / size < 1) ? 1 : (temp + size / 2) / size;
		return BitmapFactory.decodeFile(path, options);
	}

	/**
	 * 按资源创建Bitmap, 压缩至size * size的矩形区域内
	 * 
	 * @param resources
	 * @param id
	 * @param size
	 * @return
	 */
	public static Bitmap getCompressBitmap(Resources resources, int id, int size) {
		if (size <= 0) {
			return null;
		}
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inJustDecodeBounds = true;
		BitmapFactory.decodeResource(resources, id, options);
		int temp = Math.max(options.outWidth, options.outHeight);
		options.inJustDecodeBounds = false;
		options.inPreferredConfig = Bitmap.Config.ARGB_4444;
		options.inPurgeable = true;
		options.inInputShareable = true;
		options.inSampleSize = (temp / size < 1) ? 1 : (temp + size / 2) / size;
		return BitmapFactory.decodeResource(resources, id, options);
	}

	/**
	 * 判断byte 数组 是否为不为空
	 * 
	 * @param value
	 * @return
	 */
	public static boolean isNotEmpty(byte[] value) {
		return (value != null && value.length != 0);
	}

	/**
	 * 判断byte 数组 是否为为空
	 * 
	 * @param value
	 */
	public static boolean isEmpty(byte[] value) {
		return !isNotEmpty(value);
	}

	/**
	 * 把图库中文件的URI转换成绝对路径
	 * 
	 * @param uri 待转换的URI
	 * @return
	 */
	public static String getPathFromContentUri(Context context, Uri uri) {
		if (null == uri) {
			return null;
		}

		if (!"content".equals(uri.getScheme())) {
			throw new IllegalArgumentException();
		}

		String reslut = null;
		Cursor cursor = context.getContentResolver().query(uri, new String[] { MediaColumns.DATA }, null, null, null);

		try {
			if (cursor.moveToFirst()) {
				reslut = cursor.getString(cursor.getColumnIndexOrThrow(MediaColumns.DATA));
			}
		} finally {
			if (cursor != null && !cursor.isClosed()) {
				cursor.close();
				cursor = null;
			}
		}

		return reslut;
	}

	public static boolean deleteFoder(File file) {
		if (file.exists()) { // 判断文件是否存在
			if (file.isFile()) { // 判断是否是文件
				file.delete(); // delete()方法 你应该知道 是删除的意思;
			} else if (file.isDirectory()) { // 否则如果它是一个目录
				File files[] = file.listFiles(); // 声明目录下所有的文件 files[];
				if (files != null) {
					for (int i = 0; i < files.length; i++) { // 遍历目录下所有的文件
						deleteFoder(files[i]); // 把每个文件 用这个方法进行迭代
					}
				}
			}
			boolean isSuccess = file.delete();
			if (!isSuccess) {
				return false;
			}
		}
		return true;
	}

	public static Bitmap getBitmap(ContentResolver cr, String fileName) {
		Bitmap bitmap = null;
		BitmapFactory.Options options = new BitmapFactory.Options();
		options.inDither = false;
		options.inPreferredConfig = Bitmap.Config.ARGB_8888;
		// select condition.
		String whereClause = MediaStore.Images.Media.DATA + " = '" + fileName + "'";

		// colection of results.
		Cursor cursor = cr.query(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, new String[] { MediaStore.Images.Media._ID },
				whereClause, null, null);
		if (cursor == null || cursor.getCount() == 0) {
			if (cursor != null)
				cursor.close();
			return null;
		}
		cursor.moveToFirst();
		// image id in image table.
		String videoId = cursor.getString(cursor.getColumnIndex(MediaStore.Images.Media._ID));
		cursor.close();
		if (videoId == null) {
			return null;
		}
		long videoIdLong = Long.parseLong(videoId);
		// via imageid get the bimap type thumbnail in thumbnail table.
		bitmap = MediaStore.Images.Thumbnails.getThumbnail(cr, videoIdLong, Images.Thumbnails.MINI_KIND, options);
		return bitmap;
	}

	public static boolean isServiceRunning(Context context, String className) {

		boolean isRunning = false;

		ActivityManager activityManager =

		(ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);

		List<ActivityManager.RunningServiceInfo> serviceList

		= activityManager.getRunningServices(Integer.MAX_VALUE);

		if (!(serviceList.size() > 0)) {

			return false;

		}

		for (int i = 0; i < serviceList.size(); i++) {

			if (serviceList.get(i).service.getClassName().equals(className) == true) {

				isRunning = true;

				break;

			}

		}

		return isRunning;

	}

	private final static long minute = 60 * 1000;// 1分钟
	private final static long hour = 60 * minute;// 1小时
	private final static long day = 24 * hour;// 1天
	private final static long month = 31 * day;// 月
	private final static long year = 12 * month;// 年

	/**
	 * 返回文字描述的日期
	 * 
	 * @param date
	 * @return
	 */
	public static String getTimeFormatText(Date date) {
		if (date == null) {
			return null;
		}
		long diff = new Date().getTime() - date.getTime();
		long r = 0;
		if (diff > year) {
			r = (diff / year);
			return r + "年前";
		}
		if (diff > month) {
			r = (diff / month);
			return r + "个月前";
		}
		if (diff > day) {
			r = (diff / day);
			return r + "天前";
		}
		if (diff > hour) {
			r = (diff / hour);
			return r + "个小时前";
		}
		if (diff > minute) {
			r = (diff / minute);
			return r + "分钟前";
		}
		return "刚刚";
	}

	/**
	 * 发送短信
	 */
	public static void sendSms(Context context, String phoneNum, String content) {
		Intent mIntent = new Intent(Intent.ACTION_VIEW);
		mIntent.putExtra("address", phoneNum);
		mIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		mIntent.putExtra("sms_body", content);
		mIntent.setType("vnd.android-dir/mms-sms");
		context.startActivity(mIntent);
	}

	public static void close(OutputStream os) {
		try {
			if (os != null) {
				os.close();
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
	}

	public static void close(InputStream is) {
		try {
			if (is != null) {
				is.close();
			}
		} catch (Exception e) {
			// TODO: handle exception
		}
	}

	/**
	 * 获取sd卡可用空间
	 * 
	 * @return long 返回类型
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static long getAvailaleSize() {
		// 取得sdcard文件路径
		String filePath = J_FileManager.getInstance().getFileStore().getFileStorePath();
		StatFs stat = new StatFs(filePath);
		long blockSize = stat.getBlockSize();
		long availableBlocks = stat.getAvailableBlocks();
		return availableBlocks * blockSize; // 获取可用大小
	}

	/**
	 * 获取bitmap大小
	 * 
	 * @return long 返回类型
	 * @param @param bitmap
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static long getBitmapSize(Bitmap bitmap) {
		// if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) { // API19
		// return bitmap.getAllocationByteCount();
		// }
		if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB_MR1) {// API12
			return bitmap.getByteCount();
		}
		return bitmap.getRowBytes() * bitmap.getHeight(); // earlier version
	}

	/**
	 * get device IMEI, for cell phone only
	 * 
	 * @param ctx
	 * @return
	 */
	public static String getDeviceIMEI() {
		TelephonyManager tm = (TelephonyManager) J_SDK.getContext().getSystemService(Context.TELEPHONY_SERVICE);
		return tm.getDeviceId();
	}

	/**
	 * 获取渠道id
	 * 
	 * @return String 返回类型
	 * @param @return 参数类型
	 * @author likai
	 */
	public static String getChannelId() {
		String skey = "100";
		try {
			ApplicationInfo appInfo = J_SDK.getContext().getPackageManager()
					.getApplicationInfo(J_SDK.getContext().getPackageName(), PackageManager.GET_META_DATA);
			int sVal = appInfo.metaData.getInt("APP_CHANNEL");
			if (sVal > 0) {
				skey = String.valueOf(sVal);
			}
		} catch (Exception e) {
			skey = "100";
		} catch (InternalError e) {
			skey = "100";
		}
		return skey;
	}

	/**
	 * get ver of current app
	 * 
	 * @param context
	 * @return
	 */
	public static String getAppVersionName() {
		String versionName = "";
		try {
			// ---get the package info---
			PackageManager pm = J_SDK.getContext().getPackageManager();
			PackageInfo pi = pm.getPackageInfo(J_SDK.getContext().getPackageName(), 0);
			versionName = pi.versionName;
			if (versionName == null || versionName.length() <= 0) {
				return "";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return versionName;
	}
}