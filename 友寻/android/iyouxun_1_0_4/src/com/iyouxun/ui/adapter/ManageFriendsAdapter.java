package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.iyouxun.R;
import com.iyouxun.data.beans.ManageFriendsBean;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.utils.Util;

public class ManageFriendsAdapter extends BaseAdapter {
	private ArrayList<ManageFriendsBean> datas;
	private final Context mContext;
	private final OnClickListener listener;

	public ManageFriendsAdapter(Context mContext, ArrayList<ManageFriendsBean> arrayList, OnClickListener listener) {
		datas = arrayList;
		this.mContext = mContext;
		this.listener = listener;
	}

	public void updateList(ArrayList<ManageFriendsBean> arrayList) {
		this.datas = arrayList;
		notifyDataSetChanged();
	}

	@Override
	public int getCount() {
		return datas.size();
	}

	@Override
	public Object getItem(int position) {
		if (position > 0) {
			return datas.get(position - 1);
		} else {
			return 0;
		}
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder = null;
		if (convertView == null) {
			convertView = View.inflate(mContext, R.layout.item_friend, null);
			holder = new ViewHolder();
			holder.inviteBtn = (TextView) convertView.findViewById(R.id.friends_btn_invitation);
			holder.avatar = (CircularImage) convertView.findViewById(R.id.friends_icon);
			holder.name = (TextView) convertView.findViewById(R.id.friends_name);
			holder.catalog = (TextView) convertView.findViewById(R.id.friends_catalog);
			holder.ivChecked = (ImageView) convertView.findViewById(R.id.friends_checked);
			holder.ivSex = (ImageView) convertView.findViewById(R.id.friends_sex_icn);
			holder.mutualCount = (TextView) convertView.findViewById(R.id.friends_mutual_count);
			holder.hasRegistered = (ImageView) convertView.findViewById(R.id.friends_icn_my_friend);
			holder.divider = convertView.findViewById(R.id.friends_divider);
			holder.singleIcn = (ImageView) convertView.findViewById(R.id.friends_single_icn);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.name.setText(datas.get(position).getName());
		if (!Util.isBlankString(datas.get(position).getAvatar())) {
			holder.container = J_NetManager.getInstance().loadIMG(holder.container, datas.get(position).getAvatar(),
					holder.avatar, R.drawable.icon_avatar, R.drawable.icon_avatar);
		} else {
			holder.avatar.setImageResource(R.drawable.icon_avatar);
		}
		if (datas.get(position).isChecked()) {
			holder.ivChecked.setVisibility(View.VISIBLE);
		} else {
			holder.ivChecked.setVisibility(View.GONE);
		}
		if (datas.get(position).isHasRegistered()) {
			holder.hasRegistered.setVisibility(View.VISIBLE);
			holder.inviteBtn.setVisibility(View.GONE);
		} else {
			holder.hasRegistered.setVisibility(View.GONE);
			holder.inviteBtn.setVisibility(View.VISIBLE);
		}
		// 根据position获取分类的首字母的Char ascii值
		int section = getSectionForPosition(position);
		// 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
		if (position == getPositionForSection(section)) {
			holder.catalog.setVisibility(View.VISIBLE);
			holder.catalog.setText(datas.get(position).getSortLetter());
			holder.divider.setVisibility(View.GONE);
		} else {
			holder.catalog.setVisibility(View.GONE);
			holder.divider.setVisibility(View.VISIBLE);
		}

		if (datas.get(position).getSex() == 1) {
			holder.ivSex.setVisibility(View.VISIBLE);
			holder.ivSex.setImageResource(R.drawable.icn_man);
		} else if (datas.get(position).getSex() == 0) {
			holder.ivSex.setVisibility(View.VISIBLE);
			holder.ivSex.setImageResource(R.drawable.icn_woman);
		} else {// 未注册的用户不知道性别
			holder.ivSex.setVisibility(View.GONE);
		}
		if (datas.get(position).getMutualFriendsCount() >= 0) {
			String text = datas.get(position).getMutualFriendsCount() + "个共同好友";
			holder.mutualCount.setText(text);
		} else {
			holder.mutualCount.setText("还未加入友寻");
		}
		if (datas.get(position).getMarriage() == 1) {
			holder.singleIcn.setVisibility(View.VISIBLE);
		} else {
			holder.singleIcn.setVisibility(View.GONE);
		}
		holder.inviteBtn.setTag(datas.get(position));
		holder.inviteBtn.setOnClickListener(listener);
		holder.avatar.setTag(datas.get(position).getUid());
		holder.avatar.setOnClickListener(listener);
		return convertView;
	}

	private class ViewHolder {
		private TextView name;// 昵称
		private CircularImage avatar;// 头像
		private TextView inviteBtn;// 邀请按钮
		private TextView catalog;// 索引
		private ImageView ivChecked;// 选中按钮
		private ImageView ivSex;// 性别
		private TextView mutualCount;// 共同好友数量
		private ImageView hasRegistered;// 已经注册
		private View divider;// 分割线
		private ImageView singleIcn;// 单身状态
		private ImageContainer container;
	}

	/**
	 * 根据ListView的当前位置获取分类的首字母的Char ascii值
	 */
	public int getSectionForPosition(int position) {
		return datas.get(position).getSortLetter().charAt(0);
	}

	/**
	 * 根据分类的首字母的Char ascii值获取其第一次出现该首字母的位置
	 */
	public int getPositionForSection(int section) {
		for (int i = 0; i < getCount(); i++) {
			String sortStr = datas.get(i).getSortLetter();
			char firstChar = sortStr.toUpperCase().charAt(0);
			if (firstChar == section) {
				return i;
			}
		}

		return -1;
	}
}
