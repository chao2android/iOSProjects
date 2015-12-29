package com.iyouxun.data.cache;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

import android.app.Activity;

import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.data.beans.users.LoginUser;

public class J_Cache {
	/***
	 * 推送消息的缓存 103 102 1128 1302
	 * 
	 * @author Administrator
	 * 
	 */
	public static final class PushCache {
		private static HashMap<Long, PushMsgInfo> sPushMsgs = new HashMap<Long, PushMsgInfo>();

		/** 移除push消息 */
		public synchronized static void removePushMsg(PushMsgInfo info) {
			if (sPushMsgs != null) {
				sPushMsgs.remove(info.getKey());
			}
		}

		/** 增加push消息 */
		public synchronized static void addPushMsg(PushMsgInfo info) {
			if (sPushMsgs == null) {
				sPushMsgs = new HashMap<Long, PushMsgInfo>();
			}
			sPushMsgs.put(info.getKey(), info);
		}

		public static void clearAllPush() {
			if (sPushMsgs != null) {
				sPushMsgs.clear();
			}
		}

		public static ArrayList<PushMsgInfo> getAllPushMsg() {
			ArrayList<PushMsgInfo> arrayList = new ArrayList<PushMsgInfo>();
			if (sPushMsgs != null) {
				for (Map.Entry<Long, PushMsgInfo> entry : sPushMsgs.entrySet()) {
					arrayList.add(entry.getValue());
				}
				Collections.sort(arrayList);
				return arrayList;
			} else {
				return null;
			}
		}

		public static int getPushMsgCount() {
			ArrayList<PushMsgInfo> arrayList = getAllPushMsg();
			if (arrayList != null && !arrayList.isEmpty()) {
				int i = 0;
				for (PushMsgInfo info : arrayList) {
					if (!info.isRead) {
						i++;
					}
				}
				return i;
			} else {
				return 0;
			}
		}

		/** 获取最近一条push消息 */
		public static PushMsgInfo getNearPush() {
			ArrayList<PushMsgInfo> infos = getAllPushMsg();
			if (infos != null && !infos.isEmpty()) {
				return infos.get(0);
			}
			return null;
		}
	}

	/** 当前登录用户信息 */
	public static LoginUser sLoginUser;
	/** 注册监听的页面 */
	public static HashMap<String, Activity> pageListener = new HashMap<String, Activity>();
}
