package com.iyouxun.ui.adapter;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

import android.content.Context;
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
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.ViewTreeObserver;
import android.view.ViewTreeObserver.OnPreDrawListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.comparator.CommentComparator;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.beans.CommentInfoBean;
import com.iyouxun.data.beans.NewsInfoBean;
import com.iyouxun.data.beans.users.BaseUser;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.net.request.DelPraiseRequest;
import com.iyouxun.net.request.SendPraiseRequest;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.center.ProfilePhotoViewActivity;
import com.iyouxun.ui.activity.center.ProfileViewActivity;
import com.iyouxun.ui.activity.news.NewsDetailActivity;
import com.iyouxun.ui.views.FaceConversionUtil;
import com.iyouxun.ui.views.NotScollGridView;
import com.iyouxun.utils.ImageUtils;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.TimeUtil;
import com.iyouxun.utils.Util;

/**
 * 熟人圈动态列表adapter
 * 
 * @ClassName: NewsListInfoAdapter
 * @author likai
 * @date 2015-3-5 下午7:34:29
 * 
 */
public class NewsListInfoAdapter extends BaseAdapter {
	private final Context mContext;
	private List<NewsInfoBean> datas = new ArrayList<NewsInfoBean>();
	private Handler mHandler;
	private final int MAX_SHOW_TXT_LINE = 3;

	public NewsListInfoAdapter(Context mContext) {
		this.mContext = mContext;
	}

	public void setData(List<NewsInfoBean> datas) {
		this.datas = datas;
	}

	public void setHandler(Handler mHandler) {
		this.mHandler = mHandler;
	}

	@Override
	public int getCount() {
		return datas.size();
	}

