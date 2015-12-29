package com.iyouxun.location;

import android.os.Handler;

import com.baidu.location.BDLocation;
import com.baidu.location.BDLocationListener;
import com.baidu.location.LocationClient;
import com.baidu.location.LocationClientOption;
import com.baidu.location.LocationClientOption.LocationMode;
import com.iyouxun.J_Application;
import com.iyouxun.data.beans.LocationInfo;
import com.iyouxun.location.J_LocationManager.J_LocationCallback;
import com.iyouxun.utils.DLog;

/**
 * 百度定位处理
 * 
 * @author likai
 * @date 2014年9月17日 下午2:09:40
 */
public class BaiduLocationManager {
	private J_LocationCallback j_callback = null;
	private LocationClient locationClient = null;
	private BDLocationListener locationListener = new LocationListener();
	private final Handler handler = new Handler();

	public BaiduLocationManager(J_LocationCallback j_callBack) {
		this.j_callback = j_callBack;
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
		locationClient = new LocationClient(J_Application.context);
		locationClient.registerLocationListener(locationListener);

		// 配置定位参数
		LocationClientOption option = new LocationClientOption();
		// 半个小时请求一次
		option.setScanSpan(30 * 60 * 1000);// 30 * 60 * 1000
		// 设置定位模式
		// Hight_Accuracy高精度、Battery_Saving低功耗、Device_Sensors仅设备(GPS)
		option.setLocationMode(LocationMode.Hight_Accuracy);
		// 返回的定位结果是百度经纬度,默认值gcj02
		option.setCoorType("bd09ll");
		// 返回的定位结果包含地址信息
		option.setIsNeedAddress(true);

		locationClient.setLocOption(option);
		// 启动定位SDK
		locationClient.start();
	}

	/**
	 * 请求获取数据
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 */
	public void requestLocation() {
		if (locationClient != null) {
			DLog.i("J_Location", "requestLocation");
			// 发起定位请求
			locationClient.requestLocation();
		}
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
				if (j_callback != null) {
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
						j_callback.onLocationSuccess(point);
					}
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
				if (j_callback != null) {
					j_callback.onLocationFail(code + ":" + message);
				}
			}
		});
	}
}
