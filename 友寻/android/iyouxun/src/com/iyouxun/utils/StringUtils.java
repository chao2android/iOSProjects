package com.iyouxun.utils;

import java.io.UnsupportedEncodingException;

/**
 * 文字处理工具
 * 
 * @ClassName: TextUtils
 * @author likai
 * @date 2015-3-19 上午10:46:54
 * 
 */
public class StringUtils {
	/**
	 * 获取指定长度的输入内容
	 * 
	 * @return String 返回类型
	 * @param inputStr 要检测的文字
	 * @param maxLength 限制的长度(按照最大的字符个数，1个汉字2个字符)
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String getLimitSubstring(String inputStr, int maxLength) {
		int orignLen = inputStr.length();
		int resultLen = 0;
		String temp = null;
		for (int i = 0; i < orignLen; i++) {
			temp = inputStr.substring(i, i + 1);
			try {
				// 3 bytes to indicate chinese word,1 byte to indicate english
				// word ,in utf-8 encode
				if (temp.getBytes("utf-8").length == 3) {
					resultLen += 2;
				} else {
					resultLen++;
				}
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
			if (resultLen > maxLength) {
				return inputStr.substring(0, i);
			}
		}
		return inputStr;
	}

	/**
	 * 获取指定长度的输入内容
	 * 
	 * @return String 返回类型
	 * @param inputStr 要检测的文字
	 * @param maxLength 限制的长度(按照最大的字符个数，1个汉字2个字符)
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static String getLimitSubstringWithMore(String inputStr, int maxLength) {
		String temp = "";

		if (!Util.isBlankString(inputStr)) {
			int orignLen = inputStr.length();
			if (orignLen <= maxLength) {
				return inputStr;
			} else {
				temp = inputStr.substring(0, maxLength) + "...";
			}
		}

		return temp;
	}

	/**
	 * 获取字符长度
	 * 
	 * @return int 返回类型
	 * @param @param inputStr
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static int getStringLength(String inputStr) {
		int orignLen = inputStr.length();
		int resultLen = 0;
		String temp = null;
		for (int i = 0; i < orignLen; i++) {
			temp = inputStr.substring(i, i + 1);
			try {
				// 3 bytes to indicate chinese word,1 byte to indicate english
				// word ,in utf-8 encode
				if (temp.getBytes("utf-8").length == 3) {
					resultLen += 2;
				} else {
					resultLen++;
				}
			} catch (UnsupportedEncodingException e) {
				e.printStackTrace();
			}
		}
		return resultLen;
	}
}
