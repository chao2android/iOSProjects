package com.iyouxun.ui.activity;

import android.app.ActivityGroup;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RelativeLayout;
import android.widget.TabHost;
import android.widget.TabHost.TabSpec;
import android.widget.TextView;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.chat.ChatContactRepository;
import com.iyouxun.j_libs.managers.J_PageManager;
import com.iyouxun.net.request.GetPrivacyInfoRequest;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.service.UpdateChatUserList;
import com.iyouxun.ui.activity.center.ProfileMainActivity;
import com.iyouxun.ui.activity.find.FindActivity;
import com.iyouxun.ui.activity.message.MessageMainActivity;
import com.iyouxun.ui.activity.news.NewsMainActivity;
import com.iyouxun.ui.views.NewsFaceRelativeLayout;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

/**
 * 主页面
 * 
 * @ClassName: MainBoxActivity
 * @author likai
 * @date 2015-2-27 下午6:07:06
 * 
 */
public class MainBoxActivity extends ActivityGroup {
	private TabHost tabHost;
	private Context mContext;
	// 公共输入框
	private RelativeLayout news_global_edittext_box;// 键盘层
	private NewsFaceRelativeLayout faceRelativeLayout;// 键盘
	private Button btn_setting_msg;// 发送评论按钮
	private EditText input_msg_text;// 评论输入框
	// 当前焦点页面
	private String currentTab = "news";

	private RadioButton global_menu_button_news;
	private RadioButton global_menu_button_msg;
	private RadioButton global_menu_button_find;
	private RadioButton global_menu_button_center;
	private ImageView global_menu_news_warm;// 动态有新提醒的红点
	private TextView global_menu_msg_warm;// 消息新提醒
	private Handler uiHandler;
	private int newMsgCount = 0;// 消息未读数字

	@Override
	protected void onCreate(Bundle arg0) {
		super.onCreate(arg0);
		setContentView(R.layout.activity_main_box);

		mContext = this;

		J_PageManager.getInstance().addPage(this);

		initViews();

		initBackgroundRreshData();

		// 更新消息联系人信息
		startService(new Intent(mContext, UpdateChatUserList.class));

		// 删除登录前的页面
		J_PageManager.getInstance().finishBeforeLoginPage();
		// 获得消息数字
		UtilRequest.getCount(new Handler(), mContext, SharedPreUtil.getLoginInfo().uid + "");

		IntentFilter filter = new IntentFilter();
		filter.addAction(J_Consts.UPDATE_MESSAGE_LIST_DATA);
		registerReceiver(mReceiver, filter);
	}

	@Override
	protected void onResume() {
		super.onResume();
		// 保持登录信息
		SharedPreUtil.getLoginInfo();

		// 更新用户坐标信息（暂时放在这里，以后需要设置一个定时器，定时去更新）
		UtilRequest.updateLnglat();
		J_Application.isInAppStatus = true;
	}

	@Override
	protected void onPause() {
		super.onPause();
		J_Application.isInAppStatus = false;
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		unregisterReceiver(mReceiver);
		ChatContactRepository.clears();
		J_PageManager.getInstance().finishPage(this);
	}

