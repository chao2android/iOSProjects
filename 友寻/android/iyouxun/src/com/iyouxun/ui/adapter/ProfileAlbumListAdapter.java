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
import com.iyouxun.utils.Util;

/**
 * 相册图片列表
 * 
 * @ClassName: ProfileAlbumListAdapter
 * @author likai
 * @date 2015-3-11 下午2:07:08
 * 
 */
public class ProfileAlbumListAdapter extends BaseAdapter {
	private final Context mContext;
	private ArrayList<PhotoInfoBean> datas = new ArrayList<PhotoInfoBean>();

	public ProfileAlbumListAdapter(Context mContext, ArrayList<PhotoInfoBean> datas) {
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
			if (Util.getScreenDensityDpi(mContext) >= 320) {
				convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_profile_album_list, null);
			} else {
				convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_profile_album_list_small, null);
			}

			vh.newsPhotoListIv = (ImageView) convertView.findViewById(R.id.newsPhotoListIv);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		PhotoInfoBean photo = datas.get(position);

		// 显示图片
		vh.container = J_NetManager.getInstance().loadIMG(vh.container, photo.url_small, vh.newsPhotoListIv,
				R.drawable.pic_default_square, R.drawable.pic_default_square);

		return convertView;
	}

	private class ViewHolder {
		public ImageContainer container;

		public ImageView newsPhotoListIv;
	}
}
