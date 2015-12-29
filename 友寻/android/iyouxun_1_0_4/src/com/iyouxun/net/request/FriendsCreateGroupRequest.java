package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class FriendsCreateGroupRequest extends J_Request {

	public FriendsCreateGroupRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_CREATE_GROUP_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_CREATE_GROUP;
	}

	/**
	 * @Title: create
	 * @Description: 创建好友分组
	 * @return J_Request 返回类型
	 * @param @param uid 当前用户id
	 * @param @param groupName 分组名称
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request create(String uid, String groupName) {
		addParam(UtilRequest.FORM_UID, uid);
		addParam(UtilRequest.FORM_GROUP_NAME, groupName);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
