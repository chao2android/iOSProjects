package com.iyouxun.data.beans;

/**
 * tag标签信息
 * 
 * @ClassName: TagsInfoBean
 * @author likai
 * @date 2015-3-2 下午7:52:09
 * 
 */
public class TagsInfoBean {
	/** 标签id */
	public String tid = "";
	/** 标签名称 */
	public String name = "";
	/** 标签点击数量 */
	public int clickNum = 0;
	/** 标签状态是否点击过(0：未确认，1：已确认) */
	public int isClicked = 0;
	/** 是否选中 0:未选中（待删除），1：选中 */
	public int isSelected = 1;
	/** 最后更新时间 */
	public long updateTime;
}
