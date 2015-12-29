package com.iyouxun.utils;

import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONObject;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;

import com.iyouxun.J_Application;
import com.iyouxun.data.beans.DynamicInfoBean;
import com.iyouxun.data.beans.GroupsInfoBean;
import com.iyouxun.data.beans.LocationInfo;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.beans.SplashInfo;
import com.iyouxun.data.beans.users.LoginUser;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.encrypt.Base64Util;
import com.iyouxun.location.J_LocationPoint;

public class SharedPreUtil {

	/**
	 * 保存登录用户信息
	 * 
	 * @return void 返回类型
	 * @param @param user 参数类型
	 * @author likai
	 */
	public static void saveLoginInfo(LoginUser user) {
		if (!Util.isBlankString(user.userName)) {
			saveLoginMobile(user.userName);
		}

		saveUserInfoToLocalFile(true, user);

		J_Cache.sLoginUser = user;

	}

	/**
	 * TODO 获取登录用户信息
	 * 
	 * @return LoginUser 返回类型
	 * @param @return 参数类型
	 * @author likai
	 */
	public static LoginUser getLoginInfo() {
		if (J_Cache.sLoginUser != null) {
			return J_Cache.sLoginUser;
		}

		J_Cache.sLoginUser = parseUserInfoFromLocalFile(true, 0);

		return J_Cache.sLoginUser;
	}

	/**
	 * 保存普通用户信息
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public static void saveNormalUser(LoginUser user) {
		saveUserInfoToLocalFile(false, user);
	}

	/**
	 * 获取普通用户信息
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public static LoginUser getNormalUser(long uid) {
		LoginUser user = parseUserInfoFromLocalFile(false, uid);

		return user;
	}

	/**
	 * 缓存用户信息到本地文件
	 * 
	 * @return void 返回类型
	 * @param @param user 参数类型
	 * @author likai
	 * @throws
	 */
	private static void saveUserInfoToLocalFile(boolean isLoginUser, LoginUser user) {
		SharedPreferences sp;
		if (isLoginUser) {
			// 登录用户信息
			sp = J_Application.context.getSharedPreferences("login_info", Context.MODE_PRIVATE);
		} else {
			// 普通用户信息
			sp = J_Application.context.getSharedPreferences("user_info_" + user.uid, Context.MODE_PRIVATE);
		}
		Editor editor = sp.edit();
		// baseUser
		editor.putLong("uid", user.uid);
		editor.putInt("gid", user.gid);
		editor.putString("nickName", user.nickName);
		editor.putInt("sex", user.sex);
		editor.putInt("age", user.age);
		editor.putString("username", user.userName);
		if (!Util.isBlankString(user.password)) {
			editor.putString("password", Base64Util.encode(user.password));
		}
		editor.putString("mobile", user.mobile);
		// LoginUser
		editor.putString("openID", user.openID);
		editor.putInt("location", user.location);
		editor.putInt("subLocation", user.subLocation);
		editor.putString("locationName", user.locationName);
		editor.putString("subLocationName", user.subLocationName);
		editor.putInt("birthYear", user.birthYear);
		editor.putInt("birthMonth", user.birthMonth);
		editor.putInt("birthDay", user.birthDay);
		editor.putInt("marriage", user.marriage);
		editor.putInt("height", user.height);
		editor.putInt("weight", user.weight);
		editor.putInt("career", user.career);
		editor.putString("company", user.company);
		editor.putString("school", user.school);
		editor.putString("intro", user.intro);
		editor.putInt("star", user.star);
		editor.putInt("birthpet", user.birthpet);
		editor.putInt("lonelyConfirm", user.lonelyConfirm);
		editor.putInt("photoCount", user.photoCount);
		editor.putInt("distance", user.distance);
		editor.putString("address", user.address);
		editor.putInt("isFriend", user.isFriend);
		editor.putInt("isLonelyConfirm", user.isLonelyConfirm);
		editor.putInt("hasAvatar", user.hasAvatar);
		editor.putString("avatarUrl", user.avatarUrl150);
		editor.putString("avatarUrl150", user.avatarUrl150);
		editor.putString("avatarUrl200", user.avatarUrl200);
		editor.putString("avatarUrl600", user.avatarUrl600);
		editor.putString("avatarPid", user.avatarPid);
		editor.putString("mark", user.mark);
		editor.putInt("show_second_friend_dync", user.show_second_friend_dync);
		editor.putInt("allow_second_friend_look_my_dync", user.allow_second_friend_look_my_dync);
		editor.putInt("allow_accept_second_friend_invite", user.allow_accept_second_friend_invite);
		editor.putInt("allow_add_with_chat", user.allow_add_with_chat);
		editor.putInt("allow_my_profile_show", user.allow_my_profile_show);
		editor.putInt("callno_upload", user.callno_upload);
		editor.putInt("friends_num", user.friends_num);

		editor.putLong("lastLoginTime", user.lastLoginTime);
		editor.putString("photoDatasStr", user.photoDatasStr);
		// Config
		editor.putBoolean("is_music_on", user.is_music_on);
		editor.putBoolean("is_sound_effects_on", user.is_sound_effects_on);
		editor.putBoolean("is_vibration_on", user.is_vibration_on);
		editor.putBoolean("is_msg_push_on", user.is_msg_push_on);

		editor.commit();
	}

