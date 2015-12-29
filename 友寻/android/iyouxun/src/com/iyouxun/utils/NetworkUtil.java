/**
 * 
 * @Package com.iyouxun.utils
 * @author likai
 * @date 2015-6-16 上午11:06:02
 * @version V1.0
 */
package com.iyouxun.utils;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;

/**
 * 
 * @author likai
 * @date 2015-6-16 上午11:06:02
 * 
 */
public class NetworkUtil {
	/**
	 * 检测网络连接
	 * 
	 */
	protected static boolean checkConnection(Context context) {
		ConnectivityManager connectivityManager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo networkInfo = connectivityManager.getActiveNetworkInfo();
		if (networkInfo != null) {
			return networkInfo.isAvailable();
		}
		return false;
	}

	/**
	 * 检查当前开启网络是否为wifi模式
	 * 
	 */
	public static boolean isWifi(Context mContext) {
		ConnectivityManager connectivityManager = (ConnectivityManager) mContext.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo activeNetInfo = connectivityManager.getActiveNetworkInfo();
		if (activeNetInfo != null && activeNetInfo.getTypeName().equals("WIFI")) {
			return true;
		}
		return false;
	}

	/**
	 * 检查网络状态
	 * 
	 */
	public static boolean checkNetwork(Context c) {
		// 判断网络状态
		return checkConnection(c);
	}
}
