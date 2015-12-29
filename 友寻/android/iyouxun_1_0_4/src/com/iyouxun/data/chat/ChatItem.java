package com.iyouxun.data.chat;

import android.os.Parcel;
import android.os.Parcelable;

public class ChatItem implements Parcelable {
	private int id;// 信息id(本地数据库_id)
	private String contactId; // 联系人uid
	private String content; // 聊天内容
	private String mimeType = "";// 标记发送聊天信息的类型
	private int boxType; // 发信人类型 INBOX=1(对方) OUTBOX=2(自己)
	private int status;// 消息发送状态 0：失败，1成功
	private String timeStamp;// 发送信息的时间戳
	private String msgId;// 信息id（服务器端生成）
	private int isAck;// 标记消息是否为已读状态0：未读，1：已读
	private int voiceLength;// 语音的时长
	private String fileName;// 语音文件|图片文件的文件名
	private String fileNameThumb;// 缩略图文件名
	private int thumbImgWidth;// 缩略图的宽
	private int thumbImgHeight;// 缩略图的高
	private int isPlaying;// 语音是否在播放
	private int percent = -1;// 图片上传百分比
	private int chatType = 0;// 0普通聊天1群组聊天
	private String groupId;// 群组id
	private String groupUserUid = "";// 群组用户uid
	private String groupUserNick = "";// 群组用户昵称
	private String groupUserAvatar = "";// 群组用户头像
	private int groupUserSex = 0;// 群组用户性别
	private String pid = "";// 图片id

	public int getId() {
		return id;
	}

	public void setId(int id) {
		this.id = id;
	}

	public int getBoxType() {
		return boxType;
	}

	public void setBoxType(int boxType) {
		this.boxType = boxType;
	}

	public String getMsgId() {
		return msgId;
	}

	public void setMsgId(String msgId) {
		this.msgId = msgId;
	}

	public int getIsAck() {
		return isAck;
	}

	public void setIsAck(int isAck) {
		this.isAck = isAck;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getMimeType() {
		return mimeType;
	}

	public void setMimeType(String mimeType) {
		this.mimeType = mimeType;
	}

	public int getStatus() {
		return status;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public String getTimeStamp() {
		return timeStamp;
	}

	public void setTimeStamp(String timeStamp) {
		this.timeStamp = timeStamp;
	}

	public String getContactId() {
		return contactId;
	}

	public void setContactId(String contactId) {
		this.contactId = contactId;
	}

	public void setVoiceLength(int vl) {
		this.voiceLength = vl;
	}

	public int getVoiceLength() {
		return voiceLength;
	}

	public void setFileName(String vn) {
		this.fileName = vn;
	}

	public String getFileName() {
		return fileName;
	}

	public void setFileNameThumb(String thumb) {
		this.fileNameThumb = thumb;
	}

	public String getFileNameThumb() {
		return fileNameThumb;
	}

	public void setThumbImageWidth(int width) {
		this.thumbImgWidth = width;
	}

	public int getThumbImageWidth() {
		return thumbImgWidth;
	}

	public void setThumbImageHeight(int height) {
		this.thumbImgHeight = height;
	}

	public int getThumbImageHeight() {
		return thumbImgHeight;
	}

	public void setIsPlaying(int isPlay) {
		this.isPlaying = isPlay;
	}

	public int getIsPlaying() {
		return isPlaying;
	}

	@Override
	public int describeContents() {
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags) {
		dest.writeInt(id);
		dest.writeString(contactId);
		dest.writeString(content);
		dest.writeString(mimeType);
		dest.writeInt(boxType);
		dest.writeInt(status);
		dest.writeString(timeStamp);
		dest.writeString(msgId);
		dest.writeInt(isAck);
		dest.writeInt(voiceLength);
		dest.writeString(fileName);
		dest.writeString(fileNameThumb);
		dest.writeInt(thumbImgWidth);
		dest.writeInt(thumbImgHeight);
		dest.writeInt(isPlaying);
		dest.writeInt(chatType);
		dest.writeString(groupId);
		dest.writeString(groupUserAvatar);
		dest.writeString(groupUserNick);
		dest.writeString(groupUserUid);
		dest.writeInt(groupUserSex);
	}

	public static final Parcelable.Creator<ChatItem> CREATOR = new Parcelable.Creator<ChatItem>() {
		@Override
		public ChatItem createFromParcel(Parcel source) {
			ChatItem item = new ChatItem();
			item.id = source.readInt();
			item.contactId = source.readString();
			item.content = source.readString();
			item.mimeType = source.readString();
			item.boxType = source.readInt();
			item.status = source.readInt();
			item.timeStamp = source.readString();
			item.msgId = source.readString();
			item.isAck = source.readInt();
			item.voiceLength = source.readInt();
			item.fileName = source.readString();
			item.fileNameThumb = source.readString();
			item.thumbImgWidth = source.readInt();
			item.thumbImgHeight = source.readInt();
			item.isPlaying = source.readInt();
			item.chatType = source.readInt();
			item.groupId = source.readString();
			item.groupUserAvatar = source.readString();
			item.groupUserNick = source.readString();
			item.groupUserUid = source.readString();
			item.groupUserSex = source.readInt();
			return item;
		}

		@Override
		public ChatItem[] newArray(int size) {
			return new ChatItem[size];
		}

	};

	@Override
	public boolean equals(Object obj) {
		if (this.equals(obj)) {
			return true;
		}
		if (obj instanceof ChatItem) {
			ChatItem item = (ChatItem) obj;
			if (item.contactId.equals(contactId) && item.timeStamp.equals(timeStamp)) {
				return true;
			} else if (item.groupId.equals(groupId) && item.timeStamp.equals(timeStamp)) {
				return true;
			}
		}
		return false;
	}

	public int getPercent() {
		return percent;
	}

	public void setPercent(int percent) {
		this.percent = percent;
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

	public String getGroupUserUid() {
		return groupUserUid;
	}

	public void setGroupUserUid(String groupUserUid) {
		this.groupUserUid = groupUserUid;
	}

	public String getGroupUserNick() {
		return groupUserNick;
	}

	public void setGroupUserNick(String groupUserNick) {
		this.groupUserNick = groupUserNick;
	}

	public String getGroupUserAvatar() {
		return groupUserAvatar;
	}

	public void setGroupUserAvatar(String groupUserAvatar) {
		this.groupUserAvatar = groupUserAvatar;
	}

	public int getGroupUserSex() {
		return groupUserSex;
	}

	public void setGroupUserSex(int groupUserSex) {
		this.groupUserSex = groupUserSex;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}
}
