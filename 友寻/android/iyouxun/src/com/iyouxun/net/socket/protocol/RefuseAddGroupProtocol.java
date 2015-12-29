package com.iyouxun.net.socket.protocol;

import org.json.JSONException;
import org.json.JSONObject;

import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.utils.JsonUtil;

/**
 * @ClassName: RefuseAddGroupProtocol
 * @Description: 谢绝加入群组
 * @author donglizhi
 * @date 2015年4月22日 下午6:23:38
 * 
 */
public class RefuseAddGroupProtocol extends AbsPushProtocol {
	/**
	 * {"uid":2091950,"nick":"黑乎乎","avatars":
	 * "http:\/\/p.friendly.dev\/09\/19\/07d80dfe7279d4c584cd33fb8aec3763\/47750100a.jpg?wh=100x10
	 * 0 " , "group_id":11050,"title":"干活就哭、kevin","cmd":308,"timer":1429698266,
	 * "pushtype":"text","description":null,"msgcount":6 }
	 */
	@Override
	public SocketProtocol getResponseObj(JSONObject json) throws JSONException {
		bean = new PushMsgInfo();
		bean.cmd = json.optInt(KEY_CMD);
		bean.nick = JsonUtil.getJsonString(json, UtilRequest.FORM_NICK);
		bean.uid = json.optLong(UtilRequest.FORM_UID);
		bean.time = json.optLong(UtilRequest.FORM_TIMER);
		bean.pushtype = JsonUtil.getJsonString(json, UtilRequest.FORM_PUSH_TYPE);
		String title = JsonUtil.getJsonString(json, UtilRequest.FORM_TITLE);
		int msgcount = json.optInt(UtilRequest.FORM_MSG_COUNT, 0);
		if (msgcount >= 5) {
			bean.contentText = "你的入群申请未通过 ( " + msgcount + " )";
			bean.nick = "入群申请";
		} else {
			bean.contentText = bean.nick + "谢绝你加入 " + title;
		}
		bean.groupId = json.optInt(UtilRequest.FORM_GROUP_ID);
		bean.msgCount = msgcount;
		bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_AVATARS);
		return this;
	}

}
