package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.beans.ManageFriendsBean;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.ui.views.CircularImage;

public class EditGroupAdapter extends BaseAdapter {
	private final ArrayList<ManageFriendsBean> datas;
	private final Context mContext;
	private boolean showDel;

	public EditGroupAdapter(Context mContext, ArrayList<ManageFriendsBean> arrayList) {
		this.mContext = mContext;
		datas = arrayList;
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
			convertView = View.inflate(mContext, R.layout.item_edit_group, null);
			holder = new ViewHolder();
			holder.avatar = (CircularImage) convertView.findViewById(R.id.edit_group_avatar);
			holder.nickName = (TextView) convertView.findViewById(R.id.edit_group_nick);
			holder.del = (ImageView) convertView.findViewById(R.id.edit_group_del);
			holder.edit = (CircularImage) convertView.findViewById(R.id.edit_group_edit);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		String name = datas.get(position).getName();
		holder.nickName.setText(name);
		if (datas.get(position).getDataType() == 1) {
			holder.del.setVisibility(View.GONE);
			holder.edit.setImageResource(R.drawable.icn_edit_add_friends);
			holder.avatar.setVisibility(View.GONE);
			holder.edit.setVisibility(View.VISIBLE);
		} else if (datas.get(position).getDataType() == 2) {
			holder.del.setVisibility(View.GONE);
			holder.edit.setImageResource(R.drawable.icn_edit_del_friends);
			holder.avatar.setVisibility(View.GONE);
			holder.edit.setVisibility(View.VISIBLE);
		} else {
			if (showDel) {
				holder.del.setVisibility(View.VISIBLE);
			} else {
				holder.del.setVisibility(View.GONE);
			}
			holder.avatar.setVisibility(View.VISIBLE);
			holder.edit.setVisibility(View.GONE);
			J_NetManager.getInstance().loadIMG(null, datas.get(position).getAvatar(), holder.avatar, 0, 0);

		}
		return convertView;
	}

	private class ViewHolder {
		private CircularImage avatar;
		private TextView nickName;
		private ImageView del;
		private CircularImage edit;
	}

	public boolean isShowDel() {
		return showDel;
	}

	public void setShowDel(boolean showDel) {
		this.showDel = showDel;
	}

}
