package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class DelContactRequest extends J_Request {

	public DelContactRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.DEL_CONTACT_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_DEL_CONTACT;
	}

	/**
	 * @Title: del
	 * @Description: 删除联系人
	 * @return J_Request 返回类型
	 * @param @param oid 对方的oid
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request del(String oid) {
		addParam(UtilRequest.FORM_OID, oid);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
