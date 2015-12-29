package com.iyouxun.data.beans.users;

public class GroupUser extends BaseUser {
	/** 在页面中是否可见 */
	public boolean isVisiable = true;
	/** 共同好友数量 */
	public int mfriend_num;
	/** 是否群主 */
	public boolean isAdmin;
	/**
	 * @Fields joinTime : 加入群组的时间
	 */
	public long joinTime;
}
