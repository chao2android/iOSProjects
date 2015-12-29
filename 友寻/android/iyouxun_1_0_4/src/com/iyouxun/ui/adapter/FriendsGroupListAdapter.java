package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.beans.FriendsGroupBean;

/**
 * @ClassName: FriendsGroupListAdapter
 * @Description: 一度好友分组列表适配器
 * @author donglizhi
 * @date 2015年3月25日 下午3:01:40
 * 
 */
public class FriendsGroupListAdapter extends BaseAdapter {
	private final ArrayList<FriendsGroupBean> datas;
	private final Context context;

	public FriendsGroupListAdapter(Context mContext, ArrayList<FriendsGroupBean> datas) {
		this.datas = datas;
		context = mContext;
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
		ViewHolder holder;
		if (convertView == null) {
			convertView = View.inflate(context, R.layout.item_friends_group, null);
			holder = new ViewHolder();
			holder.name = (TextView) convertView.findViewById(R.id.friends_group_name);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		String showText = datas.get(position).getGroupName() + " （" + datas.get(position).getGroupMembersCount() + "）";
		holder.name.setText(showText);
		return convertView;
	}

	private class ViewHolder {
		TextView name;// 分组名称
	}
}
