package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * @ClassName: GetHistoryUserChatListRequest
 * @Description:获得离线消息数据
 * @author donglizhi
 * @date 2015年3月18日 下午2:21:24
 * 
 */
public class GetHistoryUserChatListRequest extends J_Request {

	public GetHistoryUserChatListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_HISTORY_USER_CHAT_LIST;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_HISTORY_USER_CHAT_LIST;
	}

	public J_Request get(String oid, String iid, String pageSize) {
		addParam(UtilRequest.FORM_PAGE_SIZE, pageSize);
		addParam(UtilRequest.FORM_OID, oid);
		addParam(UtilRequest.FORM_IID, iid);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
