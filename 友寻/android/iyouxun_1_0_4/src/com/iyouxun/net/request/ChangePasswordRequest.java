package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 修改密码
 * 
 * @ClassName: ChangePasswordRequest
 * @author likai
 * @date 2015-3-11 上午10:04:36
 * 
 */
public class ChangePasswordRequest extends J_Request {

	public ChangePasswordRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.CHANGE_PASSWORD_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_CHANGE_PASSWORD;
	}

	public J_Request execute(String oldPwd, String newPwd) {
		addParam("current", oldPwd);
		addParam("new", newPwd);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
