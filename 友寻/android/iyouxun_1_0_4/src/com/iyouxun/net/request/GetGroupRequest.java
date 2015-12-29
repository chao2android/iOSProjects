package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取某一分组的详细信息
 * 
 * @ClassName: GetGroupRequest
 * @author likai
 * @date 2015-3-30 下午5:24:09
 * 
 */
public class GetGroupRequest extends J_Request {

	public GetGroupRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_GROUP_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_GROUP;
	}

	public J_Request execute(int group_id) {
		addParam("group_id", group_id + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
