package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 更新用户备注
 * 
 * @ClassName: UpdateUserMarkRequest
 * @author likai
 * @date 2015-3-18 下午4:53:20
 * 
 */
public class UpdateUserMarkRequest extends J_Request {

	public UpdateUserMarkRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_USER_MARK_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_USER_MARK;
	}

	public J_Request execute(String uid, String mark) {
		addParam("uid", uid);
		addParam("mark", mark);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
