package com.iyouxun.utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

import com.iyouxun.J_Application;

/**
 * app配置信息设置
 * 
 * @author likai
 * @date 2014年8月26日 下午6:17:24
 */
public class SettingSharedPreUtil {
	/**
	 * 距离通知
	 * 
	 * @Title: saveDistanceNotification
	 * @return void 返回类型
	 * @param @param distanceNotification 参数类型
	 * @author likai
	 * @throws
	 */
	public static void saveDistanceNotification(String distanceNotification) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.putString("distanceNotification", distanceNotification);
		editor.commit();
	}

	public static String getDistanceNotification() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		String distanceNotification = sp.getString("distanceNotification", "2.0");
		return distanceNotification;
	}

	/**
	 * 是否打开推送设置
	 * 
	 * @Title: saveOpenPush
	 * @return void 返回类型
	 * @param @param isOpenPush 参数类型
	 * @author likai
	 * @throws
	 */
	public static void saveOpenPush(boolean isOpenPush) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.putBoolean("isOpenPush" + SharedPreUtil.getLoginInfo().uid, isOpenPush);
		editor.commit();
	}

	/**
	 * 获取推送开启设置状态
	 * 
	 * @Title: getOpenPush
	 * @return boolean 返回类型
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static boolean getOpenPush() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		boolean isOpenPush = sp.getBoolean("isOpenPush" + SharedPreUtil.getLoginInfo().uid, true);
		return isOpenPush;
	}

	/**
	 * 声音响铃提醒
	 * 
	 * @return void 返回类型
	 * @param @param isVoiceRemind 参数类型
	 * @author tanghao
	 */
	public static void saveVoiceRemind(boolean isVoiceRemind) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_shredpre", Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.putBoolean("isVoiceRemind" + SharedPreUtil.getLoginInfo().uid, isVoiceRemind);
		editor.commit();
	}

	/**
	 * 获取声音响铃提醒设置状态
	 * 
	 * @return boolean 返回类型
	 * @param @return 参数类型
	 * @author tanghao
	 */
	public static boolean getVoiceRemind() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_shredpre", Context.MODE_PRIVATE);
		boolean isVoiceRemind = sp.getBoolean("isVoiceRemind" + SharedPreUtil.getLoginInfo().uid, true);
		return isVoiceRemind;
	}

	/**
	 * 设置震动提醒
	 * 
	 * @return void 返回类型
	 * @param @param isShakeRemind 参数类型
	 * @author tanghao
	 */
	public static void saveShakeRemind(boolean isShakeRemind) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.putBoolean("isShakeRemind" + SharedPreUtil.getLoginInfo().uid, isShakeRemind);
		editor.commit();
	}

	/**
	 * 获取震动提醒状态
	 * 
	 * @return boolean 返回类型
	 * @param @return 参数类型
	 * @author tanghao
	 */
	public static boolean getShakeRemind() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		boolean isShakeRemind = sp.getBoolean("isShakeRemind" + SharedPreUtil.getLoginInfo().uid, true);
		return isShakeRemind;
	}

	/**
	 * 音效提醒
	 * 
	 * @return void 返回类型
	 * @param isSoundRemind 参数类型
	 * @author tanghao
	 */
	public static void saveSoundRemind(boolean isSoundRemind) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.putBoolean("isSoundRemind" + SharedPreUtil.getLoginInfo().uid, isSoundRemind);
		editor.commit();
	}

	/**
	 * 获取音效设置状态
	 * 
	 * @return boolean 返回类型
	 * @param @return 参数类型
	 * @author tanghao
	 */
	public static boolean getSoundRemind() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		boolean isSoundRemind = sp.getBoolean("isSoundRemind" + SharedPreUtil.getLoginInfo().uid, true);
		return isSoundRemind;
	}

	// 位置分享
	public static void saveShareLocation(boolean isShareLocation) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.putBoolean("isShareLocation", isShareLocation);
		editor.commit();
	}

	public static boolean getShareLocation() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		boolean isShareLocation = sp.getBoolean("isShareLocation", true);
		return isShareLocation;
	}

	// 自定义配置信息-String
	public static void saveShareStringConfigInfo(String key, String val) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.putString(key, val);
		editor.commit();
	}

	public static String getShareStringConfigInfo(String key) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		String goldNum = sp.getString(key, "");
		return goldNum;
	}

	// 自定义配置信息-int
	public static void saveShareIntConfigInfo(String key, int val) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.putInt(key, val);
		editor.commit();
	}

	public static int getShareIntConfigInfo(String key) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("setting_sharedpre", Context.MODE_PRIVATE);
		int goldNum = sp.getInt(key, 0);
		return goldNum;
	}

}
