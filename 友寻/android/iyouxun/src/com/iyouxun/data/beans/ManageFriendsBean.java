package com.iyouxun.data.beans;

import java.io.Serializable;

public class ManageFriendsBean implements Serializable {
	private String uid = "";// 用户id
	private String name = "";// 昵称
	private String avatar = "";// 头像
	private String sortLetter = "";// 拼音首字母
	private int mutualFriendsCount;// 共同好友数量
	private int sex;// 性别 1男 0 女 -1未知
	private boolean hasRegistered;// 注册过 不显示邀请按钮显示一度图标
	private boolean checked;// 选中
	private String mobile = "";// 电话号码 邀请按钮发送短信的电话号码 管理好友列表使用
	private int marriage;// 情感状态
	private int dataType;// 0 用户数据 1添加按钮 2 删除按钮 编辑好友分组使用
	private int relation = 0;// 好友关系 0:非好友； 1:1度; 2:2度
	private long joinTime;// 群组用户加入时间
	private boolean hasAdd = false;// 已经添加过好友
	private int gid = 0;// 用户类型

	public String getUid() {
		return uid;
	}

	public void setUid(String uid) {
		this.uid = uid;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getAvatar() {
		return avatar;
	}

	public void setAvatar(String avatar) {
		this.avatar = avatar;
	}

	public String getSortLetter() {
		return sortLetter;
	}

	public void setSortLetter(String sortLetter) {
		this.sortLetter = sortLetter;
	}

	public int getMutualFriendsCount() {
		return mutualFriendsCount;
	}

	public void setMutualFriendsCount(int mutualFriendsCount) {
		this.mutualFriendsCount = mutualFriendsCount;
	}

	public int getSex() {
		return sex;
	}

	public void setSex(int sex) {
		this.sex = sex;
	}

	public boolean isHasRegistered() {
		return hasRegistered;
	}

	public void setHasRegistered(boolean hasRegistered) {
		this.hasRegistered = hasRegistered;
	}

	public boolean isChecked() {
		return checked;
	}

	public void setChecked(boolean checked) {
		this.checked = checked;
	}

	public String getMobile() {
		return mobile;
	}

	public void setMobile(String mobile) {
		this.mobile = mobile;
	}

	public int getDataType() {
		return dataType;
	}

	public void setDataType(int dataType) {
		this.dataType = dataType;
	}

	public int getMarriage() {
		return marriage;
	}

	public void setMarriage(int marriage) {
		this.marriage = marriage;
	}

	public int getRelation() {
		return relation;
	}

	public void setRelation(int relation) {
		this.relation = relation;
	}

	public long getJoinTime() {
		return joinTime;
	}

	public void setJoinTime(long joinTime) {
		this.joinTime = joinTime;
	}

	public boolean isHasAdd() {
		return hasAdd;
	}

	public void setHasAdd(boolean hasAdd) {
		this.hasAdd = hasAdd;
	}

	public int getGid() {
		return gid;
	}

	public void setGid(int gid) {
		this.gid = gid;
	}
}
