package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.beans.OpenPlatformBeans;
import com.iyouxun.j_libs.managers.J_NetManager;

public class SinaWeiboFriendListAdapter extends BaseAdapter {
	private final ArrayList<OpenPlatformBeans> datas;
	private final Context mContext;
	private final OnClickListener listener;

	public SinaWeiboFriendListAdapter(Context mContext, ArrayList<OpenPlatformBeans> arrayList, OnClickListener listener) {
		this.mContext = mContext;
		datas = arrayList;
		this.listener = listener;
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
			convertView = View.inflate(mContext, R.layout.item_invitation_weibo_friends, null);
			holder = new ViewHolder();
			holder.btn = (TextView) convertView.findViewById(R.id.sina_weibo_btn_invitation);
			holder.icon = (ImageView) convertView.findViewById(R.id.sina_weibo_avatar);
			holder.name = (TextView) convertView.findViewById(R.id.sina_weibo_nick);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		J_NetManager.getInstance().loadIMG(null, datas.get(position).getUserIcon(), holder.icon, 0, 0);
		holder.name.setText(datas.get(position).getUserNick());
		holder.btn.setTag(datas.get(position).getUserNick());
		holder.btn.setOnClickListener(listener);
		return convertView;
	}

	private class ViewHolder {
		private TextView name;
		private ImageView icon;
		private TextView btn;
	}
}
