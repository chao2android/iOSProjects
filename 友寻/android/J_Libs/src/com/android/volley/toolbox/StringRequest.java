/*
 * Copyright (C) 2011 The Android Open Source Project
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

package com.android.volley.toolbox;

import java.io.UnsupportedEncodingException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import com.android.volley.AuthFailureError;
import com.android.volley.NetworkResponse;
import com.android.volley.Request;
import com.android.volley.Response;
import com.android.volley.Response.ErrorListener;
import com.android.volley.Response.Listener;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.utils.J_CommonUtils;

/**
 * A canned request for retrieving the response body at a given URL as a String.
 */
public class StringRequest extends Request<String> {
	private final Listener<String> mListener;

	/**
	 * Creates a new request with the given method.
	 * 
	 * @param method the request {@link Method} to use
	 * @param url URL to fetch the string at
	 * @param listener Listener to receive the String response
	 * @param errorListener Error listener, or null to ignore errors
	 */
	public StringRequest(int method, String url, Listener<String> listener, ErrorListener errorListener) {
		super(method, url, errorListener);
		mListener = listener;
	}

	/**
	 * Creates a new GET request.
	 * 
	 * @param url URL to fetch the string at
	 * @param listener Listener to receive the String response
	 * @param errorListener Error listener, or null to ignore errors
	 */
	public StringRequest(String url, Listener<String> listener, ErrorListener errorListener) {
		this(Method.GET, url, listener, errorListener);
	}

	/**
	 * Creates a new GET request.
	 * 
	 * @param url URL to fetch the string at
	 * @param listener Listener to receive the String response
	 * @param errorListener Error listener, or null to ignore errors
	 */
	public StringRequest(int method, String url, HashMap<String, String> params, Listener<String> listener,
			ErrorListener errorListener) {
		super(method, url, params, errorListener);
		mListener = listener;
	}

	@Override
	protected void deliverResponse(String response) {
		mListener.onResponse(response);
	}

	@Override
	protected Response<String> parseNetworkResponse(NetworkResponse response) {
		String parsed;
		try {
			// 读取并保存cookie(这里的cookie是最原始的Cookie信息)
			String cookies = response.headers.get("Set-Cookie");
			setCookieStore(cookies);
			// 设置编码格式
			// String dataString = new String(response.data, "UTF-8");
			parsed = new String(response.data, HttpHeaderParser.parseCharset(response.headers));
		} catch (UnsupportedEncodingException e) {
			parsed = new String(response.data);
		}
		return Response.success(parsed, HttpHeaderParser.parseCacheHeaders(response));
	}

	/**
	 * 设置header
	 * 
	 */
	@Override
	public Map<String, String> getHeaders() throws AuthFailureError {
		if (J_NetManager.VOLLEY_COOKIESTORE != null && J_NetManager.VOLLEY_COOKIESTORE.size() > 0) {
			String cookies = getCookieStore(J_NetManager.VOLLEY_COOKIESTORE);
			HashMap<String, String> headers = new HashMap<String, String>();
			headers.put("Charset", "UTF-8");
			headers.put("Cookie", cookies);
			// 存储cookie
			J_NetManager.VolleyCookie = cookies;
			return headers;
		}
		return super.getHeaders();
	}

	/**
	 * 存储cookie信息
	 * 
	 * @return void 返回类型
	 * @param @param cookies 参数类型
	 * @author likai
	 */
	private void setCookieStore(String cookies) {
		if (!J_CommonUtils.isBlankString(cookies)) {
			cookies = cookies.replaceAll(" ", "");
			cookies = cookies.replaceAll("\n", "");
			String[] allCookie = cookies.split(";");
			if (allCookie.length > 0) {
				for (int i = 0; i < allCookie.length; i++) {
					String[] keyPair = allCookie[i].split("=");
					String key = keyPair[0].trim();
					String value = keyPair.length > 1 ? keyPair[1].trim() : "";
					if (!J_CommonUtils.isBlankString(key) && !J_CommonUtils.isBlankString(value)) {
						J_NetManager.VOLLEY_COOKIESTORE.put(key, value);
					}
				}
			}
		}
	}

	/**
	 * 获取cookie信息
	 * 
	 * @return String 返回类型
	 * @param @param cookieStore
	 * @param @return 参数类型
	 * @author likai
	 */
	private String getCookieStore(Map<String, String> cookieStore) {
		String cookies = "";
		Iterator iter = cookieStore.entrySet().iterator();
		while (iter.hasNext()) {
			Map.Entry entry = (Map.Entry) iter.next();
			String key = entry.getKey().toString();
			String val = entry.getValue().toString();
			cookies += key + "=" + val + ";";
		}
		return cookies;
	}
}
