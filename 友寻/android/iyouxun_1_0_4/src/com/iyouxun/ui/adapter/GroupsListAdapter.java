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
import com.iyouxun.data.beans.GroupsInfoBean;
import com.iyouxun.utils.StringUtils;

/**
 * 群组列表adapter
 * 
 * @ClassName: GroupsListAdapter
 * @author likai
 * @date 2015-3-2 下午7:57:11
 * 
 */
public class GroupsListAdapter extends BaseAdapter {
	private final Context mContext;
	private ArrayList<GroupsInfoBean> datas;

	public GroupsListAdapter(Context context) {
		mContext = context;
	}

	public void setData(ArrayList<GroupsInfoBean> datas) {
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
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_groups_layout, null);
			vh.groups_item_name = (TextView) convertView.findViewById(R.id.groups_item_name);
			vh.groups_item_cb = (CheckBox) convertView.findViewById(R.id.groups_item_cb);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		GroupsInfoBean msg = datas.get(position);

		// 显示群组名称
		vh.groups_item_name.setText(StringUtils.getLimitSubstringWithMore(msg.name, 14) + "(" + msg.count + "人)");
		// 显示选中状态
		if (msg.show == 0) {
			// 显示
			vh.groups_item_cb.setChecked(true);
		} else {
			// 不显示
			vh.groups_item_cb.setChecked(false);
		}

		return convertView;
	}

	private class ViewHolder {
		public TextView groups_item_name;
		public CheckBox groups_item_cb;// 领取按钮
	}
}
