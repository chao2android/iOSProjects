package com.iyouxun.j_libs.file;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

import android.content.Context;
import android.os.Environment;
import android.os.StatFs;

/**
 * file operate utils
 * 
 * @author eyeshot
 * 
 */
public class FileUtils {

	public static final long SDCARD_ALERT_SIZE = 100; // SDCard left max unit is
														// M
	public static final long RAM_ALERT_SIZE = 20; // ram left max unit is M
	public static final double APP_CACHE_SIZE = 50; // app max size unit is M

	/**
	 * check sdcard is exist
	 */
	public static boolean isSDCardExist() {
		return Environment.getExternalStorageState().equals(android.os.Environment.MEDIA_MOUNTED);
	}

	/**
	 * query sdcard left size, unit is M
	 */
	public static long getSDCardAvailableSize() {
		File path = Environment.getExternalStorageDirectory();// sdCard path
		StatFs stat = new StatFs(path.getPath());
		long blockSize = stat.getBlockSize();
		long availableBlocks = stat.getAvailableBlocks();
		return availableBlocks * blockSize / (1024 * 1024); // unit is M
	}

	/**
	 * query ram left size unit is M
	 */
	public static long getRamAvailableSize(Context context) {
		StatFs stat = new StatFs(context.getFilesDir().getPath());
		long blockSize = stat.getBlockSize();
		long availableBlocks = stat.getAvailableBlocks();
		return availableBlocks * blockSize / (1024 * 1024); // unit is M
	}

	/**
	 * check cacheing file's length is or not exteed app_cache_size
	 */

	public static byte[] checkLength(InputStream is) {
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		if (null != is) {
			int len = 0;
			byte[] data = new byte[100];
			try {
				while ((len = is.read(data)) > 0) {
					baos.write(data, 0, len);
				}
			} catch (IOException e) {
			}
		}
		return baos.toByteArray();

	}

}
