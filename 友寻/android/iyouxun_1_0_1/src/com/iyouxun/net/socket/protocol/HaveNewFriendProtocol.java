package com.iyouxun.net.socket.protocol;

import org.json.JSONException;
import org.json.JSONObject;

import com.iyouxun.J_Application;
import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.utils.JsonUtil;

public class HaveNewFriendProtocol extends AbsPushProtocol {
	/**
	 * {"uid":1001850,"nick":"孙悟空1111111111112","avatars":
	 * "http:\/\/p.friendly.dev\/00\/18\/cdbab7aed89c28c9a7554a688f98e0a6\/84250100a.jpg?wh=100x100","proname":"友寻","uname":"个头","cmd":319,"timer":1432260534,"pushtype":"text","description":"个头加入了友寻","msgco
	 * u n t " : 2 }
	 */
	@Override
	public SocketProtocol getResponseObj(JSONObject json) throws JSONException {
		bean = new PushMsgInfo();
		bean.cmd = json.optInt(KEY_CMD);
		bean.nick = JsonUtil.getJsonString(json, UtilRequest.FORM_NICK);
		bean.uid = json.optLong(UtilRequest.FORM_UID);
		bean.time = json.optLong(UtilRequest.FORM_TIMER);
		bean.pushtype = JsonUtil.getJsonString(json, UtilRequest.FORM_PUSH_TYPE);
		int msgcount = json.optInt(UtilRequest.FORM_MSG_COUNT, 0);
		if (msgcount >= 5) {
			bean.contentText = "你有" + msgcount + "个新好友";
		} else {
			bean.contentText = bean.nick + "加入了友寻";
		}
		bean.nick = "新好友加入";
		bean.msgCount = msgcount;
		bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_AVATARS);
		if ((J_Application.isInAppStatus && bean.cmd == 318) || (!J_Application.isInAppStatus && bean.cmd == 319)
				|| msgcount >= 5) {
			// 应用内直接显示 应用外 时间：每日10：00，15：00，19：00，22：00或者新好友数量大于5条
			return this;
		} else {
			return null;
		}
	}
}
