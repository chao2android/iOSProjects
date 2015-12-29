package com.iyouxun.j_libs.dao;

import android.view.View;
import android.view.View.OnClickListener;

public abstract class J_OnViewClickListener implements OnClickListener {
	
	private long lastEventTime = 0 ;
	private long currentEventTime = 0 ;
	private int interval = 100 ;
	@Override
	public void onClick(View v) {
		currentEventTime = System.currentTimeMillis();
		
		if(currentEventTime - lastEventTime < interval ){
			return ;
		}else{
			lastEventTime = currentEventTime ;
			onViewClick(v);
		}
	}
	
	public abstract void onViewClick(View view);
	

}
