package com.iyouxun.receivers;

import java.util.ArrayList;
import java.util.List;

import android.content.Context;

import com.baidu.android.pushservice.PushManager;
import com.baidu.android.pushservice.PushMessageReceiver;
import com.iyouxun.J_Application;
import com.iyouxun.data.parser.SocketParser;
import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.log.J_Log;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.net.socket.protocol.AbsPushProtocol;
import com.iyouxun.net.socket.protocol.SocketProtocol;
import com.iyouxun.utils.SettingSharedPreUtil;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.SocketUtil;
import com.iyouxun.utils.Util;

/**
 * 百度推送接受消息处理
 * 
 * Push消息处理receiver。<br />
 * 请编写您需要的回调函数， 一般来说： onBind是必须的，用来处理startWork返回值； <br />
 * onMessage用来接收透传消息；<br />
 * onSetTags、onDelTags、onListTags是tag相关操作的回调；<br />
 * onNotificationClicked在通知被点击时回调；<br />
 * onUnbind是stopWork接口的返回值回调*
 * 
 * @author likai
 * @date 2014年9月16日 下午2:08:22
 */
public class MyPushMessageReceiver extends PushMessageReceiver {

	/**
	 * 调用PushManager.startWork后，sdk将对push
	 * server发起绑定请求，这个过程是异步的。绑定请求的结果通过onBind返回。
	 * 
	 * @param context BroadcastReceiver的执行Context
	 * @param errorCode 绑定接口返回值，0 - 成功
	 * @param appid 应用id。errorCode非0时为null
	 * @param userId 应用user id。errorCode非0时为null
	 * @param channelId 应用channel id。errorCode非0时为null
	 * @param requestId 向服务端发起的请求id。在追查问题时有用；
	 * @return none
	 */
	@Override
	public void onBind(Context context, int errorCode, String appid, String userId, String channelId, String requestId) {
		StringBuilder sb = new StringBuilder();
		sb.append("MyPushMessageReceiver-onBind-");
		sb.append("errorCode:" + errorCode + "|");
		sb.append("appid:" + appid + "|");
		sb.append("userId:" + userId + "|");
		sb.append("channelId:" + channelId + "|");
		sb.append("requestId:" + requestId);
		J_Log.i("J_BaiduPushReceiver", sb.toString());

		SharedPreUtil.saveBaiduUserID(userId);
		SharedPreUtil.saveBaiduChannelID(channelId);

		// 绑定成功，设置已绑定flag，可以有效的减少不必要的绑定请求
		if (errorCode == 0) {
			if (J_SDK.getConfig().API_SETTING != 3) {
				// 测试--添加一个可用标签
				ArrayList<String> allTags = new ArrayList<String>();
				allTags.add("push_test");
				PushManager.setTags(J_Application.context, allTags);
			}
			SharedPreUtil.saveBaiduChannelID(channelId);
			SharedPreUtil.saveBaiduUserID(userId);
			// 发送绑定请求
			UtilRequest.setPushId(userId, channelId);
		}
	}

	/**
	 * 接收透传消息的函数。
	 * 
	 * @param context 上下文
	 * @param message 推送的消息
	 * @param customContentString 自定义内容,为空或者json字符串
	 */
	@Override
	public void onMessage(Context context, String message, String customContentString) {
		StringBuilder sb = new StringBuilder();
		sb.append("MyPushMessageReceiver-onMessage透传消息-");
		sb.append("message:" + message + "|");// 消息体
		sb.append("customContentString:" + customContentString);// 附加字段
		J_Log.i("J_BaiduPushReceiver", sb.toString());
		// 自定义内容获取方式，mykey和myvalue对应透传消息推送时自定义内容中设置的键和值
		if (!Util.isBlankString(message)) {
			boolean isShow = SettingSharedPreUtil.getOpenPush();// 获取设置 是否显示通知
			if (isShow && SocketUtil.timeAllowed() && SharedPreUtil.getLoginInfo().uid > 0) {
				SocketProtocol sp = SocketParser.getInstance().parseData(message);
				// 显示 notify
				if (sp instanceof AbsPushProtocol) {
					AbsPushProtocol protocol = (AbsPushProtocol) sp;
					SocketUtil.parserMessage(protocol);
				}
			}
		}
	}

