package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 赞一条动态
 * 
 * @ClassName: SendPraiseRequest
 * @author likai
 * @date 2015-3-19 下午2:15:43
 * 
 */
public class SendPraiseRequest extends J_Request {

	public SendPraiseRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.SEND_PRAISE_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_SEND_PRAISE;
	}

	public J_Request execute(long oid, int dy_id) {
		addParam("oid", oid + "");
		addParam("dy_id", dy_id + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
