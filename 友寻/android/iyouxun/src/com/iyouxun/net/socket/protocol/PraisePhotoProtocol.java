package com.iyouxun.net.socket.protocol;

import org.json.JSONException;
import org.json.JSONObject;

import com.iyouxun.J_Application;
import com.iyouxun.R;
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
public class PraisePhotoProtocol extends AbsPushProtocol {
	/**
	 * {"nick":"凯爷","from":1002960,"avatars":
	 * "http:\/\/p.friendly.dev\/00\/29\/ce410e6dadbb4d4fe78228d8bc07a2f1\/2351850100a.jpg?wh=100x100","pid":2352250,"cmd":320,"timer":1435819997,"pushtype":"text","description":"凯爷赞了你的照片","msgcount":
	 * 1 }
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
		bean.contentText = J_Application.context.getString(R.string.praise_your_photo);
		bean.msgCount = msgcount;
		bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_AVATARS);
		return this;
	}

}
