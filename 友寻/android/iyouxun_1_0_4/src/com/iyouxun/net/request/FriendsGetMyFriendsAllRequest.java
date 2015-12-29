package com.iyouxun.net.request;

import org.json.JSONObject;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class FriendsGetMyFriendsAllRequest extends J_Request {

	public FriendsGetMyFriendsAllRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.FRIENDS_GET_MY_FRIENDS_ALL_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS_ALL;
	}

	/**
	 * @Title: get
	 * @Description: 获得好友列表
	 * @return J_Request 返回类型
	 * @param uid 用户id
	 * @param start 起始位置
	 * @param nums 请求数量
	 * @param sex 搜索的性别
	 * @param marriage 搜索的情感状态
	 * @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request get(String uid, int start, int nums, int sex, int marriage) {
		addParam(UtilRequest.FORM_UID, uid);
		addParam(UtilRequest.FORM_START, start + "");
		addParam(UtilRequest.FORM_NUMS, nums + "");

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
