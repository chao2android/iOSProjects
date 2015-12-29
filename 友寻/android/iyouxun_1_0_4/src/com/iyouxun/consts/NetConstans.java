package com.iyouxun.consts;

import com.iyouxun.j_libs.J_SDK;

/**
 * 网络请求默认参数（地址和api接口）
 */
public class NetConstans {
	// ************************测试环境***************************************//
	public static final String SERVER_TEST_URL = "http://c.friendly.dev/";
	// ************************预上线环境***************************************//
	public static final String SERVER_PRE_URL = "http://c.friendly.com/";
	// ************************正式环境***************************************//
	public static final String SERVER_ONLINE_URL = "http://c.iyouxun.com/";

	/** 接口域名 */
	public static final String SERVER_URL = J_SDK.getConfig().API_SETTING == 1 ? SERVER_TEST_URL
			: J_SDK.getConfig().API_SETTING == 2 ? SERVER_PRE_URL : SERVER_ONLINE_URL;

	/** socket */
	public static final String SOCKET_HOST = "223.202.50.74";
	public static final int SOCKET_PORT = 8080;

	/** 更新用户资料 */
	public static final String UPDATE_USER_INFO_URL = SERVER_URL + "cmiajax/?mod=profile&func=update_user_info&";

	/** 获取用户资料 */
	public static final String GET_USER_INFO_URL = SERVER_URL + "cmiajax/?mod=profile&func=get_user_info&";

	/** 更新个人签名 */
	public static final String UPDATE_USER_INTRO_URL = SERVER_URL + "cmiajax/?mod=profile&func=update_user_intro&";

	/** 更新个人签名 */
	public static final String UPDATE_USER_SCHOOL_NAME_URL = SERVER_URL + "cmiajax/?mod=profile&func=update_user_school_name&";

