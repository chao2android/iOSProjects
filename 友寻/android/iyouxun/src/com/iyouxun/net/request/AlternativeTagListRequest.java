/**
 * 
 * @Package com.iyouxun.net.request
 * @author likai
 * @date 2015-7-1 上午10:02:06
 * @version V1.0
 */
package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.utils.SharedPreUtil;

/**
 * 获取推荐标签列表
 * 
 * @author likai
 * @date 2015-7-1 上午10:02:06
 * 
 */
public class AlternativeTagListRequest extends J_Request {

	/**
	 * 获取推荐标签列表
	 * 
	 * @param callBack
	 */
	public AlternativeTagListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.ALTERNATIVE_TAG_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_ALTERNATIVE_TAG_LIST;
	}

	public J_Request execute() {
		addParam("sex", SharedPreUtil.getLoginInfo().sex + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}

}
