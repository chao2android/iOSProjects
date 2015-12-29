package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 取消一条赞动态
 * 
 * @ClassName: DelPraiseRequest
 * @author likai
 * @date 2015-3-19 下午2:19:47
 * 
 */
public class DelPraiseRequest extends J_Request {

	public DelPraiseRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.DEL_PRAISE_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_DEL_PRAISE;
	}

	public J_Request execute(long oid, int dy_id) {
		addParam("oid", oid + "");
		addParam("dy_id", dy_id + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
