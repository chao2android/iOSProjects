package com.iyouxun.data.parser;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;

import org.json.JSONException;
import org.json.JSONObject;

import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.beans.users.LoginUser;
import com.iyouxun.j_libs.json.parser.J_JsonParser;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.AutoLoginRequest;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.net.response.AutoLoginResponse;
import com.iyouxun.net.response.LoginResponse;
import com.iyouxun.net.response.SendGroupMsgResonse;
import com.iyouxun.net.response.SendTextMsgResonse;
import com.iyouxun.net.response.UpdateAppResponse;
import com.iyouxun.net.response.UserInfoResponse;
import com.iyouxun.net.response.VaildBindOpenidResponse;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.SettingSharedPreUtil;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;
import com.iyouxun.utils.WorkLocation;

/**
 * json数据解析器
 * 
 * 为了在http请求返回解析数据时，可以返回指定格式的解析数据，加上了此解析方法
 * 
 * 如果需要返回指定格式的数据，可以在com.iyouxun.net.response包下增加相应的response格式文件
 * 则在请求结果的onreponse（）方法中即会返回次格式数据
 * 
 * @author likai
 * @date 2014年9月10日 上午11:51:56
 */
public class JsonParser extends J_JsonParser {
	private static final String RESPONSE_TIME = "time";
	private static final String RESPONSE_IID = "iid";
	private static final String RESPONSE_SUCCESS = "success";
	public final static String RESPONSE_RETCODE = "retcode";
	public final static String RESPONSE_RETMEAN = "retmean";
	public final static String RESPONSE_DATA = "data";
	public final static String RESPONSE_TOKEN = "token";
	public final static String RESPONSE_UID = "uid";
	public final static String CMI_AJAX_RET_CODE_SUCC = "CMI_AJAX_RET_CODE_SUCC";

	/**
	 * @Fields notLogin : 不需要登录就可以调用的接口id
	 */
	private final int[] notLogin = { NetTaskIDs.TASKID_AUTO_LOGIN, NetTaskIDs.TASKID_LOGIN, NetTaskIDs.TASKID_GET_SECURITY_CODE,
			NetTaskIDs.TASKID_VAILD_MOBILE_EXISTS, NetTaskIDs.TASKID_VAILD_MOBILE_CODE, NetTaskIDs.TASKID_SET_NEW_PASSWORD,
			NetTaskIDs.TASKID_NEW_PASSWORD_GET_SECURITY_CODE, NetTaskIDs.TASKID_DO_REGISTER, NetTaskIDs.TASKID_VAILD_BIND_OPENID };

