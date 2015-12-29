package com.iyouxun.net.socket.protocol;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.database.Cursor;

import com.iyouxun.J_Application;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.data.chat.ChatContactRepository;
import com.iyouxun.data.chat.ChatDBHelper;
import com.iyouxun.data.chat.ChatItem;
import com.iyouxun.data.chat.ChatListItem;
import com.iyouxun.data.parser.SocketParser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.message.ChatMainActivity;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: InvitationGroupProtocol
 * @Description: 邀请加入
 * @author donglizhi
 * @date 2015年4月23日 上午11:35:33
 * 
 */
public class InvitationGroupProtocol extends AbsPushProtocol {
	ChatListItem item;
	ChatDBHelper helper;

	/**
	 * {"uid":2091950,"sendtime":1429858383,"nick":"黑乎乎","group_id":15450,
	 * "avatars":
	 * "http:\/\/p.friendly.dev\/09\/19\/07d80dfe7279d4c584cd33fb8aec3763\/47750100a.jpg
	 * ? w h = 1 0 0 x 1 0 0 " , "title":"咯去破坏","logo":
	 * "http:\/\/p.friendly.dev\/09\/19\/07d80dfe7279d4c584cd33fb8aec3763\/142050_100i.jpg?
	 * w h = 1 0 0 x 1 0 0
	 * " , "join_nick":"2101950","cmd":310,"timer":1429858383,"pushtype":"text
	 * ", "description":"好友邀请您加入群\"","msgcount": 0 }
	 */
	@Override
	public SocketProtocol getResponseObj(JSONObject json) throws JSONException {
		bean = new PushMsgInfo();
		bean.cmd = json.optInt(KEY_CMD);
		bean.uid = json.optLong(UtilRequest.FORM_UID);
		bean.time = json.optLong(UtilRequest.FORM_TIMER);
		bean.pushtype = JsonUtil.getJsonString(json, UtilRequest.FORM_PUSH_TYPE);
		bean.groupId = json.optInt(UtilRequest.FORM_GROUP_ID);
		if (bean.groupId <= 0) {
			return null;
		}
		String joinNick = JsonUtil.getJsonString(json, UtilRequest.FORM_JOIN_NICK);
		if (SharedPreUtil.getLoginInfo().nickName.equals(joinNick)) {
			bean.nick = JsonUtil.getJsonString(json, UtilRequest.FORM_NICK);
			String title = JsonUtil.getJsonString(json, UtilRequest.FORM_TITLE);
			int msgcount = json.optInt(UtilRequest.FORM_MSG_COUNT, 0);
			if (msgcount >= 5) {
				bean.contentText = "你有" + msgcount + "个群组邀请";
			} else {
				bean.contentText = bean.nick + "邀请你加入群组 " + title;
			}
			bean.msgCount = msgcount;
			bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_AVATARS);
			return this;
		} else {
			bean.cmd = SocketParser.CMD_SEND_NEW_CREATE_GROUP_MSG;
			bean.nick = JsonUtil.getJsonString(json, UtilRequest.FORM_TITLE);
			bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_LOGO);
			if (joinNick.length() > 6) {
				joinNick = joinNick.substring(0, 6) + "...";
			}
			bean.contentText = joinNick + "已经加入了 " + bean.nick;
			String groupTip = joinNick + "已经加入了";
			helper = ChatContactRepository.getDBHelperInstance();
			item = new ChatListItem();
			item.userIconUrl = bean.showIcon;
			item.nickName = bean.nick;
			item.chatType = 1;
			item.groupId = bean.groupId + "";
			item.count = 0;
			int lc_msg_id = saveMsgData(bean, groupTip);
			if (J_Application.pushActiviy.containsKey(bean.groupId + "")) {
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
	}

	private int saveMsgData(PushMsgInfo bean, String groupTip) {
		ChatItem ci = new ChatItem();
		ci.setBoxType(3);
		ci.setTimeStamp(System.currentTimeMillis() + "");
		ci.setChatType(1);
		ci.setGroupId(bean.groupId + "");
		ci.setContent(groupTip);
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
