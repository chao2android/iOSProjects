package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.utils.SharedPreUtil;

/**
 * 首次提示用户上传通讯录，用户取消后的请求
 * 
 * @author likai
 * @date 2015-4-23 上午11:39:06
 * 
 */
public class FriendsMakeFriendsShipRequest extends J_Request {

	public FriendsMakeFriendsShipRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_MAKEFRIENDSHIP_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_MAKEFRIENDSHIP;
	}

	public J_Request execute() {
		addParam("uid", SharedPreUtil.getLoginInfo().uid + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
