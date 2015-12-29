package com.iyouxun.j_libs.net.request;

import java.util.HashMap;

import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;

public abstract class J_Request {

	public static final String METHOD_GET = "GET";
	public static final String METHOD_POST = "POST";
	/**
	 * 请求的ID
	 */
	public int REQUEST_TYPE = -1;
	/**
	 * @Fields CHAT_TABLE_ID : 本地消息id
	 */
	public long CHAT_TABLE_ID = 0;
	public String URL = "";
	public String REQUEST_METHOD = METHOD_POST;
	public OnDataBack callback = null;
	public HashMap<String, String> map = new HashMap<String, String>();
	private String tokenField;

	public J_Request(OnDataBack callBack) {
		this.callback = callBack;
	}

	public String getTokenField() {
		return tokenField;
	}

	public void setTokenField(String tokenField) {
		this.tokenField = tokenField;
	}

	public HashMap<String, String> getRequestData() {
		return map;
	}

	public OnDataBack getCallback() {
		return callback;
	};

	public void setCallback(OnDataBack callback) {
		this.callback = callback;
	}

	public void addParam(String k, String v) {
		map.put(k, v);
	}

	public void removeParam(String key) {
		map.remove(key);
	}

	public void clearParam() {
		map.clear();
	}

	public String getToken() {
		return null;
	}

}
