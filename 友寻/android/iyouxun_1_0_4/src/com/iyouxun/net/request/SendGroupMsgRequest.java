package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class SendGroupMsgRequest extends J_Request {

	public SendGroupMsgRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.SEND_GROUP_MSG_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_SEND_GROUP_MSG;
	}

	/**
	 * @Title: send
	 * @Description: 发送群聊信息
	 * @return J_Request 返回类型
	 * @param @param form
	 * @param @param chat_table_id 消息本地id
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request send(String form, long chat_table_id) {
		this.CHAT_TABLE_ID = chat_table_id;
		addParam(UtilRequest.FORM_FORM, form);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
