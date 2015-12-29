package com.iyouxun.ui.activity.center;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;

import org.json.JSONArray;
import org.json.JSONObject;

import android.content.Intent;
import android.net.Uri;
import android.os.Handler;
import android.os.Message;
import android.text.Html;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.FrameLayout;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.sina.weibo.SinaWeibo;

import com.iyouxun.R;
import com.iyouxun.comparator.PhotoComparator;
import com.iyouxun.comparator.TagListComparator;
import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.GroupsInfoBean;
import com.iyouxun.data.beans.NewsInfoBean;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.beans.TagsInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_FileManager;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.managers.J_NetManager.OnLoadingListener;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.GetUserInfoRequest;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.open.J_ShareParams;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.common.ClipPhoto;
import com.iyouxun.ui.activity.message.ChatMainActivity;
import com.iyouxun.ui.activity.news.NewsMainActivity;
import com.iyouxun.ui.activity.setting.SettingMainActivity;
import com.iyouxun.ui.dialog.PhotoSelectDialog;
import com.iyouxun.ui.dialog.SharePopDialog;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.utils.DLog;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.OpenPlatformUtil;
import com.iyouxun.utils.ProfileUtils;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.UploadPhotoDataAccess;
import com.iyouxun.utils.Util;

/**
 * 个人资料页页面（我的）
 * 
 * @author likai
 * @date 2015-2-28 上午10:43:40
 * 
 */
public class ProfileMainActivity extends CommTitleActivity {
	private CircularImage profile_avatar;// 头像
	private TextView profile_nick;// 昵称
	private TextView profile_location;// 位置
	private TextView profile_birthday;// 生日
	private LinearLayout profile_album;// 相册
	private TextView profile_news_info;// 动态信息
	private TextView profile_signer;// 签名
	private LinearLayout profile_tags;// 标签
	private LinearLayout profile_groups;// 群组
	private ImageButton profile_photo_add_button;// 添加新照片
	private TextView profile_main_edit_button;// 编辑资料按钮
	private TextView profile_marriage;// 婚姻状况
	private ImageView profile_sex;
	private ImageView profile_right_icon2;// 相册
	private RelativeLayout profile_news_box;// 动态
	private RelativeLayout profile_singer_box;// 签名
	private TextView setting_tags_edit_button;// 标签
	private TextView profile_right_icon6;// 群组
	private Button profile_main_setting_button;// 设置
	private ImageButton profile_tag_toggle;// 显示更多标签
	private TextView profile_confirm_invite;// 邀请好友帮我认证
	private TextView emptyTagView;// 空标签提示
	private Button titleRightButton;
	private ImageButton profile_group_toggle;// 群组展开折叠按钮

	private LinearLayout item_image_upload_box;

	// 裁剪返回值
	private final int RESULT_CODE_ERROR = 500;

	private final UploadPhotoDataAccess upload = new UploadPhotoDataAccess(this);

	private final ArrayList<TagsInfoBean> tagsData = new ArrayList<TagsInfoBean>();

	private View[] textViews;// 标签视图数组
	// 裁剪返回值
	private final int REQUEST_CODE_CUT = 106;
	/** 当前标签int[0]:标签总行数，int[1]:已经展示的行数 */
	private int showTagCell[] = { 0, 0 };
	/** 当前群组int[0]:群组总行数，int[1]:已经展示的行数 */
	private final int showGroupCell[] = { 0, 0 };

	// 动态信息
	private NewsInfoBean currentUserNewsInfo = new NewsInfoBean();

	/** 群组信息-需要显示的群组信息 */
	private final ArrayList<GroupsInfoBean> currentUserGroupsInfo = new ArrayList<GroupsInfoBean>();
	/** 群组信息-全部群组信息 */
	private final ArrayList<GroupsInfoBean> currentUserAllGroupsInfo = new ArrayList<GroupsInfoBean>();

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("我");

		titleRightButton.setText("求脱单");
		titleRightButton.setVisibility(View.VISIBLE);
		titleRightButton.setOnClickListener(listener);

