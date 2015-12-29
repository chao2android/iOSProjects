package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 动态评论
 * 
 * @ClassName: SendCommentRequest
 * @author likai
 * @date 2015-3-20 下午3:30:37
 * 
 */
public class SendCommentRequest extends J_Request {

	public SendCommentRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.SEND_COMMENT_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_SEND_COMMENT;
	}

	public J_Request execute(String oid, String dy_id, String content) {
		addParam("oid", oid);
		addParam("dy_id", dy_id);
		addParam("content", content);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
