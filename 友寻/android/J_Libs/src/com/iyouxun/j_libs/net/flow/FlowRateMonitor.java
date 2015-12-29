package com.iyouxun.j_libs.net.flow;

import java.util.List;

import android.app.ActivityManager;
import android.app.ActivityManager.RunningAppProcessInfo;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.net.TrafficStats;

import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.log.J_Log;
import com.iyouxun.j_libs.utils.J_CommonUtils;
import com.iyouxun.j_libs.utils.J_NetUtil;

/**
 * 流量检测器
 * 
 * @author wang
 * 
 */
public class FlowRateMonitor {
	public static final String TAG = "J_FLOW_RATE";

	/**
	 * 数据单位为b
	 */
	public static final int UNIT_BYTE = 0;
	/**
	 * 结算单位为kb
	 */
	public static final int UNIT_KB = 1;
	private static FlowRateMonitor self = null;
	private int uid = -1;

	/**
	 * 获取已保存的Wifi上行流量的标记，供getFlowData(String whitchFlow)使用
	 */
	public static final String FLOW_WIFI_UPLOAD = "FLOW_WIFI_UPLOAD";
	/**
	 * 获取已保存的Wifi下行流量的标记，供getFlowData(String whitchFlow)使用
	 */
	public static final String FLOW_WIFI_DOWNLOAD = "FLOW_WIFI_DOWNLOAD";
	/**
	 * 获取已保存的非Wifi上行流量的标记，供getFlowData(String whitchFlow)使用
	 */
	public static final String FLOW_MOBILE_UPLOAD = "FLOW_MOBILE_UPLOAD";
	/**
	 * 获取已保存的非Wifi下行流量的标记，供getFlowData(String whitchFlow)使用
	 */
	public static final String FLOW_MOBILE_DOWNLOAD = "FLOW_MOBILE_DOWNLOAD";
	/**
	 * 获取已保存的总上行流量的标记，供getFlowData(String whitchFlow)使用
	 */
	public static final String FLOW_TOTAL_UPLOAD = "FLOW_TOTAL_UPLOAD";
	/**
	 * 获取已保存的总下行流量的标记，供getFlowData(String whitchFlow)使用
	 */
	public static final String FLOW_TOTAL_DOWNLOAD = "FLOW_TOTAL_DOWNLOAD";

	// ----------------总流量统计------------------
	/**
	 * 起始时的上行流量
	 */
	private long startUploadRate = -1;
	/**
	 * 起始时的下行流量
	 */
	private long startDownloadRate = -1;
	/**
	 * 结束时的上行流量
	 */
	private long endUploadRate = -1;
	/**
	 * 结束时的下行流量
	 */
	private long endDownloadRate = -1;

	// ----------------WIFI流量统计------------------
	/**
	 * wifi环境下起始时的上行流量
	 */
	private long startWifiUploadRate = -1;
	/**
	 * wifi环境下起始时的下行流量
	 */
	private long startWifiDownloadRate = -1;
	/**
	 * wifi环境下结束时的上行流量
	 */
	private long endWifiUploadRate = -1;
	/**
	 * wifi环境下结束时的下行流量
	 */
	private long endWifiDownloadRate = -1;
	/**
	 * wifi环境下使用的总下行流量
	 */
	private long wifiDownloadRateCount = 0;
	/**
	 * wifi环境下结束时的总上行流量
	 */
	private long wifiUploadRateCount = 0;

	// ----------------移动网络流量统计------------------

	/**
	 * 移动网络环境下起始时的上行流量
	 */
	private long startMobileUploadRate = -1;
	/**
	 * 移动网络环境下起始时的下行流量
	 */
	private long startMobileDownloadRate = -1;
	/**
	 * 移动网络环境下结束时的上行流量
	 */
	private long endMobileUploadRate = -1;
	/**
	 * 移动网络环境下结束时的下行流量
	 */
	private long endMobileDownloadRate = -1;
	/**
	 * 移动网络环境下结束时的总下行流量
	 */
	private long mobileDownloadRateCount = 0;
	/**
	 * 移动网络环境下结束时的总上行流量
	 */
	private long mobileUploadRateCount = 0;

	public static FlowRateMonitor getInstance() {
		if (self == null) {
			self = new FlowRateMonitor();
		}

		return self;
	}

