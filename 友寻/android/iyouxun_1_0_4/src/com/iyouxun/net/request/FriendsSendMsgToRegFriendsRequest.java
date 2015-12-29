package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class FriendsSendMsgToRegFriendsRequest extends J_Request {

	public FriendsSendMsgToRegFriendsRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_SEND_MSG_TO_REG_FRIENDS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_SEND_MSG_TO_REG_FRIENDS;
	}

	/**
	 * @Title: send
	 * @Description: 新好友加入
	 * @return J_Request 返回类型
	 * @param @param uid
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request send(String uid) {
		addParam(UtilRequest.FORM_UID, uid);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
