package com.iyouxun.ui.activity.message;

import java.util.ArrayList;

import android.content.Intent;
import android.os.Handler;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.GroupsInfoBean;
import com.iyouxun.data.parser.JsonParser;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.GroupPrivilegeAdapter;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.LoadingHandler;

public class EditGroupPrivilegeActivity extends CommTitleActivity {
	private ListView privilegeList;// 权限设置
	private final ArrayList<String> datas = new ArrayList<String>();
	private GroupPrivilegeAdapter adapter;
	private int selectedPositon = -1;// 选中的权限id
	private GroupsInfoBean bean;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.message_privilege_setting);
		titleLeftButton.setText(R.string.go_back);
		titleRightButton.setText(R.string.str_save);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleRightButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
		titleRightButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_edit_group_privilege, null);
	}

	@Override
	protected void initViews() {
		mContext = EditGroupPrivilegeActivity.this;
		String[] array = getResources().getStringArray(R.array.group_privilege);
		datas.add(getResources().getString(R.string.message_privilege_setting));
		for (int i = 0; i < array.length; i++) {
			datas.add(array[i]);
		}
		privilegeList = (ListView) findViewById(R.id.edit_group_privilege);
		adapter = new GroupPrivilegeAdapter(mContext, datas);
		if (getIntent().hasExtra(JsonParser.RESPONSE_DATA)) {// 初始化数据
			bean = (GroupsInfoBean) getIntent().getSerializableExtra(JsonParser.RESPONSE_DATA);
			selectedPositon = bean.privilege;
			adapter.setSelectedPosition(selectedPositon + 1);
		}
		privilegeList.setAdapter(adapter);
		privilegeList.setOnItemClickListener(new OnItemClickListener() {

			@Override
			public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
				if (position != 0) {// 选中的权限
					selectedPositon = position - 1;
					adapter.setSelectedPosition(position);
					adapter.notifyDataSetChanged();
				}
			}
		});
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:// 返回按钮
				finish();
				break;
			case R.id.titleRightButton:// 保存按钮
				bean.privilege = selectedPositon;
				DialogUtils.showProgressDialog(mContext, LoadingHandler.DEFALT_STR);
				UtilRequest.updateGroup(bean.id, bean.intro, selectedPositon, mHandler, mContext);
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
