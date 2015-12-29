package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.TextView;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.data.beans.PrivacyInfoBean;

/**
 * 隐私设置选项列表
 * 
 * @ClassName: SettingPrivacyListAdapter
 * @author likai
 * @date 2015-3-9 下午6:51:09
 * 
 */
public class SettingPrivacyListAdapter extends BaseAdapter {
	private ArrayList<PrivacyInfoBean> datas = new ArrayList<PrivacyInfoBean>();

	public void setDatas(ArrayList<PrivacyInfoBean> datas) {
		this.datas = datas;
	}

	@Override
	public int getCount() {
		return datas.size();
	}

	@Override
	public Object getItem(int position) {
		return datas.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder vh = new ViewHolder();
		if (convertView == null) {
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_setting_privacy_layout, null);
			vh.settingPrivacyButton = (CheckBox) convertView.findViewById(R.id.settingPrivacyButton);
			vh.settingPrivacyTxt = (TextView) convertView.findViewById(R.id.settingPrivacyTxt);
			vh.settingPrivacyDeliver = convertView.findViewById(R.id.settingPrivacyDeliver);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		PrivacyInfoBean data = datas.get(position);
		// 设置选项内容
		vh.settingPrivacyTxt.setText(data.name);
		// 设置选中状态
		if (data.status == 1) {
			vh.settingPrivacyButton.setChecked(true);
		} else {
			vh.settingPrivacyButton.setChecked(false);
		}
		// 下横线的显示控制
		if (position == datas.size() - 1) {
			vh.settingPrivacyDeliver.setVisibility(View.GONE);
		} else {
			vh.settingPrivacyDeliver.setVisibility(View.VISIBLE);
		}

		return convertView;
	}

	private class ViewHolder {
		public CheckBox settingPrivacyButton;
		public TextView settingPrivacyTxt;

		public View settingPrivacyDeliver;
	}
}
