package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取用户信息
 * 
 * @ClassName: GetUserInfoRequest
 * @author likai
 * @date 2015-3-3 上午11:40:39
 * 
 */
public class GetUserInfoRequest extends J_Request {

	public GetUserInfoRequest(OnDataBack callBack) {
		super(callBack);
		this.REQUEST_METHOD = J_Request.METHOD_GET;
		this.URL = NetConstans.GET_USER_INFO_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_USER_INFO;
	}

	public J_Request execute(String uid) {
		addParam("uid", uid);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
