package com.iyouxun.ui.activity.setting;

import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.SettingSharedPreUtil;

/**
 * 隐私设置
 * 
 * @ClassName: SettingPrivacyActivity
 * @author likai
 * @date 2015-3-9 下午6:05:11
 * 
 */
public class SettingPrivacyActivity extends CommTitleActivity {
	private RelativeLayout settingPrivacyButtonBox1;
	private RelativeLayout settingPrivacyButtonBox2;
	private CheckBox settingPrivacyButton1;
	private CheckBox settingPrivacyButton2;
	private Button settingPrivacyFriendAndChat;
	private Button settingPrivacyProfile;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("隐私设置");
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_setting_privacy, null);
	}

	@Override
	protected void initViews() {
		settingPrivacyButtonBox1 = (RelativeLayout) findViewById(R.id.settingPrivacyButtonBox1);
		settingPrivacyButtonBox2 = (RelativeLayout) findViewById(R.id.settingPrivacyButtonBox2);
		settingPrivacyButton1 = (CheckBox) findViewById(R.id.settingPrivacyButton1);
		settingPrivacyButton2 = (CheckBox) findViewById(R.id.settingPrivacyButton2);
		settingPrivacyFriendAndChat = (Button) findViewById(R.id.settingPrivacyFriendAndChat);
		settingPrivacyProfile = (Button) findViewById(R.id.settingPrivacyProfile);

		// 设置点击事件监听
		settingPrivacyButtonBox1.setOnClickListener(listener);
		settingPrivacyButtonBox2.setOnClickListener(listener);
		settingPrivacyFriendAndChat.setOnClickListener(listener);
		settingPrivacyProfile.setOnClickListener(listener);
	}

	@Override
	protected void onResume() {
		super.onResume();

		// 设置页面数据的默认值
		setContentInfo();
	}

	/**
	 * 设置页面数据的默认值
	 * 
	 * @Title: setContentInfo
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void setContentInfo() {
		// 默认值1-在熟人圈显示二度好友动态
		if (SettingSharedPreUtil.getShareIntConfigInfo("show_second_friend_dync") == 1) {
			settingPrivacyButton1.setChecked(true);
		}
		// 默认值2-允许二度好友查看我的朋友圈动态
		if (SettingSharedPreUtil.getShareIntConfigInfo("allow_second_friend_look_my_dync") == 1) {
			settingPrivacyButton2.setChecked(true);
		}
		// 默认值4
		String[] privacyDataFAndC = getResources().getStringArray(R.array.privacy_chat_and_friend);
		int fAndCSelect = SettingSharedPreUtil.getShareIntConfigInfo("allow_add_with_chat");
		settingPrivacyFriendAndChat.setText(privacyDataFAndC[fAndCSelect]);
		// 默认值5
		String[] privacyDataProfile = getResources().getStringArray(R.array.privacy_profile);
		int profileSelect = SettingSharedPreUtil.getShareIntConfigInfo("allow_my_profile_show");
		settingPrivacyProfile.setText(privacyDataProfile[profileSelect]);
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.settingPrivacyButtonBox1:
				// 在熟人圈显示二度好友动态
				if (!settingPrivacyButton1.isChecked()) {
					settingPrivacyButton1.setChecked(true);
					UtilRequest.updatePrivacyInfo("show_second_friend_dync", 1, null);
				} else {
					settingPrivacyButton1.setChecked(false);
					UtilRequest.updatePrivacyInfo("show_second_friend_dync", 0, null);
				}
				break;
			case R.id.settingPrivacyButtonBox2:
				// 允许二度好友查看我的朋友圈动态
				if (!settingPrivacyButton2.isChecked()) {
					settingPrivacyButton2.setChecked(true);
					UtilRequest.updatePrivacyInfo("allow_second_friend_look_my_dync", 1, new Handler() {
						@Override
						public void handleMessage(Message msg) {
							// 允许二度好友查看我的朋友朋友圈 打开 时，隐藏 只允许一度查看相册和动态
							if (SettingSharedPreUtil.getShareIntConfigInfo("allow_my_profile_show") == 1) {
								UtilRequest.updatePrivacyInfo("allow_my_profile_show", 2, new Handler() {
									@Override
									public void handleMessage(Message msg) {
										setContentInfo();
									}
								});
							}
						}
					});
				} else {
					settingPrivacyButton2.setChecked(false);
					UtilRequest.updatePrivacyInfo("allow_second_friend_look_my_dync", 0, new Handler() {
						@Override
						public void handleMessage(Message msg) {
							// 允许二度好友查看我的朋友朋友圈 关闭 时，隐藏 允许一度和二度查看相册和动态
							if (SettingSharedPreUtil.getShareIntConfigInfo("allow_my_profile_show") == 2) {
								UtilRequest.updatePrivacyInfo("allow_my_profile_show", 1, new Handler() {
									@Override
									public void handleMessage(Message msg) {
										setContentInfo();
									}
								});
							}
						}
					});
				}
				break;
			case R.id.settingPrivacyFriendAndChat:
				// 好友与聊天
				Intent friendChatIntent = new Intent(mContext, SettingPrivacyDetailActivity.class);
				friendChatIntent.putExtra("type", 1);
				startActivity(friendChatIntent);
				break;
			case R.id.settingPrivacyProfile:
				// 资料页展示
				Intent friendChatIntent2 = new Intent(mContext, SettingPrivacyDetailActivity.class);
				friendChatIntent2.putExtra("type", 2);
				startActivity(friendChatIntent2);
				break;
			default:
				break;
			}
		}
	};

}