	/**
	 * 初始化页面
	 * 
	 * @Title: initViews
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void initViews() {
		tabHost = (TabHost) findViewById(R.id.tabhost);
		global_menu_button_news = (RadioButton) findViewById(R.id.global_menu_button_news);
		global_menu_button_msg = (RadioButton) findViewById(R.id.global_menu_button_msg);
		global_menu_button_find = (RadioButton) findViewById(R.id.global_menu_button_find);
		global_menu_button_center = (RadioButton) findViewById(R.id.global_menu_button_center);
		global_menu_news_warm = (ImageView) findViewById(R.id.global_menu_news_warm);
		news_global_edittext_box = (RelativeLayout) findViewById(R.id.news_global_edittext_box);
		global_menu_msg_warm = (TextView) findViewById(R.id.global_menu_msg_warm);
		faceRelativeLayout = (NewsFaceRelativeLayout) findViewById(R.id.FaceRelativeLayout);
		btn_setting_msg = (Button) findViewById(R.id.btn_setting_msg);
		input_msg_text = (EditText) findViewById(R.id.input_msg_text);

		tabHost.setup(getLocalActivityManager());

		// 点击事件监听
		global_menu_button_news.setOnClickListener(listener);
		global_menu_button_msg.setOnClickListener(listener);
		global_menu_button_find.setOnClickListener(listener);
		global_menu_button_center.setOnClickListener(listener);
		btn_setting_msg.setOnClickListener(listener);

		// 初始化tab
		setTabContent();

		// 设置主视图界面
		setContent(currentTab, false);
		// 显示新消息提醒
		showRedDot(1);
	}

	/**
	 * 设置后台数据刷新
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void initBackgroundRreshData() {
		// 更新用户隐私设置信息
		new GetPrivacyInfoRequest(null).execute(SharedPreUtil.getLoginInfo().uid);

		// 检查应用更新
		UtilRequest.updateClient(mContext, null);
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.global_menu_button_news:
				setContent("news", true);
				break;
			case R.id.global_menu_button_msg:
				setContent("msg", true);
				break;
			case R.id.global_menu_button_find:
				setContent("find", true);
				break;
			case R.id.global_menu_button_center:
				setContent("center", true);
				break;
			case R.id.btn_setting_msg:
				// 发送评论
				String commentContent = input_msg_text.getText().toString();
				Message msg = uiHandler.obtainMessage();
				msg.what = 0x1002;
				msg.obj = commentContent;
				uiHandler.sendMessage(msg);
				break;
			default:
				break;
			}

		}
	};

	/**
	 * 设置tab标签
	 * 
	 * @Title: setTabContent
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setTabContent() {
		// 熟人圈
		TabSpec firstTab = tabHost.newTabSpec("news");
		Intent firstIntent = new Intent(this, NewsMainActivity.class);
		firstTab.setIndicator("news", null);
		firstTab.setContent(firstIntent);
		tabHost.addTab(firstTab);

		// 消息
		TabSpec secondTab = tabHost.newTabSpec("msg");
		Intent secondIntent = new Intent(this, MessageMainActivity.class);
		secondTab.setIndicator("msg", null);
		secondTab.setContent(secondIntent);
		tabHost.addTab(secondTab);

		// 发现
		TabSpec ThirdTab = tabHost.newTabSpec("find");
		Intent ThirdIntent = new Intent(this, FindActivity.class);
		ThirdTab.setIndicator("find", null);
		ThirdTab.setContent(ThirdIntent);
		tabHost.addTab(ThirdTab);

		// 我（个人中心）
		TabSpec fourthTab = tabHost.newTabSpec("center");
		Intent fourthIntent = new Intent(this, ProfileMainActivity.class);
		fourthTab.setIndicator("center", null);
		fourthTab.setContent(fourthIntent);
		tabHost.addTab(fourthTab);
	}

	/**
	 * 设置tab内容
	 * 
	 * @Title: setContent
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setContent(String tabName, boolean isClick) {
		currentTab = tabName;

		// 设置内容
		if (tabName.equals("news")) {
			global_menu_button_news.setChecked(true);
			global_menu_button_msg.setChecked(false);
			global_menu_button_find.setChecked(false);
			global_menu_button_center.setChecked(false);
			if (tabHost.getCurrentTab() != 0) {
				tabHost.setCurrentTab(0);// 熟人圈
				// 如果是除首次进入时的点击操作，而且有红点（新消息），则刷新页面
				if (J_Application.pushActiviy.containsKey("NewsMainActivity") && isClick
						&& global_menu_news_warm.getVisibility() == View.VISIBLE) {
					// ((NewsMainActivity)
					// J_Application.pushActiviy.get("NewsMainActivity")).receiveRefresh();
				}
			} else {
				if (J_Application.pushActiviy.containsKey("NewsMainActivity") && isClick) {
					((NewsMainActivity) J_Application.pushActiviy.get("NewsMainActivity")).receiveRefresh();
				}
			}
		} else if (tabName.equals("msg")) {
			global_menu_button_news.setChecked(false);
			global_menu_button_msg.setChecked(true);
			global_menu_button_find.setChecked(false);
			global_menu_button_center.setChecked(false);
			tabHost.setCurrentTab(1);// 消息
		} else if (tabName.equals("find")) {
			global_menu_button_news.setChecked(false);
			global_menu_button_msg.setChecked(false);
			global_menu_button_find.setChecked(true);
			global_menu_button_center.setChecked(false);
			tabHost.setCurrentTab(2);// 发现
		} else if (tabName.equals("center")) {
			global_menu_button_news.setChecked(false);
			global_menu_button_msg.setChecked(false);
			global_menu_button_find.setChecked(false);
			global_menu_button_center.setChecked(true);
			tabHost.setCurrentTab(3);// 个人中心
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
			} else {
				// 退出到后台
				backGroundApp();
			}
			return true;
		}
		return super.dispatchKeyEvent(event);
	}

	/**
	 * 退出到后台
	 * 
	 * */
	public void backGroundApp() {
		Intent intent = new Intent(Intent.ACTION_MAIN);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.addCategory(Intent.CATEGORY_HOME);
		startActivity(intent);
	}

