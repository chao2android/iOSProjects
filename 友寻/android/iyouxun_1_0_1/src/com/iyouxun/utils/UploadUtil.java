package com.iyouxun.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import android.app.Activity;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.graphics.BitmapFactory.Options;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.util.Log;

import com.iyouxun.R;
import com.iyouxun.j_libs.log.J_Log;
import com.iyouxun.j_libs.utils.J_CommonUtils;

public class UploadUtil
{
	public static final int REQUEST_TAKE_PICTURE = 1;
	public static final int REQUEST_OPEN_GALLERY = 2;
	public static final int REQUEST_CROP_RETURN = 3;

	public static final int GET_PHOTO_TAKE_PICTURE = 11;
	public static final int GET_PHOTO_OPEN_GALLERY = 12;

	protected static final String IMAGE_UNSPECIFIED = "image/*";
	private static File fileMAvatar;
	private static Uri mAvatarUri;
	// 剪切之后
	private static File mCropAvatar;
	private static Uri mCropUri;

	private static Activity mActivity;
	public static final String CROP_IMG_PATH = Environment.getExternalStorageDirectory() + "/ipk/crop_temp";
	public static final String TEMP_IMG_PATH = Environment.getExternalStorageDirectory() + "/ipk/temp";

	// Get avatar from camera
	public static void getCamera(Activity activity)
	{
		initData(activity);
		Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
		Intent intent_camera = activity.getPackageManager().getLaunchIntentForPackage("com.android.camera");
		if (intent_camera != null)
		{
			intent.setPackage("com.android.camera");
		}

		// 指定照片保存路径（SD卡），image.jpg为一个临时文件，每次拍照后这个图片都会被替换
		intent.putExtra(MediaStore.EXTRA_OUTPUT, mAvatarUri);
		activity.startActivityForResult(intent, REQUEST_TAKE_PICTURE);
	}

