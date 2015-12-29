package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.beans.ManageFriendsBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.net.request.UtilRequest;
import com.iyouxun.ui.activity.center.ProfileViewActivity;
import com.iyouxun.ui.views.CircularImage;
import com.iyouxun.utils.StringUtils;
import com.iyouxun.utils.Util;

public class GroupMembersAdapter extends BaseAdapter {
	private ArrayList<ManageFriendsBean> datas;
	private final Context mContext;

	public GroupMembersAdapter(Context mContext, ArrayList<ManageFriendsBean> arrayList) {
		datas = arrayList;
		this.mContext = mContext;
	}

	public void updateDatas(ArrayList<ManageFriendsBean> arrayList) {
		this.datas = arrayList;
		notifyDataSetChanged();
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
	public View getView(final int position, View convertView, ViewGroup parent) {
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
		holder.name.setText(StringUtils.getLimitSubstringWithMore(datas.get(position).getName(), 10));
		J_NetManager.getInstance().loadIMG(null, datas.get(position).getAvatar(), holder.avatar, R.drawable.bg_avatar, 0);

		if (datas.get(position).isChecked()) {
			holder.ivChecked.setVisibility(View.VISIBLE);
		} else {
			holder.ivChecked.setVisibility(View.GONE);
		}
		if (datas.get(position).isHasRegistered()) {
			holder.inviteBtn.setVisibility(View.GONE);
		} else {
			holder.inviteBtn.setVisibility(View.VISIBLE);
		}
		if (datas.get(position).getRelation() == 1) {// 一度好友
			holder.hasRegistered.setVisibility(View.VISIBLE);
			holder.hasRegistered.setImageResource(R.drawable.icn_my_friend);
		} else if (datas.get(position).getRelation() == 2) {// 二度好友
			holder.hasRegistered.setVisibility(View.VISIBLE);
			holder.hasRegistered.setImageResource(R.drawable.icon_dimen_two);
		} else {
			holder.hasRegistered.setVisibility(View.GONE);
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
		} else {
			holder.ivSex.setVisibility(View.GONE);
		}
		if (datas.get(position).getUid().equals(J_Cache.sLoginUser.uid + "")) {// 自己不显示共同好友
			holder.mutualCount.setVisibility(View.INVISIBLE);
			holder.hasRegistered.setVisibility(View.GONE);
		} else {
			holder.mutualCount.setVisibility(View.VISIBLE);
		}
		if (datas.get(position).getMutualFriendsCount() >= 0) {
			String text = datas.get(position).getMutualFriendsCount() + "个共同好友";
			holder.mutualCount.setText(text);
		}
		if (datas.get(position).getMarriage() == 1) {
			holder.singleIcn.setVisibility(View.VISIBLE);
		} else {
			holder.singleIcn.setVisibility(View.GONE);
		}
		holder.avatar.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				long uid = Util.getLong(datas.get(position).getUid());
				Intent intent = new Intent(mContext, ProfileViewActivity.class);
				intent.putExtra(UtilRequest.FORM_UID, uid);
				mContext.startActivity(intent);
			}
		});
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
