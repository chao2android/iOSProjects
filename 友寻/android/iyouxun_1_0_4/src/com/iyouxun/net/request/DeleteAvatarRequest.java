package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 删除头像
 * 
 * @ClassName: DeleteAvatarRequest
 * @author likai
 * @date 2015-3-9 下午2:39:16
 * 
 */
public class DeleteAvatarRequest extends J_Request {

	public DeleteAvatarRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.DELETE_AVATAR_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_DELETE_AVATAR;
	}

	public J_Request execute(String pid) {
		addParam("pid", pid);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}

}
