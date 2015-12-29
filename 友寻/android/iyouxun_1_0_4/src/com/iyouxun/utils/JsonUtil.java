package com.iyouxun.utils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class JsonUtil {

	public static String getJsonString(JSONObject obj, String key) {
		String res = null;
		res = obj.optString(key);
		return res;
	}

	public static int parseToInt(String str) {
		int i = 0;
		try {
			i = Integer.parseInt((str == null || str.equals("")) ? "0" : str);
		} catch (Exception e) {
			i = 0;
		}
		return i;
	}

	public static JSONObject getJsonObject(JSONObject obj, String key) {
		return obj.optJSONObject(key);
	}

	public static int[] getJsonArray(JSONObject obj, String key) {
		if (obj.has(key)) {
			JSONArray res = null;
			int[] list = null;
			try {
				res = obj.getJSONArray(key);
				int length = res.length();
				list = new int[length];
				for (int i = 0; i < length; i++) {// 遍历JSONArray
					list[i] = res.getInt(i);
				}

			} catch (JSONException e) {
				DLog.e("json:" + obj.toString() + " get property:" + key + " error!");
			}
			return list;
		}
		return null;
	}

	public static String[] getJsonStrArray(JSONObject obj, String key) {
		if (obj.has(key)) {
			JSONArray res = null;
			String[] list = null;
			try {
				res = obj.getJSONArray(key);
				int length = res.length();
				list = new String[length];
				for (int i = 0; i < length; i++) {// 遍历JSONArray
					list[i] = res.optString(i);
				}
			} catch (JSONException e) {
				DLog.e("json:" + obj.toString() + " get property:" + key + " error!");
			}
			return list;
		}
		return null;
	}

}
