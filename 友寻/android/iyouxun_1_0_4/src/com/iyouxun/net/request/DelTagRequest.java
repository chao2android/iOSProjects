package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 删除标签
 * 
 * @ClassName: DelTagRequest
 * @author likai
 * @date 2015-3-17 下午5:31:28
 * 
 */
public class DelTagRequest extends J_Request {

	public DelTagRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.DEL_TAG_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_DEL_TAG;
	}

	public J_Request execute(String tids) {
		addParam("tids", tids);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
