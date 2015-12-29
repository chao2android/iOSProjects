package com.iyouxun.ui.activity.register;

import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.Button;
import android.widget.ListView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.beans.MarriageInfoBean;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.adapter.EmotionalListAdapter;

/**
 * @ClassName: EmotionalSelectActivity
 * @Description: 补充信息选择情感状态
 * @author donglizhi
 * @date 2015年3月5日 下午2:46:47
 * 
 */
public class EmotionalSelectActivity extends CommTitleActivity {
	private ListView emotionalList;// 全部情感状态
	private Context mContext;
	private EmotionalListAdapter adapter;
	private final ArrayList<MarriageInfoBean> datas = new ArrayList<MarriageInfoBean>();// 情感状态数据
	private int userMarriageStatus = 1;// 用户情感状态

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setText(R.string.select_emotional_status);
		titleLeftButton.setText(R.string.go_back);
		titleLeftButton.setVisibility(View.VISIBLE);
		titleLeftButton.setOnClickListener(listener);
	}

	@Override
	protected View setContentView() {
		return View.inflate(this, R.layout.activity_emotional, null);
	}

	@Override
	protected void initViews() {
		mContext = EmotionalSelectActivity.this;
		emotionalList = (ListView) findViewById(R.id.emotional_listview);
		String[] marriage = getResources().getStringArray(R.array.profile_marriage_array);
		userMarriageStatus = getIntent().getIntExtra(UtilRequest.USER_MARRIAGE_STATUS, 0);
		for (int i = 0; i < marriage.length; i++) {
			MarriageInfoBean bean = new MarriageInfoBean();
			int id = i + 1;
			bean.id = id;
			bean.name = marriage[i];
			if (userMarriageStatus == id) {
				bean.status = 1;
			} else {
				bean.status = 0;
			}
			datas.add(bean);
		}
		adapter = new EmotionalListAdapter(mContext, datas);
		emotionalList.setAdapter(adapter);
		emotionalList.setOnItemClickListener(onItemClickListener);
	}

	private final OnClickListener listener = new OnClickListener() {

		@Override
		public void onClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:
				Intent resultIntent = new Intent();
				resultIntent.putExtra(UtilRequest.USER_MARRIAGE_STATUS, userMarriageStatus);
				setResult(RESULT_OK, resultIntent);
				finish();
				break;

			default:
				break;
			}
		}
	};
	/**
	 * @Fields onItemClickListener : emotionalListview监听器
	 */
	private final OnItemClickListener onItemClickListener = new OnItemClickListener() {

		@Override
		public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
			for (int i = 0; i < datas.size(); i++) {
				if (position == i) {
					userMarriageStatus = datas.get(i).id;// 修改用户情感状态
					datas.get(i).status = 1;
				} else {
					datas.get(i).status = 0;
				}
			}
			adapter.notifyDataSetChanged();
		}
	};

	@Override
	public boolean onKeyDown(int keyCode, android.view.KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			Intent resultIntent = new Intent();
			resultIntent.putExtra(UtilRequest.USER_MARRIAGE_STATUS, userMarriageStatus);
			setResult(RESULT_OK, resultIntent);
			finish();
			return true;
		} else {
			return super.onKeyDown(keyCode, event);
		}
	};
}
