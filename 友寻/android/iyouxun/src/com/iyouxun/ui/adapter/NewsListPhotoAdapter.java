package com.iyouxun.ui.adapter;

import java.util.ArrayList;

import android.content.Context;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;

import com.android.volley.toolbox.ImageLoader.ImageContainer;
import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.j_libs.managers.J_NetManager;

/**
 * 动态图片列表
 * 
 * @ClassName: NewsListPhotoAdapter
 * @author likai
 * @date 2015-3-6 上午10:49:16
 * 
 */
public class NewsListPhotoAdapter extends BaseAdapter {
	private final Context mContext;
	private ArrayList<PhotoInfoBean> datas = new ArrayList<PhotoInfoBean>();

	public NewsListPhotoAdapter(Context mContext) {
		this.mContext = mContext;
	}

	public void setData(ArrayList<PhotoInfoBean> datas) {
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
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_news_list_photo_layout, null);
			vh.newsPhotoListIv = (ImageView) convertView.findViewById(R.id.newsPhotoListIv);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		PhotoInfoBean photo = datas.get(position);

		// 加载图片
		vh.container = J_NetManager.getInstance().loadIMG(vh.container, photo.url_small, vh.newsPhotoListIv,
				R.drawable.pic_default_square, R.drawable.pic_default_square);

		return convertView;
	}

	private class ViewHolder {
		public ImageContainer container;

		public ImageView newsPhotoListIv;
	}
}
