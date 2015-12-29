package com.iyouxun.utils;

import java.util.List;

import android.app.ActivityManager;
import android.app.ActivityManager.RunningTaskInfo;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationCompat.Builder;
import android.widget.ImageView;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.data.beans.users.LoginUser;
import com.iyouxun.data.parser.SocketParser;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.ImageLoadListener;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.net.socket.protocol.AbsPushProtocol;
import com.iyouxun.ui.activity.SplashActivity;
import com.iyouxun.ui.activity.center.ProfileViewActivity;
import com.iyouxun.ui.activity.message.ChatMainActivity;
import com.iyouxun.ui.activity.message.SystemMsgActivity;

/**
 * 推送消息的处理工具类
 * 
 * @author likai
 * @date 2014年9月22日 下午4:47:03
 */
public class SocketUtil {

	/**
	 * 当前时间是否在9-21点之间
	 * */
	public static boolean timeAllowed() {
		boolean b = true;
		// Calendar calendar = Calendar.getInstance();
		// calendar.setTimeInMillis(System.currentTimeMillis());
		// int h = calendar.get(Calendar.HOUR_OF_DAY);
		// if (h > 21 || h < 9) {
		// b = false;
		// }
		return b;
	}

	public static void showNotification(PushMsgInfo info) {
		String contentText = info.contentText;
		long uid = info.uid;
		int cmd = info.cmd;
		if (cmd == SocketParser.CMD_SEND_NEW_CREATE_GROUP_MSG) {// 创建群组发送群聊信息
			cmd = SocketParser.CMD_SEND_NEW_GROUP_CHAT_MSG;
		}
		Builder builder = new NotificationCompat.Builder(J_Application.context);
		builder.setSmallIcon(R.drawable.app_icon);
		builder.setContentText(contentText);
		builder.setContentTitle(J_Application.context.getResources().getString(R.string.app_name));
		builder.setAutoCancel(true);
		builder.setWhen(System.currentTimeMillis());
		Bitmap showBitmap = J_NetManager.getInstance().getLoadBitmap(info.showIcon);
		if (showBitmap != null) {
			builder.setLargeIcon(showBitmap);
		}
		LoginUser user = SharedPreUtil.getLoginInfo();
		if (user != null) {
			boolean audio = SettingSharedPreUtil.getVoiceRemind(); // 获取设置-是否有提示音
			boolean vibra = SettingSharedPreUtil.getShakeRemind(); // 获取设置-是否有震动
			if (audio && vibra) {
				builder.setDefaults(Notification.DEFAULT_ALL);
			} else if (audio) {
				builder.setDefaults(Notification.DEFAULT_SOUND);
			} else if (vibra) {
				builder.setDefaults(Notification.DEFAULT_VIBRATE);
			} else {
				builder.setDefaults(Notification.DEFAULT_LIGHTS);
			}
		}

		/** 是否运行在后台 */
		boolean isMyAppBackGround = false;

		String packageName = J_Application.context.getPackageName();
		Intent mGotoIntent = new Intent();
		mGotoIntent.setClass(J_Application.context, SplashActivity.class);

		mGotoIntent.putExtra(J_Consts.UID, String.valueOf(uid));
		mGotoIntent.putExtra("cmd", cmd);
		switch (cmd) {
		case SocketParser.CMD_SEND_NEW_CHAT_MSG:// 单点聊天
			mGotoIntent.setClass(J_Application.context, ChatMainActivity.class);
			mGotoIntent.putExtra(UtilRequest.FORM_OID, info.uid + "");
			mGotoIntent.putExtra(UtilRequest.FORM_NICK, info.nick);
			builder.setTicker(contentText);
			builder.setContentTitle(info.nick);
			break;
		case SocketParser.CMD_SEND_NEW_CREATE_GROUP_MSG:// 创建群组
		case SocketParser.CMD_SEND_NEW_GROUP_CHAT_MSG:// 群聊消息
			UtilRequest.getCountNew();
			mGotoIntent.setClass(J_Application.context, ChatMainActivity.class);
			mGotoIntent.putExtra(UtilRequest.FORM_GROUP_ID, info.groupId);
			mGotoIntent.putExtra(UtilRequest.FORM_NICK, info.nick);
			builder.setTicker(contentText);
			builder.setContentTitle(info.nick);
			break;
		case SocketParser.CMD_SEND_NEW_ADD_GROUP_MSG:// 申请加入群组
		case SocketParser.CMD_SEND_NEW_EXIT_GROUP_MSG:// 退出群组
		case SocketParser.CMD_SEND_NEW_REJECT_FRIEND_JOIN_GROUP_MSG:// 谢绝入群
		case SocketParser.CMD_SEND_OWN_ADD_TAGS_MSG:// 新标签
		case SocketParser.CMD_SEND_NEW_INVITE_FRIEND_JOIN_GROUP_MSG:// 邀请加入群组
		case SocketParser.CMD_SEND_ADD_FRIEND_MSG:// 好友申请
		case SocketParser.CMD_SEND_NEW_GROUP_MASTER_DEL_PERSON_MSG:// 群主踢人
		case SocketParser.CMD_SEND_NEW_LIKE_PICTURE_MSG:// 赞照片
			UtilRequest.getCountNew();
			if (info.msgCount >= 5 && cmd != SocketParser.CMD_SEND_NEW_LIKE_PICTURE_MSG) {
				Bitmap systemIcon = BitmapFactory.decodeResource(J_Application.context.getResources(), R.drawable.icn_system_msg);
				builder.setLargeIcon(systemIcon);
			} else {
				builder.setContentTitle(info.nick);
			}
			if (cmd == SocketParser.CMD_SEND_NEW_ADD_GROUP_MSG) {
				builder.setContentTitle(info.nick);
			}
			builder.setTicker(contentText);
			mGotoIntent.setClass(J_Application.context, SystemMsgActivity.class);
			break;
		case SocketParser.CMD_SEND_NEW_ACCEPT_FRIEND_JOIN_GROUP_MSG:// 入群通过
			UtilRequest.getCountNew();
			if (info.msgCount >= 5) {
				Bitmap systemIcon = BitmapFactory.decodeResource(J_Application.context.getResources(), R.drawable.icn_system_msg);
				builder.setLargeIcon(systemIcon);
				mGotoIntent.setClass(J_Application.context, SystemMsgActivity.class);
			} else {
				mGotoIntent.setClass(J_Application.context, ChatMainActivity.class);
				mGotoIntent.putExtra(UtilRequest.FORM_GROUP_ID, info.groupId);
				mGotoIntent.putExtra(UtilRequest.FORM_NICK, info.nick);
				builder.setContentTitle(info.nick);
			}
			builder.setTicker(contentText);
			break;
		case SocketParser.CMD_SEND_NEW_FRIEND_JOIN_MSG:// 新用户加入
			UtilRequest.getCountNew();
			if (info.msgCount >= 5) {
				Bitmap systemIcon = BitmapFactory.decodeResource(J_Application.context.getResources(), R.drawable.icn_system_msg);
				builder.setLargeIcon(systemIcon);
				mGotoIntent.setClass(J_Application.context, SystemMsgActivity.class);
			} else {
				mGotoIntent.setClass(J_Application.context, ProfileViewActivity.class);
				mGotoIntent.putExtra(UtilRequest.FORM_UID, info.uid);
				builder.setContentTitle(info.nick);
			}
			builder.setTicker(contentText);
			break;
		}

		PendingIntent contentIntent = null;
		ActivityManager activityManager = (ActivityManager) J_Application.context.getSystemService(Context.ACTIVITY_SERVICE);
		List<RunningTaskInfo> tasksInfo = activityManager.getRunningTasks(1);

		if (!tasksInfo.get(0).topActivity.getPackageName().equals(packageName) && !isMyAppBackGround) {
			mGotoIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			contentIntent = PendingIntent.getActivity(J_Application.context, 0, mGotoIntent, PendingIntent.FLAG_UPDATE_CURRENT);
		} else {
			contentIntent = PendingIntent.getActivity(J_Application.context, 0, mGotoIntent, PendingIntent.FLAG_UPDATE_CURRENT);
		}
		builder.setContentIntent(contentIntent);
		NotificationManager ntfMgr = (NotificationManager) J_Application.context.getSystemService(Context.NOTIFICATION_SERVICE);
		ntfMgr.notify(cmd, builder.build());
	}

