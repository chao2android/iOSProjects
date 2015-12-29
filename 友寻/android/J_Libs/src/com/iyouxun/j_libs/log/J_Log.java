package com.iyouxun.j_libs.log;

import java.util.ArrayList;

import android.util.Log;

import com.lidroid.xutils.util.LogUtils;

public class J_Log {

	public static ArrayList<String> KEEP_TAG = new ArrayList<String>();

	public static void setLogEnable(boolean b) {
		if (b) {
			LogUtils.allowD = true;
			LogUtils.allowE = true;
			LogUtils.allowI = true;
			LogUtils.allowV = true;
			LogUtils.allowW = true;
			LogUtils.allowWtf = true;
		} else {
			LogUtils.allowD = false;
			LogUtils.allowE = false;
			LogUtils.allowI = false;
			LogUtils.allowV = false;
			LogUtils.allowW = false;
			LogUtils.allowWtf = false;
		}
	}

	/**
	 * 前提条件：设置config.LOG_ENABLE = false; 添加一个可以显示日志的TAG
	 * 
	 * @param tag
	 */
	public static void keepTAG(String tag) {
		if (!isKeepTag(tag)) {
			KEEP_TAG.add(tag);
		}
	}

	/**
	 * 前提条件：设置config.LOG_ENABLE = false; 删除一个可以显示日志的TAG
	 * 
	 * @param tag
	 */
	public static void removeTAG(String tag) {
		KEEP_TAG.remove(tag);
	}

	/**
	 * 前提条件：设置config.LOG_ENABLE = false; 清空所有可打印的TAG
	 * 
	 * @param tag
	 */
	public static void removeAllTAG(String tag) {
		KEEP_TAG.clear();
	}

	public static boolean isKeepTag(String tag) {
		if (KEEP_TAG.size() > 0 && KEEP_TAG.contains(tag)) {
			return true;
		}
		return false;
	}

	public static void i(String content) {
		LogUtils.i(content);
	}

	public static void d(String content) {
		LogUtils.d(content);
	}

	public static void w(String content) {
		LogUtils.w(content);
	}

	public static void e(String content) {
		LogUtils.e(content);
	}

	public static void v(String content) {
		LogUtils.v(content);
	}

	public static void i(String TAG, String content) {
		if (LogUtils.allowI || isKeepTag(TAG)) {
			Log.i(TAG, content);
		}
	}

	public static void d(String TAG, String content) {
		if (LogUtils.allowD || isKeepTag(TAG)) {
			Log.i(TAG, content);
		}
	}

	public static void w(String TAG, String content) {
		if (LogUtils.allowW || isKeepTag(TAG)) {
			Log.i(TAG, content);
		}
	}

	public static void e(String TAG, String content) {
		if (LogUtils.allowE || isKeepTag(TAG)) {
			Log.i(TAG, content);
		}
	}

	public static void v(String TAG, String content) {
		if (LogUtils.allowV || isKeepTag(TAG)) {
			Log.i(TAG, content);
		}
	}

}
