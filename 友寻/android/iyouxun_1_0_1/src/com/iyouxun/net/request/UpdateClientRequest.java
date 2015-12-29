package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.utils.Util;

/**
 * 更新app
 * 
 * @author likai
 * @date 2015-4-22 上午11:56:01
 * 
 */
public class UpdateClientRequest extends J_Request {
	public UpdateClientRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_CLIENT_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_CLIENT;
	}

	public J_Request execute() {
		String deviceid = Util.getDeviceIMEI();
		int version = Util.getAppVersionCode();
		String channelid = Util.getChannelId();
		String clientid = Util.getClientId();

		addParam("deviceid", deviceid);
		addParam("version", version + "");
		addParam("channelid", channelid);
		addParam("clientid", clientid);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