	@Override
	public Object parsJson(String jsonStr, J_Request request) throws Exception {
		if (!Util.useLoop(notLogin, request.REQUEST_TYPE)) {// 需要登录后才能请求的接口
			// 登录状态判断
			jsonStr = checkLoginStatus(jsonStr, request);
		}

		// 解析请求返回信息
		switch (request.REQUEST_TYPE) {
		case NetTaskIDs.TASKID_GET_USER_INFO:
			// 用户信息
			return parseUserInfo(jsonStr);
		case NetTaskIDs.TASKID_UPDATE_USER_INFO:
			// 更新用户资料
		case NetTaskIDs.TASKID_UPDATE_USER_INTRO:
			// 更新签名
		case NetTaskIDs.TASKID_UPDATE_USER_SCHOOL_NAME:
			// 更新学校
		case NetTaskIDs.TASKID_UPDATE_USER_COMPANY_NAME:
			// 更新公司
		case NetTaskIDs.TASKID_UPLOAD_USER_AVATAR:
			// 上传头像
		case NetTaskIDs.TASKID_UPDATE_USER_ADDRESS:
			// 更新地址
		case NetTaskIDs.TASKID_UPLOAD_PHOTO:
			// 上传照片
		case NetTaskIDs.TASKID_DELETE_PHOTO:
			// 删除照片
		case NetTaskIDs.TASKID_GET_PHOTO_LIST:
			// 获取照片列表
		case NetTaskIDs.TASKID_UPDATE_USER_LONELY_CONFIRM:
			// 确认单身
		case NetTaskIDs.TASKID_ADD_DYNAMIC:
			// 发布新动态
		case NetTaskIDs.TASKID_PICTURE_UPLOAD_PHOTO:
			// 发布新动态上传图片
		case NetTaskIDs.TASKID_DELETE_AVATAR:
			// 删除头像
		case NetTaskIDs.TASKID_UPDATE_PRIVACY:
			// 更新隐私设置
		case NetTaskIDs.TASKID_REPORT_PIC:
			// 举报图片
		case NetTaskIDs.TASKID_REPORT_PROFILE:
			// 举报个人资料
		case NetTaskIDs.TASKID_CHANGE_PASSWORD:
			// 修改密码
		case NetTaskIDs.TASKID_FIND_MOBILE_GET_CHECKCODE:
			// 更换手机号：获取验证码
		case NetTaskIDs.TASKID_UPDATE_USER_MOBILE:
			// 更换手机号
		case NetTaskIDs.TASKID_GET_USER_OAUTHS:
			// 获取已经绑定的平台帐号列表
		case NetTaskIDs.TASKID_DELETE_BIND:
			// 移除已经绑定的平台帐号
		case NetTaskIDs.TASKID_BIND_OPEN_PLATFORM:
			// 绑定第三方平台帐号
		case NetTaskIDs.TASKID_ADD_TAG:
			// 添加标签
		case NetTaskIDs.TASKID_DEL_TAG:
			// 删除标签
		case NetTaskIDs.TASKID_TAG_CLICK:
			// 点击标签
		case NetTaskIDs.TASKID_TAG_LIST:
			// 获取标签列表
		case NetTaskIDs.TASKID_UPDATE_USER_MARK:
			// 更新备注
		case NetTaskIDs.TASKID_GET_RECOMMEND_DYNAMIC_LIST:
			// 获取动态列表
		case NetTaskIDs.TASKID_GET_ONE_USER_DYNAMIC_LIST:
			// 获取单个用户发布过的动态列表
		case NetTaskIDs.TASKID_DEL_DYNAMIC:
			// 删除一条动态
		case NetTaskIDs.TASKID_SEND_PRAISE:
			// 赞一条动态
		case NetTaskIDs.TASKID_DEL_PRAISE:
			// 取消一条赞
		case NetTaskIDs.TASKID_REBROADCAST_DYNAMIC:
			// 转发一条动态
		case NetTaskIDs.TASKID_SEND_COMMENT:
			// 动态评论
		case NetTaskIDs.TASKID_REPLY_COMMENT:
			// 回复评论
		case NetTaskIDs.TASKID_GET_ONE_DYNAMIC_INFO:
			// 获取单个动态信息
		case NetTaskIDs.TASKID_DEL_COMMENT:
			// 删除评论
		case NetTaskIDs.TASKID_VAILD_MOBILE_EXISTS:
			// 手机号是否存在
		case NetTaskIDs.TASKID_VAILD_MOBILE_CODE:
			// 验证验证码
		case NetTaskIDs.TASKID_SET_NEW_PASSWORD:
			// 重置密码
		case NetTaskIDs.TASKID_GET_CHAT_USER_LIST:
			// 消息用户列表
		case NetTaskIDs.TASKID_FRIENDS_GET_GROUP_LIST:
			// 好友分组列表
		case NetTaskIDs.TASKID_FRIENDS_DEL_GROUP:
			// 删除好友分组
		case NetTaskIDs.TASKID_FRIENDS_CREATE_GROUP:
			// 创建好友分组
		case NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS_ALL:
			// 获取所有一度好友
		case NetTaskIDs.TASKID_LIST_SYSTEM:
			// 获取动态消息提醒列表
		case NetTaskIDs.TASKID_SET_ONREAD:
			// 消息置为已读
		case NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_NUMS:
			// 获得好友数量
		case NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS:
			// 获得一度好友数量
		case NetTaskIDs.TASKID_FRIENDS_GET_GROUP_MEMBERS:
			// 获得分组成员
		case NetTaskIDs.TASKID_FRIENDS_ADD_GROUP_MEMBERS:
			// 添加分组成员
		case NetTaskIDs.TASKID_FRIENDS_REMOVE_GROUP_MEMBERS:
			// 移除分组成员
		case NetTaskIDs.TASKID_FRIENDS_MOD_GROUP:
			// 修改分组名
		case NetTaskIDs.TASKID_UPDATE_LNGLAT:
			// 更新经纬度坐标
		case NetTaskIDs.TASKID_SET_ONREAD_ALLSYSMSG:
			// 消息全部置为已读
		case NetTaskIDs.TASKID_DEL_BLACKLIST:
			// 删除黑名单用户
		case NetTaskIDs.TASKID_GET_BLACKLIST_LIST:
			// 获取黑名单联系人列表
		case NetTaskIDs.TASKID_GROUP_LIST:
			// 获取已加入的群组列表
		case NetTaskIDs.TASKID_ADD_GROUP:
			// 申请加入一个群组
		case NetTaskIDs.TASKID_GET_GROUP:
			// 获取某一群组的详细信息
		case NetTaskIDs.TASKID_ADD_BLACK:
			// 添加黑名单
		case NetTaskIDs.TASKID_FRIENDS_GET_MUTUALFRIENDS:
			// 获取共同好友
		case NetTaskIDs.TASKID_GET_RECOMMEND_NEW_USERS:
			// 获取推荐用户列表
		case NetTaskIDs.TASKID_FRIENDS_GET_MUTUALNUMS:
			// 获取两人共同好友数量
		case NetTaskIDs.TASKID_GROUP_USER_LIST:
			// 获取群组内成员列表
		case NetTaskIDs.TASKID_UPDATE_USER_GROUP:
			// 修改群组设置信息（针对用户）
		case NetTaskIDs.TASKID_UPDATE_GROUP:
			// 修改群信息
		case NetTaskIDs.TASKID_INVITE_FRIEND_JOIN_GROUP:
			// 所有人可以邀请好友加入(一度)
		case NetTaskIDs.TASKID_EXIT_GROUP:
			// 退出群组
		case NetTaskIDs.TASKID_FRIENDS_SENT_REQ:
			// 申请添加好友
		case NetTaskIDs.TASKID_GROUP_MASTER_DEL_PERSON:
			// 群主踢人
		case NetTaskIDs.TASKID_RECOMMEND_GROUP_LIST:
			// 获取推荐群组列表
		case NetTaskIDs.TASKID_GET_ALL_CHAT_MSG_LIST:
			// 获取全部聊天消息列表
		case NetTaskIDs.TASKID_DEL_MSG:
			// 删除联系人消息
		case NetTaskIDs.TASKID_DEL_CONTACT:
			// 删除联系人
		case NetTaskIDs.TASKID_GET_HISTORY_GROUP_CHAT_LIST:
			// 群组消息离线数据
		case NetTaskIDs.TASKID_NOTICE_GET:
			// 获取通知消息数字
		case NetTaskIDs.TASKID_NOTICE_NEW_DYNAMIC:
			// 获取动态新消息数字
		case NetTaskIDs.TASKID_FRIENDS_GET_FSFRIENDS:
			// 获取二度好友数据
		case NetTaskIDs.TASKID_TAG_GET_MAX_TAGS:
			// 获取使用最多的30个标签
		case NetTaskIDs.TASKID_ACCEPT_FRIEND_JOIN_GROUP:
			// 接受或拒绝好友加入群(只有群主操作)
		case NetTaskIDs.TASKID_FRIENDS_MAKEFRIENDSHIP:
			// 首次提示用户上传通讯录，用户取消后的请求
		case NetTaskIDs.TASKID_FRIENDS_ACCEPT_REQ:
			// 接受好友申请
		case NetTaskIDs.TASKID_FRIENDS_REM_REQ:
			// 删除好友申请
		case NetTaskIDs.TASKID_COUNT_GROUP:
			// 我的群组数量
		case NetTaskIDs.TASKID_COUNT_NEW:
			// 获取新消息通知数
		case NetTaskIDs.TASKID_GET_SECURITY_CODE:
			// 获取验证码
		case NetTaskIDs.TASKID_CANCEL_LONELY_CONFIRM:
			// 取消确认单身
		case NetTaskIDs.TASKID_UPDATE_GROUP_TITLE:
			// 修改群组名称
		case NetTaskIDs.TASKID_UPDATE_GROUP_STATUS:
			// 更新群组状态
		case NetTaskIDs.TASKID_ADD_FEEDBACK:
			// 意见反馈
		case NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_ALL:
			// 获取所有一度、二度好友列表
		case NetTaskIDs.TASKID_FRIENDS_GET_FRIENDSNUMS_ALL:
			// 获取所有一度、二度好友列表
		case NetTaskIDs.TASKID_UPDATE_GROUP_SHOW:
			// 修改用户群在资料页显示状态
			return normalParseInfo(jsonStr);
		case NetTaskIDs.TASKID_UPDATE_CLIENT:
			// 更新app
			return parseUpdateApp(jsonStr);
		case NetTaskIDs.TASKID_GET_PRIVACY_INFO:
			// 获取隐私设置
			return parsePrivacyInfo(jsonStr, request);
		case NetTaskIDs.TASKID_AUTO_LOGIN:
			// 自动登录
			return parserAutoLoginInfo(jsonStr);
		case NetTaskIDs.TASKID_LOGIN:
			// 登录
			return parserLoginInfo(jsonStr);
		case NetTaskIDs.TASKID_VAILD_BIND_OPENID:
			// 验证第三方绑定状态
			return parserVaildBindOpenid(jsonStr);
		case NetTaskIDs.TASKID_SEND_TEXT_MSG:
			// 发送文本消息
			return parserSendTextMsg(jsonStr, request.CHAT_TABLE_ID);
		case NetTaskIDs.TASKID_SEND_GROUP_MSG:
			// 群组文本消息
			return parserSendGroupMsg(jsonStr, request.CHAT_TABLE_ID);
		case NetTaskIDs.TASKID_GET_HISTORY_USER_CHAT_LIST:
			// 离线消息列表
			return parserGetHistoryUserChatList(jsonStr);
		case NetTaskIDs.TASKID_NEW_PASSWORD_GET_SECURITY_CODE:
			// 重置密码获取验证码
		case NetTaskIDs.TASKID_DO_REGISTER:
			// 注册
			return jsonStr;
		}

		return jsonStr;
	}

