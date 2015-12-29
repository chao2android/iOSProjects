/**
 * 
 * @Package com.iyouxun.data.beans
 * @author likai
 * @date 2015-4-28 上午10:22:49
 * @version V1.0
 */
package com.iyouxun.data.beans;

import java.io.Serializable;

/**
 * 
 * @author likai
 * @date 2015-4-28 上午10:22:49
 * 
 */
public class shareFriendsInfoBean implements Serializable {
	/**
	 * @Fields serialVersionUID : TODO
	 */
	private static final long serialVersionUID = -1139904586835250779L;
	/** 分享内容 */
	public String content = "";
	/** 分享图片path */
	public String imagePath = "";
	/** 分享类型1:求脱单，2：邀请好友认证，3：分享图片，4：分享给好友/帮他脱单 */
	public int shareType = -1;
	/** 分享连接 */
	public String url = "";
}
