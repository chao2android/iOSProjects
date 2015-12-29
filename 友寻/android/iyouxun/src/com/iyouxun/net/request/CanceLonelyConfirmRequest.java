/**
 * 
 * @Package com.iyouxun.net.request
 * @author likai
 * @date 2015-5-6 上午10:07:06
 * @version V1.0
 */
package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 取消确认单身
 * 
 * @author likai
 * @date 2015-5-6 上午10:07:06
 * 
 */
public class CanceLonelyConfirmRequest extends J_Request {
	/**
	 * Title: Description:
	 * 
	 * @param callBack
	 */
	public CanceLonelyConfirmRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.CANCEL_LONELY_CONFIRM_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_CANCEL_LONELY_CONFIRM;
	}

	public J_Request execute(long friend_uid) {
		addParam("friend_uid", friend_uid + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
