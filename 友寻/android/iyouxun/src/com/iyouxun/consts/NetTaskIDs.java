package com.iyouxun.consts;

/**
 * 网络请求的各个请求的taskId
 * 
 * @author likai
 * @date 2014年9月10日 上午11:30:52
 */
public class NetTaskIDs {
	/** 更新用户信息接口ID */
	public static final int TASKID_UPDATE_USER_INFO = 100;
	/** 获取用户资料信息 */
	public static final int TASKID_GET_USER_INFO = 101;
	/** 更新用户签名 */
	public static final int TASKID_UPDATE_USER_INTRO = 102;
	/** 更新学校信息 */
	public static final int TASKID_UPDATE_USER_SCHOOL_NAME = 103;
	/** 更新公司信息 */
	public static final int TASKID_UPDATE_USER_COMPANY_NAME = 104;
	/**
	 * 自动登录
	 */
	public static final int TASKID_AUTO_LOGIN = 105;
	/**
	 * 登录
	 */
	public static final int TASKID_LOGIN = 106;
	/** 上传头像 */
	public static final int TASKID_UPLOAD_USER_AVATAR = 107;
	/** 更新用户常住地 */
	public static final int TASKID_UPDATE_USER_ADDRESS = 108;
	/** 上传图片 */
	public static final int TASKID_UPLOAD_PHOTO = 109;
	/** 删除图片 */
	public static final int TASKID_DELETE_PHOTO = 110;
	/** 获取图片列表 */
	public static final int TASKID_GET_PHOTO_LIST = 111;
	/**
	 * @Fields TASKID_GET_SECURITY_CODE : 获得注册验证码
	 */
	public static final int TASKID_GET_SECURITY_CODE = 112;
	/**
	 * @Fields TASKID_VAILD_MOBILE_EXIST : 验证手机号是否存在
	 */
	public static final int TASKID_VAILD_MOBILE_EXISTS = 113;
	/**
	 * @Fields TASKID_VAILD_MOBILE_CODE :验证验证码
	 */
	public static final int TASKID_VAILD_MOBILE_CODE = 114;
	/** 确认单身 */
	public static final int TASKID_UPDATE_USER_LONELY_CONFIRM = 115;
	/**
	 * @Fields TASKID_SET_NEW_PASSWORD : 设置新密码
	 */
	public static final int TASKID_SET_NEW_PASSWORD = 116;
	/**
	 * @Fields TASKID_NEW_PASSWORD_GET_SECURITY_CODE : 重置密码获取验证码
	 */
	public static final int TASKID_NEW_PASSWORD_GET_SECURITY_CODE = 117;
	/**
	 * 注册
	 */
	public static final int TASKID_DO_REGISTER = 118;
	/**
	 * @Fields TASKID_VAILD_BIND_OPENID :验证第三方绑定状态
	 */
	public static final int TASKID_VAILD_BIND_OPENID = 119;
	/** 添加新动态 */
	public static final int TASKID_ADD_DYNAMIC = 120;
	/** 发布动态上传图片 */
	public static final int TASKID_PICTURE_UPLOAD_PHOTO = 121;
	/**
	 * @Fields TASKID_UPLOAD_USER_CONTACTS : 上传用户联系人
	 */
	public static final int TASKID_UPLOAD_USER_CONTACTS = 122;
	/** 删除头像 */
	public static final int TASKID_DELETE_AVATAR = 123;
	/** 更新隐私设置 */
	public static final int TASKID_UPDATE_PRIVACY = 124;
	/** 获取隐私设置 */
	public static final int TASKID_GET_PRIVACY_INFO = 125;
	/** 举报图片 */
	public static final int TASKID_REPORT_PIC = 126;
	/** 举报个人资料 */
	public static final int TASKID_REPORT_PROFILE = 127;
	/** 修改密码 */
	public static final int TASKID_CHANGE_PASSWORD = 128;
	/** 更换手机：获取验证码 */
	public static final int TASKID_FIND_MOBILE_GET_CHECKCODE = 129;
	/** 更换手机号 */
	public static final int TASKID_UPDATE_USER_MOBILE = 130;
	/** 已经绑定的平台帐号列表 */
	public static final int TASKID_GET_USER_OAUTHS = 131;
	/** 移除已经绑定的平台帐号 */
	public static final int TASKID_DELETE_BIND = 132;
	/** 第三方平台绑定 */
	public static final int TASKID_BIND_OPEN_PLATFORM = 133;
	/**
	 * @Fields TASKID_SEND_TEXT_MSG : 发送文本消息
	 */
	public static final int TASKID_SEND_TEXT_MSG = 134;
	/** 添加标签 */
	public static final int TASKID_ADD_TAG = 135;
	/** 删除标签 */
	public static final int TASKID_DEL_TAG = 136;
	/** 点击标签 */
	public static final int TASKID_TAG_CLICK = 137;
	/** 获取标签列表 */
	public static final int TASKID_TAG_LIST = 138;
	/**
	 * @Fields TASKID_GET_HISTORY_USER_CHAT_LIST : 离线获得消息数据
	 */
	public static final int TASKID_GET_HISTORY_USER_CHAT_LIST = 139;
	/**
	 * @Fields TASKID_SET_PUSH_ID : 百度推送绑定id
	 */
	public static final int TASKID_SET_PUSH_ID = 140;
	/** 更新用户备注 */
	public static final int TASKID_UPDATE_USER_MARK = 141;
	/** 获取动态列表 */
	public static final int TASKID_GET_RECOMMEND_DYNAMIC_LIST = 142;
	/** 获取单个用户发布过的动态列表 */
	public static final int TASKID_GET_ONE_USER_DYNAMIC_LIST = 143;
	/** 删除一条动态 */
	public static final int TASKID_DEL_DYNAMIC = 144;
	/** 赞动态 */
	public static final int TASKID_SEND_PRAISE = 145;
	/** 取消一条赞动态 */
	public static final int TASKID_DEL_PRAISE = 146;
	/** 转播一条动态 */
	public static final int TASKID_REBROADCAST_DYNAMIC = 147;
	/**
	 * @Fields TASKID_GET_CHAT_USER_LIST : 获得聊天用户列表
	 */
	public static final int TASKID_GET_CHAT_USER_LIST = 148;
	/**
	 * @Fields TASKID_SEND_PIC_MSG : 图片消息
	 */
	public static final int TASKID_SEND_PIC_MSG = 149;
	/**
	 * @Fields TASKID_SEND_VOICE_MSG : 语音消息
	 */
	public static final int TASKID_SEND_VOICE_MSG = 150;
	/** 动态评论 */
	public static final int TASKID_SEND_COMMENT = 151;
	/** 回复评论 */
	public static final int TASKID_REPLY_COMMENT = 153;
	/** 获取单个动态信息 */
	public static final int TASKID_GET_ONE_DYNAMIC_INFO = 154;
	/** 删除评论 */
	public static final int TASKID_DEL_COMMENT = 155;
	/**
	 * @Fields TASKID_FRIENDS_CREATE_GROUP :创建好友分组
	 */
	public static final int TASKID_FRIENDS_CREATE_GROUP = 156;
	/**
	 * @Fields TASKID_FRIENDS_GET_GROUP_LIST : 获得好友分组列表
	 */
	public static final int TASKID_FRIENDS_GET_GROUP_LIST = 157;
	/**
	 * @Fields TASKID_FRIENDS_GET_GROUP_MEMBERS : 获得好友分组成员列表
	 */
	public static final int TASKID_FRIENDS_GET_GROUP_MEMBERS = 158;
	/**
	 * @Fields TASKID_FRIENDS_DEL_GROUP : 删除好友分组
	 */
	public static final int TASKID_FRIENDS_DEL_GROUP = 159;
	/**
	 * @Fields TASKID_FRIENDS_ADD_GROUP_MEMBERS : 添加分组成员
	 */
	public static final int TASKID_FRIENDS_ADD_GROUP_MEMBERS = 160;
	/**
	 * @Fields TASKID_FRIENDS_REMOVE_GROUP_MEMBERS : 删除分组成员
	 */
	public static final int TASKID_FRIENDS_REMOVE_GROUP_MEMBERS = 161;
	/**
	 * @Fields TASKID_FRIENDS_GET_MY_FRIENDS_ALL : 获取所有一度好友
	 */
	public static final int TASKID_FRIENDS_GET_MY_FRIENDS_ALL = 162;
	/** 获取动态消息提醒列表 */
	public static final int TASKID_LIST_SYSTEM = 163;
	/** 消息置为已读 */
	public static final int TASKID_SET_ONREAD = 164;
	/** 更新经纬度坐标 */
	public static final int TASKID_UPDATE_LNGLAT = 165;
	/**
	 * @Fields TASKID_FRIENDS_GET_FRIENDS_NUMS : 获得好友数量
	 */
	public static final int TASKID_FRIENDS_GET_FRIENDS_NUMS = 166;
	/**
	 * @Fields TASKID_FRIENDS_GET_MY_FRIENDS : 获取一度好友
	 */
	public static final int TASKID_FRIENDS_GET_MY_FRIENDS = 167;

