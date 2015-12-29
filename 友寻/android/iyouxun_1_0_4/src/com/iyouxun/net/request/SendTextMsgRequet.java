package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * @ClassName: SendTextMsgRequet
 * @Description: 发送一条文本消息
 * @author donglizhi
 * @date 2015年3月16日 下午5:11:07
 * 
 */
public class SendTextMsgRequet extends J_Request {

	public SendTextMsgRequet(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.SEND_TEXT_MSG_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_SEND_TEXT_MSG;
	}

	public J_Request send(String form, long chat_table_id) {
		this.CHAT_TABLE_ID = chat_table_id;
		addParam(UtilRequest.FORM_FORM, form);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
