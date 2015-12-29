package com.iyouxun.j_libs.views;

import android.content.Context;
import android.support.v4.view.ViewPager;
import android.util.AttributeSet;
import android.view.MotionEvent;

public class AdvertPager extends ViewPager {
	
	private boolean IS_TOUCH_DOWN = false ;
	private long WHEN_TOUCH_UP = -1 ;
	
	public AdvertPager(Context context) {
		super(context);
	}
	public AdvertPager(Context context, AttributeSet attrs) {
		super(context, attrs);
		// TODO Auto-generated constructor stub
	}
	
	@Override
	public boolean dispatchTouchEvent(MotionEvent event) {
		getParent().requestDisallowInterceptTouchEvent(true);
		if(event.getAction() == MotionEvent.ACTION_DOWN || event.getAction() == MotionEvent.ACTION_MOVE){
			if(!IS_TOUCH_DOWN){
				IS_TOUCH_DOWN = true ;
			}
		}
		if(event.getAction() == MotionEvent.ACTION_UP){
			if(IS_TOUCH_DOWN){
				IS_TOUCH_DOWN = false ;
				WHEN_TOUCH_UP = System.currentTimeMillis();
			}
		}
		return super.dispatchTouchEvent(event);
	}
	
	
	public boolean isTouchDown(){
		return IS_TOUCH_DOWN ;
	}
	
	public long getTouchUpTime(){
		return WHEN_TOUCH_UP ;
	}

}
