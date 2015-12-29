package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class DelPushIdRequset extends J_Request {

	public DelPushIdRequset(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.DEL_PUSH_ID;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_DEL_PUSH_ID;
	}

	public J_Request del(String pushid) {
		addParam(UtilRequest.FORM_PUSH_ID, pushid);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
