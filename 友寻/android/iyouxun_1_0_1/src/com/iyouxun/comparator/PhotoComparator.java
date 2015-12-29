package com.iyouxun.comparator;

import java.util.Comparator;

import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.utils.Util;

/**
 * 按照相册图片的时间倒序排列
 * 
 * @ClassName: PhotoComparator
 * @author likai
 * @date 2015-3-19 上午10:14:58
 * 
 */
public class PhotoComparator implements Comparator<PhotoInfoBean> {

	/**
	 * 如果photoOne小于photoTwo,返回一个负数;如果photoOne大于photoTwo，返回一个正数;如果他们相等，则返回0;
	 */
	@Override
	public int compare(PhotoInfoBean photoOne, PhotoInfoBean photoTwo) {
		if (Util.getInteger(photoOne.pid) > Util.getInteger(photoTwo.pid)) {
			return -1;
		} else if (photoOne.uploadTime < photoTwo.uploadTime) {
			return 1;
		} else {
			return 0;
		}
	}
}
