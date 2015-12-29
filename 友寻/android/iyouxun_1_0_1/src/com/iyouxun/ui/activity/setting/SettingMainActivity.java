package com.iyouxun.ui.activity.setting;

import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_FileManager;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_PageManager;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.open.J_OpenManager;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.login.LoginActivity;
import com.iyouxun.utils.ApplicationUtils;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 设置页面
 * 
 * @ClassName: SettingMainActivity
 * @author likai
 * @date 2015-2-28 下午2:01:01
 * 
 */
public class SettingMainActivity extends CommTitleActivity {
	private Button settingSecutiryButton;// 帐号安全
	private Button settingPrivacyButton;// 隐私设置
	private Button settingMsgButton;// 消息提醒
	private Button settingBlackButton;// 黑名单
	private Button settingClearButton;// 清除缓存
	private Button settingLoginOut;// 退出登录
	private Button settingOpenPlatformButton;// 第三方帐号
	private Button settingAddressBookButton;// 同步通讯录
	private Button settingMarkButton;// 给应用打分
	private Button settingFeedbackButton;// 意见反馈
	private Button settingUpdateButton;// 应用更新
	private TextView settingVersion;// 版本号

	private View lastLineView;// 最后一条横线

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("设置");
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_setting_main, null);
	}

	@Override
	protected void initViews() {
		settingSecutiryButton = (Button) findViewById(R.id.settingSecutiryButton);
		settingPrivacyButton = (Button) findViewById(R.id.settingPrivacyButton);
		settingMsgButton = (Button) findViewById(R.id.settingMsgButton);
		settingBlackButton = (Button) findViewById(R.id.settingBlackButton);
		settingClearButton = (Button) findViewById(R.id.settingClearButton);
		settingLoginOut = (Button) findViewById(R.id.settingLoginOut);
		settingOpenPlatformButton = (Button) findViewById(R.id.settingOpenPlatformButton);
		settingAddressBookButton = (Button) findViewById(R.id.settingAddressBookButton);
		settingMarkButton = (Button) findViewById(R.id.settingMarkButton);
		lastLineView = findViewById(R.id.lastLineView);
		settingFeedbackButton = (Button) findViewById(R.id.settingFeedbackButton);
		settingUpdateButton = (Button) findViewById(R.id.settingUpdateButton);
		settingVersion = (TextView) findViewById(R.id.settingVersion);

		settingSecutiryButton.setOnClickListener(listener);
		settingPrivacyButton.setOnClickListener(listener);
		settingMsgButton.setOnClickListener(listener);
		settingBlackButton.setOnClickListener(listener);
		settingClearButton.setOnClickListener(listener);
		settingLoginOut.setOnClickListener(listener);
		settingOpenPlatformButton.setOnClickListener(listener);
		settingAddressBookButton.setOnClickListener(listener);
		settingMarkButton.setOnClickListener(listener);
		settingFeedbackButton.setOnClickListener(listener);
		settingUpdateButton.setOnClickListener(listener);

		// 如果没有安装市场，隐藏该选项
		if (!ApplicationUtils.isMarketInstall(mContext)) {
			settingMarkButton.setVisibility(View.GONE);
			lastLineView.setVisibility(View.GONE);
		}

		// 版本号
		settingVersion.setText("版本：v" + Util.getAppVersionName());
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.settingMarkButton:
				// 给应用打分
				ApplicationUtils.openMarket(mContext);
				break;
			case R.id.settingUpdateButton:
				// 检查更新
				showLoading("检查更新中...");
				UtilRequest.updateClient(mContext, mHandler);
				break;
			case R.id.settingSecutiryButton:
				// 帐号安全
				Intent securityIntent = new Intent(mContext, SettingSecurityActivity.class);
				startActivity(securityIntent);
				break;
			case R.id.settingPrivacyButton:
				// 隐私设置
				Intent privacyIntent = new Intent(mContext, SettingPrivacyActivity.class);
				startActivity(privacyIntent);
				break;
			case R.id.settingMsgButton:
				// 消息提醒
				Intent msgIntent = new Intent(mContext, SettingMsgWarmActivity.class);
				startActivity(msgIntent);
				break;
			case R.id.settingBlackButton:
				// 黑名单
				Intent blackIntent = new Intent(mContext, SettingBlackListActivity.class);
				startActivity(blackIntent);
				break;
			case R.id.settingFeedbackButton:
				// 意见反馈
				Intent feedIntent = new Intent(mContext, SettingFeedbackActivity.class);
				startActivity(feedIntent);
				break;
			case R.id.settingClearButton:
				// 清除缓存
				showLoading("缓存清除中...");
				new Thread(new Runnable() {
					@Override
					public void run() {
						J_NetManager.getInstance().clearIMGCache();
						J_FileManager.getInstance().getFileStore().deleteFilesInFileStore();

						mHandler.sendEmptyMessage(0x10000);
					}
				}).start();
				break;
			case R.id.settingLoginOut:
				// 退出登录
				DialogUtils.showPromptDialog(mContext, "退出登录", "确定退出登录？", new OnSelectCallBack() {
					@Override
					public void onCallBack(String value1, String value2, String value3) {
						if (value1.equals("0")) {
							logout();
						}
					}
				});
				break;
			case R.id.settingOpenPlatformButton:
				// 第三方帐号
				Intent openPfIntent = new Intent(mContext, SettingOpenPlatformActivity.class);
				startActivity(openPfIntent);
				break;
			case R.id.settingAddressBookButton:
				// 同步通讯录
				DialogUtils.showProgressDialog(mContext, "同步中...");
				UtilRequest.uploadUserContacts(mContext, mHandler);
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 退出登录
	 * 
	 * @Title: logout
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void logout() {
		showLoading("退出登录...");
		UtilRequest.delPushId();
		// 清除登录用户数据
		SharedPreUtil.clearLoginInfo();
		// 清除token
		SharedPreUtil.saveLoginToken("");
		// 清除第三方平台数据
		J_OpenManager.getInstance().removeAccount(mContext);
		// 关闭页面
		J_PageManager.getInstance().finishAllPage();
		// 取消所有的消息
		NotificationManager ntfMgr = (NotificationManager) J_Application.context.getSystemService(Context.NOTIFICATION_SERVICE);
		ntfMgr.cancelAll();
		// 启动登录页面
		Intent loginIntent = new Intent(mContext, LoginActivity.class);
		startActivity(loginIntent);
		finish();
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_UPLOAD_USER_CONTACTS:
				// 同步通讯录
				DialogUtils.dismissDialog();
				ToastUtil.showToast(mContext, "同步成功");
				break;
			case 0x10000:
				// 清除缓存
				dismissLoading();
				ToastUtil.showToast(mContext, "缓存清除成功");
				break;
			case 0x404:
				// 更新返回
				dismissLoading();
				ToastUtil.showToast(mContext, "没有新版本");
				break;
			default:
				break;
			}
		}
	};
}
