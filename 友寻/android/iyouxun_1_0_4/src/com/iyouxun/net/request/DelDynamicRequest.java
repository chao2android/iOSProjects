package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 删除一条动态
 * 
 * @ClassName: DelDynamicRequest
 * @author likai
 * @date 2015-3-19 下午2:11:47
 * 
 */
public class DelDynamicRequest extends J_Request {

	public DelDynamicRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.DEL_DYNAMIC_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_DEL_DYNAMIC;
	}

	public J_Request execute(String dy_id) {
		addParam("dy_id", dy_id);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
