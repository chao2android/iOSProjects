package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class ClearCacheRequest extends J_Request {

	public ClearCacheRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.CLEAR_CACHE_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_CLEAR_CACHE;
	}

	public J_Request clear(String groupID) {
		addParam(UtilRequest.FORM_GROUP_ID, groupID);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}

}
