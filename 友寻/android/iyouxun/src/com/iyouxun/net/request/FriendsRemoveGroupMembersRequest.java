package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class FriendsRemoveGroupMembersRequest extends J_Request {

	public FriendsRemoveGroupMembersRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_REMOVE_GROUP_MEMBERS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_REMOVE_GROUP_MEMBERS;
	}

	/**
	 * @Title: remove
	 * @Description: 删除分组成员
	 * @return J_Request 返回类型
	 * @param @param uid 用户uid
	 * @param @param fuid 好友id
	 * @param @param groupId 分组id
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request remove(String uid, String fuid, String groupId) {
		addParam(UtilRequest.FORM_UID, uid);
		addParam(UtilRequest.FORM_FUID, fuid);
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
