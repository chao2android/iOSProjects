package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 更换手机号：发送验证码
 * 
 * @ClassName: FindMobileGetCheckCodeRequest
 * @author likai
 * @date 2015-3-11 下午6:56:42
 * 
 */
public class FindMobileGetCheckCodeRequest extends J_Request {

	public FindMobileGetCheckCodeRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FIND_MOBILE_GET_CHECKCODE_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FIND_MOBILE_GET_CHECKCODE;
	}

	public J_Request execute(String phone) {
		addParam("mobile", phone);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}

}
