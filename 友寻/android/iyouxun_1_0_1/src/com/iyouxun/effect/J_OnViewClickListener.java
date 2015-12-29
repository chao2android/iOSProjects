package com.iyouxun.effect;

import android.view.View;
import android.view.View.OnClickListener;

/**
 * 统一封装的点击事件入口
 * 
 * @author likai
 * @date 2014年12月2日 上午9:46:57
 */
public abstract class J_OnViewClickListener implements OnClickListener {
	// 上次点击时间时间戳
	private long lastEventTime = 0;
	// 当前点击时间时间戳
	private long currentEventTime = 0;
	// 两次按钮间隔（避免重复点击）
	private final int interval = 1500;

	@Override
	public void onClick(View v) {
		// 所有点击加音效
		switch (v.getId()) {
		default:
			// 默认点击音效
			// EffectsUtil.playClickEffect();
			break;
		}
		// 点击频率控制
		currentEventTime = System.currentTimeMillis();
		if (currentEventTime - lastEventTime < interval) {
			return;
		} else {
			lastEventTime = currentEventTime;
			onViewClick(v);
		}
	}

	public abstract void onViewClick(View v);
}
