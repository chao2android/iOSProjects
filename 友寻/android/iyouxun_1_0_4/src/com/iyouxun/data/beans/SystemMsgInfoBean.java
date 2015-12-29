package com.iyouxun.data.beans;

/**
 * 系统消息，消息体
 * 
 * @ClassName: SystemMsgInfoBean
 * @author likai
 * @date 2015-3-25 上午11:18:47
 * 
 */
public class SystemMsgInfoBean {
	/** 当前消息的id */
	public String iid = "";
	/** 用户uid */
	public long uid;
	/** 消息类型 17:动态被赞，18：动态被转播，19：动态被评论，20：被回复评论 */
	public int type;
	/** 时间 */
	public String time = "";
	/** 动态feedId */
	public int feedId;
	/** 动态回复数量 */
	public String feedCommentNum = "";
	/** 消息状态，是否已读0：未读，1：已读 */
	public int status;
	/** 动态类型 100:文字动态，101：图片动态，500：转播文字动态，501：转播图片动态 */
	public int feedType;
	/** 动态内容 */
	public String feedContent = "";
	/** 动态图片 */
	public String feedImgUrl = "";
	/** 动态评论内容 */
	public String commentContent = "";
	/**
	 * @Fields groupId : 群组id
	 */
	public String groupId;
	/**
	 * @Fields groupName : 群组名称
	 */
	public String groupName;
	/**
	 * @Fields nick : 用户名称
	 */
	public String nick;
	/**
	 * @Fields avatar : 用户头像
	 */
	public String avatar = "";
	/**
	 * @Fields privonce : 省份
	 */
	public String privonce = "";
	/**
	 * @Fields city : 城市
	 */
	public String city = "";

	/**
	 * @Fields relation : 0没关系 1一度好友2二度好友
	 */
	public int relation = 0;
	/**
	 * @Fields acceptType : -1-未做处理 1-通过， 2-不通过
	 */
	public int acceptType = -1;
	/**
	 * @Fields friendnick : 群组中有关系的用户昵称
	 */
	public String friendnick = "";
	/**
	 * @Fields tagName : 标签名称
	 */
	public String tagName = "";

	/**
	 * @Fields friendlists : 共同好友
	 */
	public String friendlists = "";

	/**
	 * @Fields uname : 通讯录名称
	 */
	public String uname = "";

	/**
	 * @Fields sysytemMsgStatus : 系统消息操作状态0未读，1已读，2已操作，3接受，4拒绝
	 */
	public int sysytemMsgStatus = 0;

	/** 该条动态消息是否已经删除 0:未删除，1：已删除 */
	public int fstatus = 0;
}
