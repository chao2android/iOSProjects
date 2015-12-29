package com.iyouxun.ui.views;

import android.content.Context;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.EditText;

public class EditTextWithDelete extends EditText {
	private Drawable dRight;

	{
		setEditTextDrawable();
		addTextChangedListener(new TextWatcher() {
			@Override
			public void afterTextChanged(Editable paramEditable) {
			}

			@Override
			public void beforeTextChanged(CharSequence paramCharSequence, int paramInt1, int paramInt2, int paramInt3) {
			}

			@Override
			public void onTextChanged(CharSequence paramCharSequence, int paramInt1, int paramInt2, int paramInt3) {
				EditTextWithDelete.this.setEditTextDrawable();
			}
		});
	}

	public EditTextWithDelete(Context paramContext) {
		super(paramContext);
	}

	public EditTextWithDelete(Context paramContext, AttributeSet paramAttributeSet) {
		super(paramContext, paramAttributeSet);
	}

	public EditTextWithDelete(Context paramContext, AttributeSet paramAttributeSet, int paramInt) {
		super(paramContext, paramAttributeSet, paramInt);
	}

	private void setEditTextDrawable() {
		if (getText().toString().length() == 0 || !hasFocus()) {
			setCompoundDrawables(null, null, null, null);
		} else {
			if (hasFocus())
				setCompoundDrawables(null, null, this.dRight, null);
		}
	}

	@Override
	protected void onFocusChanged(boolean focused, int direction, Rect previouslyFocusedRect) {
		if (!focused)
			setCompoundDrawables(null, null, null, null);

		if (focused && getText().toString().length() != 0)
			setCompoundDrawables(null, null, this.dRight, null);

		super.onFocusChanged(focused, direction, previouslyFocusedRect);
	}

	@Override
	protected void finalize() throws Throwable {
		super.finalize();
		this.dRight = null;
	}

	// 添加触摸事件
	@Override
	public boolean onTouchEvent(MotionEvent motionEvent) {
		if ((this.dRight != null) && (motionEvent.getAction() == MotionEvent.ACTION_UP)) {
			int touchX = (int) motionEvent.getX();

			if (touchX > this.getWidth() - this.getPaddingRight() - dRight.getIntrinsicWidth()) {
				if (hasFocus())
					setText("");
				motionEvent.setAction(MotionEvent.ACTION_CANCEL);
			}
		}
		return super.onTouchEvent(motionEvent);
	}

	// 设置显示的图片资源
	@Override
	public void setCompoundDrawables(Drawable paramDrawable1, Drawable paramDrawable2, Drawable paramDrawable3,
			Drawable paramDrawable4) {
		if (paramDrawable3 != null)
			this.dRight = paramDrawable3;
		super.setCompoundDrawables(paramDrawable1, paramDrawable2, paramDrawable3, paramDrawable4);
	}
}
