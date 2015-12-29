package com.iyouxun.j_libs.utils;

import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.preference.PreferenceManager;

import com.iyouxun.j_libs.J_SDK;

public class J_SharedPreUtil {
	/**
	 * 存储一个默认存储的全局参数
	 * 
	 * @return void 返回类型
	 * @param @param key
	 * @param @param value 参数类型
	 * @author likai
	 */
	public static void setDefaultSharedDataString(String key, String value) {
		SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(J_SDK.getContext());
		Editor editor = sp.edit();
		editor.putString(key, value);
		editor.commit();
	}

	public static String getDefaultSharedDataString(String key) {
		SharedPreferences sp = PreferenceManager.getDefaultSharedPreferences(J_SDK.getContext());
		String val = sp.getString(key, "");
		return val;
	}
}
