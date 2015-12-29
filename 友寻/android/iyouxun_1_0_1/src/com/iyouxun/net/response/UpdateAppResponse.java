package com.iyouxun.net.response;

/** 更新程序返回 */
public class UpdateAppResponse {
	/** 1:提醒升级 2:强制升级 */
	public int retcode;
	/** 必须是整数-对内 */
	public int vercode;
	/** 下载地址 */
	public String url;
	/** 版本号-对外 */
	public String vername;
	/** 更新内容 */
	public String content;
}
