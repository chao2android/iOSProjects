package com.iyouxun.ui.activity.setting;

import java.util.HashMap;

import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.FindMobileGetCheckCodeRequest;
import com.iyouxun.net.request.UpdateUserMobileRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 更改手机号
 * 
 * @ClassName: SettingChangeMobileActivity
 * @author likai
 * @date 2015-3-9 下午5:51:20
 * 
 */
public class SettingChangeMobileActivity extends CommTitleActivity {
	private EditText changeMobileOld;
	private EditText changeMobileNew;
	private Button sendMobileCodeButton;
	private EditText changeMobileCode;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("修改登录手机号");

		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);

		titleRightButton.setText("完成");
		titleRightButton.setVisibility(View.VISIBLE);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_setting_change_mobile, null);
	}

	@Override
	protected void initViews() {
		changeMobileOld = (EditText) findViewById(R.id.changeMobileOld);
		changeMobileNew = (EditText) findViewById(R.id.changeMobileNew);
		sendMobileCodeButton = (Button) findViewById(R.id.sendMobileCodeButton);
		changeMobileCode = (EditText) findViewById(R.id.changeMobileCode);

		// 当前手机号直接抓取用户手机号码，不用填写，不可编辑
		String currentMobile = SharedPreUtil.getLoginMobile();
		if (!Util.isBlankString(currentMobile)) {
			changeMobileOld.setText(currentMobile);
			changeMobileOld.setEnabled(false);
		} else {
			changeMobileOld.setEnabled(true);
		}

		sendMobileCodeButton.setOnClickListener(listener);
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleRightButton:
				// 完成
				updateUserMobile();
				break;
			case R.id.sendMobileCodeButton:
				// 重新发送手机验证码
				sendMobileCode();
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 发送手机验证码
	 * 
	 * @Title: sendMobileCode
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void sendMobileCode() {
		String newMobile = changeMobileNew.getText().toString();
		if (Util.isBlankString(newMobile) || !Util.isMobileNumber(newMobile)) {
			ToastUtil.showToast(mContext, "手机号码输入不正确");
		} else {
			sendMobileCodeButton.setEnabled(false);
			new FindMobileGetCheckCodeRequest(new OnDataBack() {
				@Override
				public void onResponse(Object result) {
					J_Response response = (J_Response) result;
					if (response.retcode == 1) {
						ToastUtil.showToast(mContext, "验证码已发送");
						Util.btnCountdown(new Handler(), 60, "秒后重新发送", sendMobileCodeButton);
					} else {
						sendMobileCodeButton.setEnabled(true);
						ToastUtil.showToast(mContext, "验证码发送失败：" + response.retmean);
					}
				}

				@Override
				public void onError(HashMap<String, Object> errMap) {
					ToastUtil.showToast(mContext, "验证码发送失败");
					sendMobileCodeButton.setEnabled(true);
				}
			}).execute(newMobile);
		}
	}

	/**
	 * 更换手机号
	 * 
	 * @Title: updateUserMobile
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void updateUserMobile() {
		String oldMobile = changeMobileOld.getText().toString();
		final String newMobile = changeMobileNew.getText().toString();
		String code = changeMobileCode.getText().toString();
		if (Util.isBlankString(newMobile) || !Util.isMobileNumber(newMobile)) {
			ToastUtil.showToast(mContext, "手机号码输入不正确");
		} else if (Util.isBlankString(code)) {
			ToastUtil.showToast(mContext, "验证码输入不正确");
		} else {
			showLoading();

			new UpdateUserMobileRequest(new OnDataBack() {
				@Override
				public void onResponse(Object result) {
					J_Response response = (J_Response) result;
					if (response.retcode == 1) {
						// 修改手机号
						J_Cache.sLoginUser.userName = newMobile;
						SharedPreUtil.saveLoginInfo(J_Cache.sLoginUser);

						ToastUtil.showToast(mContext, "手机号修改成功");
						finish();
					} else {
						dismissLoading();
						ToastUtil.showToast(mContext, "手机号修改失败:" + response.retmean);
					}
				}

				@Override
				public void onError(HashMap<String, Object> errMap) {
					ToastUtil.showToast(mContext, "手机号修改失败");
					dismissLoading();
				}
			}).execute(oldMobile, newMobile, code);
		}
	}
}
