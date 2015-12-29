package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class IgnoreSysRequest extends J_Request {

	public IgnoreSysRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.IGNORE_SYS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_IGNORE_SYS;
	}

	public J_Request ignore(String oid) {
		addParam(UtilRequest.FORM_OID, oid);
		addParam(UtilRequest.FORM_TYPE, "addfriend");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
