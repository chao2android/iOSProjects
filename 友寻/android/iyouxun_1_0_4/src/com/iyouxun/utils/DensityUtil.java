package com.iyouxun.utils;

import com.iyouxun.J_Application;

public class DensityUtil {
	/**
	 * 根据手机的分辨率从 dp 的单位 转成为 px(像素)
	 */
	public static int dip2px(float dpValue) {
		final float scale = J_Application.context.getResources().getDisplayMetrics().density;
		return (int) (dpValue * scale + 0.5f);
	}

	/**
	 * 根据手机的分辨率从 px(像素) 的单位 转成为 dp
	 */
	public static int px2dipfloat(float pxValue) {
		final float scale = J_Application.context.getResources().getDisplayMetrics().density;
		return (int) (pxValue / scale + 0.5f);
	}

	/**
	 * 获取屏幕的宽高 [0] w [1] h
	 * */
	public static int[] getWindowWH() {
		int[] wh = new int[2];
		wh[0] = J_Application.context.getResources().getDisplayMetrics().widthPixels;
		wh[1] = J_Application.context.getResources().getDisplayMetrics().heightPixels;
		return wh;
	}

	/**
	 * 根据屏幕的宽度自动适应语音背景的宽度(用于聊天背景长度自适应)
	 * 
	 * @param len 语音长度
	 * @return 在屏幕中要显式的像素大小
	 */
	public static int autoResizeWidth(int len) {
		if (len < 1) {
			len = 1;
		}
		/* 头像和间隔及其他内容所占用的像素值 */
		int w = DensityUtil.dip2px(120);
		/* 屏幕上宽度的总的像素值 */
		int widthPixels = J_Application.context.getResources().getDisplayMetrics().widthPixels;
		/* 剩余像素值,即语音背景 */
		int wPixel = widthPixels - w;
		/* 语音背景的最小宽度像素值用来显示喇叭 */
		int minWidth = DensityUtil.dip2px(60);
		/* 根据语音长度计算的宽度像素值 留出一个最小的长度用来显示喇叭 然后在剩余的长度里按照n/60增加长度 */
		int width = (int) ((wPixel - minWidth) * len / 59.0f + 0.5f) + minWidth;
		/* 如果小于最小宽度值,则返回最小宽度值,反之返回计算出来的宽度值(单位:像素) */
		return width < minWidth ? minWidth : width;
	}
}