	/**
	 * @Fields TASKID_FRIENDS_MOD_GROUP : 修改分组名称
	 */
	public static final int TASKID_FRIENDS_MOD_GROUP = 168;
	/** 全部消息置为已读 */
	public static final int TASKID_SET_ONREAD_ALLSYSMSG = 169;
	/** 删除黑名单好友 */
	public static final int TASKID_DEL_BLACKLIST = 170;
	/** 获取黑名单列表 */
	public static final int TASKID_GET_BLACKLIST_LIST = 171;
	/** 获取已加入的群组列表 */
	public static final int TASKID_GROUP_LIST = 172;
	/** 申请加入一个群组 */
	public static final int TASKID_ADD_GROUP = 173;
	/** 获取某一群组的详细信息 */
	public static final int TASKID_GET_GROUP = 174;
	/** 添加黑名单 */
	public static final int TASKID_ADD_BLACK = 175;
	/** 获取共同好友 */
	public static final int TASKID_FRIENDS_GET_MUTUALFRIENDS = 176;
	/** 获取推荐好友列表 */
	public static final int TASKID_GET_RECOMMEND_NEW_USERS = 177;
	/** 获取两人的共同好友数量 */
	public static final int TASKID_FRIENDS_GET_MUTUALNUMS = 178;
	/** 获取群组内成员列表 */
	public static final int TASKID_GROUP_USER_LIST = 179;
	/**
	 * @Fields TASKID_GROUP_CREATE_GROUP : 创建一个新群组
	 */
	public static final int TASKID_GROUP_CREATE_GROUP = 180;
	/** 更新群组设置信息 */
	public static final int TASKID_UPDATE_USER_GROUP = 181;
	/**
	 * @Fields TASKID_UPDATE_GROUP : 修改群信息
	 */
	public static final int TASKID_UPDATE_GROUP = 182;

