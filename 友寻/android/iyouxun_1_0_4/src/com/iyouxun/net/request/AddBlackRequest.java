package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 添加黑名单用户
 * 
 * @ClassName: AddBlackRequest
 * @author likai
 * @date 2015-3-30 下午7:45:45
 * 
 */
public class AddBlackRequest extends J_Request {

	public AddBlackRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.ADD_BLACK_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_ADD_BLACK;
	}

	public J_Request execute(String uid, String fuid) {
		addParam("uid", uid);
		addParam("fuid_arr", fuid);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
