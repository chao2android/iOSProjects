package com.iyouxun.utils;

import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.Rect;
import android.util.AttributeSet;
import android.util.DisplayMetrics;
import android.widget.ProgressBar;

public class MyProgressBar extends ProgressBar {
	private String text_title;
	private Paint mPaint;// 画笔

	public MyProgressBar(Context context) {
		super(context);
		initPaint();
	}

	public MyProgressBar(Context context, AttributeSet attrs) {
		super(context, attrs);
		initPaint();
	}

	public MyProgressBar(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		initPaint();
	}

	@Override
	public synchronized void setProgress(int progress) {
		super.setProgress(progress);
	}

	@Override
	protected synchronized void onDraw(Canvas canvas) {
		super.onDraw(canvas);
		if (!Util.isBlankString(this.text_title)) {
			Rect rect = new Rect();
			this.mPaint.getTextBounds(this.text_title, 0, this.text_title.length(), rect);
			int x = (getWidth() / 2) - rect.centerX();
			int y = (getHeight() / 2) - rect.centerY();
			canvas.drawText(this.text_title, x, y, this.mPaint);
		}
	}

	private void initPaint() {
		DisplayMetrics dm = getResources().getDisplayMetrics();
		float value = dm.scaledDensity;
		this.mPaint = new Paint();
		this.mPaint.setAntiAlias(true);
		this.mPaint.setColor(Color.WHITE);
		this.mPaint.setTextSize(14 * value);// 这里用的是像素值
	}

	public void setText(String text) {
		this.text_title = text;
	}

}