	/**
	 * @Fields TASKID_EXIT_GROUP : 退出群组
	 */
	public static final int TASKID_EXIT_GROUP = 183;
	/**
	 * @Fields TASKID_INVITE_FRIEND_JOIN_GROUP : 群组添加成员
	 */
	public static final int TASKID_INVITE_FRIEND_JOIN_GROUP = 184;
	/** 申请添加好友 */
	public static final int TASKID_FRIENDS_SENT_REQ = 185;
	/**
	 * @Fields TASKID_GROUP_MASTER_DEL_PERSON : 群主踢人(只有群主操作)
	 */
	public static final int TASKID_GROUP_MASTER_DEL_PERSON = 186;
	/**
	 * @Fields TASKID_UPDATE_GROUP_PIC : 修改群组头像
	 */
	public static final int TASKID_UPDATE_GROUP_PIC = 187;
	/**
	 * @Fields TASKID_RECOMMEND_GROUP_LIST : 获取推荐群组列表
	 */
	public static final int TASKID_RECOMMEND_GROUP_LIST = 188;
	/**
	 * @Fields TASKID_GET_ALL_CHAT_MSG_LIST : 获取全部聊天消息列表
	 */
	public static final int TASKID_GET_ALL_CHAT_MSG_LIST = 189;
	/**
	 * @Fields TASKID_DEL_MSG : 删除联系人消息
	 */
	public static final int TASKID_DEL_MSG = 190;

