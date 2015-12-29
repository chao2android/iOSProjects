package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.beans.MarriageInfoBean;

/**
 * @ClassName: EmotionalListAdapter
 * @Description: 情感状态
 * @author donglizhi
 * @date 2015年3月5日 下午2:33:47
 * 
 */
public class EmotionalListAdapter extends BaseAdapter {
	private final ArrayList<MarriageInfoBean> datas;
	private final Context context;

	public EmotionalListAdapter(Context context, ArrayList<MarriageInfoBean> datas) {
		this.datas = datas;
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
			convertView = View.inflate(context, R.layout.emotional_list_item, null);
			holder.emotionalCheck = (ImageView) convertView.findViewById(R.id.emotional_item_check);
			holder.emotionalText = (TextView) convertView.findViewById(R.id.emotional_item_text);
			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}
		MarriageInfoBean bean = datas.get(position);
		holder.emotionalText.setText(bean.name);
		if (bean.status == 1) {
			holder.emotionalCheck.setVisibility(View.VISIBLE);
		} else {
			holder.emotionalCheck.setVisibility(View.INVISIBLE);
		}
		return convertView;
	}

	private class ViewHolder {
		private ImageView emotionalCheck;
		private TextView emotionalText;
	}
}