	/** 更新个人签名 */
	public static final String UPDATE_USER_COMPANY_NAME_URL = SERVER_URL + "cmiajax/?mod=profile&func=update_user_company_name&";
	/**
	 * 自动登录
	 */
	public static final String AUTO_LOGIN_URL = SERVER_URL + "cmiajax/?mod=login&func=auto_login&";
	/**
	 * 登录
	 */
	public static final String LOGIN_URL = SERVER_URL + "cmiajax/?mod=login&func=login&";
	/** 上传头像 */
	public static final String UPLOAD_USER_AVATAR_URL = SERVER_URL + "cmiajax/?mod=avatar&func=upload_useravatar";
	/** 更新用户常住地 */
	public static final String UPDATE_USER_ADDRESS_URL = SERVER_URL + "cmiajax/?mod=profile&func=update_user_address&";
	/**
	 * @Fields GET_SECURITY_CODE_URL :获取注册验证码
	 */
	public static final String GET_SECURITY_CODE_URL = SERVER_URL + "cmiajax/?mod=register&func=get_check_code&";
	/**
	 * @Fields VAILD_MOBILE_EXIST_URL : 验证手机号是否存在
	 */
	public static final String VAILD_MOBILE_EXISTS_URL = SERVER_URL + "cmiajax/?mod=register&func=mobile_exists&";
	/** 上传照片图片 */
	public static final String UPLOAD_PHOTO_URL = SERVER_URL + "cmiajax/?mod=photo&func=upload_photo";
	/** 删除照片图片 */
	public static final String DELETE_PHOTO_URL = SERVER_URL + "cmiajax/?mod=photo&func=delete_photo&";
	/** 获取照片列表 */
	public static final String GET_PHOTO_LIST_URL = SERVER_URL + "cmiajax/?mod=photo&func=get_photo_list&";
	/**
	 * @Fields DO_REGISTER_URL : 注册
	 */
	public static final String DO_REGISTER_URL = SERVER_URL + "cmiajax/?mod=register&func=do_register_all&";
	/**
	 * @Fields VAILD_MOBILE_CODE_URL : 验证验证码
	 */
	public static final String VAILD_MOBILE_CODE_URL = SERVER_URL + "cmiajax/?mod=register&func=valMobileCode&";
	/** 确认单身 */
	public static final String UPDATE_USER_LONELY_CONFIRM_URL = SERVER_URL + "cmiajax/?mod=profile&func=user_lonely_confirm&";
	/** @Fields SET_NEW_PASSWORD_URL : 重置密码 */
	public static final String SET_NEW_PASSWORD_URL = SERVER_URL + "cmiajax/?mod=login&func=set_new_password&";
	/** @Fields NEW_PASSWORD_GET_SECURITY_CODE_URL : 重置密码获取验证码 */
	public static final String NEW_PASSWORD_GET_SECURITY_CODE_URL = SERVER_URL
			+ "cmiajax/?mod=login&func=find_password_get_checkcode&";
	/** @Fields VAILD_BIND_OPENID_URL : 查看第三方绑定状态 */
	public static final String VAILD_BIND_OPENID_URL = SERVER_URL + "cmiajax/?mod=login&func=is_bind_openid&";
	/** @Fields UPLOAD_CONTACT_URL : 上传联系人 */
	public static final String UPLOAD_CONTACT_URL = SERVER_URL + "cmiajax/?mod=upload&func=up_mobile_list";
	/** 添加新动态 */
	public static final String ADD_DYNAMIC_URL = SERVER_URL + "cmiajax/?mod=snsfeed&func=add_dynamic&";
	/** 发布动态上传图片 */
	public static final String PICTURE_UPLOAD_PHOTO_URL = SERVER_URL + "cmiajax/?mod=picture&func=upload_photo";
	/** 删除头像 */
	public static final String DELETE_AVATAR_URL = SERVER_URL + "cmiajax/?mod=avatar&func=delete_useravatar&";
	/** 更新隐私设置 */
	public static final String UPDATE_PRIVACY_URL = SERVER_URL + "cmiajax/?mod=profile&func=update_private_info&";
	/** 获取隐私设置 */
	public static final String GET_PRIVACY_INFO_URL = SERVER_URL + "cmiajax/?mod=profile&func=get_private_info&";
	/** 举报图片 */
	public static final String REPORT_PIC_URL = SERVER_URL + "cmiajax/?mod=police&func=report_pic&";
	/** 举报个人资料 */
	public static final String REPORT_PROFILE_URL = SERVER_URL + "cmiajax/?mod=police&func=report_profile&";
	/** 修改密码 */
	public static final String CHANGE_PASSWORD_URL = SERVER_URL + "cmiajax/?mod=login&func=change_password&";
	/** 更换手机：获取验证码 */
	public static final String FIND_MOBILE_GET_CHECKCODE_URL = SERVER_URL + "cmiajax/?mod=login&func=find_mobile_get_checkcode&";
	/** 更换手机号 */
	public static final String UPDATE_USER_MOBILE_URL = SERVER_URL + "cmiajax/?mod=login&func=update_user_mobile&";
	/** 已经绑定的平台帐号列表 */
	public static final String GET_USER_OAUTHS_URL = SERVER_URL + "cmiajax/?mod=login&func=get_user_oauths&";
	/** 移除已经绑定的平台帐号 */
	public static final String DELETE_BIND_URL = SERVER_URL + "cmiajax/?mod=login&func=del_bind&";
	/** 第三方平台绑定 */
	public static final String BIND_OPEN_PLATFORM_URL = SERVER_URL + "cmiajax/?mod=login&func=bind&";
	/**
	 * @Fields SEND_TEXT_MSG_URL : 发送文字消息
	 */
	public static final String SEND_TEXT_MSG_URL = SERVER_URL + "cmiajax/?mod=chat&func=send_text_msg&";
	/** 添加用户标签 */
	public static final String ADD_TAG_URL = SERVER_URL + "cmiajax/?mod=tags&func=add_tag&";
	/** 删除标签 */
	public static final String DEL_TAG_URL = SERVER_URL + "cmiajax/?mod=tags&func=del_tag&";
	/** 点击标签 */
	public static final String TAG_CLICK_URL = SERVER_URL + "cmiajax/?mod=tags&func=tag_click&";
	/** 获取标签列表 */
	public static final String TAG_LIST_URL = SERVER_URL + "cmiajax/?mod=tags&func=tag_list&";
	/**
	 * @Fields GET_HISTORY_USER_CHAT_LIST : 离线获得消息数据
	 */
	public static final String GET_HISTORY_USER_CHAT_LIST = SERVER_URL + "cmiajax/?mod=msg&func=get_history_user_chat_list&";
	/**
	 * @Fields SET_PUSH_ID : 百度推送绑定id
	 */
	public static final String SET_PUSH_ID = SERVER_URL + "cmiajax/?mod=push&func=set_pushid&";
	/** 更改用户备注 */
	public static final String UPDATE_USER_MARK_URL = SERVER_URL + "cmiajax/?mod=profile&func=update_user_mark&";
	/**
	 * @Fields GET_CHAT_USER_LIST_URL : 获得聊天用户列表
	 */
	public static final String GET_CHAT_USER_LIST_URL = SERVER_URL + "cmiajax/?mod=msg&func=get_chat_user_list&";
	/**
	 * @Fields SEND_PIC_MSG_URL : 发送图片消息
	 */
	public static final String SEND_PIC_MSG_URL = SERVER_URL + "cmiajax/?mod=chat&func=send_pic_msg";
	/**
	 * @Fields SEND_VOICE_MSG_URL : 发送语音消息
	 */
	public static final String SEND_VOICE_MSG_URL = SERVER_URL + "cmiajax/?mod=chat&func=send_voice_msg";

