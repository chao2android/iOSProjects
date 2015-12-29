package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.data.beans.users.GroupUser;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.utils.Util;

/**
 * 群组成员列表adapter
 * 
 * @author likai
 * @date 2015-3-31 下午7:06:18
 * 
 */
public class GroupUserListAdapter extends BaseAdapter {
	private final Context mContext;
	private final ArrayList<GroupUser> datas = new ArrayList<GroupUser>();

	public GroupUserListAdapter(Context mContext) {
		this.mContext = mContext;
	}

	public void setDatas(ArrayList<GroupUser> datas) {
		// 为了实现折叠、展示功能
		this.datas.clear();
		for (int i = 0; i < datas.size(); i++) {
			GroupUser user = datas.get(i);
			if (user.isVisiable) {
				this.datas.add(user);
			}
		}
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
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_recommend_friends, null);
			if (Util.getScreenDensityDpi(mContext) >= 320) {
				convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_recommend_friends, null);
			} else {
				convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_recommend_friends_small, null);
			}
			vh.recommend_friend_avatar = (CircularImage) convertView.findViewById(R.id.recommend_friend_avatar);
			vh.recommend_friend_nick = (TextView) convertView.findViewById(R.id.recommend_friend_nick);
			vh.recommend_group_admin = (ImageView) convertView.findViewById(R.id.recommend_group_admin);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		GroupUser user = datas.get(position);

		// 设置头像
		vh.container = J_NetManager.getInstance().loadIMG(vh.container, user.avatarUrl, vh.recommend_friend_avatar,
				R.drawable.icon_avatar, R.drawable.icon_avatar);
		// 昵称
		String nick = user.nickName;
		if (user.isAdmin) {
			nick = user.nickName;
		}
		vh.recommend_friend_nick.setText(nick);
		// 不同性别，不同颜色
		if (user.sex == 0) {
			// 女
			vh.recommend_friend_nick.setTextColor(mContext.getResources().getColor(R.color.text_normal_red));
		} else {
			// 男
			vh.recommend_friend_nick.setTextColor(mContext.getResources().getColor(R.color.text_normal_blue));
		}
		// 群主标记
		if (user.isAdmin) {
			vh.recommend_group_admin.setVisibility(View.VISIBLE);
		} else {
			vh.recommend_group_admin.setVisibility(View.GONE);
		}

		return convertView;
	}

	private class ViewHolder {
		public ImageContainer container;

		public CircularImage recommend_friend_avatar;// 头像
		public TextView recommend_friend_nick;// 昵称

		public ImageView recommend_group_admin;// 群主标记
	}
}
