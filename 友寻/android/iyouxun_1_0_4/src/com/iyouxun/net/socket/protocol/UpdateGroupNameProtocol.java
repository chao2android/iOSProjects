package com.iyouxun.net.socket.protocol;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;

import com.iyouxun.J_Application;
import com.iyouxun.data.chat.ChatContactRepository;
import com.iyouxun.data.chat.ChatDBHelper;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.utils.Util;

public class UpdateGroupNameProtocol extends AbsPushProtocol {
	/**
	 * {"group_id":15950,"title":"哈哈哈","cmd":303,"timer":1431482535,"pushtype":
	 * "text","description":"修改群名称消息","msgcount":0}
	 */
	@Override
	public SocketProtocol getResponseObj(JSONObject json) throws JSONException {
		int group_id = json.optInt(UtilRequest.FORM_GROUP_ID);
		String title = json.optString(UtilRequest.FORM_TITLE);
		if (group_id > 0 && !Util.isBlankString(title)) {// 修改群组名称
			ChatDBHelper helper = ChatContactRepository.getDBHelperInstance();
			helper.updateContactName(group_id + "", title, 1);
			Intent intent = new Intent();
			intent.setAction(UtilRequest.BROADCAST_ACTION_UPDATE_GROUP_NAME);
			intent.putExtra(UtilRequest.FORM_GROUP_ID, group_id);
			intent.putExtra(UtilRequest.FORM_TITLE, title);
			J_Application.context.sendBroadcast(intent);
		}
		return null;
	}

}
