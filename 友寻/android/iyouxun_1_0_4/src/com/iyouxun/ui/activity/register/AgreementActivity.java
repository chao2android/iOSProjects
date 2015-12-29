package com.iyouxun.ui.activity.register;

import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.ui.activity.CommTitleActivity;

/**
 * @ClassName: AgreementActivity
 * @Description:服务协议页面
 * @author donglizhi
 * @date 2015年3月5日 下午5:09:38
 * 
 */
public class AgreementActivity extends CommTitleActivity {

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.agreement_register);
		titleLeftButton.setText(R.string.go_back);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				finish();
			}
		});
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_agreement, null);
	}

	@Override
	protected void initViews() {
		TextView rightPadding = (TextView) findViewById(R.id.titleRightPadding);
		TextView leftPadding = (TextView) findViewById(R.id.titleLeftPadding);
		rightPadding.setVisibility(View.GONE);
		leftPadding.setVisibility(View.GONE);
	}

}
