/**
 * 
 * @Package com.iyouxun.net.request
 * @author likai
 * @date 2015-7-1 下午6:08:26
 * @version V1.0
 */
package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取照片被赞人员列表
 * 
 * @author likai
 * @date 2015-7-1 下午6:08:26
 * 
 */
public class GetPhotoPraiseListRequest extends J_Request {

	/**
	 * 获取照片被赞人员列表
	 * 
	 * @param callBack
	 */
	public GetPhotoPraiseListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_PHOTO_PRAISE_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_PHOTO_PRAISE_LIST;
	}

	public J_Request execute(long fuid, String pid, int start, int nums) {
		addParam("fuid", fuid + "");
		addParam("photo_id", pid);
		addParam("start", start + "");
		addParam("nums", nums + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
