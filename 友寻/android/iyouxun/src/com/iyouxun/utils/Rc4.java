package com.iyouxun.utils;

import java.io.UnsupportedEncodingException;

/**
 * RC4加密
 * 
 * @author likai
 * @date 2014年11月19日 上午10:39:22
 */
public class Rc4 {

	public static String decryptionRC4(byte[] data, String key) {
		if (data == null || key == null) {
			return null;
		}
		return new String(RC4Base(data, key));
	}

	public static byte[] encryptionRC4Byte(String data, String key) {
		if (data == null || key == null) {
			return null;
		}
		byte b_data[] = null;
		try {
			b_data = data.getBytes("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return RC4Base(b_data, key);
	}

	private static byte[] initKey(String aKey) {
		byte[] b_key = null;
		try {
			b_key = aKey.getBytes("UTF-8");
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		byte state[] = new byte[256];
		for (int i = 0; i < 256; i++) {
			state[i] = (byte) i;
		}
		int index1 = 0;
		int index2 = 0;
		if (b_key == null || b_key.length == 0) {
			return null;
		}
		for (int i = 0; i < 256; i++) {
			index2 = ((b_key[index1] & 0xff) + (state[i] & 0xff) + index2) & 0xff;
			byte tmp = state[i];
			state[i] = state[index2];
			state[index2] = tmp;
			index1 = (index1 + 1) % b_key.length;
		}
		return state;
	}

	private static byte[] RC4Base(byte[] input, String mKkey) {
		int x = 0;
		int y = 0;
		byte key[] = initKey(mKkey);
		int xorIndex;
		byte[] result = new byte[input.length];
		for (int i = 0; i < input.length; i++) {
			x = (x + 1) & 0xff;
			y = ((key[x] & 0xff) + y) & 0xff;
			byte tmp = key[x];
			key[x] = key[y];
			key[y] = tmp;
			xorIndex = ((key[x] & 0xff) + (key[y] & 0xff)) & 0xff;
			result[i] = (byte) (input[i] ^ key[xorIndex]);
		}
		return result;
	}

}