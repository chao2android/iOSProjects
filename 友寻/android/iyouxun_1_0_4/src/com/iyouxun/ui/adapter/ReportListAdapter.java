package com.iyouxun.ui.adapter;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.TextView;

import com.iyouxun.R;

/**
 * 举报信息列表
 * 
 * @ClassName: ReportListAdapter
 * @author likai
 * @date 2015-3-10 下午4:31:54
 * 
 */
public class ReportListAdapter extends BaseAdapter {
	private String[] reportData = {};
	private final Context mContext;

	public ReportListAdapter(Context mContext) {
		this.mContext = mContext;
	}

	public void setData(String[] reportData) {
		this.reportData = reportData;
	}

	@Override
	public int getCount() {
		return reportData.length;
	}

	@Override
	public Object getItem(int position) {
		return reportData[position];
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		ViewHolder holder = new ViewHolder();
		if (convertView == null) {
			convertView = View.inflate(mContext, R.layout.item_report_list_info, null);
			holder.itemReportTv = (TextView) convertView.findViewById(R.id.itemReportTv);

			convertView.setTag(holder);
		} else {
			holder = (ViewHolder) convertView.getTag();
		}

		holder.itemReportTv.setText(reportData[position]);

		// 最后 一个选项的背景需要修改下
		if (reportData.length >= 1 && position == reportData.length - 1) {
			holder.itemReportTv.setBackgroundResource(R.drawable.button_dialog_bottom_circular);
		} else {
			holder.itemReportTv.setBackgroundResource(R.drawable.button_dialog_no_circular);
		}

		return convertView;
	}

	private class ViewHolder {
		public TextView itemReportTv;
	}
}
