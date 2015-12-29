package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 点击标签
 * 
 * @ClassName: TagClickRequest
 * @author likai
 * @date 2015-3-17 下午5:32:43
 * 
 */
public class TagClickRequest extends J_Request {

	public TagClickRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.TAG_CLICK_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_TAG_CLICK;
	}

	public J_Request execute(String to_uid, String tid) {
		addParam("uid", to_uid);
		addParam("tid", tid);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
