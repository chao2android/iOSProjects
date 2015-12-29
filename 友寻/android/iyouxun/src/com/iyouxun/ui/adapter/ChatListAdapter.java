package com.iyouxun.ui.adapter;

import java.io.File;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.BitmapFactory.Options;
import android.graphics.drawable.AnimationDrawable;
import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.os.Handler;
import android.os.UserManager;
import android.text.SpannableString;
import android.text.util.Linkify;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnLongClickListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader;
import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.iyouxun.R;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.data.chat.ChatConstant;
import com.iyouxun.data.chat.ChatContactRepository;
import com.iyouxun.data.chat.ChatDBHelper;
import com.iyouxun.data.chat.ChatItem;
import com.iyouxun.j_libs.encrypt.MD5;
import com.iyouxun.j_libs.file.FileStore;
import com.iyouxun.j_libs.file.FileUtils;
import com.iyouxun.j_libs.managers.J_FileManager;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.center.ProfilePhotoViewActivity;
import com.iyouxun.ui.activity.center.ProfileViewActivity;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.ui.views.FaceConversionUtil;
import com.iyouxun.utils.ImageUtils;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;

/**
 * @author leekai
 * 
 */
public class ChatListAdapter extends BaseAdapter {
	protected List<ChatItem> items = new ArrayList<ChatItem>();
	protected Context context;
	protected String headUrl;
	protected String myHeaderUrl;
	protected String uid;
	protected UserManager um;
	protected boolean isShowTime = false;
	protected long TimeLimitNum = 300000;// 多长时间段才显示时间分隔5分

	public static final int INBOX = 1; // 收信(对方)
	public static final int OUTBOX = 2;// 发信(自己)

	protected Handler backHandler = null;
	protected ImageLoader imageLoader;

	protected int oppsiteSex = 0;// 对方的性别
	protected String oppsiteNick;// 对方的昵称
	protected int distance;// 位置距离
	protected MediaPlayer mMediaPlayer = new MediaPlayer();// 播放器设置
	protected FileStore fs;
	protected FaceConversionUtil fcu;

	protected int playPosition = -1;// 播放中的语音记录序列
	private final ChatDBHelper helper;
	private String userNick;// 单聊用户昵称
	private final OnLongClickListener onLongClickListener;// 长按事件监听
	private boolean showNick = false;// 展示昵称
	private int voiceMode = 0;

	public ChatListAdapter(Context context, List<ChatItem> items, Handler handler, OnLongClickListener onLongClickListener) {
		this.context = context;
		uid = J_Cache.sLoginUser.uid + "";
		fcu = FaceConversionUtil.getInstace();
		this.items = items;
		// 我的头像
		myHeaderUrl = J_Cache.sLoginUser.avatarUrl;
		fs = J_FileManager.getInstance().getFileStore();
		this.backHandler = handler;
		helper = ChatContactRepository.getDBHelperInstance();
		this.onLongClickListener = onLongClickListener;
	}

	/**
	 * 设置显示头像
	 * 
	 * */
	public void setHeadUrl(String headUrl, String userNick) {
		this.headUrl = headUrl;
		this.userNick = userNick;
	}

	/**
	 * @Title: setShowVoiceMode
	 * @Description: 设置语音模式
	 * @return void 返回类型
	 * @param @param voiceMode 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public void setShowVoiceMode(int voiceMode) {
		this.voiceMode = voiceMode;
		notifyDataSetChanged();
	}

	/**
	 * @Title: showNick
	 * @Description: 展示或隐藏群聊昵称
	 * @return void 返回类型
	 * @param @param showNick 是否展示
	 * @author donglizhi
	 * @throws
	 */
	public void showNick(int showNick) {
		if (showNick == 0) {
			this.showNick = true;
		} else if (showNick == 1) {
			this.showNick = false;
		}
		notifyDataSetChanged();
	}

	@Override
	public int getCount() {
		int count = 0;
		if (items != null) {
			count = items.size();
		}
		return count;
	}

