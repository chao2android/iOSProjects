/**
 * 
 * @Package com.iyouxun.ui.activity.setting
 * @author likai
 * @date 2015-6-5 下午2:32:12
 * @version V1.0
 */
package com.iyouxun.ui.activity.setting;

import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;

/**
 * 我的二维码
 * 
 * @author likai
 * @date 2015-6-5 下午2:32:12
 * 
 */
public class SettingMyQRCodeActivity extends CommTitleActivity {
	private ImageView my_qr_code_iv;// 二维码图片

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("我的二维码");

		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_setting_my_qrcode, null);
	}

	@Override
	protected void initViews() {
		my_qr_code_iv = (ImageView) findViewById(R.id.my_qr_code_iv);

		// 二维码地址
		String contents = J_Consts.SHARE_URL_USER + SharedPreUtil.getLoginInfo().uid;
		// 生成二维码
		Util.createQRImageWidthAvatar(contents, my_qr_code_iv);
	}

}
