package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 举报用户资料
 * 
 * 
 * @ClassName: ReportProfileRequest
 * @author likai
 * @date 2015-3-10 下午3:09:12
 * 
 */
public class ReportProfileRequest extends J_Request {

	public ReportProfileRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.REPORT_PROFILE_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_REPORT_PROFILE;
	}

	/**
	 * 
	 * @Title: execute
	 * @return J_Request 返回类型
	 * @param uid
	 * @param type- 0-骚扰信息、1-虚假资料、2-不良照片、3-反动政治、4-欺诈骗钱
	 * @author likai
	 * @throws
	 */
	public J_Request execute(String uid, int type) {
		addParam("uid", uid);
		addParam("type", type + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
