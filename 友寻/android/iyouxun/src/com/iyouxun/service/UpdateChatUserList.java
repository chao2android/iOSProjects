package com.iyouxun.service;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.IntentService;
import android.content.Intent;
import android.os.Handler;

import com.iyouxun.R;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.chat.ChatConstant;
import com.iyouxun.data.chat.ChatContactRepository;
import com.iyouxun.data.chat.ChatDBHelper;
import com.iyouxun.data.chat.ChatItem;
import com.iyouxun.data.chat.ChatListItem;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.Util;

public class UpdateChatUserList extends IntentService {
	private ChatDBHelper helper;

	public UpdateChatUserList() {
		super("com.iyouxun.service.UpdateChatUserList");
	}

	@Override
	protected void onHandleIntent(Intent intent) {
		helper = ChatContactRepository.getDBHelperInstance();
		UtilRequest.getAllChatMsgList(1, J_Consts.MESSAGE_LIST_PAGE_SIZE, mHandler, this);
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_GET_ALL_CHAT_MSG_LIST:
				if (msg.obj == null) {
					return;
				}
				try {
					JSONArray dataArray = new JSONArray(msg.obj.toString());
					if (dataArray.length() > 0) {
						for (int i = 0; i < dataArray.length(); i++) {
							JSONObject contactObject = dataArray.getJSONObject(i);
							ChatListItem item = new ChatListItem();
							item.uid = contactObject.optString(UtilRequest.FORM_OID);
							item.groupId = contactObject.optString(UtilRequest.FORM_GROUP_ID);
							if (!Util.isBlankString(item.groupId)) {
								item.chatType = 1;
								item.userIconUrl = contactObject.optString(UtilRequest.FORM_LOGO);
								item.nickName = contactObject.optString(UtilRequest.FORM_TITLE);
							} else {
								item.chatType = 0;
								item.userIconUrl = contactObject.optString(UtilRequest.FORM_AVATAR);
								item.nickName = contactObject.optString(UtilRequest.FORM_NICK);
							}
							int msgType = contactObject.optInt(UtilRequest.FORM_MSG_TYPE);
							item.ctime = contactObject.optString(UtilRequest.FORM_SEND_TIME) + "000";
							item.msgStatus = ChatConstant.MSG_SYNCHRONIZE_SUCCESS;
							item.count = contactObject.optInt(UtilRequest.FORM_NEW_COUNT);
							switch (msgType) {
							case 0:// 单聊普通聊天
							case 1:// 群聊普通聊天
								item.last_msg = contactObject.optString(UtilRequest.FORM_CONTENT);
								break;
							case 2:// 单聊上传声音
							case 4:// 群聊上传声音
								item.last_msg = getString(R.string.voice_msg);
								break;
							case 3:// 单聊上传图片
							case 5:// 群聊上传图片
								item.last_msg = getString(R.string.image_msg);
								break;
							}
							if (item != null && item.ctime != null) {
								// 更新联系人信息
								long id = helper.addContact(item, item.ctime);
								// 跟新聊天联系人聊天记录
							}
							// 更新联系人聊天记录
							updateHitoryUserChatList(contactObject);
						}
						int msgCount = helper.getShowMsgNewMsgCount(J_Consts.MESSAGE_LIST_PAGE_SIZE);
						Intent intent = new Intent();
						intent.setAction(J_Consts.UPDATE_MESSAGE_LIST_DATA);
						intent.putExtra(UtilRequest.FORM_COUNT, msgCount);
						Util.sendBroadcast(intent);
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}

				break;

			default:
				break;
			}
		};
	};

	private void updateHitoryUserChatList(JSONObject finalData) {
		ChatItem ci = new ChatItem();
		String msg_id = JsonUtil.getJsonString(finalData, UtilRequest.FORM_IID);
		String contact_uid = "";
		String groupId = "";
		int chatType = 0;
		String ctime = JsonUtil.getJsonString(finalData, UtilRequest.FORM_SEND_TIME);
		if (finalData.has(UtilRequest.FORM_GROUP_ID)) {
			groupId = JsonUtil.getJsonString(finalData, UtilRequest.FORM_GROUP_ID);
			chatType = 1;
			String groupUserUid = JsonUtil.getJsonString(finalData, UtilRequest.FORM_OID);
			if (groupUserUid.equals(J_Cache.sLoginUser.uid + "")) {
				ci.setBoxType(2);
			} else {
				ci.setBoxType(1);
			}
			String groupUserNick = JsonUtil.getJsonString(finalData, UtilRequest.FORM_NICK);
			String groupUserAvatar = JsonUtil.getJsonString(finalData, UtilRequest.FORM_AVATAR);
			int groupUserSex = finalData.optInt(UtilRequest.FORM_SEX, 0);
			ci.setGroupUserUid(groupUserUid);
			ci.setGroupUserAvatar(groupUserAvatar);
			ci.setGroupUserNick(groupUserNick);
			ci.setGroupUserSex(groupUserSex);
		} else {
			contact_uid = JsonUtil.getJsonString(finalData, UtilRequest.FORM_OID);
			chatType = 0;
			int boxBype = finalData.optInt(UtilRequest.FORM_TYPE);
			ci.setBoxType(boxBype);
		}

		// 消息类型0 单聊普通聊天 1 群聊普通聊天 2 单聊上传声音 3 单聊上传图片 4 群聊上传声音 5 群聊上传图片
		int msgtype = finalData.optInt(UtilRequest.FORM_MSG_TYPE);
		ci.setMsgId(msg_id);
		ci.setStatus(ChatConstant.MSG_SYNCHRONIZE_SUCCESS);// 发送结果状态
		ci.setContactId(contact_uid);
		ci.setGroupId(groupId);
		ci.setChatType(chatType);
		ci.setTimeStamp(ctime + UtilRequest.TIMESTAMP_000);
		if (msgtype == 2 || msgtype == 4) {
			// 语音内容
			ci.setContent(getString(R.string.voice_msg));
			JSONObject voiceInfo = JsonUtil.getJsonObject(finalData, UtilRequest.FORM_EXT);
			int voiceLength = voiceInfo.optInt(UtilRequest.FORM_DUR);
			String voiceName = JsonUtil.getJsonString(voiceInfo, UtilRequest.FORM_VOICE);
			ci.setVoiceLength(voiceLength);
			ci.setFileName(voiceName);
			ci.setMimeType(ChatConstant.MIME_TYPE_AUIDO_AMR);
		} else if (msgtype == 0 || msgtype == 1) {
			// 文字内容
			ci.setContent(finalData.optString(UtilRequest.FORM_CONTENT));
			ci.setMimeType(ChatConstant.MIME_TYPE_TEXT_PLAIN);
		} else if (msgtype == 3 || msgtype == 5) {
			// 图片内容
			ci.setContent(getString(R.string.image_msg));
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
				// 通过id更新该条数据信息
				helper.updateChatRecord(ci);
			}
		}
	}
}