	/**
	 * TODO 从本地缓存文件中解析用户信息
	 * 
	 * @return LoginUser 返回类型
	 * @param isLoginUser 是否为登录用户
	 * @param uid 如果为非登录用户，则为该非登录用户的uid
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	private static LoginUser parseUserInfoFromLocalFile(boolean isLoginUser, long localUid) {
		LoginUser user = new LoginUser();
		SharedPreferences sp;
		if (isLoginUser) {
			// 登录用户
			sp = J_Application.context.getSharedPreferences("login_info", Context.MODE_PRIVATE);
		} else {
			// 非登陆用户的其他用户
			sp = J_Application.context.getSharedPreferences("user_info_" + localUid, Context.MODE_PRIVATE);
		}

		// baseUser
		long uid = sp.getLong("uid", 0);
		if (uid > 0) {
			String nick = sp.getString("nickName", "");
			user.uid = uid;
			user.gid = sp.getInt("gid", 1);
			user.nickName = sp.getString("nickName", "");
			user.sex = sp.getInt("sex", 0);
			user.age = sp.getInt("age", 0);
			user.userName = sp.getString("username", "");
			user.password = Base64Util.decode(sp.getString("password", ""));
			user.mobile = sp.getString("mobile", "");
			// LoginUser
			user.openID = sp.getString("openID", "");
			user.location = sp.getInt("location", 0);
			user.subLocation = sp.getInt("subLocation", 0);
			user.locationName = sp.getString("locationName", "");
			user.subLocationName = sp.getString("subLocationName", "");
			user.birthYear = sp.getInt("birthYear", 0);
			user.birthMonth = sp.getInt("birthMonth", 0);
			user.birthDay = sp.getInt("birthDay", 0);
			user.marriage = sp.getInt("marriage", 0);
			user.height = sp.getInt("height", 0);
			user.weight = sp.getInt("weight", 0);
			user.career = sp.getInt("career", 0);
			user.company = sp.getString("company", "");
			user.school = sp.getString("school", "");
			user.intro = sp.getString("intro", "");
			user.star = sp.getInt("star", 0);
			user.birthpet = sp.getInt("birthpet", 0);
			user.lonelyConfirm = sp.getInt("lonelyConfirm", 0);
			user.photoCount = sp.getInt("photoCount", 0);
			user.distance = sp.getInt("distance", 0);
			user.address = sp.getString("address", "");
			user.isFriend = sp.getInt("isFriend", 0);
			user.isLonelyConfirm = sp.getInt("isLonelyConfirm", 0);
			user.hasAvatar = sp.getInt("hasAvatar", 0);
			user.avatarUrl = sp.getString("avatarUrl", "");
			user.avatarUrl150 = sp.getString("avatarUrl150", "");
			user.avatarUrl200 = sp.getString("avatarUrl200", "");
			user.avatarUrl600 = sp.getString("avatarUrl600", "");
			user.avatarPid = sp.getString("avatarPid", "");
			user.mark = sp.getString("mark", "");
			user.show_second_friend_dync = sp.getInt("show_second_friend_dync", 0);
			user.allow_second_friend_look_my_dync = sp.getInt("allow_second_friend_look_my_dync", 0);
			user.allow_accept_second_friend_invite = sp.getInt("allow_accept_second_friend_invite", 0);
			user.allow_add_with_chat = sp.getInt("allow_add_with_chat", 0);
			user.allow_my_profile_show = sp.getInt("allow_my_profile_show", 0);
			user.callno_upload = sp.getInt("callno_upload", 0);
			user.friends_num = sp.getInt("friends_num", 0);

			user.lastLoginTime = sp.getLong("lastLoginTime", 0);
			// 最新的几张图片
			String photoDatasStr = sp.getString("photoDatasStr", "");
			if (!Util.isBlankString(photoDatasStr) && !photoDatasStr.equals("[]")) {
				user.photoDatasStr = photoDatasStr;
				user.photoDatas = parsePhotoInfo(uid, nick, photoDatasStr);
			}

			// config
			user.is_msg_push_on = sp.getBoolean("is_msg_push_on", true);
			user.is_music_on = sp.getBoolean("is_music_on", true);
			user.is_sound_effects_on = sp.getBoolean("is_sound_effects_on", true);
			user.is_vibration_on = sp.getBoolean("is_vibration_on", true);
		}

		return user;
	}

	/**
	 * 清除登录数据
	 * 
	 * @Title: logoutLoginInfo
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public static void clearLoginInfo() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("login_info", Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.clear();
		editor.commit();
		J_Cache.sLoginUser = new LoginUser();
	}

	/**
	 * 解析用户信息中的最新图片
	 * 
	 * @Title: parsePhotoInfo
	 * @return ArrayList<PhotoInfoBean> 返回类型
	 * @param uid 图片所有人的uid
	 * @param photoInfoStr 要解析的图片信息
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static ArrayList<PhotoInfoBean> parsePhotoInfo(long uid, String nick, String photoInfoStr) {
		ArrayList<PhotoInfoBean> photoDatas = new ArrayList<PhotoInfoBean>();
		try {
			JSONObject photoObject = new JSONObject(photoInfoStr);
			Iterator iterator = photoObject.keys();
			while (iterator.hasNext()) {
				String key = (String) iterator.next();
				JSONObject single = photoObject.optJSONObject(key);
				PhotoInfoBean bean = new PhotoInfoBean();
				bean.pid = key;
				bean.url_small = single.optString("300");
				bean.url = single.optString("800");
				bean.uid = uid;
				bean.nick = nick;
				bean.isLike = single.optInt("like");
				photoDatas.add(bean);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return photoDatas;
	}

	/**
	 * 解析用户信息中最新的一条动态信息
	 * 
	 * @Title: parseNewOneDynamic
	 * @return DynamicInfoBean 返回类型
	 * @param @param newOneDynamicStr
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static DynamicInfoBean parseNewOneDynamic(String newOneDynamicStr) {
		DynamicInfoBean dbean = new DynamicInfoBean();
		try {
			JSONObject dynamic = new JSONObject(newOneDynamicStr);
			dbean.ctime = dynamic.optInt("ctime");
			dbean.type = dynamic.optInt("type");
			dbean.content = dynamic.optString("content");
			dbean.picUrl = dynamic.optString("pic");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return dbean;
	}

	/**
	 * 解析用户信息中的群组信息
	 * 
	 * @Title: parseGroupInfo
	 * @return ArrayList<GroupsInfoBean> 返回类型
	 * @param @param groupDatasStr
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static ArrayList<GroupsInfoBean> parseGroupInfo(String groupDatasStr) {
		ArrayList<GroupsInfoBean> groupDatas = new ArrayList<GroupsInfoBean>();
		try {
			JSONArray mgArray = new JSONArray(groupDatasStr);
			if (mgArray.length() > 0) {
				// 清空原数据
				for (int i = 0; i < mgArray.length(); i++) {
					GroupsInfoBean gInfoBean = new GroupsInfoBean();
					gInfoBean.id = mgArray.optJSONObject(i).optInt("id");
					gInfoBean.name = mgArray.optJSONObject(i).optString("name");
					gInfoBean.count = mgArray.optJSONObject(i).optInt("count");
					groupDatas.add(gInfoBean);
				}
			}
		} catch (Exception e) {
		}
		return groupDatas;
	}

	/**
	 * 保存用户登录的token信息
	 * 
	 * @return void 返回类型
	 * @param @param token 参数类型
	 * @author likai
	 */
	public static void saveLoginToken(String token) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.putString("loginToken", token);
		editor.commit();
	}

	/**
	 * 获取用户登录token
	 * 
	 * @return String 返回类型
	 * @param @return 参数类型
	 * @author likai
	 */
	public static String getLoginToken() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		String loginToken = sp.getString("loginToken", "");
		return loginToken;
	}

	/**
	 * 保存坐标定位信息
	 * 
	 * @return void 返回类型
	 * @param @param point 参数类型
	 * @author likai
	 */
	public static void saveLocation(J_LocationPoint point) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.putString("latitude", point.getLatitude());
		editor.putString("longitude", point.getLongitude());
		editor.putString("province", point.locationInfo.province);
		editor.putString("city", point.locationInfo.city);
		editor.putString("district", point.locationInfo.district);
		editor.putString("address", point.locationInfo.address);
		editor.putString("street", point.locationInfo.street);
		editor.putString("country", point.locationInfo.country);
		editor.commit();
	}

	/**
	 * 获取坐标定位信息
	 * 
	 * @return J_LocationPoint 返回类型
	 * @param @return 参数类型
	 * @author likai
	 */
	public static J_LocationPoint getLocation() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);

		String latStr = sp.getString("latitude", "39.980685");
		String lonStr = sp.getString("longitude", "116.413326");
		double latitude = Double.parseDouble(latStr);
		double longitude = Double.parseDouble(lonStr);
		LocationInfo info = new LocationInfo();
		info.city = sp.getString("city", "");
		info.province = sp.getString("province", "");
		info.district = sp.getString("district", "");
		info.address = sp.getString("address", "");
		info.street = sp.getString("street", "");
		info.country = sp.getString("country", "");
		J_LocationPoint cell = new J_LocationPoint(longitude, latitude);
		cell.locationInfo = info;
		return cell;
	}

	/** 保存欢迎页信息 */
	public static void saveSplashInfo(SplashInfo info) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.putString("url", info.images[0]);
		editor.putLong("start", info.begin.getTime());
		editor.putLong("end", info.end.getTime());
		editor.putString("time", info.durations[0] + "");
		editor.commit();
	}

	/** 获取欢迎页信息 */
	public static SplashInfo getSplashInfo() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		if (sp.getString("url", "").equals("")) {
			return null;
		}
		SplashInfo info = new SplashInfo();
		info.begin = new Date(sp.getLong("start", 0));
		info.end = new Date(sp.getLong("end", 0));
		info.images = new String[] { sp.getString("url", "") };
		info.durations = new double[] { Double.parseDouble(sp.getString("time", "2")) };
		return info;
	}

	/** 设置为非第一次使用 */
	public static void appHasOpened(boolean b) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		Editor editor = sp.edit();
		editor.putBoolean("first_open", b);
		editor.commit();
	}

	/** 判断用户是否为第一次使用 */
	public static boolean isAppHasOpened() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		return sp.getBoolean("first_open", false);
	}

	/** 百度推送返回的UserID */
	public static void saveBaiduUserID(String userId) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		sp.edit().putString("baiduUserID", userId).commit();
	}

	/** 百度推送返回的UserID */
	public static String getBaiduUserID() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		return sp.getString("baiduUserID", "");
	}

	/** 百度推送返回的channelId */
	public static void saveBaiduChannelID(String channelId) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		sp.edit().putString("baiduChannelID", channelId).commit();
	}

	/** 百度推送返回的channelId */
	public static String getBaiduChannelID() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		return sp.getString("baiduChannelID", "");
	}

	/**
	 * 设置非好友，提示添加好友弹层提示情况
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public static void setAddFriendsStatus(long uid) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putBoolean("is_show_add_friends_layer_" + uid, true).commit();
	}

	public static boolean getAddFriendsStatus(long uid) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		return sp.getBoolean("is_show_add_friends_layer_" + uid, false);
	}

	/**
	 * 是否显示引导页
	 * 
	 */
	public static boolean getShowGuide() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		return sp.getBoolean("shouldShowGuide", true);
	}

	/**
	 * 设置是否显示引导页
	 * 
	 * @return void 返回类型
	 * @param @param shouldShow 参数类型
	 * @author likai
	 * @throws
	 */
	public static void setShowGuide(boolean shouldShow) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		sp.edit().putBoolean("shouldShowGuide", shouldShow).commit();
	}

	/**
	 * 应用更新提示
	 * 
	 * @return void 返回类型
	 * @param @param versionCode
	 * @param @param shouldShow 参数类型
	 * @author likai
	 * @throws
	 */
	public static void setUpdateAppWarm(int versionCode, boolean shouldShow) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		sp.edit().putBoolean("updateAppShow_" + versionCode, shouldShow).commit();
	}

	public static boolean getUpdateAppWarm(int versionCode) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		return sp.getBoolean("updateAppShow_" + versionCode, true);
	}

	/** 主界面引导 */
	public static void setShowMainGuide(boolean showMain) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putBoolean("showMain", showMain).commit();
	}

	/** 主界面引导 */
	public static boolean getShowMainGuide() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		return sp.getBoolean("showMain", false);
	}

	/** 新注册用户 */
	public static boolean isNewUser() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		return sp.getBoolean("newUser", true);
	}

	public static void setNewUser(boolean status) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putBoolean("newUser", status).commit();
	}

	/** 设置一度好友数量注册过的 */
	public static void setMyfriendsNums(int nums) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putInt("myFriendsNums", nums).commit();
	}

	/** 获得一度好友数量注册过的 */
	public static int getMyFriendsNums() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		return sp.getInt("myFriendsNums", 0);
	}

	/** 保存好友数据 */
	public static void setMyFriendsData(String data) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putString("myFriendsData", data).commit();
	}

	/** 获得好友数据 */
	public static String getMyFriendsData() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		return sp.getString("myFriendsData", "");
	}

	/** 保存二度好友数据 */
	public static void setIndirectFriendsData(String data) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putString("IndirectFriendsData", data).commit();
	}

	/** 获得二度好友数据 */
	public static String getIndirectFriendsData() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		return sp.getString("IndirectFriendsData", "");
	}

	/** 保存所有一度、二度好友数据 */
	public static void setMyFriendsAllData(String data) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putString("myFriendsAllData", data).commit();
	}

	/** 获得所有一度、二度好友数据 */
	public static String getMyFriendsAllData() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		return sp.getString("myFriendsAllData", "");
	}

	/** 保存好友分组数据 */
	public static void setFriendsGroupData(String groupData) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putString("myFriendsGroupData", groupData).commit();
	}

	/** 获得好友分组数据 */
	public static String getFriendsGroupData() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		return sp.getString("myFriendsGroupData", "");
	}

	/**
	 * 保存登录帐号的手机号
	 * 
	 * @return void 返回类型
	 * @param @param mobile 参数类型
	 * @author likai
	 * @throws
	 */
	public static void saveLoginMobile(String mobile) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		sp.edit().putString("loginUsername", mobile).commit();
	}

	public static String getLoginMobile() {
		String mobile = SharedPreUtil.getLoginInfo().userName;
		if (Util.isBlankString(mobile)) {
			SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
			mobile = sp.getString("loginUsername", "");
		}
		return mobile;
	}

	/** 保存动态未读消息数字 */
	public static void setNewsNewMsgData(int num) {
		num = num < 0 ? 0 : num;
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putInt("newsNewMsgNum_" + SharedPreUtil.getLoginInfo().uid, num).commit();
	}

	/** 获取动态未读消息数字 */
	public static int getNewsNewMsgData() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		int newMsg = sp.getInt("newsNewMsgNum_" + SharedPreUtil.getLoginInfo().uid, 0);
		newMsg = newMsg < 0 ? 0 : newMsg;
		return newMsg;
	}

	/**
	 * @Title: setFriendsNum
	 * @Description: 保存好友数量
	 * @return void 返回类型
	 * @param type 1一度2二度3全部
	 * @param num 好友数量
	 * @author donglizhi
	 * @throws
	 */
	public static void setFriendsNum(int type, int num) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putInt("friendsNum_" + type + SharedPreUtil.getLoginInfo().uid, num).commit();
	}

	/**
	 * 
	 * @Description: 获得好友数量
	 * @return int 好友数量
	 * @param @param type 1一度2二度3全部
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static int getFriendsNum(int type) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		int num = sp.getInt("friendsNum_" + type + SharedPreUtil.getLoginInfo().uid, 0);
		return num;
	}

	/**
	 * @Title: setGroupCount
	 * @Description: 设置好友分组数量
	 * @return void 返回类型
	 * @param @param count 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static void setGroupCount(int count) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putInt("groupCount", count).commit();
	}

	/**
	 * @Title: getGroupCount
	 * @Description: 获得好友分组数量
	 * @return int 返回类型
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static int getGroupCount() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		int num = sp.getInt("groupCount", 0);
		return num;
	}

	public static void setSystemChange(int count) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putInt("sys_change", count).commit();
	}

	public static int getSystemChange() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		int num = sp.getInt("sys_change", 0);
		return num;
	}

	public static void setSystemTime(String time) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		sp.edit().putString("sys_time", time).commit();
	}

	public static String getSystemTime() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info" + getLoginInfo().uid,
				Context.MODE_PRIVATE);
		String time = sp.getString("sys_time", "");
		return time;
	}

	/**
	 * 缓存推荐列表中首页信息
	 * 
	 * @return void 返回类型
	 * @param @param newsInfo 参数类型
	 * @author likai
	 * @throws
	 */
	public static void saveRecommendNewsInfo(String newsInfo, String type) {
		SharedPreferences sp = J_Application.context
				.getSharedPreferences("cache_info" + getLoginInfo().uid, Context.MODE_PRIVATE);
		sp.edit().putString("news_info_" + type, newsInfo).commit();
	}

	/**
	 * 获取缓存的推荐列表信息
	 * 
	 * @return String 返回类型
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String getRecommendNewsInfo(String type) {
		SharedPreferences sp = J_Application.context
				.getSharedPreferences("cache_info" + getLoginInfo().uid, Context.MODE_PRIVATE);
		String newsInfo = sp.getString("news_info_" + type, "");
		return newsInfo;
	}

	public static void saveShowVoiceModeTime(long time) {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		sp.edit().putLong("showVoiceModeTiem", time).commit();
	}

	public static long getShowVoiceModeTime() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		long time = sp.getLong("showVoiceModeTiem", 0);
		return time;
	}

	/**
	 * 计算当前登录用户进入推荐用户页面并加好友的次数
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public static void saveAddFriendsForUploadDialogNums() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		// 取出原数据+1后保存
		int num = sp.getInt("recommendUserAddFriendNums", 0);
		num += 1;
		sp.edit().putInt("recommendUserAddFriendNums", num).commit();
	}

	/**
	 * 获取当前登录用户进入推荐用户页面并加好友的次数
	 * 
	 * @return int 返回类型
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static int getAddFriendsForUploadDialogNums() {
		SharedPreferences sp = J_Application.context.getSharedPreferences("system_info", Context.MODE_PRIVATE);
		int num = sp.getInt("recommendUserAddFriendNums", 0);
		return num;
	}
}