	/**
	 * @Title: parserGetHistoryUserChatList
	 * @Description: 解析离线消息列表
	 * @return J_Response 返回类型
	 * @param @param jsonStr
	 * @param @return
	 * @param @throws JSONException 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private J_Response parserGetHistoryUserChatList(String jsonStr) throws JSONException {
		JSONObject jsonObject = new JSONObject(jsonStr);
		J_Response response = new J_Response();
		response.retcode = jsonObject.getInt(RESPONSE_RETCODE);
		response.retmean = JsonUtil.getJsonString(jsonObject, RESPONSE_RETMEAN);
		response.obj = JsonUtil.getJsonArray(jsonObject, RESPONSE_DATA);
		response.data = JsonUtil.getJsonString(jsonObject, RESPONSE_DATA);
		return response;
	}

	/**
	 * @param cHAT_TABLE_ID
	 * @Title: parserSendTextMsg
	 * @Description: 解析文本消息返回数据
	 * @return J_Response 返回类型
	 * @param @param jsonStr
	 * @param @return
	 * @param @throws JSONException 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private SendTextMsgResonse parserSendTextMsg(String jsonStr, long chat_table_id) throws JSONException {
		JSONObject jsonObject = new JSONObject(jsonStr);
		SendTextMsgResonse response = new SendTextMsgResonse();
		response.retcode = jsonObject.getInt(RESPONSE_RETCODE);
		response.retmean = JsonUtil.getJsonString(jsonObject, RESPONSE_RETMEAN);
		response.data = JsonUtil.getJsonString(jsonObject, RESPONSE_DATA);
		response.chat_table_id = chat_table_id;
		if (response.retcode == 1 && CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
			JSONObject dataObject = JsonUtil.getJsonObject(jsonObject, RESPONSE_DATA);
			response.iid = JsonUtil.getJsonString(dataObject, RESPONSE_IID);
			String time = JsonUtil.getJsonString(dataObject, RESPONSE_TIME);
			if (!Util.isBlankString(time)) {
				response.time = time + "000";
			}
			response.status = dataObject.optInt(UtilRequest.FORM_STATUS);
		}
		return response;
	}

	/**
	 * @Title: parserSendGroupMsg
	 * @Description: 解析群组消息返回数据
	 * @return SendGroupMsgResonse 返回类型
	 * @param @param jsonStr 返回数据
	 * @param @param chat_table_id 消息id
	 * @param @return
	 * @param @throws JSONException 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private SendGroupMsgResonse parserSendGroupMsg(String jsonStr, long chat_table_id) throws JSONException {
		JSONObject jsonObject = new JSONObject(jsonStr);
		SendGroupMsgResonse response = new SendGroupMsgResonse();
		response.retcode = jsonObject.getInt(RESPONSE_RETCODE);
		response.retmean = JsonUtil.getJsonString(jsonObject, RESPONSE_RETMEAN);
		response.data = JsonUtil.getJsonString(jsonObject, RESPONSE_DATA);
		response.chat_table_id = chat_table_id;
		if (response.retcode == 1 && CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
			JSONObject dataObject = JsonUtil.getJsonObject(jsonObject, RESPONSE_DATA);
			response.iid = JsonUtil.getJsonString(dataObject, RESPONSE_IID);
			String time = JsonUtil.getJsonString(dataObject, RESPONSE_TIME);
			if (!Util.isBlankString(time)) {
				response.time = time + "000";
			}
			response.status = dataObject.optInt(UtilRequest.FORM_STATUS);
			response.msgType = dataObject.optInt(UtilRequest.FORM_MSG_TYPE);
		}
		return response;
	}

	/**
	 * 获取并保存用户隐私设置信息
	 * 
	 * @Title: parsePrivacyInfo
	 * @return J_Response 返回类型
	 * @param @param jsonStr
	 * @param @return
	 * @param @throws JSONException 参数类型
	 * @author likai
	 * @throws
	 */
	private J_Response parsePrivacyInfo(String jsonStr, J_Request request) throws JSONException {
		J_Response response = new J_Response();
		JSONObject object = new JSONObject(jsonStr);
		int retcode = object.optInt("retcode");
		String retmean = object.optString("retmean");
		String data = object.optString("data");

		if (retcode == 1) {
			String uid = request.getRequestData().get("uid");
			if (Util.getInteger(uid) == SharedPreUtil.getLoginInfo().uid) {
				// 更新当前登录用户的隐私设置信息
				JSONObject dataJson = object.optJSONObject("data");
				Iterator iterator = dataJson.keys();
				while (iterator.hasNext()) {
					String key = (String) iterator.next();
					int value = dataJson.optInt(key);
					SettingSharedPreUtil.saveShareIntConfigInfo(key, value);
				}
			}
		}

		response.retcode = retcode;
		response.retmean = retmean;
		response.data = data;
		response.obj = jsonStr;
		return response;
	}

