package com.iyouxun.comparator;

import java.util.Comparator;

import com.iyouxun.data.chat.ChatItem;

/**
 * 用户排序
 * 
 * @param <T>
 * 
 * */
public class ChatMsgComparator implements Comparator<ChatItem> {

	/**
	 * 联系人列表用户，按照最后聊天时间按时间由大到小的顺序排列
	 * 
	 * */
	@Override
	public int compare(ChatItem msg1, ChatItem msg2) {
		try {
			if (msg1.getTimeStamp() != null && msg2.getTimeStamp() != null) {
				long time1 = Long.valueOf(msg1.getTimeStamp());
				long time2 = Long.valueOf(msg2.getTimeStamp());
				if (time1 > 0 && time2 > 0) {
					if (time1 > time2) {
						return 1;// 时间大的返回1
					} else if (time1 < time2) {
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
