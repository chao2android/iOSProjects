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
import com.iyouxun.data.beans.FriendsGroupBean;

/**
 * 获取群组列表
 * 
 * @ClassName: NewsAuthGroupListAdapter
 * @author likai
 * @date 2015-3-7 上午10:58:35
 * 
 */
public class NewsAuthGroupListAdapter extends BaseAdapter {
	public ArrayList<FriendsGroupBean> datas = new ArrayList<FriendsGroupBean>();

	public void setDatas(ArrayList<FriendsGroupBean> datas) {
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
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_auth_groups_layout, null);
			vh.itemAuthGroupName = (TextView) convertView.findViewById(R.id.itemAuthGroupName);
			vh.itemAuthGroupsCb = (CheckBox) convertView.findViewById(R.id.itemAuthGroupsCb);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		FriendsGroupBean group = datas.get(position);

		// 群名称
		vh.itemAuthGroupName.setText(group.getGroupName() + "(" + group.getGroupMembersCount() + ")");
		// 选中状态
		if (group.getIsChecked() == 0) {
			vh.itemAuthGroupsCb.setChecked(false);
		} else {
			vh.itemAuthGroupsCb.setChecked(true);
		}

		return convertView;
	}

	private class ViewHolder {
		public TextView itemAuthGroupName;
		public CheckBox itemAuthGroupsCb;
	}
}