	/** 获取动态列表 */
	public static final String GET_RECOMMEND_DYNAMIC_LIST_URL = SERVER_URL
			+ "cmiajax/?mod=snsfeed&func=get_recommend_dynamic_list&";
	/** 获取单个用户发布过的动态列表 */
	public static final String GET_ONE_USER_DYNAMIC_LIST_URL = SERVER_URL
			+ "cmiajax/?mod=snsfeed&func=get_one_user_dynamic_list&";
	/** 删除一条动态 */
	public static final String DEL_DYNAMIC_URL = SERVER_URL + "cmiajax/?mod=snsfeed&func=del_dynamic&";
	/** 赞动态 */
	public static final String SEND_PRAISE_URL = SERVER_URL + "cmiajax/?mod=snsfeed&func=send_praise&";
	/** 取消赞动态 */
	public static final String DEL_PRAISE_URL = SERVER_URL + "cmiajax/?mod=snsfeed&func=del_praise&";
	/** 转发某人的一条动态 */
	public static final String REBROADCAST_DYNAMIC_URL = SERVER_URL + "cmiajax/?mod=snsfeed&func=rebroadcast_dynamic&";
	/** 动态评论 */
	public static final String SEND_COMMENT_URL = SERVER_URL + "cmiajax/?mod=comment&func=send_comment&";
	/**
	 * @Fields FRIENDS_CREATE_GROUP_URL : 创建好友分组
	 */
	public static final String FRIENDS_CREATE_GROUP_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_create_group&";
	/** 回复评论 */
	public static final String REPLY_COMMENT_URL = SERVER_URL + "cmiajax/?mod=comment&func=reply_comment&";
	/** 获取单个动态信息 */
	public static final String GET_ONE_DYNAMIC_INFO_URL = SERVER_URL + "cmiajax/?mod=snsfeed&func=get_one_dynamic_info&";
	/** 删除评论 */
	public static final String DEL_COMMENT_URL = SERVER_URL + "cmiajax/?mod=comment&func=del_comment&";
	/**
	 * @Fields FRIENDS_GET_GROUP_LIST_URL : 获取好友分组列表
	 */
	public static final String FRIENDS_GET_GROUP_LIST_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_get_grouplist&";
	/**
	 * @Fields FRIENDS_GET_GROUP_MEMBERS_URL : 获得分组成员列表
	 */
	public static final String FRIENDS_GET_GROUP_MEMBERS_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_get_groupmembers&";
	/**
	 * @Fields FRIENDS_DEL_GROUP_URL : 删除好友分组
	 */
	public static final String FRIENDS_DEL_GROUP_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_del_group&";
	/**
	 * @Fields FRIENDS_ADD_GROUP_MEMBERS_URL : 添加分组成员
	 */
	public static final String FRIENDS_ADD_GROUP_MEMBERS_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_add_groupmember&";
	/**
	 * @Fields FRIENDS_REMOVE_GROUP_MEMBERS_URL : 删除分组成员
	 */
	public static final String FRIENDS_REMOVE_GROUP_MEMBERS_URL = SERVER_URL
			+ "cmiajax/?mod=friends&func=friends_rem_groupmember&";
	/**
	 * @Fields FRIENDS_GET_MY_FRIENDS_ALL_URL : 获得所有好友
	 */
	public static final String FRIENDS_GET_MY_FRIENDS_ALL_URL = SERVER_URL
			+ "cmiajax/?mod=friends&func=friends_get_myfriends_all&";
	/** 获取动态消息提醒列表 */
	public static final String LIST_SYSTEM_URL = SERVER_URL + "cmiajax/?mod=msg&func=listsys&";
	/** 消息置为已读 */
	public static final String SET_ONREAD_URL = SERVER_URL + "cmiajax/?mod=msg&func=set_onread&";
	/** 更新经纬度坐标 */
	public static final String UPDATE_LNGLAT_URL = SERVER_URL + "cmiajax/?mod=login&func=update_lnglat&";
	/**
	 * @Fields FRIENDS_GET_FRIENDS_NUMS_URL : 获得好友数量
	 */
	public static final String FRIENDS_GET_FRIENDS_NUMS_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_get_friendsnums&";
	/**
	 * @Fields FRIENDS_GET_MY_FRIENDS_URL : 获取一度好友列表
	 */
	public static final String FRIENDS_GET_MY_FRIENDS_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_get_myfriends&";
	/**
	 * @Fields FRIENDS_MOD_GROUP_URL : 修改分组名
	 */
	public static final String FRIENDS_MOD_GROUP_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_mod_group&";

