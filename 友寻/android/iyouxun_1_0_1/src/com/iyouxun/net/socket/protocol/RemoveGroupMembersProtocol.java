package com.iyouxun.net.socket.protocol;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;

import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.data.chat.ChatDBHelper;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: RemoveGroupMembersProtocol
 * @Description: 群主踢人
 * @author donglizhi
 * @date 2015年4月22日 下午7:05:30
 * 
 */
public class RemoveGroupMembersProtocol extends AbsPushProtocol {
	ChatDBHelper helper;

	/**
	 * {"uid":2095350,"nick":"天字第二号","avatars":
	 * "http:\/\/p.friendly.dev\/09\/53\/70bcb455ccb58ce525ef50c9d73dc397\/113250100a.jp
	 * g ? w h = 1 0 0 x 1 0 0
	 * " , "group_id":15850,"title":"哄哄、黑乎乎、我好帅","cmd":309,"timer":1429941170,
	 * "pushtype":"text","description":"谢绝你加入群\"","msgcount":1 }
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
			bean.contentText = "你退出了群组 ( " + msgcount + " )";
		} else {
			bean.contentText = bean.nick + "把你移出了 " + title;
		}
		bean.groupId = json.optInt(UtilRequest.FORM_GROUP_ID);
		bean.msgCount = msgcount;
		bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_AVATARS);
		Intent exitIntent = new Intent(UtilRequest.BROADCAST_ACTION_EXIT_GROUP);
		exitIntent.putExtra(UtilRequest.FORM_GROUP_ID, bean.groupId + "");
		Util.sendBroadcast(exitIntent);
		return this;
	}

}
