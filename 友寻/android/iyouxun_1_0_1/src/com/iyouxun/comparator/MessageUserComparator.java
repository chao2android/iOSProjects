package com.iyouxun.comparator;

import java.util.Comparator;

import com.iyouxun.data.chat.MessageListCell;
import com.iyouxun.utils.Util;

/**
 * 用户排序
 * 
 * @param <T>
 * 
 * */
public class MessageUserComparator implements Comparator<MessageListCell> {

	/**
	 * 联系人列表用户，按照最后聊天时间按时间由大到小的顺序排列
	 * 
	 * */
	@Override
	public int compare(MessageListCell user1, MessageListCell user2) {
		try {
			if (user1.systemMsg || user2.systemMsg) {// 系统条目不排序
				return 0;
			}
			if (!Util.isBlankString(user1.timeStamp) && !Util.isBlankString(user2.timeStamp)) {
				long time1 = Long.valueOf(user1.timeStamp);
				long time2 = Long.valueOf(user2.timeStamp);
				if (time1 > 0 && time2 > 0) {
					if (time1 < time2) {
						return 1;// 时间大的返回1
					} else if (time1 > time2) {
						return -1;// 时间小的返回-1---这里很重要，小的一定要返回-1
					} else {
						return 0;// 0表示序列不变
					}
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}
}
