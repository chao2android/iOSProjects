package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class SendOnreadByOidRequest extends J_Request {

	public SendOnreadByOidRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.SEND_ONREAD_BY_OID_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_SEND_ONREAD_BY_OID;
	}

	public J_Request send(String oid) {
		addParam(UtilRequest.FORM_OID, oid);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
