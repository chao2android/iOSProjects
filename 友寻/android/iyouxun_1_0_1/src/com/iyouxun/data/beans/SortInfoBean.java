package com.iyouxun.data.beans;

/**
 * 用户列表用户信息（带排序）
 * 
 * @ClassName: SortInfoBean
 * @author likai
 * @date 2015-3-10 上午10:04:47
 * 
 */
public class SortInfoBean {
	/** 用户uid */
	public long uid;
	/** 显示的数据 */
	public String name = "";
	/** 用户头像 */
	public String avatar = "";
	/** 显示数据拼音的首字母 */
	public String sortLetter = "";
	/** 状态 */
	public int status = 0;
	/** 情感状态 */
	public int marriage = 0;
	/** 性别 */
	public int sex = 0;
	/** 共同好友数量 */
	public int sameFriendsNum = 0;
	/** 好友维度 */
	public int friendDimen = 1;
	/** 类型 */
	public int type;
	/** 该用户是否注册0:未注册，1：已注册 */
	public int isReg = 1;
	/** 手机号 */
	public String mobileNumber = "";
	/** 是否选择 */
	public boolean isChecked;
}
