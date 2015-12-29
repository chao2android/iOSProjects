/**
 * 
 * @Package com.iyouxun.net.request
 * @author likai
 * @date 2015-5-18 下午6:45:25
 * @version V1.0
 */
package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 
 * @author likai
 * @date 2015-5-18 下午6:45:25
 * 
 */
public class FriendsGetFriendsAllRequest extends J_Request {

	/**
	 * Title: Description:
	 * 
	 * @param callBack
	 */
	public FriendsGetFriendsAllRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_GET_FRIENDS_ALL_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_ALL;
	}

	public J_Request execute(long uid, int start, int nums) {
		addParam("uid", uid + "");
		addParam("start", start + "");
		addParam("nums", nums + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
