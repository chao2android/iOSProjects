package com.iyouxun.net.socket.protocol;

import org.json.JSONException;
import org.json.JSONObject;

import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.utils.JsonUtil;

/**
 * @ClassName: NewTagProtocol
 * @Description: 给我贴标签
 * @author donglizhi
 * @date 2015年4月23日 上午10:48:58
 * 
 */
public class NewTagProtocol extends AbsPushProtocol {
	/**
	 * {"uid":2091950,"nick":"黑乎乎","avatars":
	 * "http:\/\/p.friendly.dev\/09\/19\/07d80dfe7279d4c584cd33fb8aec3763\/47750100a.jpg?wh=10
	 * 0 x 1 0 0
	 * " , "name":"废话v不","cmd":316,"timer":1429757509,"pushtype":"text",
	 * "description":"给你打了新的标签","msgcount":5 }
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
		String name = JsonUtil.getJsonString(json, UtilRequest.FORM_NAME);
		if (msgcount >= 5) {
			bean.contentText = "你有" + msgcount + "个新标签";
		} else {
			bean.contentText = bean.nick + "给你打了新标签 " + name;
		}
		bean.groupId = json.optInt(UtilRequest.FORM_GROUP_ID);
		bean.msgCount = msgcount;
		bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_AVATARS);
		return this;
	}

}
