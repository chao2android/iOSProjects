package com.iyouxun.ui.activity.message;

import android.content.Intent;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.GroupsInfoBean;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: EditGroupIntroductionActivity
 * @Description: 编辑用户简介
 * @author donglizhi
 * @date 2015年4月1日 下午6:06:08
 * 
 */
public class EditGroupIntroductionActivity extends CommTitleActivity {
	private EditText editIntroduction;// 编辑简介
	private GroupsInfoBean bean;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.message_group_introduction);
		titleLeftButton.setText(R.string.go_back);
		titleRightButton.setText(R.string.str_save);
		titleLeftButton.setOnClickListener(listener);
		titleRightButton.setOnClickListener(listener);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleRightButton.setVisibility(View.VISIBLE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_edit_group_introduction, null);
	}

	@Override
	protected void initViews() {
		editIntroduction = (EditText) findViewById(R.id.edit_group_introduction);
		if (getIntent().hasExtra(JsonParser.RESPONSE_DATA)) {
			bean = (GroupsInfoBean) getIntent().getSerializableExtra(JsonParser.RESPONSE_DATA);
			if (!Util.isBlankString(bean.name)) {
				editIntroduction.setText(bean.intro);
				editIntroduction.setSelection(bean.intro.length());
			}
		}
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 返回按钮
				finish();
				break;
			case R.id.titleRightButton:// 保存按钮
				String intro = editIntroduction.getText().toString();
				if (!Util.isBlankString(intro.trim())) {
					bean.intro = intro.trim();
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					UtilRequest.updateGroup(bean.id, intro, bean.privilege, mHandler, mContext);
				} else {
					ToastUtil.showToast(mContext, "请输入群组简介");
				}
				break;

			default:
				break;
			}
		}
	};
	private final Handler mHandler = new Handler() {
		@Override
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case NetTaskIDs.TASKID_UPDATE_GROUP:// 更新群信息
				DialogUtils.dismissDialog();
				Intent intent = new Intent();
				intent.putExtra(JsonParser.RESPONSE_DATA, bean);
				setResult(RESULT_OK, intent);
				finish();
				break;

			default:
				break;
			}
		};
	};

}
