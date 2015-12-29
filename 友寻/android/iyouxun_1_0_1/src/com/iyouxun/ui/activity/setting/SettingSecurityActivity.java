package com.iyouxun.ui.activity.setting;

import android.content.Intent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

/**
 * 帐号安全设置
 * 
 * @ClassName: SettingSecurityActivity
 * @author likai
 * @date 2015-3-9 下午3:43:05
 * 
 */
public class SettingSecurityActivity extends CommTitleActivity {
	private TextView settingSecurityAccountInfo;
	private Button settingSecurityFindPwdButton;
	private Button settingSecurityChangePwdButton;
	private Button settingSecurityChangeMobileButton;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("帐号安全");
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_setting_security, null);
	}

	@Override
	protected void initViews() {
		settingSecurityAccountInfo = (TextView) findViewById(R.id.settingSecurityAccountInfo);
		settingSecurityFindPwdButton = (Button) findViewById(R.id.settingSecurityFindPwdButton);
		settingSecurityChangePwdButton = (Button) findViewById(R.id.settingSecurityChangePwdButton);
		settingSecurityChangeMobileButton = (Button) findViewById(R.id.settingSecurityChangeMobileButton);

		settingSecurityFindPwdButton.setOnClickListener(listener);
		settingSecurityChangePwdButton.setOnClickListener(listener);
		settingSecurityChangeMobileButton.setOnClickListener(listener);
	}

	@Override
	protected void onResume() {
		super.onResume();

		// 设置当前帐号
		String formatMobile = Util.getFormatMobileNumber(SharedPreUtil.getLoginMobile());
		if (Util.isBlankString(formatMobile)) {
			formatMobile = "第三方平台帐号";
		}
		settingSecurityAccountInfo.setText(formatMobile);
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.settingSecurityFindPwdButton:
				// 找回密码
				Intent findPwdIntent = new Intent(mContext, SettingFindPwdActivity.class);
				startActivity(findPwdIntent);
				break;
			case R.id.settingSecurityChangePwdButton:
				// 修改密码
				Intent changePwdIntent = new Intent(mContext, SettingChangePwdActivity.class);
				startActivity(changePwdIntent);
				break;
			case R.id.settingSecurityChangeMobileButton:
				// 更换手机号
				Intent changeMobileIntent = new Intent(mContext, SettingChangeMobileActivity.class);
				startActivity(changeMobileIntent);
				break;
			default:
				break;
			}
		}
	};
}
