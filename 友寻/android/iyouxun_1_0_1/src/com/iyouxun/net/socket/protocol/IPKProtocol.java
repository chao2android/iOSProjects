package com.iyouxun.net.socket.protocol;

import org.json.JSONObject;

import com.iyouxun.data.beans.socket.PushMsgInfo;

/** 挑战好友的结果 推送 */
public class IPKProtocol extends AbsPushProtocol {

	/**
	 * @Fields serialVersionUID
	 */
	private static final long serialVersionUID = 3800130438144961886L;

	@Override
	public SocketProtocol getResponseObj(JSONObject json) {

		bean = new PushMsgInfo();
		bean.cmd = json.optInt(KEY_CMD);
		json = json.optJSONObject(KEY_DATA);
		bean.nick = json.optString("nick");
		bean.sex = json.optInt("sex");
		bean.uid = json.optLong("from");
		bean.qid = json.optInt("qid");
		bean.time = json.optInt("timer");
		bean.pushtype = json.optString("pushtype");
		bean.contentText = json.optString("description");

		return this;
	}
}
