package com.iyouxun.net.request;

import org.json.JSONObject;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取共同好友列表
 * 
 * @ClassName: FriendsGetMutualFriendsRequest
 * @author likai
 * @date 2015-3-30 下午8:36:02
 * 
 */
public class FriendsGetMutualFriendsRequest extends J_Request {

	public FriendsGetMutualFriendsRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_GET_MUTUALFRIENDS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_GET_MUTUALFRIENDS;
	}

	public J_Request execute(String uid, String fuid, int start, int num, int sex, int marriage) {
		addParam("uid", uid);
		addParam("fuid", fuid);
		addParam("start", start + "");
		addParam("num", num + "");
		// 如果两个参数都是“不限”，就不传递该参数
		if (sex != 2 || marriage != 0) {
			try {
				JSONObject json = new JSONObject();
				if (sex != 2) {
					json.put("sex", sex);
				}
				if (marriage != 0) {
					json.put("marriage", marriage);
				}
				addParam("condition", json.toString());
			} catch (Exception e) {
				e.printStackTrace();
			}
		}

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
