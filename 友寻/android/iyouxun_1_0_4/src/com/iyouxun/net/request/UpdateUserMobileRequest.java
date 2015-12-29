package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 更改手机号
 * 
 * @ClassName: UpdateUserMobileRequest
 * @author likai
 * @date 2015-3-11 下午7:17:28
 * 
 */
public class UpdateUserMobileRequest extends J_Request {

	public UpdateUserMobileRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_USER_MOBILE_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_USER_MOBILE;
	}

	public J_Request execute(String oldMobile, String newMobile, String code) {
		addParam("old_mobile", oldMobile);
		addParam("mobile", newMobile);
		addParam("code", code);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
