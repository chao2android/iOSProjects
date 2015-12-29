package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 删除图片
 * 
 * @ClassName: DeletePhotoRequest
 * @author likai
 * @date 2015-3-4 下午4:09:48
 * 
 */
public class DeletePhotoRequest extends J_Request {

	public DeletePhotoRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.DELETE_PHOTO_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_DELETE_PHOTO;
	}

	public J_Request execute(String pid) {
		addParam("pid", pid);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
