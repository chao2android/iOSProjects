package com.iyouxun.ui.activity.login;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.MainBoxActivity;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: ResetPasswordActivity
 * @Description: 忘记密码
 * @author donglizhi
 * @date 2015年3月4日 上午10:53:29
 * 
 */
public class ResetPasswordActivity extends CommTitleActivity {
	private Button btnGetSecurityCode;// 获得验证码按钮
	private EditText inputSecurityCode;// 输入验证码
	private EditText inputNewPassword;// 输入新密码
	private EditText inputNewPasswordAgain;// 再次输入新密码
	private EditText inputMobile;// 输入手机号
	private Button btnSubmit;// 提交按钮
	private Context mContext;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.forgot_password);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setText(R.string.go_back);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_reset_password, null);
	}

	@Override
	protected void initViews() {
		mContext = ResetPasswordActivity.this;
		btnGetSecurityCode = (Button) findViewById(R.id.reset_password_btn_get_security_code);
		btnSubmit = (Button) findViewById(R.id.reset_password_btn_submit);
		inputNewPassword = (EditText) findViewById(R.id.reset_password_input_new_password);
		inputNewPasswordAgain = (EditText) findViewById(R.id.reset_password_input_password_again);
		inputSecurityCode = (EditText) findViewById(R.id.reset_password_input_security_code);
		inputMobile = (EditText) findViewById(R.id.reset_password_input_phone_number);
		btnSubmit.setOnClickListener(listener);
		btnGetSecurityCode.setOnClickListener(listener);
		inputMobile.addTextChangedListener(textWatcher);
		inputNewPassword.addTextChangedListener(textWatcher);
		inputNewPasswordAgain.addTextChangedListener(textWatcher);
		inputSecurityCode.addTextChangedListener(textWatcher);
	}

	private final TextWatcher textWatcher = new TextWatcher() {

		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}

		@Override
		public void afterTextChanged(Editable s) {
			String mobile = inputMobile.getText().toString();
			String securityCode = inputSecurityCode.getText().toString();
			String newPassword = inputNewPassword.getText().toString();
			String confirmPassword = inputNewPasswordAgain.getText().toString();
			if (Util.isMobileNumber(mobile) && securityCode.length() == 6 && newPassword.length() >= 6
					&& newPassword.equals(confirmPassword)) {// 验证手机号，验证码位数，和密码相同
				btnSubmit.setEnabled(true);
			} else {
				btnSubmit.setEnabled(false);
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
			case R.id.reset_password_btn_get_security_code:// 获取验证码
				String phoneNumber = inputMobile.getText().toString();
				if (Util.isMobileNumber(phoneNumber)) {
					try {
						JSONObject form = new JSONObject();
						form.put(UtilRequest.FORM_MOBILE, phoneNumber);
						DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
						UtilRequest.vaildMobile(mContext, mHandler, form.toString(), 0);// 手机号不存在需要先注册
					} catch (JSONException e) {
						e.printStackTrace();
					}
				} else {
					ToastUtil.showToast(mContext, getString(R.string.please_input_true_mobile_number));
				}
				break;
			case R.id.reset_password_btn_submit:// 提交按钮
				String passwordString = inputNewPassword.getText().toString().trim();
				String passwordAgain = inputNewPasswordAgain.getText().toString().trim();
				String mobile = inputMobile.getText().toString().trim();
				String securityCode = inputSecurityCode.getText().toString().trim();
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.setNewPassword(mobile, passwordAgain, securityCode, mContext, mHandler);
				break;
			default:
				break;
			}
		}
	};

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_NEW_PASSWORD_GET_SECURITY_CODE:// 获取手机验证码
				DialogUtils.dismissDialog();
				Util.btnCountdown(mHandler, Util.COUNTDOWN_TIME, getString(R.string.str_countdown_title), btnGetSecurityCode);
				btnGetSecurityCode.setEnabled(false);
				break;
			case NetTaskIDs.TASKID_VAILD_MOBILE_EXISTS:// 验证手机号是否存在
				if (msg.obj == null) {
					return;
				}
				String phoneNumber = inputMobile.getText().toString();
				UtilRequest.newpasswordGetSecurityCode(mHandler, phoneNumber, mContext);
				break;
			case NetTaskIDs.TASKID_SET_NEW_PASSWORD:// 重置密码
				J_Response response = (J_Response) msg.obj;
				try {
					JSONObject dataObject = new JSONObject(response.data);
					long uid = dataObject.optLong(UtilRequest.FORM_UID, 0);
					if (uid <= 0) {
						ToastUtil.showToast(mContext, "密码修改失败，请再次尝试");
						return;
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
				String userName = inputMobile.getText().toString();
				String password = inputNewPassword.getText().toString();
				ToastUtil.showToast(mContext, getString(R.string.change_password_successed));
				UtilRequest.doLogin(userName, password, mHandler, mContext);
				break;
			case NetTaskIDs.TASKID_GET_USER_INFO:// 获取用户状态
				Intent mainIntent = new Intent(mContext, MainBoxActivity.class);
				startActivity(mainIntent);
				finish();
				DialogUtils.dismissDialog();
				break;
			default:
				break;
			}
		};
	};
}
