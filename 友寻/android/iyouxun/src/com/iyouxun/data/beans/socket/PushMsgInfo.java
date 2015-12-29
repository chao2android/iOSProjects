package com.iyouxun.data.beans.socket;

import java.io.Serializable;

/**
 * 推送消息返回内容bean
 * 
 * @author duyuan
 * 
 */
public class PushMsgInfo implements Comparable<PushMsgInfo>, Serializable {
	private static final long serialVersionUID = 1L;
	public int cmd;
	public String nick = "";
	public long uid;
	public int qid;
	public int sex;
	public long time;
	public String pushtype = "";
	public String contentText = "";
	public String title = "";
	public int msgCount = 0;
	public boolean isRead;
	/** 动态新消息总数字 */
	public int newsMsgcount;
	/** 对方的uid */
	public long from;
	/** 动态id */
	public long fid;
	/** 评论回复的内容 */
	public String replay;
	/** 群组id */
	public int groupId;
	/** 显示的头像 */
	public String showIcon = "";
	/** 动态赞的数量 */
	public int praiseNum = 0;
	/** 动态转播的数量 */
	public int rebroadNum = 0;
	/** 动态回复的数量 */
	public int replyNum = 0;
	/** 动态评论回复的数量 */
	public int replyCommentNum = 0;

	public long getKey() {
		return uid;
	}

	@Override
	public int compareTo(PushMsgInfo another) {
		if (this.time > another.time) {
			return -1;
		} else if (this.time < another.time) {
			return 1;
		}
		return 0;
	}
}