	/** 全部消息置为已读 */
	public static final String SET_ONREAD_ALLSYSMSG_URL = SERVER_URL + "cmiajax/?mod=msg&func=set_onread_allsysmsg&";
	/** 删除黑名单好友 */
	public static final String DEL_BLACKLIST_URL = SERVER_URL + "cmiajax/?mod=relation&func=del_black_list&";
	/** 获取黑名单列表 */
	public static final String GET_BLACKLIST_LIST_URL = SERVER_URL + "cmiajax/?mod=relation&func=get_black_list&";
	/** 获取已加入的群组列表 */
	public static final String GROUP_LIST_URL = SERVER_URL + "cmiajax/?mod=chat&func=group_list&";
	/** 申请加入一个群组 */
	public static final String ADD_GROUP_URL = SERVER_URL + "cmiajax/?mod=chat&func=add_group&";
	/** 获取某一群组的详细信息 */
	public static final String GET_GROUP_URL = SERVER_URL + "cmiajax/?mod=chat&func=get_group&";
	/** 添加黑名单 */
	public static final String ADD_BLACK_URL = SERVER_URL + "cmiajax/?mod=relation&func=add_black&";
	/** 获取共同好友 */
	public static final String FRIENDS_GET_MUTUALFRIENDS_URL = SERVER_URL
			+ "cmiajax/?mod=friends&func=friends_get_mutualfriends&";
	/** 获取推荐好友 */
	public static final String GET_RECOMMEND_NEW_USERS_URL = SERVER_URL + "cmiajax/?mod=recommend&func=get_recommend_new_users&";
	/** 获取共同好友的数量 */
	public static final String FRIENDS_GET_MUTUALNUMS_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_get_mutualnums&";
	/** 获取群组内成员列表 */
	public static final String GROUP_USER_LIST_URL = SERVER_URL + "cmiajax/?mod=chat&func=group_user_list&";
	/**
	 * @Fields CREATE_GROUP_URL : 创建一个新群组
	 */
	public static final String CREATE_GROUP_URL = SERVER_URL + "cmiajax/?mod=chat&func=create_group&";
	/** 更新群设置 */
	public static final String UPDATE_USER_GROUP_URL = SERVER_URL + "cmiajax/?mod=chat&func=update_user_group&";
	/**
	 * @Fields UPDATE_GROUP_URL : 修改群信息
	 */
	public static final String UPDATE_GROUP_URL = SERVER_URL + "cmiajax/?mod=chat&func=update_group&";
	/**
	 * @Fields EXIT_GROUP_URL : 退出群组
	 */
	public static final String EXIT_GROUP_URL = SERVER_URL + "cmiajax/?mod=chat&func=exit_group&";
	/**
	 * @Fields INVITE_FRIEND_JOIN_GROUP_URL : 群组添加成员
	 */
	public static final String INVITE_FRIEND_JOIN_GROUP_URL = SERVER_URL + "cmiajax/?mod=chat&func=invite_friend_join_group&";

