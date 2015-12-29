package com.iyouxun.comparator;

import java.util.Comparator;

import com.iyouxun.data.beans.ManageFriendsBean;

/**
 * 按照拼音字母#@排序
 * 
 * 
 */
public class FriendsPinyinComparator implements Comparator<ManageFriendsBean> {

	@Override
	public int compare(ManageFriendsBean o1, ManageFriendsBean o2) {
		if ((o1.getSortLetter().equals("#") || o1.getSortLetter().equals("@")) && !o2.getSortLetter().equals("#")
				&& !o2.getSortLetter().equals("@")) {
			return 1;
		} else if (!(o1.getSortLetter().equals("#") || o1.getSortLetter().equals("@"))
				&& (o2.getSortLetter().equals("#") || o2.getSortLetter().equals("@"))) {
			return -1;
		} else if (o1.getSortLetter().equals("#") && o2.getSortLetter().equals("@")) {
			return -1;
		} else if (o1.getSortLetter().equals("@") && o2.getSortLetter().equals("#")) {
			return 1;
		} else {
			return o1.getSortLetter().compareTo(o2.getSortLetter());
		}
	}
}
