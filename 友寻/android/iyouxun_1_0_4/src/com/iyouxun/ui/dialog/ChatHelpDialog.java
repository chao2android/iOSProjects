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
	public final static int COPY_MESSAGE = 1;// 复制文本消息
	public final static int VOICE_SWITCH_NORMAL = 2;// 扬声器模式
	public final static int VOICE_SWITCH_IN_CALL = 3;// 听筒模式
	private int type = 0;

	public ChatHelpDialog(Context context, int theme, int type) {
		super(context, theme);
		mContext = context;
		this.type = type;
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
		setButtonType(type);
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
				if (type == COPY_MESSAGE) {
					callBack.onCallBack("1", null, null);
				} else {// 切换声音模式
					callBack.onCallBack("2", null, null);
				}
				dismiss();
				break;
			default:
				break;
			}
		}
	};

	/**
	 * @Title: setButtonType
	 * @Description: 按钮类型
	 * @return void 返回类型
	 * @param @param type 参数类型
	 * @author donglizhi
	 * @throws
	 */
	private void setButtonType(int type) {
		switch (type) {
		case COPY_MESSAGE:// 复制文本消息
			btnCopy.setText(R.string.str_copy);
			break;
		case VOICE_SWITCH_NORMAL:// 切换听筒模式
			btnCopy.setText(R.string.switch_mode_in_call);
			break;
		case VOICE_SWITCH_IN_CALL:// 切换扬声器模式
			btnCopy.setText(R.string.switch_mode_normal);
			break;
		}
	}
}
