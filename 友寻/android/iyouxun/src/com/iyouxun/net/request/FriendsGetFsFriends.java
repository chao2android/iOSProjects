package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

public class FriendsGetFsFriends extends J_Request {

	public FriendsGetFsFriends(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_GET_FSFRIENDS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_GET_FSFRIENDS;
	}

	/**
	 * @Title: get
	 * @Description: 获得二度好友列表
	 * @return J_Request 返回类型
	 * @param @param start 起始位置
	 * @param @param num 请求数量
	 * @param @param condition 条件
	 * @param @param conditionStar 星座条件
	 * @param @param conditionTags 标签条件
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request get(int start, int num, String condition, String conditionStar, String conditionTags) {
		addParam(UtilRequest.FORM_UID, SharedPreUtil.getLoginInfo().uid + "");
		addParam(UtilRequest.FORM_IS_REGISTERED, "1");
		addParam(UtilRequest.FORM_START, start + "");
		addParam(UtilRequest.FORM_NUMS, num + "");
		if (!Util.isBlankString(condition)) {
			addParam(UtilRequest.FORM_CONDITION, condition);
		}
		if (!Util.isBlankString(conditionStar)) {
			addParam(UtilRequest.FORM_CONDITION_STAR, conditionStar);
		}
		if (!Util.isBlankString(conditionTags)) {
			addParam(UtilRequest.FORM_CONDITION_TAGS, conditionTags);
		}
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
