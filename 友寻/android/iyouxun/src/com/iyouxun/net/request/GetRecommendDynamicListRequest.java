package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取动态列表
 * 
 * @ClassName: GetRecommendDynamicListRequest
 * @author likai
 * @date 2015-3-19 下午2:03:15
 * 
 */
public class GetRecommendDynamicListRequest extends J_Request {

	public GetRecommendDynamicListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_RECOMMEND_DYNAMIC_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_RECOMMEND_DYNAMIC_LIST;
	}

	public J_Request execute(int dy_id, int num, int is_single) {
		addParam("dy_id", dy_id + "");
		addParam("num", num + "");
		addParam("is_single", is_single + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