	/**
	 * 显示键盘
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	public void showKeyboard(Handler uiHandler, String eTHint) {
		this.uiHandler = uiHandler;
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
		// 隐藏输入框
		// 清空内容
		input_msg_text.setText("");
		// 隐藏键盘
		Util.hideKeyboard(mContext, input_msg_text);
		// 隐藏输入框
		news_global_edittext_box.setVisibility(View.GONE);
		// 隐藏表情层
		faceRelativeLayout.hideFaceView();
	}

	/**
	 * 显示提醒红点
	 * 
	 * @Title: showRedDot
	 * @return void 返回类型
	 * @param @param index 参数类型
	 * @author likai
	 * @throws
	 */
	public void showRedDot(int index) {
		switch (index) {
		case 0:// 熟人圈
			global_menu_news_warm.setVisibility(View.VISIBLE);
			break;
		case 1:// 消息
			int sysCount = SharedPreUtil.getSystemChange();
			int count = sysCount + getNewMsgCount();
			if (count > 0) {
				String countShow = "";
				if (count > 99) {
					countShow = "99+";
				} else {
					countShow = count + "";
				}
				global_menu_msg_warm.setText(countShow);
				global_menu_msg_warm.setVisibility(View.VISIBLE);
			} else {
				global_menu_msg_warm.setVisibility(View.GONE);
			}
			break;
		case 2:// 发现

			break;
		case 3:// 我

			break;
		default:
			break;
		}
	}

	/**
	 * 隐藏红点
	 * 
	 * @Title: hideRedDot
	 * @return void 返回类型
	 * @param @param index 参数类型
	 * @author likai
	 * @throws
	 */
	public void hideRedDot(int index) {
		switch (index) {
		case 0:// 熟人圈
			global_menu_news_warm.setVisibility(View.GONE);
			break;
		case 1:// 消息
			global_menu_msg_warm.setVisibility(View.GONE);
			break;
		case 2:// 发现

			break;
		case 3:// 我

			break;
		default:
			break;
		}
	}

	public int getNewMsgCount() {
		return newMsgCount;
	}

	public void setNewMsgCount(int newMsgCount) {
		this.newMsgCount = newMsgCount;
		showRedDot(1);
	}

	private final BroadcastReceiver mReceiver = new BroadcastReceiver() {

		@Override
		public void onReceive(Context context, Intent intent) {
			String action = intent.getAction();
			if (J_Consts.UPDATE_MESSAGE_LIST_DATA.equals(action) && intent.hasExtra(UtilRequest.FORM_COUNT)) {// 更新消息列表
				int msgCount = intent.getIntExtra(UtilRequest.FORM_COUNT, 0);
				if (msgCount > 0) {
					setNewMsgCount(msgCount);
				}
			}
		}
	};
}
