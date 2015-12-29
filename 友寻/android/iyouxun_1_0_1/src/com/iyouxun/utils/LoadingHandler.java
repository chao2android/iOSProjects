package com.iyouxun.utils;

import android.graphics.drawable.AnimationDrawable;
import android.text.TextUtils;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import android.widget.TextView;

import com.iyouxun.R;

public class LoadingHandler {
	/** 当前显示页面的布局 */
	private final ViewGroup mContentView;
	private final LayoutInflater mInflater;
	private TextView mLoadingText;
	private ImageView mLoadingAnim;
	public static final String DEFALT_STR = "加载中...";
	private String textStr;
	/** loading的蒙层 */
	private View mModal;
	private boolean isReady;
	private AnimationDrawable ad;

	public LoadingHandler(ViewGroup contentView) {
		this.mContentView = contentView;
		this.mInflater = LayoutInflater.from(contentView.getContext());
	}

	private void init() {
		mModal = getModal();
		mContentView.addView(mModal, new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT,
				ViewGroup.LayoutParams.MATCH_PARENT));
		mModal.setVisibility(View.GONE);
		mContentView.invalidate();
		isReady = true;
	}

	/** 显示加载中 */
	public void showModal(String str) {
		textStr = TextUtils.isEmpty(str) ? DEFALT_STR : str;
		if (isReady) {
			showLoading();
		} else {
			init();
			showModal(str);
		}
	}

	/** 隐藏加载中 */
	public void hideModal() {
		mContentView.removeView(mModal);
		mContentView.invalidate();
		isReady = false;
		mModal = null;
	}

	private View getModal() {
		View modal = mInflater.inflate(R.layout.loading_layout, null);
		mLoadingText = (TextView) modal.findViewById(R.id.txt_1);
		mLoadingAnim = (ImageView) modal.findViewById(R.id.img_1);
		modal.setClickable(true);
		return modal;
	}

	private void showLoading() {
		mModal.setVisibility(View.VISIBLE);
		mLoadingText.setText(textStr);
		ad = (AnimationDrawable) mLoadingAnim.getDrawable();
		mLoadingAnim.post(new Runnable() {
			@Override
			public void run() {
				if (ad.isRunning()) {
					ad.stop();
				}
				ad.start();
			}
		});
	}
}
