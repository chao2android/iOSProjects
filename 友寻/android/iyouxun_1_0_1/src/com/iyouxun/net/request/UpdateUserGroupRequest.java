package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class UpdateUserGroupRequest extends J_Request {

	public UpdateUserGroupRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_USER_GROUP_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_USER_GROUP;
	}

	/**
	 * 
	 * @Title: execute
	 * @return J_Request 返回类型
	 * @param uid
	 * @param group_id
	 * @param show 在资料页是否显示 0显示 1不显示
	 * @param hint 提醒 0 接受 1 不接受
	 * @param status 0正常 -1删除
	 * @return 参数类型
	 * @author likai
	 */
	public J_Request execute(long uid, int group_id, int show, int hint) {
		addParam("uid", uid + "");
		addParam("group_id", group_id + "");
		addParam("show", show + "");
		addParam("hint", hint + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
