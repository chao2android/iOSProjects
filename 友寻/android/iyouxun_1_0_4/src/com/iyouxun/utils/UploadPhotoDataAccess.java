package com.iyouxun.utils;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import android.app.Activity;
import android.content.ContentResolver;
import android.content.Intent;
import android.database.Cursor;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.BitmapFactory.Options;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.net.Uri;
import android.os.Handler;
import android.provider.MediaStore;
import android.provider.MediaStore.Images.ImageColumns;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.j_libs.encrypt.MD5;
import com.iyouxun.j_libs.file.FileStore;
import com.iyouxun.j_libs.managers.J_FileManager;

/**
 * 相册或拍照获取图片
 * 
 * 使用方法：
 * 
 * 1、实例化UploadPhotoDataAccess类
 * 
 * 2、setActivity()
 * 
 * 3、setCacheName()
 * 
 * @author likai
 * @date 2015-5-15 上午10:37:39
 * 
 */
public class UploadPhotoDataAccess {
	public static final int NONE = 0;
	public static final int REQUEST_ASK_CAMERA = 123;
	public static final int REQUEST_ASK_GALLERY = 456;
	protected static final String IMAGE_UNSPECIFIED = "image/*";

	private Handler mHandler;
	private final Activity activity;
	/** 默认的缓存名称为temp，可以通过setCacheName()方法进行设置 */
	private String cacheName = "upload_temp";
	private final FileStore fs;
	private final String filePath;
	/** 拍照缓存的图片file */
	private File captureFile;

	public void setHandler(Handler handler) {
		this.mHandler = handler;
	}

	public UploadPhotoDataAccess(Activity activity) {
		this.activity = activity;
		// 获取filestore
		fs = J_FileManager.getInstance().getFileStore();
		// 设置缓存目录
		filePath = fs.getFileStorePath();
		// 检查目录是否存在并创建该目录
		File file_path = new File(filePath);
		if (!file_path.exists()) {
			file_path.mkdirs();
		}
	}

	/**
	 * 设置缓存文件名
	 * 
	 * */
	public void setCacheName(String cName) {
		this.cacheName = cName;
	}

	/**
	 * 获取缓存名称
	 * 
	 * @return String 返回类型
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public String getCacheName() {
		return cacheName;
	}

	/**
	 * 拍照获取文件
	 * 
	 * INTENT_ACTION_STILL_IMAGE_CAMERA
	 * */
	public void getHeaderFromCamera() {
		Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE);

		// 设置拍照后存储的图片地址
		captureFile = new File(filePath, MD5.md5(cacheName));
		intent.putExtra(MediaStore.EXTRA_OUTPUT, Uri.fromFile(captureFile));