	/**
	 * 登录状态检查
	 * 
	 * @return void 返回类型
	 * @param @param jsonStr 参数类型
	 * @author likai
	 */
	private String checkLoginStatus(String jsonStr, final J_Request request) {
		String jsonString = jsonStr;
		if (!Util.isBlankString(jsonStr)) {
			try {
				int index = jsonStr.indexOf("{\"retcode\"");
				jsonString = jsonStr.subSequence(index, jsonStr.length()).toString();
				JSONObject data = new JSONObject(jsonString);
				int retcode = data.optInt("retcode");
				if (retcode == -2002) {
					// 当前状态为未登录状态
					// 获取登录token
					String token = SharedPreUtil.getLoginToken();
					// 执行登录操作
					AutoLoginRequest loginRequest = new AutoLoginRequest(new OnDataBack() {
						@Override
						public void onResponse(Object result) {
							J_Response response = (J_Response) result;
							if (response.retcode == 1) {
								try {
									String str = response.obj.toString();
									if (!Util.isBlankString(str)) {
										JSONObject data = new JSONObject(str);
										String uid = data.optString("uid");
										if (!Util.isBlankString(uid)) {
											J_NetManager.getInstance().sendRequest(request);
										}
									}
								} catch (Exception e) {
									e.printStackTrace();
								}
							}
						}

						@Override
						public void onError(HashMap<String, Object> errMap) {
							int Error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
						}
					});

					loginRequest.login(token);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		return jsonString;
	}

	/**
	 * 公共的解析数据格式
	 * 
	 * @return J_Response 返回类型
	 * @param str 要解析的字符串
	 * @return
	 * @param @throws Exception 参数类型
	 * @author likai
	 */
	private J_Response normalParseInfo(String jsonStr) throws Exception {
		JSONObject object = new JSONObject(jsonStr);
		int retcode = object.optInt("retcode");
		String retmean = object.optString("retmean");
		String data = object.optString("data");
		J_Response response = new J_Response();
		response.retcode = retcode;
		response.retmean = retmean;
		response.data = data;
		response.obj = jsonStr;
		return response;
	}

	/**
	 * 解析获取的用户信息
	 * 
	 * @return J_Response 返回类型
	 * @param str 返回的json字符串
	 * @param @throws Exception 参数类型
	 * @author likai
	 */
	private UserInfoResponse parseUserInfo(String str) throws Exception {
		UserInfoResponse response = new UserInfoResponse();

		LoginUser parseUser = new LoginUser();
		JSONObject jsonObject = new JSONObject(str);

		/** 是否获取登录用户 0:否，1：是 */
		int isLoginUser = 0;

		if (jsonObject.optInt("retcode") == 1) {
			JSONObject userInfos = JsonUtil.getJsonObject(jsonObject, "data");
			// 获取uid
			String uid = JsonUtil.getJsonString(userInfos, "uid");
			long currUid = JsonUtil.parseToInt(uid);
			// 判断当前获取信息的用户类型
			LoginUser spLoginUser = SharedPreUtil.getLoginInfo();
			if (spLoginUser == null || spLoginUser.uid <= 0 || spLoginUser.uid == currUid) {
				isLoginUser = 1;
				// 如果是获取的当前登录用户的信息，并且该用户存在原有信息，需要在原登录用户信息基础上更新信息
				parseUser = spLoginUser;
			}
			// uid
			parseUser.uid = currUid;
			// 昵称
			parseUser.nickName = JsonUtil.getJsonString(userInfos, "nick");
			// 性别
			parseUser.sex = userInfos.optInt("sex");
			// age
			String age = JsonUtil.getJsonString(userInfos, "age");
			parseUser.age = JsonUtil.parseToInt(age);
			// 位置信息-code
			String location = JsonUtil.getJsonString(userInfos, "live_location");
			String subLocation = JsonUtil.getJsonString(userInfos, "live_sublocation");
			parseUser.location = JsonUtil.parseToInt(location);
			parseUser.subLocation = JsonUtil.parseToInt(subLocation);
			// 位置信息-String
			if (!Util.isBlankString(location) && !Util.isBlankString(subLocation)) {
				// 通过pid获取pindex
				int pindex = WorkLocation.getLocationIndexWithCode(location);
				parseUser.locationName = WorkLocation.getLocationNameWithIndex(pindex);// 省份名
				// cid 获取cindex
				int cindex = WorkLocation.getSubLocationIndexWithCode(pindex, subLocation);
				parseUser.subLocationName = WorkLocation.getSubLocationNameWithIndex(pindex, cindex, false);// 城市名
			}
			// 生日
			String birthInfo = JsonUtil.getJsonString(userInfos, "birthday");
			String[] birthArray = birthInfo.split("\\-");
			if (birthArray != null && birthArray.length == 3) {
				parseUser.birthYear = JsonUtil.parseToInt(birthArray[0]);
				parseUser.birthMonth = JsonUtil.parseToInt(birthArray[1]);
				parseUser.birthDay = JsonUtil.parseToInt(birthArray[2]);
			}
			// 婚姻状况
			parseUser.marriage = userInfos.optInt("marriage");
			// 身高
			parseUser.height = userInfos.optInt("height");
			// 体重
			parseUser.weight = userInfos.optInt("weight");
			// 职业
			parseUser.career = userInfos.optInt("career");
			// 公司
			parseUser.company = JsonUtil.getJsonString(userInfos, "company_name");
			// 学校
			parseUser.school = JsonUtil.getJsonString(userInfos, "school");
			// 个人签名介绍
			parseUser.intro = JsonUtil.getJsonString(userInfos, "intro");
			// 星座
			parseUser.star = userInfos.optInt("star");
			// 生肖
			parseUser.birthpet = userInfos.optInt("animal");
			// 好友认证数量
			parseUser.lonelyConfirm = userInfos.optInt("lonely_confirm");
			// 图片数量
			parseUser.photoCount = userInfos.optInt("photocount");
			// 距离
			parseUser.distance = userInfos.optInt("distance");
			// 常住地
			parseUser.address = userInfos.optString("address");
			// 是否好友
			parseUser.isFriend = userInfos.optInt("is_friend");
			// 是否确认过单身
			parseUser.isLonelyConfirm = userInfos.optInt("is_lonely_confirm");
			// 是否上传头像
			parseUser.hasAvatar = userInfos.optInt("hasavatar");
			// avatars
			JSONObject avatarsAll = JsonUtil.getJsonObject(userInfos, "avatars");
			if (userInfos != null) {
				String pid = JsonUtil.getJsonString(avatarsAll, "pid");
				String avatar150 = JsonUtil.getJsonString(avatarsAll, "150");
				String avatar200 = JsonUtil.getJsonString(avatarsAll, "200");
				String avatar600 = JsonUtil.getJsonString(avatarsAll, "600");
				// 头像
				parseUser.avatarUrl = avatar200;
				if (!Util.isBlankString(avatar150)) {
					parseUser.avatarUrl150 = avatar150;
				}
				if (!Util.isBlankString(avatar200)) {
					parseUser.avatarUrl200 = avatar200;
				}
				if (!Util.isBlankString(avatar600)) {
					parseUser.avatarUrl600 = avatar600;
				}
				// 头像pid
				if (!Util.isBlankString(pid)) {
					parseUser.avatarPid = pid;
				}
			}
			// 昵称备注
			if (userInfos.has("mark")) {
				parseUser.mark = userInfos.optString("mark");
			}
			// 权限设置-是否显示二度好友动态
			if (userInfos.has("show_second_friend_dync")) {
				parseUser.show_second_friend_dync = userInfos.optInt("show_second_friend_dync");
			}
			// 权限设置-是否允许二度好友查看我的动态
			if (userInfos.has("allow_second_friend_look_my_dync")) {
				parseUser.allow_second_friend_look_my_dync = userInfos.optInt("allow_second_friend_look_my_dync");
			}
			// 权限设置-是否接受二度好友邀请加入群
			if (userInfos.has("allow_accept_second_friend_invite")) {
				parseUser.allow_accept_second_friend_invite = userInfos.optInt("allow_accept_second_friend_invite");
			}
			// 权限设置-好友与聊天
			if (userInfos.has("allow_add_with_chat")) {
				parseUser.allow_add_with_chat = userInfos.optInt("allow_add_with_chat");
			}
			// 权限设置-资料展示
			if (userInfos.has("allow_my_profile_show")) {
				parseUser.allow_my_profile_show = userInfos.optInt("allow_my_profile_show");
			}
			// 通讯录是否已上传的标记
			parseUser.callno_upload = userInfos.optInt("callno_upload");
			// 好友数量
			parseUser.friends_num = userInfos.optInt("friends_num");

			// 最新的几张图片
			if (userInfos.has("photoes")) {
				String photoInfoStr = userInfos.optString("photoes");
				if (!Util.isBlankString(photoInfoStr) && !photoInfoStr.equals("[]")) {
					parseUser.photoDatasStr = photoInfoStr;
					parseUser.photoDatas = SharedPreUtil.parsePhotoInfo(currUid, parseUser.nickName, photoInfoStr);
				} else {
					parseUser.photoDatasStr = "";
					parseUser.photoDatas = new ArrayList<PhotoInfoBean>();
				}
			}

			if (isLoginUser == 1) {
				// 保存更新当前登录用户信息
				SharedPreUtil.saveLoginInfo(parseUser);
			} else {
				SharedPreUtil.saveNormalUser(parseUser);
			}

			response.retcode = jsonObject.optInt("retcode");
			response.obj = str;
			response.data = jsonObject.optString("data");
			response.userInfo = parseUser;
		}
		return response;
	}

	/**
	 * @Title: parserLoginInfo
	 * @Description: 解析登陆数据
	 * @return LoginResponse 登录数据
	 * @param @param jsonString
	 * @param @return
	 * @param @throws JSONException 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private LoginResponse parserLoginInfo(String jsonString) throws JSONException {
		LoginResponse response = new LoginResponse();
		JSONObject loginObject = new JSONObject(jsonString);
		response.retcode = loginObject.optInt(RESPONSE_RETCODE);
		response.data = JsonUtil.getJsonString(loginObject, RESPONSE_DATA);
		response.retmean = JsonUtil.getJsonString(loginObject, RESPONSE_RETMEAN);
		if (response.retcode == 1) {
			JSONObject data = JsonUtil.getJsonObject(loginObject, RESPONSE_DATA);
			int uid = JsonUtil.parseToInt(JsonUtil.getJsonString(data, RESPONSE_UID));
			String token = JsonUtil.getJsonString(data, RESPONSE_TOKEN);
			int status = data.optInt(UtilRequest.FORM_STATUS);
			LoginUser user = new LoginUser();
			user.uid = uid;
			response.userInfo = user;
			response.token = token;
			response.status = status;
		}
		return response;
	}

	/**
	 * @Title: parserAutoLoginInfo
	 * @Description: 解析自动登录数据
	 * @return AutoLoginResponse 返回类型
	 * @param @param jsonString
	 * @param @return
	 * @param @throws JSONException 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private AutoLoginResponse parserAutoLoginInfo(String jsonString) throws JSONException {
		AutoLoginResponse response = new AutoLoginResponse();
		if (Util.isBlankString(jsonString)) {
			return response;
		}
		JSONObject auto = new JSONObject(jsonString);
		response.retcode = auto.optInt(RESPONSE_RETCODE);
		response.retmean = JsonUtil.getJsonString(auto, RESPONSE_RETMEAN);
		response.data = JsonUtil.getJsonString(auto, RESPONSE_DATA);
		response.obj = jsonString;
		if (response.retcode == 1) {
			response.uid = JsonUtil.getJsonString(auto, RESPONSE_UID);
		}
		return response;
	}

	/**
	 * @Title: parserVaildBindOpenid
	 * @Description: 解析第三方绑定状态数据
	 * @return VaildBindOpenidResponse 返回类型
	 * @param @param jsonString
	 * @param @return
	 * @param @throws JSONException 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private VaildBindOpenidResponse parserVaildBindOpenid(String jsonString) throws JSONException {
		VaildBindOpenidResponse response = new VaildBindOpenidResponse();
		JSONObject vaild = new JSONObject(jsonString);
		response.data = JsonUtil.getJsonString(vaild, RESPONSE_DATA);
		response.retcode = vaild.getInt(RESPONSE_RETCODE);
		response.retmean = JsonUtil.getJsonString(vaild, RESPONSE_RETMEAN);
		JSONObject dataObject = new JSONObject(response.data);
		if (dataObject != null) {
			response.token = JsonUtil.getJsonString(dataObject, RESPONSE_TOKEN);
			response.uid = JsonUtil.getJsonString(dataObject, RESPONSE_UID);
			response.success = dataObject.getInt(RESPONSE_SUCCESS);
		}
		return response;
	}

	/**
	 * 应用更新
	 * 
	 * @return UpdateAppResponse 返回类型
	 * @param @param jsonStr
	 * @param @return
	 * @param @throws JSONException 参数类型
	 * @author likai
	 */
	private UpdateAppResponse parseUpdateApp(String jsonStr) throws JSONException {
		UpdateAppResponse resp = new UpdateAppResponse();

		JSONObject json = new JSONObject(jsonStr);
		if (json.has("retcode")) {
			resp.retcode = json.optInt("retcode");
		}
		if (json.has("url")) {
			resp.url = json.optString("url");
		}
		if (json.has("vercode")) {
			resp.vercode = json.optInt("vercode");
		}
		if (json.has("vername")) {
			resp.vername = json.optString("vername");
		}
		if (json.has("content")) {
			resp.content = json.optString("content");
		}

		return resp;
	}
}
