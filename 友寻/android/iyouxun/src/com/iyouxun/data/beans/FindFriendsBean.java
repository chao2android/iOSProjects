package com.iyouxun.data.beans;

public class FindFriendsBean {
	private int textId;// 内容
	private String count = "";// 好友数量
	private int imageId;// 图片id

	public int getTextId() {
		return textId;
	}

	public void setTextId(int textId) {
		this.textId = textId;
	}

	public String getCount() {
		return count;
	}

	public void setCount(String count) {
		this.count = count;
	}

	public int getImageId() {
		return imageId;
	}

	public void setImageId(int imageId) {
		this.imageId = imageId;
	}
}
