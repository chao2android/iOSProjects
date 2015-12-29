package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class DelMsgRequest extends J_Request {

	public DelMsgRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.DEL_MSG_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_DEL_MSG;
	}

	/**
	 * @Title: del
	 * @Description: 删除联系人消息
	 * @return J_Request 返回类型
	 * @param @param oid 联系人id
	 * @param @param iid 消息id
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request del(String oid, String iid) {
		addParam(UtilRequest.FORM_OID, oid);
		addParam(UtilRequest.FORM_IID, iid);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
