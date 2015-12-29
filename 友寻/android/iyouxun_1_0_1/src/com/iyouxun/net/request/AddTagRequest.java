package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 添加新标签
 * 
 * @ClassName: AddTagRequest
 * @author likai
 * @date 2015-3-17 下午5:28:48
 * 
 */
public class AddTagRequest extends J_Request {

	public AddTagRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.ADD_TAG_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_ADD_TAG;
	}

	public J_Request execute(String to_uid, String tag_name) {
		addParam("uid", to_uid);
		addParam("add_tag", tag_name);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}