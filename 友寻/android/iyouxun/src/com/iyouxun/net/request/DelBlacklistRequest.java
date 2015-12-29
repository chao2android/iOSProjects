package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 删除黑名单好友
 * 
 * @author likai
 * @date 2015-3-26 上午11:49:46
 * 
 */
public class DelBlacklistRequest extends J_Request {

	public DelBlacklistRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.DEL_BLACKLIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_DEL_BLACKLIST;
	}

	public J_Request execute(long toUid) {
		addParam("uid", J_Cache.sLoginUser.uid + "");
		addParam("fuid", toUid + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
