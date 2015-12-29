package com.iyouxun.ui.views;

import com.iyouxun.R;
import android.content.Context;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ListView;

public class MoreView extends LinearLayout {
	public static final int TYPE_LOADING = 10;
	public static final int TYPE_NORMAL = 30;
	private ListView mListView;
	private int displayType = TYPE_NORMAL;

	public MoreView(Context context) {
		super(context);
		setOrientation(LinearLayout.HORIZONTAL);
		init();
	}

	private void init() {
		View moreView = View.inflate(getContext(), R.layout.item_more_layout, null);
		addView(moreView);
		setClickable(false);
	}

	public void bindListView(ListView listView) {
		mListView = listView;
		setVisibility(View.GONE);
		mListView.addFooterView(this);
	}

	public void setDisplayType(int type) {
		if (mListView == null) {
			throw new IllegalArgumentException("请先调用 bindListView 方法");
		}
		displayType = type;
		switch (displayType) {
		case TYPE_LOADING:
			setVisibility(View.VISIBLE);
			if (mListView.getFooterViewsCount() == 0) {
				mListView.addFooterView(this);
			}
			break;
		case TYPE_NORMAL:
			if (mListView.getFooterViewsCount() > 0) {
				mListView.removeFooterView(this);
			}
			break;
		}
	}

}
