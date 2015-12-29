package com.iyouxun.ui.dialog;

import android.content.Context;
import android.graphics.drawable.PaintDrawable;
import android.view.View;
import android.view.WindowManager.LayoutParams;
import android.widget.Button;
import android.widget.PopupWindow;

import com.iyouxun.R;
import com.iyouxun.effect.J_OnViewClickListener;
import com.iyouxun.utils.DialogUtils;

/**
 * 弹出菜单（熟人圈>筛选）
 * 
 * @ClassName: MenuPopDialog
 * @author likai
 * @date 2015-3-6 下午4:26:27
 * 
 */
public class MenuPopDialog extends PopupWindow {
	private final Context mContext;
	private DialogUtils.OnSelectCallBack callBack;

	private final Button menuDialogAllButton;
	private final Button menuDialogSingleButton;

	private int defaultIndex = 0;

	public MenuPopDialog setCallBack(DialogUtils.OnSelectCallBack callBack) {
		this.callBack = callBack;
		return this;
	}

	public MenuPopDialog setDefault(int index) {
		this.defaultIndex = index;

		if (defaultIndex == 0) {
			// 第一项
			menuDialogAllButton.setTextColor(mContext.getResources().getColor(R.color.text_normal_blue));
			menuDialogSingleButton.setTextColor(mContext.getResources().getColor(R.color.text_normal_black));
		} else if (defaultIndex == 1) {
			// 第二项
			menuDialogAllButton.setTextColor(mContext.getResources().getColor(R.color.text_normal_black));
			menuDialogSingleButton.setTextColor(mContext.getResources().getColor(R.color.text_normal_blue));
		}

		return this;
	}

	public MenuPopDialog(Context context) {
		super(context);
		this.mContext = context;
		View view = View.inflate(mContext, R.layout.dialog_menu_pop_layout, null);
		setContentView(view);

		// 这个设置还是必须的
		setHeight(LayoutParams.WRAP_CONTENT);
		setWidth(LayoutParams.WRAP_CONTENT);
		// 背景透明，和布局文件是分开的
		setBackgroundDrawable(new PaintDrawable(0x00000000));

		menuDialogAllButton = (Button) view.findViewById(R.id.menuDialogAllButton);
		menuDialogSingleButton = (Button) view.findViewById(R.id.menuDialogSingleButton);

		menuDialogAllButton.setOnClickListener(mListener);
		menuDialogSingleButton.setOnClickListener(mListener);

		// 外部点击可以消失
		setOutsideTouchable(true);
	}

	private final J_OnViewClickListener mListener = new J_OnViewClickListener() {
		@Override
		public void onViewClick(View v) {
			switch (v.getId()) {
			case R.id.menuDialogAllButton:
				// 全部
				callBack.onCallBack("1", null, null);
				dismiss();
				break;
			case R.id.menuDialogSingleButton:
				// 只看单身
				callBack.onCallBack("2", null, null);
				dismiss();
				break;
			default:
				break;
			}
		}
	};
}
