package com.iyouxun.ui.adapter;

import java.util.List;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.SectionIndexer;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.beans.ManageFriendsBean;

public class SortAdapter extends BaseAdapter implements SectionIndexer {
	private List<ManageFriendsBean> list = null;
	private final Context mContext;

	public SortAdapter(Context mContext, List<ManageFriendsBean> list) {
		this.mContext = mContext;
		this.list = list;
	}

	/**
	 * 当ListView数据发生变化时,调用此方法来更新ListView
	 * 
	 * @param list
	 */
	public void updateListView(List<ManageFriendsBean> list) {
		this.list = list;
		notifyDataSetChanged();
	}

	@Override
	public int getCount() {
		return this.list.size();
	}

	@Override
	public Object getItem(int position) {
		return list.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(final int position, View view, ViewGroup arg2) {
		ViewHolder viewHolder = null;
		final ManageFriendsBean mContact = list.get(position);
		if (view == null) {
			viewHolder = new ViewHolder();
			view = LayoutInflater.from(mContext).inflate(R.layout.contact_item, null);
			viewHolder.tvTitle = (TextView) view.findViewById(R.id.contact_name);
			viewHolder.tvLetter = (TextView) view.findViewById(R.id.contact_catalog);
			viewHolder.ivCheck = (ImageView) view.findViewById(R.id.contact_check);
			viewHolder.divider = view.findViewById(R.id.contact_divider);
			view.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) view.getTag();
		}

		// 根据position获取分类的首字母的Char ascii值
		int section = getSectionForPosition(position);

		// 如果当前位置等于该分类首字母的Char的位置 ，则认为是第一次出现
		if (position == getPositionForSection(section)) {
			viewHolder.tvLetter.setVisibility(View.VISIBLE);
			viewHolder.tvLetter.setText(mContact.getSortLetter());
			viewHolder.divider.setVisibility(View.GONE);
		} else {
			viewHolder.tvLetter.setVisibility(View.GONE);
			viewHolder.divider.setVisibility(View.VISIBLE);
		}
		if (this.list.get(position).isChecked()) {
			viewHolder.ivCheck.setVisibility(View.VISIBLE);
		} else {
			viewHolder.ivCheck.setVisibility(View.INVISIBLE);
		}
		viewHolder.tvTitle.setText(this.list.get(position).getName());

		return view;

	}

	private class ViewHolder {
		TextView tvLetter;
		TextView tvTitle;
		ImageView ivCheck;
		View divider;
	}

	/**
	 * 根据ListView的当前位置获取分类的首字母的Char ascii值
	 */
	@Override
	public int getSectionForPosition(int position) {
		return list.get(position).getSortLetter().charAt(0);
	}

	/**
	 * 根据分类的首字母的Char ascii值获取其第一次出现该首字母的位置
	 */
	@Override
	public int getPositionForSection(int section) {
		for (int i = 0; i < getCount(); i++) {
			String sortStr = list.get(i).getSortLetter();
			char firstChar = sortStr.toUpperCase().charAt(0);
			if (firstChar == section) {
				return i;
			}
		}

		return -1;
	}

	/**
	 * 提取英文的首字母，非英文字母用#代替。
	 * 
	 * @param str
	 * @return
	 */
	private String getAlpha(String str) {
		String sortStr = str.trim().substring(0, 1).toUpperCase();
		// 正则表达式，判断首字母是否是英文字母
		if (sortStr.matches("[A-Z]")) {
			return sortStr;
		} else {
			return "#";
		}
	}

	@Override
	public Object[] getSections() {
		return null;
	}
}