	/** 添加好友申请 */
	public static final String FRIENDS_SENT_REQ_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_sent_req&";
	/**
	 * @Fields GROUP_MASTER_DEL_PERSON_URL : 群主踢人(只有群主操作)
	 */
	public static final String GROUP_MASTER_DEL_PERSON_URL = SERVER_URL + "cmiajax/?mod=chat&func=group_master_del_person&";
	/**
	 * @Fields UPDATE_GROUP_PIC_URL : 修改群组头像
	 */
	public static final String UPDATE_GROUP_PIC_URL = SERVER_URL + "cmiajax/?mod=chat&func=update_group_pic&";
	/**
	 * @Fields RECOMMEND_GROUP_LIST_URL : 获取推荐群组列表
	 */
	public static final String RECOMMEND_GROUP_LIST_URL = SERVER_URL + "cmiajax/?mod=chat&func=recommend_group_list";
	/**
	 * @Fields GET_ALL_CHAT_MSG_LIST_URL : 获取全部聊天消息列表
	 */
	public static final String GET_ALL_CHAT_MSG_LIST_URL = SERVER_URL + "cmiajax/?mod=msg&func=get_all_chat_msg_list&";
	/**
	 * @Fields DEL_MSG_URL : 删除联系人消息
	 */
	public static final String DEL_MSG_URL = SERVER_URL + "cmiajax/?mod=msg&func=del_msg&";
	/**
	 * @Fields DEL_CONTACT_URL : 删除联系人
	 */
	public static final String DEL_CONTACT_URL = SERVER_URL + "cmiajax/?mod=msg&func=del_contact&";
	/**
	 * @Fields SEND_GROUP_MSG_URL : 发送群聊信息
	 */
	public static final String SEND_GROUP_MSG_URL = SERVER_URL + "cmiajax/?mod=chat&func=send_group_msg&";
	/**
	 * @Fields SEND_PIC_GROUP_MSG_URL : 群聊发送一条图片聊天信息
	 */
	public static final String SEND_PIC_GROUP_MSG_URL = SERVER_URL + "cmiajax/?mod=chat&func=send_pic_group_msg&";
	/**
	 * @Fields SEND_VOICE_GROUP_MSG_URL : 群聊发送一条语音聊天信息
	 */
	public static final String SEND_VOICE_GROUP_MSG_URL = SERVER_URL + "cmiajax/?mod=chat&func=send_group_voice_msg&";
	/**
	 * @Fields GET_HISTORY_GROUP_CHAT_LIST_URL : 历史群聊消息列表
	 */
	public static final String GET_HISTORY_GROUP_CHAT_LIST_URL = SERVER_URL
			+ "cmiajax/?mod=msg&func=get_history_group_chat_list&";
	/**
	 * @Fields SEND_ONREAD_BY_OID_URL : 单聊消息设置已读
	 */
	public static final String SEND_ONREAD_BY_OID_URL = SERVER_URL + "cmiajax/?mod=msg&func=set_onread_by_oid&";
	/**
	 * @Fields SEND_ONREAD_GROUP_BY_OID_URL : 群里消息置为已读（也就是群未读消息数清零）
	 */
	public static final String SEND_ONREAD_GROUP_BY_OID_URL = SERVER_URL + "cmiajax/?mod=msg&func=set_onread_group_by_oid&";
	/** 获取通知消息数字 */
	public static final String NOTICE_GET_URL = SERVER_URL + "cmiajax/?mod=notice&func=gets&";
	/** 获取动态新消息数字 */
	public static final String NOTICE_NEW_DYNAMIC_URL = SERVER_URL + "cmiajax/?mod=notice&func=new_dynamic&";
	/**
	 * @Fields FRIENDS_GET_FSFRIENDS_URL : 获取2度好友列表
	 */
	public static final String FRIENDS_GET_FSFRIENDS_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_get_fsfriends&";
	/**
	 * @Fields TAG_GET_MAX_TAGS_URL : 获取使用最多的30个标签
	 */
	public static final String TAG_GET_MAX_TAGS_URL = SERVER_URL + "cmiajax/?mod=tags&func=max_tags";

