package com.iyouxun.ui.activity.login;

import java.io.File;
import java.util.HashMap;

import android.content.Intent;
import android.os.Handler;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.PlatformDb;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.wechat.friends.Wechat;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.OpenPlatformBeans;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.j_libs.encrypt.MD5;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.net.response.VaildBindOpenidResponse;
import com.iyouxun.open.J_OpenManager;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.MainBoxActivity;
import com.iyouxun.ui.activity.register.RegisterActivity;
import com.iyouxun.ui.views.ClearEditText;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;
import com.lidroid.xutils.exception.HttpException;
import com.lidroid.xutils.http.ResponseInfo;
import com.lidroid.xutils.http.callback.RequestCallBack;

/**
 * @ClassName: LoginActivity
 * @Description: 登录主页面
 * @author donglizhi
 * @date 2015年3月3日 上午11:14:00
 * 
 */
public class LoginActivity extends CommTitleActivity {
	private static final String PLATFORM_USER_ICON = "platformUserIcon";// 下载头像的名字
	private ClearEditText inputPhone;// 输入手机号
	private ClearEditText inputPassword;// 输入密码
	private Button btnLogin;// 登录按钮
	private TextView btnRegister;// 注册新用户
	private TextView btnForgotPassword;// 忘记密码
	private Button btnWeiXin;// 微信
	private Button btnSinaWeibo;// 新浪微博
	private Button btnQQ;// QQ
	private final OpenPlatformBeans beans = new OpenPlatformBeans();

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.home_login);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
		titleLeftButton.setText(R.string.go_back);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_login, null);
	}

	@Override
	protected void initViews() {
		inputPassword = (ClearEditText) findViewById(R.id.login_input_password);
		inputPhone = (ClearEditText) findViewById(R.id.login_input_phone_number);
		btnForgotPassword = (TextView) findViewById(R.id.login_btn_forgot_password);
		btnLogin = (Button) findViewById(R.id.login_btn_login);
		btnQQ = (Button) findViewById(R.id.login_btn_qq);
		btnRegister = (TextView) findViewById(R.id.login_btn_register);
		btnSinaWeibo = (Button) findViewById(R.id.login_btn_sinaweibo);
		btnWeiXin = (Button) findViewById(R.id.login_btn_weixin);

		btnForgotPassword.setOnClickListener(listener);
		btnLogin.setOnClickListener(listener);
		btnQQ.setOnClickListener(listener);
		btnRegister.setOnClickListener(listener);
		btnSinaWeibo.setOnClickListener(listener);
		btnWeiXin.setOnClickListener(listener);
		inputPassword.addTextChangedListener(textWatcher);
		inputPhone.addTextChangedListener(textWatcher);

		// ArrayList<Activity> beforeLoginPage =
		// J_PageManager.getInstance().getBeforeLoginPage();
		// if (beforeLoginPage != null && beforeLoginPage.size() > 0) {
		// int containGuidePage = 0;
		// for (int i = 0; i < beforeLoginPage.size(); i++) {
		// if
		// (GuideActivity.class.getName().equals(beforeLoginPage.get(i).getClass().getName()))
		// {
		// containGuidePage = 1;
		// }
		// }
		// if (containGuidePage == 0) {
		// titleLeftButton.setVisibility(View.GONE);
		// }
		// }
	}

	private final TextWatcher textWatcher = new TextWatcher() {

		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}

		@Override
		public void afterTextChanged(Editable s) {// 手机号和密码位数没问题登录按钮可用
			String mobile = inputPhone.getText().toString();
			String password = inputPassword.getText().toString();
			if (Util.isMobileNumber(mobile) && password.length() >= 6 && password.length() <= 20) {
				btnLogin.setEnabled(true);
			} else {
				btnLogin.setEnabled(false);
			}
		}
	};

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 头部左侧按钮
				finish();
				break;
			case R.id.login_btn_forgot_password:// 忘记密码按钮
				Intent forgotIntent = new Intent(mContext, ResetPasswordActivity.class);
				startActivity(forgotIntent);
				break;
			case R.id.login_btn_login:// 登录按钮
				String userName = inputPhone.getText().toString();
				String password = inputPassword.getText().toString();
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.doLogin(userName, password, mHandler, mContext);
				break;
			case R.id.login_btn_qq:// qq登录
				loginByThirdPlatform(QQ.NAME);
				break;
			case R.id.login_btn_register:// 注册按钮
				Intent registerIntent = new Intent(mContext, RegisterActivity.class);
				registerIntent.putExtra(UtilRequest.FROM_ACTIVITY, LoginActivity.class.toString());
				startActivity(registerIntent);
				break;
			case R.id.login_btn_weixin:// 微信登录
				loginByThirdPlatform(Wechat.NAME);
				break;
			case R.id.login_btn_sinaweibo:// 新浪微博登陆
				loginByThirdPlatform(SinaWeibo.NAME);
				break;
			default:
				break;
			}
		}
	};

	/**
	 * @Title: loginByThirdPlatform
	 * @Description: 第三方平台登录
	 * @return void 返回类型
	 * @param @param platform 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void loginByThirdPlatform(String platform) {
		DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
		J_OpenManager.getInstance().login(mHandler, platform, new PlatformActionListener() {

			@Override
			public void onError(Platform arg0, int arg1, Throwable arg2) {
				DialogUtils.dismissDialog();
				arg0.removeAccount();
				arg2.printStackTrace();
				String expName = arg2.getClass().getSimpleName();
				if ("WechatClientNotExistException".equals(expName) || "WechatTimelineNotSupportedException".equals(expName)
						|| "WechatFavoriteNotSupportedException".equals(expName)) {
					mHandler.post(new Runnable() {

						@Override
						public void run() {
							ToastUtil.showToast(mContext, "目前您的微信版本过低或未安装微信，需要安装微信才能使用");
						}
					});
				}
			}

			@Override
			public void onComplete(Platform arg0, int arg1, HashMap<String, Object> arg2) {
				DialogUtils.dismissDialog();
				goToSupplement(arg0);
			}

			@Override
			public void onCancel(Platform arg0, int arg1) {
				arg0.removeAccount();
				DialogUtils.dismissDialog();
			}
		});
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void dispatchMessage(final android.os.Message msg) {
			switch (msg.what) {
			case R.id.third_platform_is_valid:// 已经授权
				Platform pf = (Platform) msg.obj;
				goToSupplement(pf);
				break;
			case NetTaskIDs.TASKID_GET_USER_INFO:// 获取用户状态
				Intent mainIntent = new Intent(mContext, MainBoxActivity.class);
				startActivity(mainIntent);
				DialogUtils.dismissDialog();
				finish();
				break;
			case NetTaskIDs.TASKID_VAILD_BIND_OPENID:// 第三方绑定状态
				VaildBindOpenidResponse response = (VaildBindOpenidResponse) msg.obj;
				if (response.success == 1 && response.retcode == 1 && JsonParser.CMI_AJAX_RET_CODE_SUCC.equals(response.retmean)) {
					SharedPreUtil.saveLoginToken(response.token);
					UtilRequest.doAutoLogin(response.token, mContext, mHandler);
				} else {
					final File file = new File(getCacheDir(), MD5.md5(PLATFORM_USER_ICON));
					J_NetManager.getInstance().downloadFile(beans.getUserIcon(), file.getAbsolutePath(),
							new RequestCallBack<File>() {
								@Override
								public void onSuccess(ResponseInfo<File> responseInfo) {
									beans.setImgPath(file.getAbsolutePath());
									Intent supplementIntent = new Intent(mContext, SupplementActivity.class);
									supplementIntent.putExtra(UtilRequest.PLATFORM_DATA, beans);
									startActivity(supplementIntent);
									finish();
								}

								@Override
								public void onFailure(HttpException error, String msg) {
									beans.setImgPath("");
									Intent supplementIntent = new Intent(mContext, SupplementActivity.class);
									supplementIntent.putExtra(UtilRequest.PLATFORM_DATA, beans);
									startActivity(supplementIntent);
									finish();
								}
							});
				}
			default:
				break;
			}
		};
	};

	/**
	 * @Description: 跳转到补充页面
	 * @return void 返回类型
	 * @param @param pf 平台数据
	 * @author donglizhi
	 * @throws
	 */
	private void goToSupplement(Platform pf) {
		PlatformDb platformDb = pf.getDb();
		final String userId = platformDb.getUserId();
		final String userNick = platformDb.getUserName();
		String userIcon = platformDb.getUserIcon();
		String userGender = platformDb.getUserGender();
		final String pfName = pf.getName();
		String accessToken = platformDb.getToken();
		if (QQ.NAME.equals(pfName)) {// 微信1 新浪微博2 QQ3
			if (!Util.isBlankString(userIcon)) {
				userIcon = userIcon.substring(0, userIcon.length() - 2) + "100";
				beans.setOpenType(3);
			}
		} else if (SinaWeibo.NAME.equals(pfName)) {
			beans.setOpenType(2);
		} else if (Wechat.NAME.equals(pfName)) {
			beans.setOpenType(1);
		}
		beans.setUserGender(userGender);
		beans.setUserIcon(userIcon);
		beans.setUserId(userId);
		beans.setUserNick(userNick);
		beans.setAccessToken(accessToken);
		UtilRequest.vaildBindOpenid(beans.getUserId(), beans.getOpenType(), mHandler, mContext);
	}

	@Override
	protected void onResume() {
		super.onResume();
		DialogUtils.dismissDialog();
	}
}
