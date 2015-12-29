package com.iyouxun.ui.activity.center;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.text.Html;
import android.text.SpannableString;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.style.ForegroundColorSpan;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.sina.weibo.SinaWeibo;

import com.iyouxun.R;
import com.iyouxun.comparator.PhotoComparator;
import com.iyouxun.comparator.TagListComparator;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.GroupsInfoBean;
import com.iyouxun.data.beans.NewsInfoBean;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.beans.TagsInfoBean;
import com.iyouxun.data.beans.users.BaseUser;
import com.iyouxun.data.beans.users.LoginUser;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.CanceLonelyConfirmRequest;
import com.iyouxun.net.request.GetUserInfoRequest;
import com.iyouxun.net.request.J_OnDataBack;
import com.iyouxun.net.request.UpdateUserLonlyConfirmRequest;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.net.response.UserInfoResponse;
import com.iyouxun.open.J_ShareParams;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.message.ChatMainActivity;
import com.iyouxun.ui.activity.news.NewsMainActivity;
import com.iyouxun.ui.dialog.AddTagDialog;
import com.iyouxun.ui.dialog.EditTextDialog;
import com.iyouxun.ui.dialog.ProfileMenuPopDialog;
import com.iyouxun.ui.dialog.ReportDialog;
import com.iyouxun.ui.dialog.SharePopDialog;
import com.iyouxun.ui.dialog.UploadContactsDialog;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.ui.views.DrawableCenterButton;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.DialogCallBack;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.NetworkUtil;
import com.iyouxun.utils.OpenPlatformUtil;
import com.iyouxun.utils.ProfileUtils;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.StringUtils;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 个人资料页面(浏览他人)
 * 
 * @ClassName: ProfileViewActivity
 * @author likai
 * @date 2015-3-2 下午4:56:33
 * 
 */
public class ProfileViewActivity extends CommTitleActivity {
	private TextView titleCenter;
	private long currentUid;
	private LoginUser currentUserInfo;

	private CircularImage profile_avatar;// 头像
	private ImageView profile_sex;// 性别
	private TextView profile_nick;// 昵称
	private TextView profile_marriage;// 婚姻状态
	private TextView profile_remark;// 备注
	private TextView profile_location;// 位置
	private TextView profile_birthday;// 生日
	private TextView profile_signer;// 签名
	private ImageButton profile_right_icon2;// 相册盒子
	private LinearLayout profile_album;// 相册包装
	private RelativeLayout profile_news_box;// 动态盒子
	private TextView profile_news_info;// 动态
	private LinearLayout profile_view_content_box;
	private TextView profile_view_birth;// 生日
	private RelativeLayout profile_view_birth_box;
	private TextView profile_view_height;// 身高
	private RelativeLayout profile_view_height_box;// 身高
	private TextView profile_view_weight;// 体重
	private RelativeLayout profile_view_weight_box;// 体重
	private TextView profile_view_job;// 工作
	private RelativeLayout profile_view_job_box;// 工作
	private TextView profile_view_company;// 公司
	private LinearLayout profile_tags;
	private LinearLayout profile_groups;
	private Button profile_chat_button;// 聊天按钮
	private Button profile_add_friend_button;// 加为好友
	private TextView profile_add_new_tag_button;// 添加新标签
	private TextView profile_same_friends;// 共同好友
	private ImageButton profile_tag_toggle;// 控制标签层收起显示的按钮
	private ImageView profile_friend_dimen_icon;// 1度2度好友的标记
	private TextView profile_view_icon5;// 学生和公司的标题
	private DrawableCenterButton profile_out_single_button;// 帮他脱单按钮
	private RelativeLayout profile_item_company_box;// 公司项
	private RelativeLayout profile_album_box;// 相册模块
	private RelativeLayout profileSameFriendBox;// 共同好友模块
	private Button titleRightButton;
	private TextView emptyTagView;// 空标签提示
	private RelativeLayout profile_view_address_box;// 常驻地模块
	private TextView profile_view_address;// 常驻地
	private ImageButton profile_group_toggle;
	private TextView profile_confirm_invite;
	private TextView profile_left_title1;
	private TextView profile_right_icon1;

	// 标签数据
	private final ArrayList<TagsInfoBean> tagsData = new ArrayList<TagsInfoBean>();
	/** 推荐标签数组 */
	private final ArrayList<TagsInfoBean> recommendTagsData = new ArrayList<TagsInfoBean>();
	// 标签视图数组
	private View[] textViews;
	// 共同好友
	private final ArrayList<BaseUser> sameFriends = new ArrayList<BaseUser>();// 孙悟空,猪八戒,唐僧
	private int sameFriendsCount = 0;
	/** 当前标签int[0]:标签总行数，int[1]:已经展示的行数 */
	private int showTagCell[] = { 0, 0 };
	/** 当前群组int[0]:群组总行数，int[1]:已经展示的行数 */
	private final int showGroupCell[] = { 0, 0 };
	/** 标记该用户是否已经添加黑名单 */
	private boolean isAddBlack = false;
	/** 标记该用户类型0：普通用户，1：推荐用户 */
	private int userType;
	/** 默认的标签数量 */
	private int defaultTagNum;
	/** 是否首次加载本页 */
	private boolean isFirstLoad = true;

