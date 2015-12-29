package com.iyouxun.consts;

import java.util.ArrayList;

import com.iyouxun.utils.ProfileUtils;

public class RequestParams {

	/**
	 * Token过期条件
	 * {"retcode":-1025,"uid":"86271357","msg":"invalid parameter: token"}
	 * */
	public static final String[] TOKEN_EXPIRE = { "\"retcode\":-1025" };
	/** 登陆所需用户字段 */
	public static final int[] LOGIN_USER_YPES = { ProfileUtils.PROFILE_NAME, ProfileUtils.PROFILE_SEX,
			ProfileUtils.PROFILE_NICKNAME, ProfileUtils.PROFILE_BIRTHYEAR, ProfileUtils.PROFILE_BIRTHDAY };
	public static final String LOGIN_TYPE = "normal";

	/***
	 * 登陆时所需要得用户信息字段
	 * 
	 * @return
	 */
	public static String getLoginUserFields() {
		StringBuilder sb = new StringBuilder();
		sb.append("[");
		for (int i = 0; i < LOGIN_USER_YPES.length; i++) {
			sb.append(LOGIN_USER_YPES[i]);
			if (i < LOGIN_USER_YPES.length - 1) {
				sb.append(",");
			}
		}
		sb.append("]");
		return sb.toString();
	}

	/** 获取搜索的默认条件 */

	/** 获取在线用户字段 */
	public static String getOnlineUserFields() {
		StringBuilder sb = new StringBuilder();
		sb.append("[");
		sb.append(ProfileUtils.PROFILE_SEX + ",");
		sb.append(ProfileUtils.PROFILE_NICKNAME + ",");
		sb.append(ProfileUtils.PROFILE_BIRTHDAY + ",");
		sb.append(ProfileUtils.PROFILE_BIRTHYEAR + ",");
		sb.append("]");
		return sb.toString();
	}

	/** 获取我的关注用户字段信息 */
	public static String getMyFollowUserFields() {
		StringBuilder sb = new StringBuilder();
		sb.append("[");
		sb.append(ProfileUtils.PROFILE_SEX + ",");
		sb.append(ProfileUtils.PROFILE_NICKNAME + ",");
		sb.append(ProfileUtils.PROFILE_BIRTHDAY + ",");
		sb.append(ProfileUtils.PROFILE_BIRTHYEAR + ",");
		sb.append("]");
		return sb.toString();
	}

	/** 获取对方资料页接口所需要的参数信息 */
	public static String getDetailUserInfoParams(ArrayList<Integer> attributeData) {
		if (attributeData == null) {
			attributeData = new ArrayList<Integer>();
			attributeData.add(ProfileUtils.PROFILE_GROUP_ID);
			attributeData.add(ProfileUtils.PROFILE_NICKNAME); // nickname

			attributeData.add(ProfileUtils.PROFILE_SEX); // sex

			attributeData.add(ProfileUtils.PROFILE_BIRTHDAY); // birth_day
			attributeData.add(ProfileUtils.PROFILE_BIRTHYEAR); // birth_year
			attributeData.add(ProfileUtils.PROFILE_AGE); // age
			attributeData.add(ProfileUtils.PROFILE_NAME); // email
		}
		StringBuilder sb = new StringBuilder("");
		sb.append("[");
		// Attributes
		for (int i = 0; i < attributeData.size(); i++) {
			sb.append(attributeData.get(i)).append(",");
		}
		sb.deleteCharAt(sb.length() - 1);
		sb.append("]");

		return sb.toString();
	}

	/** 获取聊天对方资料所需要的参数信息 */
	public static String getChatUserInfoParams() {
		ArrayList<Integer> attributeData = new ArrayList<Integer>();
		attributeData.add(ProfileUtils.PROFILE_NICKNAME); // nickname
		StringBuilder sb = new StringBuilder("");
		sb.append("[");
		// Attributes
		for (int i = 0; i < attributeData.size(); i++) {
			sb.append(attributeData.get(i)).append(",");
		}
		sb.deleteCharAt(sb.length() - 1);
		sb.append("]");

		return sb.toString();
	}

	/** 获取我的关注用户字段信息 */
	// "[2,3,300,126,206,5,6,102,103]"
	public static String getMatchListUserFields() {
		StringBuilder sb = new StringBuilder();
		sb.append("[");
		sb.append(ProfileUtils.PROFILE_SEX + ",");
		sb.append(ProfileUtils.PROFILE_NICKNAME + ",");
		sb.append(ProfileUtils.PROFILE_BIRTHDAY + ",");
		sb.append(ProfileUtils.PROFILE_BIRTHYEAR + ",");
		sb.append("]");

		return sb.toString();
	}
}
