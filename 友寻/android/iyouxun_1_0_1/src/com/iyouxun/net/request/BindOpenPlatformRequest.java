package com.iyouxun.net.request;

import org.json.JSONObject;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 绑定第三方帐号
 * 
 * @ClassName: BindOpenPlatformRequest
 * @author likai
 * @date 2015-3-12 下午2:12:46
 * 
 */
public class BindOpenPlatformRequest extends J_Request {
	public BindOpenPlatformRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.BIND_OPEN_PLATFORM_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_BIND_OPEN_PLATFORM;
	}

	public J_Request execute(String openId, int openType, String accessToken, long expiresIn) {
		try {
			JSONObject json = new JSONObject();
			json.put("expires_in", expiresIn);
			json.put("openid", openId);
			json.put("access_token", accessToken);
			json.put("openid_type", openType);
			json.put("refresh_token", accessToken);

			addParam("dat", json.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
