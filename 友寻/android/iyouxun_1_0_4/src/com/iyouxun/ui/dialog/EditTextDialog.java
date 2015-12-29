package com.iyouxun.ui.dialog;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.text.Editable;
import android.text.InputFilter;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.iyouxun.R;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.ui.views.ClearEditText;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.StringUtils;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 创建新标签弹框
 * 
 * @ClassName: TagCreateDialog
 * @author likai
 * @date 2015-3-2 下午6:26:25
 * 
 */
public class EditTextDialog extends Dialog {
	private final Context mContext;
	private DialogUtils.OnSelectCallBack callBack;

	private ClearEditText tag_name_et;
	private Button tag_button_cancel;
	private Button tag_button_ok;
	private TextView tag_dialog_title;// 标题

	private String defaultTxt = "";// 默认文字

	private LinearLayout tag_dialog_layerbox;

	/** 类型：1：标签，2：备注 */
	private int type = 0;

	private String dialogTitle = "";
	private String dialogHint = "";

	public EditTextDialog(Context context, int theme) {
		super(context, theme);
		mContext = context;
	}

	public EditTextDialog setType(int type) {
		this.type = type;

		switch (type) {
		case 1:// 标签
			this.dialogTitle = "添加标签";
			this.dialogHint = "标签名称";
			break;
		case 2:// 备注
			this.dialogTitle = "添加备注";
			this.dialogHint = "备注名称";
			break;
		default:
			break;
		}

		return this;
	}

	/**
	 * 设置默认文字
	 * 
	 * @return EditTextDialog 返回类型
	 * @param @param defTxt
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public EditTextDialog setDefaultTxt(String defTxt) {
		this.defaultTxt = defTxt;

		return this;
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
	public EditTextDialog setCallBack(DialogUtils.OnSelectCallBack callBack) {
		this.callBack = callBack;
		return this;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.dialog_edit_text_layout);

		tag_name_et = (ClearEditText) findViewById(R.id.tag_name_et);
		tag_button_cancel = (Button) findViewById(R.id.tag_button_cancel);
		tag_button_ok = (Button) findViewById(R.id.tag_button_ok);
		tag_dialog_layerbox = (LinearLayout) findViewById(R.id.tag_dialog_layerbox);
		tag_dialog_title = (TextView) findViewById(R.id.tag_dialog_title);

		tag_dialog_layerbox.setAlpha(0.9f);

		// 最多输入10个汉字
		if (type == 1) {
			// tag_name_et.setFilters(new InputFilter[] { new InputFilter() {
			// @Override
			// public CharSequence filter(CharSequence source, int start, int
			// end, Spanned dest, int dstart, int dend) {
			// if (source.length() < 1) {
			// return null;
			// } else {
			// char temp[] = (source.toString()).toCharArray();
			// char result[] = new char[temp.length];
			// for (int i = 0, j = 0; i < temp.length; i++) {
			// if (temp[i] == ' ') {
			// continue;
			// } else {
			// result[j++] = temp[i];
			// }
			// }
			// return String.valueOf(result).trim();
			// }
			// }
			// } });
			tag_name_et.addTextChangedListener(new TextWatcher() {
				private String temp;

				@Override
				public void onTextChanged(CharSequence s, int start, int before, int count) {
					temp = s.toString();
				}

				@Override
				public void beforeTextChanged(CharSequence s, int start, int count, int after) {
				}

				@Override
				public void afterTextChanged(Editable s) {
					if (!TextUtils.isEmpty(temp)) {
						String limitSubstring = StringUtils.getLimitSubstring(temp, 20);
						if (!TextUtils.isEmpty(limitSubstring)) {
							if (!limitSubstring.equals(temp)) {
								tag_name_et.setText(limitSubstring);
								tag_name_et.setSelection(limitSubstring.length());
							}
						}
					}
				}
			});
		} else if (type == 2) {
			// 昵称、备注统一为1-14个字
			tag_name_et.setFilters(new InputFilter[] { new InputFilter.LengthFilter(14) });
			if (!Util.isBlankString(defaultTxt)) {
				this.dialogTitle = "修改备注";
			}
		}

		// 设置默认文字
		if (!Util.isBlankString(defaultTxt)) {
			tag_name_et.setText(defaultTxt);
		}

		// 设置显示位置
		Window window = getWindow();

		WindowManager.LayoutParams params = window.getAttributes();
		params.width = Util.getScreenWidth(mContext);
		params.height = WindowManager.LayoutParams.WRAP_CONTENT;
		window.setAttributes(params);

		// 设置标题
		if (!Util.isBlankString(dialogTitle)) {
			tag_dialog_title.setText(dialogTitle);
		}
		if (!Util.isBlankString(dialogHint)) {
			tag_name_et.setHint(dialogHint);
		}

		tag_button_ok.setOnClickListener(listener);
		tag_button_cancel.setOnClickListener(listener);
	}

	private final J_OnViewClickListener listener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.tag_button_ok:
				// 保存
				String tagName = tag_name_et.getText().toString().trim();
				if (type == 1 && Util.isBlankString(tagName)) {// 标签
					ToastUtil.showToast(mContext, "请填写标签内容");
					return;
				} else if (type == 2 && !Util.isBlankString(tagName) && (tagName.length() < 1 || tagName.length() > 14)) {
					ToastUtil.showToast(mContext, "备注内容为1-14个字");
					return;
				}
				callBack.onCallBack("1", tagName, null);
				dismiss();
				break;
			case R.id.tag_button_cancel:
				// 取消
				dismiss();
				break;
			default:
				break;
			}
		}
	};
}
