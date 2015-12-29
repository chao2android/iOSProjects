package com.iyouxun.data.beans;

import java.util.ArrayList;

import com.iyouxun.data.beans.users.BaseUser;

/**
 * 动态消息
 * 
 * @ClassName: NewsInfoBean
 * @author likai
 * @date 2015-3-5 下午7:35:15
 * 
 */
public class NewsInfoBean {
	/** 该条动态的发布人的uid */
	public long uid;
	/** 该条动态发布人的昵称 */
	public String nick = "";
	/** 头像 */
	public String avatar = "";
	/** 性别 0女，1男 */
	public int sex;
	/** 情感状态 1:单身2：恋爱中3:已婚4：保密 */
	public int marriage;
	/** 好友关系 1:1度好友，2:2度好友 */
	public int friendDimen;
	/** 发布时间 */
	public String date = "";
	/** 该条动态的id */
	public int feedId;
	/** 动态类型100-文字,101-图片,500-转播文字,501-转播图片 */
	public int type;
	/** 内容 */
	public String content = "";
	/** 动态内容(图片) */
	public ArrayList<PhotoInfoBean> contentPhoto = new ArrayList<PhotoInfoBean>();
	/** 转播内容的发布人昵称 */
	public String relayNick = "";
	/** 转播内容的发布人uid */
	public long relayUid;
	/** 转播内容的发布人头像 */
	public String relayAvatar = "";
	/** 转播人的性别0女，1男 */
	public int relaySex;
	/** 转播人的婚姻状态 1:单身2：恋爱中3:已婚4：保密 */
	public int relayMarriage;
	/** 转播人的好友关系1:1度好友，2：2度好友 */
	public int relayFriendDimen;
	/** 转播内容的feedid */
	public int relayFeedId;
	/** 转播内容的内容 */
	public String relayContent = "";
	/** 转播内容的类型100-文字,101-图片,500-转播文字,501-转播图片 */
	public int relayType;
	/** 转播内容的图片列表 */
	public ArrayList<PhotoInfoBean> relayContentPhoto = new ArrayList<PhotoInfoBean>();
	/** 转播内容的发布时间 */
	public String relayDate = "";
	/** 赞的数量 */
	public int praiseCount;
	/** 转播的数量 */
	public int rebroadcastCount;
	/** 评论的数量 */
	public int commentCount;
	/** 是否展开全部赞过的人 */
	public boolean isPraiseShowAll = false;
	/** 赞过的人的列表 */
	public ArrayList<BaseUser> praisePeople = new ArrayList<BaseUser>();
	/** 是否展开全部转播过的人 */
	public boolean isRebroadcastShowAll = false;
	/** 转播的人的列表 */
	public ArrayList<BaseUser> rebroadcastPeople = new ArrayList<BaseUser>();
	/** 评论内容列表 */
	public ArrayList<CommentInfoBean> comment = new ArrayList<CommentInfoBean>();
	/** 是否已经赞过该动态 */
	public int is_praise = 0;
	/** 是否转发过该动态 */
	public int is_rebroadcast = 0;
	/** 是否评论过该动态 */
	public int is_comment = 0;
	/** 该条动态是否已经删除 0:未删除，1：删除 */
	public int is_relay_del = 0;

	/** 动态的删除（内容存在）状态，0：正常，-1：删除 */
	public int status = 0;
	/** 转播的动态的删除（内容存在）状态，0：正常，-1：删除 */
	public int relayStatus = 0;

	/** 内容是否展开true：已获取，false：为获取 */
	public boolean contentIsGetLineCount = false;
	/** 当前折叠状态：0：折叠，1：打开 */
	public int contentIsOpenStatus = 0;
	/** 可显示的总行数 */
	public int contentLineCount = 1;
	/** 内容是否展开true：已获取，false：为获取 */
	public boolean relayContentIsGetLineCount = false;
	/** 当前折叠状态：0：折叠，1：打开 */
	public int relayContentIsOpenStatus = 0;
	/** 可显示的总行数 */
	public int relayContentLineCount = 1;
}
