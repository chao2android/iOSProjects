package com.iyouxun.ui.activity.message;

import java.io.File;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Timer;
import java.util.TimerTask;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.hardware.Sensor;
import android.hardware.SensorEvent;
import android.hardware.SensorEventListener;
import android.hardware.SensorManager;
import android.media.AudioManager;
import android.os.Handler;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.View.OnLongClickListener;
import android.view.View.OnTouchListener;
import android.view.inputmethod.EditorInfo;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.TextView.OnEditorActionListener;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.comparator.ChatMsgComparator;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.chat.ChatConstant;
import com.iyouxun.data.chat.ChatContactRepository;
import com.iyouxun.data.chat.ChatDBHelper;
import com.iyouxun.data.chat.ChatItem;
import com.iyouxun.data.chat.ChatListItem;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.j_libs.file.FileStore;
import com.iyouxun.j_libs.file.FileUtils;
import com.iyouxun.j_libs.managers.J_FileManager;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.j_libs.utils.J_NetUtil;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.net.response.SendGroupMsgResonse;
import com.iyouxun.net.response.SendTextMsgResonse;
import com.iyouxun.net.response.UserInfoResponse;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.MainBoxActivity;
import com.iyouxun.ui.activity.center.ProfileViewActivity;
import com.iyouxun.ui.adapter.ChatListAdapter;
import com.iyouxun.ui.dialog.ChatHelpDialog;
import com.iyouxun.ui.views.FaceRelativeLayout;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.ImageUtils;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SoundMeter;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.UploadPhotoDataAccess;
import com.iyouxun.utils.Util;

/**
 * @ClassName: ChatMainActivity
 * @Description: 发送消息页面
 * @author donglizhi
 * @date 2015年3月16日 下午5:12:55
 * 
 */
