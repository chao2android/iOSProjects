package com.iyouxun.net.socket.protocol;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.database.Cursor;

import com.iyouxun.J_Application;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.data.chat.ChatConstant;
import com.iyouxun.data.chat.ChatContactRepository;
import com.iyouxun.data.chat.ChatDBHelper;
import com.iyouxun.data.chat.ChatItem;
import com.iyouxun.data.chat.ChatListItem;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.message.ChatMainActivity;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: ChatMsgProtocol
 * @Description: 文本消息推送
 * @author donglizhi
 * @date 2015年3月18日 下午7:34:12
 * 
 */
public class ChatMsgProtocol extends AbsPushProtocol {
	ChatListItem item;
	ChatDBHelper helper;

	/**
	 * {"nick":"天字第二号","from":2095350,"sex":"0","msg":{"chatmsg":"头疼咯",
	 * "fromnick":"天字第二号","from":2095350,"msgfrom":"appim-1","sex":"0","avatar":
	 * "http:\/\/p.friendly.dev\/09\/53\/70bcb455ccb58ce525ef50c9d73dc397\/11325
	 * 0 1 0 0 a . j p g ? w h = 1 0 0 x 1 0 0 " , "sendtime":"2015-04-15
	 * 11:07:43","iid":2501250,"to":2091950,"msgtype":0,"ext":""},"cmd":301,"
	 * timer
	 * ":1429067263,"pushtype":"text","description":"收到新的未读消息","msgcount":129}
	 * 
	 * @throws JSONException
	 */
	@Override
	public SocketProtocol getResponseObj(JSONObject json) throws JSONException {
		bean = new PushMsgInfo();
		bean.cmd = json.optInt(KEY_CMD);
		JSONObject msg = json.optJSONObject(UtilRequest.FORM_MSG);
		bean.nick = JsonUtil.getJsonString(json, UtilRequest.FORM_NICK);
		bean.sex = json.optInt(UtilRequest.FORM_SEX, 0);
		bean.uid = json.optLong(UtilRequest.FORM_FROM);
		bean.time = json.optLong(UtilRequest.FORM_TIMER);
		bean.pushtype = JsonUtil.getJsonString(json, UtilRequest.FORM_PUSH_TYPE);
		String chatMsg = JsonUtil.getJsonString(msg, UtilRequest.FORM_CHAT_MSG);
		helper = ChatContactRepository.getDBHelperInstance();
		bean.showIcon = JsonUtil.getJsonString(msg, UtilRequest.FORM_AVATAR);
		item = new ChatListItem();
		item.uid = bean.uid + "";
		item.userIconUrl = bean.showIcon;
		item.sex = bean.sex;
		item.nickName = bean.nick;
		item.chatType = 0;
		item.count = 0;
		int lc_msg_id = saveMsgData(msg, bean.time);
		if (J_Application.pushActiviy.containsKey(bean.uid + "")) {
			ChatMainActivity activity = (ChatMainActivity) J_Application.pushActiviy.get(bean.uid + "");
			if (activity.getChatType() == 0) {
				activity.getNewMsg(lc_msg_id);
				UtilRequest.sendOnreadByOid(bean.uid + "");
				return null;
			}
		}
		helper.autoIncrementNewMsgCount(item.uid);
		int msgcount = helper.getUnreadMsgByContactId(item.uid, "", 0);
		if (msgcount > 1) {
			bean.contentText = "[" + msgcount + "条]" + chatMsg;
		} else {
			bean.contentText = chatMsg;
		}
		Intent intent = new Intent();
		intent.setAction(J_Consts.UPDATE_MESSAGE_LIST_DATA);
		Util.sendBroadcast(intent);
		return this;
	}

	private int saveMsgData(JSONObject finalData, long time) throws JSONException {

		String msg_id = JsonUtil.getJsonString(finalData, UtilRequest.FORM_IID);// msg_id
		String contact_uid = JsonUtil.getJsonString(finalData, UtilRequest.FORM_FROM);// contact_uid
		int chatType = 0;
		// 消息类型0 单聊普通聊天 1 群聊普通聊天 2 单聊上传声音 3 单聊上传图片 4 群聊上传声音
		// 5 群聊上传图片
		int msgtype = finalData.optInt(UtilRequest.FORM_MSG_TYPE);
		int boxBype = 1;
		ChatItem ci = new ChatItem();
		ci.setMsgId(msg_id);// msg_id
		ci.setStatus(ChatConstant.MSG_SYNCHRONIZE_SUCCESS);// 发送结果状态
		ci.setBoxType(boxBype);// box_type
		ci.setContactId(contact_uid);// contact_uid
		ci.setTimeStamp(time + UtilRequest.TIMESTAMP_000);// created_at
		ci.setChatType(chatType);
		if (msgtype == 2) {
			// 语音内容
			ci.setContent("[语音消息]");// content
			JSONObject voiceInfo = JsonUtil.getJsonObject(finalData, UtilRequest.FORM_EXT);
			int voiceLength = voiceInfo.optInt(UtilRequest.FORM_DUR);
			String voiceName = JsonUtil.getJsonString(voiceInfo, UtilRequest.FORM_VOICE);
			ci.setVoiceLength(voiceLength);
			ci.setFileName(voiceName);
			ci.setMimeType(ChatConstant.MIME_TYPE_AUIDO_AMR);// mime_type
		} else if (msgtype == 0) {
			// 文字内容
			ci.setContent(JsonUtil.getJsonString(finalData, UtilRequest.FORM_CHAT_MSG));// content
			ci.setMimeType(ChatConstant.MIME_TYPE_TEXT_PLAIN);// mime_type
		} else if (msgtype == 3) {
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
