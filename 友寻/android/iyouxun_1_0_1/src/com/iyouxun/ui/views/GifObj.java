package com.iyouxun.ui.views;

import java.util.List;

public class GifObj {
	private final String gifID;
	private final List<GifTextDrawable> drawable;

	public GifObj(String gifID, List<GifTextDrawable> drawableList) {
		this.gifID = gifID;
		this.drawable = drawableList;
	}

	public String getGifId() {
		return this.gifID;
	}

	public List<GifTextDrawable> getGifTextDrawableList() {
		return this.drawable;
	}
}
