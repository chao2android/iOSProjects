package com.iyouxun.data.parser;

import java.util.HashMap;

import org.json.JSONObject;

import com.iyouxun.net.socket.protocol.AddFriendProtocol;
import com.iyouxun.net.socket.protocol.AgreeAddGroupProtocol;
import com.iyouxun.net.socket.protocol.ApplyAddGroupProtocol;
import com.iyouxun.net.socket.protocol.ChatMsgProtocol;
import com.iyouxun.net.socket.protocol.CreateGroupProtocol;
import com.iyouxun.net.socket.protocol.ExitGroupProtocol;
import com.iyouxun.net.socket.protocol.GroupMsgProtocol;
import com.iyouxun.net.socket.protocol.HaveNewFriendProtocol;
import com.iyouxun.net.socket.protocol.InvitationGroupProtocol;
import com.iyouxun.net.socket.protocol.NewTagProtocol;
import com.iyouxun.net.socket.protocol.NewsPraiseProtocol;
import com.iyouxun.net.socket.protocol.RefuseAddGroupProtocol;
import com.iyouxun.net.socket.protocol.RemoveGroupMembersProtocol;
import com.iyouxun.net.socket.protocol.SocketProtocol;
import com.iyouxun.net.socket.protocol.UpdateGroupNameProtocol;
import com.iyouxun.utils.DLog;

public class SocketParser {
	public static final String TAG = "SocketParser";
	// 广播
	public static final int CMD_MSG_TYPE_BORADCAST_SYSTEM = 201;
	// 建群消息
	public static final int CMD_MSG_TYPE_BORADCAST_CREATE_GROUP = 204;
	// 退群消息
	public static final int CMD_MSG_TYPE_BORADCAST_EXIT_GROUP = 205;
	// 群聊接口
	public static final int CMD_MSG_TYPE_BORADCAST_GROUP_CHAT = 206;
	// 提醒
	public static final int CMD_MSG_TYPE_UNREAD_MSG_COUNT = 132;
	// 未读消息
	public static final int CMD_MSG_TYPE_UNREAD_MSG_COUNT_APP = 135;
	// app 通知 单点聊天
	public static final int CMD_SEND_NEW_CHAT_MSG = 301;
	// 发送群聊消息
	public static final int CMD_SEND_NEW_GROUP_CHAT_MSG = 302;
	// 修改群组名称
	public static final int CMD_UPDATE_GROUP_NAME = 303;
	// 建群消息
	public static final int CMD_SEND_NEW_CREATE_GROUP_MSG = 304;
	// 申请加入群消息
	public static final int CMD_SEND_NEW_ADD_GROUP_MSG = 305;
	// 退群消息
	public static final int CMD_SEND_NEW_EXIT_GROUP_MSG = 306;
	// 接受好友加入群(只有群主操作)
	public static final int CMD_SEND_NEW_ACCEPT_FRIEND_JOIN_GROUP_MSG = 307;
	// 拒绝好友加入群(只有群主操作)
	public static final int CMD_SEND_NEW_REJECT_FRIEND_JOIN_GROUP_MSG = 308;
	// 群主踢人(只有群主操作)
	public static final int CMD_SEND_NEW_GROUP_MASTER_DEL_PERSON_MSG = 309;
	// 所有人可以邀请好友加入(一度)
	public static final int CMD_SEND_NEW_INVITE_FRIEND_JOIN_GROUP_MSG = 310;
	// 动态被赞
	public static final int CMD_SEND_NEW_LIKE_DYNAMIC_MSG = 311;
	// 转播你的动态
	public static final int CMD_SEND_NEW_REBROADCAST_DYNAMIC_MSG = 312;
	// 评论了你的动态
	public static final int CMD_SEND_NEW_COMMENT_DYNAMIC_MSG = 313;
	// 回复你的评论
	public static final int CMD_SEND_NEW_REPLY_COMMENT_MSG = 314;
	// 给用户新的一度好友打标签
	public static final int CMD_SEND_ONCE_FRIEND_ADD_TAGS_MSG = 315;
	// 用户A给自己打了标签XX
	public static final int CMD_SEND_OWN_ADD_TAGS_MSG = 316;
	// 好友申请
	public static final int CMD_SEND_ADD_FRIEND_MSG = 317;
	// 新好友加入
	public static final int CMD_SEND_NEW_FRIEND_JOIN_MSG = 318;
	// 新好友加入整点推送
	public static final int CMD_SEND_NEW_FRIEND_JOIN_HOUR_MSG = 319;
	// 发送动态信息
	public static final int CMD_UPLOAD_NEW_NEWS = 999;

