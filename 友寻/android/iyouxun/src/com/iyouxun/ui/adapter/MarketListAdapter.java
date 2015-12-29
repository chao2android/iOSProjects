/**
 * 
 * @Package com.iyouxun.ui.adapter
 * @author likai
 * @date 2015-4-23 下午6:52:44
 * @version V1.0
 */
package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.graphics.drawable.Drawable;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.data.beans.MarketInfoBean;
import com.iyouxun.utils.ApplicationUtils;

/**
 * android市场列表
 * 
 * @author likai
 * @date 2015-4-23 下午6:52:44
 * 
 */
public class MarketListAdapter extends BaseAdapter {
	private final Context mContext;
	private ArrayList<MarketInfoBean> datas = new ArrayList<MarketInfoBean>();

	public MarketListAdapter(Context mContext, ArrayList<MarketInfoBean> datas) {
		this.mContext = mContext;
		this.datas = datas;
	}

	@Override
	public int getCount() {
		return datas.size();
	}

	@Override
	public Object getItem(int arg0) {
		return datas.get(arg0);
	}

	@Override
	public long getItemId(int arg0) {
		return arg0;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder vh = new ViewHolder();
		if (convertView == null) {
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_market_list_layout, null);

			vh.marketIcon = (ImageView) convertView.findViewById(R.id.marketIcon);
			vh.marketName = (TextView) convertView.findViewById(R.id.marketName);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		MarketInfoBean bean = datas.get(position);

		// 设置图标
		Drawable db = ApplicationUtils.getProgramIconByPackageName(mContext, bean.packageName);
		vh.marketIcon.setImageDrawable(db);

		// 设置名称
		vh.marketName.setText(bean.name);

		return convertView;
	}

	private class ViewHolder {
		public ImageView marketIcon;
		public TextView marketName;
	}

}
