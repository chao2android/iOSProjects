package com.iyouxun.utils;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.math.BigDecimal;

import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.BitmapFactory.Options;
import android.graphics.Canvas;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.PixelFormat;
import android.graphics.drawable.BitmapDrawable;
import android.graphics.drawable.Drawable;
import android.media.ExifInterface;
import android.widget.ImageView;
import android.widget.ImageView.ScaleType;
import android.widget.LinearLayout.LayoutParams;

import com.iyouxun.J_Application;
import com.iyouxun.R;

public class ImageUtils {
	public static Bitmap getImage(String srcPath) {
		return getimage(srcPath, 480, 800, 1024);
	}

	public static Bitmap getimage(String srcPath, float wantWidth, float wantHeight, int fileSize) {
		BitmapFactory.Options newOpts = new BitmapFactory.Options();
		// 开始读入图片，此时把options.inJustDecodeBounds 设回true了
		newOpts.inJustDecodeBounds = true;
		Bitmap bitmap = BitmapFactory.decodeFile(srcPath, newOpts);// 此时返回bm为空

		newOpts.inJustDecodeBounds = false;
		int w = newOpts.outWidth;
		int h = newOpts.outHeight;
		// 现在主流手机比较多是800*480分辨率，所以高和宽我们设置为
		float hh = wantHeight;// 这里设置高度为800f
		float ww = wantWidth;// 这里设置宽度为480f
		// 缩放比。由于是固定比例缩放，只用高或者宽其中一个数据进行计算即可
		int be = 1;// be=1表示不缩放
		if (w > h && w > ww) {// 如果宽度大的话根据宽度固定大小缩放
			be = (int) (newOpts.outWidth / ww);
		} else if (w < h && h > hh) {// 如果高度高的话根据宽度固定大小缩放
			be = (int) (newOpts.outHeight / hh);
		}
		if (be <= 0)
			be = 1;
		newOpts.inSampleSize = be;// 设置缩放比例
		// 重新读入图片，注意此时已经把options.inJustDecodeBounds 设回false了
		bitmap = BitmapFactory.decodeFile(srcPath, newOpts);
		return compressImage(bitmap, fileSize);// 压缩好比例大小后再进行质量压缩
	}

	/**
	 * 按照指定大小压缩图片 采用循环压缩，图片大小每次递减10%
	 * 
	 * @param image
	 * @param imgSize 图片被压缩后的大小（单位kb）
	 * @return
	 */
	public static Bitmap compressImage(Bitmap image, int imgSize) {

		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		image.compress(Bitmap.CompressFormat.JPEG, 100, baos);// 质量压缩方法，这里100表示不压缩，把压缩后的数据存放到baos中
		int options = 100;
		while (baos.toByteArray().length / 1024 > imgSize) { // 循环判断如果压缩后图片是否大于100kb,大于继续压缩
			baos.reset();// 重置baos即清空baos
			image.compress(Bitmap.CompressFormat.JPEG, options, baos);// 这里压缩options%，把压缩后的数据存放到baos中
			options -= 10;// 每次都减少10
		}
		ByteArrayInputStream isBm = new ByteArrayInputStream(baos.toByteArray());// 把压缩后的数据baos存放到ByteArrayInputStream中
		Bitmap bitmap = BitmapFactory.decodeStream(isBm, null, null);// 把ByteArrayInputStream数据生成图片
		return bitmap;
	}

	/**
	 * 生成透明图，带文字：审核中
	 * 
	 * @param bmp
	 * @return
	 */
	public static Bitmap genTranslusentCircleBitmap(Bitmap bmp) {
		int textSize = 18;
		int newWidth = 110;
		int newHeight = 110;
		int radio = Math.round(newWidth / 2);

		int width = bmp.getWidth();
		int height = bmp.getHeight();
		int x = 0;
		int y = 0;
		if (width > height) {
			x = (width - height) / 2;
			width = height;
		} else {
			y = (height - width) / 2;
			height = width;
		}
		Matrix matrix = new Matrix();
		float sx = (float) newWidth / width;
		matrix.setScale(sx, sx);
		Bitmap bitmap = Bitmap.createBitmap(bmp, x, y, width, height, matrix, true);
		Canvas canvas = new Canvas(bitmap);
		Paint circlePaint = new Paint();
		circlePaint.setAntiAlias(true);
		circlePaint.setARGB(120, 0, 0, 0);
		canvas.drawCircle(newWidth / 2, newHeight / 2, radio, circlePaint);
		Paint txtPaint = new Paint();
		txtPaint.setAntiAlias(true);
		txtPaint.setARGB(255, 255, 255, 255);
		txtPaint.setTextSize(textSize);
		canvas.drawText(J_Application.context.getString(R.string.avatar_be_reviewing), 30, (newHeight + textSize) / 2, txtPaint);
		if (!bmp.isRecycled()) {
			bmp.recycle();
		}
		return bitmap;
	}

