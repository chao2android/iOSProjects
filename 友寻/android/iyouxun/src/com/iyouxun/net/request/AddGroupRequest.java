package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 申请加入一个群组
 * 
 * @ClassName: AddGroupRequest
 * @author likai
 * @date 2015-3-30 下午3:26:24
 * 
 */
public class AddGroupRequest extends J_Request {

	public AddGroupRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.ADD_GROUP_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_ADD_GROUP;
	}

	public J_Request execute(int group_id, String touid) {
		addParam("group_id", group_id + "");
		addParam("touid", touid);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
