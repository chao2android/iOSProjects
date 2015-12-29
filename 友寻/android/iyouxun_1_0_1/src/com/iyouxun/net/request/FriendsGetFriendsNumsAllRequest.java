/**
 * 
 * @Package com.iyouxun.net.request
 * @author likai
 * @date 2015-5-18 下午7:21:01
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
 * @date 2015-5-18 下午7:21:01
 * 
 */
public class FriendsGetFriendsNumsAllRequest extends J_Request {

	/**
	 * Title: Description:
	 * 
	 * @param callBack
	 */
	public FriendsGetFriendsNumsAllRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_GET_FRIENDSNUMS_ALL_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_GET_FRIENDSNUMS_ALL;
	}

	public J_Request execute(long uid) {
		addParam("uid", uid + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
