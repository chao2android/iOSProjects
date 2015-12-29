package com.iyouxun.net.request;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.json.JSONObject;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.utils.SharedPreUtil;

/**
 * 更新用户信息
 * 
 * @ClassName: UpdateUserInfoRequest
 * @author likai
 * @date 2015-3-3 下午3:32:28
 * 
 */
public class UpdateUserInfoRequest extends J_Request {

	public UpdateUserInfoRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_USER_INFO_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_USER_INFO;
	}

	public J_Request execute(HashMap<String, String> params) {
		try {
			JSONObject json = new JSONObject();
			json.put("uid", SharedPreUtil.getLoginInfo().uid + "");

			Iterator iter = params.entrySet().iterator();
			while (iter.hasNext()) {
				Map.Entry entry = (Map.Entry) iter.next();
				String key = entry.getKey().toString();
				String val = entry.getValue().toString();
				json.put(key, val);
			}

			addParam("fields", json.toString());
		} catch (Exception e) {
			e.printStackTrace();
		}

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
