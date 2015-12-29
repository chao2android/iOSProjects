package com.iyouxun.ui.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;

import com.iyouxun.R;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.Util;

public class ChatHelpDialog extends Dialog {
	private final Context mContext;
	private Button btnCopy;// 复制按钮
	private Button btnCancel;// 取消按钮
	private DialogUtils.OnSelectCallBack callBack;

	public ChatHelpDialog(Context context, boolean cancelable, OnCancelListener cancelListener) {
		super(context, cancelable, cancelListener);
		mContext = context;
	}

	public ChatHelpDialog(Context context, int theme) {
		super(context, theme);
		mContext = context;
	}

	public ChatHelpDialog(Context context) {
		super(context);
		mContext = context;
	}

	public void setCallBack(DialogUtils.OnSelectCallBack callBack) {
		this.callBack = callBack;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dialog_chat_help);
		btnCancel = (Button) findViewById(R.id.dialog_chat_cancel_button);
		btnCopy = (Button) findViewById(R.id.dialog_chat_copy_button);
		btnCancel.setOnClickListener(listener);
		btnCopy.setOnClickListener(listener);
		// 设置显示位置
		Window window = getWindow();
		WindowManager.LayoutParams params = window.getAttributes();
		params.width = Util.getScreenWidth(mContext);
		params.height = WindowManager.LayoutParams.WRAP_CONTENT;
		window.setAttributes(params);
		window.setGravity(Gravity.BOTTOM);
		window.setWindowAnimations(R.style.AnimBottom); // 设置窗口弹出动画
	}

	private final J_OnViewClickListener listener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.dialog_chat_cancel_button:
				// 取消
				dismiss();
				break;
			case R.id.dialog_chat_copy_button:
				// 复制
				callBack.onCallBack("1", null, null);
				dismiss();
				break;
			default:
				break;
			}
		}
	};
}
