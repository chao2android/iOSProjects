package com.iyouxun.ui.activity.news;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.animation.Animation;
import android.view.animation.Animation.AnimationListener;
import android.view.animation.AnimationUtils;
import android.widget.AbsListView;
import android.widget.AbsListView.OnScrollListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.FrameLayout;
import android.widget.FrameLayout.LayoutParams;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.ListView;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.handmark.pulltorefresh.library.PullToRefreshBase;
import com.handmark.pulltorefresh.library.PullToRefreshBase.Mode;
import com.handmark.pulltorefresh.library.PullToRefreshBase.OnRefreshListener;
import com.handmark.pulltorefresh.library.PullToRefreshListView;
import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.comparator.PhotoByPidComparator;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.CommentInfoBean;
import com.iyouxun.data.beans.NewsInfoBean;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.data.beans.users.BaseUser;
import com.iyouxun.data.beans.users.LoginUser;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.FriendsMakeFriendsShipRequest;
import com.iyouxun.net.request.GetOneUserDynamicListRequest;
import com.iyouxun.net.request.GetRecommendDynamicListRequest;
import com.iyouxun.net.request.J_OnDataBack;
import com.iyouxun.net.request.NoticeNewDynamicRequest;
import com.iyouxun.net.request.RebroadcastDynamicRequest;
import com.iyouxun.net.request.SendCommentRequest;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.net.response.ReplyCommentRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.MainBoxActivity;
import com.iyouxun.ui.activity.center.ProfileViewActivity;
import com.iyouxun.ui.adapter.NewsListInfoAdapter;
import com.iyouxun.ui.dialog.MenuPopDialog;
import com.iyouxun.ui.dialog.UploadContactsDialog;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.ui.views.NewsFaceRelativeLayout;
import com.iyouxun.utils.DLog;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 熟人圈（动态）主页面
 * 
 * @author likai
 * @date 2015-2-28 上午9:38:44
 * 
 */
public class NewsMainActivity extends CommTitleActivity {
	private LinearLayout recommendContentBox;
	private PullToRefreshListView newsMainListView;
	private FrameLayout recommendWarmBox;// 提醒框
	// 公共输入框
	private RelativeLayout news_global_edittext_box;// 键盘层
	private NewsFaceRelativeLayout faceRelativeLayout;// 键盘
	private Button btn_setting_msg;// 发送评论按钮
	private EditText input_msg_text;// 评论输入框

	private TextView newsMainEmptyLayer;// 空数据层

	// header层
	private View recommenWarmLayer;
	private LinearLayout recommendFriendsBox;
	private LinearLayout recommendFriendsLayer;
	private RelativeLayout recommendContactLayer;
	private RelativeLayout recommendMsgLayer;

	/** 赞+1，广播+1 */
	private ImageView praise_anim_icon;
	private ImageView rebroadcast_anim_icon;

	private TextView footerLvTv;

	private NewsListInfoAdapter adapter;

	private final ArrayList<BaseUser> recommendFriends = new ArrayList<BaseUser>();

	protected List<NewsInfoBean> datas = new ArrayList<NewsInfoBean>();
	/** 如果uid==0：熟人圈，uid>0：查看个人的动态 */
	private long CURRNET_UID = 0;

	/** 每页加载数量 */
	private final int PAGE_NUM = 10;
	/** 分页动态id */
	private int PAGE_DY_ID = 0;
	/** 是否只看单身 */
	private int is_look_single = 0;
	/** 当前操作的序列(赞、评论、转发) */
	protected int CURRENT_MANAGE_INDEX = -1;
	/** 1:评论动态，2：回复评论 */
	protected int CURRENT_MANAGE_TYPE = 0;
	/** 当前评论的评论内容 */
	private CommentInfoBean CURRENT_REPLY_COMMENT;
	/** 跳转到动态详情页的 */
	private static final int REQUEST_CODE_DETAIL = 0X4000;
	public static final int RESULT_CODE_OK = 0X4001;
	/** 是否可以滑动加载，0：否，1：可以，2，否，提示信息做改动 */
	private int isCanLoading = 1;
	/** 是否首次加载页面 */
	protected boolean isFristLoad = true;
	private int totalHeight;
	private LoginUser currentUser = new LoginUser();

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		CURRNET_UID = getIntent().getLongExtra("uid", 0);
		currentUser = (LoginUser) getIntent().getSerializableExtra("userInfo");
		if (currentUser == null) {
			currentUser = new LoginUser();
		}
		// 点击标题滚动到顶部
		titleCenter.setOnClickListener(listener);

