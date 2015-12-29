package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取两人共同好友数量
 * 
 * @ClassName: FriendsGetMutualFriendsNumRequest
 * @author likai
 * @date 2015-3-31 下午3:07:02
 * 
 */
public class FriendsGetMutualFriendsNumRequest extends J_Request {

	public FriendsGetMutualFriendsNumRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_GET_MUTUALNUMS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_GET_MUTUALNUMS;
	}

	public J_Request execute(String uid, String fuid) {
		addParam("uid", uid);
		addParam("fuid", fuid);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
