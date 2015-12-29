package com.iyouxun.net.request;

import java.util.HashMap;

import android.os.Handler;

import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;

public class DataBackAdapter implements OnDataBack {
	@Override
	public void onResponse(Object result) {
		handler.sendMessage(handler.obtainMessage(type, result));
	}

	@Override
	public void onError(HashMap<String, Object> errMap) {
		int Error = (Integer) errMap.get(OnDataBack.KEY_ERROR);
		handler.sendMessage(handler.obtainMessage(type, Error, type));
	}

	public DataBackAdapter(Handler handler, int type) {
		this.handler = handler;
		this.type = type;
	}

	public void setType(int type) {
		this.type = type;
	}

	public int getType() {
		return type;
	}

	public void setHandler(Handler handler) {
		this.handler = handler;
	}

	public Handler getHandler() {
		return handler;
	}

	private Handler handler;
	private int type;
}