package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 举报图片
 * 
 * @ClassName: ReportPicRequest
 * @author likai
 * @date 2015-3-10 下午3:05:26
 * 
 */
public class ReportPicRequest extends J_Request {

	public ReportPicRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.REPORT_PIC_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_REPORT_PIC;
	}

	/**
	 * 
	 * @Title: execute
	 * @return J_Request 返回类型
	 * @param uid
	 * @param pid
	 * @param type 0-色情图片、1-反动图片、2-侵权冒用、3-广告欺诈
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public J_Request execute(String uid, String pid, int type) {
		addParam("uid", uid);
		addParam("pid", pid);
		addParam("type", type + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
