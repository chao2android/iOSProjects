package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class IsGroupMemberRequest extends J_Request {

	public IsGroupMemberRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.IS_GROUP_MEMBER_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_IS_GROUP_MEMBER;
	}

	/**
	 * @Title: isGroupMember
	 * @Description: 是否是群成员
	 * @return J_Request 返回类型
	 * @param @param groupId 群组id
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request isGroupMember(String groupId) {
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
