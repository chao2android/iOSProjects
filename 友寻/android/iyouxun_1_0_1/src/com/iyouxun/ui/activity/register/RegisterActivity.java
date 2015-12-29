package com.iyouxun.ui.activity.register;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.Intent;
import android.os.Handler;
import android.text.Editable;
import android.text.InputType;
import android.text.SpannableString;
import android.text.SpannableStringBuilder;
import android.text.Spanned;
import android.text.TextPaint;
import android.text.TextWatcher;
import android.text.method.LinkMovementMethod;
import android.text.style.ClickableSpan;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.views.ClearEditText;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: RegisterActivity
 * @Description:注册页面
 * @author donglizhi
 * @date 2015年3月4日 下午3:17:33
 * 
 */
public class RegisterActivity extends CommTitleActivity {
	private ClearEditText inputPhoneNumber;// 输入手机号
	private ClearEditText inputSecurityCode;// 输入验证
	private Button btnGetSecurityCode;// 获取验证码
	private ClearEditText inputPassword;// 输入密码
	private Button btnComplete;// 完成按钮
	private CheckBox btnCheckBox;// 同意按钮
	private TextView agree;// 同意协议显示
	private ImageView showPassword;// 显示密码
	private LinearLayout registerBox;// 注册模块

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.join_youxun);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setText(R.string.go_back);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_register, null);
	}

	@Override
	protected void initViews() {
		inputPassword = (ClearEditText) findViewById(R.id.register_input_password);
		inputPhoneNumber = (ClearEditText) findViewById(R.id.register_input_phone_number);
		inputSecurityCode = (ClearEditText) findViewById(R.id.register_input_security_code);
		btnGetSecurityCode = (Button) findViewById(R.id.register_btn_get_security_code);
		btnComplete = (Button) findViewById(R.id.register_btn_complete);
		btnCheckBox = (CheckBox) findViewById(R.id.register_check_box);
		agree = (TextView) findViewById(R.id.register_btn_agree);
		showPassword = (ImageView) findViewById(R.id.register_btn_show_password);
		registerBox = (LinearLayout) findViewById(R.id.register_box);
		registerBox.setOnClickListener(listener);
		btnComplete.setOnClickListener(listener);
		btnGetSecurityCode.setOnClickListener(listener);
		btnComplete.setEnabled(false);
		inputPassword.addTextChangedListener(textWatcher);
		inputPhoneNumber.addTextChangedListener(textWatcher);
		inputSecurityCode.addTextChangedListener(textWatcher);
		btnCheckBox.setOnClickListener(listener);
		showPassword.setOnClickListener(listener);
		SpannableStringBuilder commentBuilder = new SpannableStringBuilder();
		commentBuilder.append("同意会员");
		SpannableString agreeSpannableString = new SpannableString("注册协议");

		agreeSpannableString.setSpan(new ClickableSpan() {
			@Override
			public void onClick(View widget) {
				Intent agreeIntent = new Intent(mContext, AgreementActivity.class);
				startActivity(agreeIntent);
			}

			@Override
			public void updateDrawState(TextPaint ds) {
				super.updateDrawState(ds);
				// 设置字体颜色
				ds.setColor(mContext.getResources().getColor(R.color.text_normal_blue));
				// 去掉下划线
				ds.setUnderlineText(true);
			}

		}, 0, agreeSpannableString.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
		commentBuilder.append(agreeSpannableString);
		commentBuilder.append("，并开启同步手机通讯录");
		agree.setText(commentBuilder);
		// 在单击链接时凡是有要执行的动作，都必须设置MovementMethod对象
		agree.setMovementMethod(LinkMovementMethod.getInstance());
		btnCheckBox.setChecked(true);
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.register_box:
				Util.hideKeyboard(mContext, inputPassword);
				break;
			case R.id.titleLeftButton:// 头部左侧按钮
				finish();
				break;
			case R.id.register_btn_complete:// 完成按钮
				String mobileNumber = inputPhoneNumber.getText().toString();
				String password = inputPassword.getText().toString().trim();
				String securityCode = inputSecurityCode.getText().toString().trim();
				if (Util.isBlankString(securityCode)) {
					ToastUtil.showToast(mContext, getString(R.string.register_error_security_code_empty));
					return;
				} else if (Util.isBlankString(password)) {
					ToastUtil.showToast(mContext, getString(R.string.register_error_password_empty));
					return;
				} else if (password.length() < 6) {
					ToastUtil.showToast(mContext, getString(R.string.register_errror_password_6));
					return;
				} else if (!btnCheckBox.isChecked()) {
					ToastUtil.showToast(mContext, getString(R.string.should_agreement));
					return;
				}
				try {
					JSONObject formSecurity_code = new JSONObject();
					formSecurity_code.put(UtilRequest.FORM_MOBILE, mobileNumber);
					formSecurity_code.put(UtilRequest.FORM_MOBILE_CODE, securityCode);
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					UtilRequest.valMobileCode(formSecurity_code.toString(), mHandler, mContext);
				} catch (JSONException e1) {
					e1.printStackTrace();
				}

				break;
			case R.id.register_btn_get_security_code:// 获取验证码按钮
				String phoneNumber = inputPhoneNumber.getText().toString();
				if (Util.isMobileNumber(phoneNumber)) {
					try {
						JSONObject form = new JSONObject();
						form.put(UtilRequest.FORM_MOBILE, phoneNumber);
						DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
						UtilRequest.vaildMobile(mContext, mHandler, form.toString(), 1);// 手机号已存在不能注册
					} catch (JSONException e) {
						e.printStackTrace();
					}
				} else {
					ToastUtil.showToast(mContext, getString(R.string.please_input_true_mobile_number));
				}
				break;
			case R.id.register_btn_show_password:// 显示密码按钮
				String passwordStr = inputPassword.getText().toString();
				int inputType = inputPassword.getInputType();
				if (inputType != InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD) {
					inputPassword.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);
				} else {
					inputPassword.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
				}
				inputPassword.setSelection(passwordStr.length());
				break;

			case R.id.register_check_box:// 同意协议
				vaildComplete();
				break;
			}
		}
	};

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_VAILD_MOBILE_EXISTS:// 验证手机号是否存在
				if (msg.obj == null) {
					return;
				}
				J_Response response = (J_Response) msg.obj;
				if (response.retcode == -1) {// 账号已经存在直接登录
					mHandler.postDelayed(new Runnable() {
						@Override
						public void run() {
							finish();
						}
					}, 1500);
				} else {
					String phoneNumber = inputPhoneNumber.getText().toString();
					try {
						JSONObject form = new JSONObject();
						form.put(UtilRequest.FORM_MOBILE, phoneNumber);
						UtilRequest.getSecurityCode(mHandler, form.toString(), mContext);
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
				break;
			case NetTaskIDs.TASKID_GET_SECURITY_CODE:// 获取手机验证码
				DialogUtils.dismissDialog();
				if (J_SDK.getConfig().LOG_ENABLE) {
					inputSecurityCode.setText(msg.obj.toString());
				}
				Util.btnCountdown(mHandler, Util.COUNTDOWN_TIME, getString(R.string.str_countdown_title), btnGetSecurityCode);
				btnGetSecurityCode.setEnabled(false);
				break;
			case NetTaskIDs.TASKID_VAILD_MOBILE_CODE:// 验证验证码
				DialogUtils.dismissDialog();
				String mobileNumber = inputPhoneNumber.getText().toString();
				String password = inputPassword.getText().toString().trim();
				String securityCode = inputSecurityCode.getText().toString().trim();
				Intent registerUserInfoIntent = new Intent(mContext, RegisterUserInfoActivity.class);
				registerUserInfoIntent.putExtra(UtilRequest.MOBILE_NUMBER, mobileNumber);
				registerUserInfoIntent.putExtra(UtilRequest.REGISTER_PASSWORD, password);
				registerUserInfoIntent.putExtra(UtilRequest.SECURITY_CODE, securityCode);
				startActivity(registerUserInfoIntent);
				finish();
			default:
				break;
			}
		};
	};

	private final TextWatcher textWatcher = new TextWatcher() {

		@Override
		public void onTextChanged(CharSequence s, int start, int before, int count) {
		}

		@Override
		public void beforeTextChanged(CharSequence s, int start, int count, int after) {
		}

		@Override
		public void afterTextChanged(Editable s) {
			vaildComplete();
		}
	};

	/**
	 * @Title: vaildComplete
	 * @Description: 验证是否可以执行下一步
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void vaildComplete() {
		String phoneNumber = inputPhoneNumber.getText().toString();
		String code = inputSecurityCode.getText().toString();
		String password = inputPassword.getText().toString();
		boolean checked = btnCheckBox.isChecked();
		if (Util.isMobileNumber(phoneNumber) && code.length() == 6 && password.length() >= 6 && password.length() <= 20
				&& checked) {
			btnComplete.setEnabled(true);
		} else {
			btnComplete.setEnabled(false);
		}
	}
}
