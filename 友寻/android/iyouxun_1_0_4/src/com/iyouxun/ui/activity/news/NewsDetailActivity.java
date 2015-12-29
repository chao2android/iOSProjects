package com.iyouxun.ui.activity.news;

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
import android.text.TextPaint;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.text.util.Linkify;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.AdapterView.OnItemLongClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.comparator.CommentComparator;
import com.iyouxun.comparator.PhotoByPidComparator;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.beans.CommentInfoBean;
import com.iyouxun.data.beans.NewsInfoBean;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.beans.users.BaseUser;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.DelCommentRequest;
import com.iyouxun.net.request.DelDynamicRequest;
import com.iyouxun.net.request.DelPraiseRequest;
import com.iyouxun.net.request.GetOneDynamicInfoRequest;
import com.iyouxun.net.request.J_OnDataBack;
import com.iyouxun.net.request.RebroadcastDynamicRequest;
import com.iyouxun.net.request.SendCommentRequest;
import com.iyouxun.net.request.SendPraiseRequest;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.net.response.ReplyCommentRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.center.ProfilePhotoViewActivity;
import com.iyouxun.ui.activity.center.ProfileViewActivity;
import com.iyouxun.ui.adapter.CommentListAdapter;
import com.iyouxun.ui.adapter.NewsListPhotoAdapter;
import com.iyouxun.ui.views.NewsFaceRelativeLayout;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.ImageUtils;
import com.iyouxun.utils.TimeUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 动态详情页
 * 
 * @author likai
 * @date 2015-3-24 上午10:40:27
 * 
 */
public class NewsDetailActivity extends CommTitleActivity {
	private ListView newsDetailListView;
	// 公共输入框
	private RelativeLayout news_global_edittext_box;// 键盘层
	private NewsFaceRelativeLayout faceRelativeLayout;// 键盘
	private Button btn_setting_msg;// 发送评论按钮
	private EditText input_msg_text;// 评论输入框

	private View convertView;

	// 多图列表
	public NewsListPhotoAdapter photoAdapter;
	// 评论列表
	private CommentListAdapter commentAdapter;

	private ImageView newsUserAvatar;// 头像
	private TextView newsDataInfo;// 时间
	private TextView newsUserNick;// 昵称
	private ImageView newsUserSex;// 性别
	private TextView newsTitleInfo;// 标题
	private ImageView newsContentTypePhotoOne;// 单张图片
	private LinearLayout newsContentTypePhotoBox;
	private GridView newsContentTypePhoto;// 图片列表(2张以上图片)
	private TextView newsCommentNum;// 评论数
	private TextView newsReBroadcastNum;// 转播数
	private TextView newsPraiseNum;// 赞的数量
	private TextView newsLikeInfo;
	private TextView newsRelayInfo;
	private TextView newsUserFriendDimen;// 朋友类型
	private TextView newsContent;// 标题

	// 转播的内容
	private LinearLayout newsRelayContentBox;
	private TextView newsRelayNick;
	private ImageView newsRelaySex;
	private TextView newsRelayDate;
	private TextView newsRelayTitleInfo;
	private LinearLayout newsRelayContentTypePhotoOneBox;
	private ImageView newsRelayContentTypePhotoOne;
	private GridView newsRelayContentTypePhoto;
	private TextView newsRelayContent;

	private LinearLayout newsFriendsInfoBox;// 赞、评论、转播的详细页面

	private LinearLayout newsContentTypePhotoOneBox;

	private LinearLayout newsLikeInfoBox;
	private LinearLayout newsRelayInfoBox;

	private RelativeLayout newsRelayUserBox;
	private LinearLayout newsRelayDetailInfo;

