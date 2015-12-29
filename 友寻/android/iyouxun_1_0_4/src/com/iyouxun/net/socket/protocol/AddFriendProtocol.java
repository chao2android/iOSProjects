package com.iyouxun.net.socket.protocol;

import org.json.JSONException;
import org.json.JSONObject;

import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.utils.JsonUtil;

/**
 * @ClassName: AddFriendProtocol
 * @Description: 好友申请
 * @author donglizhi
 * @date 2015年4月23日 下午2:16:56
 * 
 */
public class AddFriendProtocol extends AbsPushProtocol {
	/**
	 * {"uid":2095350,"nick":"天字第二号","avatars":
	 * "http:\/\/p.friendly.dev\/09\/53\/70bcb455ccb58ce525ef50c9d73dc397\/113250100a.jpg?wh=100
	 * x 1 0 0
	 * " , "privonce":"0","city":"0","friendlists":["黑乎乎"],"cmd":317,"timer":
	 * 1429769307,"pushtype":"text","description":"天字第二号申请成为你的好友","msgcount":3 }
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
			bean.contentText = "你有" + msgcount + "个好友申请";
		} else {
			bean.contentText = bean.nick + "申请成为你的好友";
		}
		bean.groupId = json.optInt(UtilRequest.FORM_GROUP_ID);
		bean.msgCount = msgcount;
		bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_AVATARS);
		return this;
	}

}
