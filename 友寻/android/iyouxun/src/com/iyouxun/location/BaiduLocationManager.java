package com.iyouxun.location;

import android.content.Intent;
import android.os.Handler;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.location.LocationClientOption.LocationMode;
import com.iyouxun.J_Application;
import com.iyouxun.data.beans.LocationInfo;
import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.utils.DLog;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

/**
 * 百度定位处理
 * 
 * @author likai
 * @date 2014年9月17日 下午2:09:40
 */
public class BaiduLocationManager {
	private LocationClient locationClient = null;
	private BDLocationListener locationListener;
	private final Handler handler = new Handler();

	public BaiduLocationManager() {
		init();
	}

	/**
	 * 初始化并配置百度定位服务所需要的参数
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 */
	private void init() {
		DLog.i("J_Location", "init()");
		// 声明LocationClient类
		locationClient = new LocationClient(J_Application.context);
		// 注册监听函数
		locationListener = new LocationListener();
		locationClient.registerLocationListener(locationListener);

		if (J_SDK.getConfig().LOG_ENABLE) {
			locationClient.setDebug(true);
		}

		// 配置定位参数
		LocationClientOption option = new LocationClientOption();
		// 半个小时请求一次
		option.setScanSpan(30 * 60 * 1000);// 半个小时
		// 设置定位模式
		// Hight_Accuracy高精度、Battery_Saving低功耗、Device_Sensors仅设备(GPS)
		option.setLocationMode(LocationMode.Hight_Accuracy);
		// 返回的定位结果是百度经纬度,默认值gcj02
		option.setCoorType("bd09ll");
		// 返回的定位结果包含地址信息
		option.setIsNeedAddress(true);

		locationClient.setLocOption(option);
	}

	/**
	 * 请求获取数据
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 */
	public void requestLocation() {
		DLog.i("lika-test", "requestLocation");
		if (locationClient == null || !locationClient.isStarted()) {
			init();
		}

		locationClient.start();// 启动定位SDK服务
		// locationClient.requestLocation();// 发起定位请求
	}

	/**
	 * 取消定位
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 */
	public void destroy() {
		if (locationClient != null) {
			// 关闭定位SDK。调用stop之后，设置的参数LocationClientOption仍然保留
			locationClient.stop();
			locationClient.unRegisterLocationListener(locationListener);
			locationListener = null;
			locationClient = null;
		}
	}

	/**
	 * 实现BDLocationListener接口 BDLocationListener接口有2个方法需要实现：
	 * 1.接收异步返回的定位结果，参数是BDLocation类型参数。
	 * 
	 * @author likai
	 * @date 2014年9月17日 下午2:31:33
	 */
	private class LocationListener implements BDLocationListener {
		@Override
		public void onReceiveLocation(final BDLocation location) {
			DLog.d("likai-test", "获取到定位结果---onReceiveLocation");
			if (location == null) {
				return;
			}

			// 获取error code：
			int locType = location.getLocType();

			// 162~167： 服务端定位失败
			if (locType >= 162 && locType <= 167) {
				String message = "服务端定位失败";
				displayError(locType, message);
			} else {
				// 定位成功
				displayLocation(location);
				// 停止服务
				destroy();
			}
		}
	}

	/**
	 * 定位成功，返回定位结果，进行结果保存
	 * 
	 * @return void 返回类型
	 * @param @param location 参数类型
	 * @author likai
	 */
	private void displayLocation(final BDLocation location) {
		handler.post(new Runnable() {
			@Override
			public void run() {
				double lng = location.getLongitude();
				double lat = location.getLatitude();
				if (lng != 4.9E-324 && lat != 4.9E-324) {
					// 需要过滤一层错误定位数据
					J_LocationPoint point = new J_LocationPoint(lng, lat);
					point.locationInfo = new LocationInfo();
					point.locationInfo.city = location.getCity();
					point.locationInfo.province = location.getProvince();
					point.locationInfo.district = location.getDistrict();
					point.locationInfo.address = location.getAddrStr();
					point.locationInfo.street = location.getStreet();
					// 保存位置信息
					DLog.i("likai-test", "获取到的当前位置:" + point.getLongitude() + "," + point.getLatitude());
					SharedPreUtil.saveLocation(point);
					Intent intent = new Intent();
					intent.setAction(UtilRequest.BROADCAST_ACTION_REFRESH_LOCATION);
					Util.sendBroadcast(intent);
				}
			}
		});
	}

	/**
	 * 定位失败，返回失败信息
	 * 
	 * @return void 返回类型
	 * @param @param code
	 * @param @param message 参数类型
	 * @author likai
	 */
	private void displayError(final int code, final String message) {
		handler.post(new Runnable() {
			@Override
			public void run() {
				Intent intent = new Intent();
				intent.setAction(UtilRequest.BROADCAST_ACTION_REFRESH_LOCATION);
				Util.sendBroadcast(intent);
			}
		});
	}
}
