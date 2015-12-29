package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.data.beans.OpenPlatformBeans;
import com.android.volley.toolbox.ImageLoader.ImageContainer;

/**
 * 第三方帐号列表
 * 
 * @ClassName: SettingOpenPlatformAdapter
 * @author likai
 * @date 2015-3-11 下午8:24:42
 * 
 */
public class SettingOpenPlatformAdapter extends BaseAdapter {
	private ArrayList<OpenPlatformBeans> datas = new ArrayList<OpenPlatformBeans>();
	private final Context mContext;

	public SettingOpenPlatformAdapter(Context mContext, ArrayList<OpenPlatformBeans> datas) {
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
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_setting_open_platform_layout, null);
			vh.settingOpenPlatformIcon = (ImageView) convertView.findViewById(R.id.settingOpenPlatformIcon);
			vh.settingOpenPlatformStatus = (TextView) convertView.findViewById(R.id.settingOpenPlatformStatus);
			vh.settingOpenPlatformName = (TextView) convertView.findViewById(R.id.settingOpenPlatformName);
			vh.settingOpenPlatformDeliver = convertView.findViewById(R.id.settingOpenPlatformDeliver);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		OpenPlatformBeans bean = datas.get(position);

		// icon图标
		if (bean.getOpenType() == 1) {
			// 微信
			if (bean.getStatus() == 1) {
				vh.settingOpenPlatformIcon.setImageResource(R.drawable.icon_p_wechat);
			} else {
				vh.settingOpenPlatformIcon.setImageResource(R.drawable.icon_p_wechat_unbind);
			}
			// 平台名称
			vh.settingOpenPlatformName.setText("微信");
		} else if (bean.getOpenType() == 2) {
			// 新浪微博
			if (bean.getStatus() == 1) {
				vh.settingOpenPlatformIcon.setImageResource(R.drawable.icon_p_weibo);
			} else {
				vh.settingOpenPlatformIcon.setImageResource(R.drawable.icon_p_weibo_unbind);
			}
			// 平台名称
			vh.settingOpenPlatformName.setText("新浪微博");
		} else if (bean.getOpenType() == 3) {
			// QQ
			if (bean.getStatus() == 1) {
				vh.settingOpenPlatformIcon.setImageResource(R.drawable.icon_p_qq);
			} else {
				vh.settingOpenPlatformIcon.setImageResource(R.drawable.icon_p_qq_unbind);
			}
			// 平台名称
			vh.settingOpenPlatformName.setText("腾讯QQ");
		}
		// 状态
		if (bean.getStatus() == 1) {
			// 已绑定
			vh.settingOpenPlatformStatus.setText("已绑定");
		} else {
			// 未绑定
			vh.settingOpenPlatformStatus.setText("未绑定");
		}

		if (position == datas.size() - 1) {
			vh.settingOpenPlatformDeliver.setVisibility(View.GONE);
		} else {
			vh.settingOpenPlatformDeliver.setVisibility(View.VISIBLE);
		}

		return convertView;
	}

	private class ViewHolder {
		public ImageContainer container;

		public ImageView settingOpenPlatformIcon;
		public TextView settingOpenPlatformStatus;
		public TextView settingOpenPlatformName;

		public View settingOpenPlatformDeliver;
	}
}