	private NewsInfoBean detaiNewsData = new NewsInfoBean();
	/** 1:评论动态，2：回复评论 */
	private int CURRENT_MANAGE_TYPE = 0;
	/** 当前评论的评论内容 */
	private CommentInfoBean CURRENT_REPLY_COMMENT;
	// 赞、取消赞的小图标
	private ImageView praise_anim_icon;
	private ImageView rebroadcast_anim_icon;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("动态");
		// 左侧返回
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
		// 右侧-如果当前动态是我发布的动态，可以进行删除操作
		titleRightButton.setText("删除");
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_news_detail, null);
	}

	@Override
	protected void initViews() {
		// 获取当前需要展示的动态id
		int feedId = getIntent().getIntExtra("feedId", 0);

		newsDetailListView = (ListView) findViewById(R.id.newsDetailListView);
		news_global_edittext_box = (RelativeLayout) findViewById(R.id.news_global_edittext_box);
		btn_setting_msg = (Button) findViewById(R.id.btn_setting_msg);
		input_msg_text = (EditText) findViewById(R.id.input_msg_text);
		faceRelativeLayout = (NewsFaceRelativeLayout) findViewById(R.id.FaceRelativeLayout);

		convertView = View.inflate(mContext, R.layout.item_news_detail_layout, null);

		newsUserAvatar = (ImageView) convertView.findViewById(R.id.newsUserAvatar);
		newsDataInfo = (TextView) convertView.findViewById(R.id.newsDataInfo);
		newsUserNick = (TextView) convertView.findViewById(R.id.newsUserNick);
		newsUserSex = (ImageView) convertView.findViewById(R.id.newsUserSex);
		newsTitleInfo = (TextView) convertView.findViewById(R.id.newsTitleInfo);
		newsContentTypePhotoBox = (LinearLayout) convertView.findViewById(R.id.newsContentTypePhotoBox);
		newsContentTypePhotoOne = (ImageView) convertView.findViewById(R.id.newsContentTypePhotoOne);
		newsContentTypePhoto = (GridView) convertView.findViewById(R.id.newsContentTypePhoto);
		newsCommentNum = (TextView) convertView.findViewById(R.id.newsCommentNum);
		newsReBroadcastNum = (TextView) convertView.findViewById(R.id.newsReBroadcastNum);
		newsPraiseNum = (TextView) convertView.findViewById(R.id.newsPraiseNum);
		newsLikeInfo = (TextView) convertView.findViewById(R.id.newsLikeInfo);
		newsRelayInfo = (TextView) convertView.findViewById(R.id.newsRelayInfo);
		newsUserFriendDimen = (TextView) convertView.findViewById(R.id.newsUserFriendDimen);
		newsContent = (TextView) convertView.findViewById(R.id.newsContent);

		newsRelayContentBox = (LinearLayout) convertView.findViewById(R.id.newsRelayContentBox);
		newsRelayNick = (TextView) convertView.findViewById(R.id.newsRelayNick);
		newsRelaySex = (ImageView) convertView.findViewById(R.id.newsRelaySex);
		newsRelayDate = (TextView) convertView.findViewById(R.id.newsRelayDate);
		newsRelayTitleInfo = (TextView) convertView.findViewById(R.id.newsRelayTitleInfo);
		newsRelayContentTypePhotoOneBox = (LinearLayout) convertView.findViewById(R.id.newsRelayContentTypePhotoOneBox);
		newsRelayContentTypePhotoOne = (ImageView) convertView.findViewById(R.id.newsRelayContentTypePhotoOne);
		newsRelayContentTypePhoto = (GridView) convertView.findViewById(R.id.newsRelayContentTypePhoto);
		newsRelayContent = (TextView) convertView.findViewById(R.id.newsRelayContent);
		newsFriendsInfoBox = (LinearLayout) convertView.findViewById(R.id.newsFriendsInfoBox);

		newsContentTypePhotoOneBox = (LinearLayout) convertView.findViewById(R.id.newsContentTypePhotoOneBox);
		newsLikeInfoBox = (LinearLayout) convertView.findViewById(R.id.newsLikeInfoBox);
		newsRelayInfoBox = (LinearLayout) convertView.findViewById(R.id.newsRelayInfoBox);

		newsRelayUserBox = (RelativeLayout) convertView.findViewById(R.id.newsRelayUserBox);
		newsRelayDetailInfo = (LinearLayout) convertView.findViewById(R.id.newsRelayDetailInfo);

		// 把动态详情信息添加到header中
		newsDetailListView.addHeaderView(convertView);

		// 设置listview的adapter
		commentAdapter = new CommentListAdapter(mContext);
		commentAdapter.setData(detaiNewsData.comment);
		newsDetailListView.setAdapter(commentAdapter);

		// 点击回复
		newsDetailListView.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				int headerCount = newsDetailListView.getHeaderViewsCount();
				final int realPosition = position - headerCount;
				if (realPosition >= 0) {
					if (J_Cache.sLoginUser.marriage == 1 && J_Cache.sLoginUser.callno_upload == 0
							&& J_Cache.sLoginUser.friends_num == 0 && J_Cache.sLoginUser.uid != detaiNewsData.uid) {

					} else {
						final CommentInfoBean bean = detaiNewsData.comment.get(realPosition);
						CURRENT_MANAGE_TYPE = 2;
						CURRENT_REPLY_COMMENT = bean;
						String eTHint = "回复" + bean.nick + ":";
						// 显示输入框
						showKeyboard(eTHint);
					}
				}
			}
		});

		// 长按删除
		newsDetailListView.setOnItemLongClickListener(new OnItemLongClickListener() {
			@Override
			public boolean onItemLongClick(AdapterView<?> parent, View view, final int position, long id) {
				int headerCount = newsDetailListView.getHeaderViewsCount();
				final int realPosition = position - headerCount;
				if (realPosition >= 0) {
					final CommentInfoBean bean = detaiNewsData.comment.get(realPosition);
					if (bean.uid == J_Cache.sLoginUser.uid || detaiNewsData.uid == J_Cache.sLoginUser.uid) {
						DialogUtils.showPromptDialog(mContext, "删除评论", "确定删除该条评论？", new OnSelectCallBack() {
							@Override
							public void onCallBack(String value1, String value2, String value3) {
								if (value1.equals("0")) {
									// 确定
									delComment(realPosition);
								}
							}
						});
					}
				}
				return true;
			}
		});

		final View animView = View.inflate(mContext, R.layout.praise_rebroadcast_anim_layer, null);
		praise_anim_icon = (ImageView) animView.findViewById(R.id.praise_anim_icon);
		rebroadcast_anim_icon = (ImageView) animView.findViewById(R.id.rebroadcast_anim_icon);
		getRootView().addView(animView);

		// 点击事件
		btn_setting_msg.setOnClickListener(listener);
		newsRelayNick.setOnClickListener(listener);
		newsContent.setOnTouchListener(new OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				if (event.getAction() == MotionEvent.ACTION_DOWN) {
					String text = newsContent.getText().toString();
					long uid = Util.hasUserProfileUrl(text);
					if (uid > 0) {
						Intent intent = new Intent(mContext, ProfileViewActivity.class);
						intent.putExtra(UtilRequest.FORM_UID, uid);
						startActivity(intent);
						return true;
					}
				}
				return false;
			}
		});
		newsRelayContent.setOnTouchListener(new OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				if (event.getAction() == MotionEvent.ACTION_DOWN) {
					String text = newsRelayContent.getText().toString();
					long uid = Util.hasUserProfileUrl(text);
					if (uid > 0) {
						Intent intent = new Intent(mContext, ProfileViewActivity.class);
						intent.putExtra(UtilRequest.FORM_UID, uid);
						startActivity(intent);
						return true;
					}
				}
				return false;
			}
		});
		// 请求获取动态的详细信息
		getNewsDetailInfo(feedId);
	}

	/**
	 * 删除评论
	 * 
	 * @Title: delComment
	 * @return void 返回类型
	 * @param @param position 参数类型
	 * @author likai
	 * @throws
	 */
	private void delComment(final int position) {
		int dy_id = detaiNewsData.feedId;
		long dy_uid = detaiNewsData.uid;
		int comment_id = detaiNewsData.comment.get(position).id;

		showLoading();
		new DelCommentRequest(new J_OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					// 删除成功
					detaiNewsData.comment.remove(position);
					// 更新评论数
					detaiNewsData.commentCount -= 1;
					newsCommentNum.setText(detaiNewsData.commentCount + "评论");
					// 刷新数据
					commentAdapter.setData(detaiNewsData.comment);
					commentAdapter.notifyDataSetChanged();
				}
				dismissLoading();
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				super.onError(errorMap);
				dismissLoading();
			}
		}).execute(dy_id, dy_uid, comment_id);
	}

	/**
	 * 获取该条动态的详细信息
	 * 
	 * @Title: getNewsDetailInfo
	 * @return void 返回类型
	 * @param @param feedId 参数类型
	 * @author likai
	 * @throws
	 */
	private void getNewsDetailInfo(int feedId) {
		showLoading();

		new GetOneDynamicInfoRequest(new J_OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					try {
						JSONObject singleData = new JSONObject(response.data);
						NewsInfoBean bean = new NewsInfoBean();
						bean.feedId = singleData.optInt("feedid");
						bean.uid = singleData.optLong("uid");
						bean.nick = singleData.optString("nick");
						bean.date = singleData.optString("time");
						String avatarStr = singleData.optString("avatars");
						if (!avatarStr.equals("false") && !avatarStr.equals("{}") && !Util.isBlankString(avatarStr)) {
							JSONObject avatars = singleData.optJSONObject("avatars");
							bean.avatar = avatars.optString("100");
						}
						bean.type = singleData.optInt("type");
						bean.sex = singleData.optInt("sex");
						bean.friendDimen = singleData.optInt("friend");
						bean.praiseCount = singleData.optInt("praise_num");
						bean.rebroadcastCount = singleData.optInt("rebroadcast_num");
						bean.commentCount = singleData.optInt("comment_num");
						bean.is_comment = singleData.optInt("is_comment");
						bean.is_praise = singleData.optInt("is_praise");
						bean.is_rebroadcast = singleData.optInt("is_rebroadcast");
						bean.marriage = singleData.optInt("marriage");
						bean.status = singleData.optInt("status");
						// 赞列表
						if (singleData.has("praise_list")) {
							JSONArray praiseList = singleData.optJSONArray("praise_list");
							for (int j = 0; j < praiseList.length(); j++) {
								BaseUser praiseUser = new BaseUser();
								praiseUser.uid = praiseList.optJSONObject(j).optLong("uid");
								praiseUser.nickName = praiseList.optJSONObject(j).optString("nick");
								bean.praisePeople.add(praiseUser);
							}
						}
						// 转播列表
						if (singleData.has("rebroadcast_list")) {
							JSONArray rebroadcastList = singleData.optJSONArray("rebroadcast_list");
							for (int m = 0; m < rebroadcastList.length(); m++) {
								BaseUser rebroadcastUser = new BaseUser();
								rebroadcastUser.uid = rebroadcastList.optJSONObject(m).optLong("uid");
								rebroadcastUser.nickName = rebroadcastList.optJSONObject(m).optString("nick");
								bean.rebroadcastPeople.add(rebroadcastUser);
							}
						}
						// 评论列表
						if (singleData.has("comment_list")) {
							JSONArray commentList = singleData.optJSONArray("comment_list");
							for (int n = 0; n < commentList.length(); n++) {
								// 解析说该条信息的内容
								JSONObject tempComment = commentList.optJSONObject(n);
								// 创建一个新bean
								CommentInfoBean commentInfo = new CommentInfoBean();
								// 检查回复内容情况，如果有回复内容，说明该条评论会回复他人评论的评论
								String replyInfo = tempComment.optString("reply");
								if (!Util.isBlankString(replyInfo)) {
									JSONObject replyObj = tempComment.optJSONObject("reply");
									commentInfo.replyId = replyObj.optInt("id");
									commentInfo.replyNick = replyObj.optString("nick");
									commentInfo.replySex = replyObj.optInt("sex");
									commentInfo.replyUid = replyObj.optLong("uid");
									JSONObject replyAvatarObj = replyObj.optJSONObject("avatar");
									commentInfo.replyAvatar = replyAvatarObj.optString("100");
								}
								commentInfo.id = tempComment.optInt("id");
								commentInfo.uid = tempComment.optLong("uid");
								commentInfo.nick = tempComment.optString("nick");
								commentInfo.sex = tempComment.optInt("sex");
								commentInfo.content = tempComment.optString("content");
								JSONObject avatarObj = tempComment.optJSONObject("avatar");
								commentInfo.avatar = avatarObj.optString("100");
								commentInfo.time = tempComment.optString("time");
								bean.comment.add(commentInfo);
							}
						}
						if (bean.type == 100) {
							// 文字信息
							JSONObject newsData = singleData.optJSONObject("data");
							bean.content = newsData.optString("content");
							bean.content = Util.delSimpleHTMLTag(bean.content);
							// 过滤无效数据
							if (Util.isBlankString(bean.content)) {
								bean.status = -1;
							}
						} else if (bean.type == 101) {
							// 图片信息
							// 动态内容
							JSONObject newsData = singleData.optJSONObject("data");
							bean.content = newsData.optString("content");
							bean.content = Util.delSimpleHTMLTag(bean.content);
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
										pBean.nick = bean.nick;
										pBean.uid = bean.uid;
										bean.contentPhoto.add(pBean);
									}
								}
								// 重新排序
								Collections.sort(bean.contentPhoto, new PhotoByPidComparator());
							} else {
								// 过滤无效数据
								bean.status = -1;
							}
						} else if (bean.type == 500) {
							// 转播文字
							// 动态内容
							JSONObject newsData = singleData.optJSONObject("data");
							bean.relayContent = newsData.optString("content");
							bean.relayContent = Util.delSimpleHTMLTag(bean.relayContent);
							bean.relayUid = newsData.optLong("uid");
							bean.relayNick = newsData.optString("nick");
							bean.relayType = newsData.optInt("type");
							bean.relaySex = newsData.optInt("sex");
							JSONObject avatarsRelay = newsData.optJSONObject("avatar");
							bean.relayAvatar = avatarsRelay.optString("100");
							bean.relayFeedId = newsData.optInt("feedid");
							bean.relayDate = newsData.optString("time");
							bean.relayStatus = newsData.optInt("status");
							// 过滤无效数据
							if (Util.isBlankString(bean.relayContent)) {
								bean.status = -1;
							}
						} else if (bean.type == 501) {
							// 转播图片
							// 动态内容
							JSONObject newsData = singleData.optJSONObject("data");
							bean.relayContent = newsData.optString("content");
							bean.relayContent = Util.delSimpleHTMLTag(bean.relayContent);
							bean.relayUid = newsData.optLong("uid");
							bean.relayNick = newsData.optString("nick");
							bean.relayType = newsData.optInt("type");
							bean.relaySex = newsData.optInt("sex");
							JSONObject avatarsRelay = newsData.optJSONObject("avatar");
							bean.relayAvatar = avatarsRelay.optString("100");
							bean.relayFeedId = newsData.optInt("feedid");
							bean.relayDate = newsData.optString("time");
							bean.relayStatus = newsData.optInt("status");
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
										pBean.uid = bean.relayUid;
										bean.relayContentPhoto.add(pBean);
									}
								}
								// 重新排序
								Collections.sort(bean.relayContentPhoto, new PhotoByPidComparator());
							} else {
								// 过滤无效数据
								bean.status = -1;
							}
						}
						// 直接通过赋值形式，方便几个页面同改
						detaiNewsData = bean;

						// 获取到数据后，进行页面数据刷新
						setContent();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				dismissLoading();
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				super.onError(errorMap);
				dismissLoading();
			}
		}).execute(feedId);
	}

	/**
	 * 设置页面显示数据
	 * 
	 * @Title: setContent
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setContent() {
		if (detaiNewsData.feedId <= 0 || detaiNewsData.status == -1) {
			if (detaiNewsData.status == -1) {
				newsDetailListView.removeHeaderView(convertView);
				// 添加空数据信息
				View emptyLayer = View.inflate(mContext, R.layout.empty_layer, null);
				TextView tv = (TextView) emptyLayer.findViewById(R.id.emptyTv);
				tv.setText("该动态不存在");
				((ViewGroup) newsDetailListView.getParent()).addView(emptyLayer);
				newsDetailListView.setEmptyView(emptyLayer);
			}
			return;
		}
		if (detaiNewsData.uid == J_Cache.sLoginUser.uid) {
			// 当前动态为登录用户的动态，可以进行删除操作
			titleRightButton.setVisibility(View.VISIBLE);
		}
		// 头像
		J_NetManager.getInstance().loadIMG(null, detaiNewsData.avatar, newsUserAvatar, R.drawable.icon_avatar,
				R.drawable.icon_avatar);
		// 昵称
		newsUserNick.setText(detaiNewsData.nick);
		// 性别
		if (detaiNewsData.sex == 0) {
			// 女
			newsUserSex.setImageResource(R.drawable.icon_famale_s);
		} else {
			// 男
			newsUserSex.setImageResource(R.drawable.icon_male_s);
		}
		// 时间
		newsDataInfo.setText(TimeUtil.getStandardDate(detaiNewsData.date));
		// 朋友类型
		if (detaiNewsData.uid != J_Cache.sLoginUser.uid) {
			if (detaiNewsData.friendDimen == 1) {
				newsUserFriendDimen.setText("我的朋友");
			} else if (detaiNewsData.friendDimen == 2) {
				newsUserFriendDimen.setText("好友的好友");
			}
			newsUserFriendDimen.setVisibility(View.VISIBLE);
		} else {
			newsUserFriendDimen.setVisibility(View.GONE);
		}

		// TODO 自动识别文本中的连接地址
		newsContent.setAutoLinkMask(Linkify.WEB_URLS);
		newsRelayContent.setAutoLinkMask(Linkify.WEB_URLS);
		newsContent.setLinksClickable(false);
		newsRelayContent.setLinksClickable(false);

		// 标题
		if (detaiNewsData.type == 100) {
			// 发布文字内容
			// 标题
			if (detaiNewsData.marriage == 1) {
				newsTitleInfo.setText("单身");
			} else if (detaiNewsData.marriage == 2) {
				newsTitleInfo.setText("恋爱中");
			} else if (detaiNewsData.marriage == 3) {
				newsTitleInfo.setText("已婚");
			} else {
				newsTitleInfo.setText("保密");
			}
			// 内容
			if (!Util.isBlankString(detaiNewsData.content)) {
				newsContent.setText(Util.replaceTagStyleContent(detaiNewsData.content));
				newsContent.setVisibility(View.VISIBLE);
			} else {
				newsContent.setVisibility(View.GONE);
			}
			// 隐藏图片列表
			newsContentTypePhotoBox.setVisibility(View.GONE);
			newsContentTypePhotoOneBox.setVisibility(View.GONE);
			// 隐藏转播动态
			newsRelayContentBox.setVisibility(View.GONE);
		} else if (detaiNewsData.type == 101) {
			// 图片动态
			// 标题
			if (detaiNewsData.marriage == 1) {
				newsTitleInfo.setText("单身");
			} else if (detaiNewsData.marriage == 2) {
				newsTitleInfo.setText("恋爱中");
			} else if (detaiNewsData.marriage == 3) {
				newsTitleInfo.setText("已婚");
			} else {
				newsTitleInfo.setText("保密");
			}
			// 内容
			if (!Util.isBlankString(detaiNewsData.content)) {
				newsContent.setText(detaiNewsData.content);
				newsContent.setVisibility(View.VISIBLE);
			} else {
				newsContent.setVisibility(View.GONE);
			}
			// 图片列表
			// 隐藏图片列表
			newsContentTypePhotoBox.setVisibility(View.GONE);
			newsContentTypePhotoOneBox.setVisibility(View.GONE);
			// 隐藏转播动态
			newsRelayContentBox.setVisibility(View.GONE);
			if (detaiNewsData.contentPhoto.size() == 1) {
				// 单张图片
				// 设置图片宽高
				ImageUtils.setImageViewSizeFromUrl(newsContentTypePhotoOne, detaiNewsData.contentPhoto.get(0).url_small);
				// 加载图片
				J_NetManager.getInstance().loadIMG(null, detaiNewsData.contentPhoto.get(0).url_small, newsContentTypePhotoOne,
						R.drawable.pic_default_square, R.drawable.pic_default_square);
				// 设置该项目显示
				newsContentTypePhotoOneBox.setVisibility(View.VISIBLE);
				newsContentTypePhotoOne.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						Intent albumIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
						albumIntent.putExtra("photoInfo", detaiNewsData.contentPhoto);
						mContext.startActivity(albumIntent);
					}
				});
			} else if (detaiNewsData.contentPhoto.size() > 1) {
				// 使用gridview
				photoAdapter = new NewsListPhotoAdapter(mContext);
				photoAdapter.setData(detaiNewsData.contentPhoto);
				newsContentTypePhoto.setAdapter(photoAdapter);
				photoAdapter.notifyDataSetChanged();
				// 设置该项目显示
				newsContentTypePhotoBox.setVisibility(View.VISIBLE);
				newsContentTypePhoto.setOnItemClickListener(new OnItemClickListener() {
					@Override
					public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
						Intent albumIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
						albumIntent.putExtra("photoInfo", detaiNewsData.contentPhoto);
						albumIntent.putExtra("index", position);
						mContext.startActivity(albumIntent);
					}
				});
			}
		} else if (detaiNewsData.type == 501) {
			// 转播图片
			newsRelayContentBox.setVisibility(View.VISIBLE);
			if (detaiNewsData.marriage == 1) {
				newsTitleInfo.setText(Html.fromHtml("单身<br />转播动态"));
			} else if (detaiNewsData.marriage == 2) {
				newsTitleInfo.setText(Html.fromHtml("恋爱中<br />转播动态"));
			} else if (detaiNewsData.marriage == 3) {
				newsTitleInfo.setText(Html.fromHtml("已婚<br />转播动态"));
			} else {
				newsTitleInfo.setText(Html.fromHtml("保密<br />转播动态"));
			}
			if (detaiNewsData.relayStatus == -1) {
				// 已删除
				newsContent.setVisibility(View.GONE);
				newsContentTypePhotoOneBox.setVisibility(View.GONE);
				newsContentTypePhotoBox.setVisibility(View.GONE);
				newsRelayUserBox.setVisibility(View.GONE);
				newsRelayDetailInfo.setVisibility(View.GONE);
				newsRelayTitleInfo.setText("该内容已被作者删除");
			} else {
				// 内容
				if (!Util.isBlankString(detaiNewsData.content)) {
					newsContent.setText(detaiNewsData.content);
					newsContent.setVisibility(View.VISIBLE);
				} else {
					newsContent.setVisibility(View.GONE);
				}
				// 昵称
				newsRelayNick.setText(detaiNewsData.relayNick);
				// 性别
				if (detaiNewsData.relaySex == 0) {
					// 女
					newsRelaySex.setImageResource(R.drawable.icon_famale_s);
				} else {
					// 男
					newsRelaySex.setImageResource(R.drawable.icon_male_s);
				}
				// 日期
				newsRelayDate.setText(TimeUtil.getStandardDate(detaiNewsData.relayDate));
				// 标题
				if (detaiNewsData.relayType == 101) {
					newsRelayTitleInfo.setText("发表图片");
				} else {
					newsRelayTitleInfo.setText("发布内容");
				}
				// 内容
				if (!Util.isBlankString(detaiNewsData.relayContent)) {
					newsRelayTitleInfo.setVisibility(View.GONE);
					newsRelayContent.setText(detaiNewsData.relayContent);
					newsRelayContent.setVisibility(View.VISIBLE);
				} else {
					newsRelayTitleInfo.setVisibility(View.VISIBLE);
					newsRelayContent.setVisibility(View.GONE);
				}
				// 图片列表
				newsContentTypePhotoBox.setVisibility(View.GONE);
				newsContentTypePhotoOneBox.setVisibility(View.GONE);
				newsRelayContentTypePhoto.setVisibility(View.GONE);
				newsRelayContentTypePhotoOneBox.setVisibility(View.GONE);
				if (detaiNewsData.relayContentPhoto.size() == 1) {
					// 单张图片
					// 设置图片宽高
					ImageUtils.setImageViewSizeFromUrl(newsRelayContentTypePhotoOne,
							detaiNewsData.relayContentPhoto.get(0).url_small);
					// 加载图片
					J_NetManager.getInstance().loadIMG(null, detaiNewsData.relayContentPhoto.get(0).url_small,
							newsRelayContentTypePhotoOne, R.drawable.pic_default_square, R.drawable.pic_default_square);
					// 显示该项目
					newsRelayContentTypePhotoOneBox.setVisibility(View.VISIBLE);
					newsRelayContentTypePhotoOne.setOnClickListener(new OnClickListener() {
						@Override
						public void onClick(View v) {
							Intent albumIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
							albumIntent.putExtra("photoInfo", detaiNewsData.relayContentPhoto);
							mContext.startActivity(albumIntent);
						}
					});
				} else if (detaiNewsData.relayContentPhoto.size() > 1) {
					// 使用gridview
					photoAdapter = new NewsListPhotoAdapter(mContext);
					photoAdapter.setData(detaiNewsData.relayContentPhoto);
					newsRelayContentTypePhoto.setAdapter(photoAdapter);
					photoAdapter.notifyDataSetChanged();
					// 显示该项目
					newsRelayContentTypePhoto.setVisibility(View.VISIBLE);
					newsRelayContentTypePhoto.setOnItemClickListener(new OnItemClickListener() {
						@Override
						public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
							Intent albumIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
							albumIntent.putExtra("photoInfo", detaiNewsData.relayContentPhoto);
							albumIntent.putExtra("index", position);
							mContext.startActivity(albumIntent);
						}
					});
				}
			}
		} else if (detaiNewsData.type == 500) {
			// 转播文字
			newsRelayContentBox.setVisibility(View.VISIBLE);
			// 标题
			if (detaiNewsData.marriage == 1) {
				newsTitleInfo.setText(Html.fromHtml("单身<br />转播动态"));
			} else if (detaiNewsData.marriage == 2) {
				newsTitleInfo.setText(Html.fromHtml("恋爱中<br />转播动态"));
			} else if (detaiNewsData.marriage == 3) {
				newsTitleInfo.setText(Html.fromHtml("已婚<br />转播动态"));
			} else {
				newsTitleInfo.setText(Html.fromHtml("保密<br />转播动态"));
			}
			if (detaiNewsData.relayStatus == -1) {
				// 已删除
				newsContent.setVisibility(View.GONE);
				newsContentTypePhotoOneBox.setVisibility(View.GONE);
				newsContentTypePhotoBox.setVisibility(View.GONE);
				newsRelayUserBox.setVisibility(View.GONE);
				newsRelayDetailInfo.setVisibility(View.GONE);
				newsRelayTitleInfo.setText("该内容已被作者删除");
				newsRelayTitleInfo.setVisibility(View.VISIBLE);
			} else {
				// 内容
				if (!Util.isBlankString(detaiNewsData.content)) {
					newsContent.setText(detaiNewsData.content);
					newsContent.setVisibility(View.VISIBLE);
				} else {
					newsContent.setVisibility(View.GONE);
				}
				// 昵称
				newsRelayNick.setText(detaiNewsData.relayNick);
				// 性别
				if (detaiNewsData.relaySex == 0) {
					// 女
					newsRelaySex.setImageResource(R.drawable.icon_famale_s);
				} else {
					// 男
					newsRelaySex.setImageResource(R.drawable.icon_male_s);
				}
				// 时间
				newsRelayDate.setText(TimeUtil.getStandardDate(detaiNewsData.relayDate));
				// 标题
				newsRelayTitleInfo.setText(Util.replaceTagStyleContent(detaiNewsData.relayContent));
			}
		}
		// 评论
		newsCommentNum.setText(detaiNewsData.commentCount + "评论");
		newsCommentNum.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				// 评论
				if (J_Cache.sLoginUser.marriage == 1 && J_Cache.sLoginUser.callno_upload == 0
						&& J_Cache.sLoginUser.friends_num == 0 && J_Cache.sLoginUser.uid != detaiNewsData.uid) {
					Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
					profileIntent.putExtra("uid", detaiNewsData.uid);
					mContext.startActivity(profileIntent);
				} else {
					Message handleMsg = mHandler.obtainMessage();
					handleMsg.what = 0x1001;
					mHandler.sendMessage(handleMsg);
				}
			}
		});
		// 转播
		newsReBroadcastNum.setText(detaiNewsData.rebroadcastCount + "转播");
		if (detaiNewsData.is_rebroadcast == 1 || detaiNewsData.uid == J_Cache.sLoginUser.uid
				|| detaiNewsData.relayUid == J_Cache.sLoginUser.uid || detaiNewsData.relayStatus == -1) {
			// 已经转播-颜色变灰，不可点击
			newsReBroadcastNum.setTextColor(mContext.getResources().getColor(R.color.text_normal_gray));
			newsReBroadcastNum.setClickable(false);
		} else {
			// 还未转播，字体颜色正常
			newsReBroadcastNum.setTextColor(mContext.getResources().getColor(R.color.text_normal_blue));
			newsReBroadcastNum.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					if (J_Cache.sLoginUser.marriage == 1 && J_Cache.sLoginUser.callno_upload == 0
							&& J_Cache.sLoginUser.friends_num == 0) {
						Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
						profileIntent.putExtra("uid", detaiNewsData.uid);
						mContext.startActivity(profileIntent);
					} else {
						Message handleMsg = mHandler.obtainMessage();
						handleMsg.what = 0x1000;
						handleMsg.obj = newsReBroadcastNum;
						mHandler.sendMessage(handleMsg);
					}
				}
			});
		}
		// 赞
		if (detaiNewsData.is_praise == 1) {
			// 已经赞过,字体颜色变灰
			newsPraiseNum.setTextColor(mContext.getResources().getColor(R.color.text_normal_gray));
		} else {
			// 未赞过，字体颜色正常
			newsPraiseNum.setTextColor(mContext.getResources().getColor(R.color.text_normal_blue));
		}
		newsPraiseNum.setText(detaiNewsData.praiseCount + "赞");
		newsPraiseNum.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				if (J_Cache.sLoginUser.marriage == 1 && J_Cache.sLoginUser.callno_upload == 0
						&& J_Cache.sLoginUser.friends_num == 0 && J_Cache.sLoginUser.uid != detaiNewsData.uid) {
					Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
					profileIntent.putExtra("uid", detaiNewsData.uid);
					mContext.startActivity(profileIntent);
				} else {
					if (detaiNewsData.is_praise == 1) {
						// 已经赞过
						detaiNewsData.praiseCount -= 1;
						detaiNewsData.is_praise = 0;
						// 从赞列表移除自己
						for (int i = 0; i < detaiNewsData.praisePeople.size(); i++) {
							BaseUser tmpUser = detaiNewsData.praisePeople.get(i);
							if (tmpUser.uid == J_Cache.sLoginUser.uid) {
								detaiNewsData.praisePeople.remove(i);
								break;
							}
						}
						// 刷新数据
						setContent();
						// 赞
						new DelPraiseRequest(null).execute(detaiNewsData.uid, detaiNewsData.feedId);
					} else {
						// 未赞过
						detaiNewsData.praiseCount += 1;// 数字先+1
						detaiNewsData.is_praise = 1;// 设置为已经赞过
						// 添加一个赞的人
						BaseUser user = new BaseUser();
						user.uid = J_Cache.sLoginUser.uid;
						user.nickName = J_Cache.sLoginUser.nickName;
						detaiNewsData.praisePeople.add(user);
						// 播放赞动画
						Message animMsg = mHandler.obtainMessage();
						animMsg.what = 0x1010;
						animMsg.arg1 = 0;
						animMsg.obj = newsPraiseNum;
						mHandler.sendMessage(animMsg);
						// 赞
						new SendPraiseRequest(null).execute(detaiNewsData.uid, detaiNewsData.feedId);
					}
				}
			}
		});
		// ------------赞过的人-------------
		setPraisePeople();
		// 转播的人
		setRebroadcastPeople();
		// 整个大模块是否显示（因为背景共用）
		if (detaiNewsData.praisePeople.size() > 0 || detaiNewsData.rebroadcastPeople.size() > 0
				|| detaiNewsData.comment.size() > 0) {
			newsFriendsInfoBox.setVisibility(View.VISIBLE);
		} else {
			newsFriendsInfoBox.setVisibility(View.GONE);
		}
		// 点击头像
		newsUserAvatar.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
				profileIntent.putExtra("uid", detaiNewsData.uid);
				mContext.startActivity(profileIntent);
			}
		});

		// 刷新评论信息
		Collections.sort(detaiNewsData.comment, new CommentComparator());
		commentAdapter.setData(detaiNewsData.comment);
		commentAdapter.notifyDataSetChanged();
	}

	/**
	 * 设置赞过我的人列表
	 * 
	 * @Title: setPraisePeople
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setPraisePeople() {
		SpannableStringBuilder praisePeople = new SpannableStringBuilder();
		for (int i = 0; i < detaiNewsData.praisePeople.size(); i++) {
			if (!detaiNewsData.isPraiseShowAll && i > J_Consts.NEWS_COMMENT_MAX_SHOW - 1) {
				// 最多值显示限定数量个人
				break;
			}
			final BaseUser praiseUser = detaiNewsData.praisePeople.get(i);
			if (praisePeople.length() > 0) {
				praisePeople.append(", ");
			}
			String showPraiseTxt = praiseUser.nickName;
			final SpannableString praiseStr = new SpannableString(showPraiseTxt);
			praiseStr.setSpan(new ClickableSpan() {
				@Override
				public void onClick(View widget) {
					// 点击查看该用户资料
					Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
					profileIntent.putExtra("uid", praiseUser.uid);
					mContext.startActivity(profileIntent);
				}

				@Override
				public void updateDrawState(TextPaint ds) {
					super.updateDrawState(ds);
					// 设置文本颜色
					ds.setColor(mContext.getResources().getColor(R.color.text_normal_blue));
					ds.setUnderlineText(false);
					ds.clearShadowLayer();
					ds.bgColor = mContext.getResources().getColor(R.color.transparent);
				}
			}, 0, showPraiseTxt.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
			praisePeople.append(praiseStr);
		}
		if (praisePeople.length() > 0) {
			newsLikeInfoBox.setVisibility(View.VISIBLE);
			// 大于限定人数，要写“等x人”
			if (!detaiNewsData.isPraiseShowAll && detaiNewsData.praiseCount > J_Consts.NEWS_COMMENT_MAX_SHOW) {
				String showPraiseMoreTxt = " 等" + detaiNewsData.praiseCount + "人";
				SpannableString praiseMoreStr = new SpannableString(showPraiseMoreTxt);
				praiseMoreStr.setSpan(new ClickableSpan() {
					@Override
					public void onClick(View widget) {
						// 设置展开全部
						detaiNewsData.isPraiseShowAll = true;
						setPraisePeople();
					}

					@Override
					public void updateDrawState(TextPaint ds) {
						super.updateDrawState(ds);
						// 给的文字的展示时的颜色
						ds.setColor(mContext.getResources().getColor(R.color.text_normal_gray));
						ds.setUnderlineText(false);
					}
				}, 0, showPraiseMoreTxt.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
				praisePeople.append(praiseMoreStr);
			}
			newsLikeInfo.setText(praisePeople);
			// 在单击链接时凡是有要执行的动作，都必须设置MovementMethod对象
			newsLikeInfo.setMovementMethod(LinkMovementMethod.getInstance());
		} else {
			newsLikeInfoBox.setVisibility(View.GONE);
		}
	}

	/**
	 * 设置转播过的人的列表
	 * 
	 * @Title: setRebroadcastPeople
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setRebroadcastPeople() {
		SpannableStringBuilder rebroadcaseProple = new SpannableStringBuilder();
		for (int j = 0; j < detaiNewsData.rebroadcastPeople.size(); j++) {
			if (!detaiNewsData.isRebroadcastShowAll && j > J_Consts.NEWS_COMMENT_MAX_SHOW - 1) {
				// 最多值显示限定人数个人
				break;
			}
			final BaseUser rebroadcastUser = detaiNewsData.rebroadcastPeople.get(j);
			if (rebroadcaseProple.length() > 0) {
				rebroadcaseProple.append(", ");
			}
			String showRebroadTxt = rebroadcastUser.nickName;
			SpannableString rebroadStr = new SpannableString(showRebroadTxt);
			rebroadStr.setSpan(new ClickableSpan() {
				@Override
				public void onClick(View widget) {
					Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
					profileIntent.putExtra("uid", rebroadcastUser.uid);
					mContext.startActivity(profileIntent);
				}

				@Override
				public void updateDrawState(TextPaint ds) {
					super.updateDrawState(ds);
					ds.setColor(mContext.getResources().getColor(R.color.text_normal_blue));
					ds.setUnderlineText(false);
				}
			}, 0, showRebroadTxt.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
			rebroadcaseProple.append(rebroadStr);
		}
		if (rebroadcaseProple.length() > 0) {
			newsRelayInfoBox.setVisibility(View.VISIBLE);
			// 大于限定显示人数，要写“等x人”
			if (!detaiNewsData.isRebroadcastShowAll && detaiNewsData.rebroadcastCount > J_Consts.NEWS_COMMENT_MAX_SHOW) {
				String rebroadMoreTxt = " 等" + detaiNewsData.rebroadcastCount + "人";
				SpannableString rebroadMoreStr = new SpannableString(rebroadMoreTxt);
				rebroadMoreStr.setSpan(new ClickableSpan() {
					@Override
					public void onClick(View widget) {
						// 展开全部
						detaiNewsData.isRebroadcastShowAll = true;
						setRebroadcastPeople();
					}

					@Override
					public void updateDrawState(TextPaint ds) {
						super.updateDrawState(ds);
						ds.setColor(mContext.getResources().getColor(R.color.text_normal_gray));
						ds.setUnderlineText(false);
					}
				}, 0, rebroadMoreTxt.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
				rebroadcaseProple.append(rebroadMoreStr);
			}
			newsRelayInfo.setText(rebroadcaseProple);
			newsRelayInfo.setMovementMethod(LinkMovementMethod.getInstance());
		} else {
			newsRelayInfoBox.setVisibility(View.GONE);
		}
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(final Message msg) {
			switch (msg.what) {
			case 0x1010:
				// 显示点击动画
				showPageAnim((View) msg.obj, msg.arg1);
				// 刷新数据
				setContent();
				break;
			case 0x1003:
				// 回复别人的评论
				CommentInfoBean commentBean = (CommentInfoBean) msg.obj;
				CURRENT_MANAGE_TYPE = 2;
				CURRENT_REPLY_COMMENT = commentBean;
				String eTHint = "回复" + commentBean.nick + ":";
				// 显示输入框
				showKeyboard(eTHint);
				break;
			case 0x1002:
				// 评论结果
				final String content = msg.obj.toString();
				if (CURRENT_MANAGE_TYPE == 1) {
					// 评论动态
					sendComment(content);
				} else if (CURRENT_MANAGE_TYPE == 2) {
					// 回复评论
					sendCommentReply(content);
				}
				break;
			case 0x1001:
				// 评论
				CURRENT_MANAGE_TYPE = 1;
				// 显示输入框
				showKeyboard(null);
				break;
			case 0x1000:
				// 转发动态--记得转发数字要+1
				int feedId = detaiNewsData.feedId;
				long oid = detaiNewsData.uid;
				// 转发需要注意，如果当前动态为原创，直接转发该feedid，如果当前动态为转发动态，则转发原feedid
				if (detaiNewsData.type == 500 || detaiNewsData.type == 501) {
					feedId = detaiNewsData.relayFeedId;
					oid = detaiNewsData.relayUid;
				}
				// 播放动画
				showPageAnim((View) msg.obj, 1);
				// 标记为已广播
				detaiNewsData.is_rebroadcast = 1;
				// 添加广播人
				BaseUser user = new BaseUser();
				user.uid = J_Cache.sLoginUser.uid;
				user.nickName = J_Cache.sLoginUser.nickName;
				detaiNewsData.rebroadcastPeople.add(user);
				// 广播数字+1
				detaiNewsData.rebroadcastCount += 1;
				// 刷新数据
				setContent();
				// 发送请求
				new RebroadcastDynamicRequest(null).execute(feedId, oid);
				break;
			default:
				break;
			}
		}
	};

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:
				// 返回，要关闭键盘，关闭输入框
				// 隐藏键盘
				hideKeyboard();
				// 隐藏输入框
				news_global_edittext_box.setVisibility(View.GONE);
				finish();
				break;
			case R.id.newsRelayNick:
				// 点击转发人的昵称，跳转至资料页
				Intent profileRelayIntent = new Intent(mContext, ProfileViewActivity.class);
				profileRelayIntent.putExtra("uid", detaiNewsData.relayUid);
				startActivity(profileRelayIntent);
				break;
			case R.id.titleRightButton:
				// 删除动态
				DialogUtils.showPromptDialog(mContext, "删除动态", "确定删除该动态？", new OnSelectCallBack() {
					@Override
					public void onCallBack(String value1, String value2, String value3) {
						if (value1.equals("0")) {
							new DelDynamicRequest(new J_OnDataBack() {
								@Override
								public void onResponse(Object result) {
									J_Response response = (J_Response) result;
									if (response.retcode == 1) {
										ToastUtil.showToast(mContext, "删除成功");
										Intent resultIntent = new Intent();
										resultIntent.putExtra("feedId", detaiNewsData.feedId);
										setResult(NewsMainActivity.RESULT_CODE_OK, resultIntent);
										finish();
									}
								}

								@Override
								public void onError(HashMap<String, Object> errorMap) {
									super.onError(errorMap);
									dismissLoading();
								}
							}).execute(detaiNewsData.feedId + "");
						}
					}
				});
				break;
			case R.id.btn_setting_msg:
				// 输入框发送按钮
				String commentContent = input_msg_text.getText().toString();
				Message msg = mHandler.obtainMessage();
				msg.what = 0x1002;
				msg.obj = commentContent;
				mHandler.sendMessage(msg);
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 点击动画
	 * 
	 * @return void 返回类型
	 * @param currentView
	 * @param type 参数类型0：赞，1：转播
	 * @author likai
	 * @throws
	 */
	private void showPageAnim(View currentView, int type) {
		// 获取位置信息
		int[] outsideLocation = new int[2];
		getRootView().getLocationOnScreen(outsideLocation);
		int outY = outsideLocation[1];

		int[] location = new int[2];
		currentView.getLocationOnScreen(location);
		int x = location[0];
		int y = location[1] - outY;

		if (type == 0) {
			// 赞
			praise_anim_icon.setX(x);
			praise_anim_icon.setY(y);
			// 定位
			praise_anim_icon.setVisibility(View.VISIBLE);
			Animation anim = AnimationUtils.loadAnimation(mContext, R.anim.praise_anim);
			anim.setAnimationListener(new AnimationListener() {
				@Override
				public void onAnimationStart(Animation animation) {
				}

				@Override
				public void onAnimationRepeat(Animation animation) {
				}

				@Override
				public void onAnimationEnd(Animation animation) {
					praise_anim_icon.setVisibility(View.GONE);
				}
			});
			praise_anim_icon.startAnimation(anim);
		} else {
			// 转播
			rebroadcast_anim_icon.setX(x);
			rebroadcast_anim_icon.setY(y);
			// 定位
			rebroadcast_anim_icon.setVisibility(View.VISIBLE);
			Animation anim = AnimationUtils.loadAnimation(mContext, R.anim.praise_anim);
			anim.setAnimationListener(new AnimationListener() {
				@Override
				public void onAnimationStart(Animation animation) {
				}

				@Override
				public void onAnimationRepeat(Animation animation) {
				}

				@Override
				public void onAnimationEnd(Animation animation) {
					rebroadcast_anim_icon.setVisibility(View.GONE);
				}
			});
			rebroadcast_anim_icon.startAnimation(anim);
		}
	}

	/**
	 * 捕获用户按键（菜单键和返回键）
	 * 
	 * */
	@Override
	public boolean dispatchKeyEvent(KeyEvent event) {
		if (event.getKeyCode() == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0 && event.getAction() != KeyEvent.ACTION_UP) {
			if (news_global_edittext_box.getVisibility() == View.VISIBLE) {
				// 隐藏输入框
				hideKeyboard();
				return true;
			}
		}
		return super.dispatchKeyEvent(event);
	}

	/**
	 * 显示输入框
	 * 
	 * @Title: showKeyboard
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public void showKeyboard(String eTHint) {
		// 个人动态
		// 设置hint
		if (!Util.isBlankString(eTHint)) {
			input_msg_text.setHint(eTHint);
		} else {
			input_msg_text.setHint("");
		}
		// 隐藏标情况
		if (faceRelativeLayout.getFaceLayerShowStatus()) {
			faceRelativeLayout.hideFaceView();
		}
		// 显示输入框
		news_global_edittext_box.setVisibility(View.VISIBLE);
		// 显示键盘
		Util.showKeybord(mContext, input_msg_text);
	}

	/**
	 * 隐藏输入框
	 * 
	 * @Title: hideKeyboard
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public void hideKeyboard() {
		// 个人动态
		// 隐藏键盘
		Util.hideKeyboard(mContext, input_msg_text);
		// 清空内容
		input_msg_text.setText("");
		// 隐藏输入框
		news_global_edittext_box.setVisibility(View.GONE);
	}

	/**
	 * 发送动态评论
	 * 
	 * @Title: sendComment
	 * @return void 返回类型
	 * @param @param content 参数类型
	 * @author likai
	 * @throws
	 */
	private void sendComment(final String content) {
		if (Util.isBlankString(content)) {
			ToastUtil.showToast(mContext, "请填写评论内容");
			return;
		}
		// 隐藏键盘
		hideKeyboard();

		showLoading();
		new SendCommentRequest(new J_OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					// 添加一条评论内容
					CommentInfoBean cib = new CommentInfoBean();
					cib.uid = J_Cache.sLoginUser.uid;
					cib.nick = J_Cache.sLoginUser.nickName;
					cib.content = content;
					cib.avatar = J_Cache.sLoginUser.avatarUrl;
					cib.time = System.currentTimeMillis() / 1000 + "";
					cib.id = Util.getInteger(response.data);// 该条评论的id
					detaiNewsData.comment.add(cib);
					// 更新评论数字
					detaiNewsData.commentCount += 1;
					// 设置一评论
					detaiNewsData.is_comment = 1;

					// 刷新数据
					setContent();
				}
				dismissLoading();
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				super.onError(errorMap);
				dismissLoading();
			}
		}).execute(detaiNewsData.uid + "", detaiNewsData.feedId + "", content);
	}

	/**
	 * 回复评论
	 * 
	 * @Title: sendCommentReply
	 * @return void 返回类型
	 * @param @param content 参数类型
	 * @author likai
	 * @throws
	 */
	private void sendCommentReply(final String content) {
		if (Util.isBlankString(content)) {
			ToastUtil.showToast(mContext, "请填写评论内容");
			return;
		}
		// 隐藏键盘
		hideKeyboard();

		showLoading();
		new ReplyCommentRequest(new J_OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					CommentInfoBean newBean = new CommentInfoBean();
					newBean.uid = J_Cache.sLoginUser.uid;
					newBean.nick = J_Cache.sLoginUser.nickName;
					newBean.content = content;
					newBean.feedId = detaiNewsData.feedId;
					newBean.feedUid = detaiNewsData.uid;
					newBean.replyUid = CURRENT_REPLY_COMMENT.uid;
					newBean.replyNick = CURRENT_REPLY_COMMENT.nick;
					newBean.avatar = J_Cache.sLoginUser.avatarUrl;
					newBean.time = System.currentTimeMillis() / 1000 + "";
					newBean.id = Util.getInteger(response.data);// 该条评论的id
					detaiNewsData.comment.add(newBean);
					// 更新评论数字
					detaiNewsData.commentCount += 1;
					// 设置一评论
					detaiNewsData.is_comment = 1;

					// 刷新数据
					setContent();
				}
				dismissLoading();
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				super.onError(errorMap);
				dismissLoading();
			}
		}).execute(detaiNewsData.uid, J_Cache.sLoginUser.uid, detaiNewsData.feedId, CURRENT_REPLY_COMMENT.id,
				CURRENT_REPLY_COMMENT.uid, content);
	}
}
