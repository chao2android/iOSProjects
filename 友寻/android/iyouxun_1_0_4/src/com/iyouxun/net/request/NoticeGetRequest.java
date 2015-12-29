package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取通知消息数字
 * 
 * @ClassName: NoticeGetRequest
 * @author likai
 * @date 2015-4-17 下午2:23:15
 * 
 */
public class NoticeGetRequest extends J_Request {

	public NoticeGetRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.NOTICE_GET_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_NOTICE_GET;
	}

	public J_Request execute() {
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
