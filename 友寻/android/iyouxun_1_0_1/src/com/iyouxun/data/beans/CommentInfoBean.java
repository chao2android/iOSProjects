package com.iyouxun.data.beans;

/**
 * 评论信息
 * 
 * @ClassName: CommentInfoBean
 * @author likai
 * @date 2015-3-5 下午7:38:10
 * 
 */
public class CommentInfoBean {
	// 评论的动态的id
	public int feedId;
	// 动态的发布人
	public long feedUid;

	// 该条评论的id
	public int id;
	// 评论人的uid
	public long uid;
	// 评论人的昵称
	public String nick = "";
	// 评论人的头像
	public String avatar = "";
	// 评论人的性别
	public int sex;
	// 评论的内容
	public String content = "";
	// 回复的评论的id
	public int replyId;
	// 被回复人的uid
	public long replyUid;
	// 被回复人的昵称
	public String replyNick = "";
	// 被回复人的头像
	public String replyAvatar = "";
	// 被回复人的性别
	public int replySex;

	// 评论时间
	public String time = "";
}
