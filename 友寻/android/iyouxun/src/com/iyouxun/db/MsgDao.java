package com.iyouxun.db;

import com.iyouxun.J_Application;
import com.iyouxun.utils.SharedPreUtil;

/**
 * 消息数据库操作方法集
 * 
 * @author likai
 * @date 2014年10月13日 下午3:20:03
 */
public class MsgDao implements IMsgTablColumns {
	private final MsgDbHelper dbHelper;

	public MsgDao() {
		dbHelper = new MsgDbHelper(J_Application.context, SharedPreUtil.getLoginInfo().uid + "");
	}
}