public class ChatMainActivity extends CommTitleActivity {
	private EditText inputMsg;// 输入框
	private Button btnSend;// 发送按钮
	private String chatUid;// 聊天人的id
	private ChatListItem current;// 对方的资料
	private final ArrayList<ChatItem> currentItems = new ArrayList<ChatItem>();// 与当前聊天对象的聊天记录
	private ChatListAdapter chatListAdapter;
	private PullToRefreshListView chatMessageShowbox;// 消息列表
	private String currentUid;// 当前用户的id
	private int groupId = 0;// 当前分组id
	private ChatDBHelper helper;
	// 网络获取聊天记录的页码
	private long pageMsgId = 0;
	private long pageTimestamp = 0;
	// 网络获取聊天记录的每页记录数量
	private final int pageSize = 20;
	// 图片选择按钮
	private FaceRelativeLayout faceRelativeLayout;
	private ImageButton btnImageChooseCamera;
	private ImageButton btnImageChooseGallery;
	private final UploadPhotoDataAccess upload = new UploadPhotoDataAccess(this);
	private FileStore fs;
	// 语音提示框的背景层，放置点击下部内容
	private RelativeLayout voiceLayer;
	// 语音输入框
	private Button buttonChatVoice;
	// 取消发送的提示信息
	private TextView touchEventShowBox;
	// 语音振幅图片
	private ImageView ivVoiceShow;
	// 倒计时提示层
	private TextView chatMessageCountDown;
	// 录音相关
	private int voiceTm = 0;// 计时时长
	private Timer voiceTimer = null;
	private TimerTask voiceTask = null;
	private final int TOTAL_VIOCE_LENGTH = 60;// 录音最长时长
	private final int MIN_VOICE_LENGTH = 1;// 最短录音时长
	private int chatType = 0;// 聊天类型0普通消息1群组消息
	private boolean pullRefresh = false;// 下拉刷新数据
	private boolean isShowToast = false;// 是否显示提示
	private boolean isOnResume = false;// 刷新离线消息
	private boolean isSetSelect = true;// 刷新位置
	private String imageMsgName = "";// 发送图片的名称
	private AudioManager audioManager;
	private SensorManager mSensorManager;
	private Sensor mSensor;
	private int voiceMode = 0;// 0扬声器模式 1听筒模式
	private int showNick = 0;// 群聊显示昵称0显示1不显示

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleLeftButton.setText(R.string.go_back);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
		titleRightButton.setVisibility(View.VISIBLE);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_chat_main, null);
	}

	@Override
	protected void initViews() {
		fs = J_FileManager.getInstance().getFileStore();
		inputMsg = (EditText) findViewById(R.id.input_msg_text);
		btnSend = (Button) findViewById(R.id.btn_send_face);
		chatMessageShowbox = (PullToRefreshListView) findViewById(R.id.chatMessageShowbox);
		faceRelativeLayout = (FaceRelativeLayout) findViewById(R.id.FaceRelativeLayout);
		btnImageChooseCamera = (ImageButton) findViewById(R.id.btn_choose_camera);
		btnImageChooseGallery = (ImageButton) findViewById(R.id.btn_choose_gallery);
		voiceLayer = (RelativeLayout) findViewById(R.id.voiceLayer);// 语音提示层的背景层，防触
		buttonChatVoice = (Button) findViewById(R.id.btn_chat_voice);// 语音录制按钮
		touchEventShowBox = (TextView) findViewById(R.id.touchEventShowBox);// 取消发送的提示信息
		ivVoiceShow = (ImageView) findViewById(R.id.ivVoiceShow);// 语音振幅图片
		chatMessageCountDown = (TextView) findViewById(R.id.chatMessageCountDown);// 倒计时提示层
		// 初始化音频感应器
		mSoundMeter = new SoundMeter(this);
		btnSend.setOnClickListener(listener);
		btnImageChooseCamera.setOnClickListener(listener);
		btnImageChooseGallery.setOnClickListener(listener);
		buttonChatVoice.setOnTouchListener(onTouchListener);
		buttonChatVoice.setOnFocusChangeListener(new OnFocusChangeListener() {

			@Override
			public void onFocusChange(View v, boolean hasFocus) {
				if (!hasFocus && flag == 2) {
					stop();// 停止录音
					flag = 1;
					setVoiceLayerShow(2);// 隐藏语音录制提示层
					deleteVoiceFile();
				}
			}
		});
		init();
		IntentFilter filter = new IntentFilter();
		filter.addAction(UtilRequest.BROADCAST_ACTION_EXIT_GROUP);
		filter.addAction(UtilRequest.BROADCAST_ACTION_UPDATE_GROUP_NAME);
		filter.addAction(UtilRequest.BROADCAST_ACTION_UPDATE_SHOW_NICK);
		registerReceiver(mReceiver, filter);
		audioManager = (AudioManager) this.getSystemService(Context.AUDIO_SERVICE);
		mSensorManager = (SensorManager) getSystemService(Context.SENSOR_SERVICE);
		mSensor = mSensorManager.getDefaultSensor(Sensor.TYPE_PROXIMITY);
	}

	private void init() {
		pageMsgId = 0;// 初始化页码
		pageTimestamp = 0;// 初始化本地页码
		helper = ChatContactRepository.getDBHelperInstance();
		currentUid = J_Cache.sLoginUser.uid + "";
		if (getIntent().hasExtra(UtilRequest.FORM_OID)) {
			chatType = 0;
			chatUid = getIntent().getStringExtra(UtilRequest.FORM_OID);
			titleRightButton.setText("TA的主页");
			UtilRequest.sendOnreadByOid(chatUid);

		}
		if (getIntent().hasExtra(UtilRequest.FORM_GROUP_ID)) {
			chatType = 1;
			groupId = getIntent().getIntExtra(UtilRequest.FORM_GROUP_ID, 0);
			titleRightButton.setText("群组设置");
			UtilRequest.sendOnreadGroupByOid(groupId + "");
			UtilRequest.isGroupMember(groupId + "", mContext, mHandler, 0);
		}
		if (getIntent().hasExtra(UtilRequest.FORM_NICK)) {
			String nick = getIntent().getStringExtra(UtilRequest.FORM_NICK);
			titleCenter.setText(nick);
		}
		// 设置listview的数据
		chatListAdapter = new ChatListAdapter(this, currentItems, mHandler, onLongClickListener);
		chatMessageShowbox.setAdapter(chatListAdapter);
		// 对listview设置下拉加载事件监听
		chatMessageShowbox.setScrollingWhileRefreshingEnabled(false);// 加载的时候不允许滑动
		chatMessageShowbox.setPullToRefreshOverScrollEnabled(false);// 滑动到底部的时候的缓冲提示
		chatMessageShowbox.setOnRefreshListener(new OnRefreshListener<ListView>() {
			@Override
			public void onRefresh(PullToRefreshBase<ListView> refreshView) {
				// 只要是下拉获取私信记录的，首先从网络获取，如果获取不到，才取本地
				pullRefresh = true;
				isShowToast = true;
				loadHistoryMsg();
			}
		});
		chatMessageShowbox.getRefreshableView().setOnTouchListener(new OnTouchListener() {

			@Override
			public boolean onTouch(View v, MotionEvent event) {
				mHandler.sendEmptyMessage(R.id.hide_keyboard);
				return false;
			}
		});
		inputMsg.setOnEditorActionListener(onEditorActionListener);
		getChatProfile();
		UtilRequest.getVoiceSwitch(mHandler, mContext);
	}

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		setIntent(intent);

		currentItems.clear();
		chatListAdapter.clear();
		voiceTimer = null;
		voiceTask = null;
		init();
	}

	/**
	 * 获取聊天对象的资料
	 * 
	 * */
	private void getChatProfile() {
		pullRefresh = false;
		isShowToast = false;
		// 从本地数据库中获取当前用户信息
		Cursor cursor = helper.queryContactById(chatUid, groupId + "", chatType);
		// 当前用户在数据库中已经存在，则从本地获取
		int count = cursor.getCount();
		if (count > 0) {
			// 清空当前用户聊天的未读信息数量
			helper.updateNewMessageCount(chatUid, 0, null, groupId + "", chatType);
			cursor.moveToFirst();
			ChatListItem item = new ChatListItem();
			item.userIconUrl = cursor.getString(cursor.getColumnIndex(ChatDBHelper.AVATAR));
			item.nickName = cursor.getString(cursor.getColumnIndex(ChatDBHelper.NICKNAME));
			item.chatType = chatType;
			if (chatType == 0) {
				item.uid = chatUid;
				item.sex = cursor.getInt(cursor.getColumnIndex(ChatDBHelper.SEX));
				titleCenter.setText(item.nickName);
				current = item;
				chatListAdapter.setHeadUrl(item.userIconUrl, item.nickName);
			} else if (chatType == 1) {
				item.groupId = groupId + "";
				titleCenter.setText(item.nickName);
				current = item;
			}
			// 加载聊天记录
			loadPreviousRecord();
		}
		cursor.close();
		// 网络请求获取用户资料、进行数据刷新
		if (chatType == 0) {// 单对单聊天
			UtilRequest.getUserInfo(mContext, mHandler, chatUid);
		} else if (chatType == 1) {
			UtilRequest.getGroup(groupId, mHandler);
		}
	}

	@Override
	protected void onResume() {
		super.onResume();
		mSensorManager.registerListener(sensorEventListener, mSensor, SensorManager.SENSOR_DELAY_NORMAL);
		isShowToast = false;
		isOnResume = true;
		if (chatType == 1) {// 群组消息只能根据msgid查询
			pageMsgId = helper.queryGroupChatRecordLastIid(groupId);
			if (pageMsgId <= 0) {
				pageMsgId = 0;
			}
		} else {
			pageMsgId = 0;
		}
		loadHistoryMsg();
		if (chatType == 0) {
			J_Application.pushActiviy.put(chatUid, this);
		} else if (chatType == 1) {
			J_Application.pushActiviy.put(groupId + "", this);
		}
	}

	SensorEventListener sensorEventListener = new SensorEventListener() {

		@Override
		public void onSensorChanged(SensorEvent event) {
			float range = event.values[0];
			if (voiceMode == 0) {
				if (range >= mSensor.getMaximumRange()) {// 正常模式
					audioManager.setMode(AudioManager.MODE_NORMAL);
					audioManager.setSpeakerphoneOn(true);
				} else {// 听筒模式
					audioManager.setMode(AudioManager.MODE_IN_CALL);
					audioManager.setSpeakerphoneOn(false);
				}
			}
		}

		@Override
		public void onAccuracyChanged(Sensor sensor, int accuracy) {
		}
	};

	private final BroadcastReceiver mReceiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {
			String action = intent.getAction();
			if (UtilRequest.BROADCAST_ACTION_EXIT_GROUP.equals(action)) {// 退群通知
				finish();
			} else if (UtilRequest.BROADCAST_ACTION_UPDATE_GROUP_NAME.equals(action)) {
				int updateGroupId = intent.getIntExtra(UtilRequest.FORM_GROUP_ID, 0);
				String title = intent.getStringExtra(UtilRequest.FORM_TITLE);
				if (groupId == updateGroupId) {
					titleCenter.setText(title);
				}
			} else if (UtilRequest.BROADCAST_ACTION_UPDATE_SHOW_NICK.equals(action) && chatType == 1) {// 群聊更新是否显示昵称
				int updateGroupId = intent.getIntExtra(UtilRequest.FORM_GROUP_ID, 0);
				int updateShowNick = intent.getIntExtra(UtilRequest.FORM_SHOW_NICK, 0);
				if (updateGroupId == groupId) {
					chatListAdapter.showNick(updateShowNick);
				}
			}
		}
	};

	@Override
	protected void onPause() {
		mSensorManager.unregisterListener(sensorEventListener);
		super.onPause();
		if (chatType == 0) {
			J_Application.pushActiviy.remove(chatUid);
		} else if (chatType == 1) {
			J_Application.pushActiviy.remove(groupId + "");
		}
		chatListAdapter.clearPlayingVoice();
	}

	/**
	 * @Fields onEditorActionListener : 监听键盘发送按钮
	 */
	private final OnEditorActionListener onEditorActionListener = new OnEditorActionListener() {

		@Override
		public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
			if (actionId == EditorInfo.IME_ACTION_SEND) {
				String text = inputMsg.getText().toString();
				if (text.length() > 0) {
					submitContent(text);
					return true;
				}
			}
			return false;
		}
	};

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 头部左侧按钮
				mHandler.sendEmptyMessage(R.id.hide_keyboard);
				if (!Util.isRunning(mContext)) {
					Intent intent = new Intent(mContext, MainBoxActivity.class);
					startActivity(intent);
				}
				finish();
				break;
			case R.id.titleRightButton:// 头部右侧按钮
				if (chatType == 0) {// 普通聊天跳转到个人主页
					Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
					long uid = Long.valueOf(chatUid);
					profileIntent.putExtra(UtilRequest.FORM_UID, uid);
					startActivity(profileIntent);
				} else {// 群组聊天跳转到群组设置
					Intent intent = new Intent(mContext, GroupSettingsActivity.class);
					intent.putExtra(UtilRequest.FORM_GROUP_ID, groupId);
					startActivity(intent);
				}
				break;
			case R.id.btn_send_face:// 发送按钮
				String content = inputMsg.getText().toString();
				submitContent(content);
				break;
			case R.id.btn_choose_camera:
				// 拍照
				imageMsgName = System.currentTimeMillis() + "";
				upload.setCacheName(imageMsgName);
				upload.getHeaderFromCamera();
				break;
			case R.id.btn_choose_gallery:
				// 相册
				imageMsgName = System.currentTimeMillis() + "";
				upload.setCacheName(imageMsgName);
				upload.getHeaderFromGallery();
				break;
			default:
				break;
			}
		}
	};

	private final OnLongClickListener onLongClickListener = new OnLongClickListener() {

		@Override
		public boolean onLongClick(View v) {
			int position = (Integer) v.getTag();
			switch (v.getId()) {
			case R.id.chat_text_sender:// 长按复制收到的消息
			case R.id.chat_text_recever:// 长按复制发送的消息
				showChatHelpDialog(position, ChatHelpDialog.COPY_MESSAGE);
				break;
			case R.id.chatVoiceSenderButtonBox:
			case R.id.chatVoiceReceverButtonBox:// 切换听筒扬声器模式
				if (voiceMode == 0) {
					showChatHelpDialog(position, ChatHelpDialog.VOICE_SWITCH_NORMAL);
				} else if (voiceMode == 1) {
					showChatHelpDialog(position, ChatHelpDialog.VOICE_SWITCH_IN_CALL);
				}
				break;
			}
			return true;
		}
	};
	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_IS_GROUP_MEMBER:// 是群组成员
				if (msg.obj == null) {
					Intent exitIntent = new Intent(UtilRequest.BROADCAST_ACTION_EXIT_GROUP);
					exitIntent.putExtra(UtilRequest.FORM_GROUP_ID, groupId + "");
					Util.sendBroadcast(exitIntent);
					finish();
				}
				break;
			case NetTaskIDs.TASKID_GET_GROUP:// 群组信息
				try {
					JSONObject groupObject = new JSONObject(msg.obj.toString());
					String title = groupObject.optString(UtilRequest.FORM_TITLE);
					showNick = groupObject.optInt(UtilRequest.FORM_SHOW_NICK, 0);
					chatListAdapter.showNick(showNick);
					ChatListItem item = new ChatListItem();
					item.userIconUrl = groupObject.optString(UtilRequest.FORM_LOGO);
					item.nickName = title;
					item.chatType = chatType;
					item.groupId = groupId + "";
					titleCenter.setText(item.nickName);
					current = item;
					helper.updateContactAvatar(item.groupId, item.userIconUrl, chatType, item.nickName);
				} catch (JSONException e) {
					e.printStackTrace();
				}
				break;
			case NetTaskIDs.TASKID_SEND_TEXT_MSG:// 发送文本聊天
				if (msg.arg1 != 0) {// 发送失败
					long id = (Long) msg.obj;
					updateTextMsg(id, ChatConstant.MSG_SYNCHRONIZE_FAILED, null, null);
				} else {
					SendTextMsgResonse textResponse = (SendTextMsgResonse) msg.obj;
					if (textResponse != null) {
						if (textResponse.status == 1 && textResponse.retcode == 1
								&& JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(textResponse.retmean)) {
							// 发送成功
							updateTextMsg(textResponse.chat_table_id, ChatConstant.MSG_SYNCHRONIZE_SUCCESS, textResponse.iid,
									textResponse.time);
						} else {// 发送失败
							showChatFailToast(textResponse.status);
							updateTextMsg(textResponse.chat_table_id, ChatConstant.MSG_SYNCHRONIZE_FAILED, null, null);
						}
					}
				}
				chatListAdapter.notifyDataSetChanged();
				break;
			case NetTaskIDs.TASKID_SEND_GROUP_MSG:// 群组文本消息
				if (msg.arg1 != 0) {// 发送失败
					long id = (Long) msg.obj;
					updateTextMsg(id, ChatConstant.MSG_SYNCHRONIZE_FAILED, null, null);
				} else {
					SendGroupMsgResonse textResponse = (SendGroupMsgResonse) msg.obj;
					if (textResponse != null) {
						if (textResponse.status == 1 && textResponse.retcode == 1
								&& JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(textResponse.retmean)) {
							// 发送成功
							updateTextMsg(textResponse.chat_table_id, ChatConstant.MSG_SYNCHRONIZE_SUCCESS, textResponse.iid,
									textResponse.time);
						} else {// 发送失败
							showChatFailToast(textResponse.status);
							updateTextMsg(textResponse.chat_table_id, ChatConstant.MSG_SYNCHRONIZE_FAILED, null, null);
						}
					}
				}
				chatListAdapter.notifyDataSetChanged();
				break;
			case NetTaskIDs.TASKID_SEND_PIC_MSG:// 图片消息
			case NetTaskIDs.TASKID_SEND_PIC_GROUP_MSG:// 群组图片消息
				String resultPic = (String) msg.obj;
				int locMsgIdPic = msg.arg1;
				updateVoiceImgMsg(resultPic, locMsgIdPic);
				break;
			case NetTaskIDs.TASKID_SEND_VOICE_MSG:// 语音消息
			case NetTaskIDs.TASKID_SEND_VOICE_GROUP_MSG:// 群组语音消息
				String resultVoice = (String) msg.obj;
				int locMsgIdVoice = msg.arg1;
				updateVoiceImgMsg(resultVoice, locMsgIdVoice);
				break;
			case NetTaskIDs.TASKID_GET_USER_INFO:// 获得聊天用户数据
				UserInfoResponse response = (UserInfoResponse) msg.obj;
				ChatListItem item = new ChatListItem();
				if (response.userInfo != null) {
					item.uid = response.userInfo.uid + "";
					item.userIconUrl = response.userInfo.avatarUrl;
					item.sex = response.userInfo.sex;
					if (!Util.isBlankString(response.userInfo.mark)) {
						item.nickName = response.userInfo.mark;
					} else {
						item.nickName = response.userInfo.nickName;
					}
					item.chatType = chatType;
					titleCenter.setText(item.nickName);
					current = item;
					helper.updateContactAvatar(item.uid, item.userIconUrl, chatType, item.nickName);
					chatListAdapter.setHeadUrl(item.userIconUrl, item.nickName);
					chatListAdapter.notifyDataSetChanged();
				}
				DialogUtils.dismissDialog();
				// loadPreviousRecord(false);
				break;
			case NetTaskIDs.TASKID_GET_HISTORY_USER_CHAT_LIST:// 获得消息离线数据
			case NetTaskIDs.TASKID_GET_HISTORY_GROUP_CHAT_LIST:// 获得群组消息离线数据
				if (isOnResume) {// onresume刷新最新的离线数据
					isOnResume = false;
					pageTimestamp = 0;
					isSetSelect = false;
				}
				updateHitoryUserChatList(msg.obj);
				break;
			case NetTaskIDs.UPDATE_IMAGE_MSG_UPLOAD_PERCENT:// 更新图片消息上传状态
				int locMsgIdImg = msg.arg1;
				int percent = msg.arg2;
				for (int i = 0; i < currentItems.size(); i++) {
					if (currentItems.get(i).getId() == locMsgIdImg) {
						currentItems.get(i).setPercent(percent);
						break;
					}
				}
				chatListAdapter.notifyDataSetChanged();
				break;
			case R.id.hide_keyboard:// 隐藏键盘
				Util.hideKeyboard(mContext, chatMessageShowbox);
				if (faceRelativeLayout != null) {
					boolean isFaceLayerShown = faceRelativeLayout.getFaceLayerShowStatus();
					if (isFaceLayerShown) {
						faceRelativeLayout.hideFaceView();
					}
				}
				break;
			case R.id.resend_msg:// 重新发送消息
				int resendPosition = (Integer) msg.obj;
				ChatItem resendCi = currentItems.get(resendPosition);
				if (resendCi.getStatus() != ChatConstant.MSG_SYNCHRONIZE_FAILED) {// 发送失败的情况下才可以从新发送
					return;
				}
				String msgLocalId = String.valueOf(resendCi.getId()); // 消息的本地id
				String msgContent = resendCi.getContent();// 消息内容
				if (TextUtils.isEmpty(msgLocalId) || TextUtils.isEmpty(msgContent)) {
					return;
				}
				// 删除原纪录-再重新发送
				deleteLocalMsg(msgLocalId, resendPosition);
				// 再重新发送
				if (resendCi.getMimeType().equals(ChatConstant.MIME_TYPE_TEXT_PLAIN)) {
					ChatItem resendChatItem = new ChatItem();
					resendChatItem.setContent(msgContent);
					resendChatItem.setBoxType(2);
					resendChatItem.setTimeStamp(String.valueOf(System.currentTimeMillis()));
					resendChatItem.setContactId(chatUid);
					resendChatItem.setGroupId(groupId + "");
					resendChatItem.setMimeType(ChatConstant.MIME_TYPE_TEXT_PLAIN);// 标记发送类型为文字信息
					resendChatItem.setStatus(ChatConstant.MSG_SYNCHRONIZING);// 默认发送状态：发送中的状态
					resendChatItem.setMsgId("0");
					resendChatItem.setId(0);
					sendMsg(resendChatItem, true);// 重新发送
				} else if (resendCi.getMimeType().equals(ChatConstant.MIME_TYPE_IMAGE_JPEG)) {
					sendImgMsg(resendCi.getFileName(), true);
				} else if (resendCi.getMimeType().equals(ChatConstant.MIME_TYPE_AUIDO_AMR)) {
					sendVoiceMsg(resendCi.getVoiceLength(), resendCi.getFileName(), true);
				}
				break;
			case NetTaskIDs.TASKID_GET_USER_VOICE_SWITCH:// 获取听筒模式和扬声器模式开关
				voiceMode = (Integer) msg.obj;
				chatListAdapter.setShowVoiceMode(voiceMode);
				break;
			case NetTaskIDs.TASKID_SET_USER_VOICE_SWITCH:// 设置听筒模式和扬声器模式开关
				DialogUtils.dismissDialog();
				voiceMode = (Integer) msg.obj;
				if (voiceMode == 1) {// 声音开关 0扬声器 1听筒
					audioManager.setMode(AudioManager.MODE_IN_CALL);
					audioManager.setSpeakerphoneOn(false);
				} else {
					audioManager.setMode(AudioManager.MODE_NORMAL);
					audioManager.setSpeakerphoneOn(true);
				}
				chatListAdapter.setShowVoiceMode(voiceMode);
				break;

			}
		};
	};

	/**
	 * 提交文字聊天信息
	 * 
	 * @param content 聊天内容
	 * 
	 */
	private void submitContent(String content) {
		if (current == null) {
			return;
		}
		if (Util.isBlankString(content)) {
			ToastUtil.showToast(this, "请输入新消息");
		} else {
			// 发送聊天信息一
			ChatItem item = new ChatItem();
			item.setContent(content);
			item.setBoxType(2);
			item.setTimeStamp(String.valueOf(System.currentTimeMillis()));
			item.setContactId(chatUid);
			item.setMimeType(ChatConstant.MIME_TYPE_TEXT_PLAIN);// 标记发送类型为文字信息
			item.setStatus(ChatConstant.MSG_SYNCHRONIZING);// 默认发送状态：发送中
			item.setMsgId("0");
			item.setId(0);
			item.setGroupId(groupId + "");
			item.setChatType(chatType);
			sendMsg(item, true);// 正常发送聊天信息
			inputMsg.setText("");// 清空输入框
		}
	}

	/**
	 * proc to send message
	 * 
	 * @param ci
	 * @param isNew if the message if new one or resend
	 */
	private void sendMsg(ChatItem ci, boolean isNew) {
		if (ci.getId() == 0) {
			long keyId = helper.addChatRecord(ci);// 添加本次聊天记录
			ci.setId((int) keyId);
			updateChatFriendsData(ci, ChatConstant.MSG_SYNCHRONIZING, System.currentTimeMillis() + "");
		}
		try {
			JSONObject form = new JSONObject();
			if (chatType == 0) {
				form.put(UtilRequest.FORM_TO_UID, ci.getContactId());
				form.put(UtilRequest.FORM_CONTENT, ci.getContent());
				UtilRequest.sendTextMsg(mContext, mHandler, form.toString(), ci.getId());
			} else if (chatType == 1) {
				form.put(UtilRequest.FORM_GROUP_ID, ci.getGroupId());
				form.put(UtilRequest.FORM_CONTENT, ci.getContent());
				UtilRequest.sendGroupMsg(mContext, mHandler, form.toString(), ci.getId());
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
		if (isNew) {
			currentItems.add(ci);
			chatListAdapter.notifyDataSetChanged();
			chatMessageShowbox.getRefreshableView().setSelection(currentItems.size());
		}
	}

	/**
	 * @Title: updateChatFriendsData
	 * @Description: 本地添加用户数据
	 * @return void 返回类型
	 * @param @param ci 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void updateChatFriendsData(ChatItem ci, int status, String time) {
		// 从本地数据库中获取当前用户信息
		Cursor cursor = helper.queryContactById(chatUid, groupId + "", chatType);
		// 当前用户在数据库中已经存在，则从本地获取
		int count = cursor.getCount();
		if (count <= 0) {
			// 加载聊天记录
			helper.addContact(current, System.currentTimeMillis() + "");
		}
		cursor.close();
		// 更新该用户的最后一条聊天信息
		helper.updateLastMessage(ci.getContactId(), ci.getContent(), status, time, ci.getChatType(), ci.getGroupId());
	}

	/**
	 * @Title: updateTextMsg
	 * @Description: 更新文本消息
	 * @return void 返回类型
	 * @param @param id 消息本地_id
	 * @param @param status 消息状态
	 * @param @param msgId 消息服务器id
	 * @param @param time 时间戳
	 * @author donglizhi
	 * @throws
	 */
	private void updateTextMsg(long id, int status, String msgId, String time) {
		for (int i = 0; i < currentItems.size(); i++) {
			if (currentItems.get(i).getId() == id) {
				currentItems.get(i).setStatus(status);
				if (!Util.isBlankString(msgId)) {
					currentItems.get(i).setMsgId(msgId);
				}
				if (!Util.isBlankString(time)) {
					currentItems.get(i).setTimeStamp(time);
				}
				helper.updateChatRecord(currentItems.get(i));
				helper.updateLastMessage(currentItems.get(i).getContactId(), currentItems.get(i).getContent(), currentItems
						.get(i).getStatus(), currentItems.get(i).getTimeStamp(), currentItems.get(i).getChatType(), currentItems
						.get(i).getGroupId());
				break;
			}
		}
	}

	/**
	 * 加载聊天记录
	 * 
	 * */
	public void loadHistoryMsg() {
		if (!J_NetUtil.isNetConnected(mContext)) {
			// 如果没有网络，从本地获取
			loadPreviousRecord();
		} else {
			// 如果网络状态良好，从网络获取
			if (chatType == 0) {
				UtilRequest.get_history_user_chat_list(mContext, mHandler, chatUid, pageMsgId + "", pageSize + "");
			} else if (chatType == 1) {
				UtilRequest.getGroupChatHistoryList(groupId + "", pageMsgId + "", pageSize, mHandler, mContext);
			}
		}
	}

	/**
	 * @Title: loadPreviousRecord
	 * @Description: 加载聊天数据
	 * @return void 返回类型
	 * @param @param isFirst 初次加载
	 * @author donglizhi
	 * @throws
	 */
	private synchronized void loadPreviousRecord() {
		int delayMillis = currentItems.size() <= 0 ? 0 : 500;

		mHandler.postDelayed(new Runnable() {

			@Override
			public void run() {
				// 首先从本地读取用户聊天记录
				ArrayList<ChatItem> chatItems = new ArrayList<ChatItem>();
				if (helper != null) {
					// 首先从本地数据库中获取用户聊天记录
					chatItems = helper.queryChatRecordByTime(chatUid, pageTimestamp, pageSize, chatType, groupId + "");
				}
				if (chatItems.size() > 0) {
					// 过滤加载数据
					ArrayList<ChatItem> chatItem_temp = new ArrayList<ChatItem>();// 临时数据
					if (currentItems.size() > 0) {
						for (int i = 0; i < chatItems.size(); i++) {
							boolean isHave = false;// 标记是否存在该id
							for (int j = 0; j < currentItems.size(); j++) {
								if (chatItems.get(i).getId() == currentItems.get(j).getId()) {
									isHave = true;// 存在该id的标记
								}
							}
							if (!isHave) {
								// 不存在该id，可以添加
								chatItem_temp.add(chatItems.get(i));
							}
						}
					} else {
						chatItem_temp = chatItems;
					}
					if (chatItem_temp.size() > 0) {
						currentItems.addAll(0, chatItem_temp);// 在0位置处加入本次聊天数据
					}
					pageMsgId = getMinMsgId(currentItems);// 获取最小的一个msgid
					pageTimestamp = getMinTimestamp(currentItems);// 获取最小的一个时间戳
					// 对消息列表重新排序
					reSortMsgOrder();
					ChatItem item = currentItems.get(currentItems.size() - 1);
					updateChatFriendsData(item, item.getStatus(), item.getTimeStamp());
					// 回调刷新ui数据
					chatMessageShowbox.onRefreshComplete(Mode.PULL_FROM_START);
					chatListAdapter.notifyDataSetChanged();
					if (isSetSelect) {// onresume更新数据后不刷新位置
						int loadNum = chatItem_temp.size();
						chatMessageShowbox.getRefreshableView().setSelection(loadNum + 1);
					} else {
						isSetSelect = true;
					}
				} else {
					noMoreData();
				}
			}

		}, delayMillis);
	}

	/**
	 * 获取最小的msgid
	 * 
	 * */
	private long getMinMsgId(ArrayList<ChatItem> chatItems) {
		long minMsgId = 0;

		if (chatItems != null && chatItems.size() > 0) {
			for (int i = 0; i < chatItems.size(); i++) {
				String msgId = chatItems.get(i).getMsgId();
				if (!Util.isBlankString(msgId)) {
					long currMsgId = Util.getLong(msgId);
					if (currMsgId <= 0) {
						continue;
					} else if (minMsgId == 0) {
						minMsgId = currMsgId;
					}
					// 对比获取出msgid比较小的那个id
					if (minMsgId > currMsgId) {
						minMsgId = currMsgId;
					}
				}
			}
		}

		return minMsgId;
	}

	/**
	 * 获取最小的Timestamp
	 * 
	 * */
	private long getMinTimestamp(ArrayList<ChatItem> chatItems) {
		long minTimestamp = 0;

		if (chatItems != null && chatItems.size() > 0) {
			for (int i = 0; i < chatItems.size(); i++) {
				String timestamp = chatItems.get(i).getTimeStamp();
				if (!Util.isBlankString(timestamp)) {
					long currTimestamp = Util.getLong(timestamp);
					if (currTimestamp <= 0) {
						continue;
					} else if (minTimestamp == 0) {
						minTimestamp = currTimestamp;
					}
					// 对比获取出msgid比较小的那个id
					if (minTimestamp > currTimestamp) {
						minTimestamp = currTimestamp;
					}
				}
			}
		}

		return minTimestamp;
	}

	/**
	 * 对聊天记录重新排序
	 * 
	 * */
	private void reSortMsgOrder() {
		ChatMsgComparator comparator = new ChatMsgComparator();
		Collections.sort(currentItems, comparator);
	}

	/**
	 * @Title: noMoreData
	 * @Description: 没有消息数据
	 * @return void 返回类型
	 * @param @param isFirst 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void noMoreData() {
		// 没有获取到数据的情况下处理
		if (currentItems.size() <= 0) {
			// 没有聊天记录的时候
			if (isShowToast) {
				isShowToast = false;
				ToastUtil.showToast(mContext, "没有更多消息");
				chatMessageShowbox.onRefreshComplete(Mode.PULL_FROM_START);
			} else {
				// 并且不能下拉
				chatMessageShowbox.onRefreshComplete(Mode.DISABLED);
			}
		} else {
			if (pullRefresh) {
				pullRefresh = false;
				ToastUtil.showToast(mContext, "没有更多消息");
			}
			chatMessageShowbox.onRefreshComplete(Mode.PULL_FROM_START);
		}
	}

	/**
	 * @Title: getNewMsg
	 * @Description: 显示新推送的消息
	 * @return void 返回类型
	 * @param @param lc_msg_id 本地消息id
	 * @author donglizhi
	 * @throws
	 */
	public void getNewMsg(int lc_msg_id) {
		List<ChatItem> chatList = new ArrayList<ChatItem>();
		if (chatType == 0 && Util.isBlankString(chatUid)) {
			return;
		} else if (chatType == 1 && groupId <= 0) {
			return;
		}
		chatList = helper.queryNewChatRecord(chatUid, lc_msg_id, groupId + "", chatType);
		if (chatList != null) {
			for (ChatItem item : chatList) {
				if (item.getMimeType().equals(ChatConstant.MIME_TYPE_TEXT_PLAIN)) {
					item.setStatus(ChatConstant.MSG_SYNCHRONIZE_SUCCESS);
				}
				currentItems.add(item);
			}
			chatListAdapter.notifyDataSetChanged();
		}
	}

	public int getChatType() {
		return chatType;
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		switch (requestCode) {
		case UploadPhotoDataAccess.REQUEST_ASK_CAMERA:// 拍照
		case UploadPhotoDataAccess.REQUEST_ASK_GALLERY:// 图库
			// 此处是通过upload对象打开相机或相册时，选择图片后返回处理
			File file_photo = upload.onActivityResult(requestCode, resultCode, data);
			if (file_photo != null) {
				String photoPath = file_photo.getAbsolutePath();
				if (!Util.isBlankString(photoPath)) {
					// 执行发送图片操作
					sendImgMsg(imageMsgName, true);
				}
			}
			break;
		}
	};

	/**
	 * 上传图片msg
	 * 
	 * */
	private void sendImgMsg(String picName, boolean isNew) {
		ChatItem imageItem = new ChatItem();
		imageItem.setBoxType(2);// 发送方标记
		imageItem.setTimeStamp(String.valueOf(System.currentTimeMillis()));// 发送时间
		imageItem.setContactId(chatUid);// 聊天对方uid
		imageItem.setMimeType(ChatConstant.MIME_TYPE_IMAGE_JPEG);// 标记发送类型为文字信息
		imageItem.setStatus(ChatConstant.MSG_SYNCHRONIZING);// 默认发送状态：发送中
		imageItem.setIsAck(0);// 设置为未读状态0：未读，1：已读
		imageItem.setFileName(picName);
		imageItem.setFileNameThumb(picName);
		imageItem.setContent(getString(R.string.image_msg));
		imageItem.setPercent(0);
		imageItem.setChatType(chatType);
		imageItem.setGroupId(groupId + "");
		File file = fs.isFileExistSDCardAndRam(picName, null);
		if (file == null) {
			return;
		}
		Bitmap bitmap = BitmapFactory.decodeFile(file.getAbsolutePath());
		final int max_width_height = getResources().getDimensionPixelOffset(R.dimen.img_msg_max_width_height);
		float[] reSize = ImageUtils.getBitmapScaleSize(bitmap.getWidth(), bitmap.getHeight(), max_width_height);
		imageItem.setThumbImageWidth((int) reSize[0]);
		imageItem.setThumbImageHeight((int) reSize[1]);

		if (imageItem.getId() == 0) {
			long keyId = helper.addChatRecord(imageItem);// 添加本次聊天记录
			imageItem.setId((int) keyId);
			updateChatFriendsData(imageItem, ChatConstant.MSG_SYNCHRONIZING, System.currentTimeMillis() + "");
		}
		String photoPath = fs.getFileSdcardAndRamPath(picName);
		if (chatType == 0) {
			UtilRequest.sendPicMsg(photoPath, mHandler, chatUid, imageItem.getId());
		} else if (chatType == 1) {
			UtilRequest.sendPicGroupMsg(photoPath, mHandler, groupId + "", imageItem.getId());
		}

		if (isNew) {
			currentItems.add(imageItem);
			chatListAdapter.notifyDataSetChanged();
			chatMessageShowbox.getRefreshableView().setSelection(currentItems.size());
		}
	}

	/**
	 * 发送音频文件信息
	 * 
	 * */
	private void sendVoiceMsg(int voiceLen, String voiceName, boolean isNew) {
		if (current == null) {
			return;
		}
		String path = fs.getFileSdcardAndRamPath(voiceName);
		File voiceFile = new File(path);
		if (voiceFile.exists() && voiceFile.length() <= 0) {
			ToastUtil.showToast(mContext, "请确认您已经允许友寻使用录音功能！");
			return;
		}

		ChatItem voiceItem = new ChatItem();
		voiceItem.setBoxType(2);// 发送方标记
		voiceItem.setTimeStamp(String.valueOf(System.currentTimeMillis()));// 发送时间
		voiceItem.setContactId(chatUid);// 聊天对方uid
		voiceItem.setMimeType(ChatConstant.MIME_TYPE_AUIDO_AMR);// 标记发送类型为文字信息
		voiceItem.setStatus(ChatConstant.MSG_SYNCHRONIZING);// 默认发送状态：发送中
		voiceItem.setVoiceLength(voiceLen);// 音频时长
		voiceItem.setFileName(voiceName);
		voiceItem.setFileNameThumb(voiceName);
		voiceItem.setIsAck(0);// 设置为未读状态0：未读，1：已读
		voiceItem.setContent(getString(R.string.voice_msg));
		voiceItem.setChatType(chatType);
		voiceItem.setGroupId(groupId + "");
		if (voiceItem.getId() == 0) {
			helper = ChatDBHelper.getHelper(mContext, currentUid);
			long keyId = helper.addChatRecord(voiceItem);// 添加本次聊天记录
			voiceItem.setId((int) keyId);
			updateChatFriendsData(voiceItem, ChatConstant.MSG_SYNCHRONIZING, System.currentTimeMillis() + "");
		}
		if (chatType == 0) {
			UtilRequest.sendVoiceMsg(path, chatUid, mHandler, voiceLen + "", voiceItem.getId());
		} else if (chatType == 1) {
			UtilRequest.sendGroupVoiceMsg(path, groupId + "", mHandler, voiceLen + "", voiceItem.getId());
		}

		if (isNew) {
			currentItems.add(voiceItem);
			chatListAdapter.notifyDataSetChanged();
			chatMessageShowbox.getRefreshableView().setSelection(currentItems.size());
		}
	}

	// 标记当前录音状态
	protected int flag = 1;
	protected Handler voiceHandler = new Handler();
	protected String voiceName;// 录制音频的文件名
	protected SoundMeter mSoundMeter;// 录音感应器
	protected static final int POLL_INTERVAL = 100;// 录制监听事件间隔

	private final OnTouchListener onTouchListener = new OnTouchListener() {

		@Override
		public boolean onTouch(View v, MotionEvent event) {
			switch (v.getId()) {
			case R.id.btn_chat_voice:
				// 停止播放录音
				chatListAdapter.clearPlayingVoice();
				// 语音输入按钮点击
				int[] location = new int[2];
				v.getLocationInWindow(location); // 获取在当前窗口内的绝对坐标
				float eventRawX = event.getRawX();// 当前手势相对屏幕的x坐标
				float eventRawY = event.getRawY();// 当前手势相对屏幕的y坐标
				int btnStartY = location[1];
				int btnStartX = location[0];
				if ((event.getAction() == MotionEvent.ACTION_UP && flag == 1) || event.getAction() == MotionEvent.ACTION_CANCEL) {
					mHandler.removeCallbacks(startRecordRunnable);
					stop();// 停止录音
					flag = 1;
					setVoiceLayerShow(2);// 隐藏语音录制提示层
					deleteVoiceFile();
				} else if (event.getAction() == MotionEvent.ACTION_DOWN && flag == 1) {
					titleLeftButton.setClickable(false);
					titleRightButton.setClickable(false);
					// 按下手势时进行语音录制
					if (!FileUtils.isSDCardExist()) {
						ToastUtil.showToast(mContext, getString(R.string.str_not_install_sd_card));
						return false;
					}
					if (eventRawY > btnStartY && eventRawX > btnStartX) {
						// 延时500毫秒开始录音，防止触摸时间太短recorder崩溃
						mHandler.postDelayed(startRecordRunnable, 500);
					}
				} else if (event.getAction() == MotionEvent.ACTION_UP && flag == 2) {
					stop();// 停止录音
					flag = 1;
					setVoiceLayerShow(2);// 隐藏语音录制提示层
					// 松开手势时执行录制完成
					if (eventRawY > btnStartY) {
						// 松开手势的位置，可以正常发送语音
						// 计算录制事件
						if (voiceTm < MIN_VOICE_LENGTH) {
							// 少于1秒，提示录制失败
							// Util.showToast(mContext, "录音时间太短");
							deleteVoiceFile();
						} else {
							// 录制正常，进行保存发送
							// 发送音频信息
							sendVoiceMsg(voiceTm, voiceName, true);
						}
						// 保存并发送音频文件
					} else {
						// 取消发送-删除录制的音频文件
						deleteVoiceFile();
					}
				} else if (flag == 2) {
					// 判断当前手势所在的位置，进行相应的操作（手指未离开屏幕的情况）
					if (eventRawY < btnStartY - 100) {
						// 手势现在按下的位置不在语音录制按钮的范围内
						// 提示停止录制
						setVoiceLayerShow(0);
					} else {
						// 手势现在按下的位置在语音录制按钮的范围内
						setVoiceLayerShow(1);
					}
				}
				break;
			default:
				break;
			}
			return false;
		}
	};

	private final Runnable startRecordRunnable = new Runnable() {

		@Override
		public void run() {
			// 判断手势按下的位置是否是语音录制按钮的范围内-录制中....
			setVoiceLayerShow(1);
			// 录音前的准备
			long startVoiceT = System.currentTimeMillis();
			voiceName = String.valueOf(startVoiceT);
			start(voiceName);
			flag = 2;
		}
	};

	/**
	 * 语音层显示控制
	 * 
	 * @param type 1:正常 0：取消 2：关闭弹层
	 * */
	private int currentType = -1;

	private void setVoiceLayerShow(int type) {
		switch (type) {
		case 0:// 取消
			if (currentType != type) {
				voiceLayer.setVisibility(View.VISIBLE);// 显示语音录制提示层
				touchEventShowBox.setText("松开手指，取消发送");// 松开手指，取消发送
				currentType = type;
			}
			break;
		case 1:// 正常
			if (currentType != type) {
				voiceLayer.setVisibility(View.VISIBLE);// 显示语音录制提示层
				touchEventShowBox.setText("手指上滑，取消发送");// 松开手指，取消发送
				currentType = type;
			}
			break;
		case 2:// 隐藏
			if (currentType != type) {
				voiceLayer.setVisibility(View.GONE);// 隐藏语音录制提示层
				currentType = type;
			}
			break;
		default:
			break;
		}
	}

	/**
	 * 删除音频文件
	 * 
	 * */
	public void deleteVoiceFile() {
		File tempVoicefile = new File(fs.getFileStorePath() + "/" + voiceName);
		// 删除音频文件
		if (tempVoicefile.exists()) {
			tempVoicefile.delete();
		}
	}

	/**
	 * 开始录音，并更新录音振幅图片
	 * 
	 * */
	protected Runnable mPollTask = new Runnable() {
		@Override
		public void run() {
			double amp = mSoundMeter.getAmplitude();
			updateDisplay(amp);
			voiceHandler.postDelayed(mPollTask, POLL_INTERVAL);
		}
	};

	/**
	 * 录音开始计时
	 * 
	 * */
	private void startTime() {
		voiceTm = 0;// 初始化时长
		if (voiceTimer == null) {
			voiceTimer = new Timer();
		}
		if (voiceTask == null) {
			voiceTask = new TimerTask() {
				@Override
				public void run() {
					if (voiceTm < TOTAL_VIOCE_LENGTH) {
						voiceTm++;
					}
					mHandler.post(mRunnable);
				}
			};
		}
		voiceTimer.schedule(voiceTask, 1000, 1000);
	}

	private final Runnable mRunnable = new Runnable() {

		@Override
		public void run() {
			// 计时器
			int lostTime = TOTAL_VIOCE_LENGTH - voiceTm;
			String lostTxt = lostTime + "''";
			chatMessageCountDown.setText(lostTxt);
			if (chatMessageCountDown.getVisibility() == View.GONE) {
				chatMessageCountDown.setVisibility(View.VISIBLE);
			}
			if (voiceTm == TOTAL_VIOCE_LENGTH) {
				// 1.5秒后关闭
				new Handler().postDelayed(new Runnable() {
					@Override
					public void run() {
						chatMessageCountDown.setVisibility(View.GONE);
					}
				}, 1500);
				stop();// 停止录音
				flag = 1;
				setVoiceLayerShow(2);// 隐藏语音录制提示层
				// 发送语音
				sendVoiceMsg(voiceTm, voiceName, true);
			}
		}
	};

	/**
	 * 录音结束计时
	 * 
	 * */
	private void stopTime() {
		if (voiceTimer != null) {
			voiceTimer.cancel();
			voiceTimer = null;
		}
		if (voiceTask != null) {
			voiceTask.cancel();
			voiceTask = null;
		}
		chatMessageCountDown.setVisibility(View.GONE);
		voiceHandler.removeCallbacksAndMessages(null);
	}

	/**
	 * 开始录音
	 * 
	 * */
	private void start(String name) {
		mSoundMeter.start(name);
		voiceHandler.postDelayed(mPollTask, POLL_INTERVAL);
		// 开始计时
		startTime();
	}

	/**
	 * 停止录音
	 * 
	 * */
	private void stop() {
		voiceHandler.removeCallbacks(mPollTask);
		mSoundMeter.stop();
		ivVoiceShow.setImageResource(R.drawable.amp1);
		// 结束计时
		stopTime();
		titleLeftButton.setClickable(true);
		titleRightButton.setClickable(true);
	}

	/**
	 * 更新显示的振幅图片
	 * 
	 * */
	private void updateDisplay(double signalEMA) {
		int signal = (int) signalEMA;
		switch (signal) {
		case 0:
		case 1:
			ivVoiceShow.setImageResource(R.drawable.amp1);
			break;
		case 2:
		case 3:
			ivVoiceShow.setImageResource(R.drawable.amp2);
			break;
		case 4:
		case 5:
			ivVoiceShow.setImageResource(R.drawable.amp3);
			break;
		case 6:
		case 7:
			ivVoiceShow.setImageResource(R.drawable.amp4);
			break;
		case 8:
		case 9:
			ivVoiceShow.setImageResource(R.drawable.amp5);
			break;
		default:
			ivVoiceShow.setImageResource(R.drawable.amp5);
			break;
		}
	}

	/**
	 * @Title: updateVoiceImgMsg
	 * @Description: 更新消息状态
	 * @return void 返回类型
	 * @param @param result 消息返回值
	 * @param @param locMsgId 本地数据库id
	 * @author donglizhi
	 * @throws
	 */
	private void updateVoiceImgMsg(String result, int locMsgId) {
		ChatItem ci = helper.querySingleChatRecord(locMsgId);
		if (Util.isBlankString(result)) {
			// 发送信息出错，进行数据发送失败更新
			ci.setBoxType(2);// 设置该封信件为发送信件
			ci.setChatType(chatType);
			if (chatType == 0) {
				ci.setContactId(chatUid);
			} else if (chatType == 1) {
				ci.setGroupId(groupId + "");
			}
			int sendMsgStatue = ChatConstant.MSG_SYNCHRONIZE_FAILED;
			ci.setStatus(sendMsgStatue);// 设置发送失败
			helper.updateChatRecord(ci);// 更新信件状态
			// 更新最后一条聊天信息记录
			helper.updateLastMessage(ci.getContactId(), ci.getContent(), sendMsgStatue, ci.getTimeStamp(), ci.getChatType(),
					ci.getGroupId());
		} else {
			try {
				JSONObject resultJsonObject = new JSONObject(result);
				int retcode = resultJsonObject.optInt(JsonParser.RESPONSE_RETCODE);
				String retmean = JsonUtil.getJsonString(resultJsonObject, JsonParser.RESPONSE_RETMEAN);
				JSONObject getData = JsonUtil.getJsonObject(resultJsonObject, JsonParser.RESPONSE_DATA);
				int status = getData.optInt(UtilRequest.FORM_STATUS);
				if (status == 1 && retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(retmean)) {
					// 发送成功
					if (getData.has(UtilRequest.FORM_TIME)) {
						ci.setTimeStamp(getData.optString(UtilRequest.FORM_TIME) + UtilRequest.TIMESTAMP_000);// 设置发信时间戳
					}
					int sendMsgStatue = ChatConstant.MSG_SYNCHRONIZE_SUCCESS;
					String msgid = JsonUtil.getJsonString(getData, UtilRequest.FORM_IID);// 信息id
					ci.setStatus(sendMsgStatue);// 设置发送成功
					if (!Util.isBlankString(msgid)) {
						ci.setMsgId(msgid);
					}
					JSONObject extObject = JsonUtil.getJsonObject(getData, UtilRequest.FORM_EXT);
					if (chatType == 1 && extObject != null && extObject.has(UtilRequest.FORM_UID)) {
						ci.setContactId(extObject.optString(UtilRequest.FORM_UID));
					}
					if (ci.getMimeType().equals(ChatConstant.MIME_TYPE_AUIDO_AMR)) {
						// 语音上传结果
						if (extObject != null && extObject.has(UtilRequest.FORM_VOICE)) {
							String voiceName = extObject.optString(UtilRequest.FORM_VOICE);// 获已经上传成功的语音url地址，进行地址名称更换
							fs.renameFile(ci.getFileName(), voiceName, null);// 对文件进行重命名
							ci.setFileName(voiceName);
						}
					} else if (ci.getMimeType().equals(ChatConstant.MIME_TYPE_IMAGE_JPEG)) {
						// 图片上传结果
						if (extObject != null && extObject.has(UtilRequest.FORM_PIC_0)) {
							String imageName = extObject.optString(UtilRequest.FORM_PIC_0);
							// String imageNameThumb =
							// extObject.optString(UtilRequest.FORM_PIC_150);
							// fs.renameFile(ci.getFileName(), imageName, "");
							ci.setFileName(imageName);
							// ci.setFileNameThumb(imageNameThumb);
						}
						ci.setPercent(-1);
					}
					helper.updateChatRecord(ci);// 更新信件状态
					// 更新最后一条聊天信息记录
					helper.updateLastMessage(ci.getContactId(), ci.getContent(), sendMsgStatue, ci.getTimeStamp(),
							ci.getChatType(), ci.getGroupId());

				} else {
					if (status != 6 && chatType == 0) {
						showChatFailToast(status);
					}
					// 设置发信状态
					ci.setStatus(ChatConstant.MSG_SYNCHRONIZE_FAILED);
					helper.updateChatRecord(ci);// 更新信件状态
					// 更新最后一条聊天信息
					helper.updateLastMessage(ci.getContactId(), ci.getContent(), ChatConstant.MSG_SYNCHRONIZE_FAILED,
							ci.getTimeStamp(), ci.getChatType(), ci.getGroupId());
				}
			} catch (JSONException e1) {
				e1.printStackTrace();
				// 发送信息出错，进行数据发送失败更新
				ci.setBoxType(2);// 设置该封信件为发送信件
				ci.setContactId(chatUid);
				int sendMsgStatue = ChatConstant.MSG_SYNCHRONIZE_FAILED;
				ci.setStatus(sendMsgStatue);// 设置发送失败
				helper.updateChatRecord(ci);// 更新信件状态
				// 更新最后一条聊天信息记录
				helper.updateLastMessage(ci.getContactId(), ci.getContent(), sendMsgStatue, ci.getTimeStamp(), ci.getChatType(),
						ci.getGroupId());
			} catch (NullPointerException e) {
				e.printStackTrace();
				// 发送信息出错，进行数据发送失败更新
				ci.setBoxType(2);// 设置该封信件为发送信件
				ci.setContactId(chatUid);
				int sendMsgStatue = ChatConstant.MSG_SYNCHRONIZE_FAILED;
				ci.setStatus(sendMsgStatue);// 设置发送失败
				helper.updateChatRecord(ci);// 更新信件状态
				// 更新最后一条聊天信息记录
				helper.updateLastMessage(ci.getContactId(), ci.getContent(), sendMsgStatue, ci.getTimeStamp(), ci.getChatType(),
						ci.getGroupId());
			}
		}
		for (int i = 0; i < currentItems.size(); i++) {
			if (currentItems.get(i).getId() == locMsgId) {
				currentItems.set(i, ci);
				break;
			}
		}
		chatListAdapter.notifyDataSetChanged();
	}

	/**
	 * @Title: updateHitoryUserChatList
	 * @Description: 更新历史消息
	 * @return void 返回类型
	 * @param @param obj 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void updateHitoryUserChatList(Object obj) {
		if (obj != null) {
			J_Response listResponse = (J_Response) obj;
			if (listResponse.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(listResponse.retmean)) {
				try {
					JSONArray jArray = new JSONArray(listResponse.data);
					if (jArray.length() > 0) {// 存在聊天记录
						for (int i = 0; i < jArray.length(); i++) {
							JSONObject finalData = jArray.getJSONObject(i);
							ChatItem ci = new ChatItem();
							String msg_id = JsonUtil.getJsonString(finalData, UtilRequest.FORM_IID);
							String contact_uid = "";
							String groupId = "";
							if (finalData.has(UtilRequest.FORM_GROUP_ID)) {
								groupId = JsonUtil.getJsonString(finalData, UtilRequest.FORM_GROUP_ID);
								String groupUserUid = JsonUtil.getJsonString(finalData, UtilRequest.FORM_UID);
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
								int boxBype = finalData.optInt(UtilRequest.FORM_TYPE);
								ci.setBoxType(boxBype);
							}
							String ctime = JsonUtil.getJsonString(finalData, UtilRequest.FORM_SEND_TIME);
							// 消息类型0 单聊普通聊天 1 群聊普通聊天 2 单聊上传声音 3 单聊上传图片 4 群聊上传声音
							// 5 群聊上传图片
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
							} else {
								continue;
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
						// 记录加载完毕后，还是通过本地来加载数据
						loadPreviousRecord();
						return;
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		}
		noMoreData();
	}

	/**
	 * 从本地删除一条聊天记录，并更新联系人的最后一条聊天记录
	 * 
	 * */
	public void deleteLocalMsg(String id, int delMsgPosition) {
		// 从数据库中删除
		helper.deleteMsgById(id);
		// 更新最后一条聊天记录
		ChatItem ci = helper.queryLChatRecord(chatUid, groupId + "", chatType);
		if (ci != null) {
			helper.updateLastMessage(ci.getContactId(), ci.getContent(), ChatConstant.MSG_SYNCHRONIZE_SUCCESS, ci.getTimeStamp(),
					ci.getChatType(), ci.getGroupId());
		} else {
			// 删除该用户
			helper.deleteContact(chatUid, groupId + "", chatType);
		}
		// 从当前列表记录中删除
		currentItems.remove(delMsgPosition);

		// 刷新页面
		chatListAdapter.notifyDataSetChanged();
	}

	/**
	 * 按下返回键的处理
	 * 
	 * */
	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			boolean isFaceLayerShown = faceRelativeLayout.getFaceLayerShowStatus();
			if (isFaceLayerShown) {
				faceRelativeLayout.hideFaceView();
				return true;
			} else {
				mHandler.sendEmptyMessage(R.id.hide_keyboard);
				if (!Util.isRunning(mContext)) {
					Intent intent = new Intent(mContext, MainBoxActivity.class);
					startActivity(intent);
				}
				finish();
				return true;
			}
		} else {
			return super.onKeyDown(keyCode, event);
		}
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		unregisterReceiver(mReceiver);
		voiceHandler.removeCallbacksAndMessages(null);
		if (mSoundMeter != null) {
			mSoundMeter.stop();
		}
		// 关闭语音
		if (chatListAdapter != null) {
			chatListAdapter.clear();
		}
		// the current user
		if (current != null) {
			current = null;
		}
		// the current user's chat items
		if (currentItems != null) {
			currentItems.clear();
		}
		if (faceRelativeLayout != null) {
			faceRelativeLayout = null;
		}
	}

	/**
	 * @Title: showChatFailToast
	 * @Description: 消息错误提示
	 * @return void 返回类型
	 * @param @param status 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void showChatFailToast(int status) {
		String failText = "";
		switch (status) {
		case 2:
			if (chatType == 0) {
				failText = "该账号已经被管理员加黑";
			} else if (chatType == 1) {
				failText = "内容含有敏感词";
			}
			break;
		case 5:
			failText = "您已将对方加入黑名单，请取消加黑后发送";
			break;
		case 6:
			failText = "内容含有敏感词";
			break;
		}
		if (!Util.isBlankString(failText)) {
			ToastUtil.showToast(mContext, failText);
		}
	}

	/**
	 * @Title: showChatHelpDialog
	 * @Description: 长按提示对话框
	 * @return void 返回类型
	 * @param @param position 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void showChatHelpDialog(final int position, int type) {
		ChatHelpDialog dialog = new ChatHelpDialog(mContext, R.style.dialog, type);
		dialog.setCallBack(new OnSelectCallBack() {

			@Override
			public void onCallBack(String value1, String value2, String value3) {
				if (value1.equals("1")) {
					ChatItem item = currentItems.get(position);
					Util.copy(mContext, item.getContent());
				} else if (value1.equals("2")) {// 切换声音模式
					int setVoiceSwitch = 0;
					if (voiceMode == 0) {
						setVoiceSwitch = 1;
					} else {
						setVoiceSwitch = 0;
					}
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					UtilRequest.setVoiceSwicth(mHandler, mContext, setVoiceSwitch);
				}
			}
		});
		dialog.show();
	}

}
