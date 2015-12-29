package com.iyouxun.utils;

import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.net.URL;
import java.text.NumberFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.List;
import java.util.Map;
import java.util.Random;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningTaskInfo;
import android.app.AlertDialog;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.Resources;
import android.content.res.Resources.NotFoundException;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.Bitmap.Config;
import android.graphics.BitmapFactory;
import android.graphics.BitmapFactory.Options;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Rect;
import android.graphics.drawable.StateListDrawable;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Build;
import android.os.Handler;
import android.os.StatFs;
import android.telephony.TelephonyManager;
import android.text.ClipboardManager;
import android.text.TextUtils;
import android.text.format.DateFormat;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.animation.Animation;
import android.view.animation.Transformation;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.j_libs.log.J_Log;
import com.iyouxun.j_libs.managers.J_FileManager;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.ImageLoadListener;
import com.iyouxun.ui.activity.BaseActivity;
import com.iyouxun.ui.views.ScreenShotView;
import com.iyouxun.ui.views.ScreenShotView.OnScreenShotListener;

/**
 * 工具类
 * 
 * @author likai
 * @date 2014年11月19日 上午10:41:03
 */
public class Util {
	private static final String GROUP_CHAT_AVATAR = "groupChatAvatar";
	protected static final String HEXES = "0123456789ABCDEF";
	public static final int SERVICE_TYPE_SENIOR = 2;
	private static long lastClickTime;
	public static final int COUNTDOWN_TIME = 60;// 倒计时时间60秒
	public static final int[][] SENIOR_SERVICE_TYPES = new int[][] { new int[] { 40, 40 }, new int[] { 2, 2 },
			new int[] { 150, 153 }, new int[] { 505, 511 }, new int[] { 553, 575 } };
	final static float scale = Resources.getSystem().getDisplayMetrics().density;
	public static final int CREATE_AVATAR_WIDTH_HEIGHT = 90;// 本地创建群组头像小头像尺寸
	public static final int CREATE_AVATAR_BACKGROUND_WIDTH_HEIGHT = 200;// 本地创建头像尺寸

	public static String getHexString(byte[] raw) {
		if (raw == null) {
			return null;
		}
		final StringBuilder hex = new StringBuilder(2 * raw.length);
		for (final byte b : raw) {
			hex.append(HEXES.charAt((b & 0xF0) >> 4)).append(HEXES.charAt((b & 0x0F)));
		}
		return hex.toString();
	}

	public static Bitmap resizeImage(Bitmap bitmap, int w, int h) {
		if (bitmap == null) {
			return null;
		}
		Bitmap BitmapOrg = bitmap;
		int width = BitmapOrg.getWidth();
		int height = BitmapOrg.getHeight();
		int newWidth = w;
		int newHeight = h;
		float scaleWidth = ((float) newWidth) / width;
		float scaleHeight = ((float) newHeight) / height;
		Matrix matrix = new Matrix();
		matrix.postScale(scaleWidth, scaleHeight);
		Bitmap resizedBitmap = Bitmap.createBitmap(BitmapOrg, 0, 0, width, height, matrix, true);
		return resizedBitmap;
	}

	/*
	 * public static Bitmap setAlpha(Bitmap sourceImg, int number) { int[] argb
	 * = new int[sourceImg.getWidth() * sourceImg.getHeight()];
	 * sourceImg.getPixels(argb, 0, sourceImg.getWidth(), 0,
	 * 0,sourceImg.getWidth(), sourceImg.getHeight());// 获得图片的ARGB值 number =
	 * number * 255 / 100; for (int i = 0; i < argb.length; i++) { argb =
	 * (number << 24) | (argb & 0x00FFFFFF)); } sourceImg =
	 * Bitmap.createBitmap(argb, sourceImg.getWidth(), sourceImg.getHeight(),
	 * Config.ARGB_8888); return sourceImg;
	 * 
	 * }
	 */
	public static void switchTo(Activity activity, Class<? extends Activity> targetActivity) {
		switchTo(activity, new Intent(activity, targetActivity));
	}

	public static void switchTo(Activity activity, Intent intent) {
		activity.startActivity(intent);
		activity.overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
	}

	public static int dipToPixel(int dip) {
		return (int) (dip * scale + 0.5f);
	}

	public static void CopyStream(InputStream is, OutputStream os) {
		final int buffer_size = 1024;
		try {
			byte[] bytes = new byte[buffer_size];
			for (;;) {
				int count = is.read(bytes, 0, buffer_size);
				if (count == -1) {
					break;
				}
				os.write(bytes, 0, count);
			}
		} catch (Exception ex) {
		}
	}

