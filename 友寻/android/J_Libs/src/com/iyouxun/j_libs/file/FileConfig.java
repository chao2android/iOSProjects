package com.iyouxun.j_libs.file;


public class FileConfig {

	protected String storePeriod;
	protected String storePlace;
	protected String storePath;
	protected String unclearStorePath;

	public String getStorePeriod() {
		return storePeriod;
	}

	public void setStorePeriod(String storePeriod) {
		this.storePeriod = storePeriod;
	}

	public String getStorePlace() {
		return storePlace;
	}

	public void setStorePlace(String storePlace) {
		this.storePlace = storePlace;
	}

	public void setStorePath(String storePath) {
		this.storePath = storePath;
	}

	public String getStorePath() {
		return storePath;
	}

	/** 设置不被清除缓存的文件存储目录 */
	public void setUnclearStorePath(String unclearStorePath) {
		this.unclearStorePath = unclearStorePath;
	}

	/** 获取不被清除缓存的文件存储目录 */
	public String getUnclearStorePath() {
		return unclearStorePath;
	}

}
