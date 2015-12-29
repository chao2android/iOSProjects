package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 申请添加好友
 * 
 * @author likai
 * @date 2015-4-2 上午9:52:59
 * 
 */
public class FriendsSentReqRequest extends J_Request {

	public FriendsSentReqRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_SENT_REQ_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_SENT_REQ;
	}

	public J_Request execute(long uid, long fuid) {
		addParam("uid", uid + "");
		addParam("fuid", fuid + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}

}
