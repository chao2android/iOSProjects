package com.iyouxun.j_libs.file;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.graphics.Bitmap;
import android.graphics.Bitmap.CompressFormat;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;

import com.iyouxun.j_libs.J_LibsConfig;
import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.encrypt.MD5;
import com.iyouxun.j_libs.log.J_Log;
import com.iyouxun.j_libs.managers.J_FileManager;
import com.iyouxun.j_libs.utils.J_CommonUtils;
import com.iyouxun.j_libs.utils.J_NetUtil;

/**
 * operate file
 * 
 * @author leekai
 * 
 */
public class FileStore {
	protected static String SDPATH;
	protected static String RAMPATH;
	/* 文件存储目录 */
	protected static String storePath = J_LibsConfig.FILE_STORE_PATH;
	/* the whole fileStore flag which show file can or not cache */
	protected static boolean isStorageReset = true;
	protected FileRecordManager frm;
	private boolean isAppRunning;

	public synchronized void init() throws Exception {
		/* 获取外部sd卡 */
		SDPATH = Environment.getExternalStorageDirectory() + "/";
		/* get RamData Directory */
		RAMPATH = J_SDK.getContext().getFilesDir().getPath();
		/* 创建目录 */
		executeCreateDir();
		/* 检查 SDCard 状态 */
		registerSDCardListener();

		frm = J_FileManager.getInstance().getFileRecordManager();
	}

	public boolean isCachable() {
		return isStorageReset;
	}

	public static void setCachable(boolean isCachable) {
		FileStore.isStorageReset = isCachable;
	}

	public boolean isAppRunning() {
		return isAppRunning;
	}

	public void setAppRunning(boolean isAppRunning) {
		this.isAppRunning = isAppRunning;
	}

	protected String getSDPATH() {
		return SDPATH;
	}

	protected String getRAMPATH() {
		return RAMPATH;
	}

	public boolean isFileExist(String fileName) {
		return (isFileExistSDCardAndRam(fileName, null) != null);
	}

