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
import com.iyouxun.data.parser.SocketParser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.message.ChatMainActivity;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: ApplyAddGroupProtocol
 * @Description: 申请加入群组广播
 * @author donglizhi
 * @date 2015年4月22日 下午3:13:02
 * 
 */
public class ApplyAddGroupProtocol extends AbsPushProtocol {
	ChatListItem item;
	ChatDBHelper helper;

	/**
	 * {"uid":1442050,"nick":"咯去破坏","muid":"1001750","mnick":"昵称很长","avatars":
	 * "http:\/\/i.friendly.dev\/img\/common\/avatar\/r_avatar\/100\/00.png","gr
	 * o u p _ i d " : 1 2 7 5 0 , "title":"偷空、泰民路、孙悟空、干活就哭、k...","logo":
	 * "http:\/\/p.friendly.dev\/00\/17\/e81b82a5d49d3927595748d508455d10\/_100i
	 * . j p g ? w h = 0 x 0
	 * " , "subtype":1,"cmd":305,"timer":1429847468,"pushtype":"text",
	 * "description":"咯去破坏申请加入群\"","msgcount": 5 }
	 */
	@Override
	public SocketProtocol getResponseObj(JSONObject json) throws JSONException {
		bean = new PushMsgInfo();
		bean.cmd = json.optInt(KEY_CMD);
		bean.nick = JsonUtil.getJsonString(json, UtilRequest.FORM_TITLE);
		String nick = JsonUtil.getJsonString(json, UtilRequest.FORM_NICK);
		bean.uid = json.optLong(UtilRequest.FORM_UID);
		bean.time = json.optLong(UtilRequest.FORM_TIMER);
		bean.pushtype = JsonUtil.getJsonString(json, UtilRequest.FORM_PUSH_TYPE);
		bean.groupId = json.optInt(UtilRequest.FORM_GROUP_ID);
		if (bean.groupId <= 0) {
			return null;
		}
		int subType = json.optInt(UtilRequest.FORM_SUB_TYPE, 2);// 1直接加入2 申请加入
		String title = JsonUtil.getJsonString(json, UtilRequest.FORM_TITLE);
		int msgcount = json.optInt(UtilRequest.FORM_MSG_COUNT, 0);
		if (subType == 1) {
			bean.cmd = SocketParser.CMD_SEND_NEW_CREATE_GROUP_MSG;
			bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_LOGO);
			String groupTip = "";
			if (bean.uid == J_Cache.sLoginUser.uid) {
				bean.contentText = "你已经加入了 " + bean.nick + "，可以开始聊天啦";
				groupTip = "你已经加入了群组，可以开始聊天啦";
			} else {
				bean.contentText = nick + "已经加入了 " + bean.nick;
				groupTip = nick + "已经加入了群组";
			}
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
		} else if (subType == 2) {
			if (msgcount >= 5) {
				bean.contentText = "你的入群申请未通过 ( " + msgcount + " )";
			} else {
				bean.contentText = nick + "申请加入 " + title;
			}
			bean.msgCount = msgcount;
			bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_AVATARS);
			return this;
		}
		return null;
	}

	private int saveMsgData(PushMsgInfo bean, String groupTip) {
		ChatItem ci = new ChatItem();
		ci.setBoxType(3);
		ci.setTimeStamp(bean.time + "000");
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
		helper.updateLastMessage(ci.getContactId(), groupTip, ci.getStatus(), ci.getTimeStamp(), ci.getChatType(),
				ci.getGroupId());
		return ci.getId();
	}
}
