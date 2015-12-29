package com.iyouxun.data.chat;

import com.iyouxun.J_Application;
import com.iyouxun.utils.SharedPreUtil;

/**
 * 聊天对象的数据操作集合
 * 
 * @author likai
 * */
public class ChatContactRepository {
	protected static ChatDBHelper helper;

	/**
	 * 关闭数据库
	 * 
	 * */
	public static void clears() {
		if (helper != null) {
			helper.closeDatabase();
			helper = null;
		}
	}

	/**
	 * 初始化数据库操作
	 * 
	 * @return
	 * 
	 * */
	public static ChatDBHelper getDBHelperInstance() {
		if (helper == null) {
			helper = ChatDBHelper.getHelper(J_Application.context, SharedPreUtil.getLoginInfo().uid + "");
			return helper;
		} else {
			return helper;
		}
	}
}
