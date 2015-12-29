package com.iyouxun.ui.activity.common;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.OutputStream;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;

import com.edmodo.cropper.CropImageView;
import com.iyouxun.R;
import com.iyouxun.j_libs.encrypt.MD5;
import com.iyouxun.j_libs.file.FileStore;
import com.iyouxun.j_libs.managers.J_FileManager;
import com.iyouxun.ui.activity.CommTitleActivity;
import com.iyouxun.utils.ImageUtils;
import com.iyouxun.utils.Util;

public class ClipPhoto extends CommTitleActivity implements OnClickListener {
	private Bitmap bm;
	private String path;

	private int minWidth;
	private int minHeight;
	private final int percent = 90;// 压缩比例

	// 是否为裁剪头像（裁剪头像指定为方形，其他则可以任意形状）
	private boolean isAvatar;

	// private String scaleType = "centerInside";

	public static final String CLIP_PHOTO_NAME = "clip_photo_temp";// 保存的裁剪后的文件名称
	public static final String ORIGINAL_PHOTO_NAME = "original_photo_temp";// 保存的原图名称

	private CropImageView iv;
	private ImageButton btnUse;
	private ImageButton btnBack;

	@Override
	protected void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton) {
		// 隐藏中间标题
		titleCenter.setVisibility(View.GONE);
	}

	@Override
	protected View setContentView() {
		return View.inflate(mContext, R.layout.activity_clip_photo, null);
	}

	@Override
	protected void initViews() {
		// 设置标题
		iv = (CropImageView) findViewById(R.id.iv);
		btnBack = (ImageButton) findViewById(R.id.btn_back);
		btnUse = (ImageButton) findViewById(R.id.btn_useit);
		btnBack.setOnClickListener(this);
		btnUse.setOnClickListener(this);

		Intent intent = getIntent();
		path = intent.getStringExtra("path");
		isAvatar = intent.getBooleanExtra("isAvatar", false);

		minHeight = minWidth = 200;
		// scaleType = intent.getStringExtra("scaleType");
		initView();
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		if (bm != null && !bm.isRecycled()) {
			bm.recycle();
		}
	}

	/**
	 * @param path
	 * @return
	 */
	protected BitmapFactory.Options readBmpOpts(String path) {
		BitmapFactory.Options options = new BitmapFactory.Options();

		// 获取图片的实际尺寸，并且算出实际大小和要显示的大小的比例
		File file = new File(path);
		int GLOBAL_SCREEN_WIDTH = Util.getScreenWidth(this);
		int GLOBAL_SCREEN_HEIGHT = Util.getScreenHeight(this);
		int iss = ImageUtils.getSampleSize(file, GLOBAL_SCREEN_WIDTH, GLOBAL_SCREEN_HEIGHT);

		options.inJustDecodeBounds = true;
		options.inSampleSize = iss;
		options.inTempStorage = new byte[12 * 1024];
		BitmapFactory.decodeFile(path, options);
		options.inJustDecodeBounds = false;

		return options;
	}

	private void initView() {
		BitmapFactory.Options options = readBmpOpts(path);
		if (options.outHeight == -1 || options.outWidth == -1) {
			setResult(501);
			finish();
			return;
		}
		if (options.outHeight < minHeight || options.outWidth < minWidth) {
			setResult(500);
			finish();
			return;
		}
		bm = BitmapFactory.decodeFile(path, options);
		int degree = ImageUtils.getRotateDegree(path);
		if (degree != 0) {
			Matrix matrix = new Matrix();
			matrix.setRotate(degree);
			Bitmap tempBitmap = null;
			int width = bm.getWidth();
			int height = bm.getHeight();
			while (tempBitmap == null) {
				try {
					tempBitmap = Bitmap.createBitmap(bm, 0, 0, width, height, matrix, true);
				} catch (OutOfMemoryError err) {
					width *= 0.9;
					height *= 0.9;
				}
			}
			bm = tempBitmap;
		}

		iv.setTag(bm);
		iv.setImageBitmap(bm);
		// 设置裁剪区域是否可以拉伸
		if (isAvatar) {
			iv.setFixedAspectRatio(true);
		} else {
			iv.setFixedAspectRatio(false);
		}
	}

	/**
	 * 压缩图片
	 * 
	 * */
	private void compressBitmapFile(Bitmap res, int percent, File file) {
		OutputStream outputStream = null;
		try {
			outputStream = new FileOutputStream(file);
			res.compress(CompressFormat.JPEG, percent, outputStream);
			outputStream.flush();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			Util.close(outputStream);
		}
	}

	@Override
	public void onClick(View v) {
		switch (v.getId()) {
		case R.id.btn_back:
			// 返回按钮
			setResult(Activity.RESULT_CANCELED);
			finish();
		case R.id.btn_useit:
			// 确认按钮
			Bitmap res = iv.getCroppedImage();
			File file = new File(path);
			compressBitmapFile(bm, percent, file);
			iv.setVisibility(View.GONE);
			Intent intent = new Intent();
			intent.putExtra("path", path);
			FileStore fs = J_FileManager.getInstance().getFileStore();
			String avatarPath = fs.getFileStorePath() + MD5.md5(ORIGINAL_PHOTO_NAME);// 裁剪后图片的文件名
			File fileTemp = new File(avatarPath);
			compressBitmapFile(res, percent, fileTemp);
			intent.putExtra("avatarPath", avatarPath);
			setResult(RESULT_OK, intent);
			finish();
			break;
		default:
			break;
		}
	}

}
