package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.data.beans.SharePlatformInfoBean;

/**
 * 分享弹框中，平台信息列表
 * 
 * @ClassName: SharePopGridViewAdapter
 * @author likai
 * @date 2015-3-17 下午3:20:10
 * 
 */
public class SharePopGridViewAdapter extends BaseAdapter {
	private final Context mContext;
	private ArrayList<SharePlatformInfoBean> datas = new ArrayList<SharePlatformInfoBean>();

	public SharePopGridViewAdapter(Context mContext, ArrayList<SharePlatformInfoBean> datas) {
		this.mContext = mContext;
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
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_share_pop_gridview_layout, null);
			vh.item_share_pop_button = (Button) convertView.findViewById(R.id.item_share_pop_button);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		SharePlatformInfoBean data = datas.get(position);

		// 平台图标icon
		vh.item_share_pop_button.setCompoundDrawablesWithIntrinsicBounds(0, data.platformIcon, 0, 0);
		vh.item_share_pop_button.setText(data.name);

		return convertView;
	}

	private class ViewHolder {
		public Button item_share_pop_button;
	}
}
