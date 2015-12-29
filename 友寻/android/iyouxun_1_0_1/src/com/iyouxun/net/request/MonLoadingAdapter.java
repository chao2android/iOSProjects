package com.iyouxun.net.request;

import com.iyouxun.j_libs.managers.J_NetManager;

public abstract class MonLoadingAdapter implements J_NetManager.OnLoadingListener {
	@Override
	public void startLoading() {

	}

	@Override
	public void onLoading(long total, long current, boolean isUploading) {

	}

	@Override
	public void onfinishLoading(String result) {

	}

	@Override
	public void onError() {

	}
}
