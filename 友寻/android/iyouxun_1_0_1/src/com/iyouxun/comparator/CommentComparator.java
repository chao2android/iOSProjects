package com.iyouxun.comparator;

import java.util.Comparator;

import com.iyouxun.data.beans.CommentInfoBean;
import com.iyouxun.utils.Util;

/**
 * 评论排序
 * 
 * @ClassName: CommentComparator
 * @author likai
 * @date 2015-3-24 上午10:25:50
 * 
 */
public class CommentComparator implements Comparator<CommentInfoBean> {

	@Override
	public int compare(CommentInfoBean commentOne, CommentInfoBean commentTwo) {
		if (Util.getLong(commentOne.time) < Util.getLong(commentTwo.time)) {
			return 1;
		} else if (Util.getLong(commentOne.time) > Util.getLong(commentTwo.time)) {
			return -1;
		} else {
			return 0;
		}
	}

}
