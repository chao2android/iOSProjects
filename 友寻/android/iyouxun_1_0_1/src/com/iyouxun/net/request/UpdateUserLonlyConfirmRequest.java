package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 确认单身
 * 
 * @ClassName: UpdateUserLonlyConfirmRequest
 * @author likai
 * @date 2015-3-5 上午11:37:46
 * 
 */
public class UpdateUserLonlyConfirmRequest extends J_Request {

	public UpdateUserLonlyConfirmRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_USER_LONELY_CONFIRM_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_USER_LONELY_CONFIRM;
	}

	public J_Request execute(String uid) {
		addParam("friend_uid", uid);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
