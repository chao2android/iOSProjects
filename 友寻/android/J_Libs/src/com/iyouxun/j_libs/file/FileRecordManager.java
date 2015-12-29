package com.iyouxun.j_libs.file;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import android.content.Context;

import com.iyouxun.j_libs.managers.J_FileManager;

/**
 * file cache record. thread safe impl.
 * 
 * @author iceqi
 * 
 */
public class FileRecordManager {
	protected String fileSeiralInfo = "fileSeiralInfo";
	protected List<DataRecord<String>> fileList; // file list info
	protected Map<String, DataRecord<String>> tempFiles = new ConcurrentHashMap<String, DataRecord<String>>();
	protected long cachedSize; // cachesize
	protected FileSerialInfo fsi; // file serialiable info
	protected volatile long currentCacheSize;
	public Context ctx;

	public long getCurrentCacheSize() {
		return currentCacheSize;
	}

	public void setCurrentCacheSize(long current) {
		currentCacheSize = current;
	}

	/**
	 * init data
	 */
	public void init() {
		fsi = (FileSerialInfo) J_FileManager.getInstance().getFileStore().readObject(fileSeiralInfo);
		if (null == fsi) {
			fsi = new FileSerialInfo();
		}
		cachedSize = fsi.cachedSize;
		currentCacheSize = cachedSize;
		// fileList = (ArrayList<DataRecord<String>>)readObject(fileInfoName);
		fileList = fsi.fileList;
		if (null == fileList) {
			fileList = new ArrayList<DataRecord<String>>();
		}
	}

	/**
	 * call when write failed to clear any record related to the failed file
	 * 
	 * @param fileName
	 */
	public void writeFailed(String fileName) {
		tempFiles.remove(fileName);
	}

	/**
	 * call when write finished
	 * 
	 * @param fileName
	 */
	public void writeFinished(String fileName) {
		DataRecord<String> f = tempFiles.remove(fileName);
		addRecord(f);
	}

	/**
	 * append writing file length. this is only to record the length until call
	 * writeFinished or writeFailed
	 * 
	 * @param fileName
	 * @param fileLength
	 */
	public void writeFile(String fileName, long fileLength) {
		DataRecord<String> f = tempFiles.get(fileName);
		if (f == null) {
			f = new DataRecord<String>();
			f.fileName = fileName;
			tempFiles.put(fileName, f);
		}

		if (f.fileLength == null) {
			f.fileLength = fileLength;
		} else {
			f.fileLength += fileLength;
		}
	}

	/**
	 * add record to store
	 * 
	 * @param record
	 */
	protected void addRecord(DataRecord<String> record) {
		if (record.fileLength != null) {
			currentCacheSize += record.fileLength;
		}
		fileList.add(record);
		writeDataStore();
	}

	/**
	 * to write record to file
	 */
	protected synchronized void writeDataStore() {
		fsi.fileList = fileList;
		fsi.cachedSize = currentCacheSize;
		try {
			J_FileManager.getInstance().getFileStore().storeFileNoSerial(fsi, fileSeiralInfo);
		} catch (IOException e) {
			// no need log
		}
	}

	/**
	 * to remove a file record
	 * 
	 * @param fileName
	 */
	public void removeFile(String fileName) {
		for (DataRecord<String> f : fileList) {
			if (f.fileName.equalsIgnoreCase(fileName)) {
				fileList.remove(f);
				if (f.fileLength != null) {
					currentCacheSize -= f.fileLength;
				}
				writeDataStore();
				return;
			}
		}
	}

	/**
	 * remove old files util cachedSize low app_cache_size
	 * 
	 * @param cacheSize : cacheing File size
	 * @param appCacheSize : the max cache size
	 */

	public boolean removeOldFiles(long addLength) {
		boolean removeFlag = true;
		boolean isDelete = false;
		while (currentCacheSize + addLength > FileUtils.APP_CACHE_SIZE * 1024 * 1024) {
			if (fileList.size() <= 0) {
				isDelete = true;
				currentCacheSize = 0;
				new Thread(new Runnable() {
					@Override
					public void run() {
						J_FileManager.getInstance().getFileStore().deleteFilesInFileStore();
					}
				}).start();
				if (FileUtils.isSDCardExist()) {
					if (currentCacheSize + addLength > FileUtils.SDCARD_ALERT_SIZE * 1024 * 1024) {
						removeFlag = false;
						break;
					}
				} else {
					if (currentCacheSize + addLength > FileUtils.RAM_ALERT_SIZE * 1024 * 1024) {
						removeFlag = false;
						break;
					}
				}
				break;
			}
			DataRecord<String> dr = fileList.get(0);
			if (null != dr) {
				J_FileManager.getInstance().getFileStore().requestFile(dr.fileName);// 删除旧文件
			}
			fileList.remove(0);
		}
		if (!isDelete) {
			writeDataStore();
		}

		return removeFlag;
	}

}
