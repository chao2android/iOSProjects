package com.iyouxun.data.beans;

/**
 * @ClassName: FilterIndirectBeans
 * @Description: 二度好友筛选数据
 * @author donglizhi
 * @date 2015年3月11日 下午7:59:55
 * 
 */
public class FilterIndirectBeans {
	private String text = "";// 数据
	private boolean selected;// 选中状态
	private int tagId;// 标签id

	public String getText() {
		return text;
	}

	public void setText(String text) {
		this.text = text;
	}

	public boolean isSelected() {
		return selected;
	}

	public void setSelected(boolean selected) {
		this.selected = selected;
	}

	public int getTagId() {
		return tagId;
	}

	public void setTagId(int tagId) {
		this.tagId = tagId;
	}
}
