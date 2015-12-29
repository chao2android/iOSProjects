package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取已经绑定的平台帐号列表
 * 
 * @ClassName: GetUserOauthsRequest
 * @author likai
 * @date 2015-3-12 上午10:43:03
 * 
 */
public class GetUserOauthsRequest extends J_Request {

	public GetUserOauthsRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_USER_OAUTHS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_USER_OAUTHS;
	}

	public J_Request execute(long uid) {
		addParam("uid", uid + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
