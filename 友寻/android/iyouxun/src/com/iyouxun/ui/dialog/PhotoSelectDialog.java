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
 * 图片上传选择弹窗
 * 
 * @ClassName: PhotoSelectDialog
 * @author likai
 * @date 2015-3-10 下午4:04:43
 * 
 */
public class PhotoSelectDialog extends Dialog {
	private Button button_select_camera;
	private Button button_select_album;
	private Button button_selece_cancel;

	private final Context mContext;
	private DialogUtils.OnSelectCallBack callBack;

	public PhotoSelectDialog(Context context, int theme) {
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
	public PhotoSelectDialog setCallBack(DialogUtils.OnSelectCallBack callBack) {
		this.callBack = callBack;
		return this;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dialog_photo_select);

		button_select_camera = (Button) findViewById(R.id.button_select_camera);
		button_select_album = (Button) findViewById(R.id.button_select_album);
		button_selece_cancel = (Button) findViewById(R.id.button_selece_cancel);

		// 设置显示位置
		Window window = getWindow();

		WindowManager.LayoutParams params = window.getAttributes();
		params.width = Util.getScreenWidth(mContext);
		params.height = WindowManager.LayoutParams.WRAP_CONTENT;
		window.setAttributes(params);
		window.setGravity(Gravity.BOTTOM);
		window.setWindowAnimations(R.style.AnimBottom); // 设置窗口弹出动画

		button_select_camera.setOnClickListener(listener);
		button_select_album.setOnClickListener(listener);
		button_selece_cancel.setOnClickListener(listener);

		// 点击外部区域不能关闭
		// setCanceledOnTouchOutside(false);
	}

	private final J_OnViewClickListener listener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.button_select_camera:
				// 选择相机
				callBack.onCallBack("1", null, null);
				dismiss();
				break;
			case R.id.button_select_album:
				// 选择相册
				callBack.onCallBack("2", null, null);
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