		// 执行跳转
		activity.startActivityForResult(intent, REQUEST_ASK_CAMERA);
	}

	/**
	 * 从相册获取文件
	 * 
	 * */
	public void getHeaderFromGallery() {
		Intent intent = new Intent();
		intent.setAction(Intent.ACTION_PICK);
		intent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, IMAGE_UNSPECIFIED);

		// 执行跳转
		activity.startActivityForResult(intent, REQUEST_ASK_GALLERY);
	}

	/**
	 * 相册或拍照返回后的处理
	 * 
	 * @return File 返回类型
	 * @param @param requestCode
	 * @param @param resultCode
	 * @param @param intent
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public File onActivityResult(int requestCode, int resultCode, Intent intent) {
		if (resultCode == NONE) {
			return null;
		}
		if (requestCode == REQUEST_ASK_CAMERA) {
			// 处理拍照图片
			try {
				long fileSize = Util.getFileSize(captureFile);
				if (fileSize == 0) {
					ToastUtil.showToast(activity, "找不到文件");
				} else if (fileSize < 2048) {
					ToastUtil.showToast(activity, "图片尺寸不能小于2k");
				} else if (fileSize > 5 * 1024 * 1024) {
					ToastUtil.showToast(activity, "图片尺寸不能大于5M");
				} else if (captureFile != null && fileSize <= Util.getAvailaleSize()) {
					// 从相册原图拷贝一份
					File galleryFile = copyBitmapToTempFile(captureFile);
					// 处理图片
					return galleryFile;
				} else {
					ToastUtil.showToast(activity, activity.getString(R.string.str_memory_not_enough));
				}
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else if (requestCode == REQUEST_ASK_GALLERY) {
			// 处理相册图片
			try {
				Uri uri = intent.getData();
				long fileSize = activity.getContentResolver().openInputStream(uri).available();
				if (fileSize < 2 * 1024) {
					ToastUtil.showToast(activity, "图片尺寸不能小于2k");
				} else if (fileSize > 5 * 1024 * 1024) {
					ToastUtil.showToast(activity, "图片尺寸不能大于5M");
				} else if (fileSize <= Util.getAvailaleSize()) {
					// 图片尺寸检查
					BitmapFactory.Options options = new BitmapFactory.Options();
					options.inJustDecodeBounds = true;
					BitmapFactory.decodeFile(getRealFilePath(uri), options);
					int outWidth = options.outWidth;
					int outHeight = options.outHeight;
					options.inJustDecodeBounds = false;
					if (outWidth < 100 || outHeight < 100) {
						ToastUtil.showToast(activity, "图片尺寸不能小于100pxX100px");
					} else if (outWidth > 5000 || outHeight > 5000) {
						ToastUtil.showToast(activity, "图片尺寸不能大于5000pxX5000px");
					} else {
						// 从相册原图拷贝一份
						File uri2File = new File(getRealFilePath(uri));
						File galleryFile = copyBitmapToTempFile(uri2File);

						// 处理图片
						return galleryFile;
					}
				} else {
					ToastUtil.showToast(activity, activity.getString(R.string.str_memory_not_enough));
				}
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	/**
	 * 从原图uri拷贝一份到指定目录文件
	 * 
	 * @return File 返回类型
	 * @param @param uri
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public File copyBitmapToTempFile(File file) {
		try {
			// 屏幕宽度
			int GLOBAL_SCREEN_WIDTH = Util.getScreenWidth(J_Application.sCurrentActiviy);
			// 屏幕高度
			int GLOBAL_SCREEN_HEIGHT = Util.getScreenHeight(J_Application.sCurrentActiviy);

			// 获取缩放值
			int iss = ImageUtils.getSampleSize(file, GLOBAL_SCREEN_WIDTH, GLOBAL_SCREEN_HEIGHT);

			// 设置压缩值
			Options bitmapFactoryOptions = new BitmapFactory.Options();
			bitmapFactoryOptions.inSampleSize = iss;// 缩放值
			Bitmap bitmap = BitmapFactory.decodeFile(file.getAbsolutePath(), bitmapFactoryOptions);

			// 检查图片旋转状态
			int degrees = readPictureDegree(file.getAbsolutePath());
			if (degrees != 0) {
				bitmap = rotateBitmap(bitmap, degrees);
			}

			// 保存到缓存目录一份
			J_FileManager.getInstance().getFileStore().storeBitmap(bitmap, cacheName);
			bitmap.recycle();

			return J_FileManager.getInstance().getFileStore().isFileExistSDCardAndRam(cacheName, null);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public static Bitmap getPicFromBytes(byte[] bytes, BitmapFactory.Options opts) {
		if (bytes != null) {
			if (opts != null) {
				return BitmapFactory.decodeByteArray(bytes, 0, bytes.length, opts);
			} else {
				return BitmapFactory.decodeByteArray(bytes, 0, bytes.length);
			}
		}
		return null;
	}

	/**
	 * @Description: 根据InputStream复制文件
	 * @param @param is
	 * @param @return
	 * @return File
	 * @throws
	 * @date 2014-2-21
	 */
	public File copyBitmapToTempFile(InputStream is) {
		File picture = new File(filePath, MD5.md5(cacheName));
		picture.delete();
		OutputStream out = null;
		try {
			out = new FileOutputStream(picture);
			byte[] buffer = new byte[1024];
			int len = is.read(buffer);
			while (len != -1) {
				out.write(buffer, 0, len);
				len = is.read(buffer);
			}
			out.flush();
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally {
			Util.close(out);
			Util.close(is);
		}

		return picture;
	}

	/**
	 * 检查是否需要旋转图片，需要旋转，根据角度，自动旋转图片并覆盖
	 * 
	 * */
	private void checkIfRotate(final File file) {
		String pathName = file.getAbsolutePath();// 返回的是存储在filestore/temp文件中
		int degrees = readPictureDegree(pathName);
		if (degrees != 0) {
			Bitmap bm = BitmapFactory.decodeFile(pathName);
			Bitmap bmOk = rotateBitmap(bm, degrees);
			try {
				J_FileManager.getInstance().getFileStore().storeBitmap(bmOk, cacheName);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * 读取图片属性：旋转的角度
	 * 
	 * @param path 图片绝对路径
	 * @return degree旋转的角度
	 */
	public static int readPictureDegree(String path) {
		int degree = 0;
		try {
			ExifInterface exifInterface = new ExifInterface(path);
			int orientation = exifInterface.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);
			switch (orientation) {
			case ExifInterface.ORIENTATION_ROTATE_90:
				degree = 90;
				break;
			case ExifInterface.ORIENTATION_ROTATE_180:
				degree = 180;
				break;
			case ExifInterface.ORIENTATION_ROTATE_270:
				degree = 270;
				break;
			}
		} catch (IOException e) {
			e.printStackTrace();
			return degree;
		}
		return degree;
	}

	/**
	 * 旋转图片，使图片保持正确的方向。
	 * 
	 * @param bitmap 原始图片
	 * @param degrees 原始图片的角度
	 * @return Bitmap 旋转后的图片
	 */
	public static Bitmap rotateBitmap(Bitmap bitmap, int degrees) {
		if (degrees == 0 || null == bitmap) {
			return bitmap;
		}
		Matrix matrix = new Matrix();
		matrix.setRotate(degrees, bitmap.getWidth() / 2, bitmap.getHeight() / 2);
		Bitmap bmp = Bitmap.createBitmap(bitmap, 0, 0, bitmap.getWidth(), bitmap.getHeight(), matrix, true);
		if (null != bitmap) {
			bitmap.recycle();
		}
		return bmp;
	}

	/**
	 * 通过uri获取到文件的path
	 * 
	 * @return String 返回类型
	 * @param @param uri
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public String getRealFilePath(final Uri uri) {
		if (null == uri)
			return null;
		final String scheme = uri.getScheme();
		String data = null;
		if (scheme == null)
			data = uri.getPath();
		else if (ContentResolver.SCHEME_FILE.equals(scheme)) {
			data = uri.getPath();
		} else if (ContentResolver.SCHEME_CONTENT.equals(scheme)) {
			Cursor cursor = activity.getContentResolver().query(uri, new String[] { ImageColumns.DATA }, null, null, null);
			if (null != cursor) {
				if (cursor.moveToFirst()) {
					int index = cursor.getColumnIndex(ImageColumns.DATA);
					if (index > -1) {
						data = cursor.getString(index);
					}
				}
				cursor.close();
			}
		}
		return data;
	}
}
