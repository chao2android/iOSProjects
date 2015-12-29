package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class GroupMasterDelPersonRequest extends J_Request {

	public GroupMasterDelPersonRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GROUP_MASTER_DEL_PERSON_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GROUP_MASTER_DEL_PERSON;
	}

	/**
	 * @Title: del
	 * @Description: 群主踢人
	 * @return J_Request 返回类型
	 * @param @param touid 被踢uid
	 * @param @param groupId 群组id
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request del(String touid, String groupId) {
		addParam(UtilRequest.FORM_TO_UID, touid);
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