	/**
	 * 用于监听系统的网络变化，根据变化去统计不同的流量数据
	 */
	private final BroadcastReceiver broadcastReceiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {

			if (!intent.getAction().equals("android.net.conn.CONNECTIVITY_CHANGE")) {
				return;
			}

			if (uid == -1) {
				uid = getAppUid();
			}

			ConnectivityManager manager = (ConnectivityManager) context.getSystemService(Context.CONNECTIVITY_SERVICE);
			NetworkInfo mobileInfo = manager.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
			NetworkInfo wifiInfo = manager.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
			J_Log.i(TAG, "收到广播<<<<<<<<<<<<<<<<<<<<<<<");
			if (!J_NetUtil.isNetConnected(context)) {
				endWifiRecord();
				endMobileRecord();
				J_Log.i(TAG, "无网络连接");
			} else {
				J_Log.i(TAG, "有网络连接");
				if (mobileInfo.isConnected()) {
					J_Log.i(TAG, "移动网络已连接");
					startMobileRecord();
					endWifiRecord();
				}

				if (wifiInfo.isConnected()) {
					J_Log.i(TAG, "Wifi网络已连接");
					startWifiRecord();
					endMobileRecord();
				}
			}

			J_Log.i(TAG, "广播处理完毕>>>>>>>>>>>>>>>>>>>>>>");

		}
	};

	/**
	 * 是否正在记录Wifi流量
	 */
	private boolean isWifiRecording = false;
	/**
	 * 是否正在记录3G流量
	 */
	private boolean isMobileRecording = false;

	/**
	 * 开始记录wifi流量
	 */
	private void startWifiRecord() {
		if (!isWifiRecording) {
			isWifiRecording = true;
			J_Log.i(TAG, "startWifiRecord()");
			startWifiDownloadRate = TrafficStats.getUidRxBytes(uid);
			startWifiUploadRate = TrafficStats.getUidTxBytes(uid);
		}

	}

	/**
	 * 停止记录wifi流量
	 */
	private void endWifiRecord() {
		if (isWifiRecording) {
			isWifiRecording = false;
			J_Log.i(TAG, "endWifiRecord()");
			endWifiUploadRate = TrafficStats.getUidTxBytes(uid);
			endWifiDownloadRate = TrafficStats.getUidRxBytes(uid);
			wifiDownloadRateCount += (endWifiDownloadRate - startWifiDownloadRate);
			wifiUploadRateCount += (endWifiUploadRate - startWifiUploadRate);
		}
	}

	/**
	 * 开始记录3G流量
	 */
	private void startMobileRecord() {
		if (!isMobileRecording) {
			isMobileRecording = true;
			J_Log.i(TAG, "startMobileRecord()");
			startMobileDownloadRate = TrafficStats.getUidRxBytes(uid);
			startMobileUploadRate = TrafficStats.getUidTxBytes(uid);
		}

	}

	/**
	 * 停止记录3G流量
	 */
	private void endMobileRecord() {
		if (isMobileRecording) {
			isMobileRecording = false;
			J_Log.i(TAG, "endMobileRecord()");
			endMobileUploadRate = TrafficStats.getUidTxBytes(uid);
			endMobileDownloadRate = TrafficStats.getUidRxBytes(uid);
			mobileDownloadRateCount += (endMobileDownloadRate - startMobileDownloadRate);
			mobileUploadRateCount += (endMobileUploadRate - startMobileUploadRate);
		}
	}

	/**
	 * 主函数，开始统计流量，会自动判断网络环境开启对应的统计机制
	 */
	public void startRecord() {
		J_Log.i(TAG, "startRecord()");
		wifiDownloadRateCount = 0;
		wifiUploadRateCount = 0;
		mobileDownloadRateCount = 0;
		mobileUploadRateCount = 0;

		// /** 获取手机通过 2G/3G 接收的字节流量总数 */
		// TrafficStats.getMobileRxBytes();
		// /** 获取手机通过 2G/3G 接收的数据包总数 */
		// TrafficStats.getMobileRxPackets();
		// /** 获取手机通过 2G/3G 发出的字节流量总数 */
		// TrafficStats.getMobileTxBytes();
		// /** 获取手机通过 2G/3G 发出的数据包总数 */
		// TrafficStats.getMobileTxPackets();
		// /** 获取手机通过所有网络方式接收的字节流量总数(包括 wifi) */
		// TrafficStats.getTotalRxBytes();
		// /** 获取手机通过所有网络方式接收的数据包总数(包括 wifi) */
		// TrafficStats.getTotalRxPackets();
		// /** 获取手机通过所有网络方式发送的字节流量总数(包括 wifi) */
		// TrafficStats.getTotalTxBytes();
		// /** 获取手机通过所有网络方式发送的数据包总数(包括 wifi) */
		// TrafficStats.getTotalTxPackets();

		if (uid == -1) {
			uid = getAppUid();
		}
		J_Log.i(TAG, "uid = " + uid);
		boolean isWifi = J_NetUtil.isWIFINetWork(J_SDK.getContext());

		if (isWifi) {
			J_Log.i(TAG, "当前网络环境-->wifi");
			startWifiRecord();
		} else {
			J_Log.i(TAG, "当前网络环境-->mobile");
			startMobileRecord();
		}

		// /** 获取手机指定 UID 对应的应程序用通过所有网络方式接收的字节流量总数(包括 wifi) */
		startDownloadRate = TrafficStats.getUidRxBytes(uid);
		// /** 获取手机指定 UID 对应的应用程序通过所有网络方式发送的字节流量总数(包括 wifi) */
		startUploadRate = TrafficStats.getUidTxBytes(uid);
		// J_Log.i(TAG,
		// "开始统计流量，当前上行:"+startUploadRate+"\n当前下行"+startDownloadRate);
		IntentFilter filter = new IntentFilter();
		filter.addAction("android.net.conn.CONNECTIVITY_CHANGE");
		J_SDK.getContext().registerReceiver(broadcastReceiver, filter);
	}

	/**
	 * 主函数，停止流量统计，并对Wifi流量和3G流量做结算， 调用该方法后可以调用getXXXByteCount(int
	 * unit)方法获取统计后的数值， 也可调用saveFlowData(int unit)对数据进行本地化存储
	 */
	public void stopRecord() {
		J_Log.i(TAG, "stopRecord()");
		endUploadRate = TrafficStats.getUidTxBytes(uid);
		endDownloadRate = TrafficStats.getUidRxBytes(uid);
		// J_Log.i(TAG, "停止统计流量，当前上行:"+endUploadRate+"\n当前下行"+endDownloadRate);
		endWifiRecord();
		endMobileRecord();
		J_SDK.getContext().unregisterReceiver(broadcastReceiver);
	}

	/**
	 * 获取startRecord()和stopRecord()之间的上行流量，-1为计算失败
	 * 
	 * @return
	 */
	public long getUploadByteCount(int unit) {
		long count = endUploadRate - startUploadRate;
		// J_Log.i(TAG, "共消耗上行流量-->"+count+"byte");
		return computeResult(unit, count);
	}

	/**
	 * 获取startRecord()和stopRecord()之间的下行流量，-1为计算失败
	 * 
	 * @return
	 */
	public long getDownloadByteCount(int unit) {
		long count = endDownloadRate - startDownloadRate;
		// J_Log.i(TAG, "共消耗下行流量-->"+count+"byte");
		return computeResult(unit, count);
	}

	/**
	 * 获取startRecord()和stopRecord()之间的wifi上行流量，-1为计算失败
	 * 
	 * @return
	 */
	public long getWifiUploadByteCount(int unit) {
		// J_Log.i(TAG, "共消耗上行流量-->"+count+"byte");
		return computeResult(unit, wifiUploadRateCount);
	}

	/**
	 * 获取startRecord()和stopRecord()之间的wifi下行流量，-1为计算失败
	 * 
	 * @return
	 */
	public long getWifiDownloadByteCount(int unit) {
		// J_Log.i(TAG, "共消耗下行流量-->"+count+"byte");
		return computeResult(unit, wifiDownloadRateCount);
	}

	/**
	 * 获取startRecord()和stopRecord()之间的移动网络上行流量，-1为计算失败
	 * 
	 * @return
	 */
	public long getMobileUploadByteCount(int unit) {
		// J_Log.i(TAG, "共消耗上行流量-->"+count+"byte");
		return computeResult(unit, mobileUploadRateCount);
	}

	/**
	 * 获取startRecord()和stopRecord()之间的移动网络下行流量，-1为计算失败
	 * 
	 * @return
	 */
	public long getMobileDownloadByteCount(int unit) {
		// J_Log.i(TAG, "共消耗下行流量-->"+count+"byte");
		return computeResult(unit, mobileDownloadRateCount);
	}

	private long computeResult(int unit, long byteCount) {

		if (unit == UNIT_BYTE) {
			return byteCount;
		}

		if (unit == UNIT_KB) {
			return byteCount / 1024;
		}

		return -1;
	}

	/**
	 * 获取该APP的进程ID
	 * 
	 * @return
	 */
	private int getAppUid() {
		// J_Log.i(TAG, "获取APP UID");
		ActivityManager am = (ActivityManager) J_SDK.getContext().getSystemService(Context.ACTIVITY_SERVICE);
		List<RunningAppProcessInfo> apps = am.getRunningAppProcesses();

		for (RunningAppProcessInfo info : apps) {
			if (info.processName.equals(J_SDK.getContext().getPackageName())) {
				// J_Log.i(TAG, "APP UID = "+info.uid);
				return info.uid;
			}
		}
		// J_Log.i(TAG, "APP UID = -1");
		return -1;
	}

	/**
	 * 保存当次统计的数据, 必须在stopRecord（）之后调用，否则数据不准确
	 * 
	 * @param unit 保存数据时的单位，保存时时kb取的就是kb
	 */
	public void saveFlowData(int unit) {
		SharedPreferences sp = J_SDK.getContext().getSharedPreferences("net_flow", Context.MODE_PRIVATE);
		sp.edit().putLong(FLOW_TOTAL_UPLOAD, getUploadByteCount(unit)).putLong(FLOW_TOTAL_DOWNLOAD, getDownloadByteCount(unit))
				.putLong(FLOW_WIFI_UPLOAD, getWifiUploadByteCount(unit))
				.putLong(FLOW_WIFI_DOWNLOAD, getWifiDownloadByteCount(unit))
				.putLong(FLOW_MOBILE_UPLOAD, getMobileUploadByteCount(unit))
				.putLong(FLOW_MOBILE_DOWNLOAD, getMobileDownloadByteCount(unit)).commit();
	}

	/**
	 * 获取saveFlowData(int unit)保存的流量数据
	 * 
	 * @param whitchFlow 
	 *            FlowRateMonitor.FLOW_WIFI_UPLOAD\FLOW_WIFI_DOWNLOAD\FLOW_MOBILE_UPLOAD
	 *            \FLOW_MOBILE_DOWNLOAD\FLOW_TOTAL_UPLOAD\FLOW_TOTAL_DOWNLOAD
	 * 
	 * @return -1表示获取失败
	 */
	public long getFlowData(String whitchFlow) {

		if (J_CommonUtils.isEmpty(whitchFlow)) {
			return -1;
		}

		SharedPreferences sp = J_SDK.getContext().getSharedPreferences("net_flow", Context.MODE_PRIVATE);

		if (whitchFlow.equals(FLOW_TOTAL_UPLOAD)) {
			return sp.getLong(FLOW_TOTAL_UPLOAD, -1);
		} else if (whitchFlow.equals(FLOW_TOTAL_DOWNLOAD)) {
			return sp.getLong(FLOW_TOTAL_DOWNLOAD, -1);
		} else if (whitchFlow.equals(FLOW_WIFI_UPLOAD)) {
			return sp.getLong(FLOW_WIFI_UPLOAD, -1);
		} else if (whitchFlow.equals(FLOW_WIFI_DOWNLOAD)) {
			return sp.getLong(FLOW_WIFI_DOWNLOAD, -1);
		} else if (whitchFlow.equals(FLOW_MOBILE_UPLOAD)) {
			return sp.getLong(FLOW_MOBILE_UPLOAD, -1);
		} else if (whitchFlow.equals(FLOW_MOBILE_DOWNLOAD)) {
			return sp.getLong(FLOW_MOBILE_DOWNLOAD, -1);
		}

		return -1;

	}

}