	@Override
	public Object getItem(int position) {
		return items.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ChatListHolder holder = null;
		if (convertView == null) {
			convertView = View.inflate(context, R.layout.chat_list_cell, null);
			holder = new ChatListHolder();
			holder.chat_listitem_box = (LinearLayout) convertView.findViewById(R.id.chat_listitem_box);
			holder.msgFrame_left = (LinearLayout) convertView.findViewById(R.id.chat_msg_frame_left);
			holder.msgFrame_right = (LinearLayout) convertView.findViewById(R.id.chat_msg_frame_right);
			holder.textContainer_sender = (LinearLayout) convertView.findViewById(R.id.chat_text_container_sender);
			holder.textContainer_recever = (LinearLayout) convertView.findViewById(R.id.chat_text_container_recever);
			holder.text_sender = (TextView) convertView.findViewById(R.id.chat_text_sender); // 聊天内容
			holder.text_recever = (TextView) convertView.findViewById(R.id.chat_text_recever);
			holder.sender = (CircularImage) convertView.findViewById(R.id.chat_sender);// 发送人头像
			holder.receiver = (CircularImage) convertView.findViewById(R.id.chat_reciver);// 接收人头像
			holder.leftStatus = (ImageView) convertView.findViewById(R.id.chat_msg_status_left);// 发送状态图标(左侧)
			holder.chatTimeline = (LinearLayout) convertView.findViewById(R.id.chatTimeline);// 时间分隔(时间框)
			holder.timeShow = (TextView) convertView.findViewById(R.id.chat_time_show);// 时间文字
			holder.systemMsg = (TextView) convertView.findViewById(R.id.chat_system_msg);// 系统消息
			holder.chatVoiceReceverButtonBox = (RelativeLayout) convertView.findViewById(R.id.chatVoiceReceverButtonBox);
			holder.chatVoiceReceverBox = (RelativeLayout) convertView.findViewById(R.id.chatVoiceReceverBox);
			holder.chatVoiceReceverLength = (TextView) convertView.findViewById(R.id.chatVoiceReceverLength);
			holder.chatImageReceverBox = (RelativeLayout) convertView.findViewById(R.id.chatImageReceverBox);
			holder.chatImageReceverContentShow = (CircularImage) convertView.findViewById(R.id.chatImageReceverContentShow);
			holder.chatImageReceverContentShowPercent = (TextView) convertView
					.findViewById(R.id.chatImageReceverContentShowPercent);
			holder.chatVoiceSenderButtonBox = (RelativeLayout) convertView.findViewById(R.id.chatVoiceSenderButtonBox);
			holder.chatVoiceSenderBox = (RelativeLayout) convertView.findViewById(R.id.chatVoiceSenderBox);
			holder.chatVoiceSenderIsRead = (ImageView) convertView.findViewById(R.id.chatVoiceSenderIsRead);
			holder.chatVoiceSenderLength = (TextView) convertView.findViewById(R.id.chatVoiceSenderLength);
			holder.chatImageSenderBox = (LinearLayout) convertView.findViewById(R.id.chatImageSenderBox);
			holder.chatImageSenderContentShow = (CircularImage) convertView.findViewById(R.id.chatImageSenderContentShow);
			holder.showViceMode = (TextView) convertView.findViewById(R.id.chatShowVoiceMode);
			holder.chatVoiceSenderIcon = (ImageView) convertView.findViewById(R.id.chatVoiceSenderIcon);
			holder.chatVoiceReceverIcon = (ImageView) convertView.findViewById(R.id.chatVoiceReceverIcon);
			holder.leftNick = (TextView) convertView.findViewById(R.id.chat_msg_nick_left);
			convertView.setTag(holder);
		} else {
			holder = (ChatListHolder) convertView.getTag();
		}

		holder.msgFrame_left.setVisibility(View.GONE);
		holder.msgFrame_right.setVisibility(View.GONE);
		holder.chatTimeline.setVisibility(View.GONE);

		bindView(convertView, position, holder);

		return convertView;
	}

