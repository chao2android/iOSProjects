package com.iyouxun.net.socket.protocol;

import org.json.JSONException;
import org.json.JSONObject;

import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.utils.JsonUtil;

/**
 * @ClassName: ExitGroupProtocol
 * @Description: 退出群组
 * @author donglizhi
 * @date 2015年4月22日 下午4:47:30
 * 
 */
public class ExitGroupProtocol extends AbsPushProtocol {
	/**
	 * {"uid":2091950,"sendtime":1429692406,"nick":"黑乎乎","privonce":"11","city":
	 * "1105","avatars":
	 * "http:\/\/p.friendly.dev\/09\/19\/07d80dfe7279d4c584cd33fb8aec3763\/47750100a.jpg?wh=100x
	 * 1 0 0 " ,
	 * "group_id":14350,"title":"草莓公仔、测试、黄金基金份额","cmd":306,"timer":1429692406,
	 * "pushtype":"text","description":"黑乎乎退出了群\"","msgcount":6 }
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
			bean.contentText = "退群通知 ( " + msgcount + " )";
		} else {
			bean.contentText = bean.nick + "已退出 " + title;
		}
		bean.msgCount = msgcount;
		bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_AVATARS);
		return this;
	}

}
