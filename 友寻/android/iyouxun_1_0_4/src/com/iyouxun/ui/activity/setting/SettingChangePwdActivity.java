package com.iyouxun.ui.activity.setting;

import java.util.HashMap;

import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.ChangePasswordRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 修改密码
 * 
 * @ClassName: SettingChangePwdActivity
 * @author likai
 * @date 2015-3-9 下午5:40:43
 * 
 */
public class SettingChangePwdActivity extends CommTitleActivity {
	private EditText changePwdOldPwd;
	private EditText changePwdNewPwd;
	private EditText changePwdReNewPwd;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("修改密码");

		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);

		titleRightButton.setText("完成");
		titleRightButton.setVisibility(View.VISIBLE);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_change_pwd, null);
	}

	@Override
	protected void initViews() {
		changePwdOldPwd = (EditText) findViewById(R.id.changePwdOldPwd);
		changePwdNewPwd = (EditText) findViewById(R.id.changePwdNewPwd);
		changePwdReNewPwd = (EditText) findViewById(R.id.changePwdReNewPwd);
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleRightButton:
				// 完成
				changePassword();
				break;

			default:
				break;
			}
		}
	};

	/**
	 * 修改密码
	 * 
	 * @Title: changePassword
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void changePassword() {
		String oldPwd = changePwdOldPwd.getText().toString();
		String newPwd = changePwdNewPwd.getText().toString();
		String newRePwd = changePwdReNewPwd.getText().toString();

		if (Util.isBlankString(oldPwd)) {
			ToastUtil.showToast(mContext, "原密码输入不正确");
		} else if (Util.isBlankString(newPwd) || newPwd.length() < 6 || newPwd.length() > 20) {
			ToastUtil.showToast(mContext, "密码长度为6至20个字");
		} else if (!newPwd.equals(newRePwd)) {
			ToastUtil.showToast(mContext, "两次输入的密码不一致");
		} else {
			new ChangePasswordRequest(new OnDataBack() {
				@Override
				public void onResponse(Object result) {
					J_Response response = (J_Response) result;
					switch (response.retcode) {
					case 1:
						ToastUtil.showToast(mContext, "修改成功");
						finish();
						break;
					case -1:
						ToastUtil.showToast(mContext, "新密码不能为空");
						break;
					case -3:
						ToastUtil.showToast(mContext, "密码位数不正确");
						break;
					case -4:
						ToastUtil.showToast(mContext, "原密码输入不正确");
						break;
					default:
						break;
					}
				}

				@Override
				public void onError(HashMap<String, Object> errMap) {
					ToastUtil.showToast(mContext, "密码修改失败");
				}
			}).execute(oldPwd, newPwd);
		}
	}
}
