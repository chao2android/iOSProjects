package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.beans.FindFriendsBean;
import com.iyouxun.utils.SharedPreUtil;

public class FriendListAdapter extends BaseAdapter {
	private final ArrayList<FindFriendsBean> datas;
	private final Context context;

	public FriendListAdapter(Context mContext, ArrayList<FindFriendsBean> array) {
		datas = array;
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
		ViewHolder holder = null;
		if (convertView == null) {
			holder = new ViewHolder();
			convertView = View.inflate(context, R.layout.find_friend_list_item, null);
			holder.textView = (TextView) convertView.findViewById(R.id.find_friend_text);
			holder.friendsCount = (TextView) convertView.findViewById(R.id.find_friend_count);
			holder.icon = (ImageView) convertView.findViewById(R.id.find_friend_img1);
			holder.dividerBottom1 = (TextView) convertView.findViewById(R.id.find_friend_divider_bottom1);
			holder.dividerBottom2 = (TextView) convertView.findViewById(R.id.find_friend_divider_bottom2);
			holder.dividerTop = (TextView) convertView.findViewById(R.id.find_friend_divider_top);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		if (position == 0) {// 第一条数据显示头部分割线
			holder.dividerTop.setVisibility(View.VISIBLE);
		} else {
			holder.dividerTop.setVisibility(View.GONE);
		}
		if (position == datas.size() - 1) {// 最后一条数据显示底部分割线
			holder.dividerBottom2.setVisibility(View.VISIBLE);
			holder.dividerBottom1.setVisibility(View.GONE);
		} else {
			holder.dividerBottom2.setVisibility(View.GONE);
			holder.dividerBottom1.setVisibility(View.VISIBLE);
		}
		String text = context.getResources().getString(datas.get(position).getTextId());
		if (datas.size() == 3) {
			if (position == 1) {// 二度好友
				int num = SharedPreUtil.getFriendsNum(2);
				if (num > 0) {
					text = text + " ( " + num + " )";
				}
			} else if (position == 2) {// 一度好友
				int num = SharedPreUtil.getFriendsNum(1);
				if (num > 0) {
					text = text + " ( " + num + " )";
				}
			}
		}
		holder.textView.setText(text);
		holder.icon.setImageResource(datas.get(position).getImageId());
		return convertView;
	}

	private class ViewHolder {
		private TextView textView;// 内容
		private TextView friendsCount;// 好友数量
		private ImageView icon;// 图标
		private TextView dividerTop;
		private TextView dividerBottom1;
		private TextView dividerBottom2;
	}
}
