package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取群组内成员列表
 * 
 * @author likai
 * @date 2015-3-31 下午6:03:21
 * 
 */
public class GroupUserListRequest extends J_Request {

	public GroupUserListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GROUP_USER_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GROUP_USER_LIST;
	}

	public J_Request execute(int group_id) {
		addParam("group_id", group_id + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
