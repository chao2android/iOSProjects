/**
 * 
 * @Package com.iyouxun.comparator
 * @author likai
 * @date 2015-5-8 下午3:50:14
 * @version V1.0
 */
package com.iyouxun.comparator;

import java.util.Comparator;

import com.iyouxun.data.beans.TagsInfoBean;

/**
 * 
 * @author likai
 * @date 2015-5-8 下午3:50:14
 * 
 */
public class TagListComparator implements Comparator<TagsInfoBean> {
	/**
	 * 标签模块先按照数字由高到低排列，同一数字的标签按照更新时间倒序排列
	 * 
	 * @param lhs
	 * @param rhs
	 * @return
	 */
	@Override
	public int compare(TagsInfoBean lhs, TagsInfoBean rhs) {
		if (lhs.clickNum > rhs.clickNum) {
			return -1;
		} else if (lhs.clickNum < rhs.clickNum) {
			return 1;
		} else {
			if (lhs.updateTime > rhs.updateTime) {
				return -1;
			} else if (lhs.updateTime < rhs.updateTime) {
				return 1;
			} else {
				return 0;
			}
		}
	}

}