	@Override
	public Object getItem(int position) {
		return datas.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(final int position, View convertView, ViewGroup parent) {
		ViewHolder vh = new ViewHolder();
		if (convertView == null) {
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_news_main_layout, null);
			vh.newsUserAvatar = (ImageView) convertView.findViewById(R.id.newsUserAvatar);
			vh.newsDataInfo = (TextView) convertView.findViewById(R.id.newsDataInfo);
			vh.newsUserNick = (TextView) convertView.findViewById(R.id.newsUserNick);
			vh.newsTitleInfo = (TextView) convertView.findViewById(R.id.newsTitleInfo);
			vh.newsContentTypePhotoOne = (ImageView) convertView.findViewById(R.id.newsContentTypePhotoOne);
			vh.newsContentTypePhoto = (NotScollGridView) convertView.findViewById(R.id.newsContentTypePhoto);
			vh.newsCommentNum = (TextView) convertView.findViewById(R.id.newsCommentNum);
			vh.newsReBroadcastNum = (TextView) convertView.findViewById(R.id.newsReBroadcastNum);
			vh.newsPraiseNum = (TextView) convertView.findViewById(R.id.newsPraiseNum);
			vh.newsLikeTitle = (TextView) convertView.findViewById(R.id.newsLikeTitle);
			vh.newsLikeInfo = (TextView) convertView.findViewById(R.id.newsLikeInfo);
			vh.newsRelayTitle = (TextView) convertView.findViewById(R.id.newsRelayTitle);
			vh.newsRelayInfo = (TextView) convertView.findViewById(R.id.newsRelayInfo);
			vh.newsCommentTitle = (TextView) convertView.findViewById(R.id.newsCommentTitle);
			vh.newsUserFriendDimen = (TextView) convertView.findViewById(R.id.newsUserFriendDimen);
			vh.newsContent = (TextView) convertView.findViewById(R.id.newsContent);

			vh.newsRelayContentBox = (RelativeLayout) convertView.findViewById(R.id.newsRelayContentBox);
			vh.newsRelayNick = (TextView) convertView.findViewById(R.id.newsRelayNick);
			vh.newsRelayDate = (TextView) convertView.findViewById(R.id.newsRelayDate);
			vh.newsRelayContentTypePhotoOne = (ImageView) convertView.findViewById(R.id.newsRelayContentTypePhotoOne);
			vh.newsRelayContentTypePhoto = (NotScollGridView) convertView.findViewById(R.id.newsRelayContentTypePhoto);
			vh.newsRelayContentTypePhotoOneBox = (LinearLayout) convertView.findViewById(R.id.newsRelayContentTypePhotoOneBox);
			vh.newsRelayContent = (TextView) convertView.findViewById(R.id.newsRelayContent);
			vh.newsFriendsInfoBox = (RelativeLayout) convertView.findViewById(R.id.newsFriendsInfoBox);

			vh.newsContentTypePhotoOneBox = (LinearLayout) convertView.findViewById(R.id.newsContentTypePhotoOneBox);

			vh.newsMoreButton = (TextView) convertView.findViewById(R.id.newsMoreButton);
			vh.newsRelayMoreButton = (TextView) convertView.findViewById(R.id.newsRelayMoreButton);

			vh.commentTv1 = (TextView) convertView.findViewById(R.id.commentTv1);
			vh.commentTv2 = (TextView) convertView.findViewById(R.id.commentTv2);
			vh.commentTv3 = (TextView) convertView.findViewById(R.id.commentTv3);
			vh.commentMore = (TextView) convertView.findViewById(R.id.commentMore);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		final ViewHolder tempVh = vh;
		final NewsInfoBean msg = datas.get(position);

		// 自动识别网页连接地址
		vh.newsContent.setAutoLinkMask(Linkify.WEB_URLS);
		vh.newsRelayContent.setAutoLinkMask(Linkify.WEB_URLS);
		vh.newsContent.setLinksClickable(false);
		vh.newsRelayContent.setLinksClickable(false);
		// 头像
		vh.containerAvatar = J_NetManager.getInstance().loadIMG(vh.containerAvatar, msg.avatar, vh.newsUserAvatar,
				R.drawable.icon_avatar, R.drawable.icon_avatar);
		// 昵称
		vh.newsUserNick.setText(msg.nick);
		// 性别
		if (msg.sex == 0) {
			// 女
			vh.newsUserNick.setCompoundDrawablesWithIntrinsicBounds(R.drawable.icon_famale_s, 0, 0, 0);
		} else {
			// 男
			vh.newsUserNick.setCompoundDrawablesWithIntrinsicBounds(R.drawable.icon_male_s, 0, 0, 0);
		}
		// 时间
		vh.newsDataInfo.setText(TimeUtil.getStandardDate(msg.date));
		// 朋友类型
		if (msg.friendDimen == 2 && msg.uid != SharedPreUtil.getLoginInfo().uid) {
			vh.newsUserFriendDimen.setText("好友的好友");
			vh.newsUserFriendDimen.setVisibility(View.VISIBLE);
		} else {
			vh.newsUserFriendDimen.setVisibility(View.INVISIBLE);
		}

		// 设置内容的默认最大高度
		vh.newsContent.setMaxLines(MAX_SHOW_TXT_LINE);
		vh.newsRelayContent.setMaxLines(MAX_SHOW_TXT_LINE);
		// 标题
		if (msg.type == 100) {
			// 发布文字内容
			// 显示正文内容
			vh.newsContent.setVisibility(View.VISIBLE);
			// 隐藏图片列表
			vh.newsContentTypePhoto.setVisibility(View.GONE);
			vh.newsContentTypePhotoOneBox.setVisibility(View.GONE);
			// 隐藏转播动态
			vh.newsRelayContentBox.setVisibility(View.GONE);
			// 标题
			if (msg.marriage == 1) {
				vh.newsTitleInfo.setText("单身");
			} else if (msg.marriage == 2) {
				vh.newsTitleInfo.setText("恋爱中");
			} else if (msg.marriage == 3) {
				vh.newsTitleInfo.setText("已婚");
			} else if (msg.marriage == 4) {
				vh.newsTitleInfo.setText("保密");
			} else {
				vh.newsTitleInfo.setText("未知");
			}
			// 内容--设置折叠
			ViewTreeObserver viewTreeObserver = vh.newsContent.getViewTreeObserver();
			viewTreeObserver.addOnPreDrawListener(new OnPreDrawListener() {
				private int lineCount;

				@Override
				public boolean onPreDraw() {
					if (!msg.contentIsGetLineCount) {
						lineCount = tempVh.newsContent.getLineCount();
						if (lineCount > MAX_SHOW_TXT_LINE) {
							// 如果textview中的文字和应该显示的文字不同，则显示“全文”按钮
							tempVh.newsMoreButton.setVisibility(View.VISIBLE);
						} else {
							tempVh.newsMoreButton.setVisibility(View.GONE);
						}
						msg.contentIsGetLineCount = true;
						msg.contentIsOpenStatus = 0;
						msg.contentLineCount = lineCount;
						datas.set(position, msg);
					}
					return true;
				}
			});
			// 设置标签动态的内容
			vh.newsContent.setText(Util.replaceTagStyleContent(msg.content));
			if (msg.contentIsGetLineCount) {
				if (msg.contentLineCount > MAX_SHOW_TXT_LINE) {
					tempVh.newsMoreButton.setVisibility(View.VISIBLE);
					if (msg.contentIsOpenStatus == 0) {// 收起状态
						tempVh.newsMoreButton.setText("全文");
						tempVh.newsContent.setMaxLines(MAX_SHOW_TXT_LINE);
					} else {// 全文状态
						tempVh.newsMoreButton.setText("收起");
						tempVh.newsContent.setMaxLines(msg.contentLineCount);
					}
				} else {
					tempVh.newsMoreButton.setVisibility(View.GONE);
				}
			}
			tempVh.newsMoreButton.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					// 设置为展开
					if (tempVh.newsMoreButton.getText().toString().equals("全文")) {
						tempVh.newsMoreButton.setText("收起");
						tempVh.newsContent.setMaxLines(msg.contentLineCount);
						msg.contentIsOpenStatus = 1;
					} else {
						tempVh.newsMoreButton.setText("全文");
						tempVh.newsContent.setMaxLines(MAX_SHOW_TXT_LINE);
						msg.contentIsOpenStatus = 0;
					}
					datas.set(position, msg);
				}
			});
		} else if (msg.type == 101) {
			// 图片动态
			// 隐藏图片列表
			vh.newsContentTypePhoto.setVisibility(View.GONE);
			vh.newsContentTypePhotoOneBox.setVisibility(View.GONE);
			// 隐藏转播动态模块
			vh.newsRelayContentBox.setVisibility(View.GONE);
			// 标题
			if (msg.marriage == 1) {
				vh.newsTitleInfo.setText("单身");
			} else if (msg.marriage == 2) {
				vh.newsTitleInfo.setText("恋爱中");
			} else if (msg.marriage == 3) {
				vh.newsTitleInfo.setText("已婚");
			} else if (msg.marriage == 4) {
				vh.newsTitleInfo.setText("保密");
			} else {
				vh.newsTitleInfo.setText("未知");
			}
			// 内容
			if (!Util.isBlankString(msg.content)) {
				vh.newsContent.setVisibility(View.VISIBLE);
				// 内容--设置折叠
				ViewTreeObserver viewTreeObserver = vh.newsContent.getViewTreeObserver();
				viewTreeObserver.addOnPreDrawListener(new OnPreDrawListener() {
					private int lineCount;

					@Override
					public boolean onPreDraw() {
						if (!msg.contentIsGetLineCount) {
							lineCount = tempVh.newsContent.getLineCount();
							if (lineCount > MAX_SHOW_TXT_LINE) {
								// 如果textview中的文字和应该显示的文字不同，则显示“全文”按钮
								tempVh.newsMoreButton.setVisibility(View.VISIBLE);
							} else {
								tempVh.newsMoreButton.setVisibility(View.GONE);
							}
							msg.contentIsGetLineCount = true;
							msg.contentIsOpenStatus = 0;
							msg.contentLineCount = lineCount;
							datas.set(position, msg);
						}
						return true;
					}
				});
				vh.newsContent.setText(msg.content);
				if (msg.contentIsGetLineCount) {
					if (msg.contentLineCount > MAX_SHOW_TXT_LINE) {
						tempVh.newsMoreButton.setVisibility(View.VISIBLE);
						if (msg.contentIsOpenStatus == 0) {// 收起状态
							tempVh.newsMoreButton.setText("全文");
							tempVh.newsContent.setMaxLines(MAX_SHOW_TXT_LINE);
						} else {// 全文状态
							tempVh.newsMoreButton.setText("收起");
							tempVh.newsContent.setMaxLines(msg.contentLineCount);
						}
					} else {
						tempVh.newsMoreButton.setVisibility(View.GONE);
					}
				}
				tempVh.newsMoreButton.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						// 设置为展开
						if (tempVh.newsMoreButton.getText().toString().equals("全文")) {
							tempVh.newsMoreButton.setText("收起");
							tempVh.newsContent.setMaxLines(msg.contentLineCount);
							msg.contentIsOpenStatus = 1;
						} else {
							tempVh.newsMoreButton.setText("全文");
							tempVh.newsContent.setMaxLines(MAX_SHOW_TXT_LINE);
							msg.contentIsOpenStatus = 0;
						}
						datas.set(position, msg);
					}
				});
			} else {
				vh.newsContent.setVisibility(View.GONE);
			}
			// 图片列表
			if (msg.contentPhoto.size() == 1) {
				// 单张图片
				// 设置该项目显示
				vh.newsContentTypePhotoOneBox.setVisibility(View.VISIBLE);
				// 设置图片宽高
				ImageUtils.setImageViewSizeFromUrl(vh.newsContentTypePhotoOne, msg.contentPhoto.get(0).url_small);
				// 加载图片
				vh.containerOne = J_NetManager.getInstance().loadIMG(vh.containerOne, msg.contentPhoto.get(0).url_small,
						vh.newsContentTypePhotoOne, R.drawable.pic_default_square, R.drawable.pic_default_square);
				vh.newsContentTypePhotoOne.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						Intent albumIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
						albumIntent.putExtra("photoInfo", msg.contentPhoto);
						mContext.startActivity(albumIntent);
					}
				});
			} else if (msg.contentPhoto.size() > 1) {
				// TODO 使用gridview
				// 设置该项目显示
				vh.newsContentTypePhoto.setVisibility(View.VISIBLE);
				vh.photoAdapter = new NewsListPhotoAdapter(mContext);
				vh.photoAdapter.setData(msg.contentPhoto);
				vh.newsContentTypePhoto.setAdapter(vh.photoAdapter);
				vh.newsContentTypePhoto.setOnItemClickListener(new OnItemClickListener() {
					@Override
					public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
						Intent albumIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
						albumIntent.putExtra("photoInfo", msg.contentPhoto);
						albumIntent.putExtra("index", position);
						mContext.startActivity(albumIntent);
					}
				});
			}
		} else if (msg.type == 501) {
			// 转播图片动态
			// 原创内容模块隐藏
			vh.newsContent.setVisibility(View.GONE);
			vh.newsMoreButton.setVisibility(View.GONE);
			vh.newsContentTypePhotoOneBox.setVisibility(View.GONE);
			vh.newsContentTypePhoto.setVisibility(View.GONE);
			// 显示转播模块
			vh.newsRelayContentBox.setVisibility(View.VISIBLE);
			vh.newsRelayContent.setVisibility(View.VISIBLE);
			vh.newsRelayContentTypePhoto.setVisibility(View.GONE);
			vh.newsRelayContentTypePhotoOneBox.setVisibility(View.GONE);
			// 转播图片
			if (msg.marriage == 1) {
				vh.newsTitleInfo.setText(Html.fromHtml("单身<br />转播动态"));
			} else if (msg.marriage == 2) {
				vh.newsTitleInfo.setText(Html.fromHtml("恋爱中<br />转播动态"));
			} else if (msg.marriage == 3) {
				vh.newsTitleInfo.setText(Html.fromHtml("已婚<br />转播动态"));
			} else if (msg.marriage == 4) {
				vh.newsTitleInfo.setText(Html.fromHtml("保密<br />转播动态"));
			} else {
				vh.newsTitleInfo.setText(Html.fromHtml("未知<br />转播动态"));
			}
			if (msg.relayStatus == -1) {
				// 转播的动态已删除
				vh.newsRelayNick.setVisibility(View.GONE);
				vh.newsRelayDate.setVisibility(View.GONE);
				vh.newsRelayContent.setText("该内容已被作者删除");
				vh.newsRelayMoreButton.setVisibility(View.GONE);
				vh.newsRelayContentTypePhotoOneBox.setVisibility(View.GONE);
				vh.newsRelayContentTypePhoto.setVisibility(View.GONE);
			} else {
				vh.newsRelayNick.setVisibility(View.VISIBLE);
				vh.newsRelayDate.setVisibility(View.VISIBLE);
				// 昵称
				vh.newsRelayNick.setText(msg.relayNick);
				// 性别
				if (msg.relaySex == 0) {
					// 女
					vh.newsRelayNick.setCompoundDrawablesWithIntrinsicBounds(R.drawable.icon_famale_s, 0, 0, 0);
				} else {
					// 男
					vh.newsRelayNick.setCompoundDrawablesWithIntrinsicBounds(R.drawable.icon_male_s, 0, 0, 0);
				}
				// 日期
				vh.newsRelayDate.setText(TimeUtil.getStandardDate(msg.relayDate));
				// 标题
				vh.newsRelayContent.setText("发表图片");
				// 内容
				if (!Util.isBlankString(msg.relayContent)) {
					// 设置折叠
					ViewTreeObserver viewTreeObserver = vh.newsRelayContent.getViewTreeObserver();
					viewTreeObserver.addOnPreDrawListener(new OnPreDrawListener() {
						private int lineCount;

						@Override
						public boolean onPreDraw() {
							if (!msg.relayContentIsGetLineCount) {
								lineCount = tempVh.newsRelayContent.getLineCount();
								if (lineCount > MAX_SHOW_TXT_LINE) {
									// 如果textview中的文字和应该显示的文字不同，则显示“全文”按钮
									tempVh.newsRelayMoreButton.setVisibility(View.VISIBLE);
								} else {
									tempVh.newsRelayMoreButton.setVisibility(View.GONE);
								}
								msg.relayContentIsGetLineCount = true;
								msg.relayContentIsOpenStatus = 0;
								msg.relayContentLineCount = lineCount;
								datas.set(position, msg);
							}
							return true;
						}
					});
					vh.newsRelayContent.setText(msg.relayContent);
					if (msg.relayContentIsGetLineCount) {
						if (msg.relayContentLineCount > MAX_SHOW_TXT_LINE) {
							tempVh.newsRelayMoreButton.setVisibility(View.VISIBLE);
							if (msg.relayContentIsOpenStatus == 0) {// 收起状态
								tempVh.newsRelayMoreButton.setText("全文");
								tempVh.newsRelayContent.setMaxLines(MAX_SHOW_TXT_LINE);
							} else {// 全文状态
								tempVh.newsRelayMoreButton.setText("收起");
								tempVh.newsRelayContent.setMaxLines(msg.relayContentLineCount);
							}
						} else {
							tempVh.newsRelayMoreButton.setVisibility(View.GONE);
						}
					}
					tempVh.newsRelayMoreButton.setOnClickListener(new OnClickListener() {
						@Override
						public void onClick(View v) {
							// 设置为展开
							if (tempVh.newsRelayMoreButton.getText().toString().equals("全文")) {
								tempVh.newsRelayMoreButton.setText("收起");
								tempVh.newsRelayContent.setMaxLines(msg.relayContentLineCount);
								msg.relayContentIsOpenStatus = 1;
							} else {
								tempVh.newsRelayMoreButton.setText("全文");
								tempVh.newsRelayContent.setMaxLines(MAX_SHOW_TXT_LINE);
								msg.relayContentIsOpenStatus = 0;
							}
							datas.set(position, msg);
						}
					});
				} else {
					vh.newsRelayMoreButton.setVisibility(View.GONE);
				}
				// 图片列表
				if (msg.relayContentPhoto.size() == 1) {
					// 单张图片
					// 显示该项目
					vh.newsRelayContentTypePhotoOneBox.setVisibility(View.VISIBLE);
					// 设置图片宽高
					ImageUtils.setImageViewSizeFromUrl(vh.newsRelayContentTypePhotoOne, msg.relayContentPhoto.get(0).url_small);
					// 加载图片
					vh.containerOneReply = J_NetManager.getInstance().loadIMG(vh.containerOneReply,
							msg.relayContentPhoto.get(0).url_small, vh.newsRelayContentTypePhotoOne,
							R.drawable.pic_default_square, R.drawable.pic_default_square);
					vh.newsRelayContentTypePhotoOne.setOnClickListener(new OnClickListener() {
						@Override
						public void onClick(View v) {
							Intent albumIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
							albumIntent.putExtra("photoInfo", msg.relayContentPhoto);
							mContext.startActivity(albumIntent);
						}
					});
				} else if (msg.relayContentPhoto.size() > 1) {
					// TODO 使用gridview
					// 显示该项目
					vh.newsRelayContentTypePhoto.setVisibility(View.VISIBLE);
					vh.photoAdapter = new NewsListPhotoAdapter(mContext);
					vh.photoAdapter.setData(msg.relayContentPhoto);
					vh.newsRelayContentTypePhoto.setAdapter(vh.photoAdapter);
					vh.newsRelayContentTypePhoto.setOnItemClickListener(new OnItemClickListener() {
						@Override
						public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
							Intent albumIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
							albumIntent.putExtra("photoInfo", msg.relayContentPhoto);
							albumIntent.putExtra("index", position);
							mContext.startActivity(albumIntent);
						}
					});
				}
			}
		} else if (msg.type == 500) {
			// 转播文字
			// 内容
			vh.newsContent.setVisibility(View.GONE);
			vh.newsMoreButton.setVisibility(View.GONE);
			// 多图隐藏
			vh.newsContentTypePhoto.setVisibility(View.GONE);
			// 单图隐藏
			vh.newsContentTypePhotoOneBox.setVisibility(View.GONE);
			// 显示转播层
			vh.newsRelayContentBox.setVisibility(View.VISIBLE);
			// 转播的标题
			vh.newsRelayContent.setVisibility(View.VISIBLE);
			// 图片层隐藏
			vh.newsRelayContentTypePhotoOneBox.setVisibility(View.GONE);
			// 隐藏多图
			vh.newsRelayContentTypePhoto.setVisibility(View.GONE);
			// 正文标题
			if (msg.marriage == 1) {
				vh.newsTitleInfo.setText(Html.fromHtml("单身<br />转播动态"));
			} else if (msg.marriage == 2) {
				vh.newsTitleInfo.setText(Html.fromHtml("恋爱中<br />转播动态"));
			} else if (msg.marriage == 3) {
				vh.newsTitleInfo.setText(Html.fromHtml("已婚<br />转播动态"));
			} else if (msg.marriage == 4) {
				vh.newsTitleInfo.setText(Html.fromHtml("保密<br />转播动态"));
			} else {
				vh.newsTitleInfo.setText(Html.fromHtml("未知<br />转播动态"));
			}
			if (msg.relayStatus == -1) {
				// 原动态已删除
				vh.newsRelayNick.setVisibility(View.GONE);
				vh.newsRelayDate.setVisibility(View.GONE);
				vh.newsRelayContent.setText("该内容已被作者删除");
				vh.newsRelayMoreButton.setVisibility(View.GONE);
			} else {
				// 转播的内容显示
				vh.newsRelayNick.setVisibility(View.VISIBLE);
				vh.newsRelayDate.setVisibility(View.VISIBLE);
				// 昵称
				vh.newsRelayNick.setText(msg.relayNick);
				// 性别
				if (msg.relaySex == 0) {
					// 女
					vh.newsRelayNick.setCompoundDrawablesWithIntrinsicBounds(R.drawable.icon_famale_s, 0, 0, 0);
				} else {
					// 男
					vh.newsRelayNick.setCompoundDrawablesWithIntrinsicBounds(R.drawable.icon_male_s, 0, 0, 0);
				}
				// 时间
				vh.newsRelayDate.setText(TimeUtil.getStandardDate(msg.relayDate));
				// 内容
				// 设置折叠
				ViewTreeObserver viewTreeObserver = vh.newsRelayContent.getViewTreeObserver();
				viewTreeObserver.addOnPreDrawListener(new OnPreDrawListener() {
					private int lineCount;

					@Override
					public boolean onPreDraw() {
						if (!msg.relayContentIsGetLineCount) {
							lineCount = tempVh.newsRelayContent.getLineCount();
							if (lineCount > MAX_SHOW_TXT_LINE) {
								// 如果textview中的文字和应该显示的文字不同，则显示“全文”按钮
								tempVh.newsRelayMoreButton.setVisibility(View.VISIBLE);
							} else {
								tempVh.newsRelayMoreButton.setVisibility(View.GONE);
							}
							msg.relayContentIsGetLineCount = true;
							msg.relayContentIsOpenStatus = 0;
							msg.relayContentLineCount = lineCount;
							datas.set(position, msg);
						}
						return true;
					}
				});
				// 设置标签动态的内容
				vh.newsRelayContent.setText(Util.replaceTagStyleContent(msg.relayContent));
				if (msg.relayContentIsGetLineCount) {
					if (msg.relayContentLineCount > MAX_SHOW_TXT_LINE) {
						tempVh.newsRelayMoreButton.setVisibility(View.VISIBLE);
						if (msg.relayContentIsOpenStatus == 0) {// 收起状态
							tempVh.newsRelayMoreButton.setText("全文");
							tempVh.newsRelayContent.setMaxLines(MAX_SHOW_TXT_LINE);
						} else {// 全文状态
							tempVh.newsRelayMoreButton.setText("收起");
							tempVh.newsRelayContent.setMaxLines(msg.relayContentLineCount);
						}
					} else {
						tempVh.newsRelayMoreButton.setVisibility(View.GONE);
					}
				}
				tempVh.newsRelayMoreButton.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						// 设置为展开
						if (tempVh.newsRelayMoreButton.getText().toString().equals("全文")) {
							tempVh.newsRelayMoreButton.setText("收起");
							tempVh.newsRelayContent.setMaxLines(msg.relayContentLineCount);
							msg.relayContentIsOpenStatus = 1;
						} else {
							tempVh.newsRelayMoreButton.setText("全文");
							tempVh.newsRelayContent.setMaxLines(MAX_SHOW_TXT_LINE);
							msg.relayContentIsOpenStatus = 0;
						}
						datas.set(position, msg);
					}
				});
			}
		}
		// 点击分享链接，直接跳转资料页
		vh.newsContent.getParent().requestDisallowInterceptTouchEvent(true);
		vh.newsContent.setOnTouchListener(new OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				if (event.getAction() == MotionEvent.ACTION_UP) {
					String text = tempVh.newsContent.getText().toString();
					long uid = Util.hasUserProfileUrl(text);
					if (uid > 0) {
						Intent intent = new Intent(mContext, ProfileViewActivity.class);
						intent.putExtra(UtilRequest.FORM_UID, uid);
						mContext.startActivity(intent);
					} else {
						Intent intent = new Intent(mContext, NewsDetailActivity.class);
						intent.putExtra("feedId", msg.feedId);
						mContext.startActivity(intent);
					}
				}
				return true;
			}
		});
		// 点击分享链接，直接跳转资料页
		vh.newsRelayContent.getParent().requestDisallowInterceptTouchEvent(true);
		vh.newsRelayContent.setOnTouchListener(new OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				if (event.getAction() == MotionEvent.ACTION_UP) {
					String text = tempVh.newsRelayContent.getText().toString();
					long uid = Util.hasUserProfileUrl(text);
					if (uid > 0) {
						Intent intent = new Intent(mContext, ProfileViewActivity.class);
						intent.putExtra(UtilRequest.FORM_UID, uid);
						mContext.startActivity(intent);
					} else {
						Intent intent = new Intent(mContext, NewsDetailActivity.class);
						intent.putExtra("feedId", msg.feedId);
						mContext.startActivity(intent);
					}
				}
				return true;
			}
		});
		// 评论
		vh.newsCommentNum.setText(msg.commentCount + "评论");
		vh.newsCommentNum.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				// 评论
				if (J_Cache.sLoginUser.marriage == 1 && J_Cache.sLoginUser.callno_upload == 0
						&& J_Cache.sLoginUser.friends_num == 0 && J_Cache.sLoginUser.uid != msg.uid) {
					// 单身，未导入通讯录，无好友-禁止当前用户进行赞/转播/评论操作，点击后全部引导进入对方资料页
					Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
					profileIntent.putExtra("uid", msg.uid);
					mContext.startActivity(profileIntent);
				} else {
					Message handleMsg = mHandler.obtainMessage();
					handleMsg.what = 0x1001;
					handleMsg.arg1 = position;
					mHandler.sendMessage(handleMsg);
				}
			}
		});
		// 转播
		vh.newsReBroadcastNum.setText(msg.rebroadcastCount + "转播");
		if (msg.is_rebroadcast == 1 || msg.uid == J_Cache.sLoginUser.uid || msg.relayUid == J_Cache.sLoginUser.uid
				|| msg.relayStatus == -1) {
			// 已经转播-颜色变灰，不可点击
			vh.newsReBroadcastNum.setTextColor(mContext.getResources().getColor(R.color.text_normal_gray));
			vh.newsReBroadcastNum.setClickable(false);
		} else {
			// 还未转播，字体颜色正常
			vh.newsReBroadcastNum.setClickable(true);
			final View newsReBroadcastNum = vh.newsReBroadcastNum;
			vh.newsReBroadcastNum.setTextColor(mContext.getResources().getColor(R.color.text_normal_blue));
			vh.newsReBroadcastNum.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					if (J_Cache.sLoginUser.marriage == 1 && J_Cache.sLoginUser.callno_upload == 0
							&& J_Cache.sLoginUser.friends_num == 0 && J_Cache.sLoginUser.uid != msg.uid) {
						// 单身，未导入通讯录，无好友-禁止当前用户进行赞/转播/评论操作，点击后全部引导进入对方资料页
						Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
						profileIntent.putExtra("uid", msg.uid);
						mContext.startActivity(profileIntent);
					} else {
						Message handleMsg = mHandler.obtainMessage();
						handleMsg.what = 0x1000;
						handleMsg.arg1 = position;
						handleMsg.obj = newsReBroadcastNum;
						mHandler.sendMessage(handleMsg);
					}
				}
			});
		}
		// 赞
		if (msg.is_praise == 1) {
			// 已经赞过,字体颜色变灰
			vh.newsPraiseNum.setTextColor(mContext.getResources().getColor(R.color.text_normal_gray));
		} else {
			// 未赞过，字体颜色正常
			vh.newsPraiseNum.setTextColor(mContext.getResources().getColor(R.color.text_normal_blue));
		}
		vh.newsPraiseNum.setText(msg.praiseCount + "赞");
		final View newsPraiseNum = vh.newsPraiseNum;
		vh.newsPraiseNum.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				if (J_Cache.sLoginUser.marriage == 1 && J_Cache.sLoginUser.callno_upload == 0
						&& J_Cache.sLoginUser.friends_num == 0 && J_Cache.sLoginUser.uid != msg.uid) {
					// 单身，未导入通讯录，无好友-禁止当前用户进行赞/转播/评论操作，点击后全部引导进入对方资料页
					Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
					profileIntent.putExtra("uid", msg.uid);
					mContext.startActivity(profileIntent);
				} else {
					if (msg.is_praise == 1) {
						// 已经赞过
						msg.praiseCount -= 1;
						msg.is_praise = 0;
						// 从赞列表移除自己
						for (int i = 0; i < msg.praisePeople.size(); i++) {
							BaseUser tmpUser = msg.praisePeople.get(i);
							if (tmpUser.uid == J_Cache.sLoginUser.uid) {
								msg.praisePeople.remove(i);
								break;
							}
						}
						datas.set(position, msg);
						notifyDataSetChanged();
						// 赞
						new DelPraiseRequest(null).execute(msg.uid, msg.feedId);
					} else {
						// 未赞过
						msg.praiseCount += 1;// 数字先+1
						msg.is_praise = 1;// 设置为已经赞过
						// 添加一个赞的人
						BaseUser user = new BaseUser();
						user.uid = J_Cache.sLoginUser.uid;
						user.nickName = J_Cache.sLoginUser.nickName;
						msg.praisePeople.add(user);
						datas.set(position, msg);
						notifyDataSetChanged();
						// 播放赞动画
						Message animMsg = mHandler.obtainMessage();
						animMsg.what = 0x1010;
						animMsg.arg1 = 0;
						animMsg.obj = newsPraiseNum;
						mHandler.sendMessage(animMsg);
						// 赞
						new SendPraiseRequest(null).execute(msg.uid, msg.feedId);
					}
				}

			}
		});
		// TODO ------------赞、评论、转播列表Start--------------
		// ------------赞过的人-------------
		SpannableStringBuilder praisePeople = new SpannableStringBuilder();
		for (int i = 0; i < msg.praisePeople.size(); i++) {
			if (!msg.isPraiseShowAll && i > J_Consts.NEWS_COMMENT_MAX_SHOW - 1) {
				// 最多值显示限定数量个人
				break;
			}
			final BaseUser praiseUser = msg.praisePeople.get(i);
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
			if (i > 0) {
				praisePeople.append("，");
			}
			praisePeople.append(praiseStr);
		}
		if (msg.praisePeople.size() > 0) {
			vh.newsLikeInfo.setVisibility(View.VISIBLE);
			vh.newsLikeTitle.setVisibility(View.VISIBLE);
			// 大于限定人数，要写“等x人”
			if (!msg.isPraiseShowAll && msg.praiseCount > J_Consts.NEWS_COMMENT_MAX_SHOW) {
				String showPraiseMoreTxt = " 等" + msg.praiseCount + "人";
				SpannableString praiseMoreStr = new SpannableString(showPraiseMoreTxt);
				praiseMoreStr.setSpan(new ClickableSpan() {
					@Override
					public void onClick(View widget) {
						// 设置展开全部
						msg.isPraiseShowAll = true;
						datas.set(position, msg);
						notifyDataSetChanged();
					}

					@Override
					public void updateDrawState(TextPaint ds) {
						super.updateDrawState(ds);
						// 给的文字的展示时的颜色
						ds.setColor(mContext.getResources().getColor(R.color.text_normal_gray));
						ds.setUnderlineText(false);
					}
				}, 0, showPraiseMoreTxt.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
				praisePeople.append(praiseMoreStr);
			}
			vh.newsLikeInfo.setText(praisePeople);
			// 在单击链接时凡是有要执行的动作，都必须设置MovementMethod对象
			vh.newsLikeInfo.setMovementMethod(LinkMovementMethod.getInstance());
		} else {
			vh.newsLikeInfo.setVisibility(View.GONE);
			vh.newsLikeTitle.setVisibility(View.GONE);
		}
		// ------------转播的人------------
		SpannableStringBuilder rebroadcaseProple = new SpannableStringBuilder();
		for (int j = 0; j < msg.rebroadcastPeople.size(); j++) {
			if (!msg.isRebroadcastShowAll && j > J_Consts.NEWS_COMMENT_MAX_SHOW - 1) {
				// 最多值显示限定人数个人
				break;
			}
			final BaseUser rebroadcastUser = msg.rebroadcastPeople.get(j);
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
			}, 0, showRebroadTxt.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
			if (j > 0) {
				rebroadcaseProple.append("，");
			}
			rebroadcaseProple.append(rebroadStr);
		}
		if (msg.rebroadcastPeople.size() > 0) {
			vh.newsRelayInfo.setVisibility(View.VISIBLE);
			vh.newsRelayTitle.setVisibility(View.VISIBLE);
			// 大于限定显示人数，要写“等x人”
			if (!msg.isRebroadcastShowAll && msg.rebroadcastCount > J_Consts.NEWS_COMMENT_MAX_SHOW) {
				String rebroadMoreTxt = " 等" + msg.rebroadcastCount + "人";
				SpannableString rebroadMoreStr = new SpannableString(rebroadMoreTxt);
				rebroadMoreStr.setSpan(new ClickableSpan() {
					@Override
					public void onClick(View widget) {
						// 展开全部
						msg.isRebroadcastShowAll = true;
						datas.set(position, msg);
						notifyDataSetChanged();
					}

					@Override
					public void updateDrawState(TextPaint ds) {
						super.updateDrawState(ds);
						ds.setColor(mContext.getResources().getColor(R.color.text_normal_gray));
						ds.setUnderlineText(false);
					}
				}, 0, rebroadMoreTxt.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
				rebroadcaseProple.append(rebroadMoreStr);
			}
			vh.newsRelayInfo.setText(rebroadcaseProple);
			vh.newsRelayInfo.setMovementMethod(LinkMovementMethod.getInstance());
		} else {
			vh.newsRelayInfo.setVisibility(View.GONE);
			vh.newsRelayTitle.setVisibility(View.GONE);
		}
		// ------------评论内容------------
		// 隐藏评论标题
		vh.newsCommentTitle.setVisibility(View.GONE);
		// 隐藏更多按钮
		vh.commentMore.setVisibility(View.GONE);
		vh.commentTv1.setVisibility(View.GONE);
		vh.commentTv2.setVisibility(View.GONE);
		vh.commentTv3.setVisibility(View.GONE);
		if (msg.comment.size() > 0) {
			// 显示评论标题
			vh.newsCommentTitle.setVisibility(View.VISIBLE);
			Collections.sort(msg.comment, new CommentComparator());
			for (int i = 0; i < msg.comment.size(); i++) {
				if (i > J_Consts.NEWS_COMMENT_MAX_SHOW - 1) {
					// 如果大于限定条数，多余的收起
					String commentMore = "查看全部" + msg.commentCount + "条评论...";
					vh.commentMore.setText(Html.fromHtml(commentMore));
					vh.commentMore.setOnClickListener(new OnClickListener() {
						@Override
						public void onClick(View v) {
							Intent detailNewsIntent = new Intent(mContext, NewsDetailActivity.class);
							detailNewsIntent.putExtra("feedId", msg.feedId);
							mContext.startActivity(detailNewsIntent);
						}
					});
					vh.commentMore.setVisibility(View.VISIBLE);
					break;
				}
				SpannableStringBuilder commentBuilder = new SpannableStringBuilder();
				final CommentInfoBean tempBean = msg.comment.get(i);
				// 创建并添加一个textview
				TextView tv = new TextView(mContext);
				// 我的昵称
				SpannableString commentNickStr = new SpannableString(tempBean.nick + "：");
				if (!Util.isBlankString(tempBean.replyNick) && tempBean.replyUid > 0) {
					// 回复他人评论
					commentNickStr = new SpannableString(tempBean.nick);
				}
				commentNickStr.setSpan(new ClickableSpan() {
					@Override
					public void onClick(View widget) {
						Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
						profileIntent.putExtra("uid", tempBean.uid);
						mContext.startActivity(profileIntent);
					}

					@Override
					public void updateDrawState(TextPaint ds) {
						super.updateDrawState(ds);
						// 设置字体颜色
						ds.setColor(mContext.getResources().getColor(R.color.text_normal_blue));
						// 去掉下划线
						ds.setUnderlineText(false);
					}

				}, 0, commentNickStr.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
				// 对方的昵称
				SpannableString commentReplyNickStr = new SpannableString(tempBean.replyNick + "：");
				commentReplyNickStr.setSpan(new ClickableSpan() {
					@Override
					public void onClick(View widget) {
						Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
						profileIntent.putExtra("uid", tempBean.replyUid);
						mContext.startActivity(profileIntent);
					}

					@Override
					public void updateDrawState(TextPaint ds) {
						super.updateDrawState(ds);
						// 设置字体颜色
						ds.setColor(mContext.getResources().getColor(R.color.text_normal_blue));
						// 去掉下划线
						ds.setUnderlineText(false);
					}
				}, 0, commentReplyNickStr.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
				SpannableString commentContent = FaceConversionUtil.getInstace().getExpressionStringAll(mContext,
						tempBean.content);
				commentContent.setSpan(new ClickableSpan() {
					@Override
					public void onClick(View widget) {
						// 回复评论
						if (J_Cache.sLoginUser.marriage == 1 && J_Cache.sLoginUser.callno_upload == 0
								&& J_Cache.sLoginUser.friends_num == 0 && J_Cache.sLoginUser.uid != msg.uid) {
							// 单身，未导入通讯录，无好友-禁止当前用户进行赞/转播/评论操作，点击后全部引导进入对方资料页
							Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
							profileIntent.putExtra("uid", msg.uid);
							mContext.startActivity(profileIntent);
						} else {
							Message commentReplyMsg = mHandler.obtainMessage();
							commentReplyMsg.what = 0x1003;
							commentReplyMsg.obj = tempBean;
							commentReplyMsg.arg1 = position;
							mHandler.sendMessage(commentReplyMsg);
						}
					}

					@Override
					public void updateDrawState(TextPaint ds) {
						super.updateDrawState(ds);
						ds.setColor(mContext.getResources().getColor(R.color.text_normal_gray));
						ds.setUnderlineText(false);
					}

				}, 0, tempBean.content.length(), Spanned.SPAN_EXCLUSIVE_EXCLUSIVE);
				if (!Util.isBlankString(tempBean.replyNick) && tempBean.replyUid > 0) {
					// 回复他人评论
					commentBuilder.append(commentNickStr);
					commentBuilder.append(" 回复 ");
					commentBuilder.append(commentReplyNickStr);
					commentBuilder.append(commentContent);
				} else {
					// 回复动态
					commentBuilder.append(commentNickStr);
					commentBuilder.append(commentContent);
				}
				switch (i) {
				case 0:
					vh.commentTv1.setText(commentBuilder);
					vh.commentTv1.setMovementMethod(LinkMovementMethod.getInstance());
					vh.commentTv1.setTag(tempBean);
					vh.commentTv1.setVisibility(View.VISIBLE);
					break;
				case 1:
					vh.commentTv2.setText(commentBuilder);
					vh.commentTv2.setMovementMethod(LinkMovementMethod.getInstance());
					vh.commentTv2.setTag(tempBean);
					vh.commentTv2.setVisibility(View.VISIBLE);
					break;
				case 2:
					vh.commentTv3.setText(commentBuilder);
					vh.commentTv3.setMovementMethod(LinkMovementMethod.getInstance());
					vh.commentTv3.setTag(tempBean);
					vh.commentTv3.setVisibility(View.VISIBLE);
					break;
				default:
					break;
				}
			}
		}
		// 整个大模块是否显示（因为背景共用）
		if (msg.praisePeople.size() > 0 || msg.rebroadcastPeople.size() > 0 || msg.comment.size() > 0) {
			vh.newsFriendsInfoBox.setVisibility(View.VISIBLE);
		} else {
			vh.newsFriendsInfoBox.setVisibility(View.GONE);
		}
		// TODO ------------赞、评论、转播列表End--------------
		// 点击头像
		vh.newsUserAvatar.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				// 收起键盘
				mHandler.sendEmptyMessage(0x10001);

				Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
				profileIntent.putExtra("uid", msg.uid);
				mContext.startActivity(profileIntent);
			}
		});
		vh.newsUserNick.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
				profileIntent.putExtra("uid", msg.uid);
				mContext.startActivity(profileIntent);
			}
		});
		return convertView;
	}

	private class ViewHolder {
		public ImageContainer containerAvatar;
		public ImageContainer containerOne;
		public ImageContainer containerOneReply;

		// 多图列表
		public NewsListPhotoAdapter photoAdapter;

		public ImageView newsUserAvatar;// 头像
		public TextView newsDataInfo;// 时间
		public TextView newsUserNick;// 昵称
		public TextView newsTitleInfo;// 标题
		public ImageView newsContentTypePhotoOne;// 单张图片
		public LinearLayout newsContentTypePhotoOneBox;
		public NotScollGridView newsContentTypePhoto;// 图片列表(2张以上图片)
		public TextView newsCommentNum;// 评论数
		public TextView newsReBroadcastNum;// 转播数
		public TextView newsPraiseNum;// 赞的数量
		public TextView newsUserFriendDimen;// 朋友类型
		public TextView newsContent;// 标题

		// 转播的内容
		public RelativeLayout newsRelayContentBox;
		public TextView newsRelayNick;
		public TextView newsRelayDate;
		public ImageView newsRelayContentTypePhotoOne;
		public NotScollGridView newsRelayContentTypePhoto;
		public LinearLayout newsRelayContentTypePhotoOneBox;
		public TextView newsRelayContent;

		public RelativeLayout newsFriendsInfoBox;// 赞、评论、转播的详细页面

		private TextView newsMoreButton;// 文字动态，如果超出一定行数，需要显示“全文”按钮
		private TextView newsRelayMoreButton;// 文字动态，如果超出一定行数，需要显示“全文”按钮

		public TextView newsLikeTitle;
		public TextView newsLikeInfo;
		public TextView newsRelayTitle;
		public TextView newsRelayInfo;
		private TextView newsCommentTitle;

		public TextView commentTv1;
		public TextView commentTv2;
		public TextView commentTv3;
		public TextView commentMore;
	}
}
