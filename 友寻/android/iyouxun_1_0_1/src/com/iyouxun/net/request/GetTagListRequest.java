package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取标签列表
 * 
 * @ClassName: GetTagListRequest
 * @author likai
 * @date 2015-3-17 下午5:34:32
 * 
 */
public class GetTagListRequest extends J_Request {

	public GetTagListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.TAG_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_TAG_LIST;
	}

	public J_Request execute(String uid) {
		addParam("uid", uid);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
