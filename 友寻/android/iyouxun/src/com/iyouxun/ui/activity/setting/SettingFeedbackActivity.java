/**
 * 
 * @Package com.iyouxun.ui.activity.setting
 * @author likai
 * @date 2015-5-15 下午3:47:21
 * @version V1.0
 */
package com.iyouxun.ui.activity.setting;

import java.util.HashMap;

import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.AddFeedbackRequest;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 
 * @author likai
 * @date 2015-5-15 下午3:47:21
 * 
 */
public class SettingFeedbackActivity extends CommTitleActivity {
	private EditText feedbackEt;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("意见反馈");

		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);

		titleRightButton.setText("提交");
		titleRightButton.setOnClickListener(listener);
		titleRightButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.setting_feedback_layout, null);
	}

	@Override
	protected void initViews() {
		feedbackEt = (EditText) findViewById(R.id.feedbackEt);
	}

	private final J_OnViewClickListener listener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.titleRightButton:
				// 提交按钮
				String content = feedbackEt.getText().toString().trim();
				if (Util.isBlankString(content)) {
					ToastUtil.showToast(mContext, "请填写反馈内容!");
				} else {
					showLoading("提交中...");
					new AddFeedbackRequest(new OnDataBack() {
						@Override
						public void onResponse(Object result) {
							J_Response response = (J_Response) result;
							if (response.retcode == 1) {
								ToastUtil.showToast(mContext, "提交成功,感谢您的反馈！");
								finish();
							} else {
								ToastUtil.showToast(mContext, "提交失败，请稍后重试!");
							}
							dismissLoading();
						}

						@Override
						public void onError(HashMap<String, Object> errorMap) {
							dismissLoading();
							UtilRequest.showNetworkError(mContext);
						}
					}).execute(content);
				}
				break;

			default:
				break;
			}
		}
	};
}
