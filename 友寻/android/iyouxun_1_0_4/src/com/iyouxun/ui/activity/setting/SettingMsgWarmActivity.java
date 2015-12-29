package com.iyouxun.ui.activity.setting;

import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.SettingSharedPreUtil;

/**
 * 消息提醒设置
 * 
 * @ClassName: SettingMsgWarmActivity
 * @author likai
 * @date 2015-3-9 下午7:26:55
 * 
 */
public class SettingMsgWarmActivity extends CommTitleActivity {
	private RelativeLayout settingMsgWarmGetButtonBox;
	private RelativeLayout settingMsgWarmVoiceGetButtonBox;
	private RelativeLayout settingMsgWarmVibrationGetButtonBox;
	private CheckBox settingMsgWarmGetButton;
	private CheckBox settingMsgWarmVoiceGetButton;
	private CheckBox settingMsgWarmVibrationGetButton;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("消息提醒");
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_setting_msg_warm, null);
	}

	@Override
	protected void initViews() {
		settingMsgWarmGetButtonBox = (RelativeLayout) findViewById(R.id.settingMsgWarmGetButtonBox);
		settingMsgWarmVoiceGetButtonBox = (RelativeLayout) findViewById(R.id.settingMsgWarmVoiceGetButtonBox);
		settingMsgWarmVibrationGetButtonBox = (RelativeLayout) findViewById(R.id.settingMsgWarmVibrationGetButtonBox);
		settingMsgWarmGetButton = (CheckBox) findViewById(R.id.settingMsgWarmGetButton);
		settingMsgWarmVoiceGetButton = (CheckBox) findViewById(R.id.settingMsgWarmVoiceGetButton);
		settingMsgWarmVibrationGetButton = (CheckBox) findViewById(R.id.settingMsgWarmVibrationGetButton);

		// 设置默认推送状态
		if (SettingSharedPreUtil.getOpenPush()) {
			settingMsgWarmGetButton.setChecked(true);
		}
		// 设置默认声音提醒状态
		if (SettingSharedPreUtil.getVoiceRemind()) {
			settingMsgWarmVoiceGetButton.setChecked(true);
		}
		// 设置默认震动提醒状态
		if (SettingSharedPreUtil.getShakeRemind()) {
			settingMsgWarmVibrationGetButton.setChecked(true);
		}

		settingMsgWarmGetButtonBox.setOnClickListener(listener);
		settingMsgWarmVoiceGetButtonBox.setOnClickListener(listener);
		settingMsgWarmVibrationGetButtonBox.setOnClickListener(listener);
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.settingMsgWarmGetButtonBox:
				// 设置是否接受消息
				if (!settingMsgWarmGetButton.isChecked()) {
					// 选中
					settingMsgWarmGetButton.setChecked(true);
					SettingSharedPreUtil.saveOpenPush(true);
				} else {
					// 取消
					settingMsgWarmGetButton.setChecked(false);
					SettingSharedPreUtil.saveOpenPush(false);
				}
				break;
			case R.id.settingMsgWarmVoiceGetButtonBox:
				// 声音设置
				if (!settingMsgWarmVoiceGetButton.isChecked()) {
					// 选中
					settingMsgWarmVoiceGetButton.setChecked(true);
					SettingSharedPreUtil.saveVoiceRemind(true);
				} else {
					// 取消
					settingMsgWarmVoiceGetButton.setChecked(false);
					SettingSharedPreUtil.saveVoiceRemind(false);
				}

				break;
			case R.id.settingMsgWarmVibrationGetButtonBox:
				// 震动设置
				if (!settingMsgWarmVibrationGetButton.isChecked()) {
					// 选中
					settingMsgWarmVibrationGetButton.setChecked(true);
					SettingSharedPreUtil.saveShakeRemind(true);
				} else {
					// 取消
					settingMsgWarmVibrationGetButton.setChecked(false);
					SettingSharedPreUtil.saveShakeRemind(false);
				}

				break;

			default:
				break;
			}
		}
	};

}
