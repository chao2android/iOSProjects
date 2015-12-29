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
 * @ClassName: AgreeAddGroupProtocol
 * @Description: 同意加入群组
 * @author donglizhi
 * @date 2015年4月22日 下午5:46:42
 * 
 */
public class AgreeAddGroupProtocol extends AbsPushProtocol {
	ChatListItem item;
	ChatDBHelper helper;

	/**
	 * {"uid":2091950,"nick":"黑乎乎","avatars":
	 * "http:\/\/p.friendly.dev\/09\/19\/07d80dfe7279d4c584cd33fb8aec3763\/47750
	 * 1 0 0 a . j p g ? w h = 1 0 0 x 1 0 0
	 * " , "group_id":15450,"title":"咯去破坏", "logo":
	 * "http:\/\/p.friendly.dev\/09\/19\/07d80dfe7279d4c584cd33fb8aec3763\/14205
	 * 0 _ 1 0 0 i . j p g ? w h = 1 0 0 x 1 0 0
	 * " , "t_uid":"2095350","t_nick":"天字第二号","cmd":307,"timer":1429863341,
	 * "pushtype":"text","description":"同意你加入群\"","msgcount": 2 }
	 */
	@Override
	public SocketProtocol getResponseObj(JSONObject json) throws JSONException {
		bean = new PushMsgInfo();
		bean.cmd = json.optInt(KEY_CMD);
		bean.uid = json.optLong(UtilRequest.FORM_T_UID);
		bean.time = json.optLong(UtilRequest.FORM_TIMER);
		bean.pushtype = JsonUtil.getJsonString(json, UtilRequest.FORM_PUSH_TYPE);
		bean.groupId = json.optInt(UtilRequest.FORM_GROUP_ID);
		if (bean.groupId <= 0) {
			return null;
		}
		helper = ChatContactRepository.getDBHelperInstance();
		if (bean.uid == SharedPreUtil.getLoginInfo().uid) {// 本人显示系统消息
			bean.nick = JsonUtil.getJsonString(json, UtilRequest.FORM_NICK);
			String title = JsonUtil.getJsonString(json, UtilRequest.FORM_TITLE);
			int msgcount = json.optInt(UtilRequest.FORM_MSG_COUNT, 0);
			if (msgcount >= 5) {
				bean.contentText = "你的入群申请已通过 ( " + msgcount + " )";
			} else {
				bean.contentText = bean.nick + "同意你加入 " + title;
			}
			bean.msgCount = msgcount;
			bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_AVATARS);
			String logo = JsonUtil.getJsonString(json, UtilRequest.FORM_LOGO);
			item = new ChatListItem();
			item.userIconUrl = logo;
			item.nickName = title;
			item.chatType = 1;
			item.groupId = bean.groupId + "";
			item.count = 0;
			saveMsgData(bean, "你已经加入了群组，可以开始聊天啦");
			helper.autoIncrementNewGroupMsgCount(item.groupId);
			Intent intent = new Intent();
			intent.setAction(J_Consts.UPDATE_MESSAGE_LIST_DATA);
			Util.sendBroadcast(intent);
			return this;
		} else {// 非本人显示群组消息
			bean.cmd = SocketParser.CMD_SEND_NEW_CREATE_GROUP_MSG;
			String nick = JsonUtil.getJsonString(json, UtilRequest.FORM_T_NICK);
			bean.nick = JsonUtil.getJsonString(json, UtilRequest.FORM_TITLE);
			bean.showIcon = JsonUtil.getJsonString(json, UtilRequest.FORM_LOGO);
			bean.contentText = nick + "已经加入了 " + bean.nick;
			item = new ChatListItem();
			item.userIconUrl = bean.showIcon;
			item.nickName = bean.nick;
			item.chatType = 1;
			item.groupId = bean.groupId + "";
			item.count = 0;
			int lc_msg_id = saveMsgData(bean, nick + "已经加入了群组");
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
			long masterUid = json.optLong(UtilRequest.FORM_UID);
			if (masterUid == SharedPreUtil.getLoginInfo().uid) {// 群主不显示推送
				return null;
			}
			return this;
		}
	}

	private int saveMsgData(PushMsgInfo bean, String content) {
		ChatItem ci = new ChatItem();
		ci.setBoxType(3);
		ci.setTimeStamp(bean.time + "000");
		ci.setChatType(1);
		ci.setGroupId(bean.groupId + "");
		ci.setContent(content);
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
		helper.updateLastMessage(ci.getContactId(), content, ci.getStatus(), ci.getTimeStamp(), ci.getChatType(), ci.getGroupId());
		return ci.getId();
	}
}
