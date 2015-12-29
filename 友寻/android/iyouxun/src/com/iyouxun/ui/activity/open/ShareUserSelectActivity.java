package com.iyouxun.ui.activity.open;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.database.Cursor;
import android.os.Handler;
import android.os.Message;
import android.os.Parcelable;
import android.support.v4.view.PagerAdapter;
import android.support.v4.view.ViewPager;
import android.support.v4.view.ViewPager.OnPageChangeListener;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.TextView;

import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.iyouxun.R;
import com.iyouxun.comparator.PinyinComparator;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.SortInfoBean;
import com.iyouxun.data.beans.shareFriendsInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.chat.ChatConstant;
import com.iyouxun.data.chat.ChatContactRepository;
import com.iyouxun.data.chat.ChatDBHelper;
import com.iyouxun.data.chat.ChatItem;
import com.iyouxun.data.chat.ChatListItem;
import com.iyouxun.data.parser.CharacterParser;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.net.response.SendGroupMsgResonse;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.ShareUserListAdapter;
import com.iyouxun.ui.views.SideBar;
import com.iyouxun.ui.views.SideBar.OnTouchingLetterChangedListener;
import com.iyouxun.utils.JsonUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 分享应用内好友（群组）选择页面
 * 
 * @ClassName: ShareUserSelectActivity
 * @author likai
 * @date 2015-4-8 下午4:31:44
 * 
 */
public class ShareUserSelectActivity extends CommTitleActivity {
	private Button shareMyFriendButton;// 共同好友
	private Button shareMyGroupButton;// 对方的好友
	private ViewPager share_user_viewPager;
	private PullToRefreshListView shareUserListView;// 好友列表
	private PullToRefreshListView shareUserGroupListView;// 群组列表

	// 分享发送的内容
	protected shareFriendsInfoBean shareInfo = new shareFriendsInfoBean();

	private UserPagerAdapter userPagerAdapter;
	/** 汉字转换成拼音的类 */
	private CharacterParser characterParser;
	/** 根据拼音来排列ListView里面的数据类 */
	private PinyinComparator pinyinComparator;
	private SideBar sideBar1;
	private SideBar sideBar2;
	// viewpager
	private final ArrayList<View> mViews = new ArrayList<View>();// 用来存放下方滚动的layout
	private View eachViewPager1;
	private View eachViewPager2;
	// listview列表adapter
	private ShareUserListAdapter adapter1;
	private ShareUserListAdapter adapter2;
	// 空数据提示信息
	private TextView emptyTv1;
	private TextView emptyTv2;

	private final ArrayList<SortInfoBean> datas1 = new ArrayList<SortInfoBean>();
	private final ArrayList<SortInfoBean> datas2 = new ArrayList<SortInfoBean>();

	/** 标记群组列表页面是否已经加载 */
	private boolean isGroupViewShown = false;
	/** 好友数量-需要加载的数量 */
	private int pageSize = 100;

	/** 已经选择的需要分享的用户 */
	private final ArrayList<SortInfoBean> selectShareInfo = new ArrayList<SortInfoBean>();

