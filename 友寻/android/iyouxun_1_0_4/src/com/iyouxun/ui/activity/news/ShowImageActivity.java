package com.iyouxun.ui.activity.news;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import android.animation.AnimatorSet;
import android.animation.ObjectAnimator;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.BitmapFactory.Options;
import android.graphics.Point;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.GridView;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.j_libs.managers.J_FileManager;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.ui.views.MyImageView;
import com.iyouxun.ui.views.MyImageView.OnMeasureListener;
import com.iyouxun.utils.ImageUtils;
import com.iyouxun.utils.NativeImageLoader;
import com.iyouxun.utils.NativeImageLoader.NativeImageCallBack;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.UploadPhotoDataAccess;
import com.iyouxun.utils.Util;

/**
 * 显示某一相册中的图片列表
 * 
 * @author likai
 * @date 2015-4-24 下午2:43:18
 * 
 */
public class ShowImageActivity extends CommTitleActivity {
	public static final String SHOW_IMAGE_RESULT_DATA = "show_image_result_data";
	private GridView mGridView;
	private List<String> list;
	private ChildAdapter adapter;
	private int select_length = 0;// 选择图片的最多数量
	private Button btnSubmit;// 确认按钮
	private LinearLayout llThumbnail;// 选中的图片
	private final Point mPoint = new Point(0, 0);// 用来封装ImageView的宽和高的对象
	private final HashMap<String, Boolean> mSelectMap = new HashMap<String, Boolean>();// 用来存储图片的选中情况
	private final ArrayList<String> select_path = new ArrayList<String>();// 选中图片的路径
	private final ArrayList<CheckBox> checkBoxs = new ArrayList<CheckBox>();

	/**
	 * 
	 * @param titleCenter
	 * @param titleLeftButton
	 * @param titleRightButton
	 */
	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		titleCenter.setVisibility(View.GONE);

		titleLeftButton.setText("添加照片");
		titleLeftButton.setOnClickListener(listener);
		titleLeftButton.setVisibility(View.VISIBLE);

