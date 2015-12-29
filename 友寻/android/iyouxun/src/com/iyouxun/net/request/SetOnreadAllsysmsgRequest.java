package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 全部消息置为已读
 * 
 * @ClassName: SetOnreadAllsysmsgRequest
 * @author likai
 * @date 2015-3-26 上午11:05:26
 * 
 */
public class SetOnreadAllsysmsgRequest extends J_Request {

	public SetOnreadAllsysmsgRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.SET_ONREAD_ALLSYSMSG_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_SET_ONREAD_ALLSYSMSG;
	}

	public J_Request execute(String type) {
		addParam("type", type);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
