package com.iyouxun.ui.activity.message;

import android.content.Intent;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.GroupsInfoBean;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.views.ClearEditText;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * @ClassName: EditGroupNameActivity
 * @Description: 编辑群组名称
 * @author donglizhi
 * @date 2015年4月1日 下午4:31:56
 * 
 */
public class EditGroupNameActivity extends CommTitleActivity {
	private ClearEditText groupName;// 群组名称
	private GroupsInfoBean bean;// 群组数据
	private LinearLayout box;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.chat_group_name);
		titleLeftButton.setText(R.string.go_back);
		titleRightButton.setText(R.string.str_save);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleRightButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_edit_group_name, null);
	}

	@Override
	protected void initViews() {
		groupName = (ClearEditText) findViewById(R.id.edit_chat_group_name);
		box = (LinearLayout) findViewById(R.id.edit_chat_group_name_box);
		box.setOnClickListener(listener);
		if (getIntent().hasExtra(JsonParser.RESPONSE_DATA)) {
			bean = (GroupsInfoBean) getIntent().getSerializableExtra(JsonParser.RESPONSE_DATA);
			if (!Util.isBlankString(bean.name)) {
				if (bean.name.length() > 14) {
					bean.name = bean.name.substring(0, 14);
				}
				groupName.setText(bean.name);
				groupName.setSelection(bean.name.length());
			}
		}
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.edit_chat_group_name_box:// 其他区域
				Util.hideKeyboard(mContext, groupName);
				break;
			case R.id.titleLeftButton:// 返回按钮
				finish();
				break;
			case R.id.titleRightButton:// 保存按钮
				String title = groupName.getText().toString();
				if (!Util.isBlankString(title.trim())) {
					bean.name = title.trim();
					DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
					UtilRequest.updateGroupTitle(bean.id + "", title.trim(), mHandler, mContext);
				} else {
					ToastUtil.showToast(mContext, "请输入群组名称");
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
			case NetTaskIDs.TASKID_UPDATE_GROUP_TITLE:// 更新群信息
				DialogUtils.dismissDialog();
				Intent intent = new Intent();
				intent.putExtra(JsonParser.RESPONSE_DATA, bean);
				setResult(RESULT_OK, intent);
				Intent updateIntent = new Intent();
				updateIntent.setAction(UtilRequest.BROADCAST_ACTION_UPDATE_GROUP_NAME);
				updateIntent.putExtra(UtilRequest.FORM_GROUP_ID, bean.id);
				updateIntent.putExtra(UtilRequest.FORM_TITLE, bean.name);
				sendBroadcast(updateIntent);
				finish();
				break;

			default:
				break;
			}
		};
	};
}
