/**
 * 
 * @Package com.iyouxun.ui.views
 * @author likai
 * @date 2015-6-11 下午2:15:24
 * @version V1.0
 */
package com.iyouxun.ui.views;

import android.graphics.Canvas;
import android.graphics.Paint;
import android.graphics.Paint.FontMetricsInt;
import android.graphics.RectF;
import android.text.style.ReplacementSpan;

import com.iyouxun.J_Application;
import com.iyouxun.R;

/**
 * 熟人圈页面 标签添加背景色
 * 
 * @author likai
 * @date 2015-6-11 下午2:15:24
 * 
 */
public class CustomBackgroundSpan extends ReplacementSpan {
	private final int backgroundColor;

	public CustomBackgroundSpan(int backgroundColor) {
		super();
		this.backgroundColor = backgroundColor;
	}

	@Override
	public int getSize(Paint paint, CharSequence text, int start, int end, FontMetricsInt fm) {
		return Math.round(paint.measureText(text, start, end));
	}

	@Override
	public void draw(Canvas canvas, CharSequence text, int start, int end, float x, int top, int y, int bottom, Paint paint) {
		// calculate new bottom position considering the fontSpacing
		float newBottom = bottom - 6;

		// change color and draw background highlight
		RectF rect = new RectF(x, top, x + paint.measureText(text, start, end), newBottom);
		paint.setColor(backgroundColor);
		canvas.drawRect(rect, paint);

		// revert color and draw text
		paint.setColor(J_Application.context.getResources().getColor(R.color.text_normal_white));
		canvas.drawText(text, start, end, x, y, paint);
	}

}