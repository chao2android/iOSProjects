package com.iyouxun.ui.activity.register;

import android.content.Intent;
import android.os.Handler;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.activity.MainBoxActivity;
import com.iyouxun.utils.DialogUtils;

public class UploadContactActivity extends CommTitleActivity {
	private Button btnUpload;// 确定按钮
	private Button btnGiveUp;// 放弃按钮

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText("同步通讯录");
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_upload_contact, null);
	}

	@Override
	protected void initViews() {
		btnUpload = (Button) findViewById(R.id.upload_contact_btn);
		btnGiveUp = (Button) findViewById(R.id.upload_btn_give_up);
		btnUpload.setOnClickListener(listener);
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.upload_contact_btn:// 获取联系人并绑定
				DialogUtils.showProgressDialog(mContext, "同步中...");
				UtilRequest.uploadUserContacts(mContext, mHandler);
				break;
			case R.id.upload_btn_give_up:// 放弃按钮
				Intent intent = new Intent(mContext, MainBoxActivity.class);
				startActivity(intent);
				finish();
				break;
			default:
				break;
			}
		}
	};

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			Intent intent = new Intent(Intent.ACTION_MAIN);
			intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			intent.addCategory(Intent.CATEGORY_HOME);
			startActivity(intent);
			return true;
		} else {
			return super.onKeyDown(keyCode, event);
		}
	}

	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_UPLOAD_USER_CONTACTS:// 上传用户联系人
				Intent intent = new Intent(mContext, MainBoxActivity.class);
				startActivity(intent);
				finish();
				break;

			default:
				break;
			}
		};
	};
}
