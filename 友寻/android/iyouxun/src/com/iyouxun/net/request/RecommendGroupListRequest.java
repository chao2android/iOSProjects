package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class RecommendGroupListRequest extends J_Request {

	public RecommendGroupListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.RECOMMEND_GROUP_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_RECOMMEND_GROUP_LIST;
	}

	public J_Request get() {
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