	private HashMap<Integer, Class> protocols;
	private static SocketParser sParser;

	private SocketParser() {
		init();
	}

	private void init() {
		protocols = new HashMap<Integer, Class>();
		protocols.put(CMD_SEND_NEW_CHAT_MSG, ChatMsgProtocol.class);
		protocols.put(CMD_SEND_NEW_LIKE_DYNAMIC_MSG, NewsPraiseProtocol.class);
		protocols.put(CMD_SEND_NEW_REBROADCAST_DYNAMIC_MSG, NewsPraiseProtocol.class);
		protocols.put(CMD_SEND_NEW_COMMENT_DYNAMIC_MSG, NewsPraiseProtocol.class);
		protocols.put(CMD_SEND_NEW_REPLY_COMMENT_MSG, NewsPraiseProtocol.class);
		protocols.put(CMD_SEND_NEW_GROUP_CHAT_MSG, GroupMsgProtocol.class);
		protocols.put(CMD_SEND_NEW_ADD_GROUP_MSG, ApplyAddGroupProtocol.class);
		protocols.put(CMD_SEND_NEW_EXIT_GROUP_MSG, ExitGroupProtocol.class);
		protocols.put(CMD_SEND_NEW_ACCEPT_FRIEND_JOIN_GROUP_MSG, AgreeAddGroupProtocol.class);
		protocols.put(CMD_SEND_NEW_REJECT_FRIEND_JOIN_GROUP_MSG, RefuseAddGroupProtocol.class);
		protocols.put(CMD_SEND_OWN_ADD_TAGS_MSG, NewTagProtocol.class);
		protocols.put(CMD_SEND_NEW_INVITE_FRIEND_JOIN_GROUP_MSG, InvitationGroupProtocol.class);
		protocols.put(CMD_SEND_ADD_FRIEND_MSG, AddFriendProtocol.class);
		protocols.put(CMD_SEND_NEW_GROUP_MASTER_DEL_PERSON_MSG, RemoveGroupMembersProtocol.class);
		protocols.put(CMD_SEND_NEW_FRIEND_JOIN_MSG, HaveNewFriendProtocol.class);
		protocols.put(CMD_SEND_NEW_FRIEND_JOIN_HOUR_MSG, HaveNewFriendProtocol.class);
		protocols.put(CMD_SEND_NEW_CREATE_GROUP_MSG, CreateGroupProtocol.class);
		protocols.put(CMD_UPDATE_GROUP_NAME, UpdateGroupNameProtocol.class);
	}

	public SocketProtocol getSocketProtocol(int cmd) {
		try {
			if (protocols.containsKey(cmd)) {
				return (SocketProtocol) protocols.get(cmd).newInstance();
			}
		} catch (Exception e) {
			DLog.e(e);
		}
		return null;
	}

	public static SocketParser getInstance() {
		if (sParser == null) {
			sParser = new SocketParser();
		}
		return sParser;
	}

	/**
	 * 解析推送的数据 格式{"cmd":103,"data":{"nick":"likai","uid":100000}}
	 * 
	 * @return SocketProtocol 返回类型
	 * @param @param str
	 * @param @return 参数类型
	 * @author likai
	 */
	public SocketProtocol parseData(String str) {
		int i = str.indexOf("\"cmd");
		if (i != -1) {
			// String st = str.substring(i, str.length());
			try {
				JSONObject obj = new JSONObject(str);
				int cmd = obj.optInt("cmd");
				SocketProtocol protocol = getSocketProtocol(cmd);
				return protocol.getResponseObj(obj);
			} catch (Exception e) {
				DLog.e(e);
			}
		}
		return null;
	}

}
