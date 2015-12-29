package com.iyouxun.net.socket.protocol;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.database.Cursor;

import com.iyouxun.J_Application;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.chat.ChatConstant;
import com.iyouxun.data.chat.ChatContactRepository;
import com.iyouxun.data.chat.ChatDBHelper;
import com.iyouxun.data.chat.ChatItem;
import com.iyouxun.data.chat.ChatListItem;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.message.ChatMainActivity;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.Util;

public class GroupMsgProtocol extends AbsPushProtocol {
	ChatListItem item;
	ChatDBHelper helper;

	/**
	 * {"nick":"黑乎乎","from":"2091950","sex":"1","msg":{"uid":2091950,"chatmsg":
	 * "444","fromnick":"黑乎乎","msgfrom":"appim-1","sex":"1","avatar":
	 * "http:\/\/p.friendly.dev\/09\/19\/07d80dfe7279d4c584cd33fb8aec3763\/47750100a.jpg?wh=100x100","logo":"http:\/\/p.friendly.dev\/09\/19\/07d80dfe7279d4c584cd33fb8aec3763\/79950_100i.jpg?wh=100x100","title":"干活就哭、kevin、孙悟空、听、...","sendtime":"
	 * 2 0 1 5 - 0 4 - 1 6
	 * 11:02:40","iid":30450,"group_id":11350,"msgtype":1,"ext":""},"hint":"1
	 * "," cmd":302,"timer":1429153361,"pushtype":"text","description":"收到新的未读消息
	 * "," msgcount":1}
	 */
	@Override
	public SocketProtocol getResponseObj(JSONObject json) throws JSONException {
		bean = new PushMsgInfo();
		bean.cmd = json.optInt(KEY_CMD);
		long fromUid = json.optLong(UtilRequest.FORM_FROM);
		if (fromUid == J_Cache.sLoginUser.uid) {
			return null;
		}
		JSONObject msg = json.optJSONObject(UtilRequest.FORM_MSG);
		bean.nick = JsonUtil.getJsonString(msg, UtilRequest.FORM_TITLE);
		bean.sex = json.optInt(UtilRequest.FORM_SEX, 0);
		bean.groupId = msg.optInt(UtilRequest.FORM_GROUP_ID);
		bean.time = json.optLong(UtilRequest.FORM_TIMER);
		bean.showIcon = JsonUtil.getJsonString(msg, UtilRequest.FORM_LOGO);
		bean.pushtype = JsonUtil.getJsonString(json, UtilRequest.FORM_PUSH_TYPE);

		String chatMsg = JsonUtil.getJsonString(msg, UtilRequest.FORM_CHAT_MSG);
		helper = ChatContactRepository.getDBHelperInstance();
		item = new ChatListItem();
		item.userIconUrl = bean.showIcon;
		item.nickName = JsonUtil.getJsonString(msg, UtilRequest.FORM_TITLE);
		item.chatType = 1;
		item.groupId = bean.groupId + "";
		item.count = 0;
		item.hint = json.optInt(UtilRequest.FORM_HINT, 0);
		int lc_msg_id = saveMsgData(msg, bean.time, fromUid);
		if (J_Application.pushActiviy.containsKey(bean.groupId + "")) {
			ChatMainActivity activity = (ChatMainActivity) J_Application.pushActiviy.get(bean.groupId + "");
			if (activity.getChatType() == 1) {
				activity.getNewMsg(lc_msg_id);
				UtilRequest.sendOnreadGroupByOid(bean.groupId + "");
				return null;
			}
		}
		helper.autoIncrementNewGroupMsgCount(item.groupId);
		int msgcount = helper.getUnreadMsgByContactId("", item.groupId, 1);
		if (msgcount > 1) {
			bean.contentText = "[" + msgcount + "条]" + chatMsg;
		} else {
			bean.contentText = chatMsg;
		}
		Intent intent = new Intent();
		intent.setAction(J_Consts.UPDATE_MESSAGE_LIST_DATA);
		Util.sendBroadcast(intent);
		if (item.hint == 1) {
			return null;
		} else {
			return this;
		}
	}

