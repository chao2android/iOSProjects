package com.iyouxun.ui.views;

import android.widget.GridView;

/***
 * 不滑动的GridView，被嵌套时使用
 * 
 * @author Administrator
 * 
 */
public class NotScollGridView extends GridView {
	public NotScollGridView(android.content.Context context, android.util.AttributeSet attrs) {
		super(context, attrs);
	}

	/**
	 * 设置不滚动
	 */
	@Override
	public void onMeasure(int widthMeasureSpec, int heightMeasureSpec) {
		int expandSpec = MeasureSpec.makeMeasureSpec(Integer.MAX_VALUE >> 2, MeasureSpec.AT_MOST);
		super.onMeasure(widthMeasureSpec, expandSpec);
	}

}