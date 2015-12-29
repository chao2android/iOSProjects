package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class FriendsRemReqRequest extends J_Request {

	public FriendsRemReqRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_REM_REQ_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_REM_REQ;
	}

	/**
	 * @Title: accept
	 * @Description: 删除
	 * @return J_Request 返回类型
	 * @param @param uid 自己的uid
	 * @param @param fuid 好友的uid
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request remove(String uid, String fuid) {
		addParam(UtilRequest.FORM_UID, uid);
		addParam(UtilRequest.FORM_FUID, fuid);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
