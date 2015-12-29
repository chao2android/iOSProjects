package com.iyouxun.data.beans;

/**
 * 共同好友搜索条件
 * 
 * @ClassName: SameFriendSearchBean
 * @author likai
 * @date 2015-3-31 下午2:32:32
 * 
 */
public class SameFriendSearchBean {
	/** 性别0：女，1：男，2：全部 */
	public int sex = 2;
	/** 情感状态 0：不限，1：单身 */
	public int marriage = 0;
	/** 类别 0：共同好友，1：他的好友 */
	public int type = 0;
	/** 好友数量 */
	public int num = 300;
}
