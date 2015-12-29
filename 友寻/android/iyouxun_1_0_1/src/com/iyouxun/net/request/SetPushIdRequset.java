package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class SetPushIdRequset extends J_Request {

	public SetPushIdRequset(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.SET_PUSH_ID;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_SET_PUSH_ID;
	}

	public J_Request set(String pushid, String channelid) {
		addParam(UtilRequest.FORM_PUSH_ID, pushid);
		addParam(UtilRequest.FORM_CHANNEL_ID, channelid);
		addParam(UtilRequest.FORM_DEVICE_TYPE, "3");// 3android ios4
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
