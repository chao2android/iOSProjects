package com.iyouxun;

import java.util.HashMap;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;
import java.util.regex.Pattern;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.content.Context;
import android.os.Handler;
import android.os.Message;

import com.baidu.frontia.FrontiaApplication;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.j_libs.J_LibsConfig;
import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.location.J_LocationManager;
import com.iyouxun.utils.Util;

public class J_Application extends FrontiaApplication {
	public static Context context;
	/** 当前的Activity */
	public static Activity sCurrentActiviy;
	/** 收到推送的页面 */
	public static HashMap<String, Activity> pushActiviy = new HashMap<String, Activity>();
	/**
	 * @Fields isInAppStatus :是否在应用内
	 */
	public static boolean isInAppStatus = false;

	@Override
	public void onCreate() {
		super.onCreate();

		context = this;

		// j_libs配置
		if (getAppUid() > 0) {
			J_LibsConfig config = new J_LibsConfig();
			JsonParser jsonParser = new JsonParser();
			config.setJ_JsonParser(jsonParser);// 设置json解析器-网络请求返回后，会使用该解析器解析数据
			config.CLIENT_ID = Util.getClientId();
			config.CHANNEL_ID = Util.getChannelId();
			config.APP_VERSION = Util.getAppVersionName();
			config.OPERATOR_CODE = Util.operatorCode2String();
			config.DEVICE_IMEI = Util.getDeviceIMEI();
			config.MOBILE_MODEL = android.os.Build.MODEL;
			config.SYSTEM_VERSION = android.os.Build.VERSION.RELEASE;
			config.USER_ID = "";
			config.LOG_ENABLE = true;// 是否打印日志信息
			config.CRASH_LOG_ENABLE = false;// 开启crash的日志抓取
			config.API_SETTING = 3;// 接口环境1：测试，2：预上线，3：正式

			// 启动sdk框架
			J_SDK.start(config, context);

			// 网络服务
			initNetManager();

			// 推送服务(百度推送-应该放到用户登录以后去执行，因为需要登录用户的uid)
			// J_BaiduPushManager.getInstance().connecte(J_Consts.BAIDU_PUSH_APIKEY);

			// 定位服务
			initLocations();
		}
	}

	/**
	 * 定位服务配置
	 * 
	 * */
	private void initLocations() {
		// 初始化定位服务
		J_LocationManager.getInstance().init();
		// 获取定位信息
		requestLocation();

		final Handler mHandler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				switch (msg.what) {
				case 0x1000:
					requestLocation();
					break;
				default:
					break;
				}
			}
		};

		// 开启一个定时器，没隔一段时间进行一次定位请求
		new Timer().schedule(new TimerTask() {
			@Override
			public void run() {
				mHandler.sendEmptyMessage(0x1000);
			}
		}, 30 * 60 * 1000, 30 * 60 * 1000);
	}

	/** 获取位置 */
	public static void requestLocation() {
		J_LocationManager.getInstance().requestLocation();
	}

	/** 网络服务配置 */
	private void initNetManager() {
		J_NetManager.TIMEOUT_HTTP_REQUEST = 10000;
		J_NetManager.TIMEOUT_DOWNLOAD_REQUEST = 20000;
		J_NetManager.TIMEOUT_UPLOAD_REQUEST = 60000;
		J_NetManager.RETRY_HTTP_TIMES = 1;
		// 设置全局请求参数
		HashMap<String, String> hashMap = new HashMap<String, String>();
		hashMap.put("reg_meid", Util.getDeviceIMEI());
		hashMap.put("reg_channel_id", Util.getChannelId());
		hashMap.put("reg_mtype", "android");
		hashMap.put("reg_version", Util.getAppVersionName());
		J_NetManager.getInstance().setCommonParams(hashMap);
	}

	/**
	 * 判断字符串内容是否为数字
	 * 
	 * @return boolean 返回类型
	 * @param @param str
	 * @param @return 参数类型
	 * @author likai
	 */
	public static boolean isNumeric(String str) {
		Pattern pattern = Pattern.compile("[0-9]*");
		return pattern.matcher(str).matches();
	}

	/**
	 * 获取APP主进程的进程ID
	 * 
	 * @return
	 */
	private int getAppUid() {
		// 当前进程id
		int pid = android.os.Process.myPid();
		// 遍历当前所有进程，从中过滤出主进程id
		ActivityManager am = (ActivityManager) this.getSystemService(Context.ACTIVITY_SERVICE);
		List<RunningAppProcessInfo> apps = am.getRunningAppProcesses();

		for (RunningAppProcessInfo info : apps) {
			if (info.processName.equals(this.getPackageName()) && info.pid == pid) {
				return info.uid;
			}
		}
		return -1;
	}
}
