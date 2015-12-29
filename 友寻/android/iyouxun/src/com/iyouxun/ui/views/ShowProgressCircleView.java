package com.iyouxun.ui.views;

import com.iyouxun.R;
import android.annotation.SuppressLint;
import android.content.Context;
import android.content.res.TypedArray;
import android.graphics.Canvas;
import android.graphics.Color;
import android.graphics.Paint;
import android.graphics.RectF;
import android.util.AttributeSet;
import android.util.Log;
import android.view.View;

/** 展示圆形 扇形进度 */
public class ShowProgressCircleView extends View {
	private final static String TAG = "MYDIYView";
	/** 字体大小 */
	private float mTextSize = 14.0f;
	/** 字体颜色 */
	private int mTextColor = Color.YELLOW;
	/** 进度 控制扇形的形状 */
	private int mProcess = 10;
	/** 底部显示的文字 */
	private String mText = "what";
	/** 圆形 颜色 */
	private int mRoundColor = Color.RED;
	/** 扇形颜色 */
	private int mProcessColor = Color.BLUE;

	private Paint mPaint;

	public ShowProgressCircleView(Context context) {
		super(context);
		init();
	}

	public ShowProgressCircleView(Context context, AttributeSet attrs) {
		this(context, attrs, 0);
		init();
	}

	public ShowProgressCircleView(Context context, AttributeSet attrs, int mdel) {
		super(context, attrs, mdel);
		TypedArray ta = context.obtainStyledAttributes(attrs, R.styleable.ShowProgressCircleView);
		mTextSize = ta.getFloat(R.styleable.ShowProgressCircleView_textSize, sp2px(14.0f));
		mProcess = ta.getInt(R.styleable.ShowProgressCircleView_progress, 0);
		mRoundColor = ta.getColor(R.styleable.ShowProgressCircleView_roundColor, Color.TRANSPARENT);
		mProcessColor = ta.getColor(R.styleable.ShowProgressCircleView_progressColor, Color.BLUE);
		mTextColor = ta.getColor(R.styleable.ShowProgressCircleView_textcolor, Color.BLACK);

		init();

		ta.recycle();
	}

	private void init() {
		mPaint = new Paint();
		// 去掉锯齿
		mPaint.setAntiAlias(true);
		mPaint.setColor(Color.BLACK);
		// 只画边框
		mPaint.setStyle(Paint.Style.STROKE);
		// 画图线条粗细
		mPaint.setStrokeWidth(2);
	}

	private int centerX = 0;
	private int centerY = 0;

	@Override
	public void draw(Canvas canvas) {
		super.draw(canvas);
		Log.d(TAG, "draw------" + getBackground());
	}

	@SuppressLint("DrawAllocation")
	@Override
	protected void onDraw(Canvas canvas) {
		super.onDraw(canvas);

		centerX = getWidth() / 2;
		centerY = getWidth() / 2;

		Log.d(TAG, "+++++++onDraw------" + getBackground());

		// canvas.drawColor(Color.TRANSPARENT);

		// 画圆
		mPaint.setStyle(Paint.Style.STROKE);
		mPaint.setColor(mRoundColor);
		canvas.drawCircle(centerX, centerY, centerX, mPaint);

		// 画代表进度的扇形
		mPaint.setColor(mProcessColor);
		mPaint.setStyle(Paint.Style.FILL);
		RectF oval = new RectF(0, 0, getWidth() - 2, getWidth() - 2);

		float startAngle = 270.0f;
		float sweepAngle = mProcess * 3.6f;
		boolean useCenter = true;
		canvas.drawArc(oval, startAngle, sweepAngle, useCenter, mPaint);

		mPaint.setTextSize(mTextSize);
		mPaint.setColor(mTextColor);
		mText = mProcess + "%";
		canvas.drawText(mText, centerX - 3, centerY + 10, mPaint);
	}

	public void setTextSize(float textSize) {
		this.mTextSize = textSize;
	}

	public void setTextColor(int textColor) {
		this.mTextColor = textColor;
	}

	public void setProcess(int process) {
		this.mProcess = process;
	}

	public void setRonudColor(int roundColor) {
		this.mRoundColor = roundColor;
	}

	public void setProcessColor(int processColor) {
		this.mProcessColor = processColor;
	}

	public float dp2px(float dp) {
		final float scale = getResources().getDisplayMetrics().density;
		return dp * scale + 0.5f;
	}

	public float sp2px(float sp) {
		final float scale = getResources().getDisplayMetrics().scaledDensity;
		return sp * scale;
	}
}
