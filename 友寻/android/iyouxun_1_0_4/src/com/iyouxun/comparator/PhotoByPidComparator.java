/**
 * 
 * @Package com.iyouxun.comparator
 * @author likai
 * @date 2015-5-27 下午3:19:13
 * @version V1.0
 */
package com.iyouxun.comparator;

import java.util.Comparator;

import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.utils.Util;

/**
 * 图片按照pid从小到大排序，保持顺序
 * 
 * @author likai
 * @date 2015-5-27 下午3:19:13
 * 
 */
public class PhotoByPidComparator implements Comparator<PhotoInfoBean> {

	/**
	 * 
	 * @param lhs
	 * @param rhs
	 * @return
	 */
	@Override
	public int compare(PhotoInfoBean photoOne, PhotoInfoBean photoTwo) {
		if (Util.getInteger(photoOne.pid) > Util.getInteger(photoTwo.pid)) {
			return -1;
		} else if (Util.getInteger(photoOne.pid) < Util.getInteger(photoTwo.pid)) {
			return 1;
		} else {
			return 0;
		}
	}

}
