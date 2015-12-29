package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class FriendsModGroupRequest extends J_Request {

	public FriendsModGroupRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_MOD_GROUP_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_MOD_GROUP;
	}

	/**
	 * @Title: mod
	 * @Description: 修改分组名称
	 * @return J_Request 返回类型
	 * @param @param uid 用户id
	 * @param @param groupId 分组id
	 * @param @param groupName 分组名
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request mod(String uid, String groupId, String groupName) {
		addParam(UtilRequest.FORM_UID, uid);
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		addParam(UtilRequest.FORM_GROUP_NAME, groupName);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
