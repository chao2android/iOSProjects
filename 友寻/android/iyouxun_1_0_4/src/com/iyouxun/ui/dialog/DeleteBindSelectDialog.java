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

/**
 * 解除绑定
 * 
 * @ClassName: DeleteBindSelectDialog
 * @author likai
 * @date 2015-3-12 下午2:59:15
 * 
 */
public class DeleteBindSelectDialog extends Dialog {
	private final Context mContext;
	private DialogUtils.OnSelectCallBack callBack;

	private Button button_select_unbind;
	private Button button_selece_cancel;

	public DeleteBindSelectDialog(Context context, int theme) {
		super(context, theme);
		mContext = context;
	}

	/**
	 * 设置回调方法
	 * 
	 * @Title: setCallBack
	 * @return PhotoSelectDialog 返回类型
	 * @param @param callBack
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public DeleteBindSelectDialog setCallBack(DialogUtils.OnSelectCallBack callBack) {
		this.callBack = callBack;
		return this;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dialog_delete_bind_select);

		// 设置显示位置
		Window window = getWindow();

		WindowManager.LayoutParams params = window.getAttributes();
		params.width = Util.getScreenWidth(mContext);
		params.height = WindowManager.LayoutParams.WRAP_CONTENT;
		window.setAttributes(params);
		window.setGravity(Gravity.BOTTOM);
		window.setWindowAnimations(R.style.AnimBottom); // 设置窗口弹出动画

		button_select_unbind = (Button) findViewById(R.id.button_select_unbind);
		button_selece_cancel = (Button) findViewById(R.id.button_selece_cancel);

		button_select_unbind.setOnClickListener(listener);
		button_selece_cancel.setOnClickListener(listener);

		// 点击外部区域不能关闭
		setCanceledOnTouchOutside(false);
	}

	private final J_OnViewClickListener listener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.button_select_unbind:
				// 解除绑定
				callBack.onCallBack("1", null, null);
				dismiss();
				break;
			case R.id.button_selece_cancel:
				// 取消
				dismiss();
				break;
			default:
				break;
			}
		}
	};
}
