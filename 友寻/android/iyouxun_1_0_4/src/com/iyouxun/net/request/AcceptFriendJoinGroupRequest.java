package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class AcceptFriendJoinGroupRequest extends J_Request {

	public AcceptFriendJoinGroupRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.ACCEPT_FRIEND_JOIN_GROUP_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_ACCEPT_FRIEND_JOIN_GROUP;
	}

	/**
	 * @Title: accept
	 * @Description: 接受或拒绝好友加入群(只有群主操作)
	 * @return J_Request 返回类型
	 * @param @param groupId 群组id
	 * @param @param uid 申请人id
	 * @param @param type 0-未做处理 1-通过， 2-不通过
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request accept(String groupId, String uid, int type, int postion) {
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		addParam(UtilRequest.FORM_TO_UID, uid);
		addParam(UtilRequest.FORM_TYPE, type + "");
		this.CHAT_TABLE_ID = postion;
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
