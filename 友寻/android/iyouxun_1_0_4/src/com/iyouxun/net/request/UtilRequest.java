package com.iyouxun.net.request;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;

import com.iyouxun.R;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.Contact;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.file.FileStore;
import com.iyouxun.j_libs.managers.J_BaiduPushManager;
import com.iyouxun.j_libs.managers.J_FileManager;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.managers.J_NetManager.OnLoadingListener;
import com.iyouxun.j_libs.managers.J_PageManager;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.location.J_LocationManager;
import com.iyouxun.net.response.AutoLoginResponse;
import com.iyouxun.net.response.LoginResponse;
import com.iyouxun.net.response.UpdateAppResponse;
import com.iyouxun.service.UpdateService;
import com.iyouxun.ui.activity.BaseActivity;
import com.iyouxun.ui.activity.login.LoginActivity;
import com.iyouxun.utils.DLog;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SIMCardInfo;
import com.iyouxun.utils.SettingSharedPreUtil;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: UtilRequest
 * @Description: 处理可以复用的请求
 * @author donglizhi
 * @date 2015年3月5日 下午1:54:02
 * 
 */
public class UtilRequest {
	public static final String BROADCAST_UPDATE_SYSTEM_MESSAGE_COUNT = "com.iyouxun.message.update.system.message.count";
	public static final String FORM_SYS_TIME = "sys_time";
	public static final String FORM_SYS_CHANGE = "sys_change";
	public static final int GROUP_MEMBERS_LIMIT_COUNT = 100;
	/**
	 * @Fields FROM_ACTIVITY : 从哪个activity跳转过来
	 */
	public final static String FROM_ACTIVITY = "from";
	/**
	 * @Fields PLATFORM_DATA : 第三方平台登录传递的数据
	 */
	public final static String PLATFORM_DATA = "platformData";
	/**
	 * @Fields PLATFORM_USER_GENDER_MAN : 第三方平台性别男数据
	 */
	public final static String PLATFORM_USER_GENDER_MAN = "m";
	/**
	 * @Fields MOBILE_NUMBER : 手机号
	 */
	public final static String MOBILE_NUMBER = "moblie_number";
	/**
	 * @Fields SECURITY_CODE : 验证码
	 */
	public final static String SECURITY_CODE = "security_code";
	/**
	 * @Fields REGISTER_PASSWORD : 密码
	 */
	public final static String REGISTER_PASSWORD = "register_password";
	/**
	 * @Fields USER_MARRIAGE_STATUS : 用户的情感状态
	 */
	public final static String USER_MARRIAGE_STATUS = "user_marriage_status";
	/**
	 * @Fields FORM_MOBILE : 请求参数mobile
	 */
	public final static String FORM_MOBILE = "mobile";
	/**
	 * @Fields FORM_MOBILE_CODE : 请求参数mobile_code
	 */
	public final static String FORM_MOBILE_CODE = "mobile_code";
	public static final String FORM_OIDS = "oids";
	public static final String FORM_TITLE = "title";
	public static final String FORM_TID = "tid";
	public static final String TIMESTAMP_000 = "000";
	public static final String FORM_DUR = "dur";
	public final static String FORM_SEX = "sex";
	public final static String FORM_FROM = "from";
	public final static String FORM_FROM_NICK = "fromnick";
	public final static String FORM_PASSWORD = "password";
	public final static String FORM_MARRIAGE = "marriage";
	public final static String FORM_NICK = "nick";
	public final static String FORM_T_NICK = "t_nick";
	public final static String FORM_F_NICK = "f_nick";
	public final static String FORM_OPEN_ID = "openid";
	public final static String FORM_OPENID_TYPE = "openid_type";
	public final static String FORM_ACCESS_TOKEN = "access_token";
	public final static String FORM_TYPE = "type";
	public final static String FORM_TOKEN = "token";
	public final static String FORM_FORM = "form";
	public final static String FORM_NAME = "name";
	public final static String FORM_NEW = "new";
	public final static String FORM_CODE = "code";
	public final static String FORM_TO_UID = "touid";
	public final static String FORM_CONTENT = "content";
	public final static String FORM_OID = "oid";
	public final static String FORM_IID = "iid";
	public final static String FORM_PAGE_SIZE = "pageSize";
	public final static String FORM_PAGE = "page";
	public final static String FORM_AVATAR_SIZE = "avatarSize";
	public final static String FORM_PUSH_ID = "pushid";
	public final static String FORM_CHANNEL_ID = "channelid";
	public final static String FORM_DEVICE_TYPE = "devicetype";
	public final static String FORM_TIMESTAMP = "timestamp";
	public final static String FORM_NEWMSG = "newmsg";
	public final static String FORM_ONLINE = "online";
	public final static String FORM_AVATAR = "avatar";
	public final static String FORM_MSG = "msg";
	public final static String FORM_MSG_COUNT = "msgcount";
	public final static String FORM_MSG_TYPE = "msgtype";
	public final static String FORM_EXT = "ext";
	public final static String FORM_CTIME = "ctime";
	public final static String FORM_TIME = "time";
	public final static String FORM_TIMER = "timer";
	public final static String FORM_VOICE = "voice";
	public final static String FORM_PIC_150 = "pic150";
	public final static String FORM_PIC_200 = "pic200";
	public final static String FORM_PIC_0 = "pic0";
	public final static String FORM_PID = "pid";
	public final static String FORM_CHAT_MSG = "chatmsg";
	public final static String FORM_PUSH_TYPE = "pushtype";
	public final static String FORM_UID = "uid";
	public final static String FORM_T_UID = "t_uid";
	public final static String FORM_F_UID = "f_uid";
	public final static String FORM_GROUP_NAME = "group_name";
	public final static String FORM_GROUP_ID = "group_id";
	public final static String FORM_START = "start";
	public final static String FORM_NUMS = "nums";
	public final static String FORM_FUID = "fuid";
	public final static String FORM_FUID_ARR = "fuid_arr";
	public final static String FORM_AVATARS = "avatars";
	public final static String FORM_200 = "200";
	public final static String FORM_TRUENAME = "truename";
	public final static String FORM_MUTUALNUMS = "mutualnums";
	public final static String FORM_IS_MY_FRIENDS = "is_myfriends";
	public final static String FORM_IS_REGISTERED = "is_reg";
	public final static String HAS_SELET_DATA = "has_select_data";
	public static final String FORM_150 = "150";
	public static final String FORM_INTRO = "intro";
	public static final String FORM_PRIVILEGE = "privilege";
	public static final String FORM_STATUS = "status";
	public static final String FORM_SHOW = "show";
	public static final String FORM_HINT = "hint";
	public static final String FORM_MFRIEND_NUM = "mfriend_num";
	public static final String FORM_USER_LIST = "userlist";
	public static final String FORM_SEND_TIME = "sendtime";
	public static final String FORM_LOGO = "logo";
	public static final String FORM_NEW_COUNT = "newcount";
	public static final String FORM_AUTO_STATUS = "autostatus";
	public static final String FORM_CITY = "city";
	public static final String FORM_COUNT = "count";
	public static final String FORM_PRIVONCE = "privonce";
	public static final String FORM_PROVINCE = "province";
	public final static String FORM_CONDITION = "condition";
	public final static String FORM_LIVE_LOCATION = "live_location";
	public static final String FORM_HEIGHT = "height";
	public final static String FORM_STAR = "star";
	public final static String FORM_MIN_AGE = "min_age";
	public final static String FORM_MAX_AGE = "max_age";
	public final static String FORM_RELATION = "relation";
	public final static String FORM_FRIEND_NICK = "friendnick";
	public final static String FORM_CONDITION_STAR = "condition_star";
	public final static String FORM_CONDITION_TAGS = "condition_tags";
	public final static String FORM_APPLY_TIME = "apply_time";
	public final static String FORM_FRIEND_LISTS = "friendlists";
	public final static String FORM_SUB_TYPE = "subtype";
	public final static String FORM_JOIN_NICK = "join_nick";
	public final static String FORM_UNAME = "uname";
	public final static String FORM_RESULT = "result";
	public static final String FORM_JOIN_TIME = "jointime";
	public static final String FORM_OPERATE = "operate";
	public static final String FORM_SHOW_NICK = "shownick";
	public static final String FORM_SWITCH = "switch";
	/**
	 * @Fields GET_MY_FRIENDS_LIST_NUMS : 获得好友数据的请求数量
	 */
	public final static int GET_MY_FRIENDS_LIST_NUMS = 300;
	/**
	 * @Fields REQUEST_CODE_EMOTIONAL_SELECT : 页面跳转requestCode
	 */
	public final static int REQUEST_CODE_EMOTIONAL_SELECT = 10001;
	/**
	 * @Fields REQUEST_CODE_CLIP_PHOTO :裁剪照片页返回
	 */
	public final static int REQUEST_CODE_CLIP_PHOTO = 10002;
	/**
	 * @Fields BROADCAST_ACTION_UPDATE_MESSAGE_LIST : 刷新消息列表
	 */
	public final static String BROADCAST_ACTION_UPDATE_MESSAGE_LIST = "com.android.friendly.message.update";
	/**
	 * @Fields BROADCAST_ACTION_REFRESH_LOCATION : 刷新位置信息
	 */
	public final static String BROADCAST_ACTION_REFRESH_LOCATION = "com.android.friendly.find.refresh.location";
	/**
	 * @Fields BROADCAST_ACTION_EXIT_GROUP : 退出群组
	 */
	public final static String BROADCAST_ACTION_EXIT_GROUP = "com.android.friendly.message.exit.group";
	/**
	 * @Fields BROADCAST_ACTION_UPDATE_GROUP_COUNT : 更新我的群组数量
	 */
	public final static String BROADCAST_ACTION_UPDATE_GROUP_COUNT = "com.android.friendly.message.update.group.count";
	/**
	 * @Fields BROADCAST_ACTION_UPDATE_GROUP_NAME : 更新群组名称
	 */
	public final static String BROADCAST_ACTION_UPDATE_GROUP_NAME = "com.android.friendly.message.update.group.name";
	/**
	 * @Fields BROADCAST_ACTION_FINISH_READ_SYSTEM_MSG : 关闭已读系统消息页面
	 */
	public final static String BROADCAST_ACTION_FINISH_READ_SYSTEM_MSG = "com.android.friendly.message.finish.system.msg";
	/**
	 * @Fields BROADCAST_ACTION_UPDATE_SHOW_NICK : 是否展示昵称
	 */
	public final static String BROADCAST_ACTION_UPDATE_SHOW_NICK = "com.android.friendly.message.update.show.nick";

