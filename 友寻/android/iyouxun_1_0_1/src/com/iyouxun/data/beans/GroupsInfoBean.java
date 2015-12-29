package com.iyouxun.data.beans;

import java.io.Serializable;
import java.util.ArrayList;

import com.iyouxun.data.beans.users.GroupUser;

/**
 * 群组信息
 * 
 * @ClassName: GroupsListBean
 * @author likai
 * @date 2015-3-2 下午7:53:55
 * 
 */
public class GroupsInfoBean implements Serializable {
	/** 群主id */
	public long uid;
	/** 群组id */
	public int id;
	/** 群组名称 */
	public String name = "";
	/** 群组简介 */
	public String intro = "";
	/** 群组人数 */
	public int count = 1;
	/** 群icon */
	public String logo = "";
	/**
	 * 权限设置 0-所有人可以直接加入 1-所有人需要申请加入 2-只允许一度好友和二度好友直接加入 3-只允许一度好友和二度好友申请加入
	 * 4-禁止任何人加入
	 */
	public int privilege = 1;
	/** 状态(在资料页是否显示 0显示 1不显示) */
	public int show = 1;
	/** 提醒 0 接受 1 不接受 */
	public int hint = 0;
	/** 群中，好友数量 */
	public int friendsNum;
	/** 0不公开，1公开（将推荐给好友） */
	public int status;
	/** 群主id */
	public long masterId;
	/** 群组成员 */
	public ArrayList<GroupUser> userList = new ArrayList<GroupUser>();
	/** 在资料页是否显示"(类型int) 0显示 1不显示 */

	/** 是否加入该群组 0：未加入，1：已加入 */
	public int isJoin = 0;
}
