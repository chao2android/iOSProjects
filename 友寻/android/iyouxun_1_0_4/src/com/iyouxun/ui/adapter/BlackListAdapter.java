package com.iyouxun.ui.adapter;

import java.util.ArrayList;

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
import com.iyouxun.utils.StringUtils;

/**
 * 黑名单列表
 * 
 * @ClassName: BlackListAdapter
 * @author likai
 * @date 2015-3-9 下午8:11:52
 * 
 */
public class BlackListAdapter extends BaseAdapter {
	private ArrayList<SortInfoBean> datas = new ArrayList<SortInfoBean>();

	public void setDatas(ArrayList<SortInfoBean> datas) {
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
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_black_list_layout, null);
			vh.blackUserAvatar = (CircularImage) convertView.findViewById(R.id.blackUserAvatar);
			vh.blackUserNick = (TextView) convertView.findViewById(R.id.blackUserNick);
			vh.blackDimen = (ImageView) convertView.findViewById(R.id.blackDimen);
			vh.blackUserSex = (ImageView) convertView.findViewById(R.id.blackUserSex);
			vh.blackUserSameNum = (TextView) convertView.findViewById(R.id.blackUserSameNum);
			vh.blackSortCatalog = (TextView) convertView.findViewById(R.id.blackSortCatalog);
			vh.item_black_line = convertView.findViewById(R.id.item_black_line);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		SortInfoBean user = datas.get(position);

		// 根据position获取分类的首字母的Char ascii值
		int section = getSectionForPosition(position);
		// 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
		if (position == getPositionForSection(section)) {
			vh.blackSortCatalog.setVisibility(View.VISIBLE);
			vh.blackSortCatalog.setText(user.sortLetter);
			vh.item_black_line.setVisibility(View.GONE);
		} else {
			vh.blackSortCatalog.setVisibility(View.GONE);
			vh.item_black_line.setVisibility(View.VISIBLE);
		}
		// 头像
		vh.container = J_NetManager.getInstance().loadIMG(vh.container, user.avatar, vh.blackUserAvatar, R.drawable.icon_avatar,
				R.drawable.icon_avatar);
		// 昵称
		vh.blackUserNick.setText(StringUtils.getLimitSubstringWithMore(user.name, 10));
		// 好友维度
		if (user.friendDimen == 1) {
			vh.blackDimen.setImageResource(R.drawable.icon_dimen_one);
		} else {
			vh.blackDimen.setImageResource(R.drawable.icon_dimen_two);
		}
		// 性别
		if (user.sex == 0) {
			// 女
			vh.blackUserSex.setImageResource(R.drawable.icon_famale_s);
		} else {
			// 男
			vh.blackUserSex.setImageResource(R.drawable.icon_male_s);
		}
		// 共同好友数量
		vh.blackUserSameNum.setText(user.sameFriendsNum + "个共同好友");

		return convertView;
	}

	private class ViewHolder {
		public ImageContainer container;

		public CircularImage blackUserAvatar;// 头像
		public TextView blackUserNick;// 昵称
		public ImageView blackDimen;// 好友维度
		public ImageView blackUserSex;// 性别
		public TextView blackUserSameNum;// 共同好友数量
		public View item_black_line;

		public TextView blackSortCatalog;// 序号字母
	}

	/**
	 * 根据ListView的当前位置获取分类的首字母的Char ascii值
	 */
	public int getSectionForPosition(int position) {
		return datas.get(position).sortLetter.charAt(0);
	}

	/**
	 * 根据分类的首字母的Char ascii值获取其第一次出现该首字母的位置
	 */
	public int getPositionForSection(int section) {
		for (int i = 0; i < getCount(); i++) {
			String sortStr = datas.get(i).sortLetter;
			char firstChar = sortStr.toUpperCase().charAt(0);
			if (firstChar == section) {
				return i;
			}
		}

		return -1;
	}
}
