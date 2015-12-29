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
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.Util;

/**
 * 图片浏览操作的弹出操作窗口
 * 
 * @ClassName: PhotoManageDialog
 * @author likai
 * @date 2015-3-10 下午3:59:24
 * 
 */
public class PhotoManageDialog extends Dialog {
	private final Context mContext;
	private DialogUtils.OnSelectCallBack callBack;

	private Button dialog_photo_share_button;
	private Button dialog_photo_save_button;
	private Button dialog_photo_report_button;
	private Button dialog_photo_delete_button;
	private Button dialog_photo_cancel_button;

	private View dialog_delimiter_line;
	// 当前操作人的uid（登录用户要展示删除按钮，非登录用户要隐藏删除按钮）
	private PhotoInfoBean photoData = new PhotoInfoBean();

	public PhotoManageDialog(Context context, int theme) {
		super(context, theme);
		mContext = context;
	}

	public PhotoManageDialog setCallBack(DialogUtils.OnSelectCallBack callBack) {
		this.callBack = callBack;
		return this;
	}

	/**
	 * 设置当前操作用户的uid
	 * 
	 * @Title: setUid
	 * @return PhotoManageDialog 返回类型
	 * @param @param uid
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public PhotoManageDialog setPhotoData(PhotoInfoBean photoData) {
		this.photoData = photoData;
		return this;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dialog_photo_manage);

		dialog_photo_share_button = (Button) findViewById(R.id.dialog_photo_share_button);
		dialog_photo_save_button = (Button) findViewById(R.id.dialog_photo_save_button);
		dialog_photo_report_button = (Button) findViewById(R.id.dialog_photo_report_button);
		dialog_photo_delete_button = (Button) findViewById(R.id.dialog_photo_delete_button);
		dialog_photo_cancel_button = (Button) findViewById(R.id.dialog_photo_cancel_button);
		dialog_delimiter_line = findViewById(R.id.dialog_delimiter_line);

		// 设置显示位置
		Window window = getWindow();

		WindowManager.LayoutParams params = window.getAttributes();
		params.width = Util.getScreenWidth(mContext);
		params.height = WindowManager.LayoutParams.WRAP_CONTENT;
		window.setAttributes(params);
		window.setGravity(Gravity.BOTTOM);
		window.setWindowAnimations(R.style.AnimBottom); // 设置窗口弹出动画

		// 点击外部区域不能关闭
		// setCanceledOnTouchOutside(false);

		if (photoData.type == 1) {
			// 动态中的图片浏览，不显示删除和举报按钮
			// 隐藏删除按钮
			dialog_photo_delete_button.setVisibility(View.GONE);
			// 隐藏举报按钮
			dialog_photo_report_button.setVisibility(View.GONE);
			// 隐藏分割线
			dialog_delimiter_line.setVisibility(View.GONE);
			// 保存图片按钮样式调整
			dialog_photo_save_button.setBackgroundResource(R.drawable.button_dialog_bottom_circular);
		} else if (photoData.type == 2) {
			// 用户头像查看，不显示举报
			dialog_photo_report_button.setVisibility(View.GONE);
		}

		if (photoData.uid != J_Cache.sLoginUser.uid) {
			// 非当前登录用户，要隐藏删除项
			dialog_photo_delete_button.setVisibility(View.GONE);
		} else {
			// 如果是当前登录用户，隐藏举报项
			dialog_photo_report_button.setVisibility(View.GONE);
		}
		// 查看是否有pid，没有pid，不允许举报
		if (Util.isBlankString(photoData.pid) || photoData.uid <= 0) {
			// 隐藏举报按钮
			dialog_photo_report_button.setVisibility(View.GONE);
		}

		// 如果删除按钮、举报按钮都为隐藏状态，调整保存按钮样式
		if (dialog_photo_delete_button.getVisibility() == View.GONE && dialog_photo_report_button.getVisibility() == View.GONE) {
			// 隐藏分割线
			dialog_delimiter_line.setVisibility(View.GONE);
			dialog_photo_save_button.setBackgroundResource(R.drawable.button_dialog_bottom_circular);
		}

		dialog_photo_share_button.setOnClickListener(listener);
		dialog_photo_save_button.setOnClickListener(listener);
		dialog_photo_report_button.setOnClickListener(listener);
		dialog_photo_delete_button.setOnClickListener(listener);
		dialog_photo_cancel_button.setOnClickListener(listener);
	}

	private final J_OnViewClickListener listener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.dialog_photo_share_button:
				// 分享
				callBack.onCallBack("1", null, null);
				dismiss();
				break;
			case R.id.dialog_photo_save_button:
				// 保存图片
				callBack.onCallBack("2", null, null);
				dismiss();
				break;
			case R.id.dialog_photo_report_button:
				// 举报
				callBack.onCallBack("3", null, null);
				dismiss();
				break;
			case R.id.dialog_photo_delete_button:
				// 删除
				callBack.onCallBack("4", null, null);
				dismiss();
				break;
			case R.id.dialog_photo_cancel_button:
				// 取消
				dismiss();
				break;
			default:
				break;
			}
		}
	};
}
