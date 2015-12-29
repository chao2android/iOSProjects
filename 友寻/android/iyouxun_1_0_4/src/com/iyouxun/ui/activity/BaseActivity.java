package com.iyouxun.ui.activity;

import android.content.Context;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v4.app.FragmentActivity;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.j_libs.managers.J_PageManager;
import com.iyouxun.location.J_LocationManager;
import com.iyouxun.utils.DLog;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.FileUtil;
import com.iyouxun.utils.LoadingHandler;
import com.iyouxun.utils.SharedPreUtil;
import com.iyouxun.utils.Util;
import com.umeng.analytics.MobclickAgent;

public abstract class BaseActivity extends FragmentActivity {
	private Thread mUiThread;
	protected Context mContext;
	protected int GLOBAL_SCREEN_WIDTH; // 屏幕宽度
	protected int GLOBAL_SCREEN_HEIGHT;// 屏幕高度

	@Override
	protected void onCreate(Bundle arg0) {
		super.onCreate(arg0);

		mContext = this;
		mUiThread = Thread.currentThread();

		// 自定义全局变量
		GLOBAL_SCREEN_WIDTH = Util.getScreenWidth(this);
		GLOBAL_SCREEN_HEIGHT = Util.getScreenHeight(this);

		J_PageManager.getInstance().addPage(this);
		// 添加未登录的页面，用于登陆后finish()操作
		if (SharedPreUtil.getLoginInfo() == null || SharedPreUtil.getLoginInfo().uid <= 0) {
			DLog.d("likai-test", "baseActivity---添加登陆前页面");
			J_PageManager.getInstance().addBeforeLoginPage(this);
		}

		J_Application.sCurrentActiviy = this;

		// 设置过渡动画（进入时的过渡动画）
		overridePendingTransition(R.anim.slide_in_right, R.anim.slide_out_left);
	}

	/**
	 * 关闭退出
	 * 
	 * @return void 返回类型
	 * @param 参数类型
	 * @author likai
	 */
	public void exit() {
		new AsyncTask<Void, Void, Void>() {
			@Override
			protected Void doInBackground(Void... params) {
				FileUtil.deleteTimePhoto();
				return null;
			}
		}.execute();
		// 销毁所有的activity
		J_PageManager.getInstance().finishAllPage();
		// 关闭定位
		J_LocationManager.getInstance().destroy();
		// 关闭应用
		System.exit(0);
	}

	@Override
	public void finish() {
		super.finish();
		dismissLoading();
		// 关闭时的过渡动画
		overridePendingTransition(R.anim.slide_in_left, R.anim.slide_out_right);
	}

	/**
	 * 获取当前类的类名（如：MainPageActivity）
	 * 
	 * @return String 返回类型
	 * @param @return 参数类型
	 * @author likai
	 */
	public String getLTag() {
		return this.getClass().getSimpleName();
	}

	public static interface OnActivityResultListener {
		public void onActivityResult(int requestCode, int resultCode, Intent data);
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
	}

	/**
	 * 显示加载中的状态
	 * 
	 * @param msg 加载文字
	 * @param group 当前的View
	 */
	public void showLoading(String msg) {
		// 先关闭原有的dialog
		DialogUtils.dismissDialog();
		// 展示新dialog
		DialogUtils.showProgressDialog(this, msg);
	}

	public void showLoading(int res) {
		showLoading(getString(res));
	}

	public void showLoading() {
		showLoading(LoadingHandler.DEFALT_STR);
	}

	/***
	 * 取消显示加载中
	 */
	public void dismissLoading() {
		DialogUtils.dismissDialog();
	}

	/**
	 * 在主线程中执行Runnable
	 * 
	 * @return void 返回类型
	 * @param runnable 参数类型
	 * @author likai
	 */
	public void post(Runnable runnable) {
		if (Thread.currentThread() != mUiThread) {
			runOnUiThread(runnable);
		} else {
			runnable.run();
		}
	}

	/**
	 * 获取context
	 * 
	 * @return Context 返回类型
	 * @param @return 参数类型
	 * @author likai
	 */
	protected Context getContext() {
		return this;
	}

	@Override
	protected void onResume() {
		super.onResume();
		// 统计页面
		MobclickAgent.onPageStart(getClass().getName());
		// 统计时长
		MobclickAgent.onResume(this);
	}

	@Override
	protected void onPause() {
		super.onPause();
		// 统计页面
		MobclickAgent.onPageEnd(getClass().getName());
		// 统计时长
		MobclickAgent.onPause(this);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		J_PageManager.getInstance().finishPage(this);
	}

	// float startX = 0;
	// float startY = 0;
	//
	// @Override
	// public boolean dispatchTouchEvent(MotionEvent ev) {
	// Log.d("leif", this.getLocalClassName());
	// switch (ev.getAction()) {
	// case MotionEvent.ACTION_DOWN:
	// startX = ev.getX();
	// startY = ev.getY();
	// break;
	// case MotionEvent.ACTION_UP:
	// float endX = ev.getX();
	// int width = Util.getScreenWidth(mContext);
	// float endY = ev.getY();
	// if (endX - startX > width / 2 && Math.abs(endY - startY) < 150) {
	// DialogUtils.dismissDialog();
	// J_PageManager.getInstance().finishPage(this);
	// return true;
	// }
	// break;
	// case MotionEvent.ACTION_MOVE:
	// break;
	// }
	// return super.dispatchTouchEvent(ev);
	// }
}
