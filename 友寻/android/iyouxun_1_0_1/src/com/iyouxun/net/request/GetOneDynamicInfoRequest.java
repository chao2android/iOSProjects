package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取单个动态信息
 * 
 * @author likai
 * @date 2015-3-24 下午1:38:43
 * 
 */
public class GetOneDynamicInfoRequest extends J_Request {

	public GetOneDynamicInfoRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_ONE_DYNAMIC_INFO_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_ONE_DYNAMIC_INFO;
	}

	public J_Request execute(int dy_id) {
		addParam("dy_id", dy_id + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
