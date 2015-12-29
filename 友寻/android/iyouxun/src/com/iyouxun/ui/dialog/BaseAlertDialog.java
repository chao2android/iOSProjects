package com.iyouxun.ui.dialog;

import android.app.AlertDialog;
import android.content.Context;
import android.widget.Toast;

public class BaseAlertDialog extends AlertDialog {
	private final Context context;

	protected BaseAlertDialog(Context context) {
		super(context);
		this.context = context;
	}

	protected BaseAlertDialog(Context context, boolean cancelable, OnCancelListener cancelListener) {
		super(context, cancelable, cancelListener);
		this.context = context;
	}

	protected BaseAlertDialog(Context context, int theme) {
		super(context, theme);
		this.context = context;
	}

	public String getString(int id) {
		return context.getResources().getString(id);
	}

	public void showToast(int id) {
		Toast.makeText(getContext(), getString(id), Toast.LENGTH_SHORT).show();
	}

}
