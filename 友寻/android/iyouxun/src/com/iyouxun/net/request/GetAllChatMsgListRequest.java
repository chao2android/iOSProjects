package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class GetAllChatMsgListRequest extends J_Request {

	public GetAllChatMsgListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_ALL_CHAT_MSG_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_ALL_CHAT_MSG_LIST;
	}

	/**
	 * @Title: get
	 * @Description: 获取全部聊天消息列表
	 * @return J_Request 返回类型
	 * @param @param page 页码 @default 1 @min 1
	 * @param @param pageSize 页码 @default 1 @min 1 @max 20
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request get(int page, int pageSize) {
		addParam(UtilRequest.FORM_PAGE_SIZE, pageSize + "");
		addParam(UtilRequest.FORM_PAGE, page + "");
		addParam(UtilRequest.FORM_AVATAR_SIZE, "150");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}

}
