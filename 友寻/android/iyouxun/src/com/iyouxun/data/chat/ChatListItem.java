package com.iyouxun.data.chat;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * @ClassName: ChatListItem
 * @Description:聊天列表数据
 * @author donglizhi
 * @date 2015年3月16日 下午6:34:42
 * 
 */
public class ChatListItem implements Parcelable {
	public String uid;
	public String nickName;
	public int sex = 1;// 0：女 1：男
	public String userIconUrl;// 头像地址
	public String last_msg;// 最后一条私信消息
	public int count = -1;// 未读消息数量
	public String ctime;// 创建时间
	public int msgStatus = 0;// 消息发送状态
	public int chatType = 0;// 0普通聊天 1群组聊天
	public String groupId;// 群组id
	public int hint = 0;// "hint","提醒" 0 接受 1 不接受

	public ChatListItem() {
	}

	@Override
	public int describeContents() {
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags) {
		dest.writeString(uid);
		dest.writeString(nickName);
		dest.writeString(userIconUrl);
		dest.writeString(last_msg);
		dest.writeInt(count);
		dest.writeString(ctime);
		dest.writeInt(sex);
		dest.writeInt(msgStatus);
		dest.writeInt(chatType);
		dest.writeString(groupId);
		dest.writeInt(hint);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj instanceof ChatListItem) {
			ChatListItem bean = (ChatListItem) obj;
			if (bean.uid.equals(this.uid) && bean.nickName.equals(this.nickName)) {
				return true;
			}
		}
		return false;

	}

	@Override
	public int hashCode() {
		return (uid + nickName).hashCode();

	}

	public static final Parcelable.Creator<ChatListItem> CREATOR = new Parcelable.Creator<ChatListItem>() {
		@Override
		public ChatListItem createFromParcel(Parcel in) {
			ChatListItem item = new ChatListItem();
			item.uid = in.readString();
			item.nickName = in.readString();
			item.userIconUrl = in.readString();
			item.last_msg = in.readString();
			item.count = in.readInt();
			item.ctime = in.readString();
			item.sex = in.readInt();
			item.msgStatus = in.readInt();
			item.chatType = in.readInt();
			item.groupId = in.readString();
			item.hint = in.readInt();
			return item;
		}

		@Override
		public ChatListItem[] newArray(int size) {
			return new ChatListItem[size];
		}
	};

}
