package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取图片列表
 * 
 * @author likai
 * @date 2015-3-4 下午4:55:02
 * 
 */
public class GetPhotoListRequest extends J_Request {

	public GetPhotoListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_PHOTO_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_PHOTO_LIST;
	}

	public J_Request execute(long uid, String pid, int num) {
		addParam("uid", uid + "");
		addParam("pid", pid);
		addParam("pageSize", num + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
