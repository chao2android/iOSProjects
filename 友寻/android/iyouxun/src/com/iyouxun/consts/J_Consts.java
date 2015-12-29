package com.iyouxun.consts;

public class J_Consts {
	public static final String UTF8 = "UTF-8";
	// app更新弹层提示key
	public static final String APP_UPDALOD_DIALOG_TIME_KEY = "appUploadDialogTimekey";
	/** 检查socket链接状态 */
	public static final String ACTION_SOCKET = "com.iyouxun.action.check_socket";
	/** 收到推送消息 */
	public static final String ACTION_PUSH = "com.iyouxun.action.push_msg";
	/** 登陆后发送广播 */
	public static final String ACTION_LOGIN = "com.iyouxun.action.login";
	/** 网站地址 */
	public static final String SITE_URL = "http://i.iyouxun.com";
	/** 分享连接地址 */
	public static final String SHARE_URL_INVITE = "http://m.iyouxun.com/wechat/friend_invite/?uid=";
	public static final String SHARE_URL_NEWS = "http://m.iyouxun.com/wechat/share_trends/?uid=";
	public static final String SHARE_URL_USER = "http://m.iyouxun.com/wechat/share_profile/?uid=";
	/** 最长录音时间 */
	public static final int RECORD_MAX_TIME = 60;

	/** 学生职业的固定id */
	public static final int SCHOOL_CAREER_ID = 25;

	/** 截图文件名 */
	// 限时竞猜截图
	public static final String SCREEN_SHOT_TIME_GUESSING = "screen_shot_time_guessing";
	// 排行榜截图
	public static final String SCREEN_SHOT_RANK = "screen_shot_rank";
	/**
	 * 广播
	 */
	public static final String ACTION_GIFT_DIALOG = "com.iyouxun.gift.action";
	public static final String ACTION_GIFT_BAG_DIALOG = "com.iyouxun.gift.bag.action";
	public static final String ACTION_GIFT_SEND_SUCCESS = "com.iyouxun.gift.send.action";

	/**
	 * 注册类型
	 */
	// 只有手机号注册
	public static final int REGISTER_TYPE_PHONE = 1;
	// 只有邮箱注册
	public static final int REGISTER_TYPE_EMAIL = 2;
	// 即有手机号注册也有邮箱注册
	public static final int REGISTER_TYPE_PHONE_AND_EMAIL = 3;

	/** 百度统计key */
	public static final String BAIDU_STATISTICS_KEY = "ViRhOnUnBxHkFHmPbl8ZGU7P";

	/** 百度推送key */
	public static final String BAIDU_PUSH_APIKEY = "ViRhOnUnBxHkFHmPbl8ZGU7P";
	public static final String BAIDU_PUSH_TEST_APIKEY = "kbNtPvhmlaXbxKarGt1KEzBn";

	/** 参数名 "display_name" */
	public static final String DISPLAY_NAME = "display_name";

	/** 参数名 "sort_key" */
	public static final String SORT_KEY = "sort_key";

	/** 参数名 "uid" */
	public static final String UID = "uid";

	/** 参数名 "qid" */
	public static final String QID = "qid";

	/** 消息中心聊天消息中，图片缩略图的最大尺寸 */
	public final static int MAX_THUMB_IMG_SIZE = 200;

	/** 熟人圈中的评论最多展示条数 */
	public final static int NEWS_COMMENT_MAX_SHOW = 3;
	/**
	 * @Fields MESSAGE_LIST_PAGE_SIZE : 消息列表每次获取数量
	 */
	public static int MESSAGE_LIST_PAGE_SIZE = 20;

	/**
	 * @Fields UPDATE_MESSAGE_LIST_DATA : 更新消息联系人列表
	 */
	public static String UPDATE_MESSAGE_LIST_DATA = "com.iyouxun.message.update.message";
}
