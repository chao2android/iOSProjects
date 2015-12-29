package com.iyouxun.ui.adapter;

import java.io.BufferedInputStream;
import java.io.FileInputStream;
import java.util.ArrayList;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.os.Handler;
import android.os.Message;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.ui.activity.center.ProfilePhotoViewActivity;
import com.iyouxun.utils.Util;

/**
 * 发布新动态前，选择的待上传的图片列表adapter
 * 
 * @ClassName: NewsUploadPhotoListAdapter
 * @author likai
 * @date 2015-3-6 下午8:10:44
 * 
 */
public class NewsUploadPhotoListAdapter extends BaseAdapter {
	private final Context mContext;
	private ArrayList<PhotoInfoBean> datas = new ArrayList<PhotoInfoBean>();
	private Handler mHandler;

	public NewsUploadPhotoListAdapter(Context mContext) {
		this.mContext = mContext;
	}

	public void setDatas(ArrayList<PhotoInfoBean> datas) {
		this.datas = datas;
	}

	public void setHandler(Handler mHandler) {
		this.mHandler = mHandler;
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
	public View getView(final int position, View convertView, ViewGroup parent) {
		ViewHolder vh = new ViewHolder();
		if (convertView == null) {
			convertView = LayoutInflater.from(J_Application.context).inflate(R.layout.item_news_upload_photo_layout, null);
			vh.newsUploadPicInfo = (ImageView) convertView.findViewById(R.id.newsUploadPicInfo);
			vh.newsDelPic = (ImageView) convertView.findViewById(R.id.newsDelPic);

			convertView.setTag(vh);
		} else {
			vh = (ViewHolder) convertView.getTag();
		}

		PhotoInfoBean photo = datas.get(position);

		// 图片处理
		vh.newsUploadPicInfo.setVisibility(View.GONE);
		if (!Util.isBlankString(photo.picPath)) {
			// 显示图片
			try {
				FileInputStream f = new FileInputStream(photo.picPath);
				BitmapFactory.Options options = new BitmapFactory.Options();
				options.inSampleSize = 8;
				BufferedInputStream bis = new BufferedInputStream(f);
				Bitmap bm = BitmapFactory.decodeStream(bis, null, options);
				vh.newsUploadPicInfo.setImageBitmap(bm);
				vh.newsUploadPicInfo.setVisibility(View.VISIBLE);
			} catch (Exception e) {
				e.printStackTrace();
			}
			vh.newsUploadPicInfo.setOnClickListener(new OnClickListener() {
				@Override
				public void onClick(View v) {
					ArrayList<PhotoInfoBean> tmp = new ArrayList<PhotoInfoBean>();
					for (int i = 0; i < datas.size(); i++) {
						if (!Util.isBlankString(datas.get(i).picPath)) {
							tmp.add(datas.get(i));
						}
					}
					Intent albumIntent = new Intent(mContext, ProfilePhotoViewActivity.class);
					albumIntent.putExtra("index", position);
					albumIntent.putExtra("photoInfo", tmp);
					albumIntent.putExtra("viewType", 1);
					mContext.startActivity(albumIntent);
				}
			});
		}
		// 删除图片
		vh.newsDelPic.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				Message msg = mHandler.obtainMessage();
				msg.what = 0x10000;
				msg.arg1 = position;
				mHandler.sendMessage(msg);
			}
		});

		return convertView;
	}

	private class ViewHolder {
		public ImageView newsUploadPicInfo;
		// 删除按钮
		public ImageView newsDelPic;
	}

}
