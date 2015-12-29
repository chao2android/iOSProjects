package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class FriendsGetMyFriendsRequest extends J_Request {

	public FriendsGetMyFriendsRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_GET_MY_FRIENDS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS;
	}

	/**
	 * @Title: get
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @return J_Request 返回类型
	 * @param @param uid 用户id
	 * @param @param isRegistered 是否已注册 1：已注册(默认1);0：未注册
	 * @param @param start 起始位置
	 * @param @param nums 请求数量
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request get(String uid, int isRegistered, int start, int nums) {
		addParam(UtilRequest.FORM_UID, uid);
		addParam(UtilRequest.FORM_IS_REGISTERED, isRegistered + "");
		addParam(UtilRequest.FORM_START, start + "");
		addParam(UtilRequest.FORM_NUMS, nums + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
