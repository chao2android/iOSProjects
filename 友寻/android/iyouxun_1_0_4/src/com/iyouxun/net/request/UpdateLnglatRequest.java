package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.location.J_LocationPoint;
import com.iyouxun.utils.SharedPreUtil;

/**
 * 更新用户坐标信息
 * 
 * @author likai
 * @date 2015-3-26 上午10:57:14
 * 
 */
public class UpdateLnglatRequest extends J_Request {

	public UpdateLnglatRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_LNGLAT_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_LNGLAT;
	}

	public J_Request execute() {
		J_LocationPoint location = SharedPreUtil.getLocation();

		addParam("uid", J_Cache.sLoginUser.uid + "");
		addParam("lng", location.getLongitude());
		addParam("lat", location.getLatitude());

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