	private int saveMsgData(JSONObject finalData, long time, long fromUid) throws JSONException {

		String msg_id = JsonUtil.getJsonString(finalData, UtilRequest.FORM_IID);// msg_id
		String contact_uid = fromUid + "";// contact_uid
		String group_id = JsonUtil.getJsonString(finalData, UtilRequest.FORM_GROUP_ID);
		String groupUserNick = JsonUtil.getJsonString(finalData, UtilRequest.FORM_FROM_NICK);
		String groupUserAvatar = JsonUtil.getJsonString(finalData, UtilRequest.FORM_AVATAR);
		int groupUserSex = finalData.optInt(UtilRequest.FORM_SEX, 0);
		int chatType = 1;
		// 消息类型0 单聊普通聊天 1 群聊普通聊天 2 单聊上传声音 3 单聊上传图片 4 群聊上传声音
		// 5 群聊上传图片
		int msgtype = finalData.optInt(UtilRequest.FORM_MSG_TYPE);
		int boxBype = 1;
		ChatItem ci = new ChatItem();
		ci.setMsgId(msg_id);// msg_id
		ci.setStatus(ChatConstant.MSG_SYNCHRONIZE_SUCCESS);// 发送结果状态
		ci.setBoxType(boxBype);// box_type
		ci.setGroupUserUid(contact_uid);// contact_uid
		ci.setGroupUserAvatar(groupUserAvatar);
		ci.setGroupUserNick(groupUserNick);
		ci.setGroupUserSex(groupUserSex);
		ci.setTimeStamp(time + UtilRequest.TIMESTAMP_000);// created_at
		ci.setChatType(chatType);
		ci.setGroupId(group_id);
		if (msgtype == 4) {
			// 语音内容
			ci.setContent("[语音消息]");// content
			JSONObject voiceInfo = JsonUtil.getJsonObject(finalData, UtilRequest.FORM_EXT);
			int voiceLength = voiceInfo.optInt(UtilRequest.FORM_DUR);
			String voiceName = JsonUtil.getJsonString(voiceInfo, UtilRequest.FORM_VOICE);
			ci.setVoiceLength(voiceLength);
			ci.setFileName(voiceName);
			ci.setMimeType(ChatConstant.MIME_TYPE_AUIDO_AMR);// mime_type
		} else if (msgtype == 1) {
			// 文字内容
			ci.setContent(JsonUtil.getJsonString(finalData, UtilRequest.FORM_CHAT_MSG));// content
			ci.setMimeType(ChatConstant.MIME_TYPE_TEXT_PLAIN);// mime_type
		} else if (msgtype == 5) {
			// 图片内容
			ci.setContent("[图片消息]");
			JSONObject imgInfo = JsonUtil.getJsonObject(finalData, UtilRequest.FORM_EXT);
			String imageName = JsonUtil.getJsonString(imgInfo, UtilRequest.FORM_PIC_0);
			String imageNameThumb = JsonUtil.getJsonString(imgInfo, UtilRequest.FORM_PIC_200);
			String pid = JsonUtil.getJsonString(imgInfo, UtilRequest.FORM_PID);
			ci.setPid(pid);
			ci.setFileName(imageName);
			ci.setFileNameThumb(imageNameThumb);
			ci.setMimeType(ChatConstant.MIME_TYPE_IMAGE_JPEG);// 该条私信记录的类型
			// 设置图片宽高
			int[] widthHeight = Util.getWidthHeight(imageNameThumb);
			int originalWidth = widthHeight[0];
			int originalHeight = widthHeight[1];
			ci.setThumbImageWidth(originalWidth);
			ci.setThumbImageHeight(originalHeight);
		} else {
			return -1;
		}
		if (!Util.isBlankString(msg_id) && Util.getLong(msg_id) > 0) {
			// 获取当前信息的本地id
			ChatItem checkCi = helper.querySingleChatRecordFromMsgid(Util.getLong(msg_id), chatType);
			if (checkCi == null) {
				// 在数据库中不存在，添加至数据库
				long loc_msgid = helper.addChatRecord(ci);
				ci.setId(Util.getInteger(String.valueOf(loc_msgid)));
			} else {
				// 已经存在于数据库中，仅获取该数据msgid
				ci.setId(checkCi.getId());
				helper.updateChatRecord(ci);
			}
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
			helper.updateLastMessage(ci.getContactId(), ci.getContent(), ci.getStatus(), ci.getTimeStamp(), ci.getChatType(),
					ci.getGroupId());
			return ci.getId();
		}
		return -1;
	}

}
