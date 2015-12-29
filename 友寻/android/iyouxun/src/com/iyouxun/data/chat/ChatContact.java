package com.iyouxun.data.chat;

import java.util.ArrayList;

public class ChatContact {
	private String oid;// uid
	private String nickName;// 昵称
	private String thumbnailUrl;// 头像
	private int sex;// 性别
	private int unreadCount;// 未读信息数量
	private String lastMsg;
	private String ctime;// 最后更新时间
	private int msgStatus;// 信息发送状态
	private int chatType;// 0普通消息1群组消息
	private String groupId;// 群组id
	private int hint;// "hint","提醒" 0 接受 1 不接受
	private final ArrayList<ChatItem> sendingChatItems = new ArrayList<ChatItem>();

	public ArrayList<ChatItem> getSendingChatItems() {
		return sendingChatItems;
	}

	public String getLastMsg() {
		return lastMsg;
	}

	public void setLastMsg(String lastMsg) {
		this.lastMsg = lastMsg;
	}

	public int getSex() {
		return sex;
	}

	public void setSex(int userSex) {
		this.sex = userSex;
	}

	public void setCtime(String ctime) {
		this.ctime = ctime;
	}

	public String getCtime() {
		return ctime;
	}

	public void setMsgStatus(int status) {
		this.msgStatus = status;
	}

	public int getMsgStatus() {
		return msgStatus;
	}

	public String getNickName() {
		return nickName;
	}

	public String getThumbnailUrl() {
		return thumbnailUrl;
	}

	public int getUnreadCount() {
		return unreadCount;
	}

	public String getUid() {
		return oid;
	}

	public void setUid(String uid) {
		this.oid = uid;
	}

	public void setNickName(String nickName) {
		this.nickName = nickName;
	}

	public void setThumbnailUrl(String thumbnailUrl) {
		this.thumbnailUrl = thumbnailUrl;
	}

	public void setUnreadCount(int unreadCount) {
		this.unreadCount = unreadCount;
	}

	public int getChatType() {
		return chatType;
	}

	public void setChatType(int chatType) {
		this.chatType = chatType;
	}

	public String getGroupId() {
		return groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	public int getHint() {
		return hint;
	}

	public void setHint(int hint) {
		this.hint = hint;
	}

}