	/**
	 * @Fields ACCEPT_FRIEND_JOIN_GROUP_URL : 接受或拒绝好友加入群(只有群主操作)
	 */
	public static final String ACCEPT_FRIEND_JOIN_GROUP_URL = SERVER_URL + "cmiajax/?mod=chat&func=accept_friend_join_group&";

	/** 更新app */
	public static final String UPDATE_CLIENT_URL = SERVER_URL + "update_client.php?";
	/** 首次提示用户上传通讯录，用户取消后的请求 */
	public static final String FRIENDS_MAKEFRIENDSHIP_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_makefriendship&";
	/**
	 * @Fields FRIENDS_ACCEPT_REQ_URL : 通过好友申请
	 */
	public static final String FRIENDS_ACCEPT_REQ_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_accept_req&";
	/**
	 * @Fields FRIENDS_SEND_MSG_TO_REG_FRIENDS_URL : 新好友加入
	 */
	public static final String FRIENDS_SEND_MSG_TO_REG_FRIENDS_URL = SERVER_URL
			+ "cmiajax/?mod=friends&func=friends_sentmsg_to_regfriends&";
	/**
	 * @Fields COUNT_GROUP_URL : 我的群组数量
	 */
	public static final String COUNT_GROUP_URL = SERVER_URL + "cmiajax/?mod=chat&func=count_group&";
	/**
	 * @Fields COUNT_NEW_URL : 获取新消息通知数
	 */
	public static final String COUNT_NEW_URL = SERVER_URL + "cmiajax/?mod=msg&func=countnew";
	/**
	 * @Fields DEL_PUSH_ID : 解绑推送
	 */
	public static final String DEL_PUSH_ID = SERVER_URL + "cmiajax/?mod=push&func=del_pushid&";
	/** 取消确认单身 */
	public static final String CANCEL_LONELY_CONFIRM_URL = SERVER_URL + "cmiajax/?mod=profile&func=cancel_lonely_confirm&";
	/**
	 * @Fields UPDATE_GROUP_TITLE_URL : 修改群组名称
	 */
	public static final String UPDATE_GROUP_TITLE_URL = SERVER_URL + "cmiajax/?mod=chat&func=update_group_title&";
	/**
	 * @Fields UPDATE_GROUP_STATUS_URL : 更新群组状态
	 */
	public static final String UPDATE_GROUP_STATUS_URL = SERVER_URL + "cmiajax/?mod=chat&func=update_group_status&";
	/**
	 * @Fields IGNORE_SYS_URL : 忽略好友申请
	 */
	public static final String IGNORE_SYS_URL = SERVER_URL + "cmiajax/?mod=msg&func=ignore_sys&";

