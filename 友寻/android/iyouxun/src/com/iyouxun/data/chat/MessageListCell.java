package com.iyouxun.data.chat;

public class MessageListCell {
	// 个人消息列表
	public String oid = "";// uid
	public String avatar = "";// 头像
	public String content = "";// 信息内容
	public int newmsg; // 新记录数量
	public String timeStamp = "";// 时间戳
	public String nick = ""; // 用户昵称
	public int status;// 发送的信息状态
	public int sex;// 性别“0”女，“1”男
	public int chatType;// 0普通消息1群组消息
	public String groupId = "";// 群组id
	public int hint;// "hint","提醒" 0 接受 1 不接受
	public boolean systemMsg = false;// 系统信息列表
	public int item_countnew;// 新信息数量
}
