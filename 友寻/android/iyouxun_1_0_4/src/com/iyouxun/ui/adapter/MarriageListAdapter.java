package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.CheckBox;
import android.widget.TextView;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.data.beans.MarriageInfoBean;

/**
 * 情感状态列表adapter
 * 
 * @ClassName: MarriageListAdapter
 * @author likai
 * @date 2015-3-3 下午7:29:39
 * 
 */
public class MarriageListAdapter extends BaseAdapter {
	private final Context mContext;
	private ArrayList<MarriageInfoBean> datas;

	public MarriageListAdapter(Context context) {
		mContext = context;
	}

	public void setData(ArrayList<MarriageInfoBean> datas) {
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
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_marriage_layout, null);
			vh.marriage_item_name = (TextView) convertView.findViewById(R.id.marriage_item_name);
			vh.marriage_item_cb = (CheckBox) convertView.findViewById(R.id.marriage_item_cb);
			vh.marriage_item_line = convertView.findViewById(R.id.marriage_item_line);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		MarriageInfoBean msg = datas.get(position);

		// 显示群组名称
		vh.marriage_item_name.setText(msg.name);
		// 显示选中状态
		if (msg.status == 1) {
			// 显示
			vh.marriage_item_cb.setChecked(true);
		} else {
			// 不显示
			vh.marriage_item_cb.setChecked(false);
		}

		// 底线的显示
		if (position == datas.size() - 1) {
			vh.marriage_item_line.setVisibility(View.GONE);
		} else {
			vh.marriage_item_line.setVisibility(View.VISIBLE);
		}

		return convertView;
	}

	private class ViewHolder {
		public TextView marriage_item_name;
		public CheckBox marriage_item_cb;// 领取按钮
		public View marriage_item_line;// 底线
	}
}