	public void bindView(View cv, final int position, final ChatListHolder holder) {
		final ChatItem ci = items.get(position);// 聊天内容
		int prevPosition = position - 1;// 获取前一个记录的序列
		prevPosition = prevPosition <= 0 ? 0 : prevPosition;
		boolean isShowTime = false;
		holder.text_sender.setAutoLinkMask(Linkify.WEB_URLS);
		holder.text_recever.setAutoLinkMask(Linkify.WEB_URLS);
		holder.text_sender.setLinksClickable(false);
		holder.text_recever.setLinksClickable(false);
		holder.leftNick.setVisibility(View.GONE);
		holder.showViceMode.setVisibility(View.GONE);
		if (ci.getBoxType() == INBOX) {// recevier
			// 左侧，信息接收方
			holder.sender.setVisibility(View.VISIBLE);
			holder.receiver.setVisibility(View.GONE);
			holder.text_recever.setVisibility(View.GONE);
			holder.text_sender.setVisibility(View.GONE);
			holder.chatVoiceReceverBox.setVisibility(View.GONE);
			holder.chatVoiceSenderBox.setVisibility(View.GONE);
			holder.chatImageReceverBox.setVisibility(View.GONE);
			holder.chatImageSenderBox.setVisibility(View.GONE);
			holder.systemMsg.setVisibility(View.GONE);
			if (ci.getChatType() == 1 && !Util.isBlankString(ci.getGroupUserNick()) && showNick) {
				holder.leftNick.setVisibility(View.VISIBLE);
				holder.leftNick.setText(ci.getGroupUserNick());
			}
			if (ci.getMimeType().equals(ChatConstant.MIME_TYPE_TEXT_PLAIN)) {
				String content = ci.getContent();// 聊天信息内容
				content = Util.delHTMLTagOnly(content);// 去除html标签
				// 文字聊天内容
				// 转换内容中的表情
				SpannableString spannableString = fcu.getExpressionStringAll(context, content);
				holder.text_sender.setText(spannableString);
				holder.text_sender.setVisibility(View.VISIBLE);
			} else if (ci.getMimeType().equals(ChatConstant.MIME_TYPE_AUIDO_AMR)) {
				// 语音聊天内容
				holder.chatVoiceSenderBox.setVisibility(View.VISIBLE);
				holder.chatVoiceSenderLength.setText(String.valueOf(ci.getVoiceLength()) + "″");
				if (ci.getIsAck() == 0) {// 未读
					holder.chatVoiceSenderIsRead.setVisibility(View.VISIBLE);
				} else {// 已读
					holder.chatVoiceSenderIsRead.setVisibility(View.INVISIBLE);
				}
				// 检查文件内容是否存在，不存在则进行文件下载
				if (!Util.isBlankString(ci.getFileName()) && ci.getFileName().indexOf("http://") > -1) {
					downLoadFile(ci.getFileName());
				}
				// 根据语音的长度，进行语音框显示的宽度
				LayoutParams layoutparam = null;
				int width5 = context.getResources().getDimensionPixelSize(R.dimen.voice_msg_min_length);
				int width10 = context.getResources().getDimensionPixelSize(R.dimen.voice_msg_middle_length);
				int widthMax = context.getResources().getDimensionPixelSize(R.dimen.voice_msg_max_length);
				int heightMax = context.getResources().getDimensionPixelSize(R.dimen.img_msg_min_width_height);
				if (ci.getVoiceLength() < 10) {
					layoutparam = new LayoutParams(width5, heightMax);
				} else if (ci.getVoiceLength() >= 10 && ci.getVoiceLength() < 25) {
					layoutparam = new LayoutParams(width10, heightMax);
				} else if (ci.getVoiceLength() >= 25) {
					layoutparam = new LayoutParams(widthMax, heightMax);
				}
				holder.chatVoiceSenderBox.setLayoutParams(layoutparam);
				// 播放图标的设置
				if (ci.getIsPlaying() == 1) {
					AnimationDrawable rocketAnimation;
					int resId = context.getResources().getIdentifier("video_play_left", "anim", context.getPackageName());
					holder.chatVoiceSenderIcon.setBackgroundResource(resId);
					rocketAnimation = (AnimationDrawable) holder.chatVoiceSenderIcon.getBackground();
					rocketAnimation.start();
				} else {
					holder.chatVoiceSenderIcon.setBackgroundResource(R.drawable.bottle_receiver_voice_node_playing003);
				}
				// 点击内容播放语音
				holder.chatVoiceSenderButtonBox.setTag(position);
				holder.chatVoiceSenderButtonBox.setOnClickListener(onClickListener);
				holder.chatVoiceSenderButtonBox.setOnLongClickListener(onLongClickListener);
				// 显示语音模式
				long showTime = SharedPreUtil.getShowVoiceModeTime();
				long msgTime = Util.getLong(ci.getTimeStamp());
				if (msgTime - showTime >= 1000 * 60 * 30 || showTime == msgTime) {// 间隔30分钟展示展示语音模式
					if (msgTime - showTime >= 1000 * 60 * 30) {
						SharedPreUtil.saveShowVoiceModeTime(msgTime);
					}
					holder.showViceMode.setVisibility(View.VISIBLE);
					if (voiceMode == 0) {
						holder.showViceMode.setText("当前是扬声器模式");
					} else {
						holder.showViceMode.setText("当前是听筒模式");
					}
				}
			} else if (ci.getMimeType().equals(ChatConstant.MIME_TYPE_IMAGE_JPEG)) {
				// 图片聊天内容
				int thumbImgWidth = ci.getThumbImageWidth();// 图片缩略图的宽
				int thumbImgHeight = ci.getThumbImageHeight();//
				// 图片缩略图的高
				int max_width_height = context.getResources().getDimensionPixelOffset(R.dimen.img_msg_max_width_height);
				if (thumbImgWidth >= max_width_height && thumbImgHeight >= max_width_height) {
					LayoutParams imgLp = new LayoutParams(max_width_height, max_width_height);
					holder.chatImageSenderContentShow.setLayoutParams(imgLp);
				} else {
					float scale = (float) thumbImgWidth / thumbImgHeight;
					int newWidth = 0;
					int newHeight = 0;
					if (thumbImgHeight < max_width_height && thumbImgWidth < max_width_height) {
						if (scale >= 1) {
							thumbImgWidth = max_width_height;
						} else {
							thumbImgHeight = max_width_height;
						}
					}
					if (thumbImgHeight >= max_width_height) {
						newHeight = max_width_height;
						newWidth = (int) (max_width_height * scale);
					} else if (thumbImgWidth >= max_width_height) {
						newWidth = max_width_height;
						newHeight = (int) (max_width_height / scale);
					} else {
						newWidth = newHeight = max_width_height;
					}
					LayoutParams imgLp = new LayoutParams(newWidth, newHeight);
					holder.chatImageSenderContentShow.setLayoutParams(imgLp);
				}
				holder.imgMsgContainer = J_NetManager.getInstance().loadIMG(holder.imgMsgContainer, ci.getFileNameThumb(),
						holder.chatImageSenderContentShow, R.drawable.error_no_data, R.drawable.error_no_data);
				holder.chatImageSenderBox.setVisibility(View.VISIBLE);
				holder.chatImageSenderBox.setTag(position);
				holder.chatImageSenderBox.setOnClickListener(onClickListener);
			}
			holder.msgFrame_left.setVisibility(View.VISIBLE);// 左侧框架的显示
			// 设置时间显示框
			if (ci.getTimeStamp() != null) {
				/**
				 * 时间显示规则： 1、当前仅有一条记录的情况，显示当前记录时间 2、当前记录与上一条记录跨天的情况，显示当前记录时间
				 * */
				if (getCount() == 1) {
					isShowTime = true;
				}
				if (getCount() > 1 && prevPosition >= 0 && prevPosition < getCount() - 1) {
					ChatItem ciPrev = items.get(prevPosition);// 获取前一条记录
					Long pTime = Long.parseLong(ciPrev.getTimeStamp());
					Long lTime = Long.parseLong(ci.getTimeStamp());// 当前记录的发布时间
					if (lTime - pTime > TimeLimitNum) {
						isShowTime = true;
					}
				}
				if (position == prevPosition) {
					isShowTime = true;
				}
				if (isShowTime) {
					String showTm = Util.getFormatDateTime2(context, ci.getTimeStamp());
					holder.timeShow.setText(showTm);
					holder.chatTimeline.setVisibility(View.VISIBLE);
				}
			}
			// 头像点击事件
			holder.sender.setTag(position);
			holder.sender.setOnClickListener(onClickListener);
			// 设置头像
			if (ci.getChatType() == 0 && !Util.isBlankString(headUrl)) {
				holder.container = J_NetManager.getInstance().loadIMG(holder.container, headUrl, holder.sender,
						R.drawable.icon_avatar, R.drawable.icon_avatar);
			} else if (ci.getChatType() == 1 && !Util.isBlankString(ci.getGroupUserAvatar())) {
				holder.container = J_NetManager.getInstance().loadIMG(holder.container, ci.getGroupUserAvatar(), holder.sender,
						R.drawable.icon_avatar, R.drawable.icon_avatar);
			}
			holder.text_sender.setTag(position);
			holder.text_sender.setOnLongClickListener(onLongClickListener);
			holder.text_sender.setOnClickListener(onClickListener);
		} else if (ci.getBoxType() == OUTBOX) {// sender
			// 右侧，信息发送方
			holder.sender.setVisibility(View.GONE);
			holder.receiver.setVisibility(View.VISIBLE);
			holder.text_recever.setVisibility(View.GONE);
			holder.text_sender.setVisibility(View.GONE);
			holder.chatVoiceReceverBox.setVisibility(View.GONE);
			holder.chatVoiceSenderBox.setVisibility(View.GONE);
			holder.chatImageReceverBox.setVisibility(View.GONE);
			holder.chatImageSenderBox.setVisibility(View.GONE);
			holder.leftStatus.setVisibility(View.GONE);
			holder.systemMsg.setVisibility(View.GONE);
			holder.leftStatus.clearAnimation();
			if (ci.getMimeType().equals(ChatConstant.MIME_TYPE_TEXT_PLAIN)) {
				String content = ci.getContent();// 聊天信息内容
				content = Util.delHTMLTagOnly(content);// 去除html标签
				// 普通文字内容
				// 转换内容中的表情
				SpannableString spannableString = fcu.getExpressionStringAll(context, content);
				holder.text_recever.setText(spannableString);
				holder.text_recever.setVisibility(View.VISIBLE);// 显示文字内容框
			} else if (ci.getMimeType().equals(ChatConstant.MIME_TYPE_AUIDO_AMR)) {
				// 语音内容
				holder.chatVoiceReceverBox.setVisibility(View.VISIBLE);
				holder.chatVoiceReceverLength.setText(String.valueOf(ci.getVoiceLength()) + "″");
				// 检查文件内容是否存在，不存在则进行文件下载
				if (!Util.isBlankString(ci.getFileName()) && ci.getFileName().indexOf("http://") > -1) {
					downLoadFile(ci.getFileName());
				}
				// 根据语音的长度，进行语音框显示的宽度
				LayoutParams layoutparam = null;
				int width5 = context.getResources().getDimensionPixelSize(R.dimen.voice_msg_min_length);
				int width10 = context.getResources().getDimensionPixelSize(R.dimen.voice_msg_middle_length);
				int widthMax = context.getResources().getDimensionPixelSize(R.dimen.voice_msg_max_length);
				int heightMax = context.getResources().getDimensionPixelSize(R.dimen.img_msg_min_width_height);
				if (ci.getVoiceLength() < 10) {
					layoutparam = new LayoutParams(width5, heightMax);
				} else if (ci.getVoiceLength() >= 10 && ci.getVoiceLength() < 25) {
					layoutparam = new LayoutParams(width10, heightMax);
				} else if (ci.getVoiceLength() >= 25) {
					layoutparam = new LayoutParams(widthMax, heightMax);
				}
				holder.chatVoiceReceverBox.setLayoutParams(layoutparam);
				// 播放图标的设置
				if (ci.getIsPlaying() == 1) {
					AnimationDrawable rocketAnimation;
					int resId = context.getResources().getIdentifier("video_play_right", "anim", context.getPackageName());
					holder.chatVoiceReceverIcon.setBackgroundResource(resId);
					rocketAnimation = (AnimationDrawable) holder.chatVoiceReceverIcon.getBackground();
					rocketAnimation.start();
				} else {
					holder.chatVoiceReceverIcon.setBackgroundResource(R.drawable.chatto_voice_playing_f3);
				}
				// 点击内容播放语音
				holder.chatVoiceReceverButtonBox.setTag(position);
				holder.chatVoiceReceverButtonBox.setOnClickListener(onClickListener);
				holder.chatVoiceReceverButtonBox.setOnLongClickListener(onLongClickListener);
			} else if (ci.getMimeType().equals(ChatConstant.MIME_TYPE_IMAGE_JPEG)) {
				// 图片聊天内容
				int thumbImgWidth = ci.getThumbImageWidth();
				int thumbImgHeight = ci.getThumbImageHeight();
				final int max_width_height = context.getResources().getDimensionPixelOffset(R.dimen.img_msg_max_width_height);
				if (thumbImgWidth >= max_width_height && thumbImgHeight >= max_width_height) {
					android.widget.RelativeLayout.LayoutParams imgLp = new android.widget.RelativeLayout.LayoutParams(
							max_width_height, max_width_height);
					holder.chatImageReceverContentShow.setLayoutParams(imgLp);
					holder.chatImageReceverContentShowPercent.setLayoutParams(imgLp);
				} else {
					float scale = (float) thumbImgWidth / thumbImgHeight;
					int newWidth = 0;
					int newHeight = 0;
					if (thumbImgHeight < max_width_height && thumbImgWidth < max_width_height) {
						if (scale >= 1) {
							thumbImgWidth = max_width_height;
						} else {
							thumbImgHeight = max_width_height;
						}
					}
					if (thumbImgHeight >= max_width_height) {
						newHeight = max_width_height;
						newWidth = (int) (max_width_height * scale);
					} else if (thumbImgWidth >= max_width_height) {
						newWidth = max_width_height;
						newHeight = (int) (max_width_height / scale);
					} else {
						newWidth = newHeight = max_width_height;
					}
					android.widget.RelativeLayout.LayoutParams imgLp = new android.widget.RelativeLayout.LayoutParams(newWidth,
							newHeight);
					holder.chatImageReceverContentShow.setLayoutParams(imgLp);
					holder.chatImageReceverContentShowPercent.setLayoutParams(imgLp);
				}
				if (ci.getPercent() >= 0 && ci.getPercent() <= 100) {
					holder.chatImageReceverContentShowPercent.setVisibility(View.VISIBLE);
					holder.chatImageReceverContentShowPercent.setText(ci.getPercent() + "%");
				} else {
					holder.chatImageReceverContentShowPercent.setVisibility(View.GONE);
				}
				if (ci.getFileNameThumb() != null) {
					if (ci.getFileNameThumb().indexOf("http://") > -1) {
						holder.imgMsgContainer = J_NetManager.getInstance().loadIMG(holder.imgMsgContainer,
								ci.getFileNameThumb(), holder.chatImageReceverContentShow, R.drawable.error_no_data,
								R.drawable.error_no_data);
					} else {
						// 需要对图片进行压缩
						File imgFile = new File(ci.getFileNameThumb());
						int GLOBAL_SCREEN_WIDTH = Util.getScreenWidth(context);
						int GLOBAL_SCREEN_HEIGHT = Util.getScreenHeight(context);
						int iss = ImageUtils.getSampleSize(imgFile, GLOBAL_SCREEN_WIDTH, GLOBAL_SCREEN_HEIGHT);
						Options bitmapFactoryOptions = new BitmapFactory.Options();
						bitmapFactoryOptions.inSampleSize = iss;
						InputStream tempImgIs = fs.requestFile(ci.getFileNameThumb());
						Bitmap bm = BitmapFactory.decodeStream(tempImgIs, null, bitmapFactoryOptions);// 很重要------
						if (bm != null) {
							// 缩放图片
							Bitmap bmShow = ImageUtils.resizeImageBitmap(bm, max_width_height);
							holder.chatImageReceverContentShow.setImageBitmap(bmShow);
						} else {
							holder.chatImageReceverContentShow.setImageResource(R.drawable.error_no_data);
						}
					}
				} else {
					holder.chatImageReceverContentShow.setImageResource(R.drawable.error_no_data);
				}
				holder.chatImageReceverBox.setTag(position);
				holder.chatImageReceverBox.setVisibility(View.VISIBLE);
				holder.chatImageReceverBox.setOnClickListener(onClickListener);
			}

			// 设置发送状态
			holder.msgStatus = 0;
			if (ci.getStatus() == ChatConstant.MSG_SYNCHRONIZING) {// 显示发送中的状态
				if (ci.getMimeType().equals(ChatConstant.MIME_TYPE_IMAGE_JPEG)) {
					holder.leftStatus.setVisibility(View.GONE);
				} else {
					holder.leftStatus.setVisibility(View.VISIBLE);
					holder.leftStatus.setBackgroundResource(R.drawable.progress_medium_small_holo);
					Animation rotateAnim = AnimationUtils.loadAnimation(context, R.anim.rotate_anim);
					holder.leftStatus.startAnimation(rotateAnim);
				}
			} else if (ci.getStatus() == ChatConstant.MSG_SYNCHRONIZE_SUCCESS) {// 发送成功
				holder.leftStatus.setVisibility(View.GONE);
			} else {// 发送失败
				holder.leftStatus.setVisibility(View.VISIBLE);
				holder.leftStatus.setBackgroundResource(R.drawable.icn_msg_send_fail);
				holder.msgStatus = 400;
			}
			// 显示右侧的对话框
			holder.msgFrame_right.setVisibility(View.VISIBLE);
			// 设置时间显示框
			if (ci.getTimeStamp() != null) {
				/**
				 * 时间显示规则： 1、当前仅有一条记录的情况，显示当前记录时间 2、当前记录与上一条记录跨天的情况，显示当前记录时间
				 * */
				if (getCount() == 1) {
					isShowTime = true;
				}

				if (getCount() > 1 && prevPosition >= 0 && prevPosition < getCount() - 1) {
					ChatItem ciPrev = items.get(prevPosition);// 获取前一条记录
					Long pTime = Long.parseLong(ciPrev.getTimeStamp());
					Long lTime = Long.parseLong(ci.getTimeStamp());// 当前记录的发布时间
					if (lTime - pTime > TimeLimitNum) {
						isShowTime = true;
					}
				}
				if (position == prevPosition) {
					isShowTime = true;
				}
				if (isShowTime) {
					String showTm = Util.getFormatDateTime2(context, ci.getTimeStamp());
					holder.timeShow.setText(showTm);
					holder.chatTimeline.setVisibility(View.VISIBLE);
				}
			}
			// 加载头像
			holder.container = J_NetManager.getInstance().loadIMG(holder.container, myHeaderUrl, holder.receiver,
					R.drawable.icon_avatar, R.drawable.icon_avatar);
			holder.receiver.setTag(position);
			holder.receiver.setOnClickListener(onClickListener);
			holder.text_recever.setTag(position);
			holder.text_recever.setOnLongClickListener(onLongClickListener);
			holder.text_recever.setOnClickListener(onClickListener);
		} else {
			holder.sender.setVisibility(View.GONE);
			holder.receiver.setVisibility(View.GONE);
			holder.text_recever.setVisibility(View.GONE);
			holder.text_sender.setVisibility(View.GONE);
			holder.chatVoiceReceverBox.setVisibility(View.GONE);
			holder.chatVoiceSenderBox.setVisibility(View.GONE);
			holder.chatImageReceverBox.setVisibility(View.GONE);
			holder.chatImageSenderBox.setVisibility(View.GONE);
			holder.leftStatus.setVisibility(View.GONE);
			holder.systemMsg.setVisibility(View.VISIBLE);
			holder.systemMsg.setText(ci.getContent());
		}
		// 点击隐藏键盘
		holder.chat_listitem_box.setOnTouchListener(new OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				backHandler.sendEmptyMessage(R.id.hide_keyboard);
				return false;
			}
		});
		// 发送失败的情况，错误提示符可以点击操作
		if (holder.msgStatus == 400) {
			holder.leftStatus.setTag(position);
			holder.leftStatus.setOnClickListener(onClickListener);
		}
	}

	class ChatListHolder {
		LinearLayout msgFrame_left;
		LinearLayout msgFrame_right;
		LinearLayout textContainer_sender;
		LinearLayout textContainer_recever;
		LinearLayout chatTimeline;
		CircularImage sender;
		CircularImage receiver;
		TextView text_sender;
		TextView text_recever;
		TextView timeShow;
		ImageView leftStatus;

		// 左侧
		RelativeLayout chatVoiceSenderBox;// 语音内容显示框
		RelativeLayout chatVoiceSenderButtonBox;// 语音按钮
		TextView chatVoiceSenderLength;// 语音时间长度显示文字
		ImageView chatVoiceSenderIsRead;// 语音内容是否已读标记
		LinearLayout chatImageSenderBox;// 图片内容显示框
		CircularImage chatImageSenderContentShow;// 图片内容
		ImageView chatVoiceSenderIcon;// 三角图标
		// 右侧
		RelativeLayout chatVoiceReceverBox;
		RelativeLayout chatVoiceReceverButtonBox;// 语音按钮
		TextView chatVoiceReceverLength;// 语音时间长度显示文字
		RelativeLayout chatImageReceverBox;// 图片内容显示框
		CircularImage chatImageReceverContentShow;// 图片内容
		TextView chatImageReceverContentShowPercent;// 图片消息上传进度
		ImageView chatVoiceReceverIcon;// 右侧三角图标
		int msgStatus;// 消息状态
		LinearLayout chat_listitem_box;
		TextView systemMsg;// 系统消息
		ImageContainer container;// 头像
		ImageContainer imgMsgContainer;// 图片消息
		TextView leftNick;// 左侧昵称
		TextView showViceMode;// 显示消息模式
	}

	/**
	 * 播放语音
	 * 
	 * @Description
	 * @param name
	 */
	private void playVoice(String name) {
		try {
			if (mMediaPlayer.isPlaying()) {
				mMediaPlayer.stop();
			}

			mMediaPlayer.reset();
			mMediaPlayer.setDataSource(name);
			mMediaPlayer.prepare();
			mMediaPlayer.start();
			mMediaPlayer.setOnCompletionListener(new OnCompletionListener() {
				@Override
				public void onCompletion(MediaPlayer mp) {
					clearPlayingVoice();
				}
			});
		} catch (Exception e) {
			e.printStackTrace();
			clearPlayingVoice();
		}
	}

	/**
	 * 点击播放语音的处理
	 * 
	 * @param position
	 */
	private void readyForPlayingVoice(final int position) {
		if (mMediaPlayer.isPlaying() && position == playPosition) {
			// 如果现在音频正在播放，而且播放的内容和当前点击的内容是同一条，做停止播放处理
			clearPlayingVoice();
		} else {
			// 判断是否有语音播放，先清除之前播放的语音，再继续播放现在的语音
			clearPlayingVoice();
			if (items != null && items.size() > 0) {
				ChatItem ci = items.get(position);
				// 播放语音
				String voicePath = fs.getFileSdcardAndRamPath(ci.getFileName());
				File voiceFile = null;
				if (!Util.isBlankString(voicePath)) {
					voiceFile = new File(voicePath);
				}
				if (voiceFile != null && voiceFile.exists()) {
					playPosition = position;
					ci.setIsPlaying(1);// 设置为正在播放
					if (ci.getBoxType() == INBOX) {// 读取对方发送的语音消息
						// 设置为已读
						ci.setIsAck(1);
						// 数据库中标记该语音消息为已读
						helper.updateUnreadMsgStatus(ci.getMsgId());
					}
					items.set(position, ci);// 更新数据
					// 刷新页面
					notifyDataSetChanged();
					// 播放语音
					playVoice(voicePath);
				} else if (!FileUtils.isSDCardExist()) {
					ToastUtil.showToast(context, context.getString(R.string.str_not_install_sd_card));
				} else {
					// 检查文件内容是否存在，不存在则进行文件下载
					if (!Util.isBlankString(ci.getFileName()) && ci.getFileName().indexOf("http://") > -1) {
						downLoadFile(ci.getFileName());
						new Handler().postDelayed(new Runnable() {
							@Override
							public void run() {
								readyForPlayingVoice(position);
							}
						}, 2000);
					}
				}
			}
		}
	}

	/**
	 * 清除正在播放的语音
	 * 
	 * */
	public void clearPlayingVoice() {
		try {
			// 停止播放语音
			if (mMediaPlayer.isPlaying()) {
				mMediaPlayer.stop();
				mMediaPlayer.reset();
			}
			// 更新播放中的状态图标
			if (playPosition >= 0) {
				items.get(playPosition).setIsPlaying(0);
				notifyDataSetChanged();
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 释放资源
	 * 
	 * */
	public void clear() {
		backHandler = null;
		context = null;
		clearPlayingVoice();
		if (items != null) {
			items.clear();
		}
		if (mMediaPlayer != null) {
			mMediaPlayer.stop();
			mMediaPlayer.reset();
			mMediaPlayer = null;
		}
		if (fcu != null) {
			fcu.clearAll();
			fcu = null;
		}
	}

	private void downLoadFile(String url) {
		final File file = new File(fs.getFileStorePath(), MD5.md5(url));
		if (!file.exists()) {
			J_NetManager.getInstance().downloadFile(url, file.getAbsolutePath(), new RequestCallBack<File>() {
				@Override
				public void onSuccess(ResponseInfo<File> responseInfo) {
				}

				@Override
				public void onFailure(HttpException error, String msg) {
				}
			});
		}
	}

	/**
	 * @Title: showLargePhoto
	 * @Description: 查看大图
	 * @return void 返回类型
	 * @param @param ci 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void showLargePhoto(final ChatItem ci) {
		final ArrayList<PhotoInfoBean> photoInfoBeans = new ArrayList<PhotoInfoBean>();
		int index = 0;
		for (int i = 0; i < items.size(); i++) {
			if (ChatConstant.MIME_TYPE_IMAGE_JPEG.equals(items.get(i).getMimeType())) {
				PhotoInfoBean photoInfoBean = new PhotoInfoBean();
				if (items.get(i).getBoxType() == 2) {
					photoInfoBean.nick = J_Cache.sLoginUser.nickName;
				} else if (items.get(i).getChatType() == 0) {
					photoInfoBean.nick = userNick;
				} else if (items.get(i).getChatType() == 1) {
					photoInfoBean.nick = items.get(i).getGroupUserNick();
				}
				if (ci.getFileName() != null) {
					if (ci.getFileName().indexOf("http://") > -1) {
						photoInfoBean.url = items.get(i).getFileName();
						photoInfoBean.url_small = items.get(i).getFileNameThumb();
						photoInfoBean.pid = items.get(i).getPid();
						if (items.get(i).getChatType() == 0) {// 普通聊天
							photoInfoBean.uid = Util.getLong(items.get(i).getContactId());
						} else if (items.get(i).getChatType() == 1) {// 群组聊天
							photoInfoBean.uid = Util.getLong(items.get(i).getGroupUserUid());
						}
					}
				} else {
					photoInfoBean.picPath = fs.getFileSdcardAndRamPath(ci.getFileNameThumb());
				}
				photoInfoBeans.add(photoInfoBean);
				if (items.get(i).getId() == ci.getId()) {
					index = photoInfoBeans.size() - 1;
				}
			}
		}
		Intent photoViewIntent = new Intent(context, ProfilePhotoViewActivity.class);
		photoViewIntent.putExtra("photoInfo", photoInfoBeans);
		photoViewIntent.putExtra("index", index);
		photoViewIntent.putExtra("viewType", 1);
		context.startActivity(photoViewIntent);
	}

	private final OnClickListener onClickListener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			int position = (Integer) v.getTag();
			ChatItem ci = items.get(position);
			switch (v.getId()) {
			case R.id.chatVoiceSenderButtonBox:
			case R.id.chatVoiceReceverButtonBox:
				readyForPlayingVoice(position);// 播放设置
				break;
			case R.id.chatImageSenderBox:// 查看大图
			case R.id.chatImageReceverBox:
				showLargePhoto(ci);
				break;
			case R.id.chat_reciver:// 点击自己的头像
				long current_uid = SharedPreUtil.getLoginInfo().uid;
				Intent current_intent = new Intent(context, ProfileViewActivity.class);
				current_intent.putExtra(UtilRequest.FORM_UID, current_uid);
				context.startActivity(current_intent);
				break;
			case R.id.chat_sender:// 点击头像进入个人主页
				if (ci.getChatType() == 1) {
					if (!Util.isBlankString(ci.getGroupUserUid())) {
						long uid = Long.valueOf(ci.getGroupUserUid());
						Intent intent = new Intent(context, ProfileViewActivity.class);
						intent.putExtra(UtilRequest.FORM_UID, uid);
						context.startActivity(intent);
					}
				} else {
					if (!Util.isBlankString(ci.getContactId())) {
						long uid = Long.valueOf(ci.getContactId());
						Intent intent = new Intent(context, ProfileViewActivity.class);
						intent.putExtra(UtilRequest.FORM_UID, uid);
						context.startActivity(intent);
					}
				}
				break;
			case R.id.chat_text_sender:// 点击链接进入个人主页
			case R.id.chat_text_recever:
				String text = ci.getContent();// 聊天信息内容
				long uid = Util.hasUserProfileUrl(text);
				if (uid > 0) {
					Intent intent = new Intent(context, ProfileViewActivity.class);
					intent.putExtra(UtilRequest.FORM_UID, uid);
					context.startActivity(intent);
				}
				break;
			case R.id.chat_msg_status_left:// 发送失败
				backHandler.sendMessage(backHandler.obtainMessage(R.id.resend_msg, position));
				break;
			}
		}
	};
}
