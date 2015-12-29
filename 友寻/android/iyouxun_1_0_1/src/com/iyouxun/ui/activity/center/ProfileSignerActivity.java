package com.iyouxun.ui.activity.center;

import java.util.HashMap;

import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.J_OnDataBack;
import com.iyouxun.net.request.UpdateUserIntroRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.StringUtils;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 我的签名管理页
 * 
 * @ClassName: ProfileSignerActivity
 * @author likai
 * @date 2015-2-28 下午2:34:16
 * 
 */
public class ProfileSignerActivity extends CommTitleActivity {
	private EditText profile_singer_et;
	private LinearLayout profileIntroBox;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("签名");
		titleLeftButton.setText("返回");
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_profile_signer, null);
	}

	@Override
	protected void initViews() {
		profile_singer_et = (EditText) findViewById(R.id.profile_singer_et);
		profileIntroBox = (LinearLayout) findViewById(R.id.profileIntroBox);

		profile_singer_et.setText(J_Cache.sLoginUser.intro);

		profileIntroBox.setOnClickListener(listener);

		// 最多输入100个汉字
		profile_singer_et.addTextChangedListener(new TextWatcher() {
			private String temp;

			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				temp = s.toString().trim();
			}

			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
			}

			@Override
			public void afterTextChanged(Editable s) {
				if (!TextUtils.isEmpty(temp)) {
					String limitSubstring = StringUtils.getLimitSubstring(temp, 200);
					if (!TextUtils.isEmpty(limitSubstring)) {
						if (!limitSubstring.equals(temp)) {
							profile_singer_et.setText(limitSubstring);
							profile_singer_et.setSelection(limitSubstring.length());
						}
					}
				}
			}
		});
	}

	private final OnClickListener listener = new OnClickListener() {
		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.profileIntroBox:
				Util.hideKeyboard(mContext, profile_singer_et);
				break;
			case R.id.titleLeftButton:
				// 返回保存
				save();
				break;

			default:
				break;
			}
		}
	};

	/**
	 * 保存信息
	 * 
	 * @Title: save
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 * @throws
	 */
	private void save() {
		showLoading("信息保存中...");
		final String intro = profile_singer_et.getText().toString().trim();
		new UpdateUserIntroRequest(new J_OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				if (response.retcode == 1) {
					ToastUtil.showToast(mContext, "保存成功");
					J_Cache.sLoginUser.intro = intro;
					finish();
				} else {
					ToastUtil.showToast(mContext, "保存失败:" + response.retmean);
					dismissLoading();
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
				super.onError(errorMap);
				dismissLoading();
			}
		}).execute(intro);
	}

	/**
	 * 捕获用户按键（菜单键和返回键）
	 * 
	 * */
	@Override
	public boolean dispatchKeyEvent(KeyEvent event) {
		if (event.getKeyCode() == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0 && event.getAction() != KeyEvent.ACTION_UP) {
			save();
			return true;
		}
		return super.dispatchKeyEvent(event);
	}
}
