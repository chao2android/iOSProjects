package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取推荐用户列表
 * 
 * @ClassName: GetRecommendNewUsersRequest
 * @author likai
 * @date 2015-3-31 上午10:47:33
 * 
 */
public class GetRecommendNewUsersRequest extends J_Request {

	public GetRecommendNewUsersRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_RECOMMEND_NEW_USERS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_RECOMMEND_NEW_USERS;
	}

	public J_Request execute(int page, int pagesize) {
		addParam("page", page + "");
		addParam("pagesize", pagesize + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