	/**
	 * @Title: doRegister
	 * @Description: 注册新用户
	 * @return void 返回类型
	 * @param @param formStr 注册参数
	 * @param @param imgPath 图片地址
	 * @param @param handler
	 * @param @param context
	 * @author donglizhi
	 * @throws
	 */
	public static void doRegister(String formStr, String imgPath, final Handler handler, final Context context) {
		if (Util.isBlankString(imgPath)) {
			new DoRegisterRequest(new OnDataBack() {

				@Override
				public void onResponse(Object result) {
					String reslutString = (String) result;
					parserDoRegisterResult(handler, context, reslutString);
				}

				@Override
				public void onError(HashMap<String, Object> errMap) {
					int error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
					DialogUtils.dismissDialog();
					if (error == 1) {
						showNetworkError(context);
					} else {
						ToastUtil.showToast(context, context.getString(R.string.register_fail));
					}
				}
			}).doRegister(formStr);
		} else {
			Map<String, String> map = new HashMap<String, String>();
			map.put(UtilRequest.FORM_FORM, formStr);
			DialogUtils.showProgressDialog(context, LoadingHandler.DEFALT_STR);
			J_NetManager.getInstance().uploadWithXUtils(NetConstans.DO_REGISTER_URL, map, imgPath, new OnLoadingListener() {

				@Override
				public void startLoading() {
				}

				@Override
				public void onfinishLoading(String result) {
					parserDoRegisterResult(handler, context, result);
				}

				@Override
				public void onLoading(long total, long current, boolean isUploading) {
				}

				@Override
				public void onError() {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, context.getString(R.string.register_fail));
				}
			});
		}
	}

	/**
	 * @Title: parserDoRegisterResult
	 * @Description: 解析注册返回的数据
	 * @return void 返回类型
	 * @param @param handler
	 * @param @param context
	 * @param @param result 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private static void parserDoRegisterResult(final Handler handler, final Context context, String result) {
		try {
			JSONObject resultJsonObject = new JSONObject(result);
			int retcode = resultJsonObject.optInt(JsonParser.RESPONSE_RETCODE);
			String retmean = JsonUtil.getJsonString(resultJsonObject, JsonParser.RESPONSE_RETMEAN);
			if (retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(retmean)
					&& resultJsonObject.has(JsonParser.RESPONSE_DATA)) {
				JSONObject data = JsonUtil.getJsonObject(resultJsonObject, JsonParser.RESPONSE_DATA);
				String token = JsonUtil.getJsonString(data, JsonParser.RESPONSE_TOKEN);
				String uid = JsonUtil.getJsonString(data, JsonParser.RESPONSE_UID);
				SharedPreUtil.saveLoginToken(token);
				Message msg = handler.obtainMessage(NetTaskIDs.TASKID_DO_REGISTER, result);
				handler.sendMessage(msg);
				// 新好友加入
				// friendsSendMsgToRegFriends(uid);
			} else {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, context.getString(R.string.register_fail));
			}
		} catch (JSONException e) {
			DialogUtils.dismissDialog();
			ToastUtil.showToast(context, context.getString(R.string.register_fail));
			e.printStackTrace();
		}
	}

	/**
	 * @Title: getSecurityCode
	 * @Description: 获取验证码
	 * @return void 返回类型
	 * @param @param handler
	 * @param @param formStr 请求数据 手机号
	 * @author donglizhi
	 * @throws
	 */
	public static void getSecurityCode(final Handler handler, String formStr, final Context context) {
		new GetSecurityCodeRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				String code = "";
				try {
					JSONObject object = new JSONObject(response.data);
					code = object.optString("check_code");
				} catch (JSONException e) {
					e.printStackTrace();
				}
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_SECURITY_CODE, code));
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				showNetworkError(context);
				DialogUtils.dismissDialog();
			}
		}).getCode(formStr);
	};

	/**
	 * @Title: newpasswordGetSecurityCode
	 * @Description: 重置密码获取验证码
	 * @return void 返回类型
	 * @param @param handler
	 * @param @param mobile 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void newpasswordGetSecurityCode(final Handler handler, String mobile, final Context context) {
		new NewPasswordGetSecurityCodeRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				handler.sendEmptyMessage(NetTaskIDs.TASKID_NEW_PASSWORD_GET_SECURITY_CODE);
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				int error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
				if (error == 1) {
					showNetworkError(context);
				} else {
					ToastUtil.showToast(context, context.getString(R.string.get_code_fail));
				}
				DialogUtils.dismissDialog();
			}
		}).getCode(mobile);
	}

	/**
	 * @Title: valMobileCode
	 * @Description: 验证验证码是否正确
	 * @return void 返回类型
	 * @param @param formStr
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void valMobileCode(String formStr, final Handler handler, final Context context) {
		new VaildMobileCodeRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && response.data.equals("1")) {
					Message msg = handler.obtainMessage(NetTaskIDs.TASKID_VAILD_MOBILE_CODE, result);
					handler.sendMessage(msg);
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, context.getString(R.string.wrong_security_code));
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				int error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
				if (error == 1) {
					showNetworkError(context);
				} else {
					ToastUtil.showToast(context, context.getString(R.string.wrong_security_code));
				}
				DialogUtils.dismissDialog();
			}
		}).vaildMobileCode(formStr);
	}

	/**
	 * @Title: setNewPassword
	 * @Description: 修改密码
	 * @return void 返回类型
	 * @param @param mobile 手机号
	 * @param @param password 密码
	 * @param @param securityCode 验证码
	 * @param @param context
	 * @param @param handler 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void setNewPassword(String mobile, String password, String securityCode, final Context context,
			final Handler handler) {
		new SetNewPasswordRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				DialogUtils.dismissDialog();
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SET_NEW_PASSWORD, result));
				} else if (response.retcode == -3) {
					ToastUtil.showToast(context, "验证码输入错误");
				} else if (response.retcode == -2) {
					ToastUtil.showToast(context, "手机尚未注册");
				} else {
					ToastUtil.showToast(context, context.getString(R.string.modify_password_fail));
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				int error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
				if (error == 1) {
					showNetworkError(context);
				} else {
					ToastUtil.showToast(context, context.getString(R.string.modify_password_fail));
				}
				DialogUtils.dismissDialog();
			}
		}).execute(mobile, securityCode, password);
	}

	/**
	 * @Title: vaildMobile
	 * @Description: 验证手机号是否存在
	 * @return void 返回类型
	 * @param @param context
	 * @param @param handler
	 * @param @param vaild 0确认不存在 1确认已存在
	 * @param @param formStr 请求参数
	 * @author donglizhi
	 * @throws
	 */
	public static void vaildMobile(final Context context, final Handler handler, String formStr, final int vaild) {
		new VaildMobileRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == -1) {// 手机号已经注册了
					if (vaild == 1) {
						DialogUtils.dismissDialog();
						ToastUtil.showToast(context, context.getResources().getString(R.string.has_register_do_login));
						handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_VAILD_MOBILE_EXISTS, response));
					} else {
						Message msg = handler.obtainMessage(NetTaskIDs.TASKID_VAILD_MOBILE_EXISTS, response);
						handler.sendMessage(msg);
					}
				} else if (response.retcode == -2) {// 手机号不合法
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, context.getResources().getString(R.string.please_input_true_mobile_number));
				} else {
					if (vaild == 0) {
						DialogUtils.dismissDialog();
						ToastUtil.showToast(context, context.getResources().getString(R.string.please_register_first));
					} else {
						Message msg = handler.obtainMessage(NetTaskIDs.TASKID_VAILD_MOBILE_EXISTS, response);
						handler.sendMessage(msg);
					}
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				showNetworkError(context);
				DialogUtils.dismissDialog();
			}
		}).vaildMobile(formStr);
	}

	/**
	 * 登录
	 * 
	 * @return void 返回类型
	 * @param $abnormal int 0-正常登陆，1-异常登陆
	 * @param 参数类型
	 * @author likai
	 */
	public static void doAutoLogin(String token, int abnormal, final Context mContext, final Handler handler) {
		AutoLoginRequest request = new AutoLoginRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				AutoLoginResponse response = (AutoLoginResponse) result;
				if (response.retcode == 1 && !Util.isBlankString(response.uid)) {
					initData(handler, mContext, response.uid);
				} else {
					DialogUtils.dismissDialog();
					// 自动登录失败跳转到登录页面
					if (!LoginActivity.class.getName().equals(mContext.getClass().getName())) {
						Intent intent = new Intent(mContext, LoginActivity.class);
						mContext.startActivity(intent);
						((BaseActivity) mContext).finish();
					}
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				DialogUtils.dismissDialog();
				int error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
				if (error == 1) {
					showNetworkError(mContext);
				}
				if (!LoginActivity.class.getName().equals(mContext.getClass().getName())) {
					// 自动登录失败跳转到登录页面
					Intent intent = new Intent(mContext, LoginActivity.class);
					mContext.startActivity(intent);
					((BaseActivity) mContext).finish();
				}
			}
		});

		request.login(token, abnormal);
	}

	/**
	 * @Title: vaildBindOpenid
	 * @Description: 检查第三方平台绑定状态
	 * @return void 返回类型
	 * @param @param openid
	 * @param @param type
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void vaildBindOpenid(String openid, int type, final Handler handler, final Context context) {
		new VaildBindOpenidRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_VAILD_BIND_OPENID, result));
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				int error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
				if (error == 1) {
					showNetworkError(context);
				} else {
					ToastUtil.showToast(context, "获取绑定状态失败，请再次尝试！");
				}
			}
		}).vaild(openid, type + "");
	}

	/**
	 * @Title: loginSetPush
	 * @Description: 登陆之后绑定推送设置退出登录的情况下使用
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private static void loginSetPush() {
		String channelId = SharedPreUtil.getBaiduChannelID();
		String userid = SharedPreUtil.getBaiduUserID();
		if (!Util.isBlankString(channelId) && !Util.isBlankString(userid)) {
			setPushId(userid, channelId);
		}
	}

	/**
	 * @Title: doLogin
	 * @Description: 登录接口
	 * @return void 返回类型
	 * @param @param userName 用户名
	 * @param @param password 密码
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void doLogin(String userName, String password, final Handler handler, final Context context) {
		new LoginRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				LoginResponse response = (LoginResponse) result;
				if (response.retcode == 1 && response.retmean.equals(JsonParser.CMI_AJAX_RET_CODE_SUCC)) {
					if (response.status == -1) {
						DialogUtils.dismissDialog();
						ToastUtil.showToast(context, "密码错误，请重新输入");
					} else if (response.status == -2) {
						DialogUtils.dismissDialog();
						ToastUtil.showToast(context, "黑名单用户，不能登录");
					} else if (response.status == -3) {
						DialogUtils.dismissDialog();
						ToastUtil.showToast(context, "账号不存在，请检查或注册新账号");
					} else {
						String uid = response.userInfo.uid + "";
						SharedPreUtil.saveLoginToken(response.token);
						initData(handler, context, uid);
					}
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				DialogUtils.dismissDialog();
				showNetworkError(context);
			}
		}).execute(userName, password);

	}

	/**
	 * @Title: getUserInfo
	 * @Description: 获得用户数据
	 * @return void 返回类型
	 * @param @param context
	 * @param @param handler
	 * @param @param uid 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void getUserInfo(final Context context, final Handler handler, String uid) {
		new GetUserInfoRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				DialogUtils.dismissDialog();
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_USER_INFO, result));
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				int error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
				DialogUtils.dismissDialog();
				if (error == 1) {
					showNetworkError(context);
				} else {
					ToastUtil.showToast(context, "登录失败");
				}
			}
		}).execute(uid);
	}

	/**
	 * 同步手机通讯录
	 * 
	 * @Title: uploadUserContacts
	 * @return void 返回类型
	 * @param @param context
	 * @param @param handler 参数类型
	 * @author likai
	 * @throws
	 */
	public static void uploadUserContacts(final Context context, final Handler handler) {
		SIMCardInfo simCardInfo = new SIMCardInfo(context);
		ArrayList<Contact> contacts = simCardInfo.getContact();
		if (contacts.size() > 0) {
			JSONObject contactObject = new JSONObject();
			for (Contact contact : contacts) {
				if (Util.isMobileNumber(contact.getNumber())) {// 上传联系人
					try {
						contactObject.put(contact.getNumber(), contact.getName());
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			}
			if (contactObject.length() > 0) {
				FileStore fs = J_FileManager.getInstance().getFileStore();
				try {
					if (fs.storeFileUTF8(contactObject.toString(), "userContacts")) {
						String path = fs.getFileSdcardAndRamPath("userContacts");
						Map<String, String> map = new HashMap<String, String>();
						map.put("type", "4");
						J_NetManager.getInstance().uploadWithXUtils(NetConstans.UPLOAD_CONTACT_URL, map, path,
								new OnLoadingListener() {

									@Override
									public void startLoading() {
									}

									@Override
									public void onfinishLoading(String result) {
										DialogUtils.dismissDialog();
										try {
											DLog.d("J_NET", "response--upload--->>>" + result);
											JSONObject jsonObject = new JSONObject(result);
											String data = JsonUtil.getJsonString(jsonObject, JsonParser.RESPONSE_DATA);
											int retcode = jsonObject.optInt(JsonParser.RESPONSE_RETCODE);
											String retmean = JsonUtil.getJsonString(jsonObject, JsonParser.RESPONSE_RETMEAN);
											if (retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(retmean)
													&& "1".equals(data)) {
												J_Cache.sLoginUser.callno_upload = 1;
												SharedPreUtil.saveLoginInfo(J_Cache.sLoginUser);
												handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_UPLOAD_USER_CONTACTS,
														result));
											} else {
												ToastUtil.showToast(context, "上传失败");
											}
										} catch (JSONException e) {
											e.printStackTrace();
											ToastUtil.showToast(context, "上传失败");
										}
									}

									@Override
									public void onLoading(long total, long current, boolean isUploading) {
									}

									@Override
									public void onError() {
										DialogUtils.dismissDialog();
										UtilRequest.showNetworkError(context);
									}
								});
					}

				} catch (IOException e) {
					handler.post(new Runnable() {

						@Override
						public void run() {
							ToastUtil.showToast(context, "写文件异常");
							DialogUtils.dismissDialog();
						}
					});
					e.printStackTrace();
				}
			}
		} else {
			DialogUtils.dismissDialog();
			ToastUtil.showToast(context, "没有联系人");
			handler.sendEmptyMessage(0x404);
		}
	}

	/**
	 * 更新隐私设置
	 * 
	 * @Title: updatePrivacyInfo
	 * @return void 返回类型
	 * @param @param key
	 * @param @param value 参数类型
	 * @author likai
	 * @throws
	 */
	public static void updatePrivacyInfo(final String key, final int value, final Handler mhandler) {
		new UpdatePrivacyRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					// 更新成功
					SettingSharedPreUtil.saveShareIntConfigInfo(key, value);
					// 特殊情况下，需要该回调状态
					if (mhandler != null) {
						mhandler.sendMessage(mhandler.obtainMessage(NetTaskIDs.TASKID_UPDATE_PRIVACY, result));
					}
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				int Error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
			}
		}).execute(key, value);
	}

	/**
	 * @Title: sendTextMsg
	 * @Description: 发送一条文本消息
	 * @return void 返回类型
	 * @param @param form 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void sendTextMsg(final Context context, final Handler handler, String form, long chat_table_id) {
		new SendTextMsgRequet(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SEND_TEXT_MSG, result));
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				int error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
				long id = (Long) errMap.get(OnDataBack.KEY_CHAT_TABLE_ID);
				if (error == 1) {
					showNetworkError(context);
				}
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SEND_TEXT_MSG, error, error, id));
			}

		}).send(form, chat_table_id);
	}

	/**
	 * 添加新标签
	 * 
	 * @Title: addNewTag
	 * @return void 返回类型
	 * @param @param to_uid
	 * @param @param tag_name
	 * @param @param mHandler 参数类型
	 * @author likai
	 * @throws
	 */
	public static void addNewTag(final Context mContext, String to_uid, String tag_name, final Handler mHandler) {
		new AddTagRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_ADD_TAG, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				showNetworkError(mContext);
			}
		}).execute(to_uid, tag_name);
	}

	/**
	 * 获取标签列表
	 * 
	 * @Title: getTagsList
	 * @return void 返回类型
	 * @param @param uid 参数类型
	 * @author likai
	 * @throws
	 */
	public static void getTagsList(final Context mContext, String uid, final Handler mHandler) {
		new GetTagListRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_TAG_LIST, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				showNetworkError(mContext);
			}
		}).execute(uid);
	}

	/**
	 * 删除标签
	 * 
	 * @Title: deleteTag
	 * @return void 返回类型
	 * @param @param tid
	 * @param @param mHandler 参数类型
	 * @author likai
	 * @throws
	 */
	public static void deleteTag(final Context mContext, String tids, final Handler mHandler) {
		new DelTagRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_DEL_TAG, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				ToastUtil.showToast(mContext, "删除标签失败");
			}
		}).execute(tids);
	}

	/**
	 * 点击标签
	 * 
	 * @Title: clickTag
	 * @return void 返回类型
	 * @param @param mContext
	 * @param @param to_uid
	 * @param @param tid
	 * @param @param mHandler 参数类型
	 * @author likai
	 * @throws
	 */
	public static void clickTag(final Context mContext, String to_uid, String tid, final Handler mHandler) {
		new TagClickRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_TAG_CLICK, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				ToastUtil.showToast(mContext, "操作出错，请重试");
			}
		}).execute(to_uid, tid);
	}

	/**
	 * @Title: get_history_user_chat_list
	 * @Description: 获得离线消息数据
	 * @return void 返回类型
	 * @param @param context
	 * @param @param handler
	 * @param @param oid 对方的uid
	 * @param @param iid 消息id
	 * @param @param pageSize 数据条数
	 * @author donglizhi
	 * @throws
	 */
	public static void get_history_user_chat_list(final Context context, final Handler handler, String oid, String iid,
			String pageSize) {
		new GetHistoryUserChatListRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_HISTORY_USER_CHAT_LIST, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				int error = (Integer) errorMap.get(OnDataBack.KEY_ERROR);
				if (error == 1) {
					showNetworkError(context);
				}
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_HISTORY_USER_CHAT_LIST, error, error));
			}
		}).get(oid, iid, pageSize);
	}

	/**
	 * @Title: setPushId
	 * @Description: 绑定百度推送的id
	 * @return void 返回类型
	 * @param @param pushid
	 * @param @param channelid 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void setPushId(String pushid, String channelid) {
		new SetPushIdRequset(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).set(pushid, channelid);
	}

	/**
	 * 更新备注
	 * 
	 * @Title: update_user_mark
	 * @return void 返回类型
	 * @param @param uid
	 * @param @param mark 参数类型
	 * @author likai
	 * @throws
	 */
	public static void update_user_mark(final Context mContext, String uid, String mark, final Handler mHandler) {
		new UpdateUserMarkRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_UPDATE_USER_MARK, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).execute(uid, mark);
	}

	/**
	 * @Title: get_chat_user_list
	 * @Description: 获得消息用户列表
	 * @return void 返回类型
	 * @param @param handler
	 * @param @param timestamp 最新消息联系人的时间戳
	 * @author donglizhi
	 * @throws
	 */
	public static void get_chat_user_list(final Handler handler, String timestamp, final Context context) {
		final String pageSize = "20";
		new GetChatUserListRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_CHAT_USER_LIST, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				int error = (Integer) errorMap.get(OnDataBack.KEY_ERROR);
				if (error == 1) {
					showNetworkError(context);
				}
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_CHAT_USER_LIST, error, error));
			}
		}).get(pageSize, timestamp);
	}

	/**
	 * @param msgId
	 * @Title: sendPicMsg
	 * @Description: 发送图片消息
	 * @return void 返回类型
	 * @param @param path 图片路径
	 * @param @param handler
	 * @param @param touid 发送人id
	 * @param @param lcMsgId 本地消息id
	 * @author donglizhi
	 * @throws
	 */
	public static void sendPicMsg(String path, final Handler handler, String touid, final int lcMsgId) {
		Map<String, String> params = new HashMap<String, String>();
		params.put(FORM_TO_UID, touid);
		J_NetManager.getInstance().uploadWithXUtils(NetConstans.SEND_PIC_MSG_URL, params, path, new OnLoadingListener() {

			@Override
			public void startLoading() {
			}

			@Override
			public void onfinishLoading(String result) {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SEND_PIC_MSG, lcMsgId, lcMsgId, result));
			}

			@Override
			public void onLoading(long total, long current, boolean isUploading) {
				if (isUploading) {
					double percent = current * 100 / (double) total;
					int percentage = (int) percent;
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.UPDATE_IMAGE_MSG_UPLOAD_PERCENT, lcMsgId, percentage));
				}
			}

			@Override
			public void onError() {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SEND_PIC_MSG, lcMsgId, lcMsgId));
			}
		});
	}

	/**
	 * @Title: sendVoiceMsg
	 * @Description: 发送语音消息
	 * @return void 返回类型
	 * @param @param filePath
	 * @param @param touid
	 * @param @param handler
	 * @param @param dur 参数类型
	 * @param @param lcMsgId 本地消息id
	 * @author donglizhi
	 * @throws
	 */
	public static void sendVoiceMsg(String filePath, String touid, final Handler handler, String dur, final int lcMsgId) {
		Map<String, String> params = new HashMap<String, String>();
		params.put(FORM_TO_UID, touid);
		params.put(FORM_DUR, dur);
		J_NetManager.getInstance().uploadWithXUtils(NetConstans.SEND_VOICE_MSG_URL, params, filePath, new OnLoadingListener() {

			@Override
			public void startLoading() {
			}

			@Override
			public void onfinishLoading(String result) {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SEND_VOICE_MSG, lcMsgId, lcMsgId, result));
			}

			@Override
			public void onLoading(long total, long current, boolean isUploading) {
			}

			@Override
			public void onError() {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SEND_VOICE_MSG, lcMsgId, lcMsgId));
			}
		});
	}

	/**
	 * @Title: getFriendsGroupList
	 * @Description: 获得好友分组列表
	 * @return void 返回类型
	 * @param @param uid 用户id
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void getFriendsGroupList(String uid, final Handler handler, final Context context) {
		DialogUtils.showProgressDialog(context, LoadingHandler.DEFALT_STR);
		new FriendsGetGroupListRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				DialogUtils.dismissDialog();
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					SharedPreUtil.setFriendsGroupData(response.data);
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_GROUP_LIST, response.data));
				} else {
					ToastUtil.showToast(context, "请求失败");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				int error = (Integer) errorMap.get(OnDataBack.KEY_ERROR);
				if (error == 1) {
					showNetworkError(context);
				} else {
					ToastUtil.showToast(context, "请求失败");
				}
			}
		}).get(uid);
	}

	/**
	 * @Title: getFriendsList
	 * @Description: 获得一度好友
	 * @return void 返回类型
	 * @param @param uid 用户id
	 * @param @param handler
	 * @param @param context
	 * @param @param start 起始位置
	 * @param @param nums 请求数量
	 * @author donglizhi
	 * @throws
	 */
	public static void getFriendsList(String uid, final Handler handler, Context context, int start, int nums) {
		new FriendsGetMyFriendsAllRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					SharedPreUtil.setMyFriendsData(response.data);
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS_ALL, response.data));
				} else {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS_ALL, ""));
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS_ALL, ""));
			}
		}).get(uid, start, nums, 2, 0);
	}

	/**
	 * @Title: getFriendsListSearch
	 * 
	 * @Description: 获得一度好友(带有搜索功能)
	 * @return void 返回类型
	 * @param @param uid 用户id
	 * @param @param handler
	 * @param @param context
	 * @param @param start 起始位置
	 * @param @param nums 请求数量
	 * @author likai
	 * @throws
	 */
	public static void getFriendsListSearch(String uid, final Handler handler, Context context, int start, int nums, int sex,
			int marriage) {
		new FriendsGetMyFriendsAllRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS_ALL, response.data));
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).get(uid, start, nums, sex, marriage);
	}

	/**
	 * @Title: friendsCreateGroup
	 * @Description: 创建分组
	 * @return void 返回类型
	 * @param @param uid 用户id
	 * @param @param groupName 分组名
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void friendsCreateGroup(String uid, String groupName, final Handler handler, final Context context) {
		new FriendsCreateGroupRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					try {
						JSONObject dataObject = new JSONObject(response.data);
						String groupId = JsonUtil.getJsonString(dataObject, FORM_GROUP_ID);
						handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_CREATE_GROUP, groupId));
					} catch (JSONException e) {
						e.printStackTrace();
					}
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "操作失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				int error = (Integer) errorMap.get(OnDataBack.KEY_ERROR);
				if (error == 1) {
					showNetworkError(context);
				} else {
					ToastUtil.showToast(context, "操作失败，请再次尝试！");
				}
				DialogUtils.dismissDialog();
			}
		}).create(uid, groupName);
	}

	/**
	 * @Title: delFriendsGroup
	 * @Description: 删除用户分组
	 * @return void 返回类型
	 * @param @param uid 用户id
	 * @param @param groupId 分组id
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void delFriendsGroup(String uid, String groupId, final Handler handler, final Context context,
			final boolean showToast) {
		new FriendsDelGroupRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				DialogUtils.dismissDialog();
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_DEL_GROUP, response.data));
				} else {
					if (showToast) {
						ToastUtil.showToast(context, "删除分组失败，请再次尝试！");
					}
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				if (showToast) {
					int error = (Integer) errorMap.get(OnDataBack.KEY_ERROR);
					if (error == 1) {
						showNetworkError(context);
					} else {
						ToastUtil.showToast(context, "删除分组失败，请再次尝试！");
					}
				}
			}
		}).del(uid, groupId);
	}

	/**
	 * @Title: addFriendsGroupMembers
	 * @Description: 添加分组成员
	 * @return void 返回类型
	 * @param @param uid 用户uid
	 * @param @param fuid
	 * @param @param groupId 分组id
	 * @author donglizhi
	 * @throws
	 */
	public static void addFriendsGroupMembers(String uid, String fuid, String groupId, final Handler handler,
			final Context context) {
		new FriendsAddGroupMemebersRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_ADD_GROUP_MEMBERS, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "分组成员添加失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "分组成员添加失败，请再次尝试！");
			}
		}).add(uid, fuid, groupId);
	}

	/**
	 * 获取消息提醒列表
	 * 
	 * @Title: getSystemList
	 * @return void 返回类型
	 * @param type sys 系统消息 group所有群消息 crgroup 建群消息 addgroup 申请加入群消息 qtgroup
	 *            退群消息 photo 照片赞 reply 照片评论 reject 拒绝好友加入群 accept 接受好友加入群 del
	 *            群主踢人 invite 所有人可以邀请好友加入(一度) like 动态被赞 rebroadcast 动态被转播
	 *            comment 动态被评论 reply 被回复评论
	 * @param page 页码 @default 1 @min 1
	 * @param pageSize - 页码 @default 10 @min 1 @max 20
	 * @param status - 消息状态 0未读 1已读 -1全部 100全部含已删除
	 * @param autostatus - 自动设置已读 0/1 @default 1
	 * @param mHandler 参数类型
	 * @author likai
	 * @throws
	 */
	public static void getSystemList(String type, int page, int pageSize, int avatarSize, int status, int autostatus,
			final Handler mHandler, final Context context) {
		new ListSystemRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_LIST_SYSTEM, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				showNetworkError(context);
				DialogUtils.dismissDialog();
			}
		}).execute(type, page, pageSize, avatarSize, status, autostatus);
	}

	/**
	 * 消息全部置为已读状态
	 * 
	 * @Title: setOnreadAll
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public static void setOnreadAll(String type, final Handler mHandler) {
		new SetOnreadAllsysmsgRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_SET_ONREAD_ALLSYSMSG, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				mHandler.sendEmptyMessage(NetTaskIDs.TASKID_SET_ONREAD_ALLSYSMSG);
			}
		}).execute(type);
	}

	/**
	 * 更新用户坐标信息
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public static void updateLnglat() {
		new UpdateLnglatRequest(null).execute();
	}

	/**
	 * 删除黑名单联系人
	 * 
	 * @return void 返回类型
	 * @param fid String：要删除人的uid
	 * @author likai
	 * @throws
	 */
	public static void delBlackListUser(long fid, final Handler mHandler) {
		new DelBlacklistRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_DEL_BLACKLIST, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).execute(fid);
	}

	/**
	 * 
	 * @Title: getBlackList
	 * @return void 返回类型
	 * @param @param page
	 * @param @param pageSize
	 * @param @param mHandler 参数类型
	 * @author likai
	 * @throws
	 */
	public static void getBlackList(int page, int pageSize, final Context mContext, final Handler mHandler) {
		new GetBlackListRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_GET_BLACKLIST_LIST, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				int error = (Integer) errorMap.get(OnDataBack.KEY_ERROR);
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_GET_BLACKLIST_LIST, error, error));
				DialogUtils.dismissDialog();
				showNetworkError(mContext);
			}
		}).execute(page, pageSize);
	}

	/**
	 * @Title: getFriendsNums
	 * @Description: 获取好友总数
	 * @return void 返回类型
	 * @param @param uid 用户id
	 * @param @param friendsType 1:获取1度;2:获取2度
	 * @param @param isRegistered 是否已注册 1：已注册(默认1);0：未注册
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void getFriendsNums(String uid, final int friendsType, int isRegistered, final Handler handler,
			final Context context) {
		new FriendsGetFriendsNumsRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					int friendsNums = Util.getInteger(response.data);
					SharedPreUtil.setFriendsNum(friendsType, friendsNums);
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_NUMS, response.data));
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				// int error = (Integer) errorMap.get(OnDataBack.KEY_ERROR);
				showNetworkError(context);
				DialogUtils.dismissDialog();
				// handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_NUMS,
				// error, error));
			}
		}).get(uid, friendsType, isRegistered);
	}

	/**
	 * 获取一度、二度好友的总数量
	 * 
	 * @return void 返回类型
	 * @param uid
	 * @param handler
	 * @param friendsType type 1一度2二度3全部
	 * @param context 参数类型
	 * @author likai
	 * @throws
	 */
	public static void getFriendsAllNums(long uid, final int friendsType, final Handler handler, Context context) {
		new FriendsGetFriendsNumsAllRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					int friendsNums = Util.getInteger(response.data);
					SharedPreUtil.setFriendsNum(friendsType, friendsNums);
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_FRIENDSNUMS_ALL, response.data));
				}

			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				int error = (Integer) errorMap.get(OnDataBack.KEY_ERROR);
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_FRIENDSNUMS_ALL, error, error));
			}
		}).execute(uid);
	}

	/**
	 * 获取两人共同好友数量
	 * 
	 * @return void 返回类型
	 * @param @param uid
	 * @param @param fuid
	 * @param @param mHandler 参数类型
	 * @author likai
	 * @throws
	 */
	public static void getMutualFriendsNums(String uid, String fuid, final Handler mHandler) {
		new FriendsGetMutualFriendsNumRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_MUTUALNUMS, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).execute(uid, fuid);
	}

	/**
	 * @Title: getFriendsGroupMembers
	 * @Description: 获得分组成员数据
	 * @return void 返回类型
	 * @param @param uid 用户id
	 * @param @param groupId 分组id
	 * @param @param start 起始位置
	 * @param @param nums 查询数量
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void getFriendsGroupMembers(String uid, String groupId, int start, int nums, final Handler handler,
			final Context context) {
		new FriendsGetGroupMembersRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_GROUP_MEMBERS, response.data));
				} else {
					handler.sendEmptyMessage(NetTaskIDs.TASKID_FRIENDS_GET_GROUP_MEMBERS);
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				handler.sendEmptyMessage(NetTaskIDs.TASKID_FRIENDS_GET_GROUP_MEMBERS);
			}
		}).get(uid, groupId, start, nums);
	}

	/**
	 * @Title: getFriends
	 * 
	 * @return void 返回类型
	 * @param @param uid 用户id
	 * @param @param isRegistered 是否已注册 1：已注册(默认1);0：未注册
	 * @param @param start 起始位置
	 * @param @param nums 请求数量
	 * @author donglizhi
	 * @throws
	 */
	public static void getFriends(String uid, int isRegistered, int start, int nums, final Handler handler, Context context) {
		new FriendsGetMyFriendsRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS, response.data));
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).get(uid, isRegistered, start, nums);

	}

	/**
	 * 获取所有的一度、二度好友
	 * 
	 * @return void 返回类型
	 * @param @param uid
	 * @param @param start
	 * @param @param nums
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author likai
	 * @throws
	 */
	public static void getFriendsAll(long uid, int start, int nums, final Handler handler, Context context) {
		new FriendsGetFriendsAllRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					SharedPreUtil.setMyFriendsAllData(response.data);
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_ALL, response.data));
				} else {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_ALL, ""));
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_ALL, ""));

			}
		}).execute(uid, start, nums);
	}

	/**
	 * @Title: removeGroupMembers
	 * @Description: 删除分组成员
	 * @return void 返回类型
	 * @param @param uid 用户id
	 * @param @param fuid 成员id
	 * @param @param groupId 分组id
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void removeGroupMembers(String uid, String fuid, String groupId, final Handler handler, final Context context) {
		new FriendsRemoveGroupMembersRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_REMOVE_GROUP_MEMBERS, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "移除分组成员失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "移除分组成员失败，请再次尝试！");
			}
		}).remove(uid, fuid, groupId);
	}

	/**
	 * @Title: modFriendsGroup
	 * @Description: 修改分组名称
	 * @return void 返回类型
	 * @param @param uid 用户id
	 * @param @param groupId 分组id
	 * @param @param groupName 分组名称
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void modFriendsGroup(String uid, String groupId, String groupName, final Handler handler, final Context context) {
		new FriendsModGroupRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_MOD_GROUP, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "未能保存分组信息，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "未能保存分组信息，请再次尝试！");
			}
		}).mod(uid, groupId, groupName);
	}

	/**
	 * @Title: uploadSinaFriends
	 * @Description: 上传新浪好友
	 * @return void 返回类型
	 * @param @param data
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void uploadSinaFriends(String data, Context context) {
		if (data.length() > 0) {
			FileStore fs = J_FileManager.getInstance().getFileStore();
			try {
				if (fs.storeFileUTF8(data, "sinaFriends")) {
					String path = fs.getFileSdcardAndRamPath("sinaFriends");
					Map<String, String> map = new HashMap<String, String>();
					map.put("type", "2");
					J_NetManager.getInstance().uploadWithXUtils(NetConstans.UPLOAD_CONTACT_URL, map, path,
							new OnLoadingListener() {

								@Override
								public void startLoading() {
								}

								@Override
								public void onfinishLoading(String result) {
								}

								@Override
								public void onLoading(long total, long current, boolean isUploading) {
								}

								@Override
								public void onError() {
									DialogUtils.dismissDialog();
								}
							});
				}

			} catch (IOException e) {
			}
		}
	}

	/**
	 * 获取某个用户的动态列表
	 * 
	 * @Title: getOneUserDynamicList
	 * @return void 返回类型
	 * @param @param uid
	 * @param @param dy_id
	 * @param @param num 参数类型
	 * @author likai
	 * @throws
	 */
	public static void getOneUserDynamicList(long uid, int dy_id, int num, final Handler mHandler) {
		new GetOneUserDynamicListRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_GET_ONE_USER_DYNAMIC_LIST, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).execute(uid, dy_id, num);
	}

	/**
	 * 获取用户的群组列表
	 * 
	 * @Title: getGroupList
	 * @return void 返回类型
	 * @param @param uid 参数类型
	 * @author likai
	 * @throws
	 */
	public static void getGroupList(String uid, final Handler mHandler, final Context mContext) {
		new GroupListRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_GROUP_LIST, response.data));
				} else {
					ToastUtil.showToast(mContext, response.retmean);
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				showNetworkError(mContext);
			}
		}).execute(uid);
	}

	/**
	 * 申请加入一个群组
	 * 
	 * @return void 返回类型
	 * @param @param group_id
	 * @param @param touid
	 * @param @param mHandler 参数类型
	 * @author likai
	 * @throws
	 */
	public static void addGroup(final int group_id, String touid, final Handler mHandler, final Context mContext) {
		new AddGroupRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					Message msg = mHandler.obtainMessage();
					msg.what = NetTaskIDs.TASKID_ADD_GROUP;
					msg.obj = response.data;
					msg.arg1 = group_id;
					mHandler.sendMessage(msg);
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(mContext, "申请加入失败，请再次尝试");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				showNetworkError(mContext);
			}
		}).execute(group_id, touid);
	}

	/**
	 * 获取某一群组的详细信息
	 * 
	 * @return void 返回类型
	 * @param @param group_id 参数类型
	 * @author likai
	 * @throws
	 */
	public static void getGroup(int group_id, final Handler mHandler) {
		new GetGroupRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_GET_GROUP, response.data));
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).execute(group_id);
	}

	/**
	 * 获取群组内成员列表
	 * 
	 * @Title: getGroupUserList
	 * @return void 返回类型
	 * @param @param group_id
	 * @param @param mHandler 参数类型
	 * @author likai
	 * @throws
	 */
	public static void getGroupUserList(int group_id, final Handler mHandler, final Context context) {
		new GroupUserListRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_GROUP_USER_LIST, response.data));
				} else {
					// 申请发送失败
					DialogUtils.dismissDialog();
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				showNetworkError(context);
			}
		}).execute(group_id);
	}

	/**
	 * 添加黑名单用户
	 * 
	 * @return void 返回类型
	 * @param @param uid
	 * @param @param fuid 参数类型
	 * @author likai
	 * @throws
	 */
	public static void addBlack(String uid, String fuid, final Handler mHandler) {
		new AddBlackRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_ADD_BLACK, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).execute(uid, fuid);
	}

	/**
	 * 获取共同好友
	 * 
	 * @Title: getMutualFriends
	 * @return void 返回类型
	 * @param @param uid
	 * @param @param fuid
	 * @param @param start
	 * @param @param num 参数类型
	 * @author likai
	 * @throws
	 */
	public static void getMutualFriends(String uid, String fuid, int start, int num, int sex, int marriage, final Handler mHandler) {
		new FriendsGetMutualFriendsRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_MUTUALFRIENDS, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).execute(uid, fuid, start, num, sex, marriage);
	}

	/**
	 * 获取推荐好友列表
	 * 
	 * @Title: getRecommendNewUsers
	 * @return void 返回类型
	 * @param @param page
	 * @param @param pagesize 参数类型
	 * @author likai
	 * @throws
	 */
	public static void getRecommendNewUsers(int page, int pagesize, final Handler mHandler) {
		new GetRecommendNewUsersRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_GET_RECOMMEND_NEW_USERS, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).execute(page, pagesize);
	}

	/**
	 * @Title: createGroup
	 * @Description: 创建一个新群组
	 * @return void 返回类型
	 * @param @param filePath 头像
	 * @param @param title 群组标题
	 * @param @param oids 群组成员id
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void createGroup(String filePath, String title, String oids, final Handler handler, final Context context) {
		Map<String, String> params = new HashMap<String, String>();
		params.put(FORM_TITLE, title);
		params.put(FORM_OIDS, oids);
		J_NetManager.getInstance().uploadWithXUtils(NetConstans.CREATE_GROUP_URL, params, filePath, new OnLoadingListener() {

			@Override
			public void startLoading() {
			}

			@Override
			public void onfinishLoading(String result) {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GROUP_CREATE_GROUP, result));
			}

			@Override
			public void onLoading(long total, long current, boolean isUploading) {
			}

			@Override
			public void onError() {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "新建群组失败，请再次尝试！");
			}
		});
	}

	/**
	 * 修改用户群组设置
	 * 
	 * @return void 返回类型
	 * @param @param uid
	 * @param @param group_id
	 * @param @param show
	 * @param @param hint
	 * @param @param status 参数类型
	 * @author likai
	 * @throws
	 */
	public static void updateUserGroup(long uid, int group_id, int show, int hint, final Handler mHandler, final Context context) {
		new UpdateUserGroupRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_UPDATE_USER_GROUP, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "更新失败，请再次尝试");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				showNetworkError(context);
			}
		}).execute(uid, group_id, show, hint);
	}

	/**
	 * @Title: updateGroup
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @return void 返回类型
	 * @param @param groupId 群组id
	 * @param @param intro 组简介
	 * @param @param privilege 权限
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void updateGroup(int groupId, String intro, int privilege, final Handler handler, final Context context) {
		new UpdateGroupRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_UPDATE_GROUP, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "群组信息更新失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "群组信息更新失败，请再次尝试！");
			}
		}).update(groupId, intro, privilege);
	}

	/**
	 * @Title: inviteFriendJoinGroup
	 * @Description: 邀请好友
	 * @return void 返回类型
	 * @param @param oid 邀请的id
	 * @param @param groupId 群组id
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void inviteFriendJoinGroup(String oid, String groupId, final Handler handler, final Context context) {
		new InviteFriendJoinGroupRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_INVITE_FRIEND_JOIN_GROUP, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "操作失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "操作失败，请再次尝试！");
			}
		}).invite(oid, groupId);
	}

	/**
	 * 申请添加好友
	 * 
	 * @return void 返回类型
	 * @param @param uid
	 * @param @param fuid 参数类型
	 * @author likai
	 * @throws
	 */
	public static void friendsSentReq(long uid, long fuid, final Handler mHandler) {
		new FriendsSentReqRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				mHandler.sendMessage(mHandler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_SENT_REQ, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).execute(uid, fuid);
	}

	/**
	 * @Title: groupMasterDelPerson
	 * @Description: 群主踢人
	 * @return void 返回类型
	 * @param @param touid 用户id
	 * @param @param groupId 群组id
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void groupMasterDelPerson(String touid, String groupId, final Handler handler, final Context context) {
		new GroupMasterDelPersonRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GROUP_MASTER_DEL_PERSON, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "操作失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "操作失败，请再次尝试！");
			}
		}).del(touid, groupId);
	}

	/**
	 * @Title: exitGroup
	 * @Description: 退出群组
	 * @return void 返回类型
	 * @param @param groupId
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void exitGroup(int groupId, final Handler handler, final Context context) {
		new ExitGroupRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					if ("true".equals(response.data)) {
						handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_EXIT_GROUP, response.data));
					} else {
						DialogUtils.dismissDialog();
						ToastUtil.showToast(context, "不能退出该群组！");
					}
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "操作失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "操作失败，请再次尝试！");
			}
		}).exit(groupId);
	}

	/**
	 * @Title: updateGroupPic
	 * @Description: 修改群组头像
	 * @return void 返回类型
	 * @param @param filePath 头像路径
	 * @param @param groupId 群组id
	 * @author donglizhi
	 * @throws
	 */
	public static void updateGroupPic(String filePath, String groupId) {
		Map<String, String> params = new HashMap<String, String>();
		params.put(FORM_GROUP_ID, groupId);
		J_NetManager.getInstance().uploadWithXUtils(NetConstans.UPDATE_GROUP_PIC_URL, params, filePath, new OnLoadingListener() {

			@Override
			public void startLoading() {
			}

			@Override
			public void onfinishLoading(String result) {
			}

			@Override
			public void onLoading(long total, long current, boolean isUploading) {
			}

			@Override
			public void onError() {
			}
		});
	}

	/**
	 * @Title: recommendGroupList
	 * @Description: 获取推荐数据
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void recommendGroupList(final Handler handler, final Context context) {
		new RecommendGroupListRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_RECOMMEND_GROUP_LIST, response.data));
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).get();
	}

	/**
	 * @Title: getAllChatMsgList
	 * @Description: 获取全部聊天消息列表
	 * @return void 返回类型
	 * @param @param page 页码
	 * @param @param pageSize 每页数量
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void getAllChatMsgList(int page, int pageSize, final Handler handler, final Context context) {
		new GetAllChatMsgListRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_ALL_CHAT_MSG_LIST, response.data));
				} else {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_ALL_CHAT_MSG_LIST, response.retcode,
							response.retcode));
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				int error = (Integer) errorMap.get(OnDataBack.KEY_ERROR);
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_ALL_CHAT_MSG_LIST, error, error));
			}
		}).get(page, pageSize);
	}

	/**
	 * @Title: delMsg
	 * @Description: 删除联系人消息
	 * @return void 返回类型
	 * @param @param oid 联系人id
	 * @param @param iid 消息id
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void delMsg(String oid, String iid, Handler handler, Context context) {
		new DelMsgRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).del(oid, iid);
	}

	/**
	 * @Title: delContactAllMsg
	 * @Description: 删除联系人所有消息
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void delContactAllMsg(String oid, final Handler handler, final Context context) {
		new DelContactRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_DEL_CONTACT, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "操作失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "操作失败，请再次尝试！");
			}
		}).del(oid);
	}

	/**
	 * @Title: sendGroupMsg
	 * @Description: 发送群组聊天消息
	 * @return void 返回类型
	 * @param @param context
	 * @param @param handler
	 * @param @param form 消息内容
	 * @param @param chat_table_id 消息本地id
	 * @author donglizhi
	 * @throws
	 */
	public static void sendGroupMsg(final Context context, final Handler handler, String form, long chat_table_id) {
		new SendGroupMsgRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SEND_GROUP_MSG, result));
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				int Error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
				long id = (Long) errMap.get(OnDataBack.KEY_CHAT_TABLE_ID);
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SEND_GROUP_MSG, Error, Error, id));
			}

		}).send(form, chat_table_id);
	}

	/**
	 * @Title: sendPicGroupMsg
	 * @Description: 发送群组图片消息
	 * @return void 返回类型
	 * @param @param path 图片路径
	 * @param @param handler
	 * @param @param groupId 群组id
	 * @param @param lcMsgId 本地群组id
	 * @author donglizhi
	 * @throws
	 */
	public static void sendPicGroupMsg(String path, final Handler handler, String groupId, final int lcMsgId) {
		Map<String, String> params = new HashMap<String, String>();
		params.put(FORM_GROUP_ID, groupId);
		J_NetManager.getInstance().uploadWithXUtils(NetConstans.SEND_PIC_GROUP_MSG_URL, params, path, new OnLoadingListener() {

			@Override
			public void startLoading() {
			}

			@Override
			public void onfinishLoading(String result) {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SEND_PIC_GROUP_MSG, lcMsgId, lcMsgId, result));
			}

			@Override
			public void onLoading(long total, long current, boolean isUploading) {
				if (isUploading) {
					double percent = current * 100 / (double) total;
					int percentage = (int) percent;
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.UPDATE_IMAGE_MSG_UPLOAD_PERCENT, lcMsgId, percentage));
				}
			}

			@Override
			public void onError() {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SEND_PIC_GROUP_MSG, lcMsgId, lcMsgId));
			}
		});
	}

	/**
	 * @Title: sendGroupVoiceMsg
	 * @Description: 群组发送语音消息
	 * @return void 返回类型
	 * @param @param filePath 音频路径
	 * @param @param group_id 群组id
	 * @param @param handler
	 * @param @param dur 音频时长
	 * @param @param lcMsgId 消息本地id
	 * @author donglizhi
	 * @throws
	 */
	public static void sendGroupVoiceMsg(String filePath, String group_id, final Handler handler, String dur, final int lcMsgId) {
		Map<String, String> params = new HashMap<String, String>();
		params.put(FORM_GROUP_ID, group_id);
		params.put(FORM_DUR, dur);
		J_NetManager.getInstance().uploadWithXUtils(NetConstans.SEND_VOICE_GROUP_MSG_URL, params, filePath,
				new OnLoadingListener() {

					@Override
					public void startLoading() {
					}

					@Override
					public void onfinishLoading(String result) {
						handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SEND_VOICE_GROUP_MSG, lcMsgId, lcMsgId,
								result));
					}

					@Override
					public void onLoading(long total, long current, boolean isUploading) {
					}

					@Override
					public void onError() {
						handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SEND_VOICE_GROUP_MSG, lcMsgId, lcMsgId));
					}
				});
	}

	/**
	 * @Title: getGroupChatHistoryList
	 * @Description: 获取群组历史聊天记录
	 * @return void 返回类型
	 * @param @param groupId 群组id
	 * @param @param page 页码
	 * @param @param pageSize
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void getGroupChatHistoryList(String groupId, String iid, int pageSize, final Handler handler, Context context) {
		new GetHistoryGroupChatListRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_HISTORY_GROUP_CHAT_LIST, result));
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				int error = (Integer) errorMap.get(OnDataBack.KEY_ERROR);
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_HISTORY_GROUP_CHAT_LIST, error, error));
			}
		}).get(groupId, iid, pageSize);
	}

	/**
	 * @Title: sendOnreadByOid
	 * @Description: 设置单聊消息全部已读
	 * @return void 返回类型
	 * @param @param oid 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void sendOnreadByOid(String oid) {
		new SendOnreadByOidRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).send(oid);
	}

	/**
	 * @Title: sendOnreadGroupByOid
	 * @Description: 设置群组消息为已读
	 * @return void 返回类型
	 * @param @param groupId 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void sendOnreadGroupByOid(String groupId) {
		new SendOnreadGroupByOidRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).send(groupId);
	}

	/**
	 * @Title: getFriendsFsFriends
	 * @Description: 获得二度好友数据
	 * @return void 返回类型
	 * @param @param start
	 * @param @param num
	 * @param @param condition
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void getFriendsFsFriends(int start, int num, String condition, String conditionStar, String conditionTags,
			final Handler handler, final Context context) {
		new FriendsGetFsFriends(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_GET_FSFRIENDS, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "请求失败,请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "请求失败,请再次尝试！");
			}
		}).get(start, num, condition, conditionStar, conditionTags);
	}

	/**
	 * @Title: getMaxTag
	 * @Description: 获取使用频率最高的30个标签
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void getMaxTag(final Handler handler, Context context) {
		new TagGetMaxTagRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_TAG_GET_MAX_TAGS, response.data));
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).get();
	}

	/**
	 * @Title: acceptFriendsJoinGroup
	 * @Description: 接受或拒绝好友加入群(只有群主操作)
	 * @return void 返回类型
	 * @param @param groupId 群组id
	 * @param @param uid 申请人id
	 * @param @param type 0-未做处理 1-通过， 2-不通过
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void acceptFriendsJoinGroup(String groupId, String uid, final int type, final int position,
			final Handler handler, final Context context) {
		new AcceptFriendJoinGroupRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_ACCEPT_FRIEND_JOIN_GROUP, position, type,
							response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "操作失败，请再次尝试！");
				}

			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "操作失败，请再次尝试！");
			}
		}).accept(groupId, uid, type, position);
	}

	/**
	 * @Title: initData
	 * @Description: 登陆后初始化数据
	 * @return void 返回类型
	 * @param @param handler
	 * @param @param context
	 * @param @param uid 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private static void initData(final Handler handler, final Context context, String uid) {
		// 启动推送
		if (J_SDK.getConfig().API_SETTING == 3) {
			J_BaiduPushManager.getInstance().connecte(J_Consts.BAIDU_PUSH_APIKEY);
		} else {
			J_BaiduPushManager.getInstance().connecte(J_Consts.BAIDU_PUSH_TEST_APIKEY);
		}
		// 获取用户信息
		getUserInfo(context, handler, uid);
		loginSetPush();
		SharedPreUtil.saveShowVoiceModeTime(0);
	}

	public static void getCount(final Handler handler, final Context context, String uid) {
		// 一度好友数量
		UtilRequest.getFriendsNums(uid, 1, 1, handler, context);
		// 二度好友数量
		UtilRequest.getFriendsNums(uid, 2, 1, handler, context);
		getMyGroupCount(context);
		getCountNew();
	}

	/**
	 * 升级app
	 * 
	 * @return void 返回类型
	 * @param mContext 参数类型
	 * @author likai
	 * @throws
	 */
	public static void updateClient(final Context mContext, final Handler mHandler) {
		boolean isShow = SharedPreUtil.getUpdateAppWarm(Util.getAppVersionCode());
		if (isShow) {
			new UpdateClientRequest(new OnDataBack() {
				@Override
				public void onResponse(Object result) {
					final UpdateAppResponse response = (UpdateAppResponse) result;
					if (response.retcode == 1) {
						// 提醒升级
						DialogUtils.showUpdateDialog(mContext, R.string.setting_update_app, response.content,
								new OnSelectCallBack() {
									@Override
									public void onCallBack(String value1, String value2, String value3) {
										if (value1.equals("0")) {
											// 确定-开始下载更新-后台保持下载
											Intent upIntent = new Intent(mContext, UpdateService.class);
											upIntent.putExtra("url", response.url);
											mContext.startService(upIntent);
										} else {
											SharedPreUtil.setUpdateAppWarm(Util.getAppVersionCode(), false);
										}
									}
								});
					} else if (response.retcode == 2) {
						// 强制升级
						DialogUtils.showUpdateDialog(mContext, R.string.setting_update_app, response.content,
								new OnSelectCallBack() {
									@Override
									public void onCallBack(String value1, String value2, String value3) {
										if (value1.equals("0")) {
											// 确定-开始下载更新-后台保持下载
											Intent upIntent = new Intent(mContext, UpdateService.class);
											upIntent.putExtra("url", response.url);
											mContext.startService(upIntent);
										} else if (value1.equals("1")) {
											// 取消，关闭应用
											// 关闭页面
											J_PageManager.getInstance().finishAllPage();
											// 关闭定位
											J_LocationManager.getInstance().destroy();
											// 关闭应用
											System.exit(0);
										}
									}
								});
					} else {
						if (mHandler != null) {
							mHandler.sendEmptyMessage(0x40004);
						}
					}
				}

				@Override
				public void onError(HashMap<String, Object> errorMap) {
					DialogUtils.dismissDialog();
					showNetworkError(mContext);
				}
			}).execute();
		}
	}

	/**
	 * @Title: friendsAcceptReq
	 * @Description: 接受好友申请
	 * @return void 返回类型
	 * @param @param uid 自己的uid
	 * @param @param fuid 好友的uid
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void friendsAcceptReq(String uid, String fuid, final Handler handler, final Context context, final int position) {
		new FriendsAcceptReqRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_ACCEPT_REQ, position, 1, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "操作失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "操作失败，请再次尝试！");
			}
		}).accept(uid, fuid);
	}

	public static void friendsRemReq(String uid, String fuid, final Handler handler, final Context context, final int position) {
		new FriendsRemReqRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_FRIENDS_REM_REQ, position, 1, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "操作失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "操作失败，请再次尝试！");
			}
		}).remove(uid, fuid);
	}

	/**
	 * @Title: friendsSendMsgToRegFriends
	 * @Description: 新好友加入
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void friendsSendMsgToRegFriends(String uid) {
		new FriendsSendMsgToRegFriendsRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).send(uid);
	}

	/**
	 * @param typeString
	 * @Title: systemMsgSetOnread
	 * @Description: 设置系统消息已读
	 * @return void 返回类型
	 * @param @param iid 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void systemMsgSetOnread(String iid, String typeString) {
		new SetOnreadRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).execute(iid, typeString);
	}

	/**
	 * @Title: getMyGroupCount
	 * @Description: 获得好友分组数量
	 * @return void 返回类型
	 * @param @param handler 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void getMyGroupCount(final Context context) {
		new CountGroupRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					int myGorupCount = Integer.valueOf(response.data);
					SharedPreUtil.setGroupCount(myGorupCount);
					Intent intent = new Intent();
					intent.setAction(BROADCAST_ACTION_UPDATE_GROUP_COUNT);
					context.sendBroadcast(intent);
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).getCount();
	}

	/**
	 * @Title: getCountNew
	 * @Description: 获得消息数字
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void getCountNew() {
		new CountNewRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					try {
						JSONObject object = new JSONObject(response.data);
						int sys_change = object.optInt(FORM_SYS_CHANGE);
						String sys_time = object.optString(FORM_SYS_TIME) + "000";
						SharedPreUtil.setSystemChange(sys_change);
						SharedPreUtil.setSystemTime(sys_time);
						Intent intent = new Intent();
						intent.setAction(BROADCAST_UPDATE_SYSTEM_MESSAGE_COUNT);
						Util.sendBroadcast(intent);
						return;
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
				SharedPreUtil.setSystemChange(0);
				SharedPreUtil.setSystemTime("0");
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).get();
	}

	public static void showNetworkError(Context context) {
		ToastUtil.showToast(context, context.getString(R.string.network_error));
	}

	/**
	 * @Title: delPushId
	 * @Description: 解绑推送
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void delPushId() {
		new DelPushIdRequset(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).del(SharedPreUtil.getBaiduUserID());
	}

	/**
	 * @Title: updateGroupTitle
	 * @Description: 修改群组名称
	 * @return void 返回类型
	 * @param @param groupId
	 * @param @param title
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void updateGroupTitle(String groupId, String title, final Handler handler, final Context context) {
		new UpdateGroupTitleRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_UPDATE_GROUP_TITLE, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "群组名称更新失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "群组名称更新失败，请再次尝试！");
			}
		}).update(groupId, title);
	}

	/**
	 * @Title: updateGroupStatus
	 * @Description: 更新群组状态
	 * @return void 返回类型
	 * @param @param groupId 群组id
	 * @param @param status 群组状态
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void updateGroupStatus(String groupId, int status, final Handler handler, final Context context) {
		new UpdateGroupStatusRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_UPDATE_GROUP_STATUS, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "群组状态更新失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "群组状态更新失败，请再次尝试！");
			}
		}).update(groupId, status);
	}

	/**
	 * @Title: updateGroupShow
	 * @Description: 修改用户群在资料页显示状态
	 * @return void 返回类型
	 * @param @param groupId
	 * @param @param show
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void updateGroupShow(String groupId, int show, final Handler handler, final Context context) {
		new UpdateGroupShowRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_UPDATE_GROUP_SHOW, response.data));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "是否展示更新失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				ToastUtil.showToast(context, "是否展示更新失败，请再次尝试！");
			}
		}).update(groupId, show);
	}

	/**
	 * @Title: ignoreSys
	 * @Description: 忽略好友申请
	 * @return void 返回类型
	 * @param @param oid
	 * @author donglizhi
	 * @throws
	 */
	public static void ignoreSys(String oid) {
		new IgnoreSysRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).ignore(oid);
	}

	/**
	 * @Title: setHandled
	 * @Description: 设置系统消息已处理
	 * @return void 返回类型
	 * @param String $iid 消息id
	 * @param int $operate 操作类型 3接受 4拒绝
	 * @author donglizhi
	 * @throws
	 */
	public static void setHandled(String iid, int operate) {
		new SetHandledRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).set(iid, operate);
	}

	/**
	 * @Title: isGroupMember
	 * @Description: 是否是群组成员
	 * @return void 返回类型
	 * @param @param groupId
	 * @param @param context
	 * @param @param handler 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void isGroupMember(String groupId, final Context context, final Handler handler, final int index) {
		new IsGroupMemberRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean) && response.retcode == 1
						&& "true".equals(response.data)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_IS_GROUP_MEMBER, index));
				} else {
					handler.sendEmptyMessage(NetTaskIDs.TASKID_IS_GROUP_MEMBER);
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "你已经不在该群组中");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				showNetworkError(context);
			}
		}).isGroupMember(groupId);
	}

	public static void updateUserGroupShowNick(String groupId, int showNick, final Handler handler, final Context context) {
		new UpdateUserGroupShowNick(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_UPDATE_USER_GROUP_SHOW_NICK));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "更新失败，请再次尝试！");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				showNetworkError(context);
			}
		}).update(groupId, showNick);
	}

	/**
	 * @Title: getVoiceSwitch
	 * @Description: 获取听筒模式和扬声器模式开关
	 * @return void 返回类型
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void getVoiceSwitch(final Handler handler, final Context context) {
		new GetUserVoiceSwitch(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					int voiceSwitch = Util.getInteger(response.data);
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_USER_VOICE_SWITCH, voiceSwitch));
				} else {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_USER_VOICE_SWITCH, 0));
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_GET_USER_VOICE_SWITCH, 0));
				showNetworkError(context);
			}
		}).get();
	}

	/**
	 * @Title: setVoiceSwicth
	 * @Description: 设置语音模式
	 * @return void 返回类型
	 * @param @param handler
	 * @param @param context
	 * @param @param voiceSwitch 声音开关 0扬声器 1听筒
	 * @author donglizhi
	 * @throws
	 */
	public static void setVoiceSwicth(final Handler handler, final Context context, final int voiceSwitch) {
		new SetUserVoiceSwitch(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)
						&& "true".equals(response.data)) {
					handler.sendMessage(handler.obtainMessage(NetTaskIDs.TASKID_SET_USER_VOICE_SWITCH, voiceSwitch));
				} else {
					DialogUtils.dismissDialog();
					ToastUtil.showToast(context, "切换语音模式失败，请再次尝试");
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				showNetworkError(context);
			}
		}).set(voiceSwitch);
	}

	/**
	 * @Title: clearCache
	 * @Description: 删除群聊后清除缓存
	 * @return void 返回类型
	 * @param @param groupId 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void clearCache(String groupId) {
		new ClearCacheRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).clear(groupId);
	}

	/**
	 * @Title: sendSingleMsg
	 * @Description: 单聊求脱单
	 * @return void 返回类型
	 * @param @param toUid 接收人的uid
	 * @param @param avatar 分享用户的头像
	 * @param @param sex 分享用户的性别
	 * @param @param province 分享用户的省份
	 * @param @param city 分享用户的城市
	 * @param @param nick 分享用户昵称
	 * @param @param marriage 分享用户的情感状态
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void sendSingleMsg(String toUid, String avatar, int sex, String province, String city, String nick,
			int marriage, Handler handler, final Context context) {
		new SendSingleMsgRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {

			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				DialogUtils.dismissDialog();
				showNetworkError(context);
			}
		}).send(toUid, avatar, sex, province, city, nick, marriage);
	}

	/**
	 * @Title: sendGroupSingleMsg
	 * @Description: 群聊求脱单
	 * @return void 返回类型
	 * @param @param groupId 接收的群组id
	 * @param @param avatar 分享用户的头像
	 * @param @param sex 分享用户的性别
	 * @param @param province 分享用户的省份
	 * @param @param city 分享用户的城市
	 * @param @param nick 分享用户昵称
	 * @param @param marriage 分享用户的情感状态
	 * @param @param handler
	 * @param @param context 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void sendGroupSingleMsg(String groupId, String avatar, int sex, String province, String city, String nick,
			int marriage, Handler handler, final Context context) {
		new SendGroupSingleMsgRequest(new OnDataBack() {

			@Override
			public void onResponse(Object result) {
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				showNetworkError(context);
				DialogUtils.dismissDialog();
			}
		}).send(groupId, avatar, sex, province, city, nick, marriage);
	}

}