	/**
	 * @Fields UPDATE_IMAGE_MSG_UPLOAD_PERCENT : 更新图片消息上传进度
	 */
	public static final int UPDATE_IMAGE_MSG_UPLOAD_PERCENT = 191;
	/**
	 * @Fields TASKID_DEL_CONTACT : 删除联系人
	 */
	public static final int TASKID_DEL_CONTACT = 192;
	/**
	 * @Fields TASKID_SEND_GROUP_MSG : 发送群组消息
	 */
	public static final int TASKID_SEND_GROUP_MSG = 193;
	/**
	 * @Fields TASKID_SEND_PIC_GROUP_MSG : 群聊发送一条图片聊天信息
	 */
	public static final int TASKID_SEND_PIC_GROUP_MSG = 194;
	/**
	 * @Fields TAKID_SEND_VOICE_GROUP_MSG : 群聊发送一条语音聊天信息
	 */
	public static final int TASKID_SEND_VOICE_GROUP_MSG = 195;

	/**
	 * @Fields TASKID_GET_HISTORY_GROUP_CHAT_LIST : 历史群聊消息列表
	 */
	public static final int TASKID_GET_HISTORY_GROUP_CHAT_LIST = 196;
	/**
	 * @Fields TASKID_SEND_ONREAD_BY_OID : 单聊消息设置已读
	 */
	public static final int TASKID_SEND_ONREAD_BY_OID = 197;
	/**
	 * @Fields TASKID_SEND_ONREAD_GROUP_BY_OID : 群里消息置为已读（也就是群未读消息数清零）
	 */
	public static final int TASKID_SEND_ONREAD_GROUP_BY_OID = 198;
	/** 获取通知消息数字 */
	public static final int TASKID_NOTICE_GET = 199;
	/** 获取动态新消息数字 */
	public static final int TASKID_NOTICE_NEW_DYNAMIC = 200;
	/**
	 * @Fields TASKID_FRIENDS_GET_FSFRIENDS : 获取2度好友列表
	 */
	public static final int TASKID_FRIENDS_GET_FSFRIENDS = 201;
	/**
	 * @Fields TASKID_TAG_GET_MAX_TAGS :获取使用最多的30个标签
	 */
	public static final int TASKID_TAG_GET_MAX_TAGS = 202;
	/**
	 * @Fields TASKID_ACCEPT_FRIEND_JOIN_GROUP : 接受或拒绝好友加入群(只有群主操作)
	 */
	public static final int TASKID_ACCEPT_FRIEND_JOIN_GROUP = 203;
	/** 更新app */
	public static final int TASKID_UPDATE_CLIENT = 204;
	/** 首次提示用户上传通讯录，用户取消后的请求 */
	public static final int TASKID_FRIENDS_MAKEFRIENDSHIP = 205;
	/**
	 * @Fields TASKID_FRIENDS_ACCEPT_REQ : 通过好友申请
	 */
	public static final int TASKID_FRIENDS_ACCEPT_REQ = 206;
	/**
	 * @Fields TASKID_FRIENDS_SEND_MSG_TO_REG_FRIENDS : 新好友加入
	 */
	public static final int TASKID_FRIENDS_SEND_MSG_TO_REG_FRIENDS = 207;
	/**
	 * @Fields TASKID_COUNT_GROUP : 我的群组数量
	 */
	public static final int TASKID_COUNT_GROUP = 208;
	/**
	 * @Fields TASKID_COUNT_NEW : 获取新消息通知数
	 */
	public static final int TASKID_COUNT_NEW = 209;
	/**
	 * @Fields TASKID_DEL_PUSH_ID : 解绑推送
	 */
	public static final int TASKID_DEL_PUSH_ID = 210;
	/** 取消确认单身 */
	public static final int TASKID_CANCEL_LONELY_CONFIRM = 211;
	/**
	 * @Fields TASKID_UPDATE_GROUP_TITLE :修改群组名称
	 */
	public static final int TASKID_UPDATE_GROUP_TITLE = 212;

