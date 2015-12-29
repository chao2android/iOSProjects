package com.iyouxun.j_libs.utils;

import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.URLDecoder;

import android.content.Context;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.telephony.TelephonyManager;

public class J_NetUtil {

	/**
	 * 判断当前网络状态是否可用
	 * 
	 * @return
	 */
	public static boolean isNetConnected(Context context) {
		try {
			ConnectivityManager connectivity = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
			if (connectivity != null) {
				NetworkInfo info = connectivity.getActiveNetworkInfo();
				if (info != null) {
					return info.isConnectedOrConnecting();
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	/**
	 * 判断当前网络是否是wifi类型的网络
	 * 
	 * @param context
	 * @return
	 */
	public static boolean isWIFINetWork(Context mContext) {
		ConnectivityManager connectivity = (ConnectivityManager) mContext.getSystemService(Context.CONNECTIVITY_SERVICE);
		if (connectivity == null) {
			return false;
		} else {
			NetworkInfo net = connectivity.getActiveNetworkInfo();
			if (net != null && net.getState() != null && net.getState() == NetworkInfo.State.CONNECTED) {
				int type = net.getType();
				return type == ConnectivityManager.TYPE_WIFI;
			}
		}
		return false;
	}

	/**
	 * 判断当前网络是否是2G类型的网络
	 * 
	 * @param context
	 * @return
	 */
	public static boolean is2GNetWork(Context context) {
		ConnectivityManager connectivity = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
		if (connectivity == null) {
			return false;
		} else {
			NetworkInfo info = connectivity.getActiveNetworkInfo();
			// if (net != null && net.getState() != null && net.getState() ==
			// NetworkInfo.State.CONNECTED) {
			// int type = net.getType();
			// if(type == ConnectivityManager.TYPE_){
			// return true;
			// }
			//
			// }
			if (info != null) {
				if (info.getSubtype() == TelephonyManager.NETWORK_TYPE_GPRS
						|| info.getSubtype() == TelephonyManager.NETWORK_TYPE_CDMA
						|| info.getSubtype() == TelephonyManager.NETWORK_TYPE_EDGE) {
					return true;
				}
			}
		}
		return false;
	}

	/**
	 * convert URL to URI to deal with URISyntaxException
	 */
	public static URI url2uri(URL url) {
		String query = url.getQuery();
		if (query != null)
			query = URLDecoder.decode(query);
		try {
			return new URI(url.getProtocol(), url.getHost(), url.getPath(), query, null);
		} catch (URISyntaxException e) {
			throw new RuntimeException(e);
		}
	}

}
