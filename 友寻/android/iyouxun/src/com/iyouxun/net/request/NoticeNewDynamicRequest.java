package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取动态新消息总数字
 * 
 * @ClassName: NoticeNewDynamicRequest
 * @author likai
 * @date 2015-4-17 下午3:00:10
 * 
 */
public class NoticeNewDynamicRequest extends J_Request {

	public NoticeNewDynamicRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.NOTICE_NEW_DYNAMIC_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_NOTICE_NEW_DYNAMIC;
	}

	public J_Request execute() {
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
