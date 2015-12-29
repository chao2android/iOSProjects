package com.iyouxun.ui.activity.center;

import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.ui.activity.CommTitleActivity;

/**
 * 我的动态管理
 * 
 * @ClassName: ProfileMyNewsActivity
 * @author likai
 * @date 2015-2-28 下午2:13:14
 * 
 */
public class ProfileNewsActivity extends CommTitleActivity {

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("我的动态");
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_profile_news, null);
	}

	@Override
	protected void initViews() {
	}

}
