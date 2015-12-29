package com.iyouxun.net.response;

import com.iyouxun.j_libs.net.response.J_Response;

/**
 * @ClassName: SendTextMsgResonse
 * @Description: 发送文本消息返回
 * @author donglizhi
 * @date 2015年3月17日 下午5:29:27
 * 
 */
public class SendTextMsgResonse extends J_Response {
	public String iid;// 消息id
	public long chat_table_id;// 消息在数据库表中_id
	public String time = "";// 系统返回的消息时间戳
	public int status;// 消息发送状态
}
