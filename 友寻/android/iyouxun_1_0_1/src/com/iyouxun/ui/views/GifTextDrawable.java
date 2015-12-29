package com.iyouxun.ui.views;

import android.graphics.drawable.AnimationDrawable;
import android.graphics.drawable.Drawable;
import android.widget.TextView;

public class GifTextDrawable extends AnimationDrawable {
	private final TextView tv;
	private int curFrame = -1;
	private boolean Stop = false;

	public GifTextDrawable(TextView textView) {
		this.tv = textView;
	}

	@Override
	public void invalidateDrawable(Drawable who) {
		super.invalidateDrawable(who);
	}

	@Override
	public boolean selectDrawable(int idx) {
		curFrame = idx;
		return super.selectDrawable(idx);
	}

	@Override
	public void scheduleSelf(Runnable what, long when) {
		if (!Stop) {
			tv.postInvalidate();
			tv.postDelayed(this, this.getDuration(curFrame));
		}
	}

	@Override
	public void stop() {
		super.stop();
		Stop = true;
	}
}
