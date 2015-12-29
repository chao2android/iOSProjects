package com.iyouxun.ui.activity.setting;

import java.util.HashMap;

import org.json.JSONObject;

import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.J_OnDataBack;
import com.iyouxun.net.request.NewPasswordGetSecurityCodeRequest;
import com.iyouxun.net.request.SetNewPasswordRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 找回密码
 * 
 * @ClassName: SettingFindPwdActivity
 * @author likai
 * @date 2015-3-9 下午4:15:40
 * 
 */
public class SettingFindPwdActivity extends CommTitleActivity {
	private Button settingFindPwdReSendButton;
	private EditText settingFindPwdCode;
	private TextView settingFindPwdDesc;
	private EditText settingFindPwdNewPwd;
	private EditText settingFindPwdReNewPwd;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("找回密码");
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
		titleRightButton.setText("完成");
		titleRightButton.setVisibility(View.VISIBLE);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_setting_find_pwd, null);
	}

	@Override
	protected void initViews() {
		settingFindPwdReSendButton = (Button) findViewById(R.id.settingFindPwdReSendButton);
		settingFindPwdCode = (EditText) findViewById(R.id.settingFindPwdCode);
		settingFindPwdDesc = (TextView) findViewById(R.id.settingFindPwdDesc);
		settingFindPwdNewPwd = (EditText) findViewById(R.id.settingFindPwdNewPwd);
		settingFindPwdReNewPwd = (EditText) findViewById(R.id.settingFindPwdReNewPwd);

		settingFindPwdReSendButton.setOnClickListener(listener);

		// 发送验证码
		sendMobileCode();
	}

	/**
	 * 设置页面提示信息
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void sendMobileCodeForFindPwd() {
		// 补充信息
		String formatMobile = Util.getFormatMobileNumber(SharedPreUtil.getLoginMobile());
		String info = getString(R.string.send_mobile_code_desc, formatMobile);
		settingFindPwdDesc.setText(info);
		settingFindPwdDesc.setVisibility(View.VISIBLE);
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleRightButton:
				// 完成
				setNewPwd();
				break;
			case R.id.settingFindPwdReSendButton:
				// 发送验证码
				sendMobileCode();
				break;
			default:
				break;
			}
		}
	};

	/**
	 * 设置新密码
	 * 
	 * @Title: setNewPwd
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setNewPwd() {
		String code = settingFindPwdCode.getText().toString();
		String newPwd = settingFindPwdNewPwd.getText().toString();
		String reNewPwd = settingFindPwdReNewPwd.getText().toString();
		if (Util.isBlankString(code)) {
			ToastUtil.showToast(mContext, "验证码输入不正确");
		} else if (Util.isBlankString(newPwd) || newPwd.length() < 6 || newPwd.length() > 20) {
			ToastUtil.showToast(mContext, "密码长度为6至20个字");
		} else if (Util.isBlankString(reNewPwd) || !newPwd.equals(reNewPwd)) {
			ToastUtil.showToast(mContext, "两次输入的密码不一致");
		} else {
			new SetNewPasswordRequest(new J_OnDataBack() {
				@Override
				public void onResponse(Object result) {
					J_Response response = (J_Response) result;
					if (response.retcode == 1) {
						ToastUtil.showToast(mContext, "修改成功");
						finish();
					} else if (response.retcode == -3) {
						ToastUtil.showToast(mContext, "验证码不正确");
					} else if (response.retcode == -2) {
						ToastUtil.showToast(mContext, "手机号尚未注册");
					}
				}

				@Override
				public void onError(HashMap<String, Object> errorMap) {
					ToastUtil.showToast(mContext, "修改失败");
				}
			}).execute(SharedPreUtil.getLoginMobile(), code, newPwd);
		}
	}

	/**
	 * 获取验证码
	 * 
	 * @Title: getMobileCode
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void sendMobileCode() {
		settingFindPwdReSendButton.setEnabled(false);
		new NewPasswordGetSecurityCodeRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				try {
					JSONObject json = new JSONObject(result.toString());
					int retcode = json.optInt("retcode");
					if (retcode == 1) {
						int data = json.optInt("data");
						if (data == 300) {
							settingFindPwdReSendButton.setEnabled(true);
							ToastUtil.showToast(mContext, "已超过当日最大发送次数(6次)！");
						} else {
							// 禁止点击
							Util.btnCountdown(new Handler(), 60, "秒后重新发送", settingFindPwdReSendButton);
							// 设置页面提示信息
							sendMobileCodeForFindPwd();
						}
					} else {
						ToastUtil.showToast(mContext, "验证码发送失败");
						settingFindPwdReSendButton.setEnabled(true);
					}
				} catch (Exception e) {
					e.printStackTrace();
				}
			}

			@Override
			public void onError(HashMap<String, Object> errMap) {
				ToastUtil.showToast(mContext, "验证码发送失败");
				settingFindPwdReSendButton.setEnabled(true);
			}
		}).getCode(SharedPreUtil.getLoginMobile());
	}
}
