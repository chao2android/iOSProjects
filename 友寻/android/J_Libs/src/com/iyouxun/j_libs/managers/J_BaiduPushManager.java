package com.iyouxun.j_libs.managers;

import com.baidu.android.pushservice.PushConstants;
import com.baidu.android.pushservice.PushManager;
import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.log.J_Log;

/**
 * 百度推送服务管理
 * 
 * @author likai
 * @date 2014年9月16日 下午2:22:49
 */
public class J_BaiduPushManager {
	private static J_BaiduPushManager self = null;
	// 标记百度推送服务是否开启
	private static boolean isPushServiceStarted = false;

	private J_BaiduPushManager() {
	}

	public static J_BaiduPushManager getInstance() {
		if (self == null) {
			self = new J_BaiduPushManager();
		}
		return self;
	}

	/**
	 * 绑定开启百度推送服务
	 * 
	 * @return void 返回类型
	 * @param @param API_KEY 参数类型
	 * @author likai
	 */
	public void connecte(final String API_KEY) {
		J_Log.e("J_BaiduPushManager", "connecte");
		if (isPushServiceStarted) {
			// 百度推送已经绑定，不需重复绑定
			return;
		}

		// 设置推送功能已经开启
		isPushServiceStarted = true;

		// 启动推送服务
		PushManager.startWork(J_SDK.getContext(), PushConstants.LOGIN_TYPE_API_KEY, API_KEY);
	}

	/**
	 * 关闭百度推送服务
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 */
	public void closePushService() {
		if (isPushServiceStarted) {
			isPushServiceStarted = false;
			// 解除绑定
			PushManager.unbind(J_SDK.getContext());
			// 关闭服务
			PushManager.stopWork(J_SDK.getContext());
		}
		J_Log.e("J_BaiduPushManager", "closeed");
	}

}
