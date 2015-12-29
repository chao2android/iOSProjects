package com.iyouxun.net.socket.protocol;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.database.Cursor;

import com.iyouxun.J_Application;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.chat.ChatContactRepository;
import com.iyouxun.data.chat.ChatDBHelper;
import com.iyouxun.data.chat.ChatItem;
import com.iyouxun.data.chat.ChatListItem;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.message.ChatMainActivity;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.Util;

public class CreateGroupProtocol extends AbsPushProtocol {
	ChatListItem item;
	ChatDBHelper helper;

	/**
	 * {"uid":2091950,"sendtime":1429783329,"nick":"黑乎乎","group_id":14850,
	 * "avatars":
	 * "http:\/\/p.friendly.dev\/09\/19\/07d80dfe7279d4c584cd33fb8aec3763\/47750
	 * 1 0 0 a . j p g ? w h = 1 0 0 x 1 0 0
	 * " , "title":"天字第二号","cmd":304,"timer":1429783330,"pushtype":"text",
	 * "description":"黑乎乎建了个群\"","msgcount":0 }
	 */
	@Override
	public SocketProtocol getResponseObj(JSONObject json) throws JSONException {
		bean = new PushMsgInfo();
		bean.cmd = json.optInt(KEY_CMD);
		long fromUid = json.optLong(UtilRequest.FORM_UID);
		if (fromUid == J_Cache.sLoginUser.uid) {
			return null;
		}
		bean.nick = JsonUtil.getJsonString(json, UtilRequest.FORM_TITLE);
		bean.groupId = json.optInt(UtilRequest.FORM_GROUP_ID);
		bean.time = json.optLong(UtilRequest.FORM_TIMER);
		bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_LOGO);
		bean.pushtype = JsonUtil.getJsonString(json, UtilRequest.FORM_PUSH_TYPE);
		bean.contentText = "你已经加入了" + bean.nick + "，可以开始聊天啦";
		helper = ChatContactRepository.getDBHelperInstance();
		item = new ChatListItem();
		item.userIconUrl = bean.showIcon;
		item.nickName = bean.nick;
		item.chatType = 1;
		item.groupId = bean.groupId + "";
		item.count = 0;
		int lc_msg_id = saveMsgData(bean, "你已经加入了群组，可以开始聊天啦");
		if (J_Application.pushActiviy.containsKey(bean.groupId + "")) {
			UtilRequest.getCountNew();
			ChatMainActivity activity = (ChatMainActivity) J_Application.pushActiviy.get(bean.groupId + "");
			if (activity.getChatType() == 1) {
				activity.getNewMsg(lc_msg_id);
				UtilRequest.sendOnreadGroupByOid(bean.groupId + "");
				return null;
			}
		}
		helper.autoIncrementNewGroupMsgCount(item.groupId);
		Intent intent = new Intent();
		intent.setAction(J_Consts.UPDATE_MESSAGE_LIST_DATA);
		Util.sendBroadcast(intent);
		return this;
	}

	private int saveMsgData(PushMsgInfo bean, String string) {
		ChatItem ci = new ChatItem();
		ci.setBoxType(3);
		ci.setTimeStamp(System.currentTimeMillis() + "");
		ci.setChatType(1);
		ci.setGroupId(bean.groupId + "");
		ci.setContent(string);
		// 在数据库中不存在，添加至数据库
		long loc_msgid = helper.addChatRecord(ci);
		ci.setId(Util.getInteger(String.valueOf(loc_msgid)));
		// 从本地数据库中获取当前用户信息
		Cursor cursor = helper.queryContactById(ci.getContactId(), ci.getGroupId(), ci.getChatType());
		// 当前用户在数据库中已经存在，则从本地获取
		int count = cursor.getCount();
		if (count <= 0) {
			// 加载聊天记录
			helper.addContact(item, System.currentTimeMillis() + "");
		}
		cursor.close();
		// 更新该用户的最后一条聊天信息
		helper.updateLastMessage(ci.getContactId(), bean.contentText, ci.getStatus(), ci.getTimeStamp(), ci.getChatType(),
				ci.getGroupId());
		return ci.getId();
	}
}
