package com.iyouxun.ui.activity;

import java.io.File;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.ImageView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.encrypt.MD5;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.login.LoginActivity;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.DialogUtils.OnSelectCallBack;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;
import com.umeng.analytics.MobclickAgent;

/**
 * 应用入口页面
 * 
 * @author likai
 * @date 2014年8月26日 下午1:56:49
 */
public class SplashActivity extends BaseActivity {
	private ImageView splashLogo;

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_GET_USER_INFO:// 获取用户状态
				Intent mainIntent = new Intent(mContext, MainBoxActivity.class);
				startActivity(mainIntent);
				finish();
				break;
			default:
				break;
			}
		};
	};

	@Override
	protected void onCreate(Bundle arg0) {
		super.onCreate(arg0);
		// 设置页面显示数据，动态创建imageview，放入页面
		setContentView(R.layout.activity_splash_layout);
		// 设置首发logo
		splashLogo = (ImageView) findViewById(R.id.splashLogo);
		String channelId = Util.getChannelId();
		if (!Util.isBlankString(channelId)) {
			if (channelId.equals("201")) {
				// 360渠道
				splashLogo.setImageResource(R.drawable.splash_logo_360);
				splashLogo.setVisibility(View.VISIBLE);
			}
		}
	}

	@Override
	protected void onResume() {
		super.onResume();
		// 获取本地存储用户登录需要使用的token
		// 如果不存在该token，执行登录操作，如果存在token，执行登录
		String token = SharedPreUtil.getLoginToken();
		if (Util.isBlankString(token)) {
			// 如果当前app不存在登录可用的token，去执行注册操作
			mHandler.postDelayed(new Runnable() {
				@Override
				public void run() {
					if (SharedPreUtil.getShowGuide()) {
						SharedPreUtil.setShowGuide(false);
						Intent guideIntent = new Intent(mContext, GuideActivity.class);
						startActivity(guideIntent);
						finish();
					} else {
						Intent loginIntent = new Intent(mContext, LoginActivity.class);
						startActivity(loginIntent);
						finish();
					}
				}
			}, 2000);
		} else {
			// 存在登录可用的token，去执行登录操作
			UtilRequest.doAutoLogin(token, 0, mContext, mHandler);
		}

		/** 如果是调试模式，数据实时发送，不受发送策略控制 */
		if (J_SDK.getConfig().LOG_ENABLE) {
			MobclickAgent.updateOnlineConfig(this);
			// 打开调试模式后，您可以在logcat中查看您的数据是否成功发送到友盟服务器，
			// 以及集成过程中的出错原因等，友盟相关log的tag是MobclickAgent
			MobclickAgent.setDebugMode(true);
		}
	}

	/**
	 * 下载图片
	 * 
	 * @return void 返回类型
	 * @param @param url 参数类型
	 * @author likai
	 */
	private void downLoadImg(String url) {
		final File file = new File(getCacheDir(), MD5.md5(url));
		J_NetManager.getInstance().downloadFile(url, file.getAbsolutePath(), new RequestCallBack<File>() {
			@Override
			public void onSuccess(ResponseInfo<File> responseInfo) {
			}

			@Override
			public void onFailure(HttpException error, String msg) {
			}
		});
	}

	/**
	 * 显示网络异常，退出登录
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 */
	private void showNetWorkDialog(int Error) {
		if (Error == 1) {
			DialogUtils.showPromptDialog(this, "网络异常", "请检查网络！", new OnSelectCallBack() {
				@Override
				public void onCallBack(String value1, String value2, String value3) {
					if (value1.equals("0")) {
						// 确定
						if (android.os.Build.VERSION.SDK_INT > 10) {
							// 3.0以上打开设置界面，也可以直接用ACTION_WIRELESS_SETTINGS打开到wifi界面
							startActivity(new Intent(android.provider.Settings.ACTION_SETTINGS));
						} else {
							startActivity(new Intent(android.provider.Settings.ACTION_WIRELESS_SETTINGS));
						}
					} else if (value1.equals("1")) {
						// 取消
						exit();
					}
				}
			});
		}
	}
}
