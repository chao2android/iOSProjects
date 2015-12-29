package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 转播一条动态
 * 
 * @ClassName: RebroadcastDynamicRequest
 * @author likai
 * @date 2015-3-19 下午2:22:25
 * 
 */
public class RebroadcastDynamicRequest extends J_Request {

	public RebroadcastDynamicRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.REBROADCAST_DYNAMIC_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_REBROADCAST_DYNAMIC;
	}

	public J_Request execute(int dy_id, long oid) {
		addParam("dy_id", dy_id + "");
		addParam("oid", oid + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
