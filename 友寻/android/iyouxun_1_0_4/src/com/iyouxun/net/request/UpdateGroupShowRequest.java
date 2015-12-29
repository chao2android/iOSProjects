package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class UpdateGroupShowRequest extends J_Request {

	public UpdateGroupShowRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_GROUP_SHOW_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_GROUP_SHOW;
	}

	/**
	 * @Title: update
	 * @Description: 修改用户群在资料页显示状态
	 * @return J_Request 返回类型
	 * @param @param groupId
	 * @param @param show
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request update(String groupId, int show) {
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		addParam(UtilRequest.FORM_SHOW, show + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
