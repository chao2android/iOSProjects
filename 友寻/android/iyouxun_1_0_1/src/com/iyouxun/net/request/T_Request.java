package com.iyouxun.net.request;

import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public abstract class T_Request extends J_Request {

	public T_Request(Object... args) {
		super(null);
		setUrlAndType();
	}

	/** 调用此构造方法时,执行请求的方法是空参数的perform() */
	public T_Request(OnDataBack odb) {
		super(odb);
		this.callback = odb;
		setUrlAndType();
	}

	/** 设置请求地址和类型(NetTaskIDs中请求ID标识 ) */
	public abstract void setUrlAndType();

	public void perform(OnDataBack mcallback) {
		this.callback = mcallback;
		perform();
	}

	public void perform() {
		J_NetManager.getInstance().sendRequest(this);
	}

	@Override
	public OnDataBack getCallback() {
		return callback;
	}
}
