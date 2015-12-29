package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class FriendsAddGroupMemebersRequest extends J_Request {

	public FriendsAddGroupMemebersRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_ADD_GROUP_MEMBERS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_ADD_GROUP_MEMBERS;
	}

	/**
	 * @Title: add
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @return J_Request 返回类型
	 * @param @param uid 当前用户id
	 * @param @param fuid 好友uid
	 * @param @param groupId 分组id
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request add(String uid, String fuid, String groupId) {
		addParam(UtilRequest.FORM_UID, uid);
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		addParam(UtilRequest.FORM_FUID_ARR, fuid);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
