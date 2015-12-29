package com.iyouxun.data.chat;

import java.util.ArrayList;
import java.util.List;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;

import com.iyouxun.utils.Util;

public class ChatDBHelper extends SQLiteOpenHelper {
	public static final String IMG_HEIGHT = "img_height";// 图片高度
	public static final String IMG_WIDTH = "img_width";// 图片宽度
	public static final String FILE_NAME_THUMB = "file_name_thumb";// 缩略图
	public static final String FILE_NAME = "file_name";// 文件名称
	public static final String VOICE_LENGTH = "voice_length";// 语音时长
	public static final String IS_ACK = "is_ack";// 未读状态
	public static final String CONTENT = "content";// 消息内容
	public static final String CREATED_AT = "created_at";// 创建时间
	public static final String MSG_STATUS = "msg_status";// 消息状态
	public static final String BOX_TYPE = "box_type";// 收发状态
	public static final String MIME_TYPE = "mime_type";// 消息类型文字语音图片
	public static final String MSG_ID = "msg_id";// 消息id
	public static final String CHAT_TYPE = "chat_type";// 消息类型群组消息普通消息
	public static final String LASTMSG_STATUS = "lastmsg_status";// 消息发送状态
	public static final String SEX = "sex";// 性别
	public static final String AVATAR = "avatar";// 头像
	public static final String NICKNAME = "nickname";// 昵称
	public static final String _ID = "_id";// 消息本地id
	public static final String GROUP_ID = "group_id";// 群组id
	public static final String CTIME = "ctime";// 创建时间
	public static final String CONTACT_UID = "contact_uid";// 用户id
	public static final String NEW_MSG_COUNT = "new_msg_count";// 新消息数量
	public static final String LAST_MSG = "last_msg";// 最新一条消息
	public static final String GROUP_USER_SEX = "group_user_sex";// 群组用户性别
	public static final String GROUP_USER_NICK = "group_user_nick";// 群组用户昵称
	public static final String GROUP_USER_AVATAR = "group_user_avatar";// 群组用户头像
	public static final String GROUP_USER_UID = "group_user_uid";// 群组用户uid
	public static final String ALL_NEW_MSG_COUNT = "all_new_msg_count";// 新消息数量
	public static final String GROUP_HINT = "group_hint";
	public static final String PHOTO_ID = "photo_id";// 图片id
	private final static int VERSION = 5;// 版本号

	private final String tableChatFriend = "chat_friend";// 消息用户表
	// 聊天好友记录表，创建语句
	private final String createTableChatFriend = "create table chat_friend (_id integer primary key autoincrement,contact_uid text,"
			+ "avatar text,nickname text,ctime timestamp,new_msg_count integer default 0,group_id text,"
			+ "last_msg text,lastmsg_status integer default 0,sex integer default 0,chat_type integer default 0,"
			+ "group_hint integer default 0)";
	private final String tableChatMsg = "chat_msg";// 聊天记录表名
	private final String dropTableChatFriend = "drop table chat_friend";// 删除聊天好友记录表语句
	private final String dropTableChatMsg = "drop table chat_msg";// 删除聊天记录表语句
	// 聊天记录表，创建语句
	private final String createTableChatMsg = "create table chat_msg (_id integer primary key autoincrement,"
			+ "msg_id integer default 0,mime_type text,box_type integer,msg_status integer default 0,"
			+ "created_at timestamp ,content text,contact_uid text ,group_id text ,chat_type integer default 0,is_ack integer default 0,file_name text,"
			+ "file_name_thumb text,voice_length integer default 0,img_width integer default 0, img_height integer default 0,"
			+ "group_user_sex integer default 0,group_user_nick text,group_user_avatar text,group_user_uid text,photo_id text)";
	public SQLiteDatabase db;
	private static ChatDBHelper instance;

	public ChatDBHelper(Context context, String name, CursorFactory factory, int version) {
		super(context, name, factory, version);
		db = getWritableDatabase();
	}

	public ChatDBHelper(Context context, String uid) {
		this(context, uid, null, VERSION);
	}

	/**
	 * 创建聊天记录表、聊天对象记录表
	 * */
	private void createTable(SQLiteDatabase db) {
		db.execSQL(createTableChatFriend);// 聊天好友记录表
		db.execSQL(createTableChatMsg);// 聊天信息记录表
	}

	/**
	 * 创建数据库
	 * */
	@Override
	public void onCreate(SQLiteDatabase db) {
		createTable(db);
	}

