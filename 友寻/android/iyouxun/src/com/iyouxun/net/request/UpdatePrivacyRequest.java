package com.iyouxun.net.request;

import org.json.JSONObject;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.utils.SharedPreUtil;

/**
 * 更新隐私设置
 * 
 * @ClassName: UpdatePrivacyRequest
 * @author likai
 * @date 2015-3-10 下午1:31:03
 * 
 */
public class UpdatePrivacyRequest extends J_Request {

	public UpdatePrivacyRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_PRIVACY_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_PRIVACY;
	}

	public J_Request execute(String key, int value) {
		try {
			addParam("uid", SharedPreUtil.getLoginInfo().uid + "");
			JSONObject fields = new JSONObject();
			fields.put(key, value);
			addParam("fields", fields.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
