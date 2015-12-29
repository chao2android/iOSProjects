package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.beans.FilterIndirectBeans;

/**
 * @ClassName: IndirectFilterAdapter
 * @Description: 二度好友筛选数据适配器
 * @author donglizhi
 * @date 2015年3月12日 上午10:39:30
 * 
 */
public class IndirectFilterAdapter extends BaseAdapter {
	private final ArrayList<FilterIndirectBeans> datas;
	private final Context context;

	public IndirectFilterAdapter(Context context, ArrayList<FilterIndirectBeans> signArray) {
		this.datas = signArray;
		this.context = context;
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
			convertView = View.inflate(context, R.layout.filter_indirect_item, null);
			holder.textView = (TextView) convertView.findViewById(R.id.indirect_item_text);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		holder.textView.setText(datas.get(position).getText());
		if (datas.get(position).isSelected()) {
			holder.textView.setTextColor(context.getResources().getColor(R.color.text_normal_white));
			holder.textView.setBackgroundResource(R.drawable.bg_filter_conditions_pressed);
		} else {
			holder.textView.setTextColor(context.getResources().getColor(R.color.text_normal_blue));
			holder.textView.setBackgroundResource(R.drawable.bg_filter_conditions_normal);
		}
		return convertView;
	}

	private class ViewHolder {
		private TextView textView;
	}
}
