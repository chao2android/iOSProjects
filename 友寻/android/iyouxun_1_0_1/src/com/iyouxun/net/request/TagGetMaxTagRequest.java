package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class TagGetMaxTagRequest extends J_Request {

	public TagGetMaxTagRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.TAG_GET_MAX_TAGS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_TAG_GET_MAX_TAGS;
	}

	public J_Request get() {
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