	private ChatDBHelper helper;
	private ChatListItem current;// 对方的资料
	private ChatItem groupChatItem;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("分享好友");
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);

		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_share_user_select, null);
	}

	@Override
	protected void initViews() {
		shareInfo = (shareFriendsInfoBean) getIntent().getSerializableExtra("shareInfo");

		helper = ChatContactRepository.getDBHelperInstance();

		shareMyFriendButton = (Button) findViewById(R.id.shareMyFriendButton);
		shareMyGroupButton = (Button) findViewById(R.id.shareMyGroupButton);
		share_user_viewPager = (ViewPager) findViewById(R.id.share_user_viewPager);

		// 实例化汉字转拼音类
		characterParser = CharacterParser.getInstance();
		pinyinComparator = new PinyinComparator();

		// 设置连个要显示的pager
		eachViewPager1 = View.inflate(mContext, R.layout.share_user_select_pageview, null);
		eachViewPager2 = View.inflate(mContext, R.layout.share_user_select_pageview, null);
		mViews.add(eachViewPager1);
		mViews.add(eachViewPager2);

		// 设置每个pager页面中的listview--我的好友列表
		shareUserListView = (PullToRefreshListView) eachViewPager1.findViewById(R.id.shareUserPageviewListview);
		shareUserListView.setMode(Mode.DISABLED);
		sideBar1 = (SideBar) eachViewPager1.findViewById(R.id.sidebar);
		adapter1 = new ShareUserListAdapter(mContext);
		adapter1.setData(datas1);
		shareUserListView.setAdapter(adapter1);
		// 分享给好友
		shareUserListView.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				// 限制最多选择10个用户
				if (selectShareInfo.size() >= 10) {
					ToastUtil.showToast(mContext, "每次最多选择10个");
					return;
				}
				int realPosition = position - 1;
				realPosition = realPosition < 0 ? 0 : realPosition;
				SortInfoBean bean = datas1.get(realPosition);
				if (bean.isChecked) {
					bean.isChecked = false;
					// 未选中，删除
					for (int i = 0; i < selectShareInfo.size(); i++) {
						if (selectShareInfo.get(i).uid == bean.uid) {
							selectShareInfo.remove(i);
						}
					}
					selectShareInfo.remove(bean);
				} else {
					bean.isChecked = true;
					// 选中，添加
					selectShareInfo.add(bean);
				}
				datas1.set(realPosition, bean);
				adapter1.notifyDataSetChanged();

				refreshHeaderInfo();
			}
		});
		sideBar1.setOnTouchingLetterChangedListener(new OnTouchingLetterChangedListener() {
			@Override
			public void onTouchingLetterChanged(String s) {
				// 该字母首次出现的位置
				int position = adapter1.getPositionForSection(s.charAt(0));
				if (position != -1) {
					shareUserListView.getRefreshableView().setSelection(position);
				}
			}
		});
		// 我的群组列表
		shareUserGroupListView = (PullToRefreshListView) eachViewPager2.findViewById(R.id.shareUserPageviewListview);
		shareUserGroupListView.setMode(Mode.DISABLED);
		sideBar2 = (SideBar) eachViewPager2.findViewById(R.id.sidebar);
		adapter2 = new ShareUserListAdapter(mContext);
		adapter2.setData(datas2);
		shareUserGroupListView.setAdapter(adapter2);
		// 分享给群组
		shareUserGroupListView.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				// 限制最多选择10个用户
				if (selectShareInfo.size() >= 10) {
					ToastUtil.showToast(mContext, "每次最多选择10个");
					return;
				}
				int realPosition = position - 1;
				realPosition = realPosition < 0 ? 0 : realPosition;
				SortInfoBean bean = datas2.get(realPosition);
				if (bean.isChecked) {
					bean.isChecked = false;
					// 未选中，删除
					for (int i = 0; i < selectShareInfo.size(); i++) {
						if (selectShareInfo.get(i).uid == bean.uid) {
							selectShareInfo.remove(i);
						}
					}
					selectShareInfo.remove(bean);
				} else {
					bean.isChecked = true;
					// 选中，添加
					selectShareInfo.add(bean);
				}
				datas2.set(realPosition, bean);
				adapter2.notifyDataSetChanged();

				refreshHeaderInfo();
			}
		});
		sideBar2.setOnTouchingLetterChangedListener(new OnTouchingLetterChangedListener() {
			@Override
			public void onTouchingLetterChanged(String s) {
				// 该字母首次出现的位置
				int position = adapter2.getPositionForSection(s.charAt(0));
				if (position != -1) {
					shareUserGroupListView.getRefreshableView().setSelection(position);
				}
			}
		});

		// viewpager设置
		userPagerAdapter = new UserPagerAdapter();
		share_user_viewPager.setAdapter(userPagerAdapter);
		share_user_viewPager.setCurrentItem(0, true);
		shareMyFriendButton.setEnabled(false);
		shareMyGroupButton.setEnabled(true);
		share_user_viewPager.setOnPageChangeListener(new MyPagerOnPageChangeListener());

		// 空数据展示
		View view1 = View.inflate(mContext, R.layout.empty_layer, null);
		emptyTv1 = (TextView) view1.findViewById(R.id.emptyTv);
		emptyTv1.setText("没有好友");
		shareUserListView.setEmptyView(emptyTv1);
		View view2 = View.inflate(mContext, R.layout.empty_layer, null);
		emptyTv2 = (TextView) view2.findViewById(R.id.emptyTv);
		emptyTv2.setText("没有群组信息");
		shareUserGroupListView.setEmptyView(emptyTv2);

		// 切换按钮的点击事件
		shareMyFriendButton.setOnClickListener(listener);
		shareMyGroupButton.setOnClickListener(listener);

		// 进入页面，首先加载我的好友列表
		getUserNum();
	}

	/**
	 * 刷新header标题信息
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void refreshHeaderInfo() {
		int selectNum = selectShareInfo.size();
		if (selectNum > 0) {
			titleRightButton.setVisibility(View.VISIBLE);
			titleRightButton.setText("分享(" + selectNum + ")");
		} else {
			titleRightButton.setVisibility(View.INVISIBLE);
			titleRightButton.setText("分享");
		}
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.shareMyFriendButton:
				// 我的好友
				share_user_viewPager.setCurrentItem(0, true);
				break;
			case R.id.shareMyGroupButton:
				// 我的群组
				share_user_viewPager.setCurrentItem(1, true);
				break;
			case R.id.titleRightButton:
				// 执行分享
				showLoading("消息发送中...");
				toShare();
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 执行分享
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void toShare() {
		if (selectShareInfo.size() <= 0) {
			// 不存在数据，关闭页面
			ToastUtil.showToast(mContext, "分享成功");
			dismissLoading();
			finish();
		}

		if (share_user_viewPager.getCurrentItem() == 0) {
			try {
				SortInfoBean bean = selectShareInfo.get(0);
				if (shareInfo.shareType == 3 && !Util.isBlankString(shareInfo.imagePath)) {
					// 发送图片
					UtilRequest.sendPicMsg(shareInfo.imagePath, mHandler, bean.uid + "", -1);
				} else {
					// 发送文字
					JSONObject form = new JSONObject();
					form.put("content", shareInfo.content);
					form.put("touid", bean.uid);
					UtilRequest.sendTextMsg(mContext, mHandler, form.toString(), -1L);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
			// 我的群组
			try {
				SortInfoBean bean = selectShareInfo.get(0);

				ChatListItem groupInfo = new ChatListItem();
				groupInfo.userIconUrl = bean.avatar;
				groupInfo.nickName = bean.name;
				groupInfo.chatType = 1;
				groupInfo.groupId = bean.uid + "";
				current = groupInfo;

				showLoading("消息发送中...");
				if (shareInfo.shareType == 3 && !Util.isBlankString(shareInfo.imagePath)) {
					groupChatItem = new ChatItem();
					groupChatItem.setBoxType(2);// 发送方标记
					groupChatItem.setTimeStamp(String.valueOf(System.currentTimeMillis()));
					// 发送时间
					groupChatItem.setContactId(J_Cache.sLoginUser.uid + "");
					// 聊天对方uid
					groupChatItem.setMimeType(ChatConstant.MIME_TYPE_IMAGE_JPEG);
					// 标记发送类型为文字信息
					groupChatItem.setStatus(ChatConstant.MSG_SYNCHRONIZE_SUCCESS);
					// 默认发送状态：发送中
					groupChatItem.setIsAck(0);// 设置为未读状态0：未读，1：已读
					groupChatItem.setFileName(shareInfo.imagePath);
					groupChatItem.setFileNameThumb(shareInfo.imagePath);
					groupChatItem.setContent(getString(R.string.image_msg));
					groupChatItem.setPercent(0);
					groupChatItem.setChatType(1);// 0普通消息，1群组消息
					groupChatItem.setGroupId(bean.uid + "");

					// 存在图片,调用发送图片接口
					UtilRequest.sendPicGroupMsg(shareInfo.imagePath, mHandler, bean.uid + "", -1);
				} else {
					groupChatItem = new ChatItem();
					groupChatItem.setContent(shareInfo.content);
					groupChatItem.setBoxType(2);
					groupChatItem.setTimeStamp(String.valueOf(System.currentTimeMillis()));
					groupChatItem.setContactId(J_Cache.sLoginUser.uid + "");
					groupChatItem.setMimeType(ChatConstant.MIME_TYPE_TEXT_PLAIN);
					// 标记发送类型为文字信息
					groupChatItem.setStatus(ChatConstant.MSG_SYNCHRONIZE_SUCCESS);
					// 默认发送状态：发送中
					groupChatItem.setMsgId("0");
					groupChatItem.setId(0);
					groupChatItem.setGroupId(bean.uid + "");
					groupChatItem.setChatType(1);// 0普通消息，1群组消息
					long keyId = helper.addChatRecord(groupChatItem);// 添加本次聊天记录
					groupChatItem.setId((int) keyId);
					updateChatFriendsData(groupChatItem, ChatConstant.MSG_SYNCHRONIZING, System.currentTimeMillis() + "");

					// 调用发送文字接口
					JSONObject form = new JSONObject();
					form.put("content", shareInfo.content);
					form.put("group_id", bean.uid);
					UtilRequest.sendGroupMsg(mContext, mHandler, form.toString(), -1L);
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_SEND_TEXT_MSG:
				// 发送分享好友的文字消息
				// 继续分享下一个
				if (selectShareInfo.size() > 0) {
					selectShareInfo.remove(0);
				}
				toShare();
				break;
			case NetTaskIDs.TASKID_SEND_GROUP_MSG:
				// 发送群组好友消息
				// {"retcode":1,"retmean":"CMI_AJAX_RET_CODE_SUCC","data":{"iid":8760,"group_id":6060,"time":1432817981,"sendtime":"2015-05-28 20:59:41","status":1,"msgtype":1}}
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
						} else {
							// 发送失败
							updateTextMsg(textResponse.chat_table_id, ChatConstant.MSG_SYNCHRONIZE_FAILED, null, null);
						}
					}
				}
				// 继续分享下一个
				if (selectShareInfo.size() > 0) {
					selectShareInfo.remove(0);
				}
				toShare();
				break;
			case NetTaskIDs.TASKID_SEND_PIC_MSG:
				// 发送好友图片消息
				// 继续分享下一个
				if (selectShareInfo.size() > 0) {
					selectShareInfo.remove(0);
				}
				toShare();
				break;
			case NetTaskIDs.TASKID_SEND_PIC_GROUP_MSG:
				// 发送群组图片消息
				String resultPic = (String) msg.obj;
				try {
					JSONObject resultJsonObject = new JSONObject(resultPic);
					int retcode = resultJsonObject.optInt(JsonParser.RESPONSE_RETCODE);
					String retmean = JsonUtil.getJsonString(resultJsonObject, JsonParser.RESPONSE_RETMEAN);
					JSONObject getData = JsonUtil.getJsonObject(resultJsonObject, JsonParser.RESPONSE_DATA);
					int status = getData.optInt(UtilRequest.FORM_STATUS);
					if (status == 1 && retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(retmean)) {
						// 发送成功
						JSONObject extObject = JsonUtil.getJsonObject(getData, UtilRequest.FORM_EXT);
						if (extObject != null && extObject.has(UtilRequest.FORM_PIC_0)) {
							String imageName = extObject.optString(UtilRequest.FORM_PIC_0);
							groupChatItem.setFileName(imageName);
							groupChatItem.setFileNameThumb(imageName);
							// 设置图片宽高
							int[] widthHeight = Util.getWidthHeight(imageName);
							int originalWidth = widthHeight[0];
							int originalHeight = widthHeight[1];
							groupChatItem.setThumbImageWidth(originalWidth);
							groupChatItem.setThumbImageHeight(originalHeight);
							helper.addChatRecord(groupChatItem);// 添加本次聊天记录
							updateChatFriendsData(groupChatItem, ChatConstant.MSG_SYNCHRONIZE_SUCCESS, System.currentTimeMillis()
									+ "");
						}
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				// 继续分享下一个
				if (selectShareInfo.size() > 0) {
					selectShareInfo.remove(0);
				}
				toShare();
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_FRIENDS_NUMS:
				// 获取我的好友数量
				if (msg.obj != null) {
					pageSize = Util.getInteger(msg.obj.toString());
					if (pageSize > 0) {
						getUserList();
						return;
					}
				}
				// 获取信息失败
				dismissLoading();
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_MY_FRIENDS:
				// 获取我的好友列表
				try {
					// 好友姓名列表
					JSONObject friendsObj = new JSONObject(msg.obj.toString());
					Iterator iterator = friendsObj.keys();
					while (iterator.hasNext()) {
						String key = (String) iterator.next();
						JSONObject singleFriend = friendsObj.optJSONObject(key);

						SortInfoBean user = new SortInfoBean();
						user.uid = singleFriend.optLong("uid");
						user.name = singleFriend.optString("nick");
						if (Util.isBlankString(user.name)) {
							continue;
						}
						String avatars = singleFriend.optString("avatars");
						if (!Util.isBlankString(avatars)) {
							JSONObject avatarObj = singleFriend.optJSONObject("avatars");
							if (avatarObj.has("200")) {
								user.avatar = avatarObj.optString("200");
							}
						}
						user.marriage = singleFriend.optInt("marriage");
						user.friendDimen = 1;// 共同好友都是1度好友
						user.sameFriendsNum = singleFriend.optInt("mutualnums");// 共同好友的数量
						user.sex = singleFriend.optInt("sex");
						user.type = 0;
						datas1.add(user);
					}
					// 刷新页面数据
					setContent();
				} catch (Exception e) {
					e.printStackTrace();
				}
				dismissLoading();
				break;
			case NetTaskIDs.TASKID_GROUP_LIST:
				// 获取我的群组列表
				try {
					String groupInfo = msg.obj.toString();
					if (!Util.isBlankString(groupInfo)) {
						JSONArray groupArray = new JSONArray(msg.obj.toString());
						for (int i = 0; i < groupArray.length(); i++) {
							JSONObject groupOjb = groupArray.optJSONObject(i);
							SortInfoBean user = new SortInfoBean();
							user.avatar = groupOjb.optString("logo");
							user.uid = groupOjb.optLong("group_id");
							user.name = groupOjb.optString("title");
							user.type = 1;
							datas2.add(user);
						}
					}

					// 刷新页面数据
					if (datas2.size() > 0) {
						setContent();
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				dismissLoading();
				break;
			default:
				break;
			}
		}
	};

	/**
	 * @Description: 本地添加用户数据
	 * @return void 返回类型
	 * @param @param ci 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void updateChatFriendsData(ChatItem ci, int status, String time) {
		// 从本地数据库中获取当前用户信息
		Cursor cursor = helper.queryContactById(ci.getContactId(), ci.getGroupId() + "", 1);
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
		groupChatItem.setStatus(status);
		if (!Util.isBlankString(msgId)) {
			groupChatItem.setMsgId(msgId);
		}
		if (!Util.isBlankString(time)) {
			groupChatItem.setTimeStamp(time);
		}
		helper.updateChatRecord(groupChatItem);
		helper.updateLastMessage(groupChatItem.getContactId(), groupChatItem.getContent(), groupChatItem.getStatus(),
				groupChatItem.getTimeStamp(), groupChatItem.getChatType(), groupChatItem.getGroupId());
	}

	/**
	 * 刷新页面数据
	 * 
	 * @Title: setContent
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setContent() {
		if (share_user_viewPager.getCurrentItem() == 0) {
			for (int i = 0; i < datas1.size(); i++) {
				SortInfoBean sortModel = datas1.get(i);
				// 汉字转换成拼音
				String pinyin = characterParser.getSelling(sortModel.name);
				String sortString = pinyin.substring(0, 1).toUpperCase();

				// 正则表达式，判断首字母是否是英文字母
				if (sortString.matches("[A-Z]")) {
					sortModel.sortLetter = sortString.toUpperCase();
				} else {
					sortModel.sortLetter = "#";
				}
				datas1.set(i, sortModel);
			}

			// 根据a-z进行排序源数据
			Collections.sort(datas1, pinyinComparator);

			adapter1.setData(datas1);
			adapter1.notifyDataSetChanged();
		} else {
			for (int i = 0; i < datas2.size(); i++) {
				SortInfoBean sortModel = datas2.get(i);
				// 汉字转换成拼音
				String pinyin = characterParser.getSelling(sortModel.name);
				String sortString = pinyin.substring(0, 1).toUpperCase();

				// 正则表达式，判断首字母是否是英文字母
				if (sortString.matches("[A-Z]")) {
					sortModel.sortLetter = sortString.toUpperCase();
				} else {
					sortModel.sortLetter = "#";
				}
				datas2.set(i, sortModel);
			}

			// 根据a-z进行排序源数据
			Collections.sort(datas2, pinyinComparator);

			adapter2.setData(datas2);
			adapter2.notifyDataSetChanged();
		}
	}

	/**
	 * 获取用户好友数量
	 * 
	 * @Title: getUserNum
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getUserNum() {
		showLoading();

		UtilRequest.getFriendsNums(J_Cache.sLoginUser.uid + "", 1, 1, mHandler, mContext);
	}

	/**
	 * 获取用户好友列表
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getUserList() {
		UtilRequest.getFriends(J_Cache.sLoginUser.uid + "", 1, 0, pageSize, mHandler, mContext);
	}

	/**
	 * 获取用户群组列表
	 * 
	 * @Title: getGroupList
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getGroupList() {
		showLoading();
		UtilRequest.getGroupList(J_Cache.sLoginUser.uid + "", mHandler, mContext);
	}

	/**
	 * ViewPager的适配器
	 * 
	 * @author likai
	 */
	private class UserPagerAdapter extends PagerAdapter {
		@Override
		public void destroyItem(View v, int position, Object obj) {
			((ViewPager) v).removeView(mViews.get(position));
		}

		@Override
		public void finishUpdate(View arg0) {
		}

		@Override
		public int getCount() {
			return mViews.size();
		}

		@Override
		public Object instantiateItem(View v, int position) {
			((ViewPager) v).addView(mViews.get(position));
			return mViews.get(position);
		}

		@Override
		public boolean isViewFromObject(View arg0, Object arg1) {
			return arg0 == arg1;
		}

		@Override
		public void restoreState(Parcelable arg0, ClassLoader arg1) {
		}

		@Override
		public Parcelable saveState() {
			return null;
		}

		@Override
		public void startUpdate(View arg0) {
		}
	}

	/**
	 * ViewPager的PageChangeListener(页面改变的监听器)
	 * 
	 * @author likai
	 */
	private class MyPagerOnPageChangeListener implements OnPageChangeListener {
		@Override
		public void onPageScrollStateChanged(int arg0) {
		}

		@Override
		public void onPageScrolled(int arg0, float arg1, int arg2) {
		}

		/**
		 * 滑动ViewPager的时候,让上方的HorizontalScrollView自动切换
		 * 
		 */
		@Override
		public void onPageSelected(int position) {
			if (position == 0) {// 我的好友
				shareMyFriendButton.setEnabled(false);
				shareMyGroupButton.setEnabled(true);
			} else if (position == 1) {// 我的群组
				shareMyFriendButton.setEnabled(true);
				shareMyGroupButton.setEnabled(false);
				if (!isGroupViewShown) {
					isGroupViewShown = true;
					getGroupList();// 首次加载该页面，需要请求数据
				}
			}
			// 重新选择列表的时候，重置列表信息
			resetSelect();
		}
	}

	/**
	 * 重置列表
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void resetSelect() {
		// 清空选择项
		selectShareInfo.clear();
		// 重置用户列表
		for (int i = 0; i < datas1.size(); i++) {
			SortInfoBean beanUser = datas1.get(i);
			beanUser.isChecked = false;
			datas1.set(i, beanUser);
		}
		adapter1.setData(datas1);
		adapter1.notifyDataSetChanged();
		// 重置群组列表
		for (int j = 0; j < datas2.size(); j++) {
			SortInfoBean beanGroup = datas2.get(j);
			beanGroup.isChecked = false;
			datas2.set(j, beanGroup);
		}
		adapter2.setData(datas2);
		adapter2.notifyDataSetChanged();
		// 重置header
		refreshHeaderInfo();
	}

	/**
	 * @Title: showChatFailToast
	 * @Description: 消息错误提示
	 * @return void 返回类型
	 * @param status 参数类型
	 * @param chatType // 聊天类型0普通消息1群组消息
	 * @author donglizhi
	 * @throws
	 */
	private void showChatFailToast(int status, int chatType) {
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
	 * 发送图片消息提醒
	 * 
	 * @return void 返回类型
	 * @param @param result
	 * @param @param chatType 参数类型
	 * @author likai
	 * @throws
	 */
	private void showChatPicFailToast(String result, int chatType) {
		if (Util.isBlankString(result)) {
			ToastUtil.showToast(mContext, "发送异常");
		} else {
			try {
				JSONObject resultJsonObject = new JSONObject(result);
				int retcode = resultJsonObject.optInt(JsonParser.RESPONSE_RETCODE);
				String retmean = JsonUtil.getJsonString(resultJsonObject, JsonParser.RESPONSE_RETMEAN);
				JSONObject getData = JsonUtil.getJsonObject(resultJsonObject, JsonParser.RESPONSE_DATA);
				int status = getData.optInt(UtilRequest.FORM_STATUS);
				if (status == 1 && retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(retmean)) {
					// 发送成功
					ToastUtil.showToast(mContext, "发送成功");
				} else {
					if (status != 6 && chatType == 0) {
						showChatFailToast(status, chatType);
					} else {
						ToastUtil.showToast(mContext, "发送失败");
					}
				}
			} catch (JSONException e1) {
				ToastUtil.showToast(mContext, "发送失败");
				e1.printStackTrace();
			}
		}
	}
}
