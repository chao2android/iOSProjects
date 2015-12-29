package com.iyouxun.net.socket.protocol;

import java.io.Serializable;

import org.json.JSONException;
import org.json.JSONObject;

import com.iyouxun.utils.DLog;

public abstract class SocketProtocol implements Serializable {
	private static final long serialVersionUID = 113L;

	protected static final String KEY_CMD = "cmd";
	protected static final String KEY_DATA = "data";
	protected static final String KEY_NICK = "nick";
	protected static final String KEY_FROM = "from";
	protected static final String KEY_FID = "fid";
	protected static final String KEY_TIMER = "timer";
	protected static final String KEY_PUSHTYPE = "pushtype";
	protected static final String KEY_REPLAY = "replay";

	/** 生成请求串 */
	protected abstract String getRequestStr();

	/** 组装请求串 */
	public String appendRequestStr() {
		String str = getRequestStr();
		byte[] len = intToByteArray(str.getBytes().length);
		String sendstr = "";
		try {
			sendstr = new String(len, "UTF-8") + str;
		} catch (Exception e) {
			DLog.e(e);
		}
		return sendstr;
	}

	/**
	 * 获得服务器返回结果
	 * 
	 * @throws JSONException
	 */
	public abstract SocketProtocol getResponseObj(JSONObject object) throws JSONException;

	/** 获取广播的Action */
	public String getBroadcastAction() {
		return null;
	}

	public static byte[] intToByteArray(int value) {
		byte[] b = new byte[4];
		for (int i = 0; i < 4; i++) {
			b[i] = (byte) (value >> 8 * (3 - i) & 0xFF);
		}
		return b;
	}

	public String getLTag() {
		return getClass().getSimpleName();
	}

	public void sendMsgFail(String str) {

	}
}
