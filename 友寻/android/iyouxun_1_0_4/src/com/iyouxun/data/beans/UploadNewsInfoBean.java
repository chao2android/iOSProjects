package com.iyouxun.data.beans;

import java.io.Serializable;
import java.util.ArrayList;

/**
 * 待上传的动态信息
 * 
 * @ClassName: UploadNewsInfoBean
 * @author likai
 * @date 2015-3-7 上午9:37:03
 * 
 */
public class UploadNewsInfoBean implements Serializable {
	/**
	 * @Fields serialVersionUID : TODO
	 */
	private static final long serialVersionUID = -1142557826558295051L;
	/** 动态文字信息 */
	public String content = "";
	/** 动态图片信息 */
	public ArrayList<PhotoInfoBean> photos = new ArrayList<PhotoInfoBean>();
	/** 图片id串 */
	public ArrayList<String> pids;
	/** 查看权限 */
	public NewsAuthInfoBean lookAuth = new NewsAuthInfoBean();
	/** 是否同步至相册（0：否（默认），1：是） */
	public int isSyncToAlbum = 0;
}