	/** 意见反馈 */
	public static final String ADD_FEEDBACK_URL = SERVER_URL + "cmiajax/?mod=feedback&func=add_feedback&";

	/** 获取所有一度、二度好友列表 */
	public static final String FRIENDS_GET_FRIENDS_ALL_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_get_friends_all&";

	/** 获取所有已读、二度好友列表总数字 */
	public static final String FRIENDS_GET_FRIENDSNUMS_ALL_URL = SERVER_URL
			+ "cmiajax/?mod=friends&func=friends_get_friendsnums_all&";
	/**
	 * @Fields FRIENDS_REM_REQ_URL : 删除好友申请
	 */
	public static final String FRIENDS_REM_REQ_URL = SERVER_URL + "cmiajax/?mod=friends&func=friends_rem_req&";
	/**
	 * @Fields UPDATE_GROUP_SHOW_URL : 修改用户群在资料页显示状态
	 */
	public static final String UPDATE_GROUP_SHOW_URL = SERVER_URL + "cmiajax/?mod=chat&func=update_user_group_show&";
	/**
	 * @Fields SET_HANDLED_URL : 设置系统消息已处理
	 */
	public static final String SET_HANDLED_URL = SERVER_URL + "cmiajax/?mod=msg&func=set_handled&";

	/**
	 * @Fields IS_GROUP_MEMBER_URL : 是否是群成员
	 */
	public static final String IS_GROUP_MEMBER_URL = SERVER_URL + "cmiajax/?mod=chat&func=is_group_member&";
	/**
	 * @Fields UPDATE_USER_GROUP_SHOW_NICK_URL : 群聊是否展示昵称
	 */
	public static final String UPDATE_USER_GROUP_SHOW_NICK_URL = SERVER_URL
			+ "cmiajax/?mod=chat&func=update_user_group_shownick&";
	/**
	 * @Fields GET_USER_VOICE_SWITCH_URL : 获取听筒模式和扬声器模式开关
	 */
	public static final String GET_USER_VOICE_SWITCH_URL = SERVER_URL + "cmiajax/?mod=profile&func=get_user_voice_switch&";
	/**
	 * @Fields SET_USER_VOICE_SWITCH_URL : 设置听筒模式和扬声器模式开关
	 */
	public static final String SET_USER_VOICE_SWITCH_URL = SERVER_URL + "cmiajax/?mod=profile&func=set_user_voice_switch&";
	/**
	 * @Fields CLEAR_CACHE_URL : 清除接口调用cache
	 */
	public static final String CLEAR_CACHE_URL = SERVER_URL + "cmiajax/?mod=msg&func=clear_cache_gid";
	/**
	 * @Fields SEND_SINGLE_MSG_URL : 单聊求脱单
	 */
	public static final String SEND_SINGLE_MSG_URL = SERVER_URL + "cmiajax/?mod=chat&func=send_single_msg&";

	/**
	 * @Fields SEND_GROUP_SINGLE_MSG_URL : 群聊求脱单
	 */
	public static final String SEND_GROUP_SINGLE_MSG_URL = SERVER_URL + "cmiajax/?mod=chat&func=send_group_single_msg&";
}