		titleRightButton.setText("取消");
		titleRightButton.setOnClickListener(listener);
		titleRightButton.setVisibility(View.VISIBLE);
	}

	/**
	 * 
	 * @return
	 */
	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.show_image_activity, null);
	}

	/**
	 *  
	 */
	@Override
	protected void initViews() {
		// 初始化页面
		mContext = ShowImageActivity.this;
		mGridView = (GridView) findViewById(R.id.child_grid);
		btnSubmit = (Button) findViewById(R.id.show_image_btn_submit);
		llThumbnail = (LinearLayout) findViewById(R.id.show_image_ll_thumbnail);
		// 初始化数据
		list = getIntent().getStringArrayListExtra("data");
		select_length = getIntent().getExtras().getInt("length");
		adapter = new ChildAdapter();
		mGridView.setAdapter(adapter);
		showThumbnail();
		// 绑定监听时间
		btnSubmit.setOnClickListener(listener);
	}

	/**
	 * 显示选中的图片
	 */
	private void showThumbnail() {
		llThumbnail.removeAllViews();
		for (int i = 0; i < select_length; i++) {
			View view = LayoutInflater.from(mContext).inflate(R.layout.image_scan_item, null);
			final ImageView imageView = (ImageView) view.findViewById(R.id.image_scan_item_iv);
			if (select_path.size() > 0 && i < select_path.size()) {
				// 利用NativeImageLoader类加载本地图片
				Bitmap bitmap = NativeImageLoader.getInstance().loadNativeImage(select_path.get(i), mPoint,
						new NativeImageCallBack() {

							@Override
							public void onImageLoader(Bitmap bitmap, String path) {
								ImageView mImageView = (ImageView) mGridView.findViewWithTag(path);
								if (bitmap != null && mImageView != null) {
									imageView.setImageBitmap(bitmap);
								}
							}
						});

				if (bitmap != null) {
					imageView.setImageBitmap(bitmap);
				} else {
					imageView.setImageResource(R.drawable.pic_default_square);
				}
				final int index = i;
				imageView.setOnClickListener(new OnClickListener() {

					@Override
					public void onClick(View arg0) {
						checkBoxs.get(index).setChecked(false);
					}
				});
			}
			btnSubmit.setText("确认\n" + select_path.size() + "/" + select_length);
			llThumbnail.addView(view);
		}
		// adapter.notifyDataSetChanged();
	}

	public class ChildAdapter extends BaseAdapter {
		protected LayoutInflater mInflater;

		public ChildAdapter() {
			mInflater = LayoutInflater.from(mContext);
		}

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

		@Override
		public View getView(final int position, View convertView, ViewGroup parent) {
			final ViewHolder viewHolder;
			final String path = list.get(position);

			if (convertView == null) {
				convertView = mInflater.inflate(R.layout.grid_child_item, null);
				viewHolder = new ViewHolder();
				viewHolder.mImageView = (MyImageView) convertView.findViewById(R.id.child_image);
				viewHolder.mCheckBox = (CheckBox) convertView.findViewById(R.id.child_checkbox);
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
			viewHolder.mImageView.setTag(path);
			viewHolder.mCheckBox.setOnCheckedChangeListener(new OnCheckedChangeListener() {

				@Override
				public void onCheckedChanged(CompoundButton buttonView, boolean isChecked) {

				}
			});
			viewHolder.mCheckBox.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View v) {
					if (select_path.size() < select_length || select_path.indexOf(path) != -1) {
						boolean isChecked = viewHolder.mCheckBox.isChecked();
						// 如果是未选中的CheckBox,则添加动画
						if (!mSelectMap.containsKey(position) || !mSelectMap.get(position)) {
							addAnimation(viewHolder.mCheckBox);
						}
						mSelectMap.put(path, isChecked);
						if (isChecked) {
							if (select_path.indexOf(path) == -1) {
								Log.i("likai-test", "path-select:" + path);
								select_path.add(path);
								checkBoxs.add(viewHolder.mCheckBox);
							}
						} else {
							if (select_path.indexOf(path) != -1) {
								select_path.remove(select_path.indexOf(path));
								checkBoxs.remove(viewHolder.mCheckBox);
							}
						}
						showThumbnail();
					} else {
						if (viewHolder.mCheckBox.isChecked()) {
							viewHolder.mCheckBox.setChecked(false);
						}
						ToastUtil.showToast(mContext, "最多可以选择" + select_length + "张");
					}
				}
			});
			final BitmapFactory.Options bmpFactoryOptions = new BitmapFactory.Options();
			bmpFactoryOptions.inJustDecodeBounds = true;
			BitmapFactory.decodeFile(path, bmpFactoryOptions);
			if (select_path.size() < select_length) {
				if (bmpFactoryOptions.outHeight <= 280 && bmpFactoryOptions.outWidth <= 280) {
					viewHolder.mCheckBox.setClickable(false);
				} else {
					viewHolder.mCheckBox.setClickable(true);
				}
			} else {
				if (viewHolder.mCheckBox.isChecked()) {
					viewHolder.mCheckBox.setClickable(true);
				} else {
					viewHolder.mCheckBox.setClickable(false);
				}
			}
			viewHolder.mImageView.setOnClickListener(new OnClickListener() {

				@Override
				public void onClick(View arg0) {
					if (select_length == select_path.size()) {
						ToastUtil.showToast(mContext, "最多可以选择" + select_length + "张");
					} else if (bmpFactoryOptions.outHeight <= 280 && bmpFactoryOptions.outWidth <= 280) {
						ToastUtil.showToast(mContext, "图片太小，请重新选择图片");
					}
				}
			});
			viewHolder.mCheckBox.setChecked(mSelectMap.containsKey(path) ? mSelectMap.get(path) : false);
			// 利用NativeImageLoader类加载本地图片
			Bitmap bitmap = NativeImageLoader.getInstance().loadNativeImage(path, mPoint, new NativeImageCallBack() {

				@Override
				public void onImageLoader(Bitmap bitmap, String path) {
					ImageView mImageView = (ImageView) mGridView.findViewWithTag(path);
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

		/**
		 * 给CheckBox加点击动画，利用开源库nineoldandroids设置动画
		 * 
		 * @param view
		 */
		private void addAnimation(View view) {
			float[] vaules = new float[] { 0.5f, 0.6f, 0.7f, 0.8f, 0.9f, 1.0f, 1.1f, 1.2f, 1.3f, 1.25f, 1.2f, 1.15f, 1.1f, 1.0f };
			AnimatorSet set = new AnimatorSet();
			set.playTogether(ObjectAnimator.ofFloat(view, "scaleX", vaules), ObjectAnimator.ofFloat(view, "scaleY", vaules));
			set.setDuration(150);
			set.start();
		}

		/**
		 * 获取选中的Item的position
		 * 
		 * @return
		 */
		public List<String> getSelectItems() {
			List<String> list = new ArrayList<String>();
			for (Iterator<Map.Entry<String, Boolean>> it = mSelectMap.entrySet().iterator(); it.hasNext();) {
				Map.Entry<String, Boolean> entry = it.next();
				if (entry.getValue()) {
					list.add(entry.getKey());
				}
			}
			adapter.notifyDataSetChanged();
			return list;
		}

		public class ViewHolder {
			public MyImageView mImageView;
			public CheckBox mCheckBox;
		}

	}

	Handler mHandler = new Handler() {
		@Override
		public void dispatchMessage(Message msg) {
			switch (msg.what) {
			case 1:
				Intent resultIntent = new Intent();
				resultIntent.putStringArrayListExtra(SHOW_IMAGE_RESULT_DATA, select_path);
				setResult(ImageScanActivity.RESULT_CODE_SHOW_IAMGE, resultIntent);
				finish();
				break;
			default:
				break;
			}
		}
	};

	/**
	 * @Title: saveCache
	 * @Description: 压缩处理选中的图片
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void saveCache() {
		for (int i = 0; i < select_path.size(); i++) {
			File file_photo = new File(select_path.get(i));
			try {
				long fileSize = Util.getFileSize(file_photo);
				Options bitmapFactoryOptions = new BitmapFactory.Options();
				bitmapFactoryOptions.inJustDecodeBounds = true;
				BitmapFactory.decodeFile(select_path.get(i), bitmapFactoryOptions);
				// 获取图片的实际尺寸，并且算出实际大小和要显示的大小的比例
				int heightRatio = (int) Math.ceil(bitmapFactoryOptions.outHeight / (float) GLOBAL_SCREEN_HEIGHT);
				int widthRatio = (int) Math.ceil(bitmapFactoryOptions.outWidth / (float) GLOBAL_SCREEN_WIDTH);
				int iss = ImageUtils.getSampleSize(fileSize);
				if (heightRatio > 1 && widthRatio > 1) {
					if (heightRatio > widthRatio) {
						iss = heightRatio;
					} else {
						iss = widthRatio;
					}
				}
				bitmapFactoryOptions.inSampleSize = iss;// 缩放值
				bitmapFactoryOptions.inJustDecodeBounds = false;
				Bitmap bitmap = BitmapFactory.decodeFile(select_path.get(i), bitmapFactoryOptions);
				// 检查图片旋转状态
				int degrees = UploadPhotoDataAccess.readPictureDegree(file_photo.getAbsolutePath());
				if (degrees != 0) {
					bitmap = UploadPhotoDataAccess.rotateBitmap(bitmap, degrees);
				}
				// 保存到缓存目录一份
				String imgName = System.currentTimeMillis() + "";
				J_FileManager.getInstance().getFileStore().storeBitmap(bitmap, imgName);
				String path = J_FileManager.getInstance().getFileStore().getFileSdcardAndRamPath(imgName);
				if (path != null) {
					select_path.remove(i);
					select_path.add(i, path);
				}
				bitmap.recycle();
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	private final J_OnViewClickListener listener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:
				// 选择照片
				finish();
				break;
			case R.id.titleRightButton:
				// 取消
				finish();
				break;
			case R.id.show_image_btn_submit:
				// 确认按钮
				if (select_path.size() > 0) {
					showLoading("照片压缩中，请稍候…");
					new Thread(new Runnable() {
						@Override
						public void run() {
							saveCache();
							mHandler.sendEmptyMessage(1);
						}
					}).start();
				}
				break;
			default:
				break;
			}
		}
	};
}
