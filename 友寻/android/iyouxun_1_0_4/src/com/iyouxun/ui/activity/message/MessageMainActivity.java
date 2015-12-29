package com.iyouxun.ui.activity.message;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.iyouxun.R;
import com.iyouxun.comparator.MessageUserComparator;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.chat.ChatConstant;
import com.iyouxun.data.chat.ChatContact;
import com.iyouxun.data.chat.ChatContactRepository;
import com.iyouxun.data.chat.ChatDBHelper;
import com.iyouxun.data.chat.ChatItem;
import com.iyouxun.data.chat.ChatListItem;
import com.iyouxun.data.chat.MessageListCell;
import com.iyouxun.data.parser.SocketParser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.MainBoxActivity;
import com.iyouxun.ui.activity.find.NoFriendsActivity;
import com.iyouxun.ui.adapter.MessageAdapter;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.SocketUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: MessgeMainActivity
 * @Description: 消息主页
 * @author donglizhi
 * @date 2015年3月13日 下午4:24:27
 * 
 */
public class MessageMainActivity extends CommTitleActivity {
	private PullToRefreshListView messageList;// 消息数据列表
	private MessageAdapter adapter;
	private final ArrayList<MessageListCell> arrayList = new ArrayList<MessageListCell>();
	private final String[] other = { "我的群组", "系统消息" };
	private ChatDBHelper helper;
	private final int SYSTEM_ITEM_SIZE = 2;// 系统条目数量
	private long pageTime = 0;// 获取联系人列表的翻页时间戳
	private boolean isFirstLoad = true;// 首次加载
	private int delPosition = -1;
	private boolean refreshFirstPage = false;// 刷新第一页数据
	private int messageListPage = 1;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.str_message);
		titleRightButton.setText(R.string.create_chat_group);
		titleRightButton.setVisibility(View.VISIBLE);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_message, null);
	}

	@Override
	protected void initViews() {
		isFirstLoad = true;
		mContext = MessageMainActivity.this;
		messageList = (PullToRefreshListView) findViewById(R.id.message_list);
		messageList.setMode(Mode.PULL_FROM_END);// 设置只能从底部上拉
		messageList.setScrollingWhileRefreshingEnabled(false);// 加载的时候不允许滑动
		messageList.setPullToRefreshOverScrollEnabled(false);// 滑动到底部的时候的缓冲提示
		helper = ChatContactRepository.getDBHelperInstance();
		for (int i = 0; i < SYSTEM_ITEM_SIZE; i++) {
			MessageListCell tempMlc = new MessageListCell();
			tempMlc.item_countnew = 0;
			tempMlc.nick = other[i];
			if (i == 0) {
				int groupCount = SharedPreUtil.getGroupCount();
				tempMlc.content = "共" + groupCount + "个群组";
			} else {
				tempMlc.content = "新的系统消息";
			}
			tempMlc.systemMsg = true;
			arrayList.add(i, tempMlc);
		}
		adapter = new MessageAdapter(arrayList, mContext);
		messageList.getRefreshableView().setAdapter(adapter);
		messageList.setOnItemClickListener(onItemClickListener);
		messageList.getRefreshableView().setOnItemLongClickListener(onItemLongClickListener);
		messageList.setOnRefreshListener(new OnRefreshListener<ListView>() {

			@Override
			public void onRefresh(PullToRefreshBase<ListView> refreshView) {
				UtilRequest.getAllChatMsgList(messageListPage, J_Consts.MESSAGE_LIST_PAGE_SIZE, mHandler, mContext);
			}

		});
		// 获取一页列表数据
		getPageRecentInfo(false, false);
		IntentFilter filter = new IntentFilter();
		filter.addAction(J_Consts.UPDATE_MESSAGE_LIST_DATA);
		filter.addAction(UtilRequest.BROADCAST_ACTION_EXIT_GROUP);
		filter.addAction(UtilRequest.BROADCAST_UPDATE_SYSTEM_MESSAGE_COUNT);
		filter.addAction(UtilRequest.BROADCAST_ACTION_UPDATE_GROUP_COUNT);
		registerReceiver(mReceiver, filter);
	}

	@Override
	protected void onResume() {
		super.onResume();
		if (!isFirstLoad) {
			refreshFirstPage = true;
			UtilRequest.getAllChatMsgList(1, J_Consts.MESSAGE_LIST_PAGE_SIZE, mHandler, mContext);
			getPageRecentInfo(true, false);
			UtilRequest.getMyGroupCount(mContext);
			UtilRequest.getCountNew();
		} else {
			isFirstLoad = false;
		}
		((MainBoxActivity) getParent()).showRedDot(1);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_NEW_CHAT_MSG);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_NEW_CREATE_GROUP_MSG);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_NEW_GROUP_CHAT_MSG);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_NEW_ADD_GROUP_MSG);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_NEW_EXIT_GROUP_MSG);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_NEW_REJECT_FRIEND_JOIN_GROUP_MSG);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_NEW_GROUP_MASTER_DEL_PERSON_MSG);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_NEW_INVITE_FRIEND_JOIN_GROUP_MSG);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_ADD_FRIEND_MSG);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_NEW_FRIEND_JOIN_MSG);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_NEW_FRIEND_JOIN_HOUR_MSG);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_OWN_ADD_TAGS_MSG);
		SocketUtil.cancelNotification(SocketParser.CMD_SEND_NEW_ACCEPT_FRIEND_JOIN_GROUP_MSG);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		unregisterReceiver(mReceiver);
	}

	private final BroadcastReceiver mReceiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {
			((MainBoxActivity) getParent()).showRedDot(1);
			String action = intent.getAction();
			if (J_Consts.UPDATE_MESSAGE_LIST_DATA.equals(action)) {// 更新消息列表
				getPageRecentInfo(true, false);
			} else if (UtilRequest.BROADCAST_ACTION_EXIT_GROUP.equals(action)) {// 退群广播
				String exitGroupId = intent.getStringExtra(UtilRequest.FORM_GROUP_ID);
				if (!Util.isBlankString(exitGroupId)) {// 退群删除本地数据
					for (int i = 0; i < arrayList.size(); i++) {
						if (exitGroupId.equals(arrayList.get(i).groupId) && arrayList.get(i).chatType == 1) {
							delPosition = i;
							break;
						}
					}
					if (delPosition >= 0) {
						mHandler.sendEmptyMessage(NetTaskIDs.TASKID_DEL_CONTACT);
					}
				}
			} else if (UtilRequest.BROADCAST_UPDATE_SYSTEM_MESSAGE_COUNT.equals(action)) {
				adapter.notifyDataSetChanged();
			} else if (UtilRequest.BROADCAST_ACTION_UPDATE_GROUP_COUNT.equals(action)) {// 更新群组数量
				if (arrayList.size() > 0) {
					int groupCount = SharedPreUtil.getGroupCount();
					arrayList.get(0).content = "共" + groupCount + "个群组";
					adapter.notifyDataSetChanged();
				}
			}
		}
	};
	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleRightButton:// 建立组群
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.getFriendsNums(J_Cache.sLoginUser.uid + "", 1, 1, mHandler, mContext);
				break;

			default:
				break;
			}
		}
	};

	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			if (position == 1) {
				Intent intent = new Intent(mContext, MyGroupActivity.class);
				startActivity(intent);
			} else if (position == 2) {
				Intent intent = new Intent(mContext, SystemMsgActivity.class);
				startActivity(intent);
			} else {
				int index = position - 1;
				int chatType = arrayList.get(index).chatType;
				String nick = arrayList.get(index).nick;
				Intent intent = new Intent(mContext, ChatMainActivity.class);
				intent.putExtra(UtilRequest.FORM_NICK, nick);
				if (chatType == 0) {// 0普通消息1群组消息
					String oid = arrayList.get(index).oid;
					intent.putExtra(UtilRequest.FORM_OID, oid);
				} else {
					int groupId = Integer.valueOf(arrayList.get(index).groupId);
					intent.putExtra(UtilRequest.FORM_GROUP_ID, groupId);
				}
				startActivity(intent);
				((MainBoxActivity) getParent()).showRedDot(1);
			}
		}
	};

	private final OnItemLongClickListener onItemLongClickListener = new OnItemLongClickListener() {

		@Override
		public boolean onItemLongClick(AdapterView<?> parent, View view, int position, long id) {
			if (position <= 2) {
				return false;
			} else {
				delPosition = position - 1;
				DialogUtils.showPromptDialog(mContext, "提示信息", "是否要删除该对话记录?", new OnSelectCallBack() {

					@Override
					public void onCallBack(String value1, String value2, String value3) {
						if ("0".equals(value1)) {
							if (arrayList.get(delPosition).chatType == 0) {
								DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
								UtilRequest.delContactAllMsg(arrayList.get(delPosition).oid, mHandler, mContext);
							} else {
								mHandler.sendEmptyMessage(NetTaskIDs.TASKID_DEL_CONTACT);
							}
						}
					}
				});
				return true;
			}
		}
	};

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_DEL_CONTACT:// 删除用户聊天消息
				DialogUtils.dismissDialog();
				String removeUid = arrayList.get(delPosition).oid;
				String removeGroupid = arrayList.get(delPosition).groupId;
				int chatType = arrayList.get(delPosition).chatType;
				// 从数据库中删除该用户
				if ((!Util.isBlankString(removeGroupid) && chatType == 1) || (!Util.isBlankString(removeUid) && chatType == 0)) {
					if (chatType == 1) {// 群聊消息删除后要清除一下服务器缓存
						UtilRequest.clearCache(removeGroupid);
					}
					// 从数组中删除该数据
					arrayList.remove(delPosition);

					// 从数据库中删除该用户
					int removeLines = helper.deleteContact(removeUid, removeGroupid, chatType);
					if (removeLines > 0) {
						// 删除该用户的聊天记录
						helper.deleteAllMsgByContact(removeUid, removeGroupid, chatType);

						removeUid = null;
						removeGroupid = null;
						delPosition = -1;
					}
					adapter.notifyDataSetChanged();
					// 重新整理小红点中的数字，进行刷新显示
					((MainBoxActivity) getParent()).showRedDot(1);
				}
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_NUMS:// 好友数量
				int friendsNums = Util.getInteger(msg.obj.toString());
				if (friendsNums <= 0) {
					DialogUtils.dismissDialog();
					Intent noFriendsIntent = new Intent(mContext, NoFriendsActivity.class);
					startActivity(noFriendsIntent);
				} else {
					UtilRequest.getFriendsList(J_Cache.sLoginUser.uid + "", mHandler, mContext, 0, friendsNums);
					SharedPreUtil.setMyfriendsNums(friendsNums);
				}
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS_ALL:// 所用好友
				DialogUtils.dismissDialog();
				Intent intent = new Intent(mContext, AddGroupMemebersActivity.class);
				startActivity(intent);
				break;
			case NetTaskIDs.TASKID_GET_ALL_CHAT_MSG_LIST:// 获取全部聊天消息列表
				if (msg.obj == null) {
					messageList.onRefreshComplete(Mode.PULL_FROM_END);
					if (msg.arg1 < 0) {
						ToastUtil.showToast(mContext, "请求失败");
					} else {
						ToastUtil.showToast(mContext, getString(R.string.network_error));
					}
					return;
				}
				try {
					JSONArray dataArray = new JSONArray(msg.obj.toString());
					if (dataArray.length() > 0) {
						messageListPage++;
						for (int i = 0; i < dataArray.length(); i++) {
							JSONObject contactObject = dataArray.getJSONObject(i);
							ChatListItem item = new ChatListItem();
							item.uid = contactObject.optString(UtilRequest.FORM_OID);
							item.groupId = contactObject.optString(UtilRequest.FORM_GROUP_ID);
							if (!Util.isBlankString(item.groupId)) {
								item.chatType = 1;
								item.userIconUrl = contactObject.optString(UtilRequest.FORM_LOGO);
								item.nickName = contactObject.optString(UtilRequest.FORM_TITLE);
							} else {
								item.chatType = 0;
								item.userIconUrl = contactObject.optString(UtilRequest.FORM_AVATAR);
								item.nickName = contactObject.optString(UtilRequest.FORM_NICK);
							}
							int msgType = contactObject.optInt(UtilRequest.FORM_MSG_TYPE);
							item.ctime = contactObject.optString(UtilRequest.FORM_SEND_TIME) + "000";
							item.msgStatus = ChatConstant.MSG_SYNCHRONIZE_SUCCESS;
							item.count = contactObject.optInt(UtilRequest.FORM_NEW_COUNT);
							if (item.chatType == 1) {
								item.hint = contactObject.optInt(UtilRequest.FORM_HINT, 0);
							}
							switch (msgType) {
							case 0:// 单聊普通聊天
							case 1:// 群聊普通聊天
								item.last_msg = contactObject.optString(UtilRequest.FORM_CONTENT);
								break;
							case 2:// 单聊上传声音
							case 4:// 群聊上传声音
								item.last_msg = getString(R.string.voice_msg);
								break;
							case 3:// 单聊上传图片
							case 5:// 群聊上传图片
								item.last_msg = getString(R.string.image_msg);
								break;
							}
							if (item != null && item.ctime != null) {
								// 更新联系人信息
								long id = helper.addContact(item, item.ctime);
								// 跟新聊天联系人聊天记录
							}
							// 更新联系人聊天记录
							updateHitoryUserChatList(contactObject);
						}
						// 加载完成以后，再从本地获取数据
						if (refreshFirstPage) {
							refreshFirstPage = false;
							getPageRecentInfo(true, false);
						} else {
							getPageRecentInfo(false, true);
						}
						messageList.onRefreshComplete(Mode.PULL_FROM_END);
					} else {
						messageList.onRefreshComplete(Mode.DISABLED);
					}
				} catch (JSONException e) {
					messageList.onRefreshComplete(Mode.DISABLED);
					e.printStackTrace();
				}
				((MainBoxActivity) getParent()).showRedDot(1);
				break;
			default:
				break;
			}
		};
	};

	/**
	 * @Title: updateHitoryUserChatList
	 * @Description: 更新历史消息
	 * @return void 返回类型
	 * @param @param finalData 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void updateHitoryUserChatList(JSONObject finalData) {
		ChatItem ci = new ChatItem();
		String msg_id = JsonUtil.getJsonString(finalData, UtilRequest.FORM_IID);
		String contact_uid = "";
		String groupId = "";
		int chatType = 0;
		String ctime = JsonUtil.getJsonString(finalData, UtilRequest.FORM_SEND_TIME);
		if (finalData.has(UtilRequest.FORM_GROUP_ID)) {
			groupId = JsonUtil.getJsonString(finalData, UtilRequest.FORM_GROUP_ID);
			chatType = 1;
			String groupUserUid = JsonUtil.getJsonString(finalData, UtilRequest.FORM_OID);
			if (groupUserUid.equals(J_Cache.sLoginUser.uid + "")) {
				ci.setBoxType(2);
			} else {
				ci.setBoxType(1);
			}
			String groupUserNick = JsonUtil.getJsonString(finalData, UtilRequest.FORM_NICK);
			String groupUserAvatar = JsonUtil.getJsonString(finalData, UtilRequest.FORM_AVATAR);
			int groupUserSex = finalData.optInt(UtilRequest.FORM_SEX, 0);
			ci.setGroupUserUid(groupUserUid);
			ci.setGroupUserAvatar(groupUserAvatar);
			ci.setGroupUserNick(groupUserNick);
			ci.setGroupUserSex(groupUserSex);
		} else {
			contact_uid = JsonUtil.getJsonString(finalData, UtilRequest.FORM_OID);
			chatType = 0;
			int boxBype = finalData.optInt(UtilRequest.FORM_TYPE);
			ci.setBoxType(boxBype);
		}

		// 消息类型0 单聊普通聊天 1 群聊普通聊天 2 单聊上传声音 3 单聊上传图片 4 群聊上传声音 5 群聊上传图片
		int msgtype = finalData.optInt(UtilRequest.FORM_MSG_TYPE);
		ci.setMsgId(msg_id);
		ci.setStatus(ChatConstant.MSG_SYNCHRONIZE_SUCCESS);// 发送结果状态
		ci.setContactId(contact_uid);
		ci.setGroupId(groupId);
		ci.setChatType(chatType);
		ci.setTimeStamp(ctime + UtilRequest.TIMESTAMP_000);
		if (msgtype == 2 || msgtype == 4) {
			// 语音内容
			ci.setContent(getString(R.string.voice_msg));
			JSONObject voiceInfo = JsonUtil.getJsonObject(finalData, UtilRequest.FORM_EXT);
			int voiceLength = voiceInfo.optInt(UtilRequest.FORM_DUR);
			String voiceName = JsonUtil.getJsonString(voiceInfo, UtilRequest.FORM_VOICE);
			ci.setVoiceLength(voiceLength);
			ci.setFileName(voiceName);
			ci.setMimeType(ChatConstant.MIME_TYPE_AUIDO_AMR);
		} else if (msgtype == 0 || msgtype == 1) {
			// 文字内容
			ci.setContent(finalData.optString(UtilRequest.FORM_CONTENT));
			ci.setMimeType(ChatConstant.MIME_TYPE_TEXT_PLAIN);
		} else if (msgtype == 3 || msgtype == 5) {
			// 图片内容
			ci.setContent(getString(R.string.image_msg));
			JSONObject imgInfo = JsonUtil.getJsonObject(finalData, UtilRequest.FORM_EXT);
			String imageName = JsonUtil.getJsonString(imgInfo, UtilRequest.FORM_PIC_0);
			String imageNameThumb = JsonUtil.getJsonString(imgInfo, UtilRequest.FORM_PIC_200);
			String pid = JsonUtil.getJsonString(imgInfo, UtilRequest.FORM_PID);
			ci.setPid(pid);
			ci.setFileName(imageName);
			ci.setFileNameThumb(imageNameThumb);
			ci.setMimeType(ChatConstant.MIME_TYPE_IMAGE_JPEG);// 该条私信记录的类型
			// 设置图片宽高
			int[] widthHeight = Util.getWidthHeight(imageNameThumb);
			int originalWidth = widthHeight[0];
			int originalHeight = widthHeight[1];
			ci.setThumbImageWidth(originalWidth);
			ci.setThumbImageHeight(originalHeight);
		}
		if (!Util.isBlankString(msg_id) && Util.getLong(msg_id) > 0) {
			// 获取当前信息的本地id
			ChatItem checkCi = helper.querySingleChatRecordFromMsgid(Util.getLong(msg_id), chatType);
			if (checkCi == null) {
				// 在数据库中不存在，添加至数据库
				long loc_msgid = helper.addChatRecord(ci);
				ci.setId(Util.getInteger(String.valueOf(loc_msgid)));
			} else {
				// 已经存在于数据库中，仅获取该数据msgid
				ci.setId(checkCi.getId());
				// 通过id更新该条数据信息
				helper.updateChatRecord(ci);
			}
		}
	}

	/**
	 * 获取一页聊天好友信息
	 * 
	 * @page 页码 1-n
	 * @pageSize 每页加载数量
	 * */
	public List<ChatContact> getContactsByTime(long pageTime, int pageSize) {
		List<ChatContact> rtnList = null;
		if (helper != null) {
			Cursor cs = helper.queryContactsByTime(pageTime, pageSize);
			if (cs != null && cs.getCount() > 0) {
				rtnList = new ArrayList<ChatContact>();
				while (cs.moveToNext()) {
					ChatContact cc = new ChatContact();
					cc.setUid(cs.getString(cs.getColumnIndex(ChatDBHelper.CONTACT_UID)));
					cc.setNickName(cs.getString(cs.getColumnIndex(ChatDBHelper.NICKNAME)));
					cc.setThumbnailUrl(cs.getString(cs.getColumnIndex(ChatDBHelper.AVATAR)));
					cc.setUnreadCount(cs.getInt(cs.getColumnIndex(ChatDBHelper.NEW_MSG_COUNT)));
					cc.setLastMsg(cs.getString(cs.getColumnIndex(ChatDBHelper.LAST_MSG)));
					cc.setCtime(cs.getString(cs.getColumnIndex(ChatDBHelper.CTIME)));
					cc.setMsgStatus(cs.getInt(cs.getColumnIndex(ChatDBHelper.LASTMSG_STATUS)));
					cc.setSex(cs.getInt(cs.getColumnIndex(ChatDBHelper.SEX)));
					cc.setChatType(cs.getInt(cs.getColumnIndex(ChatDBHelper.CHAT_TYPE)));
					cc.setGroupId(cs.getString(cs.getColumnIndex(ChatDBHelper.GROUP_ID)));
					cc.setHint(cs.getInt(cs.getColumnIndex(ChatDBHelper.GROUP_HINT)));
					rtnList.add(cc);
				}
			}
			cs.close();
		}
		return rtnList;
	}

	/**
	 * 获取联系人列表
	 * 
	 * @param isRefresh 刷新页面或加载页面true:刷新页面,false:加载页面
	 * @param isPool 标识是否是拖动操作
	 * 
	 * @throws ParseException
	 * 
	 */
	private void getPageRecentInfo(boolean isRefresh, boolean isPool) {
		// 从本地数据库读出用户列表信息
		List<ChatContact> allContacts;
		if (isRefresh) {// 只做刷新
			int refreshSize = arrayList.size() <= SYSTEM_ITEM_SIZE ? 10 : arrayList.size() - SYSTEM_ITEM_SIZE;
			allContacts = getContactsByTime(0, refreshSize);
		} else {// 获取新一页
			allContacts = getContactsByTime(pageTime, J_Consts.MESSAGE_LIST_PAGE_SIZE);
		}
		if (allContacts != null) {
			if (allContacts.size() > 0) {
				for (int i = 0; i < allContacts.size(); i++) {
					ChatContact cc = allContacts.get(i);
					MessageListCell mlc = new MessageListCell();
					mlc.avatar = cc.getThumbnailUrl();
					mlc.content = cc.getLastMsg();
					mlc.nick = cc.getNickName();
					mlc.oid = cc.getUid();
					mlc.timeStamp = cc.getCtime();
					mlc.newmsg = cc.getUnreadCount();
					mlc.status = cc.getMsgStatus();
					mlc.sex = cc.getSex();
					mlc.chatType = cc.getChatType();
					mlc.groupId = cc.getGroupId();
					mlc.hint = cc.getHint();
					mlc.systemMsg = false;
					int getIndex = 0;
					if (mlc.chatType == 0) {
						getIndex = getUserIndexUid(cc.getUid());// 查询该用户的uid
					} else if (mlc.chatType == 1) {
						getIndex = getUserIndexGroupId(cc.getGroupId());// 查询该用户的uid
					}
					if (getIndex < SYSTEM_ITEM_SIZE) {// 表示不存在该条数据，添加操作
						arrayList.add(mlc);
					} else {// 已经存在该条数据，替换操作
						arrayList.set(getIndex, mlc);
					}
				}

				// 对用户列表重新排序
				resortUserList();
				// 恢复正常拉动状态
				if (messageList.getCurrentMode() == Mode.DISABLED) {
					messageList.setMode(Mode.PULL_FROM_END);
				}
				int unReadMsg = 0;
				for (int i = 0; i < arrayList.size(); i++) {
					if (arrayList.get(i).hint == 0) {
						unReadMsg += arrayList.get(i).newmsg;
					}
				}
				((MainBoxActivity) getParent()).setNewMsgCount(unReadMsg);
				adapter.notifyDataSetChanged();
			}
		}
	}

	/**
	 * 根据uid检查用户是否已经加载
	 * 
	 * 
	 **/
	private int getUserIndexUid(String uid) {
		int index = -1;
		if (arrayList.size() > SYSTEM_ITEM_SIZE) {
			for (int i = SYSTEM_ITEM_SIZE; i < arrayList.size(); i++) {
				if (uid.equals(arrayList.get(i).oid) && arrayList.get(i).chatType == 0) {
					index = i;
					break;
				}
			}
		}
		return index;
	}

	/**
	 * 根据groupId检查用户是否已经加载
	 * 
	 * 
	 **/
	private int getUserIndexGroupId(String groupId) {
		int index = -1;
		if (arrayList.size() > SYSTEM_ITEM_SIZE) {
			for (int i = SYSTEM_ITEM_SIZE; i < arrayList.size(); i++) {
				if (groupId.equals(arrayList.get(i).groupId) && arrayList.get(i).chatType == 1) {
					index = i;
					break;
				}
			}
		}
		return index;
	}

	/**
	 * 用户列表重新排序
	 * 
	 * */
	private void resortUserList() {
		MessageUserComparator comparator = new MessageUserComparator();
		Collections.sort(arrayList, comparator);
		getLastUpdateTime();
	}

	/**
	 * 获取当前列表中最后一个联系人的时间戳
	 * 
	 * */
	private void getLastUpdateTime() {
		if (arrayList != null && arrayList.size() > SYSTEM_ITEM_SIZE) {
			for (int i = SYSTEM_ITEM_SIZE; i < arrayList.size(); i++) {
				long currentTime = Util.getLong(arrayList.get(i).timeStamp);
				if (pageTime == 0) {
					pageTime = currentTime;
				} else {
					if (pageTime > currentTime) {
						pageTime = currentTime;
					}
				}
			}
		}
	}

}
