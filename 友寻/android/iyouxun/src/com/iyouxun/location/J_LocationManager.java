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
	public void init() {
		DLog.d("J_Location", "初始化定位服务");
		if (baiduLocation != null) {
			baiduLocation.destroy();
		}
		baiduLocation = new BaiduLocationManager();
	}

	/**
	 * 启动定位
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public void requestLocation() {
		if (baiduLocation == null) {
			init();
		}
		baiduLocation.requestLocation();
	}

	public void destroy() {
		baiduLocation.destroy();
	}

}
