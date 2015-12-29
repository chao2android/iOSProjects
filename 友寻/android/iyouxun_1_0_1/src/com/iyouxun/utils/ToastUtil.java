package com.iyouxun.utils;

import android.app.Activity;
import android.content.Context;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.iyouxun.J_Application;
import com.iyouxun.R;

public class ToastUtil {
	private static Toast toast = null;

	/**
	 * 显示提示信息(系统默认样式)
	 * 
	 * public static void alert(Context curActivity, String content) {
	 * Toast.makeText(curActivity, content, Toast.LENGTH_SHORT).show(); }
	 * 
	 * 退出activity时取消toast
	 */
	public static void cancelToast() {
		if (toast != null) {
			toast.cancel();
		}
	}

	/**
	 * 自定义toast样式信息提示弹窗 从布局文件中加载布局并且自定义显示Toast
	 * 
	 * 这个不要改，一般不要使用这个，可改用下一个showToast()
	 */
	public static void showToastNative(Context context, String content) {
		// 获取LayoutInflater对象，该对象可以将布局文件转换成与之一致的view对象
		LayoutInflater inflater = ((Activity) context).getLayoutInflater();
		// 将布局文件转换成相应的View对象
		View layout = inflater.inflate(R.layout.toast_layout, null);
		// 从layout中按照id查找TextView对象
		TextView textView = (TextView) layout.findViewById(R.id.tvForToast);
		// 设置TextView的text内容
		textView.setText(content);
		// 实例化一个Toast对象
		Toast toast = new Toast(context);
		toast.setDuration(Toast.LENGTH_SHORT); // 设置显示时长
		// toast.setGravity(Gravity.BOTTOM, 0, 100);// 设置显示位置
		int ScreenWidth = Util.getScreenWidth(context);
		if (ScreenWidth <= 480) {
			toast.setGravity(Gravity.BOTTOM, 0, 165);
		} else {
			toast.setGravity(Gravity.BOTTOM, 0, 250);
		}
		toast.setView(layout);// 放入页面
		toast.show();
	}

	/**
	 * 自定义toast样式信息提示弹窗 从布局文件中加载布局并且自定义显示Toast
	 * 
	 * 这个不要改，一般不要使用这个，可改用下一个showToast()
	 */
	public static void showToast(Context context, String content) {
		showToast(context, content, 0);
	}

	/**
	 * 自定义toast样式信息提示弹窗 从布局文件中加载布局并且自定义显示Toast int position 0-底部，1-中部，2-顶部
	 * 
	 * @param 文本
	 * @param 内容
	 * @param 顶部
	 */

	public static void showToast(Context context, String content, int position) {
		if (Util.isBlankString(content) || content.equals("CMI_AJAX_ERR_NOT_LOGIN")) {
			return;
		}
		// 获取LayoutInflater对象，该对象可以将布局文件转换成与之一致的view对象
		LayoutInflater inflater = ((Activity) context).getLayoutInflater();
		// 将布局文件转换成相应的View对象
		View layout = inflater.inflate(R.layout.toast_layout, null);
		// 从layout中按照id查找TextView对象
		TextView textView = (TextView) layout.findViewById(R.id.tvForToast);
		// 设置TextView的text内容
		textView.setText(content);
		// 实例化一个Toast对象
		if (toast != null) {
			toast.cancel();
		}
		toast = new Toast(context);
		toast.setDuration(Toast.LENGTH_SHORT); // 设置显示时长
		int ScreenWidth = Util.getScreenWidth(context);
		switch (position) {
		case 0:
			if (ScreenWidth <= 480) {
				toast.setGravity(Gravity.BOTTOM, 0, 165);
			} else {
				toast.setGravity(Gravity.BOTTOM, 0, 250);
			}
			break;
		case 1:
			toast.setGravity(Gravity.CENTER, 0, 100);
			break;
		case 2:
			toast.setGravity(Gravity.TOP, 0, 100);
			break;
		}
		toast.setView(layout);// 放入页面
		toast.show();
	}

	/**
	 * 显示toast提示
	 * 
	 * @return void 返回类型
	 * @param @param str 提示文字
	 * @param @param isOk 提示类型：true对号，false错误警告
	 * @author likai
	 */
	public static void showActionResult(String str, boolean isOk) {
		View v = View.inflate(J_Application.context, R.layout.toast_result_layout, null);
		float w = DensityUtil.getWindowWH()[0];
		v.setMinimumWidth((int) (w * 0.4f));
		v.setMinimumHeight((int) (w * 0.4f));
		ImageView iv = (ImageView) v.findViewById(R.id.img_1);
		iv.setImageResource(isOk ? R.drawable.action_ok : R.drawable.action_error);
		TextView tv = (TextView) v.findViewById(R.id.txt_1);
		tv.setText(str);
		Toast toast = new Toast(J_Application.context);
		toast.setView(v);
		toast.setGravity(Gravity.CENTER, 0, 0);
		toast.setDuration(Toast.LENGTH_SHORT);
		toast.show();
	}

	/**
	 * 显示toast提示
	 * 
	 * @return void 返回类型
	 * @param @param str 提示文字string id
	 * @param @param isOk 提示类型：true对号，false错误警告
	 * @author likai
	 */
	public static void showActionResult(int res, boolean isOk) {
		showActionResult(J_Application.context.getString(res), isOk);
	}

	/**
	 * 显示在屏幕中央的半透明toast
	 * 
	 * @Title: showCenterToast
	 * @return void 返回类型
	 * @param @param res
	 * @param @param isOk 参数类型
	 * @author likai
	 * @throws
	 */
	public static void showCenterToast(String str, boolean isOk) {
		View v = View.inflate(J_Application.context, R.layout.toast_center_layout, null);
		float w = DensityUtil.getWindowWH()[0];
		v.setMinimumWidth((int) (w * 0.4f));
		v.setMinimumHeight((int) (w * 0.4f));
		ImageView iv = (ImageView) v.findViewById(R.id.toast_status_iv);
		RelativeLayout toast_center_box = (RelativeLayout) v.findViewById(R.id.toast_center_box);
		iv.setImageResource(isOk ? R.drawable.icon_ok : R.drawable.icon_ok);
		TextView tv = (TextView) v.findViewById(R.id.toast_status_info);
		// 设置显示文字
		tv.setText(str);
		// 设置透明状态
		toast_center_box.setAlpha(0.8f);
		Toast toast = new Toast(J_Application.context);
		toast.setView(v);
		toast.setGravity(Gravity.CENTER, 0, 0);
		toast.setDuration(Toast.LENGTH_SHORT);
		toast.show();
	}
}