	/**
	 * 显示状态栏提醒
	 * 
	 * @Title: showNotification
	 * @return void 返回类型
	 * @param @param title 参数类型
	 * @author likai
	 * @throws
	 */
	public static void showNotification(String title, int id) {
		Builder builder = new NotificationCompat.Builder(J_Application.context);
		builder.setSmallIcon(R.drawable.icon_status_bar);// icon
		builder.setLargeIcon(BitmapFactory.decodeResource(J_Application.context.getResources(), R.drawable.app_icon));
		// 显示屏幕顶端状态栏的文本
		builder.setTicker(title);
		// 显示通知栏中的标题
		builder.setContentTitle(J_Application.context.getResources().getString(R.string.app_name));
		// 显示通知栏中标题下的内容
		builder.setContentText(title);
		// 设为true,notification将无法通过左右滑动的方式清除 * 可用于添加常驻通知，必须调用cancle方法来清除
		builder.setOngoing(false);
		// 设置点击后通知消失
		builder.setAutoCancel(true);
		// builder.setDefaults(Notification.DEFAULT_ALL);
		// 设置点击事件
		builder.setContentIntent(PendingIntent.getActivity(J_Application.context, 1, new Intent(), Notification.FLAG_AUTO_CANCEL));
		builder.setPriority(Notification.PRIORITY_HIGH);
		// 时间
		builder.setWhen(System.currentTimeMillis());
		NotificationManager ntfMgr = (NotificationManager) J_Application.context.getSystemService(Context.NOTIFICATION_SERVICE);
		ntfMgr.notify(id, builder.build());
	}

