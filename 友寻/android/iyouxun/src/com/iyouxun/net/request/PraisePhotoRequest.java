/**
 * 
 * @Package com.iyouxun.net.request
 * @author likai
 * @date 2015-7-1 下午6:02:44
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
 * 赞照片
 * 
 * @author likai
 * @date 2015-7-1 下午6:02:44
 * 
 */
public class PraisePhotoRequest extends J_Request {

	/**
	 * 赞照片
	 * 
	 * @param callBack
	 */
	public PraisePhotoRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.PRAISE_PHOTO_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_PRAISE_PHOTO;
	}

	public J_Request execute(long fuid, String pid) {
		addParam("uid", SharedPreUtil.getLoginInfo().uid + "");
		addParam("fuid", fuid + "");
		addParam("photo_id", pid);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