	/**
	 * 通过原始图片宽高获取该图片在先听范围内的图片的宽高
	 * 
	 * */
	public static float[] getBitmapScaleSize(int originalWidth, int originalHeight, int maxSize) {
		int width = originalWidth;
		int height = originalHeight;
		float[] result = { 0, 0 };

		if (width < maxSize && height < maxSize) {
			result[0] = width;
			result[1] = height;
		} else {
			float differ = 1.000f;
			if (width > height) {
				differ = div(maxSize, width, 3);
				result[0] = maxSize;
				result[1] = height * differ;
			} else {
				differ = div(maxSize, height, 3);
				result[0] = width * differ;
				result[1] = maxSize;
			}
		}
		return result;
	}

	/**
	 * 提供（相对）精确的除法运算。当发生除不尽的情况时，由scale参数指 定精度，以后的数字四舍五入。
	 * 
	 * @param v1 被除数
	 * @param v2 除数
	 * @param scale 表示表示需要精确到小数点以后几位。
	 * @return 两个参数的商
	 */
	public static float div(double v1, double v2, int scale) {
		if (scale < 0) {
			throw new IllegalArgumentException("The scale must be a positive integer or zero");
		}
		BigDecimal b1 = new BigDecimal(Double.toString(v1));
		BigDecimal b2 = new BigDecimal(Double.toString(v2));
		return b1.divide(b2, scale, BigDecimal.ROUND_HALF_UP).floatValue();
	}

	/**
	 * 获取压缩比例
	 * 
	 * */
	public static int getSampleSize(File imgFile, int GLOBAL_SCREEN_WIDTH, int GLOBAL_SCREEN_HEIGHT) {
		int iss = 1;

		int useWidth = GLOBAL_SCREEN_WIDTH;
		int useHeihgt = GLOBAL_SCREEN_HEIGHT;

		try {
			long fileSize = Util.getFileSize(imgFile);
			iss = ImageUtils.getSampleSize(fileSize);

			Options bitmapFactoryOptions = new BitmapFactory.Options();
			bitmapFactoryOptions.inJustDecodeBounds = true;
			BitmapFactory.decodeFile(imgFile.toString(), bitmapFactoryOptions);
			// 获取图片的实际尺寸，并且算出实际大小和要显示的大小的比例
			int heightRatio = (int) Math.ceil(bitmapFactoryOptions.outHeight / (float) useHeihgt);
			int widthRatio = (int) Math.ceil(bitmapFactoryOptions.outWidth / (float) useWidth);
			// 如果原图小于500x500，不再压缩
			if (bitmapFactoryOptions.outHeight < 500 && bitmapFactoryOptions.outWidth < 500) {
				iss = 1;
			}
			if (heightRatio > 1 && widthRatio > 1) {
				if (heightRatio > widthRatio) {
					iss = heightRatio;
				} else {
					iss = widthRatio;
				}
			}
			bitmapFactoryOptions.inJustDecodeBounds = false;
		} catch (Exception e) {
		}
		DLog.d("likai-test", "ImageUtils获取的图片压缩比：" + iss);
		return iss;
	}

	/**
	 * 
	 * @param imgPath
	 * @return
	 */
	public static int getRotateDegree(String imgPath) {
		int degree = 0;
		try {
			ExifInterface exifIntf = new ExifInterface(imgPath);
			int intOrentation = exifIntf.getAttributeInt(ExifInterface.TAG_ORIENTATION, ExifInterface.ORIENTATION_NORMAL);
			switch (intOrentation) {
			case ExifInterface.ORIENTATION_NORMAL:
				degree = 0;
				break;
			case ExifInterface.ORIENTATION_ROTATE_180:
				degree = 180;
				break;
			case ExifInterface.ORIENTATION_ROTATE_270:
				degree = 270;
				break;
			case ExifInterface.ORIENTATION_ROTATE_90:
				degree = 90;
				break;
			case ExifInterface.ORIENTATION_FLIP_HORIZONTAL:
				degree = 0;
				break;
			case ExifInterface.ORIENTATION_FLIP_VERTICAL:
				degree = 0;
				break;
			case ExifInterface.ORIENTATION_TRANSPOSE:
				degree = 0;
				break;
			case ExifInterface.ORIENTATION_TRANSVERSE:
				degree = 0;
				break;
			case ExifInterface.ORIENTATION_UNDEFINED:
				degree = 0;
				break;
			}
		} catch (IOException e) {
			e.printStackTrace();
		}
		return degree;
	}

	/**
	 * 获取压缩比例
	 * 
	 * @param fileSize
	 * @return
	 */
	public static int getSampleSize(Long fileSize) {
		int sampleSize = 1;
		// 数字越大读出的图片占用的heap越小 不然总是溢出
		if (fileSize < 512000) {
			sampleSize = 1;
		} else if (fileSize < 1024000) { // 500-1024k
			sampleSize = 2;
		} else if (fileSize < 2048000) {// 1024-2048k
			sampleSize = 4;
		} else if (fileSize < 4096000) {// 2048-4096k
			sampleSize = 6;
		} else {
			sampleSize = 8;
		}
		return sampleSize;
	}

