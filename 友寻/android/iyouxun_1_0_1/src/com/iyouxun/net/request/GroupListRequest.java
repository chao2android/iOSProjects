package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取已加入的群组列表
 * 
 * @ClassName: GroupListRequest
 * @author likai
 * @date 2015-3-30 下午2:45:29
 * 
 */
public class GroupListRequest extends J_Request {

	public GroupListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GROUP_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GROUP_LIST;
	}

	public J_Request execute(String uid) {
		addParam("uid", uid);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
