package com.iyouxun.ui.views;

import android.content.Context;
import android.graphics.Canvas;
import android.text.Layout;
import android.text.Layout.Alignment;
import android.text.StaticLayout;
import android.text.TextUtils.TruncateAt;
import android.util.AttributeSet;
import android.widget.TextView;

public class EllipsizingTextView extends TextView {
	private static final String ELLIPSIS = "...";

	public interface EllipsizeListener {
		void ellipsizeStateChanged(boolean ellipsized);
	}

	public Layout layout;
	private EllipsizeListener ellipsizeListener =null;
	private boolean isEllipsized;
	private boolean isStale;
	private boolean showExpandButton;
	private boolean programmaticChange;
	private String fullText;
	private int maxLines = -1;
	private float lineSpacingMultiplier = 1.0f;
	private float lineAdditionalVerticalPadding = 0.0f;

	public EllipsizingTextView(Context context) {
		super(context);
	}

	public EllipsizingTextView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	public EllipsizingTextView(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
	}

	public void setEllipsizeListener(EllipsizeListener listener) {
		if (listener != null) {
			ellipsizeListener=listener;
		}
	}

	public boolean isEllipsized() {
		return isEllipsized;
	}

	public int getTextLineCount() {
		if (layout != null) {
			return layout.getLineCount();
		} else {
			return 0;
		}
	}

	@Override
	public void setMaxLines(int maxLines) {
		super.setMaxLines(maxLines);
		this.maxLines = maxLines;
		isStale = true;
	}

	public int getMaxLinesNum() {
		return maxLines;
	}

	@Override
	public void setLineSpacing(float add, float mult) {
		this.lineAdditionalVerticalPadding = add;
		this.lineSpacingMultiplier = mult;
		super.setLineSpacing(add, mult);
	}

	@Override
	protected void onTextChanged(CharSequence text, int start, int before,
			int after) {
		super.onTextChanged(text, start, before, after);
		if (!programmaticChange) {
			fullText = text.toString();
			isStale = true;
		}
	}

	@Override
	protected void onDraw(Canvas canvas) {
		if (isStale) {
			super.setEllipsize(null);
			resetText();
		}
		super.onDraw(canvas);
	}

	public boolean showExpandButton(){
		return showExpandButton;
	}
	private void resetText() {
		int maxLines = getMaxLinesNum();
		String workingText = fullText;
		boolean ellipsized = false;
		if (maxLines != -1) {
			layout = createWorkingLayout(workingText);
			if (layout.getLineCount() > maxLines) {
				showExpandButton=true;
				workingText = fullText.substring(0,
						layout.getLineEnd(maxLines - 1) - 1);
				while (createWorkingLayout(workingText + ELLIPSIS)
						.getLineCount() > maxLines) {
					int lastSpace = workingText.lastIndexOf(' ');
					if (lastSpace == -1) {
						break;
					}
					workingText = workingText.substring(0,
							workingText.length() - 1);
				}
				workingText = workingText + ELLIPSIS;
				ellipsized = true;
			}else{
				showExpandButton=false;
			}
		}
		if (!workingText.equals(getText())) {
			programmaticChange = true;
			try {
				setText(workingText);
			} finally {
				programmaticChange = false;
			}
		}
		isStale = false;
		if (ellipsized != isEllipsized) {
			isEllipsized = ellipsized;
			if(ellipsizeListener!=null)
				ellipsizeListener.ellipsizeStateChanged(ellipsized);
		}
	}

	private Layout createWorkingLayout(String workingText) {
		return new StaticLayout(workingText, getPaint(), getWidth()
				- getPaddingLeft() - getPaddingRight(), Alignment.ALIGN_NORMAL,
				lineSpacingMultiplier, lineAdditionalVerticalPadding, false);
	}

	@Override
	public void setEllipsize(TruncateAt where) {
		// Ellipsize settings are not respected
	}
}