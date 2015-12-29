package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.iyouxun.R;
import com.iyouxun.data.beans.GroupsInfoBean;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.ui.views.CircularImage;

public class MyGroupAdapter extends BaseAdapter {
	private final ArrayList<GroupsInfoBean> datas;
	private final Context mContext;
	private int myGroupsSize = 0;
	private final OnClickListener listener;

	public MyGroupAdapter(Context mContext, ArrayList<GroupsInfoBean> datas, OnClickListener listener) {
		this.datas = datas;
		this.mContext = mContext;
		this.listener = listener;
	}

	public void setMyGroupsSize(int size) {
		myGroupsSize = size;
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
		ViewHolder holder = null;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = View.inflate(mContext, R.layout.item_my_group, null);
			holder.btnRefresh = (TextView) convertView.findViewById(R.id.my_group_btn_refresh);
			holder.recommendLayout = (RelativeLayout) convertView.findViewById(R.id.my_group_recommend_box);
			holder.groupAvatar = (CircularImage) convertView.findViewById(R.id.my_group_avatar);
			holder.join = (TextView) convertView.findViewById(R.id.my_group_btn_join);
			holder.name = (TextView) convertView.findViewById(R.id.my_group_name);
			holder.members = (TextView) convertView.findViewById(R.id.my_group_content);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.container = J_NetManager.getInstance().loadIMG(holder.container, datas.get(position).logo, holder.groupAvatar, 0,
				0);
		holder.name.setText(datas.get(position).name);
		String content = String.format(mContext.getResources().getString(R.string.group_members_content),
				datas.get(position).count, datas.get(position).friendsNum);
		holder.members.setText(content);
		if (position >= myGroupsSize) {
			if (position == myGroupsSize) {
				holder.recommendLayout.setVisibility(View.VISIBLE);
			} else {
				holder.recommendLayout.setVisibility(View.GONE);
			}
			holder.join.setVisibility(View.VISIBLE);
		} else {
			holder.recommendLayout.setVisibility(View.GONE);
			holder.join.setVisibility(View.GONE);
		}
		holder.btnRefresh.setOnClickListener(listener);
		holder.join.setTag(position);
		holder.join.setOnClickListener(listener);
		return convertView;
	}

	private class ViewHolder {
		private TextView btnRefresh;// 刷新按钮
		private RelativeLayout recommendLayout;// 推荐模块
		private CircularImage groupAvatar;// 群组头像
		private TextView join;// 加入按钮
		private TextView name;// 群组名称
		private TextView members;// 群组成员数量
		private ImageContainer container;
	}

}
