/**
 * 
 * @Package com.iyouxun.ui.activity.setting
 * @author likai
 * @date 2015-6-5 上午9:52:40
 * @version V1.0
 */
package com.iyouxun.ui.activity.setting;

import android.view.View;
import android.widget.Button;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.Util;

/**
 * 关于我们
 * 
 * @author likai
 * @date 2015-6-5 上午9:52:40
 * 
 */
public class SettingAboutUsActivity extends CommTitleActivity {
	private TextView setting_about_us_tv;

	/**
	 * 
	 * @param titleCenter
	 * @param titleLeftButton
	 * @param titleRightButton
	 */
	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("关于我们");

		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	/**
	 * 
	 * @return
	 */
	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_setting_about_us, null);
	}

	/**
	 *  
	 */
	@Override
	protected void initViews() {
		setting_about_us_tv = (TextView) findViewById(R.id.setting_about_us_tv);

		setting_about_us_tv.setText(getString(R.string.iyouxun_about_us, Util.getAppVersionName()));
	}

}