	/**
	 * 关闭通知信息
	 * 
	 * @Title: cancelNotification
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public static void cancelNotification(int id) {
		NotificationManager ntfMgr = (NotificationManager) J_Application.context.getSystemService(Context.NOTIFICATION_SERVICE);
		ntfMgr.cancel(id);
	}

	/**
	 * 处理推送信息
	 * 
	 * @Title: parserMessage
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public static void parserMessage(final AbsPushProtocol protocol) {
		if (protocol.bean != null) {
			switch (protocol.bean.cmd) {
			case SocketParser.CMD_SEND_NEW_LIKE_DYNAMIC_MSG:
			case SocketParser.CMD_SEND_NEW_REBROADCAST_DYNAMIC_MSG:
			case SocketParser.CMD_SEND_NEW_COMMENT_DYNAMIC_MSG:
			case SocketParser.CMD_SEND_NEW_REPLY_COMMENT_MSG:
				// 动态模块消息推送

				break;
			case SocketParser.CMD_SEND_NEW_CHAT_MSG:// 普通消息
			case SocketParser.CMD_SEND_NEW_GROUP_CHAT_MSG:// 群组消息
			case SocketParser.CMD_SEND_NEW_ADD_GROUP_MSG:// 申请加入群组
			case SocketParser.CMD_SEND_NEW_EXIT_GROUP_MSG:// 退出群组
			case SocketParser.CMD_SEND_NEW_ACCEPT_FRIEND_JOIN_GROUP_MSG:// 入群通过
			case SocketParser.CMD_SEND_NEW_REJECT_FRIEND_JOIN_GROUP_MSG:// 谢绝入群
			case SocketParser.CMD_SEND_OWN_ADD_TAGS_MSG:// 新标签
			case SocketParser.CMD_SEND_NEW_INVITE_FRIEND_JOIN_GROUP_MSG:// 邀请加入群组
			case SocketParser.CMD_SEND_ADD_FRIEND_MSG:// 好友申请
			case SocketParser.CMD_SEND_NEW_GROUP_MASTER_DEL_PERSON_MSG:// 群主踢人
			case SocketParser.CMD_SEND_NEW_FRIEND_JOIN_MSG:// 新用户加入
			case SocketParser.CMD_SEND_NEW_CREATE_GROUP_MSG:// 创建群组
			case SocketParser.CMD_SEND_NEW_LIKE_PICTURE_MSG:// 赞照片
				J_NetManager.getInstance().loadIMG(null, protocol.bean.showIcon, new ImageView(J_Application.context),
						new ImageLoadListener() {

							@Override
							public void onLoadFinish() {
								showNotification(protocol.bean);
							}
						}, 0, 0);
				break;
			default:
				showNotification(protocol.bean);
				break;
			}
		}
	}
}
