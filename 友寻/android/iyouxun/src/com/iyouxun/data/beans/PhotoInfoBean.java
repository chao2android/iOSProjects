package com.iyouxun.data.beans;

import java.io.Serializable;
import java.util.ArrayList;

import com.iyouxun.data.beans.users.BaseUser;

/**
 * 浏览图片的图片信息
 * 
 * @ClassName: PhotoInfoBean
 * @author likai
 * @date 2015-3-2 下午3:52:57
 * 
 */
public class PhotoInfoBean implements Serializable {
	/**
	 * @Fields serialVersionUID : TODO
	 */
	private static final long serialVersionUID = 8205972251509349599L;
	/** 图片大图url */
	public String url = "";

	/** 图片小图url */
	public String url_small = "";

	/** 图片path（url和path应该不会同时存在） */
	public String picPath = "";

	/** 图片描述 */
	public String title = "";

	/** 照片id */
	public String pid = "";

	/** 照片所有人的uid */
	public long uid;

	/** 照片所有人的nick */
	public String nick = "";

	/** 是否已经上传 0:否，1：是 */
	public int isUploaded = 0;

	/** 图片类型，0：普通（默认）1：动态中的图片 2:头像图片 */
	public int type = 0;

	/** 照片上传时间 */
	public long uploadTime = 0;

	/** 照片是否赞过0：未赞过，1：已赞 */
	public int isLike = 0;

	/** 赞的数量 */
	public int likeNum = 0;

	/** 赞的用户列表 */
	public ArrayList<BaseUser> likeUsers = new ArrayList<BaseUser>();
}
