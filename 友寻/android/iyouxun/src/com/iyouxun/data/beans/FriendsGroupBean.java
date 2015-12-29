package com.iyouxun.data.beans;

import java.io.Serializable;

/**
 * @ClassName: FriendsGroupBean
 * @Description: 好友分组列表数据元素
 * @author donglizhi
 * @date 2015年3月25日 下午3:14:17
 * 
 */
public class FriendsGroupBean implements Serializable {
	private String groupName = "";// 分组名称
	private String groupId = "";// 分组id
	private int groupMembersCount;// 分组成员数量
	private int isChecked = 0;// 选中状态

	public int getIsChecked() {
		return isChecked;
	}

	public void setIsChecked(int checked) {
		this.isChecked = checked;
	}

	public String getGroupName() {
		return groupName;
	}

	public void setGroupName(String groupName) {
		this.groupName = groupName;
	}

	public String getGroupId() {
		return groupId;
	}

	public void setGroupId(String groupId) {
		this.groupId = groupId;
	}

	public int getGroupMembersCount() {
		return groupMembersCount;
	}

	public void setGroupMembersCount(int groupMembersCount) {
		this.groupMembersCount = groupMembersCount;
	}
}
