package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取单个用户发布过的动态列表
 * 
 * @ClassName: GetOneUserDynamicListRequest
 * @author likai
 * @date 2015-3-19 下午2:09:22
 * 
 */
public class GetOneUserDynamicListRequest extends J_Request {

	public GetOneUserDynamicListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_ONE_USER_DYNAMIC_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_ONE_USER_DYNAMIC_LIST;
	}

	public J_Request execute(long uid, int dy_id, int num) {
		addParam("uid", uid + "");
		addParam("dy_id", dy_id + "");
		addParam("num", num + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
