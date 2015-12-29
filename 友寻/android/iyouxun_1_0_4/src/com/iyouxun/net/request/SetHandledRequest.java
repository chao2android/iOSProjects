package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class SetHandledRequest extends J_Request {

	public SetHandledRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.SET_HANDLED_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_SET_HANDLED;
	}

	/**
	 * @Title: set
	 * @Description: 设置系统消息已处理
	 * @return J_Request 返回类型
	 * @param String $iid 消息id
	 * @param int $operate 操作类型 3接受 4拒绝
	 * @author donglizhi
	 * @throws
	 */
	public J_Request set(String iid, int operate) {
		addParam(UtilRequest.FORM_IID, iid);
		addParam(UtilRequest.FORM_OPERATE, operate + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