	/**
	 * @Fields TASKID_UPDATE_GROUP_STATUS : 更新群组状态
	 */
	public static final int TASKID_UPDATE_GROUP_STATUS = 213;

	/**
	 * @Fields TASKID_IGNORE_SYS : 忽略好友申请
	 */
	public static final int TASKID_IGNORE_SYS = 214;
	/** 意见反馈 */
	public static final int TASKID_ADD_FEEDBACK = 215;

	/** 获取所有一度、二度好友列表 */
	public static final int TASKID_FRIENDS_GET_FRIENDS_ALL = 216;

	/** 获取所有一度、二度好友列表总数字 */
	public static final int TASKID_FRIENDS_GET_FRIENDSNUMS_ALL = 217;

	/**
	 * @Fields TASKID_FRIENDS_REM_REQ : 删除好友申请
	 */
	public static final int TASKID_FRIENDS_REM_REQ = 218;
	/**
	 * @Fields TASKID_UPDATE_GROUP_SHOW : 修改用户群在资料页显示状态
	 */
	public static final int TASKID_UPDATE_GROUP_SHOW = 219;
	/**
	 * @Fields TASKID_SET_HANDLED : 设置系统消息已处理
	 */
	public static final int TASKID_SET_HANDLED = 220;
	/**
	 * @Fields TASKID_IS_GROUP_MEMBER : 是否是群成员
	 */
	public static final int TASKID_IS_GROUP_MEMBER = 221;
	/**
	 * @Fields TASKID_UPDATE_USER_GROUP_SHOW_NICK : 是否展示群聊昵称
	 */
	public static final int TASKID_UPDATE_USER_GROUP_SHOW_NICK = 222;

	/**
	 * @Fields TASKID_GET_USER_VOICE_SWITCH :获取听筒模式和扬声器模式开关
	 */
	public static final int TASKID_GET_USER_VOICE_SWITCH = 223;
	/**
	 * @Fields TASKID_SET_USER_VOICE_SWITCH : 设置听筒模式和扬声器模式开关
	 */
	public static final int TASKID_SET_USER_VOICE_SWITCH = 224;
	/**
	 * @Fields TASKID_CLEAR_CACHE : 清除接口调用cache
	 */
	public static final int TASKID_CLEAR_CACHE = 225;
	/**
	 * @Fields TASKID_SEND_SINGLE_MSG :单聊求脱单
	 */
	public static final int TASKID_SEND_SINGLE_MSG = 226;
	/**
	 * @Fields TASKID_SEND_GROUP_SINGLE_MSG : 群聊求脱单
	 */
	public static final int TASKID_SEND_GROUP_SINGLE_MSG = 227;
	/** 获取推荐标签 */
	public static final int TASKID_ALTERNATIVE_TAG_LIST = 228;
	/** 赞照片 */
	public static final int TASKID_PRAISE_PHOTO = 229;
	/** 取消赞照片 */
	public static final int TASKID_PRAISE_PHOTO_CANCLE = 230;
	/** 获取照片赞用户列表 */
	public static final int TASKID_GET_PHOTO_PRAISE_LIST = 231;
	/**
	 * @Fields TASKID_IS_EXIST_PHOTO :生活照是否存在
	 */
	public static final int TASKID_IS_EXIST_PHOTO = 232;
}
