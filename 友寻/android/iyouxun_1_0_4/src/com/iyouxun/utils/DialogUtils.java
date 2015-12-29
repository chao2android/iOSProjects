package com.iyouxun.utils;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.content.DialogInterface.OnDismissListener;
import android.content.DialogInterface.OnKeyListener;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;
import cn.sharesdk.framework.PlatformActionListener;

import com.iyouxun.R;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.open.J_ShareParams;
import com.iyouxun.ui.activity.BaseActivity;
import com.iyouxun.ui.dialog.MyDialog;
import com.iyouxun.ui.dialog.SharePopDialog;

public class DialogUtils {
	private static Dialog myDialog;

	/**
	 * 退出选择项
	 * 
	 * @param activity
	 * @param callBack
	 */
	public static void showSelectDialog(final BaseActivity activity, final OnSelectCallBack callBack) {
		final MyDialog dialog = new MyDialog();
		View v = View.inflate(activity, R.layout.dialog_select_layout, null);
		TextView selTxt1 = (TextView) v.findViewById(R.id.select_txt_1);
		TextView selTxt2 = (TextView) v.findViewById(R.id.select_txt_2);
		TextView selTxt3 = (TextView) v.findViewById(R.id.select_txt_3);
		selTxt1.setOnClickListener(new J_OnViewClickListener() {

			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(0 + "", null, null);
				dialog.dismiss();

			}
		});
		selTxt2.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(1 + "", null, null);
				dialog.dismiss();
			}
		});
		selTxt3.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(2 + "", null, null);
				dialog.dismiss();
			}
		});
		dialog.showCustomDialog(activity, v);
	}

	/**
	 * 上传头像选择操作
	 * 
	 * @param activity
	 * @param titleResId
	 * @param txtResId1
	 * @param txtResId2
	 * @param callBack
	 */
	public static void showSelectPhotoDialog(final Activity activity, int titleResId, final OnSelectCallBack callBack) {
		final MyDialog dialog = new MyDialog();
		View v = View.inflate(activity, R.layout.dialog_select_photo_layout, null);
		TextView title = (TextView) v.findViewById(R.id.txt_1);
		title.setText(titleResId);
		TextView selTxt1 = (TextView) v.findViewById(R.id.select_txt_1);
		TextView selTxt2 = (TextView) v.findViewById(R.id.select_txt_2);
		TextView selTxt3 = (TextView) v.findViewById(R.id.select_txt_3);
		selTxt1.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(0 + "", null, null);
				dialog.dismiss();
			}
		});
		selTxt2.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(1 + "", null, null);
				dialog.dismiss();
			}
		});
		selTxt3.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(2 + "", null, null);
				dialog.dismiss();
			}
		});
		dialog.showCustomDialog(activity, v);
	}

	/**
	 * 提示弹出框
	 * 
	 * @param activity
	 * @param titleResId
	 * @param txtResId1
	 * @param callBack
	 * @return 0:ok 1:cancel
	 */
	public static void showPromptDialog(Context mContext, String titleRes, String txtRes, final OnSelectCallBack callBack) {
		final MyDialog dialog = new MyDialog();
		View v = View.inflate(mContext, R.layout.dialog_prompt_layout, null);
		LinearLayout dialog_prompt_layer_box = (LinearLayout) v.findViewById(R.id.dialog_prompt_layer_box);
		TextView title = (TextView) v.findViewById(R.id.txt_1);
		TextView selTxt1 = (TextView) v.findViewById(R.id.select_txt_1);
		Button btnOk = (Button) v.findViewById(R.id.btn_ok);
		Button btnCancel = (Button) v.findViewById(R.id.btn_cancel);
		// 标题
		title.setText(titleRes);
		// 内容
		selTxt1.setText(txtRes);
		// 设置透明度
		dialog_prompt_layer_box.setAlpha(0.9f);

		btnOk.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(0 + "", null, null);
				dialog.dismiss();
			}
		});
		btnCancel.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(1 + "", null, null);
				dialog.dismiss();
			}
		});
		dialog.setOnCancelListener(new OnCancelListener() {
			@Override
			public void onCancel(DialogInterface dialog) {
				callBack.onCallBack(1 + "", null, null);
				dialog.dismiss();
			}
		});
		dialog.showCustomDialog(mContext, v);
	}

	/**
	 * 自定义的陌生人提示加好友弹层
	 * 
	 * @return void 返回类型
	 * @param @param mContext
	 * @param @param titleRes
	 * @param @param txtRes
	 * @param @param btnRes
	 * @param @param isOutSideClose
	 * @param @param callBack 参数类型
	 * @author likai
	 * @throws
	 */
	public static void showStangerWarmDialog(Context mContext, int sex, boolean isOutSideClose, final OnSelectCallBack callBack) {
		final Dialog dialog = new Dialog(mContext, R.style.dialog);
		View v = View.inflate(mContext, R.layout.dialog_stranger_warm_layout, null);
		dialog.setContentView(v);
		// 文字描述
		TextView stranger_info = (TextView) v.findViewById(R.id.stranger_info);
		String content = "他还不是你的好友，";
		if (sex == 0) {
			content = "她还不是你的好友，";
		}
		stranger_info.setText(content);
		// 确认按钮
		Button btnOk = (Button) v.findViewById(R.id.stranger_button_ok);
		// 点击确认
		btnOk.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				if (callBack != null) {
					callBack.onCallBack(0 + "", null, null);
				}
				dialog.dismiss();
			}
		});
		// 弹层关闭
		dialog.setOnCancelListener(new OnCancelListener() {
			@Override
			public void onCancel(DialogInterface dialog) {
				if (callBack != null) {
					callBack.onCallBack(1 + "", null, null);
				}
				dialog.dismiss();
			}
		});
		// 点击外部是否关闭
		dialog.setCanceledOnTouchOutside(isOutSideClose);
		dialog.show();
	}

	/**
	 * app升级提示弹出框
	 * 
	 * @param activity
	 * @param titleResId
	 * @param txtResId1
	 * @param callBack
	 */
	public static void showUpdateDialog(Context mContext, int titleResId, String txtResId1, final OnSelectCallBack callBack) {
		final MyDialog dialog = new MyDialog();
		View v = View.inflate(mContext, R.layout.dialog_prompt_layout, null);
		LinearLayout dialog_prompt_layer_box = (LinearLayout) v.findViewById(R.id.dialog_prompt_layer_box);
		TextView title = (TextView) v.findViewById(R.id.txt_1);
		TextView selTxt1 = (TextView) v.findViewById(R.id.select_txt_1);
		Button btnOk = (Button) v.findViewById(R.id.btn_ok);
		Button btnCancel = (Button) v.findViewById(R.id.btn_cancel);
		// 标题
		title.setText(titleResId);
		// 内容
		selTxt1.setText(txtResId1);
		selTxt1.setGravity(Gravity.LEFT);
		// 设置透明度
		dialog_prompt_layer_box.setAlpha(0.9f);

		btnOk.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(0 + "", null, null);
				dialog.dismiss();
			}
		});
		btnCancel.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(1 + "", null, null);
				dialog.dismiss();
			}
		});
		// 点击外部不关闭
		dialog.setCanceledOnTouchOutside(false);
		dialog.showCustomDialog(mContext, v);
	}

	/**
	 * 提醒框
	 * 
	 * @return void 返回类型
	 * @param mContext
	 * @param titleRes 标题信息
	 * @param txtRes 提示的内容信息
	 * @param btnRes 按钮上的文字信息
	 * @param isOutSideClose 点击外部是否关闭
	 * @param callBack 回调方法
	 * @author likai
	 */
	public static void showAlertDialog(Context mContext, String titleRes, String txtRes, String btnRes,
			final boolean isOutSideClose, final OnSelectCallBack callBack) {
		final Dialog dialog = new Dialog(mContext, R.style.dialog);
		View v = View.inflate(mContext, R.layout.dialog_alert_layout, null);
		dialog.setContentView(v);
		// 描述标题
		TextView title = (TextView) v.findViewById(R.id.dialogAlertTitle);
		title.setText(titleRes);
		// 描述内容
		TextView txt = (TextView) v.findViewById(R.id.dialogAlertContent);
		txt.setText(txtRes);
		// 确认按钮
		Button btnOk = (Button) v.findViewById(R.id.dialogAlertButton);
		btnOk.setText(btnRes);

		// 点击确认
		btnOk.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				if (callBack != null) {
					callBack.onCallBack(0 + "", null, null);
				}
				dialog.dismiss();
			}
		});
		// 弹层关闭
		dialog.setOnCancelListener(new OnCancelListener() {
			@Override
			public void onCancel(DialogInterface dialog) {
				if (callBack != null) {
					callBack.onCallBack(1 + "", null, null);
				}
				dialog.dismiss();
			}
		});
		// 点击外部是否关闭
		dialog.setCanceledOnTouchOutside(isOutSideClose);
		dialog.show();

		// 挑战好友答题 如果金币不足 直接物理按钮返回 需要关闭Activity
		dialog.setOnKeyListener(new OnKeyListener() {
			@Override
			public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
				if (callBack != null) {
					callBack.onCallBack(1 + "", null, String.valueOf(keyCode));
				}
				if (keyCode == KeyEvent.KEYCODE_BACK && isOutSideClose) {
					// 如果点击外部不允许关闭，阻止点击返回键
					return true;
				}
				return false;
			}
		});
	}

	/**
	 * 没有头像的弹框
	 * 
	 * @param activity
	 * @param flag true-显示取消，缘分页使用的弹框；false-隐藏取消，个人资料页显示的弹框
	 * @param callBack
	 */
	public static MyDialog showNoAvatarDialog(final BaseActivity activity, boolean flag, final OnSelectCallBack callBack) {
		final MyDialog dialog = new MyDialog();
		dialog.setCanceledOnTouchOutside(false);
		dialog.setCancelable(true);

		View v = View.inflate(activity, R.layout.dialog_no_avatar_layout, null);
		TextView selTxt1 = (TextView) v.findViewById(R.id.select_txt_1);
		TextView selTxt2 = (TextView) v.findViewById(R.id.select_txt_2);
		TextView selTxt3 = (TextView) v.findViewById(R.id.select_txt_3);
		if (flag) {
			selTxt3.setVisibility(View.VISIBLE);
		}
		selTxt1.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(0 + "", null, null);
			}
		});
		selTxt2.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(1 + "", null, null);
			}
		});
		selTxt3.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(2 + "", null, null);
				dialog.dismiss();
			}
		});
		dialog.showCustomDialog(activity, v);
		return dialog;
	}

	/**
	 * 忘记密码
	 * 
	 * @param activity
	 * @param callBack
	 */
	public static void showForgetPwdDialog(final BaseActivity activity, final OnSelectCallBack callBack) {
		final MyDialog dialog = new MyDialog();
		View v = View.inflate(activity, R.layout.dialog_select_photo_layout, null);
		TextView tv_title = (TextView) v.findViewById(R.id.txt_1);
		tv_title.setText(R.string.login_text_forgot_password);
		TextView selTxt1 = (TextView) v.findViewById(R.id.select_txt_1);
		TextView selTxt2 = (TextView) v.findViewById(R.id.select_txt_2);
		TextView selTxt3 = (TextView) v.findViewById(R.id.select_txt_3);
		selTxt1.setText(R.string.dialog_find_back_through_email);
		selTxt2.setText(R.string.dialog_find_back_through_photo);
		selTxt1.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(0 + "", null, null);
				dialog.dismiss();
			}
		});
		selTxt2.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(1 + "", null, null);
				dialog.dismiss();
			}
		});
		selTxt3.setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(2 + "", null, null);
				dialog.dismiss();
			}
		});
		dialog.showCustomDialog(activity, v);
	}

	/**
	 * 显示加载提示信息框
	 * 
	 * @return Dialog 返回类型
	 * @param @param activity
	 * @param @param type
	 * @param @param desc
	 * @param @return 参数类型
	 * @author likai
	 */
	public static Dialog showProgressDialog(Context mContext, String desc) {
		if (myDialog != null && myDialog.isShowing()) {
			return myDialog;
		}
		View myView = View.inflate(mContext, R.layout.dialog_loading_new, null);
		TextView dialog_text = (TextView) myView.findViewById(R.id.loading_text);
		dialog_text.setText(desc);
		myDialog = new Dialog(mContext, R.style.Dialog_loading_noDim);
		myDialog.setContentView(myView);
		myDialog.setCanceledOnTouchOutside(false);
		myDialog.show();
		return myDialog;
	}

	private static SharePopDialog sharePropDialog;

	/**
	 * 分享弹层
	 * 
	 * @return void 返回类型
	 * @param mContext 参数类型
	 * @author likai
	 */
	public static void showSharePopDialog(Activity mActivity, PlatformActionListener callBack, J_ShareParams params) {
		if (sharePropDialog == null) {
			sharePropDialog = new SharePopDialog(mActivity, R.style.dialog);
			// 设置回调方法
			sharePropDialog.setCallBack(callBack);
			// 设置分享参数
			sharePropDialog.setParams(params);
			sharePropDialog.setOnDismissListener(new OnDismissListener() {
				@Override
				public void onDismiss(DialogInterface dialog) {
					sharePropDialog = null;
				}
			});
			sharePropDialog.show();
		}
	}

	/**
	 * 清除加载对话框
	 * 
	 * @param dialog
	 */
	public static void dismissDialog() {
		if (myDialog != null && myDialog.isShowing()) {
			myDialog.dismiss();
		}
	}

	public static interface OnSelectCallBack {
		public void onCallBack(String value1, String value2, String value3);
	}

	public static void showAlertTwoBtn(final BaseActivity activity, String text, final OnSelectCallBack callBack) {
		final MyDialog myDialog = new MyDialog();

		View v = View.inflate(activity, R.layout.dialog_alert_two_btn_layout, null);
		TextView tv = (TextView) v.findViewById(R.id.tv_alert_title);
		tv.setText(text);

		// 取消
		v.findViewById(R.id.btn_alert_cancel).setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(1 + "", null, null);
				myDialog.dismiss();
			}
		});

		// 确定
		v.findViewById(R.id.btn_alert_confirm).setOnClickListener(new J_OnViewClickListener() {
			@Override
			public void onViewClick(View v) {
				callBack.onCallBack(2 + "", null, null);
				myDialog.dismiss();
			}
		});

		myDialog.showCustomDialog(activity, v);
	}
}
