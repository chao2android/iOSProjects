package com.iyouxun.ui.dialog;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface.OnCancelListener;
import android.view.Display;
import android.view.Gravity;
import android.view.View;
import android.view.WindowManager;

import com.iyouxun.R;

public class MyDialog {
	private Dialog mDialog;
	private boolean isOutsideCanceled = true;
	private boolean isCancelable = false;
	private View mContentView;
	private OnCancelListener listener;

	public Dialog showCustomDialog(Context context, View view) {
		return showCustomDialog(context, view, 0.8f, Gravity.CENTER, false);
	}

	public Dialog showCustomDialog(Context context, View view, boolean onWindow) {
		return showCustomDialog(context, view, 0.8f, Gravity.CENTER, onWindow);
	}

	/***
	 * 
	 * @param context
	 * @param view
	 * @param percent View 的最小宽度百分比
	 * @param gravity 显示的位置 {@link Gravity}
	 * @param onWindow 是否不依赖Activity显示
	 * @return
	 */
	public Dialog showCustomDialog(Context context, View view, float percent, int gravity, boolean onWindow) {
		mContentView = view;
		mDialog = new Dialog(context, R.style.dialog);
		mDialog.setCancelable(isCancelable);
		if (listener != null) {
			mDialog.setOnCancelListener(listener);
		}
		WindowManager m = mDialog.getWindow().getWindowManager();
		Display d = m.getDefaultDisplay();
		view.setMinimumWidth((int) (d.getWidth() * percent));
		mDialog.setContentView(view);
		mDialog.getWindow().setGravity(gravity);
		if (onWindow) {
			if (!(context instanceof Activity)) {
				mDialog.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_DIALOG);
				mDialog.getWindow().setType(WindowManager.LayoutParams.TYPE_SYSTEM_ALERT);
			}
		}
		mDialog.setCanceledOnTouchOutside(isOutsideCanceled);

		mDialog.show();
		return mDialog;
	}

	public void dismiss() {
		if (mDialog.isShowing()) {
			mDialog.dismiss();
		}
	}

	public void cancel() {
		if (mDialog.isShowing()) {
			mDialog.cancel();
		}
	}

	public void setOnCancelListener(OnCancelListener listener) {
		this.listener = listener;
	}

	public void setCanceledOnTouchOutside(boolean flage) {
		isOutsideCanceled = flage;
	}

	public void setCancelable(boolean isCancelable) {
		this.isCancelable = isCancelable;
	}

	public View getContentView() {
		return mContentView;
	}

	public boolean isShowing() {
		return mDialog != null && mDialog.isShowing();
	}
}
