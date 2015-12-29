package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class GetHistoryGroupChatListRequest extends J_Request {

	public GetHistoryGroupChatListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_HISTORY_GROUP_CHAT_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_HISTORY_GROUP_CHAT_LIST;
	}

	/**
	 * @Title: get
	 * @Description: 获取群消息未读历史记录
	 * @return J_Request 返回类型
	 * @param @param groupId 群组id
	 * @param @param iid 消息id
	 * @param @param pageSize
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request get(String groupId, String iid, int pageSize) {
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		addParam(UtilRequest.FORM_PAGE_SIZE, pageSize + "");
		addParam(UtilRequest.FORM_IID, iid);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
