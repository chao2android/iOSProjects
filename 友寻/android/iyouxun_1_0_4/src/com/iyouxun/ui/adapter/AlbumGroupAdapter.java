package com.iyouxun.ui.adapter;

import java.util.List;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Point;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.data.beans.ImageBean;
import com.iyouxun.ui.views.MyImageView;
import com.iyouxun.ui.views.MyImageView.OnMeasureListener;
import com.iyouxun.utils.NativeImageLoader;
import com.iyouxun.utils.NativeImageLoader.NativeImageCallBack;

/**
 * 相册列表adapter
 * 
 * @author likai
 * @date 2015-4-24 下午2:44:03
 * 
 */
public class AlbumGroupAdapter extends BaseAdapter {
	private final List<ImageBean> list;
	private final Point mPoint = new Point(0, 0);// 用来封装ImageView的宽和高的对象
	private final ListView mListView;
	protected LayoutInflater mInflater;

	@Override
	public int getCount() {
		return list.size();
	}

	@Override
	public Object getItem(int position) {
		return list.get(position);
	}

	@Override
	public long getItemId(int position) {
		return position;
	}

	public AlbumGroupAdapter(Context context, List<ImageBean> list, ListView mGroupGridView) {
		this.list = list;
		this.mListView = mGroupGridView;
		mInflater = LayoutInflater.from(context);
	}

	@Override
	public View getView(int position, View convertView, ViewGroup parent) {
		final ViewHolder viewHolder;
		ImageBean mImageBean = list.get(position);
		String path = mImageBean.getTopImagePath();
		if (convertView == null) {
			viewHolder = new ViewHolder();
			convertView = mInflater.inflate(R.layout.grid_group_item, null);
			viewHolder.mImageView = (MyImageView) convertView.findViewById(R.id.group_image);
			viewHolder.mTextViewTitle = (TextView) convertView.findViewById(R.id.group_title);
			// 用来监听ImageView的宽和高
			viewHolder.mImageView.setOnMeasureListener(new OnMeasureListener() {

				@Override
				public void onMeasureSize(int width, int height) {
					mPoint.set(width, height);
				}
			});
			convertView.setTag(viewHolder);
		} else {
			viewHolder = (ViewHolder) convertView.getTag();
			viewHolder.mImageView.setImageResource(R.drawable.pic_default_square);
		}

		viewHolder.mTextViewTitle.setText(mImageBean.getFolderName() + " (" + mImageBean.getImageCounts() + ")");
		// 给ImageView设置路径Tag,这是异步加载图片的小技巧
		viewHolder.mImageView.setTag(path);

		// 利用NativeImageLoader类加载本地图片
		Bitmap bitmap = NativeImageLoader.getInstance().loadNativeImage(path, mPoint, new NativeImageCallBack() {
			@Override
			public void onImageLoader(Bitmap bitmap, String path) {
				ImageView mImageView = (ImageView) mListView.findViewWithTag(path);
				if (bitmap != null && mImageView != null) {
					mImageView.setImageBitmap(bitmap);
				}
			}
		});

		if (bitmap != null) {
			viewHolder.mImageView.setImageBitmap(bitmap);
		} else {
			viewHolder.mImageView.setImageResource(R.drawable.pic_default_square);
		}
		return convertView;
	}

	public static class ViewHolder {
		public MyImageView mImageView;
		public TextView mTextViewTitle;
	}

}