		if (CURRNET_UID == 0) {
			// 熟人圈--左侧筛选-右侧添加
			// 中间标题
			titleCenter.setText(getString(R.string.news));
			// 左侧筛选
			titleLeftButton.setVisibility(View.VISIBLE);
			titleLeftButton.setOnClickListener(listener);
			titleLeftButton.setCompoundDrawablesWithIntrinsicBounds(R.drawable.icon_search, 0, 0, 0);
			// 右侧按钮
			titleRightButton.setVisibility(View.VISIBLE);
			titleRightButton.setOnClickListener(listener);
			titleRightButton.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.icon_create_new, 0);
		} else {
			// 个人动态
			if (CURRNET_UID == J_Cache.sLoginUser.uid) {
				titleCenter.setText("我的动态");
			} else {
				if (currentUser.sex == 0) {
					titleCenter.setText("她的动态");
				} else {
					titleCenter.setText("他的动态");
				}
			}
			if (CURRNET_UID == J_Cache.sLoginUser.uid) {
				// 当前登录用户-右侧按钮
				titleRightButton.setVisibility(View.VISIBLE);
				titleRightButton.setOnClickListener(listener);
				titleRightButton.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.icon_create_new, 0);
			}

			// 左侧返回
			titleLeftButton.setText("返回");
			titleLeftButton.setVisibility(View.VISIBLE);
		}
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_news_main, null);
	}

	@Override
	protected void initViews() {
		recommendContentBox = (LinearLayout) findViewById(R.id.recommendContentBox);
		newsMainListView = (PullToRefreshListView) findViewById(R.id.newsMainListView);
		recommendWarmBox = (FrameLayout) findViewById(R.id.recommendWarmBox);
		news_global_edittext_box = (RelativeLayout) findViewById(R.id.news_global_edittext_box);
		faceRelativeLayout = (NewsFaceRelativeLayout) findViewById(R.id.FaceRelativeLayout);
		btn_setting_msg = (Button) findViewById(R.id.btn_setting_msg);
		input_msg_text = (EditText) findViewById(R.id.input_msg_text);
		recommendContactLayer = (RelativeLayout) findViewById(R.id.recommendContactLayer);
		recommendMsgLayer = (RelativeLayout) findViewById(R.id.recommendMsgLayer);
		newsMainEmptyLayer = (TextView) findViewById(R.id.newsMainEmptyLayer);

		if (CURRNET_UID == 0) {
			// 禁用硬件加速（避免内存小的手机使用硬件加速时出现内存溢出的问题）
			newsMainListView.setLayerType(View.LAYER_TYPE_SOFTWARE, null);
		}
		// 滑动到底部的时候的缓冲提示
		newsMainListView.setPullToRefreshOverScrollEnabled(false);
		// 空数据提示信息
		newsMainListView.getRefreshableView().setEmptyView(newsMainEmptyLayer);
		// 设置仅可向下拉动
		newsMainListView.setMode(Mode.PULL_FROM_START);

		// 底部加载loading提示框
		View footerView = View.inflate(mContext, R.layout.footer_listview_layer, null);
		footerLvTv = (TextView) footerView.findViewById(R.id.footerLvTv);
		newsMainListView.getRefreshableView().addFooterView(footerView);

		// 发送评论按钮事件
		btn_setting_msg.setOnClickListener(listener);

		// 页面添加“赞+1，广播+1”图标
		View animView = View.inflate(mContext, R.layout.praise_rebroadcast_anim_layer, null);
		praise_anim_icon = (ImageView) animView.findViewById(R.id.praise_anim_icon);
		rebroadcast_anim_icon = (ImageView) animView.findViewById(R.id.rebroadcast_anim_icon);
		getRootView().addView(animView);

		// TODO 熟人圈-添加header中的层(推荐用户列表)
		if (newsMainListView.getRefreshableView().getHeaderViewsCount() <= 1) {
			recommenWarmLayer = View.inflate(mContext, R.layout.view_recommend_warm_layout, null);
			newsMainListView.getRefreshableView().addHeaderView(recommenWarmLayer);
			// 获取推荐层内控件
			recommendFriendsBox = (LinearLayout) recommenWarmLayer.findViewById(R.id.recommendFriendsBox);
			recommendFriendsLayer = (LinearLayout) recommenWarmLayer.findViewById(R.id.recommendFriendsLayer);
		}

		// 设置adapter，setAdapter要放在addHeaderView的后面
		adapter = new NewsListInfoAdapter(mContext);
		adapter.setHandler(mHandler);
		adapter.setData(datas);
		newsMainListView.setAdapter(adapter);

		// 设置下拉刷新事件
		newsMainListView.setOnRefreshListener(new OnRefreshListener<ListView>() {
			@Override
			public void onRefresh(PullToRefreshBase<ListView> refreshView) {
				hideFooterLoading(1);
				PAGE_DY_ID = 0;
				getNewsListInfo();
			}
		});
		// 滑动到底部，自动加载
		newsMainListView.setOnScrollListener(new OnScrollListener() {
			/*
			 * scrollState值： 当屏幕停止滚动时为SCROLL_STATE_IDLE = 0；
			 * 当屏幕滚动且用户使用的触碰或手指还在屏幕上时为SCROLL_STATE_TOUCH_SCROLL = 1；
			 * 由于用户的操作，屏幕产生惯性滑动时为SCROLL_STATE_FLING = 2
			 */
			@Override
			public void onScrollStateChanged(AbsListView view, int scrollState) {
				if (scrollState == OnScrollListener.SCROLL_STATE_IDLE) {
					if (view.getLastVisiblePosition() <= (view.getCount() - 3)
							|| view.getLastVisiblePosition() == (view.getCount() - 1)) {
						if (isCanLoading == 1 && datas.size() > 0) {
							showFooterLoading(0);
							getNewsListInfo();
						}
					}
				}
			}

			/*
			 * firstVisibleItem:表示在现时屏幕第一个ListItem(部分显示的ListItem也算)在整个ListView的位置
			 * (下标从0开始) visibleItemCount:表示在现时屏幕可以见到的ListItem(部分显示的ListItem也算)总数
			 * totalItemCount:表示ListView的ListItem总数
			 * listView.getFirstVisiblePosition
			 * ()表示在现时屏幕第一个ListItem(第一个ListItem部分显示也算)在整个ListView的位置(下标从0开始)
			 * listView
			 * .getLastVisiblePosition()表示在现时屏幕最后一个ListItem(最后ListItem要完全显示出来才算
			 * )在整个ListView的位置(下标从0开始)
			 */
			@Override
			public void onScroll(AbsListView view, int firstVisibleItem, int visibleItemCount, int totalItemCount) {
				// int currentIndex = firstVisibleItem + visibleItemCount;
				// if (totalItemCount - currentIndex < 3 && isCanLoading == 1 &&
				// datas.size() > 0) {
				// showFooterLoading(0);
				// getNewsListInfo();
				// }
			}
		});
		// 点击列表中的某一项，跳转至详情页
		newsMainListView.getRefreshableView().setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				// 隐藏键盘
				hideKeyboard();
				// 跳转页面
				int headerCount = newsMainListView.getRefreshableView().getHeaderViewsCount();
				int realPosition = position - headerCount;
				if (realPosition >= 0 && realPosition < datas.size()) {
					NewsInfoBean bean = datas.get(realPosition);
					Intent detailIntent = new Intent(mContext, NewsDetailActivity.class);
					detailIntent.putExtra("feedId", bean.feedId);
					startActivityForResult(detailIntent, REQUEST_CODE_DETAIL);
				}
			}
		});

		if (CURRNET_UID == 0) {
			// “熟人圈”推荐列表页
			if (J_Cache.sLoginUser.friends_num > 0) {
				// 用户已经有好友
				// 获取推荐动态列表
				showLoading();
				getRecommendNews(true);
			} else {
				// 用户还没有好友
				if (J_Cache.sLoginUser.marriage != 1) {
					// 用户为非单身状态
					if (J_Cache.sLoginUser.callno_upload == 0) {
						// 非单身，无好友，未上传通讯录：引导上传通讯录
						newsMainListView.setMode(Mode.DISABLED);
						newsMainEmptyLayer.setText("导入通讯录，看看好友在做什么");
						newsMainEmptyLayer.setOnClickListener(new OnClickListener() {
							@Override
							public void onClick(View v) {
								// 打开导入通讯录的弹层页面
								showUploadContactsDialog(false);
							}
						});
					} else {
						// 非单身，无好友，已经上传通讯录：那就获取下列表吧
						showLoading();
						getRecommendNews(true);
					}
				} else {
					// 用户单身，无好友：按照推荐规则获取动态列表
					// 获取推荐列表信息
					showLoading();
					// 获取推荐动态列表
					getRecommendNews(true);
				}
			}
			// 推荐用户
			if (J_Cache.sLoginUser.marriage == 1) {
				// 1、单身
				// 2、导入通讯录，但好友数＜5（或未导入通讯录，无好友）
				if ((J_Cache.sLoginUser.callno_upload == 1 && J_Cache.sLoginUser.friends_num < 5)
						|| (J_Cache.sLoginUser.callno_upload == 0 && J_Cache.sLoginUser.friends_num <= 0)) {
					// 获取推荐朋友-只有在查看推荐列表的时候
					getRecommendFriends();
				}
			}
			// 有动态相关推送时（刷新新消息数字），注册监听（只在作为熟人圈推荐页面的时候，接受处理该消息）
			J_Application.pushActiviy.put("NewsMainActivity", this);
		} else {
			// 用户个人动态列表页
			if (CURRNET_UID == SharedPreUtil.getLoginInfo().uid) {
				// 如果是登录用户自己的动态页，发布完成新动态后，进行刷新操作(因为共用一个页面，所以要区分)
				J_Application.pushActiviy.put("NewsMainActivityRefreshListener_" + SharedPreUtil.getLoginInfo().uid, this);
			}

			// 获取单个用户的动态列表
			showLoading();
			getOneUserNews();
		}
	}

	@Override
	protected void onResume() {
		super.onResume();
		// 当前页面为“熟人圈”页面
		if (CURRNET_UID == 0) {
			// 如果当前列表中没有数据，则重新加载数据
			if (!isFristLoad) {
				if (datas.size() <= 0) {
					// 获取推荐动态列表
					getRecommendNews(false);
				}
				// 推荐用户
				if (recommendFriends.size() <= 0 && J_Cache.sLoginUser.marriage == 1) {
					// 1、单身
					// 2、导入通讯录，但好友数＜5（或未导入通讯录，无好友）
					if ((J_Cache.sLoginUser.callno_upload == 1 && J_Cache.sLoginUser.friends_num < 5)
							|| (J_Cache.sLoginUser.callno_upload == 0 && J_Cache.sLoginUser.friends_num <= 0)) {
						// 获取推荐朋友-只有在查看推荐列表的时候
						getRecommendFriends();
					}
				}
			}
			// 设置为非首次加载页面
			isFristLoad = false;
			// 检查页面的提示信息情况
			checkCurrentStatus();
		}

		// 设置listview的高度
		// setListViewHeight();
	}

	/**
	 * 检查当前状态，“导入通讯录”操作是否已经执行
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void checkCurrentStatus() {
		// 只有熟人圈才会进行该内容检查
		// 还未上传过通讯录
		if (SharedPreUtil.getLoginInfo().callno_upload == 0 && SharedPreUtil.isNewUser()) {
			// 新用户显示上传通讯录对话框
			SharedPreUtil.setNewUser(false);
			mHandler.postDelayed(new Runnable() {
				@Override
				public void run() {
					// 弹出导入通讯录的弹层
					showUploadContactsDialog(true);
				}
			}, 500);
		}

		// 先检查新消息数字，没有新消息数字，提醒上传通讯录
		checkMsgNumAndUpload();
	}

	/**
	 * 先检查新消息数字，没有新消息数字，提醒上传通讯录
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void checkMsgNumAndUpload() {
		// 检查新消息提醒层的展示情况
		// 获取已有的新消息提醒数字
		int newMsgNum = SharedPreUtil.getNewsNewMsgData();
		if (newMsgNum <= 0) {
			if (recommendContactLayer.getVisibility() == View.GONE) {
				recommendWarmBox.setVisibility(View.GONE);
				recommendMsgLayer.setVisibility(View.GONE);
			}
		}
		// 获取数字
		new NoticeNewDynamicRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				int retcode = response.retcode;
				if (retcode == 1) {
					try {
						PushMsgInfo bean = new PushMsgInfo();
						// 计算总数量
						bean.newsMsgcount = Util.getInteger(response.data);
						// 回调方法
						receivePushMsg(bean);
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).execute();

	}

	/**
	 * 弹出导入通讯录的弹层
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void showUploadContactsDialog(final boolean isFirst) {
		new UploadContactsDialog(mContext, R.style.dialog).setCallBack(new OnSelectCallBack() {
			@Override
			public void onCallBack(String value1, String value2, String value3) {
				if (value1.equals("0")) {
					// 导入成功
					// 如果当前列表为禁用状态，进行禁用状态接触
					if (newsMainListView.getMode() == Mode.DISABLED) {
						newsMainListView.setMode(Mode.PULL_FROM_START);
					}
					// 关闭提示框
					recommendContactLayer.setVisibility(View.GONE);
					recommendWarmBox.setVisibility(View.GONE);
					// 如果当前列表中没有数据，则重新加载数据
					if (datas.size() <= 0) {
						// 获取推荐动态列表
						showLoading();
						mHandler.postDelayed(new Runnable() {
							@Override
							public void run() {
								getRecommendNews(false);
							}
						}, 1500);
					}
					// 推荐用户
					if (recommendFriends.size() <= 0 && J_Cache.sLoginUser.marriage == 1) {
						// 1、单身
						// 2、导入通讯录，但好友数＜5（或未导入通讯录，无好友）
						if ((J_Cache.sLoginUser.callno_upload == 1 && J_Cache.sLoginUser.friends_num < 5)
								|| (J_Cache.sLoginUser.callno_upload == 0 && J_Cache.sLoginUser.friends_num <= 0)) {
							// 获取推荐朋友-只有在查看推荐列表的时候
							getRecommendFriends();
						}
					}
					// 重新设置listview高度
					// setListViewHeight();
				} else if (value1.equals("2") && isFirst) {
					// 首次弹窗，取消操作
					new FriendsMakeFriendsShipRequest(null).execute();
				}
			}
		}).show();
	}

	@Override
	public void onWindowFocusChanged(boolean hasFocus) {
		super.onWindowFocusChanged(hasFocus);
		if (totalHeight == 0) {
			totalHeight = recommendContentBox.getMeasuredHeight();
		}

		// setListViewHeight();
	}

	/**
	 * 设置listview高度
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setListViewHeight() {
		if (recommendWarmBox.getVisibility() == View.GONE) {
			// 顶部提示栏不存在
			// 要重新设置下pullToRefreshListView的高度
			LayoutParams params = new LayoutParams(LayoutParams.MATCH_PARENT, totalHeight);
			newsMainListView.setLayoutParams(params);
		} else {
			// 顶部提示栏存在
			int warmLayerHeight = recommendWarmBox.getMeasuredHeight();
			int showListHeight = totalHeight - warmLayerHeight;
			LayoutParams params = new LayoutParams(LayoutParams.MATCH_PARENT, showListHeight);
			newsMainListView.setLayoutParams(params);
		}
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		if (CURRNET_UID == 0) {
			// 有动态相关推送时，注册监听（只在作为熟人圈推荐页面的时候，接受处理该消息）
			J_Application.pushActiviy.remove("NewsMainActivity");
		}

		if (CURRNET_UID == J_Cache.sLoginUser.uid) {
			// 发布完成新动态后，进行刷新操作(因为共用一个页面，所以要区分)
			J_Application.pushActiviy.remove("NewsMainActivityRefreshListener_" + CURRNET_UID);
		}
	}

	/**
	 * 接收到刷新页面的监听
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public void receiveRefresh() {
		// 跳转到顶部
		newsMainListView.getRefreshableView().smoothScrollToPosition(0);
		// 刷新只能打开下拉刷新-避免会从底部刷新的情况出现
		newsMainListView.setMode(Mode.PULL_FROM_START);
		// 刷新页面
		PAGE_DY_ID = 0;
		// 刷新页面信息
		newsMainListView.setRefreshing();
	}

	/**
	 * 接收到的推送消息
	 * 
	 * @return void 返回类型
	 * @param @param info 参数类型
	 * @author likai
	 * @throws
	 */
	public void receivePushMsg(PushMsgInfo info) {
		// 保存数字
		SharedPreUtil.setNewsNewMsgData(info.newsMsgcount);
		// 进行页面提醒
		getWarmMsgInfo();
		// 外层主导航，显示红点
		if (info.newsMsgcount > 0) {
			((MainBoxActivity) getParent()).showRedDot(0);
		}
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (requestCode == REQUEST_CODE_DETAIL && resultCode == RESULT_CODE_OK) {
			// 删除动态后的返回
			int feedId = data.getIntExtra("feedId", 0);
			for (int i = 0; i < datas.size(); i++) {
				NewsInfoBean bean = datas.get(i);
				if (bean.feedId == feedId) {
					datas.remove(i);
					break;
				}
			}
			mHandler.sendEmptyMessage(0x10000);
		}
	}

	/**
	 * 获取推荐朋友
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getRecommendFriends() {
		if (android.os.Build.MODEL.equals("HTC T328d") || android.os.Build.VERSION.SDK_INT < 16) {
			// release:4.0.3|sdk:15|mode:HTC T328d
			// release:4.0.4|sdk:15|mode:ZTE U960s3
			DLog.d("likai-test", "该手机不予推荐用户|release:" + android.os.Build.VERSION.RELEASE + "|sdk:"
					+ android.os.Build.VERSION.SDK_INT + "|mode:" + android.os.Build.MODEL);
			return;
		}
		UtilRequest.getRecommendNewUsers(1, 10, mHandler);
	}

	/**
	 * 设置显示推荐朋友数据
	 * 
	 * @Title: displayRecommendFriends
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void displayRecommendFriends() {
		// 移除掉该层的所有数据
		recommendFriendsBox.removeAllViews();
		if (recommendFriends.size() > 0) {
			// 获取到推荐数据
			for (int i = 0; i < recommendFriends.size(); i++) {
				final BaseUser tmpUser = recommendFriends.get(i);
				View view = View.inflate(mContext, R.layout.item_recommend_friends, null);
				if (Util.getScreenDensityDpi(mContext) >= 320) {
					view = View.inflate(mContext, R.layout.item_recommend_friends, null);
				} else {
					view = View.inflate(mContext, R.layout.item_recommend_friends_small, null);
				}
				CircularImage recommend_friend_avatar = (CircularImage) view.findViewById(R.id.recommend_friend_avatar);
				TextView recommend_friend_nick = (TextView) view.findViewById(R.id.recommend_friend_nick);
				// 加载头像
				J_NetManager.getInstance().loadIMG(null, tmpUser.avatarUrl, recommend_friend_avatar, R.drawable.icon_avatar,
						R.drawable.icon_avatar);
				// 加载昵称
				recommend_friend_nick.setText(tmpUser.nickName);
				// 点击头像和昵称
				recommend_friend_avatar.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
						profileIntent.putExtra("uid", tmpUser.uid);
						startActivity(profileIntent);
					}
				});
				recommend_friend_nick.setOnClickListener(new OnClickListener() {
					@Override
					public void onClick(View v) {
						Intent profileIntent = new Intent(mContext, ProfileViewActivity.class);
						profileIntent.putExtra("uid", tmpUser.uid);
						startActivity(profileIntent);
					}
				});
				recommendFriendsBox.addView(view);
			}// 显示该层
			recommendFriendsLayer.setVisibility(View.VISIBLE);
		} else {
			// 未获取到推荐用户数据，隐藏该层
			recommendFriendsLayer.setVisibility(View.GONE);
		}
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(final Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_GET_RECOMMEND_NEW_USERS:
				// 获取推荐好友列表
				J_Response responseRecom = (J_Response) msg.obj;
				if (responseRecom.retcode == 1) {
					try {
						if (!Util.isBlankString(responseRecom.data)) {
							JSONArray recommData = new JSONArray(responseRecom.data);
							if (recommData.length() > 0) {
								// 获取到新数据后，删除就数据
								recommendFriends.clear();
								for (int i = 0; i < recommData.length(); i++) {
									JSONObject singleRecom = recommData.optJSONObject(i);
									BaseUser user = new BaseUser();
									user.uid = singleRecom.optLong("uid");
									user.nickName = singleRecom.optString("nick");
									JSONObject avatarObj = singleRecom.optJSONObject("avatar");
									user.avatarUrl = avatarObj.optString("200");
									if (recommendFriends.size() < 10) {
										recommendFriends.add(user);
									}
								}
							} else {
								ToastUtil.showToast(mContext, "没有更多了");
							}
						}
						displayRecommendFriends();
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
				dismissLoading();
				break;
			case 0x10000:
				// 刷新adapter动态列表
				// 权限设置
				if (CURRNET_UID > 0 && CURRNET_UID != J_Cache.sLoginUser.uid) {
					// 非当前登录用户的其他用户动态页面
					LoginUser user = SharedPreUtil.getNormalUser(CURRNET_UID);
					if (user.allow_my_profile_show == 3 && user.isFriend != 1 && datas.size() >= 5) {
						datas = datas.subList(0, 5);
						hideFooterLoading(2);
						newsMainListView.setMode(Mode.DISABLED);
					} else {
						newsMainListView.setMode(Mode.PULL_FROM_START);
					}
				} else {
					newsMainListView.setMode(Mode.PULL_FROM_START);
				}
				adapter.setData(datas);
				adapter.notifyDataSetChanged();
				newsMainListView.onRefreshComplete();
				// 没有数据的显示状态
				// 1、熟人圈，上传过通讯录的，显示没有发布动态
				// 2、个人动态页，没有发布动态数据的，显示没有发布动态
				if ((currentUser.uid <= 0 && datas.size() <= 0 && J_Cache.sLoginUser.callno_upload == 1)
						|| (currentUser.uid > 0 && datas.size() <= 0)) {
					if (CURRNET_UID == 0) {
						newsMainEmptyLayer.setText("好友还没有动态发布！");
					} else if (CURRNET_UID == J_Cache.sLoginUser.uid) {
						newsMainEmptyLayer.setText("您还没有动态发布！");
					} else {
						newsMainEmptyLayer.setText("还没有动态发布！");
					}
					newsMainEmptyLayer.setOnClickListener(new OnClickListener() {
						@Override
						public void onClick(View arg0) {
							showLoading();
							getNewsListInfo();
						}
					});
				}

				break;
			case 0x10001:
				// 隐藏键盘和输入框
				hideKeyboard();
				break;
			case 0x1010:
				// 显示点击动画
				showPageAnim((View) msg.obj, msg.arg1);
				break;
			case 0x1003:
				// 回复别人的评论
				CommentInfoBean commentBean = (CommentInfoBean) msg.obj;
				CURRENT_MANAGE_TYPE = 2;
				CURRENT_MANAGE_INDEX = msg.arg1;// index
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
				CURRENT_MANAGE_INDEX = msg.arg1;// index
				CURRENT_MANAGE_TYPE = 1;
				// 显示输入框
				showKeyboard(null);
				break;
			case 0x1000:
				// 转发动态--记得转发数字要+1
				int position = msg.arg1;// index
				NewsInfoBean bean = datas.get(position);
				int feedId = bean.feedId;
				long oid = bean.uid;
				// 播放动画
				showPageAnim((View) msg.obj, 1);
				// 标记为已广播
				bean.is_rebroadcast = 1;
				// 添加广播人
				BaseUser user = new BaseUser();
				user.uid = J_Cache.sLoginUser.uid;
				user.nickName = J_Cache.sLoginUser.nickName;
				bean.rebroadcastPeople.add(user);
				// 广播数字+1
				bean.rebroadcastCount += 1;
				// 更新列表数据
				datas.set(position, bean);
				// 刷新页面
				mHandler.sendEmptyMessage(0x10000);
				// 发送请求
				new RebroadcastDynamicRequest(null).execute(feedId, oid);
				break;
			default:
				break;
			}
		}
	};

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
		final NewsInfoBean newsBean = datas.get(CURRENT_MANAGE_INDEX);
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
					cib.time = System.currentTimeMillis() / 1000 + "";
					cib.id = Util.getInteger(response.data);
					newsBean.comment.add(cib);
					// 更新评论数字
					newsBean.commentCount += 1;
					// 设置一评论
					newsBean.is_comment = 1;
					datas.set(CURRENT_MANAGE_INDEX, newsBean);

					mHandler.sendEmptyMessage(0x10000);
				}
				dismissLoading();
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				super.onError(errorMap);
				dismissLoading();
			}
		}).execute(newsBean.uid + "", newsBean.feedId + "", content);
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
		final NewsInfoBean newsBean = datas.get(CURRENT_MANAGE_INDEX);
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
					newBean.id = Util.getInteger(response.data);
					newBean.uid = J_Cache.sLoginUser.uid;
					newBean.nick = J_Cache.sLoginUser.nickName;
					newBean.content = content;
					newBean.time = System.currentTimeMillis() / 1000 + "";
					newBean.feedId = newsBean.feedId;
					newBean.feedUid = newsBean.uid;
					newBean.replyUid = CURRENT_REPLY_COMMENT.uid;
					newBean.replyNick = CURRENT_REPLY_COMMENT.nick;
					newsBean.comment.add(newBean);
					// 更新评论数字
					newsBean.commentCount += 1;
					// 设置一评论
					newsBean.is_comment = 1;
					datas.set(CURRENT_MANAGE_INDEX, newsBean);
					mHandler.sendEmptyMessage(0x10000);
				}
				dismissLoading();
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				super.onError(errorMap);
				dismissLoading();
			}
		}).execute(newsBean.uid, J_Cache.sLoginUser.uid, newsBean.feedId, CURRENT_REPLY_COMMENT.id, CURRENT_REPLY_COMMENT.uid,
				content);
	}

	/**
	 * 获取新消息提醒信息
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getWarmMsgInfo() {
		int newMsgNum = SharedPreUtil.getNewsNewMsgData();

		TextView msgCountWarmInfo = (TextView) findViewById(R.id.msgCountWarmInfo);
		ImageButton msgWarmLayerCloseButton = (ImageButton) findViewById(R.id.msgWarmLayerCloseButton);

		if (newMsgNum > 0) {
			// 显示层
			if (recommendContactLayer.getVisibility() == View.VISIBLE) {
				// 如果有新消息来，但是推荐上传联系人层还存在，暂时隐藏该层
				recommendContactLayer.setVisibility(View.GONE);
				recommendWarmBox.setVisibility(View.GONE);
			}
			recommendWarmBox.setVisibility(View.VISIBLE);
			recommendMsgLayer.setVisibility(View.VISIBLE);
			// recommendMsgLayer.setAlpha(0.9f);
			// 设置数据
			String showNum = newMsgNum + "";
			if (newMsgNum > 99) {
				showNum = "99+";
			}
			msgCountWarmInfo.setText("新消息：" + showNum);
			msgCountWarmInfo.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					// 隐藏层
					recommendMsgLayer.setVisibility(View.GONE);
					recommendWarmBox.setVisibility(View.GONE);
					((MainBoxActivity) getParent()).hideRedDot(0);
					Intent msgIntent = new Intent(mContext, NewsMsgActivity.class);
					startActivity(msgIntent);
				}
			});
			// 点击关闭按钮
			msgWarmLayerCloseButton.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					recommendMsgLayer.setVisibility(View.GONE);
					recommendWarmBox.setVisibility(View.GONE);
					((MainBoxActivity) getParent()).hideRedDot(0);
					// 发送请求，所有内容置为已读
					SharedPreUtil.setNewsNewMsgData(0);// 数字置为0
					// 发送请求-全部置为已读
					UtilRequest.setOnreadAll("dynamic", mHandler);
					// 重新检查提醒状态
					checkFriendAndWarm();
				}
			});
		} else {
			// 没有新消息数字
			checkFriendAndWarm();
		}
	}

	/**
	 * 检查并提醒导入通讯录
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void checkFriendAndWarm() {
		if (J_Cache.sLoginUser.callno_upload == 0 || J_Cache.sLoginUser.friends_num <= 0) {
			TextView noFriendWarmInfo = (TextView) findViewById(R.id.noFriendWarmInfo);
			Button warmLayerCloseButton = (Button) findViewById(R.id.warmLayerCloseButton);
			// 显示图层
			recommendWarmBox.setVisibility(View.VISIBLE);
			recommendContactLayer.setVisibility(View.VISIBLE);
			recommendContactLayer.setAlpha(0.9f);
			// 设置显示内容
			noFriendWarmInfo.setText("你还没有好友，邀请好友即可查看更多信息");
			// 邀请按钮
			warmLayerCloseButton.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					// 弹出导入通讯录的弹层
					showUploadContactsDialog(false);
				}
			});
		} else {
			recommendWarmBox.setVisibility(View.GONE);
			recommendContactLayer.setVisibility(View.GONE);
		}
	}

	/**
	 * 获取动态信息列表
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getNewsListInfo() {
		if (CURRNET_UID > 0) {
			// 获取用户动态信息
			getOneUserNews();
		} else {
			// 获取推荐动态列表
			getRecommendNews(false);
		}
	}

	/**
	 * 解析动态数据
	 * 
	 * @return void 返回类型
	 * @param newsInfo 参数类型
	 * @author likai
	 * @throws
	 */
	private void parseNewsInfo(String newsInfo, String type, boolean isCache) {
		try {
			if (Util.isBlankString(newsInfo)) {
				return;
			}
			JSONObject data = new JSONObject(newsInfo);
			if (PAGE_DY_ID == 0) {
				datas.clear();
				// 缓存数据
				SharedPreUtil.saveRecommendNewsInfo(newsInfo, type);
			}
			JSONArray dataArray = data.optJSONArray("list");
			if (dataArray.length() > 0) {
				int lastFeedId = 0;
				for (int i = 0; i < dataArray.length(); i++) {
					JSONObject singleData = dataArray.optJSONObject(i);
					NewsInfoBean bean = new NewsInfoBean();
					lastFeedId = singleData.optInt("feedid");
					bean.feedId = lastFeedId;
					bean.uid = singleData.optLong("uid");
					bean.nick = singleData.optString("nick");
					bean.date = singleData.optString("time");
					bean.sex = singleData.optInt("sex");
					bean.marriage = singleData.optInt("marriage");
					JSONObject avatars = singleData.optJSONObject("avatars");
					bean.avatar = avatars.optString("200");
					bean.type = singleData.optInt("type");
					bean.friendDimen = singleData.optInt("friend");
					bean.praiseCount = singleData.optInt("praise_num");
					bean.rebroadcastCount = singleData.optInt("rebroadcast_num");
					bean.commentCount = singleData.optInt("comment_num");
					bean.is_comment = singleData.optInt("is_comment");
					bean.is_praise = singleData.optInt("is_praise");
					bean.is_rebroadcast = singleData.optInt("is_rebroadcast");
					bean.status = singleData.optInt("status");
					if (bean.status == -1) {
						// 过滤已经删除的动态
						continue;
					}
					// 赞列表
					JSONArray praiseList = singleData.optJSONArray("praise_list");
					for (int j = 0; j < praiseList.length(); j++) {
						BaseUser praiseUser = new BaseUser();
						praiseUser.uid = praiseList.optJSONObject(j).optLong("uid");
						praiseUser.nickName = praiseList.optJSONObject(j).optString("nick");
						bean.praisePeople.add(praiseUser);
					}
					// 转播列表
					JSONArray rebroadcastList = singleData.optJSONArray("rebroadcast_list");
					for (int m = 0; m < rebroadcastList.length(); m++) {
						BaseUser rebroadcastUser = new BaseUser();
						rebroadcastUser.uid = rebroadcastList.optJSONObject(m).optLong("uid");
						rebroadcastUser.nickName = rebroadcastList.optJSONObject(m).optString("nick");
						bean.rebroadcastPeople.add(rebroadcastUser);
					}
					// 评论列表
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
							commentInfo.replyAvatar = replyAvatarObj.optString("200");
						}
						commentInfo.id = tempComment.optInt("id");
						commentInfo.uid = tempComment.optLong("uid");
						commentInfo.nick = tempComment.optString("nick");
						commentInfo.sex = tempComment.optInt("sex");
						commentInfo.content = tempComment.optString("content");
						JSONObject avatarObj = tempComment.optJSONObject("avatar");
						commentInfo.avatar = avatarObj.optString("200");
						commentInfo.time = tempComment.optString("time");
						bean.comment.add(commentInfo);
					}
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
							if (photoData != null && photoData.length() > 0) {
								Iterator allkeys = photoData.keys();
								while (allkeys.hasNext()) {
									String key = (String) allkeys.next();
									if (!Util.isBlankString(key)) {
										JSONObject picInfo = photoData.optJSONObject(key);
										PhotoInfoBean pBean = new PhotoInfoBean();
										pBean.pid = key;
										pBean.url_small = picInfo.optString("300");
										pBean.url = picInfo.optString("600");
										pBean.type = 1;
										pBean.nick = bean.nick;
										bean.contentPhoto.add(pBean);
									}
								}
								// 重新排序
								Collections.sort(bean.contentPhoto, new PhotoByPidComparator());
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
						String avatar = newsData.optString("avatar");
						if (!avatar.equals("false") && !avatar.equals("{}") && !Util.isBlankString(avatar)) {
							JSONObject avatarsRelay = newsData.optJSONObject("avatar");
							bean.relayAvatar = avatarsRelay.optString("200");
						}
						bean.relayFeedId = newsData.optInt("feedid");
						bean.relayDate = newsData.optString("time");
						bean.relayStatus = newsData.optInt("status");
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
						String avatar = newsData.optString("avatar");
						if (!avatar.equals("false") && !avatar.equals("{}") && !Util.isBlankString(avatar)) {
							JSONObject avatarsRelay = newsData.optJSONObject("avatar");
							bean.relayAvatar = avatarsRelay.optString("200");
						}
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
									pBean.url_small = picInfo.optString("300");
									pBean.url = picInfo.optString("600");
									pBean.type = 1;
									pBean.nick = bean.relayNick;
									bean.relayContentPhoto.add(pBean);
								}
							}
							// 重新排序
							Collections.sort(bean.relayContentPhoto, new PhotoByPidComparator());
						} else {
							// 过滤无效数据
							continue;
						}
					}

					if (!checkIsHave(bean)) {
						datas.add(bean);
					}
				}

				// 最后一个记录page_feed_id
				if (!isCache) {
					PAGE_DY_ID = lastFeedId;
				}
				// 隐藏底部加载提示框
				hideFooterLoading(1);
			} else {
				// 处理底部加载提示框
				hideFooterLoading(0);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		mHandler.sendEmptyMessage(0x10000);
	}

	/**
	 * 获取单个用户的动态列表
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getOneUserNews() {
		new GetOneUserDynamicListRequest(new J_OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					parseNewsInfo(response.data, "user", false);
				} else {
					mHandler.sendEmptyMessage(0x10000);
				}
				dismissLoading();
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				super.onError(errorMap);
				dismissLoading();
				newsMainListView.onRefreshComplete();
				// 处理底部加载提示框
				hideFooterLoading(0);
			}
		}).execute(CURRNET_UID, PAGE_DY_ID, PAGE_NUM);
	}

	/**
	 * 熟人页 推荐列表获取
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void getRecommendNews(boolean isFirstLoading) {
		if (isFirstLoading) {
			// 首次加载，先加载缓存
			String newsInfo = SharedPreUtil.getRecommendNewsInfo("recommend");
			parseNewsInfo(newsInfo, "recommend", true);
		}

		new GetRecommendDynamicListRequest(new J_OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					parseNewsInfo(response.data, "recommend", false);
				} else {
					mHandler.sendEmptyMessage(0x10000);
				}
				dismissLoading();
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				super.onError(errorMap);
				dismissLoading();
				newsMainListView.onRefreshComplete();
				// 处理底部加载提示框
				hideFooterLoading(0);
			}
		}).execute(PAGE_DY_ID, PAGE_NUM, is_look_single);
	}

	/**
	 * 检查该feedId动态是否已经存在
	 * 
	 * @return boolean 返回类型
	 * @param @param bean
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	private boolean checkIsHave(NewsInfoBean bean) {
		boolean isHave = false;
		for (int i = 0; i < datas.size(); i++) {
			if (datas.get(i).feedId == bean.feedId) {
				isHave = true;
			}
		}

		return isHave;
	}

	/**
	 * 点击监听
	 * 
	 * 
	 */
	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleCenter:
				// 点击中间标题文字，回滚到顶部
				newsMainListView.getRefreshableView().smoothScrollToPosition(0);
				break;
			case R.id.titleLeftButton:
				// 标题左侧筛选按钮
				showNewsPopMenu(v);
				break;
			case R.id.titleRightButton:
				// 去往发布动态页面
				gotoCreateNewsPage();
				break;
			case R.id.btn_setting_msg:
				// 发送评论
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
	 * 弹出“熟人圈”选择菜单
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void showNewsPopMenu(View v) {
		new MenuPopDialog(mContext).setCallBack(new OnSelectCallBack() {
			@Override
			public void onCallBack(String value1, String value2, String value3) {
				if (value1.equals("1")) {
					// 查看全部
					is_look_single = 0;
					PAGE_DY_ID = 0;
				} else if (value1.equals("2")) {
					// 只看单身
					is_look_single = 1;
					PAGE_DY_ID = 0;
				}
				// 回到顶部
				newsMainListView.getRefreshableView().setSelection(0);
				// 显示加载中
				showLoading();
				// 重新获取信息
				getRecommendNews(false);
			}
		}).showAsDropDown(v);
	}

	/**
	 * 去往发布新动态页面
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void gotoCreateNewsPage() {
		Intent newsIntent = new Intent(mContext, AddNewNewsActivity.class);
		startActivity(newsIntent);
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
		hideKeyboard();
		if (CURRNET_UID == 0) {
			// 熟人圈
			((MainBoxActivity) getParent()).showKeyboard(mHandler, eTHint);
		} else {
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
		if (CURRNET_UID == 0) {
			// 熟人圈
			((MainBoxActivity) getParent()).hideKeyboard();
		} else {
			// 个人动态
			// 隐藏键盘
			Util.hideKeyboard(mContext, input_msg_text);
			// 清空内容
			input_msg_text.setText("");
			// 隐藏输入框
			news_global_edittext_box.setVisibility(View.GONE);
		}
	}

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
		int x = location[0] + currentView.getWidth() - getResources().getDimensionPixelSize(R.dimen.global_px80dp);
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
	 * 自动加载时，在底部显示加载中提示
	 * 
	 * @return void 返回类型
	 * @param @param canLoading 参数类型
	 * @author likai
	 * @throws
	 */
	private void showFooterLoading(int canLoading) {
		isCanLoading = canLoading;

		footerLvTv.setText("加载中...");
		footerLvTv.setVisibility(View.VISIBLE);
	}

	/**
	 * 自动加载完成后，底部提示框的相关处理
	 * 
	 * @return void 返回类型
	 * @param canLoading 参数类型
	 * @author likai
	 * @throws
	 */
	private void hideFooterLoading(int canLoading) {
		isCanLoading = canLoading;
		if (canLoading == 1) {
			footerLvTv.setVisibility(View.GONE);
		} else if (canLoading == 2) {
			footerLvTv.setVisibility(View.VISIBLE);
			footerLvTv.setText("——非好友最多显示五条动态——");
		} else {
			footerLvTv.setVisibility(View.VISIBLE);
			footerLvTv.setText("没有更多了");
		}
	}
}
