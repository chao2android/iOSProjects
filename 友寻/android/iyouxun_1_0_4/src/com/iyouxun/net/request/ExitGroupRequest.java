package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class ExitGroupRequest extends J_Request {

	public ExitGroupRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.EXIT_GROUP_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_EXIT_GROUP;
	}

	/**
	 * @Title: exit
	 * @Description: 退出群组
	 * @return J_Request 返回类型
	 * @param @param groupId
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request exit(int groupId) {
		addParam(UtilRequest.FORM_GROUP_ID, groupId + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
