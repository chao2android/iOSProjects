package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.iyouxun.R;

public class GroupPrivilegeAdapter extends BaseAdapter {
	private final ArrayList<String> datas;
	private final Context context;
	private int selectedPosition = -1;

	public GroupPrivilegeAdapter(Context mContext, ArrayList<String> datas) {
		context = mContext;
		this.datas = datas;
	}

	public void setSelectedPosition(int position) {
		selectedPosition = position;
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
			convertView = View.inflate(context, R.layout.item_group_privilege, null);
			holder.text = (TextView) convertView.findViewById(R.id.edit_group_privilege_text);
			holder.check = (ImageView) convertView.findViewById(R.id.edit_group_privilege_checked);
			holder.divider = convertView.findViewById(R.id.edit_group_privilege_divider);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.text.setText(datas.get(position));
		if (position == 0) {
			holder.divider.setVisibility(View.GONE);
			holder.text.setTextColor(context.getResources().getColor(R.color.text_normal_gray));
		} else {
			holder.divider.setVisibility(View.VISIBLE);
			holder.text.setTextColor(context.getResources().getColor(R.color.text_normal_black));
		}
		if (selectedPosition == position) {
			holder.check.setVisibility(View.VISIBLE);
		} else {
			holder.check.setVisibility(View.INVISIBLE);
		}
		return convertView;
	}

	private class ViewHolder {
		private TextView text;
		private ImageView check;
		private View divider;
	}
}
