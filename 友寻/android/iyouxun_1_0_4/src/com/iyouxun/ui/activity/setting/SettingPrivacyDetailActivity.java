package com.iyouxun.ui.activity.setting;

import java.util.ArrayList;

import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.beans.PrivacyInfoBean;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.SettingPrivacyListAdapter;
import com.iyouxun.utils.SettingSharedPreUtil;
import com.iyouxun.utils.Util;

/**
 * 好友与聊天隐私设置
 * 
 * @ClassName: SettingPrivacyFriendAndChatActivity
 * @author likai
 * @date 2015-3-9 下午6:21:14
 * 
 */
public class SettingPrivacyDetailActivity extends CommTitleActivity {
	private ListView privacyFriendAndChatLv;
	private SettingPrivacyListAdapter adapter;
	private final ArrayList<PrivacyInfoBean> datas = new ArrayList<PrivacyInfoBean>();
	/** 隐私类型，1：好友与聊天，2：资料展示 */
	private int type = 1;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		type = getIntent().getIntExtra("type", 1);

		if (type == 1) {
			titleCenter.setText("好友与聊天");
		} else if (type == 2) {
			titleCenter.setText("资料展示");
		}
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_setting_privacy_friend_and_chat, null);
	}

	@Override
	protected void initViews() {
		privacyFriendAndChatLv = (ListView) findViewById(R.id.privacyFriendAndChatLv);

		// 设置adapter数据
		String[] privacyData = getResources().getStringArray(R.array.privacy_chat_and_friend);
		String[] privacyCodeData = getResources().getStringArray(R.array.privacy_chat_and_friend_code);
		// 默认选项
		int defaultSelect = 0;
		if (type == 1) {
			// 好友与聊天
			privacyData = getResources().getStringArray(R.array.privacy_chat_and_friend);
			privacyCodeData = getResources().getStringArray(R.array.privacy_chat_and_friend_code);
			defaultSelect = SettingSharedPreUtil.getShareIntConfigInfo("allow_add_with_chat");
		} else if (type == 2) {
			// 资料展示
			// 允许二度好友查看我的朋友朋友圈 打开 时，隐藏 只允许一度查看相册和动态
			// 允许二度好友查看我的朋友朋友圈 关闭 时，隐藏 允许一度和二度查看相册和动态
			// 1、允许所有人查看动态和相册
			// 2、只允许一度好友查看动态和相册
			// 3、允许一度和二度好友查看动态和相册
			// 4、非好友可以查看最新5条更新内容
			int allow_second_friend_look_my_dync = SettingSharedPreUtil.getShareIntConfigInfo("allow_second_friend_look_my_dync");
			if (allow_second_friend_look_my_dync == 1) {
				privacyData = getResources().getStringArray(R.array.privacy_profile_on);
				privacyCodeData = getResources().getStringArray(R.array.privacy_profile_code_on);
			} else {
				privacyData = getResources().getStringArray(R.array.privacy_profile_off);
				privacyCodeData = getResources().getStringArray(R.array.privacy_profile_code_off);
			}
			defaultSelect = SettingSharedPreUtil.getShareIntConfigInfo("allow_my_profile_show");
		}
		// 设置页面显示数据
		for (int i = 0; i < privacyData.length; i++) {
			PrivacyInfoBean bean = new PrivacyInfoBean();
			bean.id = privacyCodeData[i];
			bean.name = privacyData[i];
			if (defaultSelect == Util.getInteger(bean.id)) {
				// 设置默认选中项
				bean.status = 1;
			}
			datas.add(bean);
		}

		adapter = new SettingPrivacyListAdapter();
		adapter.setDatas(datas);
		privacyFriendAndChatLv.setAdapter(adapter);
		privacyFriendAndChatLv.setOnItemClickListener(new OnItemClickListener() {
			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				for (int i = 0; i < datas.size(); i++) {
					PrivacyInfoBean bean = datas.get(i);
					if (i == position) {
						// 选中
						bean.status = 1;
						if (type == 1) {
							UtilRequest.updatePrivacyInfo("allow_add_with_chat", Util.getInteger(bean.id), null);
						} else {
							UtilRequest.updatePrivacyInfo("allow_my_profile_show", Util.getInteger(bean.id), null);
						}
					} else {
						// 未选中
						bean.status = 0;
					}
					datas.set(i, bean);
				}
				adapter.notifyDataSetChanged();
			}
		});
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:
				// 返回保存
				finish();
				break;

			default:
				break;
			}
		}
	};
}
