package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class FriendsGetGroupListRequest extends J_Request {

	public FriendsGetGroupListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_GET_GROUP_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_GET_GROUP_LIST;
	}

	/**
	 * @Title: get
	 * @Description: 获得好友分组列表
	 * @return J_Request 返回类型
	 * @param @param uid 当前用户id
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request get(String uid) {
		addParam(UtilRequest.FORM_UID, uid);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}

}