	public static Bitmap drawableToBitmap(Drawable drawable) {
		// bitmap
		int width = drawable.getIntrinsicWidth();
		int height = drawable.getIntrinsicHeight();
		Bitmap.Config config = drawable.getOpacity() != PixelFormat.OPAQUE ? Bitmap.Config.ARGB_8888 : Bitmap.Config.RGB_565;
		Bitmap bitmap = Bitmap.createBitmap(width, height, config);
		// bitmap
		Canvas canvas = new Canvas(bitmap);
		drawable.setBounds(0, 0, width, height);
		drawable.draw(canvas);
		return bitmap;
	}

	public static Drawable zoomDrawable(Drawable drawable, int resizeWidth, int resizeHeight) {
		int width = drawable.getIntrinsicWidth();
		int height = drawable.getIntrinsicHeight();
		Bitmap oldbmp = drawableToBitmap(drawable);
		Matrix matrix = new Matrix();
		float scaleWidth = ((float) resizeWidth / width);
		float scaleHeight = ((float) resizeHeight / height);
		matrix.postScale(scaleWidth, scaleHeight);
		Bitmap newbmp = Bitmap.createBitmap(oldbmp, 0, 0, width, height, matrix, true);
		return new BitmapDrawable(newbmp);
	}

	public static Bitmap zoomBitmap(Bitmap bitmap, int resizeWidth, int resizeHeight) {
		int width = bitmap.getWidth();
		int height = bitmap.getHeight();
		Matrix matrix = new Matrix();
		float scaleWidth = ((float) resizeWidth / width);
		float scaleHeight = ((float) resizeHeight / height);
		matrix.postScale(scaleWidth, scaleHeight);
		Bitmap newbmp = Bitmap.createBitmap(bitmap, 0, 0, width, height, matrix, true);
		return newbmp;
	}

	/**
	 * 调整bitmap图片的尺寸缩放到w这个最大限定范围内
	 * 
	 * */
	public static Bitmap resizeImageBitmap(Bitmap bitmap, int maxSize) {
		Bitmap BitmapOrg = bitmap;
		int width = BitmapOrg.getWidth();
		int height = BitmapOrg.getHeight();

		if ((width > height && width < maxSize) || (height > width && height < maxSize)) {
			return BitmapOrg;
		}

		float[] resieze = getBitmapScaleSize(BitmapOrg.getWidth(), BitmapOrg.getHeight(), maxSize);

		float scaleWidth = (resieze[0]) / width;
		float scaleHeight = (resieze[1]) / height;
		Matrix matrix = new Matrix();
		matrix.postScale(scaleWidth, scaleHeight);
		Bitmap resizedBitmap = Bitmap.createBitmap(BitmapOrg, 0, 0, width, height, matrix, true);
		return resizedBitmap;
	}

	/**
	 * 通过图片url中的宽高，设置imageview的尺寸在指定范围内
	 * 
	 * http://p.friendly.dev/00/18/cdbab7aed89c28c9a7554a688f98e0a6/
	 * 228050_300i.jpg?wh=168x300
	 * 
	 * @Title: setImageViewSizeFromUrl
	 * @return void 返回类型
	 * @param @param iv
	 * @param @param url 参数类型
	 * @author likai
	 * @throws
	 */
	public static void setImageViewSizeFromUrl(ImageView iv, String url) {
		int max_height_size = J_Application.context.getResources().getDimensionPixelSize(R.dimen.global_px300dp);
		int max_width_size = J_Application.context.getResources().getDimensionPixelSize(R.dimen.global_px450dp);
		String[] sizeInfo = url.split("wh=");
		int orgWidth = 0;
		int orgHeight = 0;

		float trueWidth = 0;
		float trueHeight = 0;
		if (sizeInfo.length > 1) {
			String sizeAllInfo = sizeInfo[1];
			String[] sizeArr = sizeAllInfo.split("x");
			if (sizeArr.length > 1) {
				orgWidth = Util.getInteger(sizeArr[0]);
				orgHeight = Util.getInteger(sizeArr[1]);
				if (orgWidth > orgHeight) {
					trueWidth = max_width_size;
					float scale = div(max_width_size, orgWidth, 2);
					trueHeight = orgHeight * scale;
				} else if (orgHeight > orgWidth) {
					trueHeight = max_height_size;
					float scale = div(max_height_size, orgHeight, 2);
					trueWidth = orgWidth * scale;
				} else {
					trueHeight = max_height_size;
					float scale = div(max_height_size, orgHeight, 2);
					trueWidth = orgWidth * scale;
				}
				LayoutParams params = new LayoutParams((int) trueWidth, (int) trueHeight);
				iv.setScaleType(ScaleType.FIT_XY);
				iv.setLayoutParams(params);
			}
		}
	}
}