		this.titleRightButton = titleRightButton;
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_profile_main, null);
	}

	@Override
	protected void initViews() {
		profile_avatar = (CircularImage) findViewById(R.id.profile_avatar);
		profile_nick = (TextView) findViewById(R.id.profile_nick);
		profile_album = (LinearLayout) findViewById(R.id.profile_album);
		profile_news_info = (TextView) findViewById(R.id.profile_news_info);
		profile_signer = (TextView) findViewById(R.id.profile_signer);
		profile_tags = (LinearLayout) findViewById(R.id.profile_tags);
		profile_groups = (LinearLayout) findViewById(R.id.profile_groups);
		profile_sex = (ImageView) findViewById(R.id.profile_sex);
		profile_right_icon2 = (ImageView) findViewById(R.id.profile_right_icon2);
		profile_news_box = (RelativeLayout) findViewById(R.id.profile_news_box);
		profile_singer_box = (RelativeLayout) findViewById(R.id.profile_singer_box);
		setting_tags_edit_button = (TextView) findViewById(R.id.setting_tags_edit_button);
		profile_right_icon6 = (TextView) findViewById(R.id.profile_right_icon6);
		profile_main_setting_button = (Button) findViewById(R.id.profile_main_setting_button);
		profile_main_edit_button = (TextView) findViewById(R.id.profile_main_edit_button);
		profile_marriage = (TextView) findViewById(R.id.profile_marriage);
		profile_tag_toggle = (ImageButton) findViewById(R.id.profile_tag_toggle);
		profile_confirm_invite = (TextView) findViewById(R.id.profile_confirm_invite);
		item_image_upload_box = (LinearLayout) findViewById(R.id.item_image_upload_box);
		emptyTagView = (TextView) findViewById(R.id.emptyTagView);
		profile_group_toggle = (ImageButton) findViewById(R.id.profile_group_toggle);
		profile_location = (TextView) findViewById(R.id.profile_location);
		profile_birthday = (TextView) findViewById(R.id.profile_birthday);

		profile_avatar.setOnClickListener(listener);
		profile_main_setting_button.setOnClickListener(listener);
		profile_right_icon2.setOnClickListener(listener);
		profile_news_box.setOnClickListener(listener);
		profile_singer_box.setOnClickListener(listener);
		setting_tags_edit_button.setOnClickListener(listener);
		profile_right_icon6.setOnClickListener(listener);
		profile_main_edit_button.setOnClickListener(listener);
		profile_nick.setOnClickListener(listener);
		profile_sex.setOnClickListener(listener);
		profile_marriage.setOnClickListener(listener);
		profile_tag_toggle.setOnClickListener(listener);
		profile_confirm_invite.setOnClickListener(listener);
		profile_group_toggle.setOnClickListener(listener);
	}

	@Override
	protected void onResume() {
		super.onResume();
		// 更新用户信息
		setContent();

		// 刷新用户信息
		refreshUserInfo();

		// 获取最新一条动态
		getOneUserDynamicList();

		// 获取用户的群组列表
		getGroupList();

		// 刷新标签信息
		getTagsList();
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
		UtilRequest.getGroupList(J_Cache.sLoginUser.uid + "", mHandler, mContext);
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
		UtilRequest.getOneUserDynamicList(J_Cache.sLoginUser.uid, 0, 10, mHandler);
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case 0x10001:
				String info = msg.obj.toString();
				ToastUtil.showToast(mContext, info);
				dismissLoading();
				break;
			case NetTaskIDs.TASKID_GROUP_LIST:
				// 获取用户的群组列表
				try {
					JSONArray groupArray = new JSONArray(msg.obj.toString());
					currentUserGroupsInfo.clear();
					currentUserAllGroupsInfo.clear();
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
						// 全部都会添加
						currentUserAllGroupsInfo.add(bean);
						if (bean.show == 1) {
							continue;
						} else {
							// 只添加可以显示的群组信息
							currentUserGroupsInfo.add(bean);
						}
					}

					// 刷新页面数据
					setUserGroupsInfo();
				} catch (Exception e) {
					e.printStackTrace();
				}
				break;
			case NetTaskIDs.TASKID_GET_ONE_USER_DYNAMIC_LIST:
				// 获取某位用户的动态列表
				J_Response response = (J_Response) msg.obj;
				if (response.retcode == 1) {
					try {
						JSONObject data = new JSONObject(response.data);
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
												pBean.nick = J_Cache.sLoginUser.nickName;
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
								// 接口请求多个，但只取一个是为了避免出现有动态被删除掉但仍返回结果的问题
								if (currentUserNewsInfo.feedId > 0) {
									break;
								}
							}
						} else {
							currentUserNewsInfo = new NewsInfoBean();
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}

				// 刷新页面 动态信息
				setUserNewsInfo();
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
						// 刷新列表
						refreshTags();
					} catch (Exception e) {
						e.printStackTrace();
					}
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
						// 刷新标签列表
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
	 * 刷新标签列表
	 * 
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
			tagView.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					UtilRequest.clickTag(mContext, J_Cache.sLoginUser.uid + "", bean.tid, mHandler);
				}
			});

			textViews[i] = tagView;
		}
		// 添加标签内容，并获取添加标签的行数
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
			// 没有可展示的标签，显示空标签提示
			profile_tags.removeAllViews();
			profile_tags.addView(emptyTagView);
			profile_tag_toggle.setVisibility(View.GONE);
		}
		// “编辑标签”按钮
		profile_tags.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent tagIntent = new Intent(mContext, ProfileTagsActivity.class);
				startActivity(tagIntent);
			}
		});
	}

	/**
	 * 获取标签列表
	 * 
	 * @Title: getTagsList
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getTagsList() {
		UtilRequest.getTagsList(mContext, J_Cache.sLoginUser.uid + "", mHandler);
	}

	/**
	 * 刷新用户信息
	 * 
	 * @Title: refreshUserInfo
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void refreshUserInfo() {
		new GetUserInfoRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				setContent();
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
			}
		}).execute(SharedPreUtil.getLoginInfo().uid + "");
	}

	/**
	 * 设置页面内容
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setContent() {
		// 头像
		J_NetManager.getInstance().loadIMG(null, J_Cache.sLoginUser.avatarUrl, profile_avatar, R.drawable.icon_avatar,
				R.drawable.icon_avatar);
		// 性别
		if (J_Cache.sLoginUser.sex == 0) {
			// 女
			profile_sex.setImageResource(R.drawable.icon_famale_b);
		} else {
			// 男
			profile_sex.setImageResource(R.drawable.icon_male_b);
		}
		// 个人资料
		profile_nick.setText(J_Cache.sLoginUser.nickName);
		// 婚姻状况
		profile_marriage.setText(Html.fromHtml("<font color=\"#303030\">情感状态: </font>"
				+ ProfileUtils.getMarriage(J_Cache.sLoginUser.marriage)));
		// 位置信息
		if (!Util.isBlankString(J_Cache.sLoginUser.locationName) && !Util.isBlankString(J_Cache.sLoginUser.subLocationName)) {
			profile_location.setVisibility(View.VISIBLE);
			profile_location.setText(J_Cache.sLoginUser.locationName + " " + J_Cache.sLoginUser.subLocationName);
		} else {
			profile_location.setVisibility(View.GONE);
		}
		// 生日信息
		if (J_Cache.sLoginUser.star > 0 && J_Cache.sLoginUser.birthpet > 0) {
			profile_birthday.setVisibility(View.VISIBLE);
			profile_birthday.setText(ProfileUtils.getStar(J_Cache.sLoginUser.star) + ","
					+ ProfileUtils.getBirthPet(J_Cache.sLoginUser.birthpet));
		} else {
			profile_birthday.setVisibility(View.GONE);
		}
		if (J_Cache.sLoginUser.marriage == 1) {
			// 单身
			// 显示“求脱单按钮”
			titleRightButton.setVisibility(View.VISIBLE);
			// 显示“邀请好友帮我认证”
			profile_confirm_invite.setVisibility(View.VISIBLE);
			profile_confirm_invite.setText("已有" + J_Cache.sLoginUser.lonelyConfirm + "人确认我是单身 邀请好友帮我认证");
		} else {
			titleRightButton.setVisibility(View.INVISIBLE);
			profile_confirm_invite.setVisibility(View.GONE);
		}
		// 相册信息
		setPhotoList();
		// 如果相册图片内容小于3张，不显示箭头
		// http://bugs.miuu.cn/index.php?r=info/edit&type=bug&id=9037
		if (J_Cache.sLoginUser.photoCount > 0) {
			profile_right_icon2.setVisibility(View.VISIBLE);
		} else {
			profile_right_icon2.setVisibility(View.GONE);
		}
		// 个人签名
		String cutString = "暂无签名";
		if (!Util.isBlankString(J_Cache.sLoginUser.intro)) {
			cutString = J_Cache.sLoginUser.intro;
			profile_signer.setTextColor(getResources().getColor(R.color.text_normal_black));
		} else {
			profile_signer.setTextColor(getResources().getColor(R.color.text_normal_gray));
		}
		profile_signer.setText(cutString);
	}

	/**
	 * 刷新群组信息
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setUserGroupsInfo() {
		profile_groups.removeAllViews();
		profile_group_toggle.setVisibility(View.GONE);
		// 当前展示的群组列表的数量
		int showNum = 0;
		// 设置群组总行数
		showGroupCell[0] = currentUserGroupsInfo.size();
		if (showGroupCell[1] <= 0) {
			// 初次初始化
			if (currentUserGroupsInfo.size() > 5) {
				showGroupCell[1] = 5;
			} else {
				showGroupCell[1] = currentUserGroupsInfo.size();
			}
		} else {
			if (showGroupCell[1] < 5) {
				if (currentUserGroupsInfo.size() >= 5) {
					showGroupCell[1] = 5;
				} else {
					showGroupCell[1] = currentUserGroupsInfo.size();
				}
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
				// 点击进行群聊
				item_group_name.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						Intent chatIntent = new Intent(mContext, ChatMainActivity.class);
						chatIntent.putExtra(UtilRequest.FORM_GROUP_ID, bean.id);
						chatIntent.putExtra(UtilRequest.FORM_NICK, bean.name);
						startActivity(chatIntent);
					}
				});
				// 自己的群组，不显示添加按钮
				item_group_add.setVisibility(View.INVISIBLE);
				profile_groups.addView(gView);
				showNum++;
			}
			// 显示编辑群组按钮
			profile_right_icon6.setVisibility(View.VISIBLE);
		}
		if (showNum <= 0) {
			// 没有加入群组，显示提示信息
			View gView = View.inflate(mContext, R.layout.item_profile_groups_layout, null);
			TextView item_group_name = (TextView) gView.findViewById(R.id.item_group_name);
			TextView item_goup_num = (TextView) gView.findViewById(R.id.item_goup_num);
			ImageButton item_group_add = (ImageButton) gView.findViewById(R.id.item_group_add);
			// 提示信息
			item_group_name.setText("暂无群组信息");
			item_group_name.setTextColor(getResources().getColor(R.color.text_normal_gray));
			// 隐藏群组人员数量
			item_goup_num.setVisibility(View.INVISIBLE);
			// 隐藏添加按钮
			item_group_add.setVisibility(View.INVISIBLE);
			// 折叠按钮
			profile_group_toggle.setVisibility(View.GONE);
			// 根据是否真的存在可编辑群组信息进行按钮显示的控制
			if (currentUserAllGroupsInfo.size() > 0) {
				profile_right_icon6.setVisibility(View.VISIBLE);
			} else {
				profile_right_icon6.setVisibility(View.INVISIBLE);
			}
			profile_groups.addView(gView);
		} else {
			if (currentUserGroupsInfo.size() > 5) {
				// 总数量大于5，显示折叠按钮
				profile_group_toggle.setVisibility(View.VISIBLE);
			} else {
				// 总数量小于5，隐藏折叠按钮
				profile_group_toggle.setVisibility(View.GONE);
			}
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
		if (content.equals("暂无动态信息")) {
			profile_news_info.setTextColor(getResources().getColor(R.color.text_normal_gray));
		} else {
			profile_news_info.setTextColor(getResources().getColor(R.color.text_normal_black));
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
		if (J_Cache.sLoginUser.photoDatas.size() > 0) {
			// 重新排序
			Collections.sort(J_Cache.sLoginUser.photoDatas, new PhotoComparator());
			for (int i = 0; i < J_Cache.sLoginUser.photoDatas.size(); i++) {
				// 最多显示3张照片
				if (i < 3) {
					// 获取一张照片
					PhotoInfoBean bean = J_Cache.sLoginUser.photoDatas.get(i);
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
					J_NetManager.getInstance().loadIMG(null, bean.url_small, photoIv, R.drawable.pic_default_square,
							R.drawable.pic_default_square);
					photoIv.setOnClickListener(new OnClickListener() {
						@Override
						public void onClick(View v) {
							Intent photoIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
							photoIntent.putExtra("photoInfo", J_Cache.sLoginUser.photoDatas);
							photoIntent.putExtra("index", Util.getInteger(v.getTag().toString()));
							startActivity(photoIntent);
						}
					});
					profile_album.addView(box);
				} else {
					J_Cache.sLoginUser.photoDatas.remove(i);
				}
			}
		}
		// 设置添加按钮
		View boxView = View.inflate(mContext, R.layout.item_image_upload_layout, null);
		if (Util.getScreenDensityDpi(mContext) >= 320) {
			boxView = View.inflate(mContext, R.layout.item_image_upload_layout, null);
		} else {
			boxView = View.inflate(mContext, R.layout.item_image_upload_layout_small, null);
		}
		profile_photo_add_button = (ImageButton) boxView.findViewById(R.id.profile_photo_add_button);
		profile_photo_add_button.setOnClickListener(listener);
		item_image_upload_box.removeAllViews();
		item_image_upload_box.addView(boxView);
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.profile_avatar:
				// 点击头像看大图
				if (J_Cache.sLoginUser.hasAvatar == 1) {
					Intent photoIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
					// 查看图片的data（单图）
					ArrayList<PhotoInfoBean> datas = new ArrayList<PhotoInfoBean>();
					PhotoInfoBean beanData = new PhotoInfoBean();
					beanData.url_small = J_Cache.sLoginUser.avatarUrl100;
					beanData.url = J_Cache.sLoginUser.avatarUrl200;
					beanData.uid = J_Cache.sLoginUser.uid;
					beanData.type = 2;
					beanData.pid = J_Cache.sLoginUser.avatarPid;
					beanData.nick = J_Cache.sLoginUser.nickName;
					datas.add(beanData);
					photoIntent.putExtra("photoInfo", datas);
					startActivity(photoIntent);
				}
				break;
			case R.id.titleRightButton:
				// 导航栏右侧“求脱单”
				J_ShareParams params = OpenPlatformUtil.getTuoDanParams();
				new SharePopDialog(ProfileMainActivity.this, R.style.dialog).setDialogTitle("求脱单").setParams(params)
						.setCallBack(new PlatformActionListener() {
							@Override
							public void onError(Platform arg0, int arg1, Throwable arg2) {
								DLog.d("likai-test", "onError");
								arg2.printStackTrace();
								mHandler.sendMessage(mHandler.obtainMessage(0x10001, "分享失败！！"));
							}

							@Override
							public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
								DLog.d("likai-test", "onComplete");
								if (!arg0.getName().equals(SinaWeibo.NAME)) {
									mHandler.sendMessage(mHandler.obtainMessage(0x10001, "分享成功！！"));
								}
							}

							@Override
							public void onCancel(Platform arg0, int arg1) {
								DLog.d("likai-test", "onCancel");
								mHandler.sendMessage(mHandler.obtainMessage(0x10001, "取消分享！！"));
							}
						}).show();
				break;
			case R.id.profile_confirm_invite:
				// 邀请好友帮我认证
				J_ShareParams params1 = OpenPlatformUtil.getFriendsHelpCertificate();
				new SharePopDialog(ProfileMainActivity.this, R.style.dialog).setDialogTitle("邀请好友帮我认证").setParams(params1)
						.setCallBack(new PlatformActionListener() {
							@Override
							public void onError(Platform arg0, int arg1, Throwable arg2) {
								mHandler.sendMessage(mHandler.obtainMessage(0x10001, "好友邀请失败！！"));
							}

							@Override
							public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
								if (!arg0.getName().equals(SinaWeibo.NAME)) {
									mHandler.sendMessage(mHandler.obtainMessage(0x10001, "好友邀请成功！！"));
								}
							}

							@Override
							public void onCancel(Platform arg0, int arg1) {
								mHandler.sendMessage(mHandler.obtainMessage(0x10001, "取消好友邀请！！"));
							}
						}).show();
				break;
			case R.id.profile_main_edit_button:
			case R.id.profile_nick:
			case R.id.profile_sex:
			case R.id.profile_marriage:
				// 编辑资料按钮
				Intent myProfileIntent = new Intent(mContext, ProfileDetailEditActivity.class);
				startActivity(myProfileIntent);
				break;
			case R.id.profile_main_setting_button:
				// 设置选项
				Intent settingIntent = new Intent(mContext, SettingMainActivity.class);
				startActivity(settingIntent);
				break;
			case R.id.profile_photo_add_button:
				// 弹出上传图片dialog
				new PhotoSelectDialog(mContext, R.style.dialog).setCallBack(new DialogUtils.OnSelectCallBack() {
					@Override
					public void onCallBack(String value1, String value2, String value3) {
						// 设置缓存文件名称
						upload.setCacheName("uploadUserPhoto");
						if (value1.equals("1")) {
							// 拍照
							upload.getHeaderFromCamera();
						} else if (value1.equals("2")) {
							// 相册
							upload.getHeaderFromGallery();
						}
					}
				}).show();
				break;
			case R.id.profile_right_icon2:
				// 相册
				Intent albumIntent = new Intent(mContext, ProfileAlbumActivity.class);
				albumIntent.putExtra("uid", J_Cache.sLoginUser.uid);
				albumIntent.putExtra("nick", J_Cache.sLoginUser.nickName);
				startActivity(albumIntent);
				break;
			case R.id.profile_news_box:
				// 动态
				Intent newsIntent = new Intent(mContext, NewsMainActivity.class);
				newsIntent.putExtra("type", 1);
				newsIntent.putExtra("uid", J_Cache.sLoginUser.uid);
				newsIntent.putExtra("userInfo", J_Cache.sLoginUser);
				startActivity(newsIntent);
				break;
			case R.id.profile_singer_box:
				// 签名
				Intent signIntent = new Intent(mContext, ProfileSignerActivity.class);
				startActivity(signIntent);
				break;
			case R.id.setting_tags_edit_button:
				// 标签
				Intent tagsIntent = new Intent(mContext, ProfileTagsActivity.class);
				startActivity(tagsIntent);
				break;
			case R.id.profile_tag_toggle:
				// 展开隐藏标签列表框
				toggleTag();
				break;
			case R.id.profile_group_toggle:
				// 展开隐藏群组列表框
				toggleGroup();
				break;
			case R.id.profile_right_icon6:
				// 群组
				Intent groupsIntent = new Intent(mContext, ProfileGroupActivity.class);
				startActivity(groupsIntent);
				break;
			default:
				break;
			}
		}
	};

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
		// 为了避免非硬件加速导致拖尾现象
		// refreshTags();
	}

	/**
	 * 展开闭合群组层
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

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent intent) {
		switch (requestCode) {
		case UploadPhotoDataAccess.REQUEST_ASK_CAMERA:// 拍照
			// 从拍照intent返回
			if (resultCode == -1) {
				// 获取原图地址
				String file_path_camera = J_FileManager.getInstance().getFileStore()
						.getFileSdcardAndRamPath(upload.getCacheName());
				// 跳转裁剪
				startPhotoZoomForAlbum(file_path_camera);
			}
			break;
		case UploadPhotoDataAccess.REQUEST_ASK_GALLERY:// 图库
			// TODO 此处是通过upload对象打开相册时，选择图片后返回处理
			if (intent != null) {
				try {
					Uri uri = intent.getData();
					long fileSize = getContentResolver().openInputStream(uri).available();
					if (fileSize < 2 * 1024) {
						ToastUtil.showToast(mContext, "图片尺寸不能小于2k");
					} else if (fileSize > 5 * 1024 * 1024) {
						ToastUtil.showToast(mContext, "图片尺寸不能大于5M");
					} else if (fileSize <= Util.getAvailaleSize()) {
						// 创建要裁剪的图片文件-原图
						InputStream is = getContentResolver().openInputStream(uri);
						File file_path = upload.copyBitmapToTempFile(is);
						// 获取要裁剪的图片path
						String file_path_gallery = file_path.getAbsolutePath();
						// 跳转裁剪
						startPhotoZoomForAlbum(file_path_gallery);
					} else {
						// 内存不够
						ToastUtil.showToast(mContext, getString(R.string.str_memory_not_enough));
					}
				} catch (FileNotFoundException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			break;
		case REQUEST_CODE_CUT:// 裁剪结束后图片处理106
			if (resultCode == 500) {
				// 图片尺寸太小
				ToastUtil.showToast(mContext, getString(R.string.str_photo_small_error));
				return;
			}
			// 从裁剪intent返回
			if (resultCode == -1 && intent != null) {
				// 对返回的图片进行处理
				String cutPhotoPath = intent.getStringExtra("avatarPath");
				uploadPhoto(cutPhotoPath);
			}
			break;
		case RESULT_CODE_ERROR:
			// 图片有问题
			ToastUtil.showToast(mContext, getString(R.string.str_photo_small_error));
			break;
		default:
			break;
		}
	}

	/**
	 * @Title: uploadPhoto
	 * @Description: 上传生活照
	 * @param @param pathName
	 * @return void
	 * @throws Exception
	 * @throws
	 * @date 2014-2-7
	 */
	public void uploadPhoto(String pathName) {
		try {
			if (!Util.isBlankString(pathName)) {
				// 执行上传操作
				showLoading("上传中...");
				File file = new File(pathName);
				if (file.exists()) {
					HashMap<String, String> param = new HashMap<String, String>();
					param.put("uid", SharedPreUtil.getLoginInfo().uid + "");
					J_NetManager.getInstance().uploadFile(NetConstans.UPLOAD_PHOTO_URL, param, pathName, new OnLoadingListener() {
						@Override
						public void startLoading() {
						}

						@Override
						public void onfinishLoading(String result) {
							try {
								JSONObject json = new JSONObject(result);
								int retcode = json.optInt("retcode");
								String retmean = json.optString("retmean");
								if (retcode == 1) {
									JSONObject photoData = json.optJSONObject("data");
									PhotoInfoBean bean = new PhotoInfoBean();
									bean.uid = J_Cache.sLoginUser.uid;
									bean.url_small = photoData.optString("300");
									bean.url = photoData.optString("800");
									bean.pid = photoData.optString("pid");
									bean.nick = J_Cache.sLoginUser.nickName;
									bean.uploadTime = System.currentTimeMillis() / 1000;
									J_Cache.sLoginUser.photoDatas.add(0, bean);
									// 解析上传图片的地址，添加到列表中，然后刷新4图
									setPhotoList();
									// 刷新用户信息
									refreshUserInfo();
									ToastUtil.showToast(mContext, "图片上传成功");
								} else if (retcode == -5) {
									// 图片尺寸应该大于100x100

								} else {
									ToastUtil.showToast(mContext, "图片上传失败:" + retmean);
								}
							} catch (Exception e) {
								e.printStackTrace();
							}
							dismissLoading();
						}

						@Override
						public void onLoading(long total, long current, boolean isUploading) {
						}

						@Override
						public void onError() {
							ToastUtil.showToast(mContext, "图片上传失败");
							dismissLoading();
						}
					});
				} else {
					DLog.d("likai-test", "上传文件不存在");
				}
			} else {
				DLog.d("likai-test", "图片地址为空");
			}
		} catch (Exception e) {
			ToastUtil.showToast(this, getString(R.string.str_upload_photo_fail));
			e.printStackTrace();
		}
	}

	/**
	 * 跳转至照片裁剪
	 * 
	 * */
	public void startPhotoZoomForAlbum(String path) {
		Intent intent = new Intent(this, ClipPhoto.class);
		intent.putExtra("path", path);
		intent.putExtra("isAvatar", false);
		startActivityForResult(intent, REQUEST_CODE_CUT);
	}
}
