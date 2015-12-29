package com.iyouxun.ui.fragment;

import java.util.HashMap;

import android.content.Intent;
import android.os.Bundle;
import android.support.v4.app.Fragment;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;

import com.iyouxun.ui.activity.BaseActivity;
import com.iyouxun.ui.activity.BaseActivity.OnActivityResultListener;
import com.iyouxun.utils.LoadingHandler;

public abstract class BaseFragment extends Fragment implements OnActivityResultListener {

	protected View mContentView;
	private final HashMap<Integer, LoadingHandler> handlers = new HashMap<Integer, LoadingHandler>();

	@Override
	public View onCreateView(LayoutInflater inflater, ViewGroup container, Bundle savedInstanceState) {
		mContentView = createView();
		initViews();
		return mContentView;
	}

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
	}

	protected abstract View createView();

	protected abstract void initViews();

	public View findViewById(int id) {
		return mContentView.findViewById(id);
	}

	public BaseActivity getBaseActivity() {
		return (BaseActivity) getActivity();
	}

	@Override
	public void startActivityForResult(Intent intent, int requestCode) {
		// fragment的startActivityForResult方法会修改请求码，所以重写
		getBaseActivity().startActivityForResult(intent, requestCode);
	}

	@Override
	public void onActivityResult(int requestCode, int resultCode, Intent data) {

	}

	public String getLTag() {
		return this.getClass().getSimpleName();
	}

	@Override
	public void onResume() {
		super.onResume();
		// J_StatisticsManager.getInstance().onFragmentResume(this,
		// J_StatisticsManager.STATISTICS_BAIDU);
	}

	@Override
	public void onPause() {
		super.onPause();
		// J_StatisticsManager.getInstance().onFragmentPause(this,
		// J_StatisticsManager.STATISTICS_BAIDU);
	}

	@Override
	public void onDestroy() {
		super.onDestroy();
	}

	/**
	 * 显示加载中的状态
	 * 
	 * @param msg 加载文字
	 * @param group 当前的View
	 */
	public void showLoading(String msg, ViewGroup group) {
		LoadingHandler mLoadingHandler = new LoadingHandler(group);
		mLoadingHandler.showModal(msg);
		handlers.put(group.hashCode(), mLoadingHandler);
	}

	public void showLoading(int res, ViewGroup group) {
		showLoading(getString(res), group);
	}

	public void showLoading(ViewGroup group) {
		showLoading(null, group);
	}

	public void showLoading() {
		if (mContentView != null) {
			showLoading((ViewGroup) mContentView);
		}
	}

	public void showLoading(String msg) {
		if (mContentView != null) {
			showLoading(msg, (ViewGroup) mContentView);
		}
	}

	public void showLoading(int res) {
		if (mContentView != null) {
			showLoading(res, (ViewGroup) mContentView);
		}
	}

	public void dismissLoading() {
		if (mContentView != null && isAdded()) {
			dismissLoading(mContentView.hashCode());
		}
	}

	/***
	 * 取消显示加载中
	 * 
	 * @param key 当前View的hashcode
	 */
	public void dismissLoading(int key) {
		if (handlers.containsKey(key)) {
			LoadingHandler handler = handlers.get(key);
			handler.hideModal();
			handlers.remove(key);
		}
	}
}
