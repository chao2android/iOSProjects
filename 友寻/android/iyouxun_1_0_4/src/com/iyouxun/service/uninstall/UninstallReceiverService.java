package com.iyouxun.service.uninstall;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.ArrayList;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Build;

import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.utils.DLog;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

/**
 * 卸载程序的监听
 * 
 * @author qiandong
 * 
 */
public class UninstallReceiverService extends BroadcastReceiver {
	private static final String TAG = "UninstalledObserverActivity";
	private String DestIp = "223.202.50.102";
	private final int DestPort = 80;
	private final String req = "GET /cmiajax/?mod=log&func=cpc&c=205120";
	private String host = " HTTP/1.1\r\nHost:c.iyouxun.com\r\nConnection: Close\r\n\r\n";
	private long uid;
	private String mac = "";
	private boolean isLoadLib = false;

	// 监听进程pid
	private int mObserverProcessPid = -1;

	public native int init(String user, String DestIp, String url);

	// public native void sendMessage(String uid);

	static {
		DLog.d(TAG, "load lib --> uninstalled_observer");
		try {
			System.loadLibrary("iyouxun");
		} catch (Exception e) {
		}
	}

	@Override
	public void onReceive(Context context, Intent intent) {
		if (intent.getAction() == "com.iyouxun.uninstall.listenser") {
			if (isLoadLib || !"0".equals(isCreateFork("ps -ef com.iyouxun"))) {
				DLog.d(TAG, "卸载已启动");
				return;
			}

			WifiManager wifi = (WifiManager) context.getApplicationContext().getSystemService(Context.WIFI_SERVICE);
			WifiInfo info = wifi.getConnectionInfo();
			mac = info.getMacAddress();

			// 渠道ID
			String channelID = Util.getChannelId();

			String mei = Util.getDeviceIMEI();
			if (channelID == null) {
				channelID = "";
			}
			if (mei == null) {
				mei = "";
			}
			String mobile = "";
			long autoLoginId = SharedPreUtil.getLoginInfo().uid;
			if (autoLoginId > 0) {
				mobile = SharedPreUtil.getLoginInfo().userName;
				uid = autoLoginId;
			}
			DLog.d(TAG, "channelID:" + channelID);
			DLog.d(TAG, "mei:" + mei);
			if (J_SDK.getConfig().API_SETTING == 3) {
				DestIp = "223.202.50.73";
				host = " HTTP/1.1\r\nHost:c.iyouxun.dev\r\nConnection: Close\r\n\r\n";
			}

			String app_ver = "android_ver_" + Util.getAppVersionName();
			app_ver = app_ver.replace(".", "_");
			String url = String.format("%s&mobile=%s&uid=%s&app-ver=%s&mac=%s&channelID=%s&meiID=%s%s", req, mobile, uid,
					app_ver, mac, channelID, mei, host);
			if (Build.VERSION.SDK_INT >= 17)
				mObserverProcessPid = init(getUserSerial(context), DestIp, url);
			else
				mObserverProcessPid = init(null, DestIp, url);
			isLoadLib = true;
		}
	}

	private String isCreateFork(String command) {
		String pid = "0";
		try {
			Runtime runtime = Runtime.getRuntime();
			Process proc = runtime.exec(command);

			BufferedReader in = new BufferedReader(new InputStreamReader(proc.getInputStream()));
			String line = null;
			ArrayList<String[]> arrayList = new ArrayList<String[]>();
			DLog.i(TAG, "isCreateFork-----------");

			while ((line = in.readLine()) != null) {
				line = line.replaceAll(" +", ",");
				String[] strings = line.split(",");
				arrayList.add(strings);

				DLog.i(TAG, line);
			}

			for (int i = 1; i < arrayList.size(); i++) {
				String[] str = arrayList.get(i);
				if ("1".equals(str[2]))
					pid = str[1];
				else {
					for (int j = 1; j < arrayList.size(); j++) {
						String[] str2 = arrayList.get(i);
						if (str2[1].equals(str[2]))
							pid = str[1];
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return pid;
	}

	// 由于targetSdkVersion低于17，只能通过反射获取
	private String getUserSerial(Context context) {
		Object userManager = context.getSystemService("user");
		if (userManager == null) {
			DLog.e(TAG, "userManager not exsit !!!");
			return null;
		}
		try {
			Method myUserHandleMethod = android.os.Process.class.getMethod("myUserHandle", (Class<?>[]) null);
			Object myUserHandle = myUserHandleMethod.invoke(android.os.Process.class, (Object[]) null);

			Method getSerialNumberForUser = userManager.getClass().getMethod("getSerialNumberForUser", myUserHandle.getClass());
			long userSerial = (Long) getSerialNumberForUser.invoke(userManager, myUserHandle);
			return String.valueOf(userSerial);
		} catch (NoSuchMethodException e) {
		} catch (IllegalArgumentException e) {
		} catch (IllegalAccessException e) {
		} catch (InvocationTargetException e) {
		}
		return null;
	}

}
