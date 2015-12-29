package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class UpdateGroupTitleRequest extends J_Request {

	public UpdateGroupTitleRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_GROUP_TITLE_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_GROUP_TITLE;
	}

	public J_Request update(String groupId, String title) {
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		addParam(UtilRequest.FORM_TITLE, title);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
