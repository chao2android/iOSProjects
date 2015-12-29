package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class IsExistPhotoRequest extends J_Request {

	public IsExistPhotoRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.IS_EXIST_PHOTO_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_IS_EXIST_PHOTO;
	}

	/**
	 * @Title: isExist
	 * @Description: 验证生活照是否存在
	 * @return J_Request 返回类型
	 * @param @param pid 图片id
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request isExist(String pid) {
		addParam(UtilRequest.FORM_PID, pid);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}

}
