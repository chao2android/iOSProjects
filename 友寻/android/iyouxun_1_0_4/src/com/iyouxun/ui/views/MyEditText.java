package com.iyouxun.ui.views;

import android.content.Context;
import android.text.InputFilter;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.widget.EditText;

public class MyEditText extends EditText {
	int maxLength = -1;

	public MyEditText(Context context, AttributeSet attrs, int defStyle) {
		super(context, attrs, defStyle);
		addListener(attrs);
	}

	public MyEditText(Context context, AttributeSet attrs) {
		super(context, attrs);
		addListener(attrs);
	}

	public MyEditText(Context context) {
		super(context);
		addListener(null);
	}

	private void addListener(AttributeSet attrs) {
		if (attrs != null)
			maxLength = attrs.getAttributeIntValue("http://schemas.android.com/apk/res/android", "maxLength", -1);
		InputFilter filter = new InputFilter() {
			@Override
			public CharSequence filter(CharSequence source, int start, int end, Spanned dest, int dstart, int dend) {
				StringBuffer buffer = new StringBuffer();
				for (int i = start; i < end; i++) {
					char c = source.charAt(i);
					// System.out.println((int) c);
					if (c == 55356 || c == 55357 || c == 10060 || c == 9749 || c == 9917 || c == 10067 || c == 10024
							|| c == 11088 || c == 9889 || c == 9729 || c == 11093 || c == 9924 || c == 10071 || c == 169
							|| c == 174 || c == 9992 || c == 9742 || c == 9728 || c == 9994 || c == 9996 || c == 10084
							|| c == 9918) {
						i++;
						continue;
					} else {
						buffer.append(c);
					}
				}
				if (source instanceof Spanned) {
					SpannableString sp = new SpannableString(buffer);
					TextUtils.copySpansFrom((Spanned) source, start, end, null, sp, 0);
					return sp;
				} else {
					return buffer;
				}
			}
		};
		if (maxLength > 0) {
			setFilters(new InputFilter[] { filter, new InputFilter.LengthFilter(maxLength) });
		} else {
			setFilters(new InputFilter[] { filter });
		}
	}
}
