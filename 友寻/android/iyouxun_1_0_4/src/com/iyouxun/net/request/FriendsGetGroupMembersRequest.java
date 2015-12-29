package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class FriendsGetGroupMembersRequest extends J_Request {

	public FriendsGetGroupMembersRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_GET_GROUP_MEMBERS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_GET_GROUP_MEMBERS;
	}

	/**
	 * @Title: get
	 * @Description: 获得分组成员
	 * @return J_Request 返回类型
	 * @param @param uid 当前用户uid
	 * @param @param groupId 分组id
	 * @param @param start 起始位置
	 * @param @param nums 查询数量
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request get(String uid, String groupId, int start, int nums) {
		addParam(UtilRequest.FORM_UID, uid);
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		addParam(UtilRequest.FORM_START, start + "");
		addParam(UtilRequest.FORM_NUMS, nums + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
