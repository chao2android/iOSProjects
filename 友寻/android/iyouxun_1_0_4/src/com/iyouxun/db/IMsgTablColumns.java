package com.iyouxun.db;

/**
 * 消息表
 * 
 * @author likai
 * @date 2014年10月13日 下午3:27:27
 */
public interface IMsgTablColumns {
	/** 数据库版本号 */
	public static final int DATABASE_VERSION = 1;
	/** 表名 */
	public static final String TABLE_NAME = "msg_history";
	/** id */
	public static final String _ID = "_id";
	/** 消息中用户uid */
	public static final String UID = "uid";
	/** 头像 */
	public static final String AVATAR = "avatar";
	/** 昵称 */
	public static final String NICKNAME = "nickname";
	/** 时间 */
	public static final String SENDTIME = "sendtime";
	/** 内容、标题 */
	public static final String CONTENT = "content";
	/** 领取状态 0 没领取 1 已领取 */
	public static final String STATUS = "status";
	/** 过期时间 */
	public static final String EXPIRETIME = "expiretime";
	/** 是否过期 0 没过期 1 过期 */
	public static final String ISEXPIRE = "isexpire";
	/** 类型、1好友动态、2系统通知、3领取金币 */
	public static final String TYPE = "type";
	/** 挑战书的问题id */
	public static final String QID = "qid";
	/** 挑战数的金币数量 */
	public static final String GOLD = "gold";
	/** 消息类型：0：一般消息，1：兑换金币提醒消息，2：下挑战书 */
	public static final String MSG_TYPE = "msg_type";
}
