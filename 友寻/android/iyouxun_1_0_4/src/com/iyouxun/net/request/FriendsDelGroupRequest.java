package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class FriendsDelGroupRequest extends J_Request {

	public FriendsDelGroupRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_DEL_GROUP_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_DEL_GROUP;
	}

	/**
	 * @Title: del
	 * @Description: 删除好友分组
	 * @return J_Request 返回类型
	 * @param @param uid 当前用户uid
	 * @param @param groupId 分组id
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request del(String uid, String groupId) {
		addParam(UtilRequest.FORM_UID, uid);
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
