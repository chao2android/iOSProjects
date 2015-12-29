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
import com.iyouxun.data.beans.SortInfoBean;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.ui.views.CircularImage;

/**
 * 分享给应用内好友的好友列表
 * 
 * @author likai
 * @date 2015-5-18 上午10:23:13
 * 
 */
public class ShareUserListAdapter extends BaseAdapter {
	private final Context mContext;
	private ArrayList<SortInfoBean> datas = new ArrayList<SortInfoBean>();

	public ShareUserListAdapter(Context mContext) {
		this.mContext = mContext;
	}

	public void setData(ArrayList<SortInfoBean> datas) {
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
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_same_friend_layout, null);
			vh.sameFriendUserAvatar = (CircularImage) convertView.findViewById(R.id.sameFriendUserAvatar);
			vh.sameFriendUserNick = (TextView) convertView.findViewById(R.id.sameFriendUserNick);
			vh.sameFriendDimen = (ImageView) convertView.findViewById(R.id.sameFriendDimen);
			vh.sameFriendUserSameNum = (TextView) convertView.findViewById(R.id.sameFriendUserSameNum);
			vh.sortCatalog = (TextView) convertView.findViewById(R.id.sortCatalog);
			vh.sameFriendMarriage = (ImageView) convertView.findViewById(R.id.sameFriendMarriage);
			vh.item_line = convertView.findViewById(R.id.item_line);
			vh.friends_checked = (ImageView) convertView.findViewById(R.id.friends_checked);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		SortInfoBean user = datas.get(position);

		// 图标选中状态
		if (datas.get(position).isChecked) {
			vh.friends_checked.setVisibility(View.VISIBLE);
		} else {
			vh.friends_checked.setVisibility(View.GONE);
		}

		// 根据position获取分类的首字母的Char ascii值
		int section = getSectionForPosition(position);
		// 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
		if (position == getPositionForSection(section)) {
			vh.sortCatalog.setVisibility(View.VISIBLE);
			vh.sortCatalog.setText(user.sortLetter);
			vh.item_line.setVisibility(View.GONE);
		} else {
			vh.sortCatalog.setVisibility(View.GONE);
			vh.item_line.setVisibility(View.VISIBLE);
		}
		// 头像
		vh.container = J_NetManager.getInstance().loadIMG(vh.container, user.avatar, vh.sameFriendUserAvatar,
				R.drawable.icon_avatar, R.drawable.icon_avatar);
		// 昵称
		vh.sameFriendUserNick.setText(user.name);
		if (user.type == 1) {// 我的群组列表
			// 共同好友数量
			vh.sameFriendUserSameNum.setVisibility(View.GONE);
			// 性别
			vh.sameFriendUserNick.setCompoundDrawablesWithIntrinsicBounds(0, 0, 0, 0);
			// 好友维度
			vh.sameFriendDimen.setVisibility(View.GONE);
			// 情感状况
			vh.sameFriendMarriage.setVisibility(View.GONE);
		} else {// 我的好友列表
			// 共同好友数量
			vh.sameFriendUserSameNum.setVisibility(View.VISIBLE);
			vh.sameFriendUserSameNum.setText(user.sameFriendsNum + "个共同好友");
			// 性别
			if (user.sex == 0) {
				// 女
				vh.sameFriendUserNick.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.icon_famale_s, 0);
			} else {
				// 男
				vh.sameFriendUserNick.setCompoundDrawablesWithIntrinsicBounds(0, 0, R.drawable.icon_male_s, 0);
			}
			// 好友维度
			vh.sameFriendDimen.setVisibility(View.VISIBLE);
			if (user.friendDimen == 1) {
				vh.sameFriendDimen.setImageResource(R.drawable.icon_dimen_one);
			} else {
				vh.sameFriendDimen.setImageResource(R.drawable.icon_dimen_two);
			}
			// 情感状况
			if (user.marriage == 1) {
				// 单身
				vh.sameFriendMarriage.setVisibility(View.VISIBLE);
			} else {
				vh.sameFriendMarriage.setVisibility(View.GONE);
			}
		}

		return convertView;
	}

	private class ViewHolder {
		public ImageContainer container;

		public CircularImage sameFriendUserAvatar;// 头像
		public TextView sameFriendUserNick;// 昵称
		public ImageView sameFriendDimen;// 好友维度
		public TextView sameFriendUserSameNum;// 共同好友数量
		public ImageView sameFriendMarriage;// 单身状态
		public View item_line;

		public ImageView friends_checked;// 选择图标

		public TextView sortCatalog;// 序号字母
	}

	/**
	 * 根据ListView的当前位置获取分类的首字母的Char ascii值
	 */
	public int getSectionForPosition(int position) {
		if (datas.size() > 0 && datas.get(position).sortLetter.length() > 0) {
			return datas.get(position).sortLetter.charAt(0);
		} else {
			return 0;
		}
	}

	/**
	 * 根据分类的首字母的Char ascii值获取其第一次出现该首字母的位置
	 */
	public int getPositionForSection(int section) {
		for (int i = 0; i < getCount(); i++) {
			String sortStr = datas.get(i).sortLetter;
			if (sortStr.length() > 0) {
				char firstChar = sortStr.toUpperCase().charAt(0);
				if (firstChar == section) {
					return i;
				}
			}
		}

		return -1;
	}

}
