package com.iyouxun.comparator;

import java.util.Comparator;

import com.iyouxun.data.beans.SortInfoBean;

/**
 * 按照拼音字母排序
 * 
 * 
 */
public class PinyinComparator implements Comparator<SortInfoBean> {

	@Override
	public int compare(SortInfoBean o1, SortInfoBean o2) {
		if ((o1.sortLetter.equals("#") || o1.sortLetter.equals("@")) && !o2.sortLetter.equals("#") && !o2.sortLetter.equals("@")) {
			return 1;
		} else if (!(o1.sortLetter.equals("#") || o1.sortLetter.equals("@"))
				&& (o2.sortLetter.equals("#") || o2.sortLetter.equals("@"))) {
			return -1;
		} else if (o1.sortLetter.equals("#") && o2.sortLetter.equals("@")) {
			return -1;
		} else if (o1.sortLetter.equals("@") && o2.sortLetter.equals("#")) {
			return 1;
		} else {
			return o1.sortLetter.compareTo(o2.sortLetter);
		}
	}
}
