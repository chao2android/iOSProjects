package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 解除第三方平台绑定
 * 
 * @ClassName: DeleteOpenPlatformBindRequest
 * @author likai
 * @date 2015-3-12 上午11:38:39
 * 
 */
public class DeleteOpenPlatformBindRequest extends J_Request {

	public DeleteOpenPlatformBindRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.DELETE_BIND_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_DELETE_BIND;
	}

	public J_Request execute(int openType) {
		addParam("type", openType + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
