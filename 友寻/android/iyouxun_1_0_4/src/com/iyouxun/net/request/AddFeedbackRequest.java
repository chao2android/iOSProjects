/**
 * 
 * @Package com.iyouxun.net.request
 * @author likai
 * @date 2015-5-15 下午3:54:27
 * @version V1.0
 */
package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 意见反馈
 * 
 * @author likai
 * @date 2015-5-15 下午3:54:27
 * 
 */
public class AddFeedbackRequest extends J_Request {

	/**
	 * Title: Description:
	 * 
	 * @param callBack
	 */
	public AddFeedbackRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.ADD_FEEDBACK_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_ADD_FEEDBACK;
	}

	public J_Request execute(String content) {
		addParam("content", content);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