	public static String genFilePath(String fileName, Context ctx) {
		StringBuilder sb = new StringBuilder();
		sb.append(ctx.getFilesDir().getAbsolutePath()).append("/").append(fileName);
		return sb.toString();
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
	 * get client id
	 * 
	 * @param context
	 * @return
	 */
	public static String getClientId() {
		String skey = "13";
		try {
			ApplicationInfo appInfo = J_Application.context.getPackageManager().getApplicationInfo(
					J_Application.context.getPackageName(), PackageManager.GET_META_DATA);
			int sVal = appInfo.metaData.getInt("APP_CLIENTID");
			if (sVal > 0) {
				skey = String.valueOf(sVal);
			}
		} catch (Exception e) {
			skey = "13";
		} catch (InternalError e) {
			skey = "13";
		}
		return skey;
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
			ApplicationInfo appInfo = J_Application.context.getPackageManager().getApplicationInfo(
					J_Application.context.getPackageName(), PackageManager.GET_META_DATA);
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
	 * 获取mainfest中的metadata信息
	 * 
	 * @return String 返回类型
	 * @param @param context
	 * @param @param metaName
	 * @param @return 参数类型
	 * @author likai
	 */
	public static String getMetaDataInfo(String metaName) {
		String msg = "";
		try {
			ApplicationInfo appInfo = J_Application.context.getPackageManager().getApplicationInfo(
					J_Application.context.getPackageName(), PackageManager.GET_META_DATA);
			msg = appInfo.metaData.getString(metaName);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return msg;
	}

	/**
	 * get device IMEI, for cell phone only
	 * 
	 * @param ctx
	 * @return
	 */
	public static String getDeviceIMEI() {
		TelephonyManager tm = (TelephonyManager) J_Application.context.getSystemService(Context.TELEPHONY_SERVICE);
		return tm.getDeviceId();
	}

	/**
	 * convert bytes to UTF-8 string
	 * 
	 * @param data
	 * @return
	 */
	public static String toString(byte[] data) throws UnsupportedEncodingException {
		return new String(data, "UTF-8");
	}

	/**
	 * 去除特定字符返回数字
	 * 
	 * @param str
	 * @return
	 */
	public static int cutCharToNumber(String str) {
		int num = 0;
		if (str.contains("\"")) {
			int index = str.indexOf("\"");
			num = Integer.parseInt(str.substring(0, index));
		} else {
			num = Integer.parseInt(str);
		}
		return num;
	}

	/**
	 * get system version
	 * 
	 * @return
	 */
	public static String getSysVer() {
		return Build.VERSION.RELEASE;
	}

	/**
	 * get Screen Width
	 * 
	 * @param context
	 * @return
	 */
	public static int getScreenWidth(Context context) {
		DisplayMetrics dm = new DisplayMetrics();
		((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(dm);
		return dm.widthPixels;
	}

	/**
	 * get Screen height
	 * 
	 * @param context
	 * @return
	 */
	public static int getScreenHeight(Context context) {
		DisplayMetrics dm = new DisplayMetrics();
		((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(dm);
		return dm.heightPixels;
	}

	public static double getScreenDensity(Context context) {
		DisplayMetrics dm = new DisplayMetrics();
		((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(dm);
		return dm.density;
	}

	/**
	 * get clipBitmap
	 * 
	 * @param bitmap
	 * @param resizeWidth
	 * @param resizeHeight
	 * @return
	 */
	public static Bitmap clipBitmap(Bitmap bitmap, int resizeWidth, int resizeHeight) {
		Bitmap bmp = null;
		if (bitmap != null) {
			float resizeProportion = ((float) resizeWidth) / resizeHeight;
			int bmpWidth = bitmap.getWidth();
			int bmpHeight = bitmap.getHeight();
			float bmpProportion = ((float) bmpWidth) / bmpHeight;
			int clipWidth = 0;
			int clipHeight = 0;
			int offsetX = 0;
			int offsetY = 0;
			if (resizeProportion < bmpProportion) {
				clipWidth = (int) (((float) resizeWidth * bmpHeight) / resizeHeight);
				clipHeight = bmpHeight;
				offsetX = (bmpWidth - clipWidth) / 2;
			} else {
				clipHeight = (int) ((float) resizeHeight * bmpWidth / resizeWidth);
				clipWidth = bmpWidth;
				offsetY = (bmpHeight - clipHeight) / 2;
			}
			float scaleWidth = ((float) resizeWidth) / clipWidth;
			float scaleHeight = ((float) resizeHeight) / clipHeight;
			Matrix matrix = new Matrix();
			matrix.postScale(scaleWidth, scaleHeight);
			try {
				bmp = Bitmap.createBitmap(bitmap, offsetX, offsetY, clipWidth, clipHeight, matrix, true);
			} catch (OutOfMemoryError e) {
				System.gc();
				System.runFinalization();
				bmp = Bitmap.createBitmap(bitmap, offsetX, offsetY, clipWidth, clipHeight, matrix, true);
			}
		}
		return bmp;
	}

	public static String formatDis(String dis) {
		if (dis == null) {
			return "";
		}
		try {
			Float fDis = Float.parseFloat(dis);
			int tmp = (int) (fDis * 10);
			if (tmp < 0) {
				return "";
			} else if (tmp < 10) {
				return String.valueOf(tmp < 5 ? "500" + J_Application.context.getString(R.string.meter) : tmp * 100
						+ J_Application.context.getString(R.string.meter));
			} else {
				return String.valueOf(tmp / 10.0 + J_Application.context.getString(R.string.kilometer));
			}
		} catch (NumberFormatException e) {
			return "";
		}

	}

	public static boolean isSystemMail(String uid) {
		if (uid.equals("3")) {
			return true;
		} else if (uid.equals("7508")) {
			return true;
		} else if (uid.equals("2894338")) {
			return true;
		} else if (uid.equals("3286106")) {
			return true;
		} else if (uid.equals("20631499")) {
			return true;
		} else if (uid.equals("22910713")) {
			return true;
		} else {
			return false;
		}
	}

	/**
	 * 
	 * @param is
	 */
	public static void close(InputStream is) {
		try {
			is.close();
		} catch (Exception e) {
		}
	}

	/**
	 * 
	 * @param is
	 */
	public static void close(OutputStream os) {
		try {
			os.close();
		} catch (Exception e) {
		}
	}

	public static int getAge(int birthYear, String birthDay) {
		if (null == birthDay) {
			return 18;
		}
		Date ageDate = null;
		try {
			ageDate = new Date();
			ageDate.setMonth(Integer.parseInt(birthDay.substring(0, 2)) - 1);
			ageDate.setDate(Integer.parseInt(birthDay.substring(2, 4)));
		} catch (NumberFormatException e) {
			return (Util.getYear() - birthYear);
		} catch (StringIndexOutOfBoundsException e) {
			return (Util.getYear() - birthYear);
		}

		if (!ageDate.before(new Date())) {
			return (Util.getYear() - birthYear - 1);
		} else {
			return (Util.getYear() - birthYear);
		}
	}

	public static int getYear() {
		return Calendar.getInstance().get(Calendar.YEAR);
	}

	public static JSONObject getRawJsonArray(Context mContext, String filename) {
		try {
			InputStream is = mContext.getAssets().open(filename);
			StringBuilder strbuf = new StringBuilder();
			InputStreamReader reader = new InputStreamReader(is);
			BufferedReader bufReader = new BufferedReader(reader);
			String line;
			while ((line = bufReader.readLine()) != null) {
				strbuf.append(line);
			}
			JSONObject obj = null;
			try {
				obj = new JSONObject(strbuf.toString());
			} catch (JSONException e) {
				DLog.e("read json has error : ", e.getMessage(), e);
			} finally {
				is.close();
				reader.close();
				bufReader.close();
			}
			return obj;
		} catch (IOException e) {
			DLog.e("io has error : ", e.getMessage(), e);
		}
		return null;
	}

	/**
	 * read data from stream.
	 * 
	 * @param is
	 * @return
	 */
	public static byte[] readDataFromIS(InputStream is) throws IOException {
		ByteArrayOutputStream os = new ByteArrayOutputStream();
		byte[] data = new byte[50];
		int readLen = 0;
		while ((readLen = is.read(data)) > 0) {
			os.write(data, 0, readLen);
		}
		data = os.toByteArray();
		os.close();
		return data;
	}

	/**
	 * get last section in the URL. Normally this is to get the file name.
	 * 
	 * @param url
	 * @return the last section string
	 */
	public static String lastSectionInURL(URL url) {
		String str = url.getPath();
		String strs[] = str.split("/");
		return strs[strs.length - 1];
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
			PackageManager pm = J_Application.context.getPackageManager();
			PackageInfo pi = pm.getPackageInfo(J_Application.context.getPackageName(), 0);
			versionName = pi.versionName;
			if (versionName == null || versionName.length() <= 0) {
				return "";
			}
		} catch (Exception e) {
			DLog.e("", e.getMessage(), e);
		}
		return versionName;
	}

	public static int getAppVersionCode() {
		int versionCode = 0;
		try {
			// ---get the package info---
			PackageManager pm = J_Application.context.getPackageManager();
			PackageInfo pi = pm.getPackageInfo(J_Application.context.getPackageName(), 0);
			versionCode = pi.versionCode;

		} catch (Exception e) {
			DLog.e("", e.getMessage(), e);
		}
		return versionCode;
	}

	/**
	 * check if there is key for given value in the Map
	 * 
	 * @param map
	 * @param value
	 * @return key for the given value or 'null' if no that key
	 */
	public static Object keyForValue(Map<?, ?> map, Object value) {
		for (Object key : map.keySet()) {
			if (map.get(key) == value) {
				return key;
			}
		}
		return null;
	}

	/**
	 * generate alert dialog
	 * 
	 * @param ctx
	 * @param titleId
	 * @param msgId
	 * @return
	 */
	public static Dialog genAlertDialog(Context ctx, int titleId, int msgId) {
		AlertDialog dialog = new AlertDialog.Builder(ctx).setIcon(R.drawable.icon_warning).setTitle(titleId).setMessage(msgId)
				.setPositiveButton(R.string.ok, null).create();
		return dialog;
	}

	public static String CMCC1 = "46000"; // 中国移动
	public static String CMCC2 = "46002"; // 中国移动
	public static String CMCC3 = "46007"; // 中国移动
	public static String CU = "46001"; // 中国联通
	public static String CT = "46003"; // 中国电信

	public static String getOperatorCode() {
		TelephonyManager telManager = (TelephonyManager) J_Application.context.getSystemService(Context.TELEPHONY_SERVICE);
		String operator = telManager.getSimOperator();
		return operator;
	}

	public static String operatorCode2String() {
		String str = getOperatorCode();
		if (TextUtils.isEmpty(str)) {
			return "";
		} else if (CMCC1.equals(str) || CMCC2.equals(str) || CMCC3.equals(str)) {
			return "中国移动";
		} else if (CU.equals(str)) {
			return "中国联通";
		} else if (CT.equals(str)) {
			return "中国电信";
		} else {
			return "未知";
		}
	}

	public static int computeSampleSize(Options options, int minSideLength, int maxNumOfPixels) {
		int initialSize = computeInitalSampleSize(options, minSideLength, maxNumOfPixels);
		int roundedSize;
		if (initialSize <= 8) {
			roundedSize = 1;
			while (roundedSize < initialSize) {
				roundedSize <<= 1;
			}
		} else {
			roundedSize = (initialSize + 7) / 8 * 8;
		}
		return roundedSize;
	}

	/**
	 * 
	 * @param options
	 * @param minSideLength Minimum length of width or height(pixel);
	 * @param maxNumOfPixels Maximum number of pixels , maximum value of
	 *            width*height.
	 * @return
	 */
	private static int computeInitalSampleSize(Options options, int minSideLength, int maxNumOfPixels) {
		double w = options.outWidth;
		double h = options.outHeight;
		int lowerBound = (maxNumOfPixels == -1) ? 1 : (int) Math.ceil(Math.sqrt(w * h / maxNumOfPixels));
		int upperBound = (minSideLength == -1) ? 128 : (int) Math.min(Math.floor(w / minSideLength),
				Math.floor(h / minSideLength));
		DLog.d("Util", "lowerBound=" + lowerBound + " upperBound=" + upperBound);
		if (upperBound < lowerBound) {
			return upperBound;
		}
		if ((maxNumOfPixels == -1) && (minSideLength == -1)) {
			return 1;
		} else if (minSideLength == -1) {
			return lowerBound;
		} else {
			return upperBound;
		}
	}

	public static Bitmap tryGetBitmap(String imgFile, int minSideLength, int maxNumOfPixels) {
		if (imgFile == null || imgFile.length() == 0) {
			return null;
		}
		BitmapFactory.Options options = new BitmapFactory.Options();
		long fileSize = new File(imgFile).length();
		int maxSize = 300 * 1024;
		if (fileSize <= maxSize) {
			options.inSampleSize = 1;
		} else if (fileSize <= maxSize * 4) {
			options.inSampleSize = 2;
		} else {
			long times = fileSize / maxSize;
			options.inSampleSize = (int) (Math.log(times) / Math.log(2.0)) + 1;
		}

		Bitmap bmp = null;
		options.inJustDecodeBounds = false;
		bmp = loadBitmap(imgFile, null, options);

		return bmp;
	}

	public static Bitmap tryGetBitmap(InputStream is, int minSideLength, int maxNumOfPixels) {
		try {
			if (is == null || is.available() == 0) {
				return null;
			}

			Options options = new Options();
			options.inJustDecodeBounds = true;
			options.inSampleSize = computeSampleSize(options, minSideLength, maxNumOfPixels);
			try {
				options.inJustDecodeBounds = false;
				Rect outPadding = new Rect(-1, -1, -1, -1);
				Bitmap bmp = BitmapFactory.decodeStream(is, outPadding, options);
				return bmp;
			} catch (OutOfMemoryError err) {
				return null;
			}
		} catch (Exception e) {
			return null;
		}
	}

	public static int getRotateDegree(String imgPath) {
		int degree = 0;
		try {
			ExifInterface exifIntf = new ExifInterface(imgPath);
			String orientation = exifIntf.getAttribute(ExifInterface.TAG_ORIENTATION);
			int intOrentation = Integer.parseInt(orientation);
			switch (intOrentation) {
			case ExifInterface.ORIENTATION_NORMAL:
				degree = 0;
				break;
			case ExifInterface.ORIENTATION_ROTATE_180:
				degree = 180;
				break;
			case ExifInterface.ORIENTATION_ROTATE_270:
				degree = 270;
				break;
			case ExifInterface.ORIENTATION_ROTATE_90:
				degree = 90;
				break;
			case ExifInterface.ORIENTATION_FLIP_HORIZONTAL:
				degree = 0;
				break;
			case ExifInterface.ORIENTATION_FLIP_VERTICAL:
				degree = 0;
				break;
			case ExifInterface.ORIENTATION_TRANSPOSE:
				degree = 0;
				break;
			case ExifInterface.ORIENTATION_TRANSVERSE:
				degree = 0;
				break;
			case ExifInterface.ORIENTATION_UNDEFINED:
				degree = 0;
				break;
			}

		} catch (IOException e) {
			e.printStackTrace();
		}
		return degree;
	}

	public static long getAutoUpdateInterval(int index) {
		// set auto update for alarmService
		long interval = 0;
		switch (index) {
		case 0:
			interval = 30 * 60 * 1000;
			break;
		case 1:
			interval = 60 * 60 * 1000;
			break;
		case 2:
			interval = 120 * 60 * 1000;
			break;
		case 3:
			interval = 360 * 60 * 1000;
			break;
		case 4:
			interval = 720 * 60 * 1000;
			break;
		}

		return interval;
	}

	public static boolean isBlankString(String str) {
		if (str == null || str.length() == 0 || str.equals("") || str.equals("null")) {
			return true;
		} else {
			return false;
		}
	}

	public static boolean isNumberMoreThenZero(String str) {
		return !isBlankString(str) && TextUtils.isDigitsOnly(str) && (Integer.parseInt(str) > 0);
	}

	public static String getSexstring(int sexnumber) {
		String result = "男";

		if (sexnumber == 2) {
			result = "保密";
		} else if (sexnumber == 0) {
			result = "女";
		} else if (sexnumber == 1) {
			result = "男";
		}

		return result;
	}

	public static Bitmap createRepeater(int width, Bitmap src) {
		int count = (width + src.getWidth() - 1) / src.getWidth();
		Bitmap bitmap = Bitmap.createBitmap(width, src.getHeight(), Config.ARGB_8888);
		Canvas canvas = new Canvas(bitmap);
		for (int idx = 0; idx < count; ++idx) {
			canvas.drawBitmap(src, idx * src.getWidth(), 0, null);
		}
		return bitmap;
	}

	// parse service
	public static boolean getMonthService(String type) {
		boolean bool = false;
		try {
			JSONObject json = new JSONObject(type);
			JSONArray serviceType = json.getJSONArray("service");
			int length = serviceType.length();
			if (null != serviceType && 0 != length) {
				if (!serviceType.getString(0).equalsIgnoreCase("")) {
					for (int i = 0; i < serviceType.length(); i++) {
						if (serviceType.getInt(i) == 150) {
							bool = true;
						}
					}
				} else
					bool = false;
			} else {
				bool = false;
			}
		} catch (JSONException e) {
			bool = false;
		}
		return bool;
	}

	/**
	 * load image from file
	 * 
	 * @param path
	 * @return Bitmap or 'null' if load error
	 */
	public static Bitmap loadBitmap(String path) {
		return loadBitmap(path, null, null);
	}

	public static Bitmap loadBitmap(String path, Rect out, BitmapFactory.Options opts) {
		FileInputStream fis = null;
		Bitmap b = null;

		try {
			fis = new FileInputStream(path);
			b = BitmapFactory.decodeStream(fis, out, opts);
		} catch (FileNotFoundException e) {
			DLog.e("", e.getMessage(), e);
		} finally {
			close(fis);
		}

		return b;
	}

	public static String formatDouble(double d) {
		String temp = String.valueOf(d);
		String decimals = temp.substring(temp.indexOf(".") + 1, temp.indexOf(".") + 2);
		if (Integer.parseInt(decimals) == 0) {
			return temp.substring(0, temp.indexOf("."));
		} else {
			return temp.substring(0, temp.indexOf(".") + 2);
		}
	}

	public static void unbindDrawables(View view) {
		if (view.getBackground() != null) {
			view.getBackground().setCallback(null);
		}
		if (view instanceof ImageView) {
			ImageView imageView = (ImageView) view;
			imageView.setImageBitmap(null);
		} else if (view instanceof ViewGroup) {
			ViewGroup viewGroup = (ViewGroup) view;
			for (int i = 0; i < viewGroup.getChildCount(); i++) {
				unbindDrawables(viewGroup.getChildAt(i));
			}

			if (!(view instanceof AdapterView)) {
				viewGroup.removeAllViews();
			}
		}
	}

	/**
	 * 从assets文件夹里面读取文件
	 * 
	 * @param mContext
	 * @param filename
	 * @return
	 */
	public static JSONObject getAssetsJsonArray(String filename) {
		try {
			InputStream is = J_Application.context.getAssets().open(filename);
			StringBuilder strbuf = new StringBuilder();
			InputStreamReader reader = new InputStreamReader(is);
			BufferedReader bufReader = new BufferedReader(reader);
			String line;
			while ((line = bufReader.readLine()) != null) {
				strbuf.append(line);
			}
			JSONObject obj = null;
			try {
				obj = new JSONObject(strbuf.toString());
			} catch (JSONException e) {
				J_Log.e("read json has error : " + e);
			} finally {
				is.close();
				reader.close();
				bufReader.close();
			}
			return obj;
		} catch (IOException e) {
			J_Log.e("io has error : " + e);
		}
		return null;
	}

	/** 动态生成selecter图片 */
	public static StateListDrawable createSelector(int selected, int unselected) {
		Context context = J_Application.context;
		StateListDrawable states = new StateListDrawable();

		states.addState(new int[] { android.R.attr.state_pressed }, context.getResources().getDrawable(selected));
		states.addState(new int[] { android.R.attr.state_focused }, context.getResources().getDrawable(selected));
		states.addState(new int[] { android.R.attr.state_selected }, context.getResources().getDrawable(selected));
		states.addState(new int[] {}, context.getResources().getDrawable(unselected));
		return states;
	}

	/** 发广播 */
	public static void sendBroadcast(Intent intent) {
		J_Application.context.sendBroadcast(intent);
	}

	public static List<Integer> parseIntArrToIntegerList(int[] arrInt) {
		List<Integer> arrInteger = new ArrayList<Integer>();
		if (arrInt == null || arrInt.length <= 0) {
			return arrInteger;
		}
		for (int i = 0; i < arrInt.length; i++) {
			arrInteger.add(Integer.valueOf(arrInt[i]));
		}
		return arrInteger;
	}

	// 生成随机数
	public static int getRandom(int length) {
		Random random = new Random();
		return random.nextInt(length);
	}

	/**
	 * 防止重复点击
	 * 
	 * @return boolean true:点击过快，false：正常点击
	 * @param 参数类型
	 * @author likai
	 */
	public static boolean isFastClick() {
		long time = System.currentTimeMillis();
		long timeD = time - lastClickTime;
		lastClickTime = time;
		if (timeD < 1000) {
			return true;
		}
		return false;
	}

	/**
	 * 验证email的正确性
	 * 
	 * @return boolean 返回类型
	 * @param @param url
	 * @param @return 参数类型
	 * @author likai
	 */
	public static boolean isEmail(String url) {
		Pattern emailPattern = Pattern.compile("^mailto:[\\w\\.\\-]+@([\\w\\-]+\\.)+[\\w\\-]+$", Pattern.CASE_INSENSITIVE);
		Matcher emailMatcher = emailPattern.matcher(url);
		return emailMatcher.matches();
	}

	/**
	 * 提取拨号号码
	 * 
	 * @return String 返回类型
	 * @param @param url
	 * @param @return 参数类型
	 * @author likai
	 */
	public static String matchTelNum(String url) {
		// tel:01064422188143
		Pattern telPattern = Pattern.compile("tel:\\d{3,4}\\d{7,8}", Pattern.CASE_INSENSITIVE);
		Matcher telMatcher = telPattern.matcher(url);
		if (telMatcher.matches()) {
			return telMatcher.group(0);
		} else {
			return null;
		}
	}

	/**
	 * 判断一个字符串是否在一个字符串数组中存在
	 * 
	 * @return boolean 返回类型
	 * @param val 要检查的内容
	 * @param list 所要在其中检查存在与否的数组
	 * @param @return 参数类型
	 * @author likai
	 */
	public static boolean in_array(String str, ArrayList<String> list) {
		boolean isIn = false;
		if (list.size() > 0 && !isBlankString(str)) {
			for (int i = 0; i < list.size(); i++) {
				if (list.get(i).equals(str)) {
					isIn = true;
				}
			}
		}

		return isIn;
	}

	public static int getInteger(String largeNum) {
		try {
			int num = Integer.parseInt(largeNum);
			return num;
		} catch (Exception e) {

		}
		return 0;
	}

	public static Double getDouble(String largeNum) {
		try {
			Double num = Double.parseDouble(largeNum);
			return num;
		} catch (Exception e) {

		}
		return 0d;
	}

	public static long getLong(String largeNum) {
		try {
			long num = Long.parseLong(largeNum);
			return num;
		} catch (Exception e) {
		}
		return 0l;
	}

	/**
	 * 除法计算保留小数点后两位,四舍五入
	 * 
	 * @param a 除数
	 * @param b 被除数
	 * @return 保留小数点后两位
	 */
	public static float divideNum(int a, int b) {
		if (b == 0)
			return 0.0f;

		BigDecimal a0 = new BigDecimal(Integer.toString(a));
		BigDecimal b0 = new BigDecimal(Integer.toString(b));
		return a0.divide(b0, 2, BigDecimal.ROUND_HALF_UP).floatValue();
	}

	/***
	 * 将浮点数转成百分数显示
	 * 
	 * @param b 待转换浮点数
	 */
	public static String getPercentage(float b) {
		NumberFormat nf = NumberFormat.getPercentInstance();
		nf.setMaximumFractionDigits(2);
		return nf.format(b);
	}

	/**
	 * 时间戳转需要的格式 年/月/日
	 * 
	 * @param timestampString
	 * @return
	 */
	public static String TimeStamp2Date(String timestampString) {
		String result = "";
		if (!isBlankString(timestampString)) {
			Long timestamp = Long.parseLong(timestampString) * 1000;
			result = new java.text.SimpleDateFormat("yyyy/MM/dd").format(new java.util.Date(timestamp));
		}

		return result;
	}

	/***
	 * 添加截屏功能
	 */
	@SuppressLint("NewApi")
	public static void addScreenShot(Activity context, OnScreenShotListener mScreenShotListener) {
		BaseActivity cxt = null;
		if (context instanceof BaseActivity) {
			cxt = (BaseActivity) context;
			// cxt.setAllowFullScreen(false);
			ScreenShotView screenShot = new ScreenShotView(cxt, mScreenShotListener);
			LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
			context.getWindow().addContentView(screenShot, lp);
		}
	}

	/***
	 * 截取全屏
	 */
	public static Bitmap getFullScreenShot(Activity mAct) {
		BaseActivity cxt = null;
		if (mAct instanceof BaseActivity) {
			cxt = (BaseActivity) mAct;
			// cxt.setAllowFullScreen(false);
			ScreenShotView screenShot = new ScreenShotView(cxt, null);
			LayoutParams lp = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
			mAct.getWindow().addContentView(screenShot, lp);
			return screenShot.cropFullScreen();
		}

		return null;
	}

	/**
	 * 保存当前Activy界面到SD卡
	 * */
	public static void saveFullScreen2SDcard(Activity mAct, String fileName) throws IOException {
		Bitmap bm = getFullScreenShot(mAct);
		String screenshotFilename = J_FileManager.getInstance().getFileStore().getFileStorePath() + "screenshot/" + fileName
				+ ".jpg";
		saveImageToSD(mAct, screenshotFilename, bm, 100);
	}

	/**
	 * 获取保存的截图图片
	 * 
	 * @return String 返回类型
	 * @param @param fileName
	 * @param @return 参数类型
	 * @author likai
	 */
	public static String getFullScreenFile(String fileName) {
		String screenshotFilename = J_FileManager.getInstance().getFileStore().getFileStorePath() + "screenshot/" + fileName
				+ ".jpg";
		return screenshotFilename;
	}

	/***
	 * 写图片文件到SD卡
	 * 
	 * @throws IOException
	 */
	public static void saveImageToSD(Context ctx, String filePath, Bitmap bitmap, int quality) throws IOException {
		if (bitmap != null) {
			File file = new File(filePath.substring(0, filePath.lastIndexOf(File.separator)));
			if (!file.exists()) {
				file.mkdirs();
			}
			BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(filePath));
			bitmap.compress(CompressFormat.JPEG, quality, bos);
			bos.flush();
			bos.close();
			if (ctx != null) {
				scanPhoto(ctx, filePath);
			}
		}
	}

	/**
	 * 让Gallery上能马上看到该图片
	 */
	private static void scanPhoto(Context ctx, String imgFileName) {
		Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
		File file = new File(imgFileName);
		Uri contentUri = Uri.fromFile(file);
		mediaScanIntent.setData(contentUri);
		ctx.sendBroadcast(mediaScanIntent);
	}

	/**
	 * 保存图片到本地
	 * 
	 * @Title: saveImageToLocal
	 * @return void 返回类型
	 * @param @param bean 参数类型
	 * @author likai
	 * @throws
	 */
	public static void saveImageToLocal(Context mContext, final PhotoInfoBean bean, final Handler mHandler) {
		if (!Util.isBlankString(bean.url)) {
			// 网络图片
			ImageView iv = new ImageView(mContext);
			J_NetManager.getInstance().loadIMG(null, bean.url, iv, new ImageLoadListener() {
				@Override
				public void onLoadFinish() {
					try {
						InputStream is = J_FileManager.getInstance().getFileStore().requestFile(bean.url);
						Bitmap bm = BitmapFactory.decodeStream(is);

						J_FileManager.getInstance().getFileStore()
								.storeImageToLocal(J_Application.context, bm, bean.url, mHandler);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}, 0, 0);
		} else if (!Util.isBlankString(bean.picPath)) {
			// 本地图片
			try {
				Bitmap bm = BitmapFactory.decodeFile(bean.picPath);
				J_FileManager.getInstance().getFileStore().storeImageToLocal(mContext, bm, bean.url, mHandler);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 获取文件大小
	 * 
	 * */
	public static long getFileSize(File f) throws Exception {
		long s = 0;
		if (f != null && f.exists()) {
			FileInputStream fis = null;
			fis = new FileInputStream(f);
			s = fis.available();
			fis.close();
		} else {
			DLog.d("likai-test", "uti.getFileSize():文件不存在");
		}
		return s;
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
	 * @Title: useLoop
	 * @Description: 查看数组中是否包含某值
	 * @return boolean 返回类型
	 * @param @param arr 查看的数组
	 * @param @param targetValue 想查看的值
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static boolean useLoop(int[] arr, int targetValue) {
		for (int i : arr) {
			if (i == targetValue) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 验证手机号
	 * 
	 * */
	public static boolean isMobileNumber(String mobiles) {
		Pattern p = Pattern.compile("^((13[0-9])|(15[^4,\\D])|(18[0-9])|(14[0-9])|(17[0-9]))\\d{8}$");
		Matcher m = p.matcher(mobiles);
		return m.matches();
	}

	/**
	 * @Title: btnCountdown
	 * @Description: 按钮倒计时禁用
	 * @return void 返回类型
	 * @param @param mHandler
	 * @param @param time 禁用时间
	 * @param @param btnText 显示文案
	 * @param @param btn 禁用的按钮
	 * @author donglizhi
	 * @throws
	 */
	public static void btnCountdown(final Handler mHandler, final int time, final String btnText, final Button btn) {
		/**
		 * @Fields mRunnable : 验证码按钮六十秒禁用
		 */
		final Runnable mRunnable = new Runnable() {
			int codeCountDown = time;

			@Override
			public void run() {
				String getCode = codeCountDown + btnText;
				btn.setText(getCode);
				codeCountDown--;
				if (codeCountDown >= 0) {
					mHandler.postDelayed(this, 1000);
				} else {
					btn.setEnabled(true);
					btn.setText(R.string.get_security_code);
				}
			}
		};
		mHandler.post(mRunnable);
	}

	/**
	 * @Title: expand
	 * @Description: 展开
	 * @return void 返回类型
	 * @param @param v 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void expand(final View v, final OnAnimationCallBack callBack) {
		v.measure(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT);
		final int targetHeight = v.getMeasuredHeight();

		v.getLayoutParams().height = 0;
		v.setVisibility(View.VISIBLE);
		Animation a = new Animation() {
			@Override
			protected void applyTransformation(float interpolatedTime, Transformation t) {
				v.getLayoutParams().height = interpolatedTime == 1 ? LayoutParams.WRAP_CONTENT
						: (int) (targetHeight * interpolatedTime);
				v.requestLayout();
				if (interpolatedTime == 1) {
					// 结束
					if (callBack != null) {
						callBack.onComplete(View.VISIBLE, v.getId());
					}
				}
			}

			@Override
			public boolean willChangeBounds() {
				return true;
			}
		};

		// 1dp/ms
		a.setDuration((int) (targetHeight / v.getContext().getResources().getDisplayMetrics().density));
		v.startAnimation(a);
	}

	/**
	 * 收起
	 * 
	 * @Title: collapse
	 * @return void 返回类型
	 * @param @param v 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void collapse(final View v, final OnAnimationCallBack callBack) {
		final int initialHeight = v.getMeasuredHeight();

		Animation a = new Animation() {
			@Override
			protected void applyTransformation(float interpolatedTime, Transformation t) {
				if (interpolatedTime == 1) {
					v.setVisibility(View.GONE);
					if (callBack != null) {
						callBack.onComplete(View.GONE, v.getId());
					}
				} else {
					v.getLayoutParams().height = initialHeight - (int) (initialHeight * interpolatedTime);
					v.requestLayout();
				}
			}

			@Override
			public boolean willChangeBounds() {
				return true;
			}
		};

		// 1dp/ms
		a.setDuration((int) (initialHeight / v.getContext().getResources().getDisplayMetrics().density));
		v.startAnimation(a);
	}

	/**
	 * @Title: collapse_expand
	 * @Description: 收起或展开View
	 * @return void 返回类型
	 * @param @param v 参数类型
	 * @author donglizhi
	 * @throws
	 */

	public static void collapse_expand(View v, OnAnimationCallBack callBack) {
		if (v.getVisibility() == View.VISIBLE) {
			// 收起
			collapse(v, callBack);
		} else {
			// 展开
			expand(v, callBack);
		}
	}

	public static interface OnAnimationCallBack {
		public void onComplete(int visible, int viewId);
	}

	/**
	 * 表情选择框中的表情尺寸
	 * 
	 * */
	public static int getBoxFaceSize(Context context, int type) {
		int size = context.getResources().getDimensionPixelSize(R.dimen.global_px30dp);
		switch (type) {
		case 1:
			size = context.getResources().getDimensionPixelSize(R.dimen.global_px45dp);
			break;
		case 2:
			size = context.getResources().getDimensionPixelSize(R.dimen.global_px35dp);
			break;
		case 3:
			size = context.getResources().getDimensionPixelSize(R.dimen.global_px64dp);
			break;
		default:
			break;
		}
		return size;
	}

	/**
	 * 获取表情尺寸
	 * 
	 * */
	public static int getFaceSize(Context context, int type) {
		DisplayMetrics outMetrics = new DisplayMetrics();
		((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(outMetrics);

		int currDpi = Util.getScreenDensityDpi(context);

		int size = context.getResources().getDimensionPixelSize(R.dimen.global_px45dp);

		switch (currDpi) {
		case 160:
			size = context.getResources().getDimensionPixelSize(R.dimen.global_px30dp);
			break;
		case 240:
			size = context.getResources().getDimensionPixelSize(R.dimen.global_px45dp);
			break;
		case 320:
			size = context.getResources().getDimensionPixelSize(R.dimen.global_px60dp);
			break;
		case 440:
			size = context.getResources().getDimensionPixelSize(R.dimen.global_px80dp);
			break;
		default:
			break;
		}

		return size;
	}

	/**
	 * 屏幕密度DPI（120 / 160 / 240）
	 * 
	 * */
	public static int getScreenDensityDpi(Context context) {
		DisplayMetrics dm = new DisplayMetrics();
		((Activity) context).getWindowManager().getDefaultDisplay().getMetrics(dm);
		return dm.densityDpi;
	}

	/**
	 * 根据手机的分辨率从 px(像素) 的单位 转成为 dp
	 * 
	 */
	public static int px2dip(Context context, float pxValue) {
		final float scale = context.getResources().getDisplayMetrics().density;// 密度
		return (int) (pxValue / scale + 0.5f);
	}

	/**
	 * 将px值转换为sp值，保证文字大小不变
	 * 
	 * @param pxValue
	 * @param fontScale （DisplayMetrics类中属性scaledDensity）
	 * @return
	 */
	public static int px2sp(Context context, float pxValue) {
		final float fontScale = context.getResources().getDisplayMetrics().scaledDensity;
		return (int) (pxValue / fontScale + 0.5f);
	}

	/**
	 * 获取要展示的表情的尺寸
	 * 
	 * htc --480dpi
	 * */
	public static int getShowFaceSize(Context context, int type) {
		int size = context.getResources().getDimensionPixelSize(R.dimen.global_px30dp);
		int currDpi = Util.getScreenDensityDpi(context);
		switch (type) {
		case 1:
			if (currDpi <= 160) {
				size = context.getResources().getDimensionPixelSize(R.dimen.global_px45dp);
			} else if (currDpi > 160 && currDpi <= 240) {
				size = context.getResources().getDimensionPixelSize(R.dimen.global_px60dp);
			} else if (currDpi > 240 && currDpi <= 320) {
				size = context.getResources().getDimensionPixelSize(R.dimen.global_px80dp);
			} else if (currDpi > 320) {
				size = context.getResources().getDimensionPixelSize(R.dimen.global_px80dp);
			}
			break;
		case 2:
			if (currDpi <= 160) {
				size = context.getResources().getDimensionPixelSize(R.dimen.global_px30dp);
			} else if (currDpi > 160 && currDpi <= 240) {
				size = context.getResources().getDimensionPixelSize(R.dimen.global_px45dp);
			} else if (currDpi > 240 && currDpi <= 320) {
				size = context.getResources().getDimensionPixelSize(R.dimen.global_px80dp);
			} else if (currDpi > 320 && currDpi < 480) {
				size = context.getResources().getDimensionPixelSize(R.dimen.global_px100dp);
			} else if (currDpi >= 480) {
				size = context.getResources().getDimensionPixelSize(R.dimen.global_px120dp);
			}
			break;
		case 3:
			size = context.getResources().getDimensionPixelSize(R.dimen.global_px64dp);
			break;
		default:
			break;
		}
		return size;
	}

	/**
	 * 读取表情配置文件
	 * 
	 * @param context
	 * @param type 1:默认 2：emoji 3：动态
	 * @return
	 */
	public static List<String> getEmojiFile(Context context, int type) {
		try {
			List<String> list = new ArrayList<String>();
			InputStream in = context.getResources().getAssets().open("emoji");
			if (type == 1) {
				in = context.getResources().getAssets().open("emoji");
			} else if (type == 2) {
				in = context.getResources().getAssets().open("emoji_small");
			} else if (type == 3) {
				in = context.getResources().getAssets().open("emoji_anim");
			}

			BufferedReader br = new BufferedReader(new InputStreamReader(in, "UTF-8"));
			String str = null;
			while ((str = br.readLine()) != null) {
				list.add(str);
			}
			return list;
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * 隐藏键盘
	 * 
	 * */
	public static void hideKeyboard(Context context, View view) {
		InputMethodManager imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
		imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
	}

	/**
	 * 显示键盘
	 * 
	 * */
	public static void showKeybord(Context context, EditText et) {
		InputMethodManager imm = (InputMethodManager) context.getSystemService(Context.INPUT_METHOD_SERVICE);
		et.requestFocus();
		imm.showSoftInput(et, InputMethodManager.SHOW_FORCED);
	}

	/**
	 * @Title: createNewAvatar
	 * @Description: 合成用户群聊图片
	 * @return Bitmap 返回类型
	 * @param @param background 背景
	 * @param @param bitmaps.get(0) 用户头像1
	 * @param @param bitmaps.get(1) 用户头像2
	 * @param @param bitmaps.get(2) 用户头像3
	 * @param @param bitmaps.get(3) 用户头像4
	 * @param @param bitmaps.size() 头像数量
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static Bitmap createNewAvatar(ArrayList<Bitmap> bitmaps, int color, Context context) {
		if (bitmaps.get(0) == null) {
			return null;
		}
		int background_w = CREATE_AVATAR_BACKGROUND_WIDTH_HEIGHT;
		int background_h = CREATE_AVATAR_BACKGROUND_WIDTH_HEIGHT;
		int avatar_w = bitmaps.get(0).getWidth();
		int avatar_h = bitmaps.get(0).getHeight();
		Bitmap newb = Bitmap.createBitmap(background_w, background_h, Config.ARGB_8888);
		Canvas cv = new Canvas(newb);
		cv.drawColor(color);
		if (bitmaps.size() == 2) {// 两个头像并排显示
			cv.drawBitmap(bitmaps.get(0), (background_w - avatar_w * 2) / 3, (background_h - avatar_h) / 2, null);
			cv.drawBitmap(bitmaps.get(1), (background_w - avatar_w * 2) / 3 * 2 + avatar_w, (background_h - avatar_h) / 2, null);
		} else if (bitmaps.size() == 3) {// 三个头像品字显示
			cv.drawBitmap(bitmaps.get(0), (background_w - avatar_w) / 2, (background_h - avatar_h * 2) / 3, null);
			cv.drawBitmap(bitmaps.get(1), (background_w - avatar_w * 2) / 3, (background_h - avatar_h * 2) / 3 * 2 + avatar_h,
					null);
			cv.drawBitmap(bitmaps.get(2), (background_w - avatar_w * 2) / 3 * 2 + avatar_w, (background_h - avatar_h * 2) / 3 * 2
					+ avatar_h, null);
		} else if (bitmaps.size() == 4) {// 四个头像均匀显示
			cv.drawBitmap(bitmaps.get(0), (background_w - avatar_w * 2) / 3, (background_h - avatar_h * 2) / 3, null);
			cv.drawBitmap(bitmaps.get(1), (background_w - avatar_w * 2) / 3 * 2 + avatar_w, (background_h - avatar_h * 2) / 3,
					null);
			cv.drawBitmap(bitmaps.get(2), (background_w - avatar_w * 2) / 3, (background_h - avatar_h * 2) / 3 * 2 + avatar_w,
					null);
			cv.drawBitmap(bitmaps.get(3), (background_w - avatar_w * 2) / 3 * 2 + avatar_w, (background_h - avatar_h * 2) / 3 * 2
					+ avatar_w, null);
		} else {// 显示一个头像
			cv.drawBitmap(bitmaps.get(0), (background_w - avatar_w) / 2, (background_h - avatar_h) / 2, null);
		}
		Bitmap circleBitmap = BitmapFactory.decodeResource(context.getResources(), R.drawable.bg_create_group_avatar);
		Bitmap resizeCircle = resizeImage(circleBitmap, background_w, background_h);
		if (resizeCircle != null) {
			cv.drawBitmap(resizeCircle, 0, 0, null);
		}
		cv.save(Canvas.ALL_SAVE_FLAG);// 保存
		cv.restore();// 存储
		return newb;
	}

	/**
	 * 去除所有html标签
	 * 
	 * */
	public static String delHTMLTag(String htmlStr) {
		String regEx_html = "<[^>]*>"; // 定义HTML标签的正则表达式

		Pattern p_html = Pattern.compile(regEx_html, Pattern.CASE_INSENSITIVE);
		Matcher matcherForTag = p_html.matcher(htmlStr);
		htmlStr = matcherForTag.replaceAll(""); // 过滤html标签

		htmlStr = htmlStr.replaceAll("\\n", "");// 换行符
		htmlStr = htmlStr.replaceAll("\\r", "");// 回车符
		htmlStr = htmlStr.replaceAll("\\t", "");// 制表符
		htmlStr = htmlStr.replaceAll("\\s", "");// 空白字符
		htmlStr = htmlStr.replaceAll(" ", "");

		return htmlStr.trim(); // 返回文本字符串
	}

	/**
	 * 去除所有html标签
	 * 
	 * */
	public static String delHTMLTagOnly(String htmlStr) {
		String regEx_html = "<[^>]*>"; // 定义HTML标签的正则表达式

		Pattern p_html = Pattern.compile(regEx_html, Pattern.CASE_INSENSITIVE);
		Matcher matcherForTag = p_html.matcher(htmlStr);
		htmlStr = matcherForTag.replaceAll(""); // 过滤html标签

		return htmlStr.trim(); // 返回文本字符串
	}

	/**
	 * @Title: delHtmltagAndReplaceBr
	 * @Description: 删除除br外的所有html元素，替换br为换行
	 * @return String 返回类型
	 * @param @param htmlStr
	 * @author donglizhi
	 * @throws
	 */
	public static String delHtmltagAndReplaceBr(String htmlStr) {
		String regEx_html = "<[^>]*>"; // 定义HTML标签的正则表达式
		htmlStr = htmlStr.replaceAll("<br />", "\n");
		Pattern p_html = Pattern.compile(regEx_html, Pattern.CASE_INSENSITIVE);
		Matcher m_html = p_html.matcher(htmlStr);
		htmlStr = m_html.replaceAll(""); // 过滤html标签
		// htmlStr = htmlStr.replaceAll(" ", "");

		return htmlStr.trim(); // 返回文本字符串
	}

	/**
	 * 去除指定名称的html标签及标签中的内容
	 * 
	 * */
	public static String delHTMLTag(String htmlStr, String tagName) {
		String regEx_html = "<\\s*" + tagName + "\\s+([^>]*)\\s*>"; // 定义HTML标签的正则表达式

		Pattern p_html = Pattern.compile(regEx_html, Pattern.CASE_INSENSITIVE);
		Matcher m_html = p_html.matcher(htmlStr);
		htmlStr = m_html.replaceAll(""); // 过滤html标签

		return htmlStr.trim(); // 返回文本字符串
	}

	/**
	 * @Title: getFormatDateTime
	 * @Description: 时间范围 显示格式 >=1小时且在当天 今天15:40 |大于1天且在当年 2月2日 15:18 |不在当年
	 *               12-12-20 15:18
	 * @param timeStr
	 * @return String
	 * @throws
	 * @date 2014-1-16
	 */
	@SuppressWarnings("unused")
	public static String getFormatDateTime(Context context, String timeStr) {
		String FORMAT_TODAY_DATE = "yyyy/MM/dd";
		String FORMAT_THIS_YEAR = "yyyy";
		String FORMAT_TODAY_TIME = "kk:mm";
		String FORMAT_THIS_YEAR_TIME = "MM-dd kk:mm";
		String FORMAT_TIME = "yy-MM-dd kk:mm";
		long timeLong = Long.valueOf(timeStr);
		long timeStamp = timeLong;
		if (timeStr.length() == 10) {
			timeStamp = timeLong * 1000;// 转换为毫秒
		}
		long now = System.currentTimeMillis();
		long one_minute = 60 * 1000;// 一分钟
		long one_hour = one_minute * 60; // 一小时
		long one_day = one_hour * 24;// 一天
		long one_year = one_day * 365;// 一年
		String todayDate = DateFormat.format(FORMAT_TODAY_DATE, now).toString();
		String thisYear = DateFormat.format(FORMAT_THIS_YEAR, now).toString();
		Date dt = null;
		Date yt = null;
		try {
			dt = new SimpleDateFormat(FORMAT_TODAY_DATE).parse(todayDate);
			yt = new SimpleDateFormat(FORMAT_THIS_YEAR).parse(thisYear);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		long today = dt.getTime();
		long year = yt.getTime();
		long subtract = now - timeStamp;
		String justString = context.getResources().getString(R.string.util_date_format_just);
		String todayString = context.getResources().getString(R.string.util_date_format_today);
		String minutesString = context.getResources().getString(R.string.util_date_format_minutes);
		String returnString = "";
		/*
		 * if (subtract < one_minute) {// <1分钟 刚刚 returnString = justString; }
		 * else if (subtract < one_hour) {// <1小时 58分钟前 long result = subtract /
		 * 1000 / 60; returnString = result + minutesString; } else
		 */if (timeStamp < (one_day + today) && timeStamp >= today) {// >=1小时且在当天
			// 今天15:40
			returnString = /* todayString + */"" + DateFormat.format(FORMAT_TODAY_TIME, timeStamp);
		} else if (timeStamp >= year && timeStamp < (year + one_year)) {// 大于1天且在当年
																		// 2月2日
																		// 15:18
			returnString = DateFormat.format(FORMAT_THIS_YEAR_TIME, timeStamp) + "";
		} else {// 不在当年 12-12-20 15:18
			returnString = DateFormat.format(FORMAT_TIME, timeStamp) + "";
		}
		return returnString;
	}

	/**
	 * @Title: getFormatDateTime
	 * @Description: 时间范围 显示格式 >=1小时且在当天 今天15:40 |大于1天且在当年 2月2日 15:18 |不在当年
	 *               12-12-20
	 * @param timeStr
	 * @return String
	 * @throws
	 * @date 2014-1-16
	 */
	@SuppressWarnings("unused")
	public static String getFormatDateTime2(Context context, String timeStr) {
		if (context == null || isBlankString(timeStr)) {
			return "";
		}
		String FORMAT_TODAY_DATE = "yyyy/MM/dd";
		String FORMAT_THIS_YEAR = "yyyy";
		String FORMAT_TODAY_TIME = "kk:mm";
		String FORMAT_THIS_YEAR_TIME = "MM-dd kk:mm";
		String FORMAT_TIME = "yy-MM-dd";
		long timeLong = Long.valueOf(timeStr);
		long timeStamp = timeLong;
		if (timeStr.length() == 10) {
			timeStamp = timeLong * 1000;// 转换为毫秒
		}
		long now = System.currentTimeMillis();
		long one_minute = 60 * 1000;// 一分钟
		long one_hour = one_minute * 60; // 一小时
		long one_day = one_hour * 24;// 一天
		long one_year = one_day * 365;// 一年
		String todayDate = DateFormat.format(FORMAT_TODAY_DATE, now).toString();
		String thisYear = DateFormat.format(FORMAT_THIS_YEAR, now).toString();
		Date dt = null;
		Date yt = null;
		try {
			dt = new SimpleDateFormat(FORMAT_TODAY_DATE).parse(todayDate);
			yt = new SimpleDateFormat(FORMAT_THIS_YEAR).parse(thisYear);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		long today = dt.getTime();
		long year = yt.getTime();
		long subtract = now - timeStamp;
		String justString = context.getResources().getString(R.string.util_date_format_just);
		String todayString = context.getResources().getString(R.string.util_date_format_today);
		String minutesString = context.getResources().getString(R.string.util_date_format_minutes);
		String returnString = "";
		/*
		 * if (subtract < one_minute) {// <1分钟 刚刚 returnString = justString; }
		 * else if (subtract < one_hour) {// <1小时 58分钟前 long result = subtract /
		 * 1000 / 60; returnString = result + minutesString; } else
		 */
		if (timeStamp < (one_day + today) && timeStamp >= today) {
			// >=1小时且在当天 今天15:40
			returnString = /* todayString + */"" + DateFormat.format(FORMAT_TODAY_TIME, timeStamp);
		} else if (timeStamp >= year && timeStamp < (year + one_year)) {
			// 大于1天且在当年 2月2日 15:18
			returnString = DateFormat.format(FORMAT_THIS_YEAR_TIME, timeStamp) + "";
		} else {// 不在当年 12-12-20
			returnString = DateFormat.format(FORMAT_TIME, timeStamp) + "";
		}
		return returnString;
	}

	/**
	 * @Title: getFormatDateTime
	 * @Description: 时间范围 显示格式 >=1小时且在当天 今天15:40 |大于1天且在当年 2月2日 |不在当年 12-12-20
	 * @param timeStr
	 * @return String
	 * @throws
	 * @date 2014-1-16
	 */
	@SuppressWarnings("unused")
	public static String getFormatDateTime3(Context context, String timeStr) {
		if (context == null || isBlankString(timeStr)) {
			return "";
		}
		String FORMAT_TODAY_DATE = "yyyy/MM/dd";
		String FORMAT_THIS_YEAR = "yyyy";
		String FORMAT_TODAY_TIME = "kk:mm";
		String FORMAT_THIS_YEAR_TIME = "MM-dd";
		String FORMAT_TIME = "yy-MM-dd";
		long timeLong = Long.valueOf(timeStr);
		long timeStamp = timeLong;
		if (timeStr.length() == 10) {
			timeStamp = timeLong * 1000;// 转换为毫秒
		}
		long now = System.currentTimeMillis();
		long one_minute = 60 * 1000;// 一分钟
		long one_hour = one_minute * 60; // 一小时
		long one_day = one_hour * 24;// 一天
		long one_year = one_day * 365;// 一年
		String todayDate = DateFormat.format(FORMAT_TODAY_DATE, now).toString();
		String thisYear = DateFormat.format(FORMAT_THIS_YEAR, now).toString();
		Date dt = null;
		Date yt = null;
		try {
			dt = new SimpleDateFormat(FORMAT_TODAY_DATE).parse(todayDate);
			yt = new SimpleDateFormat(FORMAT_THIS_YEAR).parse(thisYear);
		} catch (ParseException e) {
			e.printStackTrace();
		}
		long today = dt.getTime();
		long year = yt.getTime();
		long subtract = now - timeStamp;
		String justString = context.getResources().getString(R.string.util_date_format_just);
		String todayString = context.getResources().getString(R.string.util_date_format_today);
		String minutesString = context.getResources().getString(R.string.util_date_format_minutes);
		String returnString = "";
		/*
		 * if (subtract < one_minute) {// <1分钟 刚刚 returnString = justString; }
		 * else if (subtract < one_hour) {// <1小时 58分钟前 long result = subtract /
		 * 1000 / 60; returnString = result + minutesString; } else
		 */
		if (timeStamp < (one_day + today) && timeStamp >= today) {
			// >=1小时且在当天 今天15:40
			returnString = /* todayString + */"" + DateFormat.format(FORMAT_TODAY_TIME, timeStamp);
		} else if (timeStamp >= year && timeStamp < (year + one_year)) {
			// 大于1天且在当年 2月2日 15:18
			returnString = DateFormat.format(FORMAT_THIS_YEAR_TIME, timeStamp) + "";
		} else {// 不在当年 12-12-20
			returnString = DateFormat.format(FORMAT_TIME, timeStamp) + "";
		}
		return returnString;
	}

	/**
	 * @Title: getFormatLoginDateTime
	 * @Description: 显示最后登录时间 <1小时 登录时间：1分钟前 | 1小时<=登录时间<24小时 登录时间：1小时前
	 *               只取小时，如1:58前，显示1小时前| 1天<=登录时间<7天 登录时间：1天前 只取天，如2.5天前，显示2天前|
	 *               >=7天 登录时间：2012-11-01
	 * @param @param context
	 * @param @param timeStr 时间戳
	 * @param @return
	 * @return String
	 * @throws
	 * @date 2014-1-23
	 */
	public static String getFormatLoginDateTime(Context context, String timeStr) {
		String FORMAT_TIME = "yyyy-MM-dd";
		long timeLong = Long.valueOf(timeStr);
		long timeStamp = timeLong;
		if (timeStr.length() == 10) {
			timeStamp = timeLong * 1000;// 转换为毫秒
		}
		long now = System.currentTimeMillis();
		long one_minute = 60 * 1000;// 一分钟
		long one_hour = one_minute * 60; // 一小时
		long one_day = one_hour * 24;// 一天
		long subtract = now - timeStamp;
		String dayString = context.getResources().getString(R.string.util_date_format_day);
		String hourString = context.getResources().getString(R.string.util_date_format_hour);
		String minutesString = context.getResources().getString(R.string.util_date_format_minutes);
		String returnString = "";
		if (subtract < one_hour && subtract > 0) {// <1小时 58分钟前
			long result = subtract / 1000 / 60;
			if (result == 0) {
				returnString = "刚刚";
			} else {
				returnString = result + minutesString;
			}
		} else if (subtract < one_day && subtract >= one_hour) {// 1小时<=登录时间<24小时
																// 只取小时，如1:58前，显示1小时前
			long result = subtract / 1000 / 60 / 60;
			returnString = result + hourString;
		} else if (subtract >= one_day && subtract < (one_day * 7)) {// 1天<=登录时间<7天
																		// 只取天，如2.5天前，显示2天前
			long result = subtract / 1000 / 60 / 60 / 24;
			returnString = result + dayString;
		} else {// >=7天 2012-11-01
			returnString = DateFormat.format(FORMAT_TIME, timeStamp) + "";
		}
		return returnString;
	}

	/**
	 * 获取周一开始时间的时间戳
	 * 
	 * */
	public static long getThisWeekMondayTimestamp() {
		long tmStamp = 0;
		// 获取本周周一日期
		String mondayDate = getMondayOFWeek();

		// 将日期转化为时间戳
		Date date = null;
		try {
			String myDate = new String(mondayDate);
			if (myDate.indexOf("年") > -1 || myDate.indexOf("月") > -1 || myDate.indexOf("日") > -1) {
				myDate = myDate.replaceAll("年", "-");
				myDate = myDate.replaceAll("月", "-");
				myDate = myDate.replaceAll("日", "-");
			}
			SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
			date = format.parse(myDate);
			if (date != null) {
				// fetch the time as milliseconds from Jan 1, 1970
				tmStamp = date.getTime();
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

		java.text.DateFormat df = java.text.DateFormat.getDateInstance();
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

	public static void populateText(LinearLayout ll, View[] views, Context mContext) {
		populateText(ll, views, mContext, mContext.getResources().getDimensionPixelOffset(R.dimen.global_px96dp), true);
	}

	/**
	 * 可自动换行的 LinearLayout
	 * 
	 * @Title: populateText
	 * @param ll 目标 LinearLayout
	 * @param views LinearLayout内容
	 * @param mContext
	 * @param marin_width 外边据
	 * @param isShowAll 是否需要全部显示，true:全部显示，false:最多显示2行
	 * 
	 * @return int[] int[0]:显示的行数，int[1]:总行数
	 * @throws
	 * @date 2014-2-24
	 */
	public static int[] populateText(LinearLayout ll, View[] views, Context mContext, int marin_width, boolean isShowAll) {
		// 总行数
		int cellInfo[] = { 1, 1 };
		// 获取屏幕宽度
		int screen_width = getScreenWidth(mContext);
		// 移除原layout中的所有内容
		ll.removeAllViews();
		// 放置内容的盒子的宽度（屏幕宽度-外边据）
		int maxWidth = screen_width - marin_width;

		LinearLayout.LayoutParams params;
		LinearLayout newLL = new LinearLayout(mContext);
		newLL.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
		newLL.setGravity(Gravity.LEFT);
		newLL.setOrientation(LinearLayout.HORIZONTAL);

		int widthSoFar = 0;
		for (int i = 0; i < views.length; i++) {
			LinearLayout LL = new LinearLayout(mContext);
			LL.setOrientation(LinearLayout.HORIZONTAL);
			LL.setGravity(Gravity.CENTER_HORIZONTAL | Gravity.BOTTOM);
			LL.setLayoutParams(new ListView.LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT));
			views[i].measure(0, 0);
			params = new LinearLayout.LayoutParams(views[i].getMeasuredWidth(), LayoutParams.WRAP_CONTENT);
			LL.removeAllViews();
			try {
				LL.addView(views[i], params);
			} catch (Exception e) {
				((LinearLayout) views[i].getParent()).removeView(views[i]);
				LL.addView(views[i], params);
			}
			LL.measure(0, 0);
			widthSoFar += views[i].getMeasuredWidth();
			if (widthSoFar >= maxWidth) {
				if (!isShowAll && cellInfo[0] >= 2) {
					cellInfo[1] = 99999;
					break;
				}
				// 在指定显示行数以内，可以继续添加
				ll.addView(newLL);

				newLL = new LinearLayout(mContext);
				newLL.setLayoutParams(new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT));
				newLL.setOrientation(LinearLayout.HORIZONTAL);
				newLL.setGravity(Gravity.LEFT);
				params = new LinearLayout.LayoutParams(LL.getMeasuredWidth(), LL.getMeasuredHeight());
				newLL.addView(LL, params);
				widthSoFar = LL.getMeasuredWidth();

				cellInfo[0]++;
				cellInfo[1]++;
			} else {
				newLL.addView(LL);
			}
		}
		ll.addView(newLL);
		ll.invalidate();

		return cellInfo;
	}

	/**
	 * 替换字符串
	 * 
	 * */
	public static String getString(String raw, Object... formatArgs) throws NotFoundException {
		return String.format(raw, formatArgs);
	}

	/**
	 * 过滤回车换行符
	 * 
	 * */
	public static String replaceEnter(String oldString) {
		Pattern pattern = Pattern.compile("(\r\n|\r|\n|\n\r)");
		// 正则表达式的匹配一定要是这样，单个替换\r|\n的时候会错误
		Matcher matcher = pattern.matcher(oldString);
		String newString = matcher.replaceAll("");
		return newString;
	}

	/**
	 * 回车换行等字符串替换
	 * 
	 * */
	public static String filterString(String str) {
		String lastString = "";
		if (!Util.isBlankString(str)) {
			lastString = str.replace("\\br", "\n");// 替换换行符
			lastString = lastString.replace("<br />", "\n");// 替换
			lastString = lastString.replace("<br>", "\n");
			lastString = lastString.replace("\\n", "\n");
			lastString = lastString.replace("\\r", "\r");
		}
		return lastString;
	}

	/**
	 * @Title: getWidthHeight
	 * @Description: 解析图片url中的宽高
	 * @return int[] 返回类型
	 * @param @param url
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static int[] getWidthHeight(String url) {
		int[] wH = new int[2];
		String WH_STRING = "?wh=";
		String X_STRING = "x";
		int wh_index = url.indexOf(WH_STRING);
		if (wh_index != -1) {
			String wh = url.substring(wh_index + WH_STRING.length());
			int x_index = wh.indexOf(X_STRING);
			if (x_index != -1) {
				String w = wh.substring(0, x_index);
				String h = wh.substring(x_index + X_STRING.length());
				int width = Integer.valueOf(w);
				int height = Integer.valueOf(h);
				wH[0] = width;
				wH[1] = height;
			}
		}
		return wH;
	}

	/**
	 * @Title: sendSMS
	 * @Description: 发送短信
	 * @return void 返回类型
	 * @param @param toNumbers
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void sendSMS(String toNumbers, Context context) {
		String message = context.getString(R.string.sms_text) + J_Consts.SHARE_URL_INVITE + SharedPreUtil.getLoginInfo().uid;

		Uri sendSmsTo = Uri.parse("smsto:" + toNumbers);
		Intent MsgIntent = new Intent(android.content.Intent.ACTION_SENDTO, sendSmsTo);
		MsgIntent.putExtra("sms_body", message);
		context.startActivity(MsgIntent);
	}

	/**
	 * 格式化手机号为138****3075
	 * 
	 * @Title: getFormatMobileNumber
	 * @return String 返回类型
	 * @param @param mobile
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String getFormatMobileNumber(String mobile) {
		if (mobile.length() == 11) {
			String start = mobile.substring(0, 3);
			String end = mobile.substring(7, mobile.length());

			return start + "****" + end;
		}
		return mobile;
	}

	/**
	 * @Title: createNewAvatar
	 * @Description: 创建群聊图片
	 * @return String 返回类型
	 * @param @param avatarList 头像url列表
	 * @param @param mContext
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static String createNewAvatar(ArrayList<String> avatarList, Context mContext) {
		ArrayList<Bitmap> bitmaps = new ArrayList<Bitmap>();
		for (int i = 0; i < avatarList.size(); i++) {
			Bitmap bitmap = getAvatarBitmap(avatarList.get(i), CREATE_AVATAR_WIDTH_HEIGHT, CREATE_AVATAR_WIDTH_HEIGHT);
			if (bitmap != null) {
				bitmaps.add(bitmap);
			}
		}
		if (bitmaps.size() > 0) {
			int white = mContext.getResources().getColor(R.color.WhiteColor);
			Bitmap newBt = createNewAvatar(bitmaps, white, mContext);
			try {
				if (J_FileManager.getInstance().getFileStore().storeBitmap(newBt, GROUP_CHAT_AVATAR)) {
					String newPath = J_FileManager.getInstance().getFileStore().getFileSdcardAndRamPath(GROUP_CHAT_AVATAR);
					return newPath;
				}
			} catch (IOException e) {
				e.printStackTrace();
			} finally {
				for (int i = 0; i < bitmaps.size(); i++) {
					bitmaps.get(i).recycle();
				}
			}
		}
		return "";
	}

	/**
	 * @Title: getAvatarBitmap
	 * @Description: 获得指定尺寸的bitmap
	 * @return Bitmap 返回类型
	 * @param @param url
	 * @param @param width
	 * @param @param height
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static Bitmap getAvatarBitmap(final String url, final int width, final int height) {
		Bitmap avatar = J_NetManager.getInstance().getLoadBitmap(url);
		return Util.resizeImage(avatar, width, height);
	}

	/**
	 * @Title: isRunning
	 * @Description: 判断应用是否运行
	 * @return boolean 返回类型
	 * @param @param context
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static boolean isRunning(Context context) {
		ActivityManager am = (ActivityManager) context.getSystemService(Context.ACTIVITY_SERVICE);
		List<RunningTaskInfo> list = am.getRunningTasks(100);
		for (RunningTaskInfo info : list) {
			if (info.baseActivity.getClassName().equals("com.iyouxun.ui.activity.MainBoxActivity")) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 文本的复制
	 * 
	 * */
	public static void copy(Context context, String content) {
		ClipboardManager cmg = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);
		cmg.setText(content);
		ToastUtil.showToast(context, "复制成功");
	}

	/**
	 * 获得可用的内存
	 * 
	 * @Title: getmem_UNUSED
	 * @return long 返回类型
	 * @param @param mContext
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static long getmem_UNUSED(Context mContext) {
		long MEM_UNUSED;
		// 得到ActivityManager
		ActivityManager am = (ActivityManager) mContext.getSystemService(Context.ACTIVITY_SERVICE);
		// 创建ActivityManager.MemoryInfo对象

		ActivityManager.MemoryInfo mi = new ActivityManager.MemoryInfo();
		am.getMemoryInfo(mi);

		// 取得剩余的内存空间

		MEM_UNUSED = mi.availMem / 1024;
		return MEM_UNUSED;
	}

	/**
	 * 获得总内存
	 * 
	 * @Title: getmem_TOLAL
	 * @return long 返回类型
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static long getmem_TOLAL() {
		long mTotal;
		// /proc/meminfo读出的内核信息进行解释
		String path = "/proc/meminfo";
		String content = null;
		BufferedReader br = null;
		try {
			br = new BufferedReader(new FileReader(path), 8);
			String line;
			if ((line = br.readLine()) != null) {
				content = line;
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (br != null) {
				try {
					br.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
		// beginIndex
		int begin = content.indexOf(':');
		// endIndex
		int end = content.indexOf('k');
		// 截取字符串信息

		content = content.substring(begin + 1, end).trim();
		mTotal = Integer.parseInt(content);
		return mTotal;
	}

	/**
	 * @Description: 是否包含分享用户的url
	 * @return boolean 返回类型
	 * @param @param text
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static long hasUserProfileUrl(String text) {
		if (!Util.isBlankString(text) && text.indexOf(J_Consts.SHARE_URL_USER) != -1) {
			int length = J_Consts.SHARE_URL_USER.length();
			int start = text.indexOf(J_Consts.SHARE_URL_USER) + length;
			int end = text.indexOf(J_Consts.SHARE_URL_USER) + length + 7;
			String uid = text.substring(start, end);
			long userId = Util.getLong(uid);
			if (userId > 0) {
				return userId;
			}
		}
		return 0;
	}
}
