package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取用户隐私设置
 * 
 * @ClassName: GetPrivacyInfoRequest
 * @author likai
 * @date 2015-3-10 下午1:40:30
 * 
 */
public class GetPrivacyInfoRequest extends J_Request {

	public GetPrivacyInfoRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_PRIVACY_INFO_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_PRIVACY_INFO;
	}

	public J_Request execute(long uid) {
		addParam("uid", uid + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
