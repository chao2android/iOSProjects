package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class InviteFriendJoinGroupRequest extends J_Request {

	public InviteFriendJoinGroupRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.INVITE_FRIEND_JOIN_GROUP_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_INVITE_FRIEND_JOIN_GROUP;
	}

	/**
	 * @Title: invite
	 * @Description: 所有人可以邀请好友加入(一度)
	 * @return J_Request 返回类型
	 * @param @param oid 添加用户的uid
	 * @param @param groupId 群组id
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request invite(String oids, String groupId) {
		addParam(UtilRequest.FORM_OIDS, oids);
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		J_NetManager.getInstance().sendRequest(this);
		return this;

	}
}
