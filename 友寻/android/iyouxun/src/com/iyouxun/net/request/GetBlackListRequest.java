package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取黑名单列表
 * 
 * @author likai
 * @date 2015-3-26 下午1:58:09
 * 
 */
public class GetBlackListRequest extends J_Request {

	public GetBlackListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_BLACKLIST_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_BLACKLIST_LIST;
	}

	public J_Request execute(int page, int pageSize) {
		addParam("uid", J_Cache.sLoginUser.uid + "");
		addParam("page", page + "");
		addParam("nums", pageSize + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
