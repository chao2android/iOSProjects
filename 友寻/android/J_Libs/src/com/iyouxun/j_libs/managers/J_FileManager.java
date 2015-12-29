package com.iyouxun.j_libs.managers;

import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.file.FileRecordManager;
import com.iyouxun.j_libs.file.FileStore;

public class J_FileManager {
	private static J_FileManager self = null;
	private FileStore fileStore;
	private FileRecordManager frm;

	private J_FileManager() {
	}

	public static J_FileManager getInstance() {
		if (self == null) {
			self = new J_FileManager();
		}
		return self;
	}

	public FileStore getFileStore() {
		if (fileStore == null) {
			fileStore = new FileStore();
			try {
				fileStore.init();
			} catch (Exception e) {
				// TODO: handle exception
			}
		}
		return fileStore;
	}

	public FileRecordManager getFileRecordManager() {
		if (frm == null) {
			frm = new FileRecordManager();
			frm.ctx = J_SDK.getContext();
			fileStore = getFileStore();
			frm.init();
		}
		return frm;
	}
}