	/**
	 * PushManager.stopWork() 的回调函数。
	 * 
	 * @param context 上下文
	 * @param errorCode 错误码。0表示从云推送解绑定成功；非0表示失败。
	 * @param requestId 分配给对云推送的请求的id
	 */
	@Override
	public void onUnbind(Context context, int errorCode, String requestId) {
		StringBuilder sb = new StringBuilder();
		sb.append("MyPushMessageReceiver-onUnbind-");
		sb.append("errorCode:" + errorCode + "|");
		sb.append("requestId:" + requestId);
		J_Log.i("J_BaiduPushReceiver", sb.toString());

		// 解绑定成功，设置未绑定flag，
		if (errorCode == 0) {

		}
	}

	/**
	 * deleteTags() 的回调函数。
	 * 
	 * @param context 上下文
	 * @param errorCode 错误码。0表示某些tag已经删除成功；非0表示所有tag均删除失败。
	 * @param successTags 成功删除的tag
	 * @param failTags 删除失败的tag
	 * @param requestId 分配给对云推送的请求的id
	 */
	@Override
	public void onDelTags(Context context, int errorCode, List<String> sucessTags, List<String> failTags, String requestId) {
		StringBuilder sb = new StringBuilder();
		sb.append("MyPushMessageReceiver-onDelTags-");
		sb.append("errorCode:" + errorCode + "|");
		sb.append("sucessTags:" + sucessTags + "|");
		sb.append("failTags:" + failTags + "|");
		sb.append("requestId:" + requestId);
		J_Log.i("J_BaiduPushReceiver", sb.toString());
	}

	/**
	 * listTags() 的回调函数。
	 * 
	 * @param context 上下文
	 * @param errorCode 错误码。0表示列举tag成功；非0表示失败。
	 * @param tags 当前应用设置的所有tag。
	 * @param requestId 分配给对云推送的请求的id
	 */
	@Override
	public void onListTags(Context context, int errorCode, List<String> tags, String requestId) {
		StringBuilder sb = new StringBuilder();
		sb.append("MyPushMessageReceiver-onListTags-");
		sb.append("errorCode:" + errorCode + "|");
		sb.append("tags:" + tags + "|");
		sb.append("requestId:" + requestId);
		J_Log.i("J_BaiduPushReceiver", sb.toString());
	}

	/**
	 * 接收通知点击的函数。注：推送通知被用户点击前，应用无法通过接口获取通知的内容。
	 * 
	 * @param context 上下文
	 * @param title 推送的通知的标题
	 * @param description 推送的通知的描述
	 * @param customContentString 自定义内容，为空或者json字符串
	 */
	@Override
	public void onNotificationClicked(Context context, String title, String description, String customContentString) {
		// notification的点击事件在 SocketUtil.showNotification方法中处理
	}

	/**
	 * setTags() 的回调函数。
	 * 
	 * @param context 上下文
	 * @param errorCode 错误码。0表示某些tag已经设置成功；非0表示所有tag的设置均失败。
	 * @param successTags 设置成功的tag
	 * @param failTags 设置失败的tag
	 * @param requestId 分配给对云推送的请求的id
	 */
	@Override
	public void onSetTags(Context context, int errorCode, List<String> sucessTags, List<String> failTags, String requestId) {
		StringBuilder sb = new StringBuilder();
		sb.append("MyPushMessageReceiver-onSetTags-");
		sb.append("errorCode:" + errorCode + "|");
		sb.append("sucessTags:" + sucessTags + "|");
		sb.append("failTags:" + failTags + "|");
		sb.append("requestId:" + requestId);
		J_Log.i("J_BaiduPushReceiver", sb.toString());
	}

	/**
	 * 
	 * @param arg0
	 * @param arg1
	 * @param arg2
	 * @param arg3
	 */
	@Override
	public void onNotificationArrived(Context arg0, String arg1, String arg2, String arg3) {
	}

}
