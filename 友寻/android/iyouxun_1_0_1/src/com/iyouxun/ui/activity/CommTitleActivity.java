package com.iyouxun.ui.activity;

import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.effect.J_OnViewClickListener;

/**
 * 有公共头的公共activity
 * 
 * @author likai
 * @date 2014年10月8日 下午1:11:53
 */
public abstract class CommTitleActivity extends BaseActivity {
	protected ViewGroup mRootView;
	protected Button titleLeftButton;// 左侧按钮
	protected Button titleRightButton;// 右侧按钮
	protected TextView titleCenter;// 中间文字

	@Override
	protected void onCreate(Bundle arg0) {
		super.onCreate(arg0);
		setContentView(R.layout.second_layout);

		/** 设置公共标题栏 */
		initTitleView();

		/** 设置右侧按钮名称和图标样式 */
		handleTitleViews(titleCenter, titleLeftButton, titleRightButton);

		mRootView = (ViewGroup) findViewById(R.id.layout_content);
		mRootView.addView(setContentView());

		initViews();
	}

	private void initTitleView() {
		// 标题左侧按钮
		titleLeftButton = (Button) findViewById(R.id.titleLeftButton);
		// 标题右侧按钮
		titleRightButton = (Button) findViewById(R.id.titleRightButton);
		// 中间文字
		titleCenter = (TextView) findViewById(R.id.titleCenter);

		// 左侧点击事件
		titleLeftButton.setOnClickListener(clickListener);
	}

	/** 设置公共头中的各元素的事件 */
	protected abstract void handleTitleViews(TextView titleCenter, Button titleLeftButton, Button titleRightButton);

	/** 设置加载页面的layout */
	protected abstract View setContentView();

	/** 初始化页面控件 */
	protected abstract void initViews();

	private final OnClickListener clickListener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.titleLeftButton:
				// 返回操作
				onBackPressed();
				break;
			}
		}
	};

	protected ViewGroup getRootView() {
		return mRootView;
	}

}
