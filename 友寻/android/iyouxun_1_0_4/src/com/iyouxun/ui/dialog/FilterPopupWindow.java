package com.iyouxun.ui.dialog;

import android.content.Context;
import android.graphics.drawable.PaintDrawable;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup.LayoutParams;
import android.widget.PopupWindow;
import android.widget.TextView;

import com.iyouxun.R;

/**
 * @ClassName: FilterPopupWindow
 * @Description: 管理一度好友筛选菜单
 * @author donglizhi
 * @date 2015年3月11日 下午4:52:49
 * 
 */
public class FilterPopupWindow extends PopupWindow {
	private final TextView btnAll;// 全部好友
	private final TextView btnSingle;// 单身
	private final TextView btnOpposite;// 异性

	public FilterPopupWindow(Context context, OnClickListener listener) {
		super(context);
		View view = View.inflate(context, R.layout.dialog_filter_friends, null);
		btnAll = (TextView) view.findViewById(R.id.filter_friends_btn_all);
		btnSingle = (TextView) view.findViewById(R.id.filter_friends_btn_single);
		btnOpposite = (TextView) view.findViewById(R.id.filter_friends_btn_opposite);
		setContentView(view);
		setHeight(LayoutParams.WRAP_CONTENT);
		setWidth(context.getResources().getDimensionPixelOffset(R.dimen.filter_show_width));
		// 外部点击可以消失
		setFocusable(true);
		setOutsideTouchable(true);
		btnAll.setOnClickListener(listener);
		btnOpposite.setOnClickListener(listener);
		btnSingle.setOnClickListener(listener);
		// 动画效果
		setAnimationStyle(R.style.AnimView);
		// 背景透明，和布局文件是分开的
		setBackgroundDrawable(new PaintDrawable(0x00000000));
	}

}