	/**
	 * request file by fileName, the return InputStream should be close after
	 * used
	 * 
	 * @param fileName fileName
	 * @param requester FileRequester Interface
	 * @return
	 */
	public InputStream requestFile(String fileName) {
		File f = isFileExistSDCardAndRam(fileName, null);
		if (f != null) {
			try {
				MyFileInputStream is = new MyFileInputStream(f);
				is.sync = this;
				return is;
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	/**
	 * request file by fileName, the return InputStream should be close after
	 * used
	 * 
	 * @param fileName fileName
	 * @param type the file type
	 * @return
	 */
	public InputStream requestFile(String fileName, String type) {
		File f = isFileExistSDCardAndRam(fileName, type);
		if (f != null) {
			try {
				MyFileInputStream is = new MyFileInputStream(f);
				is.sync = this;
				return is;
			} catch (FileNotFoundException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	/**
	 * 在 sdcard or ram中存储文件
	 * 
	 * @param is
	 * @param fileName
	 */

	public boolean storeFile(InputStream is, String fileName) throws IOException {
		boolean isSuccess = false;
		int len = 0;
		byte[] tmpData = new byte[2 * 1024];
		try {
			while ((len = is.read(tmpData)) != -1) {
				isSuccess = appendFile(tmpData, 0, len, fileName);
				if (!isSuccess) {
					break;
				} else {
					frm.writeFile(fileName, len);
				}
			}
		} catch (IOException e) {
			retireFile(fileName);
			throw e;
		} finally {
			closeFile(fileName);
		}

		if (isSuccess) {
			frm.writeFinished(fileName);
		} else {
			frm.writeFailed(fileName);
			retireFile(fileName);
		}

		return isSuccess;
	}

	/**
	 * store file in sdcard or ram
	 * 
	 * @param is
	 * @param fileName
	 */

	public boolean storeFile(String content, String fileName) throws IOException {
		boolean isSuccess = false;
		if (content.length() < 1) {
			return isSuccess;
		}
		fileName = genSDPath(fileName);
		try {
			File saveFile = new File(fileName);
			// 打开文件获取输出流，文件不存在则自动创建
			FileOutputStream fos = new FileOutputStream(saveFile);
			fos.write(content.getBytes());
			fos.close();
			saveFile = null;
			isSuccess = true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return isSuccess;
	}

	/**
	 * @Title: storeFileUTF8
	 * @Description: utf8格式文本
	 * @return boolean 返回类型
	 * @param @param content 文件内容
	 * @param @param fileName 文件类型
	 * @param @return
	 * @param @throws IOException 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public boolean storeFileUTF8(String content, String fileName) throws IOException {
		boolean isSuccess = false;
		if (content.length() < 1) {
			return isSuccess;
		}
		fileName = genSDPath(fileName);
		try {
			File saveFile = new File(fileName);
			// 打开文件获取输出流，文件不存在则自动创建
			FileOutputStream fos = new FileOutputStream(saveFile);
			Writer out = new OutputStreamWriter(fos, "UTF-8");
			out.write(content);
			out.close();
			fos.close();
			saveFile = null;
			isSuccess = true;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return isSuccess;
	}

	/**
	 * to store given Object into file
	 * 
	 * @param o Must implements Serializable.
	 * @param fileName
	 * @return
	 * @throws IOException
	 */
	public boolean storeObject(Object o, String fileName) throws IOException {
		boolean reset = isStorageReset;
		boolean isSuccess = true;
		if (!reset) {
			isSuccess = false;
		} else {
			String tmp = getStorePath(fileName);

			OutputStream fos = null;
			ObjectOutputStream oos = null;

			try {
				fos = new FileOutputStream(tmp);
				oos = new ObjectOutputStream(fos);
				oos.writeObject(o);
				oos.flush();
				isSuccess = true;
			} catch (IOException e) {
				isSuccess = false;
				throw e;
			} finally {
				J_CommonUtils.close(oos);
				J_CommonUtils.close(fos);
			}

			frm.writeFile(fileName, new File(tmp).length());
			frm.writeFailed(fileName);
		}

		if (reset && !isSuccess) {
			isStorageReset = false;
		}
		return isSuccess;
	}

	/**
	 * generate file path with given file name
	 * 
	 * @param fileName
	 * @return
	 */
	protected String getStorePath(String fileName) {
		String tmp = null;
		String sdPath = genSDPath(fileName);
		String ramPath = genRAMPath(fileName);
		tmp = sdPath;
		if (FileUtils.isSDCardExist()) {
			tmp = sdPath;
		} else {
			tmp = ramPath;
		}
		return tmp;
	}

	/**
	 * store file in sdcard or ram.
	 * 
	 * @param b the Bitmap to store
	 * @param fileName
	 */
	public boolean storeBitmap(Bitmap b, String fileName) throws IOException {
		boolean reset = isStorageReset;
		boolean isSuccess = true;
		if (!reset || b == null) {
			isSuccess = false;
		} else {
			String tmp = getStorePath(fileName);
			ByteArrayOutputStream bos = new ByteArrayOutputStream();
			int options = 100;
			b.compress(CompressFormat.PNG, 100, bos);
			int size = 100;
			if (J_NetUtil.isWIFINetWork(J_SDK.getContext())) {
				size = 300;
			}
			while (bos.toByteArray().length / 1024 > size) {
				bos.reset();
				options -= 10;
				b.compress(Bitmap.CompressFormat.JPEG, options, bos);
			}
			byte[] bitmapdata = bos.toByteArray();
			OutputStream os = null;
			try {
				os = new FileOutputStream(tmp);
				os.write(bitmapdata);
				os.flush();
				isSuccess = true;
			} catch (IOException e) {
				isSuccess = false;
				throw e;
			} finally {
				J_CommonUtils.close(os);
			}
		}

		if (reset && !isSuccess) {
			isStorageReset = true;
		}
		return isSuccess;
	}

	/**
	 * append file in sdcard or ram
	 * 
	 * @param input
	 * @param offset
	 * @param count
	 * @param fileName
	 */
	public synchronized boolean appendFile(byte[] input, int offset, int count, String fileName) throws IOException {
		boolean reset = isStorageReset;
		boolean isSuccess = true;
		if (!reset) {
			isSuccess = false;
		} else {
			String tmp = null;
			OutputStream os = null;
			String sdPath = genSDPath(fileName);
			String ramPath = genRAMPath(fileName);
			os = tmpOsHolder.get(sdPath);
			tmp = sdPath;
			if (os == null) {
				os = tmpOsHolder.get(ramPath);
				tmp = ramPath;
			}

			if (os == null) {
				if (FileUtils.isSDCardExist()) {
					tmp = sdPath;
				} else {
					tmp = ramPath;
				}
				os = new FileOutputStream(tmp);

				tmpOsHolder.put(tmp, os);
			}

			isSuccess = doAppendFile(tmp, fileName, input, offset, count, FileUtils.getSDCardAvailableSize(), os);
		}

		if (reset && !isSuccess) {
			isStorageReset = false;
		}
		return isSuccess;
	}

	protected String sdBasePath;

	/**
	 * 获取sd卡中的文件地址
	 * 
	 * @param fileName 文件名
	 * @param isClearPath 标记，获取那种文件目录
	 * @return
	 */
	protected String genSDPath(String fileName) {
		if (sdBasePath == null) {
			StringBuilder sb = new StringBuilder();
			if (Build.VERSION.SDK_INT >= 8) {
				String cacheDir = "Android/data/" + J_SDK.getContext().getPackageName() + "/";
				sb.append(SDPATH).append(cacheDir).append(storePath).append("/");
			} else {
				sb.append(SDPATH).append(storePath).append("/");
			}
			sdBasePath = sb.toString();
		}
		return sdBasePath + MD5.md5(fileName);
	}

	protected String ramBasePath;

	/**
	 * 获取ram中的文件地址
	 * 
	 * @param fileName 文件名
	 * @param isClearPath 标记，获取那种文件目录
	 * @return
	 * */
	protected String genRAMPath(String fileName) {
		if (ramBasePath == null) {
			StringBuilder sb = new StringBuilder();
			sb.append(RAMPATH).append("/").append(storePath).append("/");
			ramBasePath = sb.toString();
		}
		return ramBasePath + MD5.md5(fileName);
	}

	protected Map<String, OutputStream> tmpOsHolder = new HashMap<String, OutputStream>();

	/**
	 * close a file output
	 * 
	 */
	protected void closeFile(String fileName) {
		OutputStream os = null;
		if (FileUtils.isSDCardExist()) {
			os = tmpOsHolder.remove(genSDPath(fileName));
		}
		if (os == null) {
			os = tmpOsHolder.remove(genRAMPath(fileName));
		}
		if (os != null) {
			J_CommonUtils.close(os);
		}
	}

	/**
	 * store file in sdcard or ram with on serialiable
	 * 
	 * @param is
	 * @param fileName
	 */
	public void storeFileNoSerial(Object o, String fileName) throws IOException {
		String pathString = getFileStorePath();
		StringBuilder sb = new StringBuilder();
		sb.append(pathString).append(MD5.md5(fileName));
		writeFileNoSerial(sb.toString(), o);
	}

	/**
	 * read serialiable data
	 * 
	 * @return object
	 */
	public Object readObject(String name) {
		InputStream is = null;
		if (isFileExistSDCardOrRam(name)) {
			is = requestFile(name);
		}
		if (is != null) {
			try {
				ObjectInputStream ois = new ObjectInputStream(is);
				return ois.readObject();
			} catch (Exception e) {
			} finally {
				J_CommonUtils.close(is);
			}
		}

		return null;
	}

	/**
	 * 销毁文件<br />
	 * 可选择销毁文件的目录
	 * */
	public void retireFile(String fileName) {
		StringBuilder sb = new StringBuilder();
		fileName = MD5.md5(fileName);
		if (FileUtils.isSDCardExist()) {
			if (Build.VERSION.SDK_INT >= 8) {
				String cacheDir = "Android/data/" + J_SDK.getContext().getPackageName() + "/";
				sb.append(SDPATH).append(cacheDir).append(storePath).append("/");
			} else {
				sb.append(SDPATH).append(storePath).append("/");
			}
			sb.append(fileName);
		} else {
			sb.append(RAMPATH).append("/").append(storePath).append("/").append(fileName);
		}
		File file = new File(sb.toString());
		if (file.exists()) {
			if (file.delete()) {
				FileSerialInfo serialInfo = (FileSerialInfo) readObject("fileSeiralInfo");
				if (null != serialInfo && serialInfo.cachedSize >= 0) {
					frm.removeFile(fileName);
				}
			}
		}
	}

	/**
	 * 在SDCARD中创建文件
	 * 
	 * @param fileName
	 * @return
	 * @throws IOException
	 */
	protected File createSDFile(String fileName) throws IOException {
		fileName = MD5.md5(fileName);
		File file = new File(fileName);
		if (file.exists()) {
			file.delete();
		}
		try {
			file.createNewFile();
		} catch (IOException e) {
			executeCreateDir();
			createSDFile(fileName);
		}
		return file;
	}

	/**
	 * 创建目录
	 * 
	 * @param dirName
	 * @return
	 */
	protected File createDir(String dirName) {
		File dir = new File(dirName);
		if (!dir.exists()) {
			dir.mkdirs();
		}
		return dir;
	}

	/**
	 * 检查文件是否存在于sd卡或ram中
	 * 
	 * @param fileName
	 * @return
	 */
	protected boolean isFileExistSDCardOrRam(String fileName) {
		fileName = MD5.md5(fileName);
		StringBuilder sb = new StringBuilder();
		// if(storePlace.equals("outer")){
		if (FileUtils.isSDCardExist()) {
			if (Build.VERSION.SDK_INT >= 8) {
				String cacheDir = "Android/data/" + J_SDK.getContext().getPackageName() + "/";
				sb.append(SDPATH).append(cacheDir).append(storePath).append("/");
			} else {
				sb.append(SDPATH).append(storePath).append("/");
			}
			sb.append(fileName);
		} else {
			sb.append(RAMPATH).append("/").append(storePath).append("/").append(fileName);
		}
		File file = new File(sb.toString());
		return file.exists();
	}

	/**
	 * 获取存储文件目录
	 * 
	 * @return
	 */
	public String getFileStorePath() {
		StringBuilder sb = new StringBuilder();
		if (FileUtils.isSDCardExist()) {
			if (Build.VERSION.SDK_INT >= 8) {
				String cacheDir = "Android/data/" + J_SDK.getContext().getPackageName() + "/";
				sb.append(SDPATH).append(cacheDir).append(storePath).append("/");
			} else {
				sb.append(SDPATH).append(storePath).append("/");
			}
		} else {
			sb.append(RAMPATH).append("/").append(storePath).append("/");
		}

		return sb.toString();
	}

	/**
	 * check file exist on SDCARD and RAM
	 * 
	 * @param fileName
	 * @return
	 */
	public File isFileExistSDCardAndRam(String fileName, String type) {
		if (type != null && type.length() > 0) {
			fileName = MD5.md5(fileName) + type;
		} else {
			fileName = MD5.md5(fileName);
		}
		StringBuilder sb = new StringBuilder();
		if (FileUtils.isSDCardExist()) {
			if (Build.VERSION.SDK_INT >= 8) {
				String cacheDir = "Android/data/" + J_SDK.getContext().getPackageName() + "/";
				sb.append(SDPATH).append(cacheDir).append(storePath).append("/");
			} else {
				sb.append(SDPATH).append(storePath).append("/");
			}
			sb.append(fileName);
			File file = new File(sb.toString());
			if (file.exists()) {
				return file;
			}
		}
		sb = new StringBuilder();
		sb.append(RAMPATH).append("/").append(storePath).append("/").append(fileName);
		File file = new File(sb.toString());
		if (file.exists()) {
			return file;
		} else {
			return null;
		}
	}

	/**
	 * 获取文件在本地存储的地址
	 * 
	 * */
	public String getFileSdcardAndRamPath(String fileName) {
		fileName = MD5.md5(fileName);
		StringBuilder sb = new StringBuilder();
		if (FileUtils.isSDCardExist()) {
			if (Build.VERSION.SDK_INT >= 8) {
				String cacheDir = "Android/data/" + J_SDK.getContext().getPackageName() + "/";
				sb.append(SDPATH).append(cacheDir).append(storePath).append("/");
			} else {
				sb.append(SDPATH).append(storePath).append("/");
			}
			sb.append(fileName);
			File file = new File(sb.toString());
			if (file.exists()) {
				return sb.toString();
			}
		}
		sb = new StringBuilder();
		sb.append(RAMPATH).append("/").append(storePath).append("/").append(fileName);

		File file = new File(sb.toString());
		if (file.exists()) {
			return sb.toString();
		} else {
			return null;
		}
	}

	/**
	 * 获取文件在本地存储的地址
	 * 
	 * */
	public String getFileSdcardAndRamPath(String fileName, String type) {
		fileName = MD5.md5(fileName) + type;
		StringBuilder sb = new StringBuilder();
		if (FileUtils.isSDCardExist()) {
			if (Build.VERSION.SDK_INT >= 8) {
				String cacheDir = "Android/data/" + J_SDK.getContext().getPackageName() + "/";
				sb.append(SDPATH).append(cacheDir).append(storePath).append("/");
			} else {
				sb.append(SDPATH).append(storePath).append("/");
			}
			sb.append(fileName);
			File file = new File(sb.toString());
			if (file.exists()) {
				return sb.toString();
			}
		}
		sb = new StringBuilder();
		sb.append(RAMPATH).append("/").append(storePath).append("/").append(fileName);

		File file = new File(sb.toString());
		if (file.exists()) {
			return sb.toString();
		} else {
			return null;
		}
	}

	/**
	 * 获取文件在本地存储的地址
	 * 
	 * 仅获取地址，不检查文件的存在与否
	 * */
	public String getFileSdcardAndRamPathOnly(String fileName, String type) {
		if (type != null && type.length() > 0) {
			fileName = MD5.md5(fileName) + type;
		} else {
			fileName = MD5.md5(fileName);
		}

		StringBuilder sb = new StringBuilder();
		if (FileUtils.isSDCardExist()) {
			if (Build.VERSION.SDK_INT >= 8) {
				String cacheDir = "Android/data/" + J_SDK.getContext().getPackageName() + "/";
				sb.append(SDPATH).append(cacheDir).append(storePath).append("/");
			} else {
				sb.append(SDPATH).append(storePath).append("/");
			}
			sb.append(fileName);
		} else {
			sb = new StringBuilder();
			sb.append(RAMPATH).append("/").append(storePath).append("/").append(fileName);
		}
		// 在指定目录中创建一个新的空文件，使用给定的前缀和后缀字符串生成其名称。
		try {
			File newFile = new File(sb.toString());
			if (!newFile.exists()) {
				newFile.createNewFile();
			}
		} catch (Exception e) {
		}

		return sb.toString();
	}

	/**
	 * execute append data
	 * 
	 * @param path
	 * @param fileName
	 * @param input
	 * @return
	 */
	protected boolean doAppendFile(String path, String fileName, byte[] input, int offset, int count, long availableSize,
			OutputStream output) throws IOException {
		boolean successFlag = true;
		try {
			// output = new FileOutputStream(path, true);
			int readLen = count;
			long currentCacheSize = frm.getCurrentCacheSize();
			if (availableSize < FileUtils.SDCARD_ALERT_SIZE
					|| currentCacheSize + readLen > FileUtils.APP_CACHE_SIZE * 1024 * 1024) {
				if (!frm.removeOldFiles(readLen)) {
					successFlag = false; // there is not enough space to save
											// files
				}
			}
			if (successFlag) {
				output.write(input, offset, count);
			}
			output.flush();
		} catch (IOException e) {
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return successFlag;
	}

	/**
	 * write file with no serialiable
	 * 
	 * @param path
	 * @param fileName
	 * @param input
	 * @return
	 */
	protected void writeFileNoSerial(String path, Object o) throws IOException {
		OutputStream output = null;
		try {
			output = new FileOutputStream(new File(path));
			ObjectOutputStream oos = new ObjectOutputStream(output);
			oos.writeObject(o);
			oos.flush();
			output.flush();
			oos.close();
		} catch (IOException e) {
			throw e;
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			try {
				if (output != null) {
					output.close();
				}
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * get inputStream from file
	 * 
	 * @param fileName fileName
	 * @return inputStream
	 */
	protected InputStream getFile(String path) {
		MyFileInputStream is = null;
		try {
			is = new MyFileInputStream(path);
			is.sync = this;
		} catch (FileNotFoundException e) {
			is = null;
		}
		return is;
	}

	/**
	 * 
	 * 在SDCARD 或 RAM中创建文件目录
	 * 
	 */
	protected void executeCreateDir() {
		StringBuilder sb = new StringBuilder();
		StringBuilder sbUnclear = new StringBuilder();
		if (FileUtils.isSDCardExist()) { // check sdCard exist
			if (Build.VERSION.SDK_INT >= 8) {
				String cacheDir = "Android/data/" + J_SDK.getContext().getPackageName() + "/";
				sb.append(SDPATH).append(cacheDir).append(storePath);
			} else {
				sb.append(SDPATH).append(storePath);
			}
			createDir(sbUnclear.toString());
			createDir(sb.toString());
		}

		// 在ram中创建文件目录
		sb = new StringBuilder();
		sbUnclear = new StringBuilder();

		sb.append(RAMPATH).append("/").append(storePath);

		createDir(sbUnclear.toString());
		createDir(sb.toString());
	}

	// listener SDCard status
	private void registerSDCardListener() {
		IntentFilter intentFilter = new IntentFilter(Intent.ACTION_MEDIA_MOUNTED);
		intentFilter.addAction(Intent.ACTION_MEDIA_SCANNER_STARTED);
		intentFilter.addAction(Intent.ACTION_MEDIA_SCANNER_FINISHED);
		intentFilter.addAction(Intent.ACTION_MEDIA_REMOVED);
		intentFilter.addAction(Intent.ACTION_MEDIA_UNMOUNTED);
		intentFilter.addAction(Intent.ACTION_MEDIA_BAD_REMOVAL);
		intentFilter.addDataScheme("file");
		J_SDK.getContext().registerReceiver(sdcardListener, intentFilter);
	}

	private final BroadcastReceiver sdcardListener = new BroadcastReceiver() {
		@Override
		public void onReceive(Context context, Intent intent) {
			isStorageReset = true;
			executeCreateDir();
			frm.init();
		}
	};

	/**
	 * 删除/filestores/目录下文件
	 * 
	 */
	public void deleteFilesInFileStore() {
		StringBuilder sb = new StringBuilder();
		if (FileUtils.isSDCardExist()) {
			if (Build.VERSION.SDK_INT >= 8) {
				String cacheDir = "Android/data/" + J_SDK.getContext().getPackageName() + "/";
				sb.append(SDPATH).append(cacheDir).append(storePath);
			} else {
				sb.append(SDPATH).append(storePath);
			}
		} else {
			sb.append(RAMPATH).append("/").append(storePath);
		}
		File file = new File(sb.toString());
		if (file.isDirectory()) {
			File[] files = file.listFiles();
			if (files != null && files.length > 0) {
				for (int i = 0; i < files.length; i++) {
					File oneFile = files[i];
					oneFile.delete();
				}
			}
		}
	}

	/**
	 * check outer file
	 * 
	 */
	public synchronized void checkOuterFiles() {
		try {
			StringBuilder sb = new StringBuilder();
			if (FileUtils.isSDCardExist()) {
				if (Build.VERSION.SDK_INT >= 8) {
					String cacheDir = "Android/data/" + J_SDK.getContext().getPackageName() + "/";
					sb.append(SDPATH).append(cacheDir).append(storePath);
				} else {
					sb.append(SDPATH).append(storePath);
				}
			} else {
				sb.append(RAMPATH).append("/").append(storePath);
			}
			File file = new File(sb.toString());
			if (file.isDirectory()) {
				File[] files = file.listFiles();
				if (files != null && files.length > 0) {
					int index = 0;
					for (int i = 0; i < files.length; i++) {
						if (!isAppRunning) {
							break;
						}
						File oneFile = files[i];
						// oneFile.delete();
						String checkFileName = oneFile.getName();
						if (checkFileName.equals(MD5.md5(frm.fileSeiralInfo)))
							continue;
						boolean isExsit = false;
						List<DataRecord<String>> temp = new ArrayList<DataRecord<String>>();
						temp.addAll(frm.fileList);
						for (DataRecord<String> dr : temp) {
							if (checkFileName.equals(MD5.md5(dr.fileName))) {
								isExsit = true;
								break;
							}
						}
						index++;
						if (!isExsit) {
							oneFile.delete();
						}
						if (index >= 20) {
							synchronized (this) {
								try {
									J_Log.i("ipk-test", "wait 5 sec!");
									this.wait(5000);
									index = 0;
								} catch (InterruptedException e) {
								}
							}
						}
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	/**
	 * 对一个文件重命名
	 * 
	 * */
	public synchronized void renameFile(String oldName, String newName, String type) {
		File oldFileName = isFileExistSDCardAndRam(oldName, type);
		String newFileNameUri = getFileSdcardAndRamPathOnly(newName, type);
		if (oldFileName != null) {
			File newFileName = new File(newFileNameUri);
			oldFileName.renameTo(newFileName);
		}
	}

	/**
	 * @Title: storeImage
	 * @Description: 保存图片到本地
	 * @return boolean 保存状态
	 * @param fileName 文件名
	 * @param context 上下文环境
	 * 
	 * @param mHandler 0x405:存储卡空间不足，0x404:没有sd卡，0x102：保存成功，0x103：保存失败
	 * @author donglizhi
	 * @throws
	 */
	public void storeImageToLocal(Context mContext, Bitmap b, String fileName, Handler mHandler) throws IOException {
		Message msg = new Message();
		msg.obj = J_SDK.getContext();
		// 存储卡不存在
		if (!FileUtils.isSDCardExist()) {
			msg.what = 0x404;
			mHandler.sendMessage(msg);
			return;
		}
		// 存储空间不足
		if (b != null && (J_CommonUtils.getBitmapSize(b) > J_CommonUtils.getAvailaleSize())) {
			msg.what = 0x405;
			mHandler.sendMessage(msg);
			return;
		}
		boolean reset = isStorageReset;
		boolean isSuccess = true;

		String albumPath = saveImagePath();
		String md5Name = MD5.md5(fileName); // 对图片地址进行md5加密
		String tmp = albumPath + "img-" + md5Name + ".jpg";
		// 创建新文件
		File file = new File(tmp);
		if (file.exists()) {
			file.delete();
		}
		file.createNewFile();

		if (!reset) {
			isSuccess = false;
		} else {
			ByteArrayOutputStream bos = new ByteArrayOutputStream();
			int options = 100;
			b.compress(CompressFormat.PNG, 100, bos);
			int size = 100;
			if (J_NetUtil.isWIFINetWork(J_SDK.getContext())) {
				size = 300;
			}
			while (bos.toByteArray().length / 1024 > size) {
				bos.reset();
				options -= 10;
				b.compress(Bitmap.CompressFormat.JPEG, options, bos);
			}
			byte[] bitmapdata = bos.toByteArray();
			OutputStream os = null;
			try {
				os = new FileOutputStream(tmp);
				os.write(bitmapdata);
				os.flush();
				isSuccess = true;
				// 保存成功，扫描目录，更新图片
				Intent mediaScanIntent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
				Uri contentUri = Uri.fromFile(file);
				mediaScanIntent.setData(contentUri);
				J_SDK.getContext().sendBroadcast(mediaScanIntent);

				// 回调
				msg.what = 0x102;
				mHandler.sendMessage(msg);
			} catch (IOException e) {
				isSuccess = false;
				// 保存失败
				msg.what = 0x103;
				mHandler.sendMessage(msg);
				throw e;
			} finally {
				J_CommonUtils.close(os);
			}
		}

		if (reset && !isSuccess) {
			isStorageReset = false;
		}
	}

	/**
	 * 保存图片的本地路径
	 * 
	 * @return String 图片路径
	 * @author donglizhi
	 * @throws
	 */
	public String saveImagePath() {
		StringBuilder sb = new StringBuilder();
		String imageDir = J_LibsConfig.FILE_STORE_ROOT_PATH;
		if (FileUtils.isSDCardExist()) {
			sb.append(SDPATH).append(imageDir);
		} else {
			sb.append(RAMPATH).append("/").append(imageDir);
		}

		// 创建目录
		createDir(sb.toString());

		return sb.toString();
	}
}
