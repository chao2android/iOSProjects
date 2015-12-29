package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.utils.SharedPreUtil;

public class CountGroupRequest extends J_Request {

	public CountGroupRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.COUNT_GROUP_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_COUNT_GROUP;
	}

	public J_Request getCount() {
		addParam(UtilRequest.FORM_UID, SharedPreUtil.getLoginInfo().uid + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
