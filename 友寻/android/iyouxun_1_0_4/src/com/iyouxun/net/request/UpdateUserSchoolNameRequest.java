package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 更新学校
 * 
 * @ClassName: UpdateUserSchoolNameRequest
 * @author likai
 * @date 2015-3-3 下午6:23:20
 * 
 */
public class UpdateUserSchoolNameRequest extends J_Request {

	public UpdateUserSchoolNameRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_USER_SCHOOL_NAME_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_USER_SCHOOL_NAME;
	}

	public J_Request execute(String value) {
		addParam("school_name", value);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}

}
