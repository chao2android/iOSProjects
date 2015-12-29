package com.iyouxun.j_libs;

import android.content.Context;

import com.iyouxun.j_libs.crash.CrashHandler;
import com.iyouxun.j_libs.log.J_Log;

public class J_SDK {
	/**
	 * SDK的设置
	 */
	private static J_LibsConfig j_LibsConfig;

	private static Context j_Context;

	/**
	 * 在Application的onCtreate方法中调用一次即可。
	 * 
	 * @param config
	 * @param context
	 */
	public static void start(J_LibsConfig config, Context context) {
		j_LibsConfig = config;
		j_Context = context;

		J_Log.setLogEnable(config.LOG_ENABLE);

		// 抓取崩溃日志设置
		if (j_LibsConfig.CRASH_LOG_ENABLE) {
			CrashHandler.TAG = j_LibsConfig.CRASH_LOG_TAG;
			CrashHandler.FILE_DIR = j_LibsConfig.CRASH_LOG_PATH;
			CrashHandler crashHandler = CrashHandler.getInstance();
			crashHandler.init(j_Context);
		}

	};

	public static J_LibsConfig getConfig() {
		return j_LibsConfig;
	}

	public static Context getContext() {
		return j_Context;
	}

}