	// 动态信息
	private NewsInfoBean currentUserNewsInfo = new NewsInfoBean();
	// 群组信息
	private final ArrayList<GroupsInfoBean> currentUserGroupsInfo = new ArrayList<GroupsInfoBean>();

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		// 顶部导航栏中间按钮
		this.titleCenter = titleCenter;
		// 顶部导航栏左侧按钮
		titleLeftButton.setVisibility(View.VISIBLE);
		// 顶部导航栏右侧按钮
		titleRightButton.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.icon_more, 0);
		titleRightButton.setCompoundDrawablePadding(getResources().getDimensionPixelSize(R.dimen.layout_topNav_space_between));
		titleRightButton.setVisibility(View.VISIBLE);
		titleRightButton.setOnClickListener(listener);

		this.titleRightButton = titleRightButton;
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_profile_view, null);
	}

	@Override
	protected void initViews() {
		// 获取uid
		currentUid = getIntent().getLongExtra("uid", 0);
		// 用户类型
		if (getIntent().hasExtra("userType")) {
			userType = getIntent().getIntExtra("userType", 0);
		}

		// 初始化页面组件
		profile_avatar = (CircularImage) findViewById(R.id.profile_avatar);
		profile_sex = (ImageView) findViewById(R.id.profile_sex);
		profile_nick = (TextView) findViewById(R.id.profile_nick);
		profile_remark = (TextView) findViewById(R.id.profile_remark);
		profile_location = (TextView) findViewById(R.id.profile_location);
		profile_birthday = (TextView) findViewById(R.id.profile_birthday);
		profile_marriage = (TextView) findViewById(R.id.profile_marriage);
		profile_signer = (TextView) findViewById(R.id.profile_signer);
		profile_right_icon2 = (ImageButton) findViewById(R.id.profile_right_icon2);
		profile_album = (LinearLayout) findViewById(R.id.profile_album);
		profile_news_box = (RelativeLayout) findViewById(R.id.profile_news_box);
		profile_news_info = (TextView) findViewById(R.id.profile_news_info);
		profile_view_content_box = (LinearLayout) findViewById(R.id.profile_view_content_box);
		profile_view_birth = (TextView) findViewById(R.id.profile_view_birth);
		profile_view_birth_box = (RelativeLayout) findViewById(R.id.profile_view_birth_box);
		profile_view_height = (TextView) findViewById(R.id.profile_view_height);
		profile_view_height_box = (RelativeLayout) findViewById(R.id.profile_view_height_box);
		profile_view_weight = (TextView) findViewById(R.id.profile_view_weight);
		profile_view_weight_box = (RelativeLayout) findViewById(R.id.profile_view_weight_box);
		profile_view_job = (TextView) findViewById(R.id.profile_view_job);
		profile_view_job_box = (RelativeLayout) findViewById(R.id.profile_view_job_box);
		profile_view_company = (TextView) findViewById(R.id.profile_view_company);
		profile_tags = (LinearLayout) findViewById(R.id.profile_tags);
		profile_groups = (LinearLayout) findViewById(R.id.profile_groups);
		profile_chat_button = (Button) findViewById(R.id.profile_chat_button);
		profile_add_friend_button = (Button) findViewById(R.id.profile_add_friend_button);
		profile_add_new_tag_button = (TextView) findViewById(R.id.profile_add_new_tag_button);
		profile_same_friends = (TextView) findViewById(R.id.profile_same_friends);
		profileSameFriendBox = (RelativeLayout) findViewById(R.id.profileSameFriendBox);
		profile_tag_toggle = (ImageButton) findViewById(R.id.profile_tag_toggle);
		profile_friend_dimen_icon = (ImageView) findViewById(R.id.profile_friend_dimen_icon);
		profile_view_icon5 = (TextView) findViewById(R.id.profile_view_icon5);
		profile_out_single_button = (DrawableCenterButton) findViewById(R.id.profile_out_single_button);
		profile_item_company_box = (RelativeLayout) findViewById(R.id.profile_item_company_box);
		profile_album_box = (RelativeLayout) findViewById(R.id.profile_album_box);
		emptyTagView = (TextView) findViewById(R.id.emptyTagView);
		profile_view_address_box = (RelativeLayout) findViewById(R.id.profile_view_address_box);
		profile_view_address = (TextView) findViewById(R.id.profile_view_address);
		profile_group_toggle = (ImageButton) findViewById(R.id.profile_group_toggle);
		profile_confirm_invite = (TextView) findViewById(R.id.profile_confirm_invite);
		profile_left_title1 = (TextView) findViewById(R.id.profile_left_title1);
		profile_right_icon1 = (TextView) findViewById(R.id.profile_right_icon1);

		profile_right_icon2.setOnClickListener(listener);
		profile_news_box.setOnClickListener(listener);
		profile_chat_button.setOnClickListener(listener);
		profile_add_friend_button.setOnClickListener(listener);
		profile_add_new_tag_button.setOnClickListener(listener);
		profileSameFriendBox.setOnClickListener(listener);
		profile_avatar.setOnClickListener(listener);
		profile_remark.setOnClickListener(listener);
		profile_tag_toggle.setOnClickListener(listener);
		profile_out_single_button.setOnClickListener(listener);
		profile_confirm_invite.setOnClickListener(listener);
		profile_group_toggle.setOnClickListener(listener);
		profile_left_title1.setOnClickListener(listener);
		profile_right_icon1.setOnClickListener(listener);

		// 读取缓存
		currentUserInfo = SharedPreUtil.getNormalUser(currentUid);
		if (currentUserInfo.uid > 0) {
			// 存在缓存
			setContent(true);
		} else {
			// 不存在缓存，提示加载中
			showLoading();
		}

		// 进入页面检查网络进行提示
		if (!NetworkUtil.checkNetwork(mContext)) {
			UtilRequest.showNetworkError(mContext);
		}

		// 获取推荐标签列表
		UtilRequest.getAlternativeTagList(mContext, mHandler);
	}

	/**
	 * 获取标签列表
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getTagsList() {
		UtilRequest.getTagsList(mContext, currentUid + "", mHandler);
	}

	@Override
	protected void onResume() {
		super.onResume();
		dismissLoading();

		// 获取最新一条动态
		getOneUserDynamicList();

		// 获取用户的群组列表
		getGroupList();

		// 更新图片信息
		getUserInfo();

		// 获取共同好友
		if (currentUid != J_Cache.sLoginUser.uid) {
			profileSameFriendBox.setVisibility(View.VISIBLE);
			getSameFriends();
		} else {
			profileSameFriendBox.setVisibility(View.GONE);
		}
	}

	/**
	 * 获取用户加入的群组列表
	 * 
	 * @Title: getGroupList
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getGroupList() {
		UtilRequest.getGroupList(currentUid + "", mHandler, mContext);
	}

	/**
	 * 获取共同好友
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getSameFriends() {
		UtilRequest.getMutualFriends(J_Cache.sLoginUser.uid + "", currentUid + "", 0, 3, 2, 0, mHandler);
	}

	/**
	 * 获取某位用户的动态列表(只获取一条)
	 * 
	 * @Title: getOneUserDynamicList
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getOneUserDynamicList() {
		UtilRequest.getOneUserDynamicList(currentUid, 0, 1, mHandler);
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_ALTERNATIVE_TAG_LIST:// 推荐标签
				DialogUtils.dismissDialog();
				J_Response responseTag = (J_Response) msg.obj;
				if (responseTag.retcode == 1) {
					try {
						JSONArray array = new JSONArray(responseTag.data);
						// 清空原数据，更新为新数据
						recommendTagsData.clear();
						for (int i = 0; i < array.length(); i++) {
							JSONObject tag = array.getJSONObject(i);
							TagsInfoBean bean = new TagsInfoBean();
							bean.tid = tag.optString("tid");
							bean.name = tag.optString("title");
							bean.clickNum = tag.optInt("bind");
							bean.isClicked = tag.optInt("oper");
							bean.isSelected = 1;// 默认为选中状态
							recommendTagsData.add(bean);
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				break;
			case NetTaskIDs.TASKID_ADD_BLACK:
				// 添加黑名单
				int errorId = msg.arg1;
				if (errorId != 0) {
					String errInfo = J_NetManager.getInstance().getErrorMsg(errorId);
					ToastUtil.showToast(mContext, errInfo);
					dismissLoading();
				} else {
					J_Response responseAdd = (J_Response) msg.obj;
					if (responseAdd.retcode == 1) {
						if (responseAdd.data.equals("true")) {
							// 添加成功--重新刷新列表
							isAddBlack = true;
							ToastUtil.showToast(mContext, "添加黑名单成功");
						} else {
							// 添加失败
							ToastUtil.showToast(mContext, "添加黑名单用户失败");
						}
					}
				}
				dismissLoading();
				break;
			case NetTaskIDs.TASKID_ADD_GROUP:
				// 申请加入一个群组
				try {
					// 获取申请结果
					JSONObject groupDataInfo = new JSONObject(msg.obj.toString());
					int resultInfo = groupDataInfo.optInt("result");
					String warmInfo = "";
					switch (resultInfo) {
					case -1:// 禁止加入
						warmInfo = "该群组禁止加入！";
						// 申请发送成功
						DialogUtils.showPromptDialog(mContext, "提醒", warmInfo, new OnSelectCallBack() {
							@Override
							public void onCallBack(String value1, String value2, String value3) {
							}
						});
						break;
					case 1:// TODO 加入成功
						warmInfo = "群组加入成功！";
						// 刷新群组信息
						int groupId = msg.arg1;
						for (int i = 0; i < currentUserGroupsInfo.size(); i++) {
							if (currentUserGroupsInfo.get(i).id == groupId) {
								currentUserGroupsInfo.get(i).isJoin = 1;
							}
						}
						setUserGroupsInfo();
						// 申请发送成功
						DialogUtils.showPromptDialog(mContext, "提醒", warmInfo, new OnSelectCallBack() {
							@Override
							public void onCallBack(String value1, String value2, String value3) {
							}
						});
						break;
					case 2:// 等待群主审核
						warmInfo = "等待群主审核，审核通过后即可加入！";
						// 申请发送成功
						DialogUtils.showPromptDialog(mContext, "申请已发送", warmInfo, new OnSelectCallBack() {
							@Override
							public void onCallBack(String value1, String value2, String value3) {
							}
						});
						break;
					case 3: // 已经申请过，再次申请的情况
						warmInfo = "您已经申请过，请等待群主审核！";
						// 申请发送成功
						DialogUtils.showPromptDialog(mContext, "申请已发送", warmInfo, new OnSelectCallBack() {
							@Override
							public void onCallBack(String value1, String value2, String value3) {
							}
						});
						break;
					default:
						break;
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case 0x10001:
				String result = msg.obj.toString();
				ToastUtil.showToast(mContext, result);
				dismissLoading();
				break;
			case NetTaskIDs.TASKID_GROUP_LIST:
				// 获取用户的群组列表
				try {
					JSONArray groupArray = new JSONArray(msg.obj.toString());
					currentUserGroupsInfo.clear();
					for (int i = 0; i < groupArray.length(); i++) {
						JSONObject groupOjb = groupArray.optJSONObject(i);
						GroupsInfoBean bean = new GroupsInfoBean();
						bean.id = groupOjb.optInt("group_id");
						bean.name = groupOjb.optString("title");
						bean.intro = groupOjb.optString("intro");
						bean.count = groupOjb.optInt("total");
						bean.logo = groupOjb.optString("logo");
						bean.friendsNum = groupOjb.optInt("friend_num");
						bean.show = groupOjb.optInt("show");
						bean.isJoin = groupOjb.optInt("join");
						if (bean.show == 0) {
							currentUserGroupsInfo.add(bean);
						}
					}

					// 刷新页面数据
					setUserGroupsInfo();
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case NetTaskIDs.TASKID_TAG_CLICK:
				// 点击标签
				J_Response response3 = (J_Response) msg.obj;
				if (response3.retcode == 1) {
					try {
						JSONObject data = new JSONObject(response3.data);
						String tid = data.optString("tid");
						for (int i = 0; i < tagsData.size(); i++) {
							TagsInfoBean bean = tagsData.get(i);
							if (bean.tid.equals(tid)) {
								bean.clickNum = data.optInt("bind");
								bean.isClicked = data.optInt("oper");
								bean.updateTime = System.currentTimeMillis();
								tagsData.set(i, bean);
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				// 刷新标签列表
				refreshTags();
				break;
			case NetTaskIDs.TASKID_FRIENDS_SENT_REQ:
				// 申请添加好友
				J_Response responseSent = (J_Response) msg.obj;
				if (responseSent.retcode == 1) {
					ToastUtil.showToast(mContext, "好友申请已发送，等待对方接受");
					profile_add_friend_button.setEnabled(false);
				} else {
					ToastUtil.showToast(mContext, "添加失败：" + responseSent.retmean);
				}
				break;
			case NetTaskIDs.TASKID_FRIENDS_GET_MUTUALFRIENDS:
				// 获取共同好友
				J_Response responseSame = (J_Response) msg.obj;
				if (responseSame.retcode == 1) {
					try {
						if (!Util.isBlankString(responseSame.data) && !responseSame.data.equals("[]")) {
							JSONObject friendsData = new JSONObject(responseSame.data);
							// 共同好友数量
							if (friendsData.has("mutualnums")) {
								sameFriendsCount = friendsData.optInt("mutualnums");
							}
							// 好友姓名列表
							JSONObject friendsObj = friendsData.optJSONObject("mutualuser");
							Iterator iterator = friendsObj.keys();
							sameFriends.clear();
							while (iterator.hasNext()) {
								if (sameFriends.size() >= 1) {
									break;
								}
								String key = (String) iterator.next();
								JSONObject singleFriend = friendsObj.optJSONObject(key);
								BaseUser user = new BaseUser();
								user.uid = singleFriend.optLong("uid");
								user.nickName = singleFriend.optString("nick");
								sameFriends.add(user);
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				// 共同好友
				setSameFriends();
				break;
			case NetTaskIDs.TASKID_GET_ONE_USER_DYNAMIC_LIST:
				// 获取某位用户的动态列表
				J_Response responseNews = (J_Response) msg.obj;
				if (responseNews.retcode == 1) {
					try {
						JSONObject data = new JSONObject(responseNews.data);
						JSONArray dataArray = data.optJSONArray("list");
						if (dataArray.length() > 0) {
							for (int i = 0; i < dataArray.length(); i++) {
								JSONObject singleData = dataArray.optJSONObject(i);
								NewsInfoBean bean = new NewsInfoBean();
								bean.feedId = singleData.optInt("feedid");
								bean.uid = singleData.optLong("uid");
								bean.nick = singleData.optString("nick");
								bean.date = singleData.optString("time");
								JSONObject avatars = singleData.optJSONObject("avatars");
								bean.avatar = avatars.optString("100");
								bean.type = singleData.optInt("type");
								bean.sex = singleData.optInt("sex");
								bean.friendDimen = singleData.optInt("friend");
								bean.praiseCount = singleData.optInt("praise_num");
								bean.rebroadcastCount = singleData.optInt("rebroadcast_num");
								bean.commentCount = singleData.optInt("comment_num");
								bean.is_comment = singleData.optInt("is_comment");
								bean.is_praise = singleData.optInt("is_praise");
								bean.is_rebroadcast = singleData.optInt("is_rebroadcast");
								if (bean.type == 100) {
									// 文字信息
									JSONObject newsData = singleData.optJSONObject("data");
									bean.content = newsData.optString("content");
									// 过滤无效数据
									if (Util.isBlankString(bean.content)) {
										continue;
									}
								} else if (bean.type == 101) {
									// 图片信息
									// 动态内容
									JSONObject newsData = singleData.optJSONObject("data");
									bean.content = newsData.optString("content");
									String pidsStr = newsData.optString("pids");
									if (!pidsStr.equals("false") && !Util.isBlankString(pidsStr) && !pidsStr.equals("[]")) {
										JSONObject photoData = newsData.optJSONObject("pids");
										Iterator allkeys = photoData.keys();
										while (allkeys.hasNext()) {
											String key = (String) allkeys.next();
											if (!Util.isBlankString(key)) {
												JSONObject picInfo = photoData.optJSONObject(key);
												PhotoInfoBean pBean = new PhotoInfoBean();
												pBean.pid = key;
												pBean.url_small = picInfo.optString("600");
												pBean.url = picInfo.optString("600");
												pBean.type = 1;
												pBean.nick = currentUserInfo.nickName;
												bean.contentPhoto.add(pBean);
											}
										}
									} else {
										// 过滤无效数据
										continue;
									}
								} else if (bean.type == 500) {
									// 转播文字
									// 动态内容
									JSONObject newsData = singleData.optJSONObject("data");
									bean.relayContent = newsData.optString("content");
									bean.relayUid = newsData.optLong("uid");
									bean.relayNick = newsData.optString("nick");
									bean.relayType = newsData.optInt("type");
									bean.relaySex = newsData.optInt("sex");
									JSONObject avatarsRelay = newsData.optJSONObject("avatar");
									bean.relayAvatar = avatarsRelay.optString("100");
									bean.relayFeedId = newsData.optInt("feedid");
									bean.relayDate = newsData.optString("time");
									// 过滤无效数据
									if (Util.isBlankString(bean.relayContent)) {
										continue;
									}
								} else if (bean.type == 501) {
									// 转播图片
									// 动态内容
									JSONObject newsData = singleData.optJSONObject("data");
									bean.relayContent = newsData.optString("content");
									bean.relayUid = newsData.optLong("uid");
									bean.relayNick = newsData.optString("nick");
									bean.relayType = newsData.optInt("type");
									bean.relaySex = newsData.optInt("sex");
									JSONObject avatarsRelay = newsData.optJSONObject("avatar");
									bean.relayAvatar = avatarsRelay.optString("100");
									bean.relayFeedId = newsData.optInt("feedid");
									bean.relayDate = newsData.optString("time");
									String pidsStr = newsData.optString("pids");
									if (!pidsStr.equals("false") && !Util.isBlankString(pidsStr) && !pidsStr.equals("[]")) {
										JSONObject photoData = newsData.optJSONObject("pids");
										Iterator allkeys = photoData.keys();
										while (allkeys.hasNext()) {
											String key = (String) allkeys.next();
											if (!Util.isBlankString(key)) {
												JSONObject picInfo = photoData.optJSONObject(key);
												PhotoInfoBean pBean = new PhotoInfoBean();
												pBean.pid = key;
												pBean.url_small = picInfo.optString("600");
												pBean.url = picInfo.optString("600");
												pBean.type = 1;
												pBean.nick = bean.relayNick;
												bean.relayContentPhoto.add(pBean);
											}
										}
									} else {
										// 过滤无效数据
										continue;
									}
								}
								currentUserNewsInfo = bean;
							}
						} else {
							currentUserNewsInfo = new NewsInfoBean();
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}

				// 刷新页面动态信息
				setUserNewsInfo();
				break;
			case NetTaskIDs.TASKID_UPDATE_USER_MARK:
				// 添加备注
				J_Response response4 = (J_Response) msg.obj;
				if (response4.retcode == 1) {
					// 添加成功
					getUserInfo();
				}
				break;
			case NetTaskIDs.TASKID_ADD_TAG:
				// 标签添加成功
				J_Response response = (J_Response) msg.obj;
				if (response.retcode == 1) {
					ToastUtil.showToast(mContext, "添加成功");
					try {
						if (response.data.equals("-1")) {
							ToastUtil.showToast(mContext, "添加失败：标签已经存在");
						} else {
							JSONObject data = new JSONObject(response.data);
							String tid = data.optString("tid");
							String title = data.optString("title");

							TagsInfoBean bean = new TagsInfoBean();
							bean.tid = tid;
							bean.name = title;
							tagsData.add(bean);
							// 刷新标签列表
							refreshTags();
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				} else if (response.retcode == -2) {
					ToastUtil.showToast(mContext, "标签添加失败：包含敏感词！");
				} else {
					ToastUtil.showToast(mContext, "标签添加失败");
				}
				break;
			case NetTaskIDs.TASKID_TAG_LIST:
				// 获取标签列表
				J_Response response2 = (J_Response) msg.obj;
				if (response2.retcode == 1) {
					try {
						JSONArray array = new JSONArray(response2.data);
						// 清空原数据，更新为新数据
						tagsData.clear();
						for (int i = 0; i < array.length(); i++) {
							JSONObject tag = array.getJSONObject(i);
							TagsInfoBean bean = new TagsInfoBean();
							bean.tid = tag.optString("tid");
							bean.name = tag.optString("title");
							bean.clickNum = tag.optInt("bind");
							bean.isClicked = tag.optInt("oper");
							bean.updateTime = tag.optLong("ctime") * 1000;
							tagsData.add(bean);
						}
						if (isFirstLoad) {
							defaultTagNum = tagsData.size();
							isFirstLoad = false;
						}
						// 刷新列表
						refreshTags();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 
	 * @Title: refreshTags
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void refreshTags() {
		// 移除当前标签容器中的所有标签，重新刷新添加
		textViews = new View[tagsData.size()];
		Collections.sort(tagsData, new TagListComparator());
		for (int i = 0; i < tagsData.size(); i++) {
			final TagsInfoBean bean = tagsData.get(i);

			View tagView = View.inflate(mContext, R.layout.item_tag_layer, null);
			LinearLayout item_tag_box = (LinearLayout) tagView.findViewById(R.id.item_tag_box);
			TextView item_tag_click_num = (TextView) tagView.findViewById(R.id.item_tag_click_num);
			TextView item_tag_name = (TextView) tagView.findViewById(R.id.item_tag_name);
			// 点击次数
			item_tag_click_num.setText(bean.clickNum + "");
			// 标签名字
			item_tag_name.setText(bean.name);
			item_tag_name.setSingleLine(true);
			if (bean.isClicked == 1) {
				// 禁用状态
				item_tag_box.setBackgroundResource(R.drawable.bg_tag_disabled);
				if (bean.clickNum <= 0) {
					item_tag_click_num.setVisibility(View.GONE);
				} else {
					item_tag_click_num.setBackgroundResource(R.drawable.bg_tag_num_disabled);
				}
			} else if (bean.clickNum >= 5) {
				// 热门标签
				item_tag_box.setBackgroundResource(R.drawable.bg_tag_hot);
				item_tag_click_num.setBackgroundResource(R.drawable.bg_tag_num_hot);
			} else if (bean.clickNum <= 0) {
				// 没有点击数字，普通标签，隐藏数字内容
				item_tag_box.setBackgroundResource(R.drawable.bg_tag_normal);
				item_tag_click_num.setVisibility(View.GONE);
			} else {
				// 普通标签
				item_tag_box.setBackgroundResource(R.drawable.bg_tag_normal);
				item_tag_click_num.setBackgroundResource(R.drawable.bg_tag_num_normal);
			}
			// 设置点击状态
			if (currentUserInfo.isFriend != 0 || currentUserInfo.uid == J_Cache.sLoginUser.uid) {
				// 好友（1度，2度）或者是用户本人才可以点击
				tagView.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						UtilRequest.clickTag(mContext, currentUid + "", bean.tid, mHandler);
					}
				});
			}
			textViews[i] = tagView;
		}
		// 添加标签到页面，并获得标签的总行数
		if (textViews.length > 0 && textViews[0] != null && textViews[0] instanceof View) {
			boolean isCurrentTagsShowAll = showTagCell[0] <= 2 ? false : true;
			showTagCell = Util.populateText(profile_tags, textViews, mContext,
					getResources().getDimensionPixelSize(R.dimen.global_px30dp), isCurrentTagsShowAll);
			// 根据标签行数（>2），看折叠按钮是否显示
			if (showTagCell[1] > 2) {
				profile_tag_toggle.setVisibility(View.VISIBLE);
			} else {
				profile_tag_toggle.setVisibility(View.GONE);
			}
		} else {
			profile_tags.removeAllViews();
			profile_tags.addView(emptyTagView);
			profile_tag_toggle.setVisibility(View.GONE);
		}
	}

	/**
	 * 自动展开闭合标签层
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void toggleTag() {
		if (showTagCell[0] <= 2) {
			// 已经隐藏-做展开操作
			showTagCell = Util.populateText(profile_tags, textViews, mContext,
					getResources().getDimensionPixelSize(R.dimen.global_px30dp), true);
			profile_tag_toggle.setImageResource(R.drawable.icon_up);
		} else {
			// 已经展开-做折叠操作
			showTagCell = Util.populateText(profile_tags, textViews, mContext,
					getResources().getDimensionPixelSize(R.dimen.global_px30dp), false);
			profile_tag_toggle.setImageResource(R.drawable.icon_more);
		}
	}

	/**
	 * 自动展开闭合群组层
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void toggleGroup() {
		if (showGroupCell[1] <= 5) {
			// 已经隐藏-做展开操作
			showGroupCell[1] = showGroupCell[0];
			setUserGroupsInfo();
			profile_group_toggle.setImageResource(R.drawable.icon_up);
		} else {
			// 已经展开-做折叠操作
			// 如果现在显示的数量大于5条，则折叠为只显示5条
			showGroupCell[1] = 5;
			// 刷新列表
			setUserGroupsInfo();
			// 图标更换
			profile_group_toggle.setImageResource(R.drawable.icon_more);
		}
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleRightButton:
				// 弹出菜单
				new ProfileMenuPopDialog(mContext, R.style.dialog).setCallBack(new OnSelectCallBack() {
					@Override
					public void onCallBack(String value1, String value2, String value3) {
						if (value1.equals("1")) {
							// 分享给好友
							shareToFriend("分享给好友");
						} else if (value1.equals("2")) {
							// 举报
							reportUser();
						} else if (value1.equals("3")) {
							// 拉黑
							if (isAddBlack) {
								ToastUtil.showToast(mContext, "该用户已经加入黑名单");
							} else {
								showLoading("加载中...");
								addBlackList();
							}
						}
					}
				}).show();
				break;
			case R.id.profile_add_new_tag_button:
				// 添加新标签
				if (defaultTagNum <= 3) {
					new AddTagDialog(mContext, R.style.dialog, currentUid + "", recommendTagsData, tagsData).setCallBack(
							new DialogCallBack() {
								@Override
								public void onCallBack(int id, Object object) {
									switch (id) {
									case R.id.add_tag_dialog:// 添加标签的返回
										TagsInfoBean bean = (TagsInfoBean) object;
										tagsData.add(bean);
										refreshTags();
										break;

									default:
										break;
									}
								}
							}).show();
				} else {
					new EditTextDialog(mContext, R.style.dialog).setType(1).setCallBack(new OnSelectCallBack() {
						@Override
						public void onCallBack(String value1, String value2, String value3) {
							if (value1.equals("1")) {
								// 确定
								UtilRequest.addNewTag(mContext, currentUid + "", value2, mHandler);
							}
						}
					}).show();
				}
				break;
			case R.id.profile_avatar:
				// 点击头像看大图
				if (currentUserInfo.hasAvatar == 1) {
					Intent photoIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
					// 查看图片的data（单图）
					ArrayList<PhotoInfoBean> datas = new ArrayList<PhotoInfoBean>();
					PhotoInfoBean beanData = new PhotoInfoBean();
					beanData.url_small = currentUserInfo.avatarUrl100;
					beanData.url = currentUserInfo.avatarUrl200;
					beanData.uid = currentUid;
					beanData.type = 2;
					beanData.nick = currentUserInfo.nickName;
					datas.add(beanData);
					photoIntent.putExtra("photoInfo", datas);
					photoIntent.putExtra("viewType", 3);
					startActivity(photoIntent);
				}
				break;
			case R.id.profile_confirm_invite:
				// 确认单身
				// 两个人是好友关系，确认好友
				showLoading();
				if (currentUserInfo.isLonelyConfirm == 1) {
					// 确认过单身，取消确认
					new CanceLonelyConfirmRequest(new OnDataBack() {
						@Override
						public void onResponse(Object result) {
							J_Response response = (J_Response) result;
							if (response.retcode == 1) {
								// 更新单身确认数
								int data = Util.getInteger(response.data);
								currentUserInfo.isLonelyConfirm = 0;
								currentUserInfo.lonelyConfirm = data;
								SharedPreUtil.saveNormalUser(currentUserInfo);
								// 刷新信息
								setContent(false);
							}
							dismissLoading();
						}

						@Override
						public void onError(HashMap<String, Object> errorMap) {
							dismissLoading();
						}
					}).execute(currentUserInfo.uid);
				} else {
					// 未确认过单身，确认
					new UpdateUserLonlyConfirmRequest(new J_OnDataBack() {
						@Override
						public void onResponse(Object result) {
							J_Response response = (J_Response) result;
							if (response.retcode == 1) {
								getUserInfo();
							}
							dismissLoading();
						}

						@Override
						public void onError(HashMap<String, Object> errorMap) {
							dismissLoading();
						}
					}).execute(currentUid + "");
				}
				break;
			case R.id.profile_out_single_button:
				// 帮他脱单
				shareToFriend("帮TA脱单");
				break;
			case R.id.profile_remark:
				// 备注点击
				new EditTextDialog(mContext, R.style.dialog).setType(2).setDefaultTxt(currentUserInfo.mark)
						.setCallBack(new OnSelectCallBack() {
							@Override
							public void onCallBack(String value1, String value2, String value3) {
								if (value1.equals("1")) {
									// 确定
									UtilRequest.update_user_mark(mContext, currentUid + "", value2, mHandler);
								}
							}
						}).show();
				break;
			case R.id.profile_right_icon2:
				// 相册
				Intent albumIntent = new Intent(mContext, ProfileAlbumActivity.class);
				albumIntent.putExtra("uid", currentUid);
				albumIntent.putExtra("nick", currentUserInfo.nickName);
				startActivity(albumIntent);
				break;
			case R.id.profile_add_friend_button:
				// 加为好友
				UtilRequest.friendsSentReq(J_Cache.sLoginUser.uid, currentUid, mHandler, mContext);
				break;
			case R.id.profile_tag_toggle:
				// 收起显示标签层
				toggleTag();
				break;
			case R.id.profile_group_toggle:
				// 收起显示群组层
				toggleGroup();
				break;
			case R.id.profileSameFriendBox:
			case R.id.profile_left_title1:
			case R.id.profile_right_icon1:
				// 共同好友
				if (sameFriendsCount > 0 && sameFriends.size() > 0) {
					// 查看共同好友
					Intent sameFriendIntent = new Intent(mContext, ProfileSameFriendsActivity.class);
					sameFriendIntent.putExtra("userInfo", currentUserInfo);
					startActivity(sameFriendIntent);
				} else {
					// 查看他的好友
					Intent sameFriendIntent = new Intent(mContext, ProfileSameFriendsActivity.class);
					sameFriendIntent.putExtra("type", 1);
					sameFriendIntent.putExtra("uid", currentUid);
					sameFriendIntent.putExtra("userInfo", currentUserInfo);
					startActivity(sameFriendIntent);
				}
				break;
			case R.id.profile_news_box:
				// 动态
				Intent newsIntent = new Intent(mContext, NewsMainActivity.class);
				newsIntent.putExtra("type", 1);
				newsIntent.putExtra("uid", currentUid);
				newsIntent.putExtra("userInfo", currentUserInfo);
				startActivity(newsIntent);
				break;
			case R.id.profile_chat_button:
				// 聊天
				Intent chatIntent = new Intent(mContext, ChatMainActivity.class);
				chatIntent.putExtra(UtilRequest.FORM_OID, currentUid + "");
				chatIntent.putExtra(UtilRequest.FORM_NICK, currentUserInfo.nickName);
				startActivity(chatIntent);
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 分享给朋友
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void shareToFriend(String title) {
		J_ShareParams params = OpenPlatformUtil.getShareFriendParams(currentUserInfo);
		new SharePopDialog(ProfileViewActivity.this, R.style.dialog).setDialogTitle(title).setParams(params)
				.setCallBack(new PlatformActionListener() {
					@Override
					public void onError(Platform arg0, int arg1, Throwable arg2) {
						mHandler.sendMessage(mHandler.obtainMessage(0x10001, "分享失败！"));
					}

					@Override
					public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
						if (!arg0.getName().equals(SinaWeibo.NAME)) {
							mHandler.sendMessage(mHandler.obtainMessage(0x10001, "分享成功！"));
						}
					}

					@Override
					public void onCancel(Platform arg0, int arg1) {
						mHandler.sendMessage(mHandler.obtainMessage(0x10001, "取消分享！"));
					}
				}).show();
	}

	/**
	 * 举报该用户
	 * 
	 * @Title: reportUser
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void reportUser() {
		new ReportDialog(mContext, R.style.dialog).setReportType(2).setReportUid(currentUid + "").show();
	}

	/**
	 * 拉黑名单
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void addBlackList() {
		UtilRequest.addBlack(J_Cache.sLoginUser.uid + "", currentUid + "", mHandler);
	}

	/**
	 * 获取用户信息
	 * 
	 * @Title: getUserInfo
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getUserInfo() {
		new GetUserInfoRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				UserInfoResponse response = (UserInfoResponse) result;
				if (response.retcode == 1) {
					currentUserInfo = response.userInfo;
					// 刷新页面信息
					setContent(false);
					// 获取标签列表
					getTagsList();
				} else {
					ToastUtil.showToast(mContext, "用户信息获取失败");
				}
				dismissLoading();
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				dismissLoading();
			}
		}).execute(currentUid + "");
	}

	/**
	 * 显示页面内容
	 * 
	 * @Title: setContent
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setContent(boolean isCache) {
		// 3黑名单，9已注销
		if (!isCache && (currentUserInfo.gid == 3 || currentUserInfo.gid == 9)) {
			DialogUtils.showAlertDialog(mContext, "提醒", "该用户已经注销！", "知道了", false, new OnSelectCallBack() {
				@Override
				public void onCallBack(String value1, String value2, String value3) {
					if (value1.equals("0")) {
						finish();
					}
				}
			});
			return;
		}
		// 设置标题
		if (!Util.isBlankString(currentUserInfo.nickName)) {
			titleCenter.setText(currentUserInfo.nickName);
		}
		// 性别显示
		if (currentUserInfo.sex == 0) {
			// 女
			profile_sex.setImageResource(R.drawable.icon_famale_b);
		} else {
			// 男
			profile_sex.setImageResource(R.drawable.icon_male_b);
		}
		// 头像
		J_NetManager.getInstance().loadIMG(null, currentUserInfo.avatarUrl, profile_avatar, R.drawable.icon_avatar,
				R.drawable.icon_avatar);
		// 昵称
		// 好友维度和备注信息的显示设置
		if (currentUserInfo.isFriend == 1) {
			// 是1度好友
			// 显示备注按钮
			profile_remark.setVisibility(View.VISIBLE);
			// 维度标记
			profile_friend_dimen_icon.setImageResource(R.drawable.icon_dimen_one);
			profile_friend_dimen_icon.setVisibility(View.VISIBLE);
			// 只有1度好友可以修改昵称
			if (!Util.isBlankString(currentUserInfo.mark)) {
				// 存在备注
				// 显示备注名称
				profile_nick.setText(StringUtils.getLimitSubstringWithMore(currentUserInfo.mark, 5));
				profile_remark.setText("");
				profile_remark.setCompoundDrawablesWithIntrinsicBounds(R.drawable.icon_mark, 0, 0, 0);
				titleCenter.setText(currentUserInfo.mark);
			} else {
				profile_nick.setText(StringUtils.getLimitSubstringWithMore(currentUserInfo.nickName, 5));
				profile_remark.setText("(备注)");
				profile_remark.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);
			}
		} else if (currentUserInfo.isFriend == 2) {
			// 2度好友不可备注
			profile_nick.setText(currentUserInfo.nickName);
			profile_remark.setVisibility(View.GONE);
			// 维度标记
			profile_friend_dimen_icon.setImageResource(R.drawable.icon_dimen_two);
			profile_friend_dimen_icon.setVisibility(View.VISIBLE);
		} else {
			// 不是好友
			// 不可备注，不显示维度
			profile_nick.setText(currentUserInfo.nickName);
			profile_remark.setVisibility(View.GONE);
			profile_friend_dimen_icon.setVisibility(View.GONE);
		}
		// 情感状况
		profile_marriage.setText(Html.fromHtml("<font color=\"#303030\">情感状态: </font>"
				+ ProfileUtils.getMarriage(currentUserInfo.marriage)));
		// 位置信息
		if (!Util.isBlankString(currentUserInfo.locationName) && !Util.isBlankString(currentUserInfo.subLocationName)) {
			profile_location.setVisibility(View.VISIBLE);
			profile_location.setText(currentUserInfo.locationName + " " + currentUserInfo.subLocationName);
		} else {
			profile_location.setVisibility(View.GONE);
		}
		// 个人签名
		String intro = "这个主人很懒，什么都没有留下！";
		if (!Util.isBlankString(currentUserInfo.intro)) {
			intro = currentUserInfo.intro;
		}
		profile_signer.setText(intro);
		// 相册图片
		setPhotoList();
		// 如果相册图片内容小于4张，不显示箭头
		if (currentUserInfo.photoCount <= 0) {
			profile_right_icon2.setVisibility(View.GONE);
		} else {
			profile_right_icon2.setVisibility(View.VISIBLE);
		}
		// 个人信息
		int totalShow = 0;
		// 常驻地
		if (!Util.isBlankString(currentUserInfo.address)) {
			totalShow++;
			profile_view_address.setText(currentUserInfo.address);
			profile_view_address_box.setVisibility(View.VISIBLE);
		} else {
			profile_view_address_box.setVisibility(View.GONE);
		}
		if (currentUserInfo.marriage == 1) {
			// 生日星座
			if (currentUserInfo.star > 0 && currentUserInfo.birthYear > 0) {
				totalShow++;
				profile_view_birth_box.setVisibility(View.VISIBLE);
				profile_view_birth.setText(ProfileUtils.getStar(currentUserInfo.star) + ","
						+ ProfileUtils.getAgeStyle(currentUserInfo.birthYear + ""));
				profile_birthday.setVisibility(View.VISIBLE);
				profile_birthday.setText(ProfileUtils.getStar(currentUserInfo.star) + ","
						+ ProfileUtils.getAgeStyle(currentUserInfo.birthYear + ""));
			} else {
				profile_view_birth_box.setVisibility(View.GONE);
				profile_birthday.setVisibility(View.GONE);
			}
			// 身高
			String height = ProfileUtils.getHeight(currentUserInfo.height);
			if (!Util.isBlankString(height)) {
				totalShow++;
				profile_view_height.setText(height);
				profile_view_height_box.setVisibility(View.VISIBLE);
			} else {
				profile_view_height_box.setVisibility(View.GONE);
			}
			// 体重
			String weight = ProfileUtils.getWeight(currentUserInfo.weight);
			if (!Util.isBlankString(weight)) {
				totalShow++;
				profile_view_weight.setText(weight);
				profile_view_weight_box.setVisibility(View.VISIBLE);
			} else {
				profile_view_weight_box.setVisibility(View.GONE);
			}
		} else {
			// 非单身-生日不显示
			profile_view_birth_box.setVisibility(View.GONE);
			profile_birthday.setVisibility(View.GONE);
			// 非单身-身高不显示
			profile_view_height_box.setVisibility(View.GONE);
			// 非单身-体重不显示
			profile_view_weight_box.setVisibility(View.GONE);
		}

		// 职业
		String career = ProfileUtils.getCareer(currentUserInfo.career);
		if (!Util.isBlankString(career)) {
			totalShow++;
			profile_view_job.setText(career);
			profile_view_job_box.setVisibility(View.VISIBLE);
			if (currentUserInfo.career == J_Consts.SCHOOL_CAREER_ID) {
				// 学生
				profile_view_icon5.setText("学校");
				profile_view_company.setText(currentUserInfo.school);
				if (Util.isBlankString(currentUserInfo.school)) {
					// 学校信息为空，隐藏该项
					profile_item_company_box.setVisibility(View.GONE);
				} else {
					profile_item_company_box.setVisibility(View.VISIBLE);
				}
			} else {
				// 其他职业
				if (Util.isBlankString(currentUserInfo.company)) {
					// 公司信息为空，隐藏该项
					profile_item_company_box.setVisibility(View.GONE);
				} else {
					profile_view_icon5.setText("公司");
					profile_view_company.setText(currentUserInfo.company);
					profile_item_company_box.setVisibility(View.VISIBLE);
				}
			}
		} else {
			profile_view_job_box.setVisibility(View.GONE);
			// 没有选择职业，可能会有公司信息，需要进行判断
			if (!Util.isBlankString(currentUserInfo.company)) {
				totalShow++;
				profile_view_icon5.setText("公司");
				profile_view_company.setText(currentUserInfo.company);
				profile_item_company_box.setVisibility(View.VISIBLE);
			} else {
				profile_item_company_box.setVisibility(View.GONE);
			}
		}

		if (totalShow >= 1) {
			profile_view_content_box.setVisibility(View.VISIBLE);
		} else {
			profile_view_content_box.setVisibility(View.GONE);
		}

		// 标签
		if (currentUserInfo.isFriend != 1) {
			// 非1度好友，不能添加标签
			profile_add_new_tag_button.setVisibility(View.GONE);
		} else {
			profile_add_new_tag_button.setVisibility(View.VISIBLE);
		}

		// 自己不显示添加好友按钮/不显示聊天按钮
		if (currentUid != J_Cache.sLoginUser.uid) {
			// 不是自己的页面，显示右侧菜单按钮
			titleRightButton.setVisibility(View.VISIBLE);
			// 情感状态确认
			if (currentUserInfo.marriage == 1) {
				// 单身状态是，设置其他额外需要显示的内容
				if (currentUserInfo.isFriend == 1) {
					// 是好友
					// 显示多少人确认多T是单身
					profile_confirm_invite.setVisibility(View.VISIBLE);
					// 是否确认过该好友为单身
					if (currentUserInfo.isLonelyConfirm == 0) {
						// 未确认过
						// 我还未确认ta是单身
						profile_confirm_invite.setText("已有" + currentUserInfo.lonelyConfirm + "人确认TA是单身 我也来帮TA认证");
						profile_confirm_invite.setBackgroundColor(getResources().getColor(R.color.text_normal_blue));
					} else {
						// 我已经确认过ta是单身
						profile_confirm_invite.setText(Html.fromHtml("已有" + currentUserInfo.lonelyConfirm
								+ "人确认TA是单身 我已经帮TA认证 <font color=\"#FA544F\">取消认证</font>"));
						profile_confirm_invite.setBackgroundColor(getResources().getColor(R.color.text_normal_gray));
					}
				} else {
					// 非好友
					profile_confirm_invite.setVisibility(View.GONE);
				}
				// 单身状态，显示“帮TA脱单”按钮
				profile_out_single_button.setVisibility(View.VISIBLE);
			} else {
				// 非单身状态，隐藏“帮ta脱单”按钮
				profile_out_single_button.setVisibility(View.GONE);
				// 隐藏多少人确认多T是单身
				profile_confirm_invite.setVisibility(View.GONE);
			}
			// 权限隐私设置
			switch (currentUserInfo.allow_add_with_chat) {
			case 0:// 允许所有人加我为好友并能发起聊天
				profile_chat_button.setVisibility(View.VISIBLE);
				if (currentUserInfo.isFriend != 1) {
					showStrangePopLayer();
					profile_add_friend_button.setVisibility(View.VISIBLE);
				} else {
					profile_add_friend_button.setVisibility(View.GONE);
				}
				break;
			case 1:// 只有二度好友可以加我并发起聊天
				if (currentUserInfo.isFriend == 2) {
					showStrangePopLayer();
					profile_chat_button.setVisibility(View.VISIBLE);
					profile_add_friend_button.setVisibility(View.VISIBLE);
				} else {
					profile_chat_button.setVisibility(View.GONE);
					profile_add_friend_button.setVisibility(View.GONE);
				}
				break;
			case 2:// 禁止任何人加我为好友并发起聊天
				profile_chat_button.setVisibility(View.GONE);
				profile_add_friend_button.setVisibility(View.GONE);
				break;
			default:
				break;
			}
		} else {
			// 自己的页面，隐藏该按钮
			titleRightButton.setVisibility(View.GONE);
			// 隐藏确认单身按钮
			profile_confirm_invite.setVisibility(View.GONE);
		}

		// 资料展示权限
		if ((currentUserInfo.allow_my_profile_show == 1 && currentUserInfo.isFriend != 1)
				|| (currentUserInfo.allow_my_profile_show == 2 && currentUserInfo.isFriend != 1 && currentUserInfo.isFriend != 2)) {
			// 1：只有1度好友可以查看动态和相册
			// 2:只有1度和2度好友查看动态和相册
			profile_album_box.setVisibility(View.GONE);
			profile_news_box.setVisibility(View.GONE);
		} else {
			if (currentUserInfo.photoDatas.size() > 0) {
				profile_album_box.setVisibility(View.VISIBLE);
			} else {
				profile_album_box.setVisibility(View.GONE);
			}
			profile_news_box.setVisibility(View.VISIBLE);
		}
	}

	/**
	 * TODO 弹出非好友，添加好友提示框
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void showStrangePopLayer() {
		if (!SharedPreUtil.getAddFriendsStatus(currentUserInfo.uid)) {
			// 设置状态为已经展示过
			SharedPreUtil.setAddFriendsStatus(currentUserInfo.uid);
			// 如果没有展示过，进行弹层展示
			DialogUtils.showStangerWarmDialog(this, currentUserInfo.sex, true, new OnSelectCallBack() {
				@Override
				public void onCallBack(String value1, String value2, String value3) {
					if (value1.equals("0")) {
						// 确定
						UtilRequest.friendsSentReq(SharedPreUtil.getLoginInfo().uid, currentUid, mHandler, mContext);
						if (SharedPreUtil.getLoginInfo().callno_upload == 0) {
							// 点击数量+1
							SharedPreUtil.saveAddFriendsForUploadDialogNums();
							// 未上传通讯录的人，每点2个加好友,点完之后显示一次导入通讯录弹层
							if (SharedPreUtil.getAddFriendsForUploadDialogNums() > 0
									&& SharedPreUtil.getAddFriendsForUploadDialogNums() % 2 == 0 && userType == 1) {
								showUploadContactsDialog();
							}
						}
					} else if (value1.equals("1")) {
						// 弹层关闭
						if (userType == 1 && SharedPreUtil.getLoginInfo().callno_upload == 0) {
							// 该用户为推荐用户，并且当前登录用户没有上传通讯录，弹出提示
							showUploadContactsDialog();
						}
					}
				}
			});
		}
	}

	/**
	 * 弹出导入通讯录的弹层
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void showUploadContactsDialog() {
		new UploadContactsDialog(mContext, R.style.dialog).setCallBack(new OnSelectCallBack() {
			@Override
			public void onCallBack(String value1, String value2, String value3) {
				if (value1.equals("0")) {
					// 导入成功
					J_Cache.sLoginUser.callno_upload = 1;
					SharedPreUtil.saveLoginInfo(J_Cache.sLoginUser);
				}
			}
		}).show();
	}

	/**
	 * 获取共同好友
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setSameFriends() {
		if (sameFriendsCount > 0 && sameFriends.size() > 0) {
			// 设置好友列表，并设置昵称可点击
			SpannableStringBuilder ssBuilder = new SpannableStringBuilder();
			for (int i = 0; i < sameFriends.size(); i++) {
				// 当前用户
				final BaseUser user = sameFriends.get(i);
				String userNick = user.nickName;
				if (sameFriendsCount > 1) {
					// 大于1个共同好友，需要截取昵称长度，如果只有1个共同好友，显示全部
					userNick = StringUtils.getLimitSubstringWithMore(user.nickName, 9);
				}
				SpannableString userStr = new SpannableString(userNick);
				userStr.setSpan(new ForegroundColorSpan(getResources().getColor(R.color.blue_main)), 0, userNick.length(),
						Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
				ssBuilder.append(userStr);
			}
			// 存在共同好友
			if (sameFriendsCount > 1) {
				ssBuilder.append("  等");
				String countTxt = sameFriendsCount + "";
				SpannableString countStr = new SpannableString(countTxt);
				countStr.setSpan(new ForegroundColorSpan(getResources().getColor(R.color.blue_main)), 0, countTxt.length(),
						Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
				ssBuilder.append(countStr);
				ssBuilder.append("人");
			}
			profile_same_friends.setText(ssBuilder);
		} else {
			SpannableStringBuilder ssBuilder = new SpannableStringBuilder();
			String noFriendStr = "还没有共同好友哦";
			SpannableString noFriendTxt = new SpannableString(noFriendStr);
			noFriendTxt.setSpan(new ForegroundColorSpan(getResources().getColor(R.color.blue_main)), 0, noFriendStr.length(),
					Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
			ssBuilder.append(noFriendTxt);
			profile_same_friends.setText(ssBuilder);
		}
	}

	/**
	 * 刷新群组信息
	 * 
	 * @Title: setUserGroupsInfo
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setUserGroupsInfo() {
		profile_groups.removeAllViews();
		// 设置群组总行数
		showGroupCell[0] = currentUserGroupsInfo.size();
		if (showGroupCell[1] <= 0) {
			// 初次初始化
			if (currentUserGroupsInfo.size() > 5) {
				showGroupCell[1] = 5;
			} else {
				showGroupCell[1] = currentUserGroupsInfo.size();
			}
		}
		if (currentUserGroupsInfo.size() > 0) {
			for (int i = 0; i < showGroupCell[1]; i++) {
				final GroupsInfoBean bean = currentUserGroupsInfo.get(i);
				// 只显示可显示的群组信息
				View gView = View.inflate(mContext, R.layout.item_profile_groups_layout, null);
				TextView item_group_name = (TextView) gView.findViewById(R.id.item_group_name);
				TextView item_goup_num = (TextView) gView.findViewById(R.id.item_goup_num);
				ImageButton item_group_add = (ImageButton) gView.findViewById(R.id.item_group_add);
				// 群组名称
				item_group_name.setText(bean.name);
				// 群组人员数量
				item_goup_num.setText("(" + bean.count + "人)");
				// 自己的群组，不显示添加按钮
				// item_group_add.setVisibility(View.INVISIBLE);
				if (currentUid == J_Cache.sLoginUser.uid || bean.isJoin == 1) {
					// 登录用户自己的页面
					item_group_add.setVisibility(View.INVISIBLE);
				} else {
					// 点击添加按钮，申请加入该群组
					item_group_add.setVisibility(View.VISIBLE);
					item_group_add.setOnClickListener(new OnClickListener() {
						@Override
						public void onClick(View v) {
							DialogUtils.showPromptDialog(mContext, "加入群组", bean.name + "(" + bean.count + "人)",
									new OnSelectCallBack() {
										@Override
										public void onCallBack(String value1, String value2, String value3) {
											if (value1.equals("0")) {
												// ok
												UtilRequest.addGroup(bean.id, currentUid + "", mHandler, mContext);
											}
										}
									});
						}
					});
				}
				// 不是登录用户自己的页面，可以点击查看
				// 点击名字进入群组详细信息页面
				item_group_name.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						Intent groupIntent = new Intent(mContext, ProfileGroupDetailActivity.class);
						groupIntent.putExtra("groupId", bean.id);
						groupIntent.putExtra("uid", currentUid);
						startActivity(groupIntent);
					}
				});
				profile_groups.addView(gView);
			}

			if (currentUserGroupsInfo.size() > 5) {
				// 总数量大于5，显示折叠按钮
				profile_group_toggle.setVisibility(View.VISIBLE);
			} else {
				// 总数量小于5，隐藏折叠按钮
				profile_group_toggle.setVisibility(View.GONE);
			}
		} else {
			// 没有加入群组，显示提示信息
			View gView = View.inflate(mContext, R.layout.item_profile_groups_layout, null);
			TextView item_group_name = (TextView) gView.findViewById(R.id.item_group_name);
			TextView item_goup_num = (TextView) gView.findViewById(R.id.item_goup_num);
			ImageButton item_group_add = (ImageButton) gView.findViewById(R.id.item_group_add);
			// 提示信息
			item_group_name.setText("暂无群组信息");
			// 隐藏其他内容
			item_goup_num.setVisibility(View.INVISIBLE);
			item_group_add.setVisibility(View.INVISIBLE);
			profile_group_toggle.setVisibility(View.GONE);
			profile_groups.addView(gView);
		}
	}

	/**
	 * 设置用户的动态信息
	 * 
	 * @Title: setUserNewsInfo
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setUserNewsInfo() {
		// 发表时间
		String content = "暂无动态信息";
		switch (currentUserNewsInfo.type) {
		case 100:
			// 发表文字
			content = currentUserNewsInfo.content;
			break;
		case 101:
			// 发表图片
			if (!Util.isBlankString(currentUserNewsInfo.content)) {
				content = currentUserNewsInfo.content;
			} else {
				content = "发表图片";
			}
			break;
		case 500:
			// 转播文字
			content = "转播文字";
			break;
		case 501:
			// 转播图片
			content = "转播图片";
			break;
		default:
			break;
		}
		profile_news_info.setText(content);
	}

	/**
	 * 设置图片列表（最多4张）
	 * 
	 * @Title: setPhotoList
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setPhotoList() {
		// 清空所有图片
		profile_album.removeAllViews();
		// 添加图片
		if (currentUserInfo.photoDatas.size() > 0) {
			// 重新排序
			Collections.sort(currentUserInfo.photoDatas, new PhotoComparator());
			for (int i = 0; i < currentUserInfo.photoDatas.size(); i++) {
				// 最多显示4张照片
				if (i < 4) {
					// 获取一张照片
					PhotoInfoBean bean = currentUserInfo.photoDatas.get(i);
					// 创建一个ImageView
					View itemView = View.inflate(mContext, R.layout.item_imageview_layout, null);
					if (Util.getScreenDensityDpi(mContext) >= 320) {
						itemView = View.inflate(mContext, R.layout.item_imageview_layout, null);
					} else {
						itemView = View.inflate(mContext, R.layout.item_imageview_layout_small, null);
					}
					FrameLayout box = (FrameLayout) itemView.findViewById(R.id.item_box);
					ImageView photoIv = (ImageView) itemView.findViewById(R.id.item_imageview);
					photoIv.setTag(i);
					photoIv.setScaleType(ScaleType.CENTER_CROP);
					J_NetManager.getInstance().loadIMG(null, bean.url_small, photoIv, R.drawable.pic_default_square,
							R.drawable.pic_default_square);
					photoIv.setOnClickListener(new OnClickListener() {
						@Override
						public void onClick(View v) {
							Intent photoIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
							photoIntent.putExtra("photoInfo", currentUserInfo.photoDatas);
							photoIntent.putExtra("index", Util.getInteger(v.getTag().toString()));
							photoIntent.putExtra("viewType", 2);
							startActivity(photoIntent);
						}
					});
					profile_album.addView(box);
				}
			}
		} else {
			profile_album_box.setVisibility(View.GONE);
		}
	}

}
