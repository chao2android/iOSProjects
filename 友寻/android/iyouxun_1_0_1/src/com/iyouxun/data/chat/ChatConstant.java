package com.iyouxun.data.chat;

public class ChatConstant {
	// mime type
	public static final String MIME_TYPE_TEXT_PLAIN = "text/plain";// 文字
	public static final String MIME_TYPE_AUIDO_AMR = "audio/amr";// 语音
	public static final String MIME_TYPE_IMAGE_JPEG = "image/jpeg";// 图片
	public static final String MIME_TYPE_DYNAMIC = "dynamic";// 动态

	/**
	 * * @return 0 未通过身份认证, -1 不能对自己 眨眼传情 -2 非异性, -3 网站黑名单 -4对方已经被 您拉黑 -14
	 * 你已被对方拉黑 -5 约会中 发消息, -6 征友成功 发消息 -7 每天一千封信件 -8 每天200次新联系 -9 未开通服务 -10
	 * 服务已过期
	 */
	public static final int MSG_SYNCHRONIZING = 2;
	public static final int MSG_SYNCHRONIZE_SUCCESS = 1;
	public static final int MSG_SYNCHRONIZE_FAILED = 2101;// 发送失败
	public static final int MSG_SYNCHRONIZE_ERR_AUTH = 2000;// 未通过身份认证
	public static final int MSG_SYNCHRONIZE_ERR_TEASER = 2001;// 不能对自己 眨眼传情
	public static final int MSG_SYNCHRONIZE_ERR_SEX = 2002;// 非异性
	public static final int MSG_SYNCHRONIZE_ERR_BLACK_SITE = 2003;// 网站黑名单
	public static final int MSG_SYNCHRONIZE_ERR_BLACK_SELF = 2004;// 对方已经被您拉黑
	public static final int MSG_SYNCHRONIZE_ERR_DATE = 2005;// 对方已被注销，不能联系该会员
	public static final int MSG_SYNCHRONIZE_ERR_LEOBUD = 2006;// 每天200次新联系
	public static final int MSG_SYNCHRONIZE_ERR_EVERYDAY_LIMIT = 2007;// 您的征友状态为正在约会中，不能进行互动
	public static final int MSG_SYNCHRONIZE_ERR_EVERYDAY_NEW = 2008;// 对方的征友状态为征友成功
	public static final int MSG_SYNCHRONIZE_ERR_NO_SERVICE = 2009;// 未开通服务
	public static final int MSG_SYNCHRONIZE_ERR_EXPIRE_SERVICE = 2010;// 服务已过期
	public static final int MSG_SYNCHRONIZE_ERR_EXPIRE_MAN_SERVICE = 2011;// 男会员无15元包月服务提醒
	public static final int MSG_SYNCHRONIZE_ERR_EXPIRE_MAN_SERVICE_END = 2012;// 男会员15元包月服务每日联系一人已经用完
	public static final int MSG_SYNCHRONIZE_ERR_BLACK_OPP = 2014;// 你已被对方拉黑
	public static final int MSG_SYNCHRONIZE_ERR_NO_AUTH = 2099;// 您尚未通过身份认证，不能给该会员发信
	public static final int MSG_SYNCHRONIZE_ERR_WAIT_AUTH = 2100;// 您上传的身份证件在审核中，暂不能发信
	public static final int MSG_SYNCHRONIZE_ERR_UPLOAD_ARM_ERROR = 2102;// 上传语音文件失败

	public static final int MSG_ISACK_SUCCESS = 1;// 消息已读
	public static final int MSG_ISACK_FAILD = 0;// 消息未读
	public static final int MSG_SHOW_FLOATING_VIEW = 3000;// 显示消息浮窗
	public static final int MSG_HIDE_FLOATING_VIEW = 3001;// 隐藏消息浮窗
	public static final int MSG_SHOW_FLOATING_VIEW_EXCHANGE = 3002;// 没有交互默认展开浮窗
}
