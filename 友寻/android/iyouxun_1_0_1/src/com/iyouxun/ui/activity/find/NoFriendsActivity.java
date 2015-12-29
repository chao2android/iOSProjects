package com.iyouxun.ui.activity.find;

import android.content.Intent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;

/**
 * @ClassName: NoFriendsActivity
 * @Description: 没有好友的页面
 * @author donglizhi
 * @date 2015年3月27日 下午1:44:04
 * 
 */
public class NoFriendsActivity extends CommTitleActivity {
	private Button btnAdd;// 添加好友按钮

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleLeftButton.setText(R.string.go_back);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_no_friends, null);
	}

	@Override
	protected void initViews() {
		mContext = NoFriendsActivity.this;
		btnAdd = (Button) findViewById(R.id.no_friends_btn_add);
		btnAdd.setOnClickListener(listener);
		if (getIntent().hasExtra(UtilRequest.FORM_TYPE)) {
			int friendType = getIntent().getIntExtra(UtilRequest.FORM_TYPE, 1);
			if (friendType == 1) {
				titleCenter.setText(R.string.manage_friends);
			} else if (friendType == 2) {
				titleCenter.setText(R.string.find_indirect_friends);
			}
		}
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 头部左侧按钮
				finish();
				break;
			case R.id.no_friends_btn_add:// 添加好友
				Intent intent = new Intent();
				intent.setClass(mContext, AddFriendsActivity.class);
				startActivity(intent);
				finish();
				break;
			default:
				break;
			}
		}
	};
}
