package com.iyouxun.data.beans.users;

import java.io.Serializable;

/***
 * 用户基类，所有和用户相关应继承此类
 * 
 * @author Administrator
 * 
 */
public class BaseUser implements Serializable {
	/**
	 * 
	 * @Fields serialVersionUID : TODO(用一句话描述这个变量表示什么)
	 */
	private static final long serialVersionUID = -4017696241128498906L;
	/** 用户UID */
	public long uid = 0;
	/** 昵称 */
	public String nickName = "";
	/** 性别 0:女 1：男 */
	public int sex;
	/** 年龄 */
	public int age;
	/** 用户名 */
	public String userName = "";
	/** 密码 */
	public String password = "";
	/** 头像 */
	public String avatarUrl = "";
	/** 手机号 */
	public String mobile = "";
	/** 情感状态 */
	public int marriage;
	/** 好友关系 0:非好友； 1:1度; 2:2度 */
	public int relation;
	/** 用户状态 3:加入黑名单，9：注销，1：正常 */
	public int gid;
}
