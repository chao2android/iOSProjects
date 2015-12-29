package com.iyouxun.utils;

import java.io.File;
import java.io.FileOutputStream;

import android.app.Activity;
import android.content.Context;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.BitmapFactory.Options;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.text.TextUtils;

import com.iyouxun.R;
import com.iyouxun.j_libs.utils.J_ImageUtil;

public class FileUtil {
	private static final String TAG = "FileUtil";

	public static String getChoosedPicturePath(Uri uri, Activity activity) {
		String imagePath = "";
		if (null == uri) {
			return "";
		}
		if (uri.toString().startsWith("content://")) {
			String[] projection = { MediaStore.Images.Media.DATA };
			Cursor cursor = activity.managedQuery(uri, projection, null, null, null);
			int column_index = cursor.getColumnIndexOrThrow(MediaStore.Images.Media.DATA);
			cursor.moveToFirst();
			imagePath = cursor.getString(column_index);
		} else {
			if (uri.toString().startsWith("file://")) {
				imagePath = uri.toString().substring("file://".length());
			} else {
				imagePath = uri.toString();
			}
		}
		String path = null;
		// 若用户选择的是图片文件,则返回路径。
		if (TextUtils.isEmpty(imagePath)) {
			return null;
		}
		String tempPath = imagePath.toLowerCase();
		if (tempPath.endsWith(".jpg") || tempPath.endsWith(".png") || tempPath.endsWith(".jpeg")) {
			path = imagePath;
		} else {
			ToastUtil.showActionResult(R.string.upload_photo_format_incorrect, false);
		}
		return path;
	}

	/**
	 * 压缩图片从相机返回
	 * */
	public static File compressFile(Context context, String filepath, int rotato) {
		File PHOTO_DIR = new File(Environment.getExternalStorageDirectory() + "/DCIM/photo");

		if (!PHOTO_DIR.exists()) {
			PHOTO_DIR.mkdirs();
		}
		File file = new File(PHOTO_DIR, System.currentTimeMillis() + ".jpg");
		if (file.exists()) {
			file.delete();
		}
		try {
			ExifInterface eff = new ExifInterface(filepath);
			int dree = eff.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);

			Options options = new Options();
			options.inJustDecodeBounds = true;
			Bitmap photo = BitmapFactory.decodeFile(filepath, options);
			options.inJustDecodeBounds = false;
			float reqHeight = 1280f;// 这里设置高度为1280f
			float reqWidth = 720f;// 这里设置宽度为720f

			int height = options.outHeight;
			int width = options.outWidth;
			int inSampleSize = 1;

			if (height > reqHeight || width > reqWidth) {
				int heightRatio = Math.round(height / reqHeight);
				int widthRatio = Math.round(width / reqWidth);
				inSampleSize = heightRatio > widthRatio ? heightRatio : widthRatio;
			}

			if (inSampleSize < 1) {
				inSampleSize = 1;
			}
			options.inSampleSize = inSampleSize;// 设置缩放比例
			photo = BitmapFactory.decodeFile(filepath, options);
			Matrix matrix1 = new Matrix();
			if (rotato != -1) {
				matrix1.setRotate(rotato);
			} else {
				matrix1.setRotate(J_ImageUtil.readPictureDegree(filepath));
			}
			Bitmap b = Bitmap.createBitmap(photo, 0, 0, photo.getWidth(), photo.getHeight(), matrix1, true);
			FileOutputStream fos = null;
			fos = new FileOutputStream(file.getPath());
			b.compress(Bitmap.CompressFormat.JPEG, 70, fos);
			photo.recycle();
			b.recycle();
		} catch (Exception e) {
			e.printStackTrace();
		}
		return file;
	}

	/**
	 * 清空临时文件
	 * */
	public static void deleteTimePhoto() {
		File PHOTO_DIR = new File(Environment.getExternalStorageDirectory() + "/DCIM/photo");
		if (!PHOTO_DIR.exists()) {
			return;
		}
		File[] files = PHOTO_DIR.listFiles();
		if (files.length > 0) {
			for (File f : files) {
				f.delete();
			}
		}
	}

}