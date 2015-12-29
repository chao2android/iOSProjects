package com.iyouxun.location;

import com.iyouxun.utils.DLog;

/**
 * 定位服务模块处理
 * 
 * @author likai
 * @date 2014年9月17日 下午2:04:11
 */
public class J_LocationManager {
	private static J_LocationManager self = null;
	private static BaiduLocationManager baiduLocation = null;

	// 定位回调方法
	public interface J_LocationCallback {
		public abstract void onLocationSuccess(J_LocationPoint point);

		public abstract void onLocationFail(String msg);
	}

	private J_LocationManager() {
	}

	public static J_LocationManager getInstance() {
		if (self == null) {
			self = new J_LocationManager();
		}
		return self;
	}

	/**
	 * 初始化定位模块
	 */
	public void init(J_LocationCallback j_callback) {
		DLog.d("J_Location", "初始化定位服务");
		if (baiduLocation != null) {
			baiduLocation.destroy();
		}
		baiduLocation = new BaiduLocationManager(j_callback);
	}

	public void requestLocation() {
		if (baiduLocation != null) {
			baiduLocation.requestLocation();
		}
	}

	public void destroy() {
		baiduLocation.destroy();
	}

}
