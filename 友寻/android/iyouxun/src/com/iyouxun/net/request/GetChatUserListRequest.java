package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.utils.Util;

/**
 * @ClassName: GetChatUserListRequest
 * @Description: 获得聊天用户列表
 * @author donglizhi
 * @date 2015年3月19日 下午2:42:48
 * 
 */
public class GetChatUserListRequest extends J_Request {

	public GetChatUserListRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_CHAT_USER_LIST_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_CHAT_USER_LIST;
	}

	/**
	 * @Title: get
	 * @Description: 获得聊天用户列表
	 * @return J_Request 返回类型
	 * @param @param pageSize 每页数量
	 * @param @param timestamp 时间戳
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request get(String pageSize, String timestamp) {
		if (!Util.isBlankString(timestamp)) {
			addParam(UtilRequest.FORM_TIMESTAMP, timestamp);
		}
		addParam(UtilRequest.FORM_PAGE_SIZE, pageSize);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