	/**
	 * 更新数据库| 删除记录表，重新创建
	 * */
	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		db.execSQL(dropTableChatFriend);
		db.execSQL(dropTableChatMsg);
		createTable(db);
	}

	/**
	 * 添加一个新聊天用户到聊天联系人表
	 * 
	 * @return The row ID of the newly inserted row, or -1 if an error
	 *         occurred.If contact exist,update the information and return the
	 *         number of rows affected
	 */
	public synchronized long addContact(ChatListItem item, String ctime) {
		long retcode = -2;
		if (item == null) {
			return retcode;
		}
		String uid = item.uid;
		String nickname = item.nickName;
		String avatar = item.userIconUrl;
		String last_msg = item.last_msg;
		int new_msgcount = item.count;
		int sex = item.sex;
		int lastmsg_status = item.msgStatus;
		int chat_type = item.chatType;
		String group_id = item.groupId;
		int group_hint = item.hint;
		if (Util.isBlankString(uid) && chat_type == 0 && uid.equals("0")) {
			return retcode;
		} else if (Util.isBlankString(group_id) && chat_type == 1 && group_id.equals("0")) {
			return retcode;
		}

		// 检查该用户是否已经存在于数据库中
		if (db != null && db.isOpen()) {
			Cursor cursor = null;
			if (chat_type == 0) {
				cursor = db.query(tableChatFriend, new String[] { CONTACT_UID, CTIME }, CONTACT_UID + "=? and " + CHAT_TYPE
						+ "=?", new String[] { uid, chat_type + "" }, null, null, null);
			} else if (chat_type == 1) {
				cursor = db.query(tableChatFriend, new String[] { GROUP_ID, CTIME }, GROUP_ID + "=? and " + CHAT_TYPE + "=?",
						new String[] { group_id, chat_type + "" }, null, null, null);
			}
			String tempUid = null;
			String oldTime = null;
			String groupId = null;
			while (cursor != null && cursor.moveToNext()) {
				if (chat_type == 0) {
					tempUid = cursor.getString(cursor.getColumnIndex(CONTACT_UID));
				} else if (chat_type == 1) {
					groupId = cursor.getString(cursor.getColumnIndex(GROUP_ID));
				}
				oldTime = cursor.getString(cursor.getColumnIndex(CTIME));
			}
			cursor.close();

			if ((tempUid != null && tempUid.equals(uid)) || (groupId != null && groupId.equals(group_id))) {
				retcode = updateContact(uid, nickname, avatar, ctime, last_msg, new_msgcount, sex, Long.valueOf(oldTime),
						lastmsg_status, chat_type, group_id, group_hint);
			} else {
				ContentValues values = new ContentValues();
				if (!Util.isBlankString(uid)) {
					values.put(CONTACT_UID, uid);
				}
				if (!Util.isBlankString(nickname)) {
					values.put(NICKNAME, nickname);
				}
				if (!Util.isBlankString(avatar)) {
					values.put(AVATAR, avatar);
				}
				if (!Util.isBlankString(ctime)) {
					values.put(CTIME, ctime);
				}
				values.put(NEW_MSG_COUNT, new_msgcount);
				if (!Util.isBlankString(last_msg)) {
					values.put(LAST_MSG, last_msg);
				}
				values.put(SEX, sex);// 性别
				values.put(LASTMSG_STATUS, lastmsg_status);// 发送状态
				values.put(CHAT_TYPE, chat_type);
				if (!Util.isBlankString(group_id)) {
					values.put(GROUP_ID, group_id);
				}
				values.put(GROUP_HINT, group_hint);
				retcode = db.insert(tableChatFriend, null, values);
			}
		}

		return retcode;
	}

	/**
	 * 更新聊天人信息
	 * 
	 * @param oldCtime 旧记录的时间，用于比较是否要更新该记录
	 * @param group_id
	 * @param group_hint2
	 * 
	 * @return the number of rows affected,if -1 illegal user id.
	 */
	public synchronized int updateContact(String uid, String nickname, String avatar, String ctime, String last_msg,
			int new_msgcount, int sex, long oldCtime, int lastmsg_status, int chat_type, String group_id, int group_hint) {
		int retcode = -1;
		ContentValues values = new ContentValues();
		if (chat_type == 0) {
			if (Util.isBlankString(uid)) {
				return retcode;
			}
		} else if (chat_type == 1) {
			if (Util.isBlankString(group_id)) {
				return retcode;
			}
		}
		// 获取当前该用户的记录中的时间戳，对比需要更改的时间戳，如果当前的时间戳比该记录中的时间戳的时间早，就不再更新
		long newCtime = Long.valueOf(ctime);// 这次要更新的记录时间
		if (newCtime >= oldCtime) {
			values.put(CONTACT_UID, uid);
			if (!Util.isBlankString(nickname)) {
				values.put(NICKNAME, nickname);
			}
			if (!Util.isBlankString(avatar)) {
				values.put(AVATAR, avatar);
			}
			values.put(CTIME, ctime);// 最后一条记录的时间

			if (new_msgcount >= 0) {
				values.put(NEW_MSG_COUNT, new_msgcount);
			}
			if (!Util.isBlankString(last_msg)) {
				values.put(LAST_MSG, last_msg);
			}
			values.put(SEX, sex);
			if (lastmsg_status >= 0) {
				values.put(LASTMSG_STATUS, lastmsg_status);
			}
			values.put(CHAT_TYPE, chat_type);
			if (!Util.isBlankString(group_id)) {
				values.put(GROUP_ID, group_id);
			}
			values.put(GROUP_HINT, group_hint);
			if (chat_type == 0) {
				retcode = db.update(tableChatFriend, values, CONTACT_UID + "=? and " + CHAT_TYPE + "=?", new String[] { uid,
						chat_type + "" });
			} else if (chat_type == 1) {
				retcode = db.update(tableChatFriend, values, GROUP_ID + "=? and " + CHAT_TYPE + "=?", new String[] { group_id,
						chat_type + "" });
			}
		}

		return retcode;
	}

	/**
	 * 更新消息的未读状态-设置为已读状态
	 * 
	 * */
	public synchronized void updateUnreadMsgStatus(String msgid) {
		if (msgid != null && !Util.isBlankString(msgid) && Long.valueOf(msgid) > 0) {
			String sql = "update chat_msg set is_ack = 1 where msg_id='" + msgid + "'";
			db.execSQL(sql);
		}
	}

	/**
	 * 更新所有未读的非语音消息为已读状态 <br />
	 * 需要去除发送失败的消息
	 * */
	public synchronized void updateUnreadTxtMsgStatus(String oid) {
		if (!Util.isBlankString(oid)) {
			String sql = "update chat_msg set is_ack = 1 where mime_type != 'audio/amr' and msg_id > 0 and contact_uid = '" + oid
					+ "'";
			db.execSQL(sql);
		}
	}

	/**
	 * 更新该uid用户的新纪录数量
	 * 
	 * @param uid User id.
	 * @param count New message count.
	 * @return the number of rows affected
	 */
	public synchronized int updateNewMessageCount(String uid, int count, String last_msg, String group_id, int chat_type) {
		ContentValues values = new ContentValues();
		values.put(NEW_MSG_COUNT, count);
		if (!Util.isBlankString(last_msg)) {
			values.put(LAST_MSG, last_msg);
		}
		int retcode = -1;
		if (chat_type == 0) {
			retcode = db.update(tableChatFriend, values, CONTACT_UID + "=? and " + CHAT_TYPE + "=?", new String[] { uid,
					chat_type + "" });
		} else if (chat_type == 1) {
			retcode = db.update(tableChatFriend, values, GROUP_ID + "=? and " + CHAT_TYPE + "=?", new String[] { group_id,
					chat_type + "" });
		}
		return retcode;
	}

	/**
	 * @Title: updateMessageHint
	 * @Description: 更新群消息接收状态
	 * @return int 返回类型
	 * @param @param group_id
	 * @param @param hint
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public synchronized void updateMessageHint(String group_id, int hint) {
		String sql = "update " + tableChatFriend + " set " + GROUP_HINT + " = " + hint + " where chat_type = 1 and " + GROUP_ID
				+ "= '" + group_id + "'";
		db.execSQL(sql);
	}

	/**
	 * 自动更新聊天记录数量
	 * */
	public synchronized void autoIncrementNewMsgCount(String uid) {
		String sql = "update chat_friend set new_msg_count = new_msg_count + 1 where chat_type = 0 and contact_uid='" + uid + "'";
		db.execSQL(sql);
	}

	/**
	 * 自动更新群组聊天记录数量
	 * */
	public synchronized void autoIncrementNewGroupMsgCount(String groupId) {
		String sql = "update chat_friend set new_msg_count = new_msg_count + 1 where chat_type = 1 and group_id='" + groupId
				+ "'";
		db.execSQL(sql);
	}

	/**
	 * @Title: getAllNewMsgCount
	 * @Description: 获得未读消息数字
	 * @return int 返回类型
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public synchronized int getAllNewMsgCount() {
		String sql = "select sum (" + NEW_MSG_COUNT + ") as " + ALL_NEW_MSG_COUNT + " from " + tableChatFriend;
		Cursor cursor = db.rawQuery(sql, null);
		int count = 0;
		while (cursor.moveToNext()) {
			count = cursor.getInt(cursor.getColumnIndex(ALL_NEW_MSG_COUNT));
		}
		if (cursor != null) {
			cursor.close();
		}
		return count;
	}

	/**
	 * @Title: getShowMsgNewMsgCount
	 * @Description: 显示初次记载后的未读消息数字
	 * @return int 返回类型
	 * @param @param size
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public synchronized int getShowMsgNewMsgCount(int size) {
		String sql = "select * " + " from " + tableChatFriend + " order by " + CTIME + " desc limit 0," + size;
		Cursor cursor = db.rawQuery(sql, null);
		int count = 0;
		for (cursor.moveToFirst(); !cursor.isAfterLast(); cursor.moveToNext()) {
			int hint = cursor.getInt(cursor.getColumnIndex(GROUP_HINT));
			if (hint != 1) {
				count += cursor.getInt(cursor.getColumnIndex(NEW_MSG_COUNT));
			}
		}
		if (cursor != null) {
			cursor.close();
		}
		return count;
	}

	/**
	 * 清除未读新信息的数量
	 * */
	public synchronized void clearUnreadMsgCount(String uid) {
		String sql = "update chat_friend set new_msg_count = 0 where contact_uid = '" + uid + "'";
		db.execSQL(sql);
	}

	/**
	 * @Title: updateLastMessage
	 * @Description: 更新最后一条聊天记录
	 * @return int 返回类型
	 * @param @param uid 用户id
	 * @param @param last_msg 最后一条消息
	 * @param @param status 消息状态
	 * @param @param ctime 创建时间
	 * @param @param chat_type 消息类型0普通消息1群组消息
	 * @param @param group_id群组id
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public synchronized int updateLastMessage(String uid, String last_msg, int status, String ctime, int chat_type,
			String group_id) {
		ContentValues values = new ContentValues();
		values.put(LAST_MSG, last_msg);
		values.put(LASTMSG_STATUS, status);
		if (!Util.isBlankString(ctime)) {
			values.put(CTIME, ctime);
		}
		values.put(GROUP_ID, group_id);
		values.put(CHAT_TYPE, chat_type);
		int retcode = -1;
		if (chat_type == 1) {// 群组消息
			retcode = db.update(tableChatFriend, values, GROUP_ID + "=? and " + CHAT_TYPE + "=?", new String[] { group_id,
					chat_type + "" });
		} else if (chat_type == 0) {// 普通消息
			retcode = db.update(tableChatFriend, values, CONTACT_UID + "=? and " + CHAT_TYPE + "=?", new String[] { uid,
					chat_type + "" });
		}
		return retcode;
	}

	/**
	 * 从数据库中删除一个联系人（非标记删除）
	 * 
	 * @param uid
	 * @return the number of rows affected if a whereClause is passed in, 0
	 *         otherwise.
	 */
	public synchronized int deleteContact(String uid, String group_id, int chat_type) {
		int retcode = -1;
		if (chat_type == 0) {
			retcode = db
					.delete(tableChatFriend, CONTACT_UID + "=? and " + CHAT_TYPE + "=?", new String[] { uid, chat_type + "" });
		} else if (chat_type == 1) {
			retcode = db.delete(tableChatFriend, GROUP_ID + "=? and " + CHAT_TYPE + "=?",
					new String[] { group_id, chat_type + "" });
		}
		return retcode;
	}

	/**
	 * 从数据库中删除所有联系人信息
	 * 
	 * */
	public synchronized int deleteAllContact() {
		int retcode = db.delete(tableChatFriend, null, null);
		return retcode;
	}

	/**
	 * Fetch all contacts information.You should close the database after the
	 * operation finished. 查询所有联系人的信息，按照时间倒叙排列
	 * 
	 * @return A Cursor to operate all contacts information.
	 */
	public synchronized Cursor queryAllContacts() {
		Cursor cursor = db.query(tableChatFriend, null, null, null, null, null, "ctime desc");
		return cursor;
	}

	/**
	 * 分页查询联系人信息
	 * 
	 * @page 页码 0-n
	 * @pageSize 每页加载数量
	 * */
	public synchronized Cursor queryContactsByPage(int page, int pageSize) {
		page = page <= 0 ? 0 : page;
		int startNum = page * pageSize;
		StringBuilder limit = new StringBuilder();
		limit.append(startNum);
		limit.append(",");
		limit.append(pageSize);

		Cursor cursor = db.query(tableChatFriend, null, null, null, null, null, "ctime desc", limit.toString());

		return cursor;
	}

	/**
	 * 分页查询联系人信息
	 * 
	 * @page 页码 0-n
	 * @pageSize 每页加载数量
	 * */
	public synchronized Cursor queryContactsByTime(long pageTime, int pageSize) {
		String selection = null;// 查询字段
		String[] selectionArgs = null;// 查询字段的值
		if (pageTime > 0) {
			// msgid为0，可能是初始化页面的时候，第一页的获取
			selection = "ctime < ?";// 查询字段
			selectionArgs = new String[] { String.valueOf(pageTime) };// 查询字段的值
		}

		StringBuilder limit = new StringBuilder();
		limit.append(0);
		limit.append(",");
		limit.append(pageSize);

		Cursor cursor = db.query(tableChatFriend, null, selection, selectionArgs, null, null, "ctime desc", limit.toString());
		return cursor;
	}

	/**
	 * 根据用户uid，获取该用户的所有联系人信息
	 * */
	public synchronized Cursor queryContactById(String uid, String group_id, int chat_type) {
		String selection = "";
		String selectionArgs[] = null;
		if (chat_type == 0) {
			selection = CONTACT_UID + "=? and " + CHAT_TYPE + "=?";
			selectionArgs = new String[] { uid, chat_type + "" };
		} else if (chat_type == 1) {
			selection = GROUP_ID + "=? and " + CHAT_TYPE + "=?";
			selectionArgs = new String[] { group_id, chat_type + "" };
		}
		Cursor cursor = db.query(tableChatFriend, null, selection, selectionArgs, null, null, null);
		return cursor;
	}

	/**
	 * 通过uid获取新聊天记录数量
	 * */
	public synchronized int getNewMessageCountById(String uid) {
		int newMsgCount = 0;
		Cursor cursor = db.query(tableChatFriend, new String[] { NEW_MSG_COUNT }, "contact_uid=?", new String[] { uid }, null,
				null, null);
		if (cursor != null) {
			cursor.moveToFirst();
			newMsgCount = cursor.getInt(cursor.getColumnIndex(NEW_MSG_COUNT));
		}
		cursor.close();
		return newMsgCount;
	}

	/**
	 * 查询出所有新消息数量>0的用户
	 * 
	 * */
	public synchronized Cursor getContactHasNewMessage() {
		String sql = "select * from " + tableChatFriend + " where new_msg_count > 0";
		Cursor cursor = db.rawQuery(sql, null);
		return cursor;
	}

	/**
	 * 通过页码获取聊天记录
	 * 
	 * @param uid
	 * @param page 起始页码 从0开始
	 * @param size 取记录数量
	 * @return List with queried data, if no data meets rule then return a empty
	 *         list.
	 */
	public synchronized ArrayList<ChatItem> queryChatRecord(String uid, int page, int size) {
		String selection = "contact_uid=?";// 查询字段
		String[] selectionArgs = new String[] { uid };// 查询字段的值

		int startNum = 0;// 开始数
		page = page <= 0 ? 0 : page;
		startNum = page * size;

		StringBuilder limit = new StringBuilder();
		limit.append(startNum);
		limit.append(",");
		limit.append(size);
		ArrayList<ChatItem> lst = new ArrayList<ChatItem>();
		// 通过时间排序
		Cursor cursor = db.query(tableChatMsg, null, selection, selectionArgs, null, null, "created_at desc", limit.toString());
		if (cursor == null) {
			return lst;
		}
		if (cursor.getCount() <= 0) {
			cursor.close();
			return lst;
		}
		cursor.moveToLast();
		do {
			ChatItem item = new ChatItem();
			item.setId(cursor.getInt(cursor.getColumnIndex(_ID)));
			item.setMsgId(cursor.getString(cursor.getColumnIndex(MSG_ID)));
			item.setMimeType((cursor.getString(cursor.getColumnIndex(MIME_TYPE))));
			item.setBoxType(cursor.getInt(cursor.getColumnIndex(BOX_TYPE)));
			// 状态改变
			int msgStatus = cursor.getInt(cursor.getColumnIndex(MSG_STATUS));
			if (msgStatus == ChatConstant.MSG_SYNCHRONIZING) {
				msgStatus = ChatConstant.MSG_SYNCHRONIZE_FAILED;
			}
			item.setStatus(msgStatus);
			item.setTimeStamp(cursor.getString(cursor.getColumnIndex(CREATED_AT)));
			item.setContent(cursor.getString(cursor.getColumnIndex(CONTENT)));
			item.setContactId(cursor.getString(cursor.getColumnIndex(CONTACT_UID)));
			item.setIsAck(cursor.getInt(cursor.getColumnIndex(IS_ACK)));
			item.setVoiceLength(cursor.getInt(cursor.getColumnIndex(VOICE_LENGTH)));
			item.setFileName(cursor.getString(cursor.getColumnIndex(FILE_NAME)));
			item.setFileNameThumb(cursor.getString(cursor.getColumnIndex(FILE_NAME_THUMB)));
			item.setThumbImageWidth(cursor.getInt(cursor.getColumnIndex(IMG_WIDTH)));
			item.setThumbImageHeight(cursor.getInt(cursor.getColumnIndex(IMG_HEIGHT)));
			item.setChatType(cursor.getInt(cursor.getColumnIndex(CHAT_TYPE)));
			item.setGroupId(cursor.getString(cursor.getColumnIndex(GROUP_ID)));
			item.setGroupUserAvatar(cursor.getString(cursor.getColumnIndex(GROUP_USER_AVATAR)));
			item.setGroupUserNick(cursor.getString(cursor.getColumnIndex(GROUP_USER_NICK)));
			item.setGroupUserSex(cursor.getInt(cursor.getColumnIndex(GROUP_USER_SEX)));
			item.setGroupUserUid(cursor.getString(cursor.getColumnIndex(GROUP_USER_UID)));
			item.setPid(cursor.getString(cursor.getColumnIndex(PHOTO_ID)));
			lst.add(item);
		} while (cursor.moveToPrevious());
		cursor.close();
		return lst;
	}

	/**
	 * 通过给定的某一消息id获取该id之前的size条聊天记录
	 * 
	 * @param oid 要查询的对方的uid
	 * @param msgid 要从该msgid进行记录查询
	 * @param size 取记录数量
	 * @return List with queried data, if no data meets rule then return a empty
	 *         list.
	 */
	public synchronized ArrayList<ChatItem> queryChatRecordByMsgid(String oid, long msgId, int size) {
		String selection = "contact_uid=? and msg_id<?";// 查询字段
		String[] selectionArgs = new String[] { oid, String.valueOf(msgId) };// 查询字段的值
		if (msgId <= 0) {
			// msgid为0，可能是初始化页面的时候，第一页的获取
			selection = "contact_uid=?";// 查询字段
			selectionArgs = new String[] { oid };// 查询字段的值
		}
		StringBuilder limit = new StringBuilder();
		limit.append(0);
		limit.append(",");
		limit.append(size);
		ArrayList<ChatItem> lst = new ArrayList<ChatItem>();
		// 通过时间排序
		Cursor cursor = db.query(tableChatMsg, null, selection, selectionArgs, null, null, "created_at desc", limit.toString());
		if (cursor == null) {
			return lst;
		}
		if (cursor.getCount() <= 0) {
			cursor.close();
			return lst;
		}
		cursor.moveToLast();
		do {
			ChatItem item = new ChatItem();
			setChatIitem(item, cursor);
			lst.add(item);
		} while (cursor.moveToPrevious());
		cursor.close();
		return lst;
	}

	/**
	 * 通过给定的时间戳获取该时间戳之前的size条聊天记录
	 * 
	 * @param oid 要查询的对方的uid
	 * @param timestamp 要从该时间戳进行记录查询
	 * @param size 取记录数量
	 * @return List with queried data, if no data meets rule then return a empty
	 *         list.
	 */
	public synchronized ArrayList<ChatItem> queryChatRecordByTime(String oid, long timestamp, int size, int chat_type,
			String group_id) {
		ArrayList<ChatItem> lst = new ArrayList<ChatItem>();
		String selection = "";
		String[] selectionArgs = null;
		if (chat_type == 0) {
			if (Util.isBlankString(oid)) {
				return lst;
			}
			selection = CONTACT_UID + "=? and " + CREATED_AT + "<? and " + CHAT_TYPE + "=?";// 查询字段
			selectionArgs = new String[] { oid, String.valueOf(timestamp), chat_type + "" };// 查询字段的值
		} else if (chat_type == 1) {
			if (Util.isBlankString(group_id)) {
				return lst;
			}
			selection = GROUP_ID + "=? and " + CREATED_AT + "<? and " + CHAT_TYPE + "=?";// 查询字段
			selectionArgs = new String[] { group_id, String.valueOf(timestamp), chat_type + "" };// 查询字段的值
		}
		if (timestamp <= 0) {
			// msgid为0，可能是初始化页面的时候，第一页的获取
			if (chat_type == 0) {
				selection = CONTACT_UID + "=? and " + CHAT_TYPE + "=?";// 查询字段
				selectionArgs = new String[] { oid, chat_type + "" };// 查询字段的值
			} else if (chat_type == 1) {
				selection = GROUP_ID + "=? and " + CHAT_TYPE + "=?";// 查询字段
				selectionArgs = new String[] { group_id, chat_type + "" };// 查询字段的值
			}
		}
		StringBuilder limit = new StringBuilder();
		limit.append(0);
		limit.append(",");
		limit.append(size);
		// 通过时间排序
		Cursor cursor = db.query(tableChatMsg, null, selection, selectionArgs, null, null, "created_at desc", limit.toString());
		if (cursor == null) {
			return lst;
		}
		if (cursor.getCount() <= 0) {
			cursor.close();
			return lst;
		}
		cursor.moveToLast();
		do {
			ChatItem item = new ChatItem();
			setChatIitem(item, cursor);
			lst.add(item);
		} while (cursor.moveToPrevious());
		cursor.close();
		return lst;
	}

	/**
	 * @Title: queryGroupChatRecordLastIid
	 * @Description: 获取群聊最大的msgid
	 * @return int 返回类型
	 * @param @param group_id
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public synchronized int queryGroupChatRecordLastIid(int group_id) {
		int msg_id = -1;
		String sql = "select max(" + MSG_ID + ") as max_msg_id" + " from " + tableChatMsg + " where " + GROUP_ID + " = "
				+ group_id + " and " + CHAT_TYPE + "=1";
		Cursor cursor = db.rawQuery(sql, null);
		if (cursor == null) {
			return msg_id;
		}
		if (cursor.getCount() <= 0) {
			cursor.close();
			return msg_id;
		}
		cursor.moveToLast();
		do {
			msg_id = cursor.getInt(cursor.getColumnIndex("max_msg_id"));
		} while (cursor.moveToPrevious());
		cursor.close();
		return msg_id;
	}

	/**
	 * query chat record by timestamp and record count to split all record.You
	 * should close the database after the operation finished. 通过时间戳获取聊天记录
	 * 
	 * @param uid
	 * @param timestamp
	 * @param recordCount
	 * @return a Cursor Object.
	 */
	public synchronized List<ChatItem> queryChatRecord(String uid, String timestamp, int recordCount) {
		List<ChatItem> list = new ArrayList<ChatItem>();
		String selection = "contact_uid=? and created_at<?";
		StringBuilder limit = new StringBuilder();
		limit.append(0);
		limit.append(",");
		limit.append(recordCount);
		Cursor cursor = db.query(tableChatMsg, null, selection, new String[] { uid, timestamp }, null, null, "_id desc",
				limit.toString());
		if (cursor == null) {
			return null;
		}
		if (cursor.getCount() <= 0) {
			cursor.close();
			return null;
		}
		cursor.moveToLast();
		while (cursor.moveToPrevious()) {
			ChatItem item = new ChatItem();
			setChatIitem(item, cursor);
			list.add(item);
		}
		cursor.close();
		return list;
	}

	/**
	 * 通过使用本地数据库的自增id读取一条聊天信息
	 * 
	 * */
	public synchronized ChatItem querySingleChatRecord(int id) {
		ChatItem item = null;
		Cursor cursor = db.query(tableChatMsg, null, "_id=?", new String[] { String.valueOf(id) }, null, null, null);
		if (cursor.moveToFirst()) {
			item = new ChatItem();
			setChatIitem(item, cursor);
		}
		cursor.close();
		return item;

	}

	/**
	 * 通过使用线上数据库信息id读取一条聊天信息
	 * 
	 * */
	public synchronized boolean queryChatRecordIsHaveFromMsgid(long msg_id) {
		ChatItem item = null;
		Cursor cursor = db.query(tableChatMsg, null, "msg_id=?", new String[] { String.valueOf(msg_id) }, null, null, null);
		if (cursor.moveToFirst()) {
			item = new ChatItem();
			item.setId(cursor.getInt(cursor.getColumnIndex(_ID)));
		}
		cursor.close();
		return item != null ? true : false;
	}

	/**
	 * 通过使用线上数据库信息id读取一条聊天信息
	 * 
	 * */
	public synchronized ChatItem querySingleChatRecordFromMsgid(long msg_id, int chat_type) {
		ChatItem item = null;
		Cursor cursor = db.query(tableChatMsg, null, MSG_ID + "=? and " + CHAT_TYPE + "=?", new String[] {
				String.valueOf(msg_id), String.valueOf(chat_type) }, null, null, null);
		if (cursor.moveToFirst()) {
			item = new ChatItem();
			setChatIitem(item, cursor);
		}
		cursor.close();
		return item;
	}

	/**
	 * 增加一条聊天记录
	 * 
	 * */
	public synchronized long addChatRecord(ChatItem item) {
		ContentValues values = new ContentValues();
		values.put(MSG_ID, item.getMsgId());
		values.put(MIME_TYPE, item.getMimeType());
		values.put(MSG_STATUS, item.getStatus());
		values.put(BOX_TYPE, item.getBoxType());
		values.put(CREATED_AT, item.getTimeStamp());
		values.put(CONTENT, item.getContent());
		values.put(CONTACT_UID, item.getContactId());
		values.put(IS_ACK, item.getIsAck());
		if (item.getFileName() != null && !Util.isBlankString(item.getFileName())) {
			values.put(FILE_NAME, item.getFileName());
		}
		if (item.getFileNameThumb() != null && !Util.isBlankString(item.getFileNameThumb())) {
			values.put(FILE_NAME_THUMB, item.getFileNameThumb());
		}
		values.put(VOICE_LENGTH, item.getVoiceLength());
		values.put(IMG_WIDTH, item.getThumbImageWidth());
		values.put(IMG_HEIGHT, item.getThumbImageHeight());
		values.put(CHAT_TYPE, item.getChatType());
		values.put(GROUP_ID, item.getGroupId());
		values.put(GROUP_USER_AVATAR, item.getGroupUserAvatar());
		values.put(GROUP_USER_NICK, item.getGroupUserNick());
		values.put(GROUP_USER_SEX, item.getGroupUserSex());
		values.put(GROUP_USER_UID, item.getGroupUserUid());
		values.put(PHOTO_ID, item.getPid());
		long retcode = db.insert(tableChatMsg, null, values);
		return retcode;

	}

	/**
	 * 通过网络msgid获取本地的msgid
	 * 
	 * */
	public synchronized long getLocMsgIdByNetMsgid(String netMsgId) {
		long locMsgId = 0;
		String selection = "msg_id=?";
		String[] selectionArgs = new String[] { netMsgId };
		Cursor cs = db.query(tableChatMsg, null, selection, selectionArgs, null, null, "_id desc", null);
		while (cs.moveToNext()) {
			locMsgId = cs.getLong(cs.getColumnIndex(_ID));
		}
		return locMsgId;
	}

	/**
	 * 删除一条聊天记录
	 * 
	 * */
	public synchronized int deleteMsgById(String id) {
		int retcode = db.delete(tableChatMsg, "_id=?", new String[] { id });
		return retcode;
	}

	/**
	 * 通过msgid删除一条聊天记录
	 * 
	 * */
	public synchronized int deleteMsgByMsgid(String msgid) {
		int retcode = db.delete(tableChatMsg, "msg_id=?", new String[] { msgid });
		return retcode;
	}

	/**
	 * 通过uid删除该用户的所有聊天记录
	 * 
	 * */
	public synchronized int deleteAllMsgByContact(String uid, String group_id, int chat_type) {
		int retcode = -1;
		if (chat_type == 0) {
			retcode = db.delete(tableChatMsg, CONTACT_UID + "=?", new String[] { uid });
		} else if (chat_type == 1) {
			retcode = db.delete(tableChatMsg, GROUP_ID + "=?", new String[] { group_id });
		}
		return retcode;
	}

	/**
	 * 通过uid获取该用户的所有聊天记录数量
	 * 
	 * */
	public synchronized int getMsgByContactId(String uid) {
		String selection = "contact_uid=?";
		String[] selectionArgs = new String[] { uid };
		Cursor cs = db.query(tableChatMsg, null, selection, selectionArgs, null, null, "_id desc", null);
		int totalCount = cs.getCount();
		cs.close();
		return totalCount;
	}

	/**
	 * 更新聊天记录
	 * 
	 * */
	public synchronized int updateChatRecord(ChatItem item) {
		ContentValues values = new ContentValues();
		values.put(MSG_ID, item.getMsgId());
		values.put(MIME_TYPE, item.getMimeType());
		values.put(MSG_STATUS, item.getStatus());
		values.put(BOX_TYPE, item.getBoxType());
		values.put(CREATED_AT, item.getTimeStamp());
		values.put(CONTENT, item.getContent());
		values.put(CONTACT_UID, item.getContactId());
		if (!Util.isBlankString(item.getMsgId()) && Long.valueOf(item.getMsgId()) > 0 && item.getIsAck() > 0) {
			values.put(IS_ACK, item.getIsAck());
		}
		if (item.getFileName() != null && !Util.isBlankString(item.getFileName())) {
			values.put(FILE_NAME, item.getFileName());
		}
		if (item.getFileNameThumb() != null && !Util.isBlankString(item.getFileNameThumb())) {
			values.put(FILE_NAME_THUMB, item.getFileNameThumb());
		}
		values.put(VOICE_LENGTH, item.getVoiceLength());
		values.put(IMG_WIDTH, item.getThumbImageWidth());
		values.put(IMG_HEIGHT, item.getThumbImageHeight());
		values.put(CHAT_TYPE, item.getChatType());
		values.put(GROUP_ID, item.getGroupId());
		values.put(GROUP_USER_AVATAR, item.getGroupUserAvatar());
		values.put(GROUP_USER_NICK, item.getGroupUserNick());
		values.put(GROUP_USER_SEX, item.getGroupUserSex());
		values.put(GROUP_USER_UID, item.getGroupUserUid());
		if (!Util.isBlankString(item.getPid())) {
			values.put(PHOTO_ID, item.getPid());
		}
		int retcode = db.update(tableChatMsg, values, "_id=?", new String[] { String.valueOf(item.getId()) });
		return retcode;
	}

	/**
	 * 更新聊天记录-仅更新必要字段
	 * 
	 * */
	public synchronized int updateChatRecordAssign(ChatItem item) {
		ContentValues values = new ContentValues();
		values.put(MSG_STATUS, item.getStatus());
		if (!Util.isBlankString(item.getMsgId()) && Long.valueOf(item.getMsgId()) > 0) {
			values.put(IS_ACK, item.getIsAck());
		}
		int retcode = db.update(tableChatMsg, values, "_id=?", new String[] { String.valueOf(item.getId()) });
		return retcode;
	}

	/**
	 * 通过自增id更新聊天记录状态
	 * */
	public synchronized void updateRecordStatus(long id) {
		String sql = "update  " + tableChatMsg + " set msg_status = 1 where _id =" + id;
		db.execSQL(sql);
	}

	/**
	 * 通过msg_id更新聊天记录状态
	 * 
	 * */
	public synchronized void updateRecordStatusByMsgid(long msg_id) {
		String sql = "update " + tableChatMsg + " set msg_status = 1 where msg_id =" + msg_id;
		db.execSQL(sql);
	}

	/**
	 * 关闭数据库连接
	 * */
	public void closeDatabase() {
		db.close();
		instance = null;
	}

	/**
	 * @param chatType
	 * @param string
	 * @Title: queryNewChatRecord
	 * @Description: 通过自增_id获取聊天记录
	 * @return List<ChatItem> 返回类型
	 * @param @param uid 联系人的uid
	 * @param @param fromID 新消息的本地_id
	 * @param @param group_id 群组id
	 * @param @param chat_type 消息类型
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public synchronized List<ChatItem> queryNewChatRecord(String uid, Integer fromID, String group_id, int chat_type) {
		ArrayList<ChatItem> lst = new ArrayList<ChatItem>();
		String selection = "";
		String[] selectionArgs = null;
		if (chat_type == 0) {
			selection = CONTACT_UID + "=? and " + _ID + ">=? and " + CHAT_TYPE + "=?";
			selectionArgs = new String[] { uid, fromID.toString(), chat_type + "" };
		} else if (chat_type == 1) {
			selection = GROUP_ID + "=? and " + _ID + ">=? and " + CHAT_TYPE + "=?";
			selectionArgs = new String[] { group_id, fromID.toString(), chat_type + "" };
		}
		if (db != null && db.isOpen()) {
			Cursor cursor = db.query(tableChatMsg, null, selection, selectionArgs, null, null, "_id desc");
			if (cursor == null) {
				return null;
			}
			if (cursor.getCount() <= 0) {
				cursor.close();
				return null;
			}
			cursor.moveToLast();
			do {
				ChatItem item = new ChatItem();
				setChatIitem(item, cursor);
				lst.add(item);
			} while (cursor.moveToPrevious());
			cursor.close();
		}

		return lst;
	}

	/**
	 * 读取数据库的最后一条聊天记录
	 * 
	 * */
	public synchronized ChatItem queryLChatRecord(String uid, String group_id, int chat_type) {
		ChatItem item = null;
		StringBuilder limit = new StringBuilder();
		limit.append(0);
		limit.append(",");
		limit.append(1);
		String selection = "";
		String[] selectionArgs = null;
		if (chat_type == 0) {
			selection = CONTACT_UID + "=? and " + CHAT_TYPE + "=?";
			selectionArgs = new String[] { uid, chat_type + "" };
		} else if (chat_type == 1) {
			selection = GROUP_ID + "=? and " + CHAT_TYPE + "=?";
			selectionArgs = new String[] { group_id, chat_type + "" };
		}
		if (db != null && db.isOpen()) {
			Cursor cursor = db.query(tableChatMsg, null, selection, selectionArgs, null, null, "created_at desc",
					limit.toString());
			if (cursor.moveToFirst()) {
				item = new ChatItem();
				setChatIitem(item, cursor);
			}
			cursor.close();
		}

		return item;
	}

	/**
	 * @Title: setChatIitem
	 * @Description: 赋值
	 * @return void 返回类型
	 * @param @param item
	 * @param @param cursor 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void setChatIitem(ChatItem item, Cursor cursor) {
		item.setId(cursor.getInt(cursor.getColumnIndex(_ID)));
		item.setMsgId(cursor.getString(cursor.getColumnIndex(MSG_ID)));
		item.setMimeType((cursor.getString(cursor.getColumnIndex(MIME_TYPE))));
		item.setBoxType(cursor.getInt(cursor.getColumnIndex(BOX_TYPE)));
		// 状态改变
		int msgStatus = cursor.getInt(cursor.getColumnIndex(MSG_STATUS));
		if (msgStatus == ChatConstant.MSG_SYNCHRONIZING) {
			msgStatus = ChatConstant.MSG_SYNCHRONIZE_FAILED;
		}
		item.setStatus(msgStatus);
		item.setTimeStamp(cursor.getString(cursor.getColumnIndex(CREATED_AT)));
		item.setContent(cursor.getString(cursor.getColumnIndex(CONTENT)));
		item.setContactId(cursor.getString(cursor.getColumnIndex(CONTACT_UID)));
		item.setIsAck(cursor.getInt(cursor.getColumnIndex(IS_ACK)));
		item.setVoiceLength(cursor.getInt(cursor.getColumnIndex(VOICE_LENGTH)));
		item.setFileName(cursor.getString(cursor.getColumnIndex(FILE_NAME)));
		item.setFileNameThumb(cursor.getString(cursor.getColumnIndex(FILE_NAME_THUMB)));
		item.setThumbImageWidth(cursor.getInt(cursor.getColumnIndex(IMG_WIDTH)));
		item.setThumbImageHeight(cursor.getInt(cursor.getColumnIndex(IMG_HEIGHT)));
		item.setChatType(cursor.getInt(cursor.getColumnIndex(CHAT_TYPE)));
		item.setGroupId(cursor.getString(cursor.getColumnIndex(GROUP_ID)));
		item.setGroupUserAvatar(cursor.getString(cursor.getColumnIndex(GROUP_USER_AVATAR)));
		item.setGroupUserNick(cursor.getString(cursor.getColumnIndex(GROUP_USER_NICK)));
		item.setGroupUserSex(cursor.getInt(cursor.getColumnIndex(GROUP_USER_SEX)));
		item.setGroupUserUid(cursor.getString(cursor.getColumnIndex(GROUP_USER_UID)));
		item.setPid(cursor.getString(cursor.getColumnIndex(PHOTO_ID)));
	}

	/**
	 * 更新用户头像
	 * 
	 * */
	public synchronized void updateContactAvatar(String uid, String avatarUrl, int chat_type, String nickName) {
		if (!Util.isBlankString(avatarUrl) && !Util.isBlankString(uid)) {
			ContentValues values = new ContentValues();
			values.put(AVATAR, avatarUrl);
			if (!Util.isBlankString(nickName)) {
				values.put(NICKNAME, nickName);
			}
			if (chat_type == 0) {
				db.update(tableChatFriend, values, CONTACT_UID + "=? and " + CHAT_TYPE + "=?",
						new String[] { uid, chat_type + "" });
			} else if (chat_type == 1) {
				db.update(tableChatFriend, values, GROUP_ID + "=? and " + CHAT_TYPE + "=?", new String[] { uid, chat_type + "" });
			}
		}
	}

	/**
	 * @Title: updateContactName
	 * @Description: 修改联系人名称
	 * @return void 返回类型
	 * @param @param uid
	 * @param @param name
	 * @param @param chat_type 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public synchronized void updateContactName(String uid, String name, int chat_type) {
		if (!Util.isBlankString(name) && !Util.isBlankString(uid)) {
			ContentValues values = new ContentValues();
			values.put(NICKNAME, name);
			if (chat_type == 0) {
				db.update(tableChatFriend, values, CONTACT_UID + "=? and " + CHAT_TYPE + "=?",
						new String[] { uid, chat_type + "" });
			} else if (chat_type == 1) {
				db.update(tableChatFriend, values, GROUP_ID + "=? and " + CHAT_TYPE + "=?", new String[] { uid, chat_type + "" });
			}
		}
	}

	/**
	 * 判断某张表是否存在
	 * 
	 * @param tabName 表名
	 * @return
	 */
	public synchronized boolean isTableExist(String tableName) {
		boolean result = false;
		if (tableName == null) {
			return false;
		}

		try {
			Cursor cursor = null;
			String sql = "select count(1) as c from sqlite_master where type ='table' and name ='" + tableName.trim() + "'";
			cursor = db.rawQuery(sql, null);
			if (cursor.moveToNext()) {
				int count = cursor.getInt(0);
				if (count > 0) {
					result = true;
				}
			}

			cursor.close();
		} catch (Exception e) {
		}
		return result;
	}

	/**
	 * 判断某张表中是否存在某字段(注，该方法无法判断表是否存在，因此应与isTableExist一起使用)
	 * 
	 * @param tabName 表名
	 * @param columnName 列名
	 * @return
	 */
	public synchronized boolean isColumnExist(String tableName, String columnName) {
		boolean result = false;
		if (tableName == null) {
			return false;
		}
		try {
			Cursor cursor = null;
			String sql = "select count(1) as c from sqlite_master where type ='table' and name ='" + tableName.trim()
					+ "' and sql like '%" + columnName.trim() + "%'";
			cursor = db.rawQuery(sql, null);
			if (cursor.moveToNext()) {
				int count = cursor.getInt(0);
				if (count > 0) {
					result = true;
				}
			}
			cursor.close();
		} catch (Exception e) {
		}
		return result;
	}

	/**
	 * 增加一个字段
	 * 
	 * */
	public synchronized void addColumn(String tableName, String columnName, String columnType) {
		String updateSql = "alter table " + tableName + " add " + columnName + " " + columnType + "";
		db.execSQL(updateSql);
	}

	/**
	 * 通过uid获取该用户的所有未读聊天记录数量
	 * 
	 * */
	public synchronized int getUnreadMsgByContactId(String uid, String group_id, int chat_type) {
		int totalUnreadMsgCount = 0;
		String selection = "";
		String[] selectionArgs = null;
		if (chat_type == 0) {
			selection = NEW_MSG_COUNT + " >0 and " + CONTACT_UID + "=? and " + CHAT_TYPE + "=?";
			selectionArgs = new String[] { uid, chat_type + "" };

		} else if (chat_type == 1) {
			selection = NEW_MSG_COUNT + " >0 and " + GROUP_ID + "=? and " + CHAT_TYPE + "=?";
			selectionArgs = new String[] { group_id, chat_type + "" };
		}
		Cursor cursor = db.query(tableChatFriend, null, selection, selectionArgs, null, null, null);
		while (cursor.moveToNext()) {
			totalUnreadMsgCount = cursor.getInt(cursor.getColumnIndex(NEW_MSG_COUNT));
		}
		cursor.close();

		return totalUnreadMsgCount;
	}

	/** 更新消息中图片的尺寸信息 **/
	public synchronized void updateMsgThumbSize(int id, float[] newSize) {
		ContentValues values = new ContentValues();
		values.put(IMG_WIDTH, (int) newSize[0]);
		values.put(IMG_HEIGHT, (int) newSize[1]);
		db.update(tableChatMsg, values, "_id=?", new String[] { String.valueOf(id) });
	}

	public static ChatDBHelper getHelper(Context mContext, String uid) {
		if (instance == null) {
			instance = new ChatDBHelper(mContext, uid);
		}
		return instance;
	}
}
