package com.iyouxun.net.request;

import java.util.HashMap;

import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;

public abstract class JonDataBackAdapter implements OnDataBack {
	@Override
	public abstract void onResponse(Object result);

	@Override
	public void onError(HashMap<String, Object> errMap) {
		int Error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
	}

}