	// Get avatar from gallery
	public static void getGallery(Activity activity)
	{
		if (!J_CommonUtils.isSDCardExists())
		{
			ToastUtil.showActionResult(R.string.sdcard_is_not_exit, false);
			return;
		}
		initData(activity);
		Intent intent = new Intent(Intent.ACTION_PICK, null);
		intent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, IMAGE_UNSPECIFIED);
		activity.startActivityForResult(intent, REQUEST_OPEN_GALLERY);
	}

	// Get photo from camera
	public static void getPhotoFromCamera(Activity activity, int requestCode)
	{
		if (!J_CommonUtils.isSDCardExists())
		{
			ToastUtil.showActionResult(R.string.sdcard_is_not_exit, false);
			return;
		}
		initData(activity);
		Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
		Intent intent_camera = activity.getPackageManager().getLaunchIntentForPackage("com.android.camera");
		if (intent_camera != null)
		{
			intent.setPackage("com.android.camera");
		}

		// 指定照片保存路径（SD卡），image.jpg为一个临时文件，每次拍照后这个图片都会被替换
		intent.putExtra(MediaStore.EXTRA_OUTPUT, mAvatarUri);
		activity.startActivityForResult(intent, requestCode);
	}

	// Get photo from gallery
	public static void getPhotoFromGallery(Activity activity, int requestCode)
	{
		initData(activity);
		Intent intent = new Intent(Intent.ACTION_PICK, null);
		intent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, IMAGE_UNSPECIFIED);
		activity.startActivityForResult(intent, requestCode);
	}

	// 初始化数据
	private static void initData(Activity activity)
	{
		mActivity = activity;
		File mFile = new File(Environment.getExternalStorageDirectory() + "/ipk");
		if (!mFile.exists())
		{
			mFile.mkdirs();
		}
		fileMAvatar = new File(TEMP_IMG_PATH);
		if (fileMAvatar.exists())
		{
			fileMAvatar.delete();
		}
		mAvatarUri = Uri.fromFile(fileMAvatar);
	} 

	/**
	 * 剪裁图片
	 * 
	 * @param uri
	 */
	public static void cropImg(Uri uri)
	{
		Intent intent = new Intent("com.android.camera.action.CROP");
		intent.setDataAndType(uri, "image/*");
		intent.putExtra("crop", "true");
		// aspectX aspectY 是宽高的比例
		intent.putExtra("aspectX", 1);
		intent.putExtra("aspectY", 1);
		intent.putExtra("outputX", 110);
		intent.putExtra("outputY", 135);
		intent.putExtra("return-data", false);
		// 系统的裁剪图片默认对图片进行人脸识别，当识别到有人脸时，会按aspectX和aspectY为1来处理，如果想设置成自定义的裁剪比例，需要设置noFaceDetection为true
		intent.putExtra("noFaceDetection", true);
		// 指定照片保存路径（SD卡），为一个临时文件，每次拍照后这个图片都会被替换
		File mFile = new File(Environment.getExternalStorageDirectory() + "/ipk");
		if (!mFile.exists())
		{
			mFile.mkdirs();
		}
		mCropAvatar = new File(CROP_IMG_PATH);
		if (mCropAvatar.exists())
		{
			mCropAvatar.delete();
		}
		mCropUri = Uri.fromFile(mCropAvatar);
		intent.putExtra(MediaStore.EXTRA_OUTPUT, mCropUri);
		mActivity.startActivityForResult(intent, REQUEST_CROP_RETURN);
	}

	public static void copyBitmapToTempFile(Uri uri)
	{
		File picture = new File(Environment.getExternalStorageDirectory() + "/ipk", "temp");
		FileOutputStream out = null;
		InputStream is = null;
		try
		{
			is = mActivity.getContentResolver().openInputStream(uri);
			out = new FileOutputStream(picture);
			byte[] buffer = new byte[1024];
			while (is.read(buffer) != -1)
			{
				out.write(buffer);
			}
			is.close();
			is = null;
			out.close();
			out = null;
		}
		catch (FileNotFoundException e)
		{
			J_Log.e("FileNotFoundException======" + e);
		}
		catch (IOException e)
		{
			J_Log.e("IOException======" + e);
		}
		finally
		{
			try
			{
				if (is != null)
				{
					is.close();
					is = null;
				}
				if (out != null)
				{
					out.close();
					out = null;
				}
			}
			catch (IOException e)
			{
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	/**
	 * 回调处理
	 * 
	 * @param requestCode
	 * @param resultCode
	 * @param data
	 * @return
	 */
	public static void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		Uri uri;
		switch (requestCode)
		{
		case REQUEST_TAKE_PICTURE:
		{
			Log.d("uploadUtils", " fileMAvatar="+fileMAvatar);
			if (fileMAvatar == null || !fileMAvatar.exists() || fileMAvatar.length() <= 0)
			{
				break;
			}
			File file = FileUtil.compressFile(mActivity, fileMAvatar.getAbsolutePath(), -1);
			uri = Uri.fromFile(file);
			cropImg(uri);
		}
			break;
		case REQUEST_OPEN_GALLERY:
		{
			if (data == null)
			{
				break;
			}
			uri = data.getData(); // 以content://开头的
			String path = FileUtil.getChoosedPicturePath(uri, mActivity);
			if (path != null)
			{
				File file = new File(path);
				uri = Uri.fromFile(file);// 以file://开头的,进行图片剪裁
				cropImg(uri);
			}
			else
			{
				ToastUtil.showActionResult(R.string.get_photo_failed, false);
			}
		}
			break;
		case REQUEST_CROP_RETURN:
			if (data == null)
			{
				break;
			}
			if (!mCropAvatar.exists() || mCropAvatar.length() <= 0)
			{
				break;
			}
		}
	}

	public static long getFileSize(File f) throws Exception
	{
		long s = 0;
		if (f.exists())
		{
			FileInputStream fis = null;
			fis = new FileInputStream(f);
			s = fis.available();
			fis.close();
		}
		else
		{
			f.createNewFile();
		}
		return s;
	}

	/**
	 * 获取压缩比例
	 * 
	 * */
	public static int getSampleSize(File imgFile, int GLOBAL_SCREEN_WIDTH, int GLOBAL_SCREEN_HEIGHT)
	{
		int iss = 1;

		try
		{
			long fileSize = getFileSize(imgFile);
			iss = getSampleSize(fileSize);

			Options bitmapFactoryOptions = new BitmapFactory.Options();
			bitmapFactoryOptions.inJustDecodeBounds = true;
			BitmapFactory.decodeFile(imgFile.toString(), bitmapFactoryOptions);
			// 获取图片的实际尺寸，并且算出实际大小和要显示的大小的比例
			int heightRatio = (int) Math.ceil(bitmapFactoryOptions.outHeight / (float) GLOBAL_SCREEN_HEIGHT);
			int widthRatio = (int) Math.ceil(bitmapFactoryOptions.outWidth / (float) GLOBAL_SCREEN_WIDTH);
			if (heightRatio > 1 && widthRatio > 1)
			{
				if (heightRatio > widthRatio)
				{
					iss = heightRatio;
				}
				else
				{
					iss = widthRatio;
				}
			}
			bitmapFactoryOptions.inJustDecodeBounds = false;
		}
		catch (Exception e)
		{
		}

		return iss;
	}

	public static int getSampleSize(Long fileSize)
	{
		int sampleSize = 1;
		// 数字越大读出的图片占用的heap越小 不然总是溢出
		if (fileSize < 512000)
		{
			sampleSize = 1;
		}
		else if (fileSize < 1024000)
		{ // 500-1024k
			sampleSize = 2;
		}
		else if (fileSize < 2048000)
		{// 1024-2048k
			sampleSize = 4;
		}
		else if (fileSize < 4096000)
		{// 2048-4096k
			sampleSize = 6;
		}
		else
		{
			sampleSize = 8;
		}
		return sampleSize;
	}
}
