package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 删除动态评论
 * 
 * @author likai
 * @date 2015-3-24 下午5:07:56
 * 
 */
public class DelCommentRequest extends J_Request {

	public DelCommentRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.DEL_COMMENT_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_DEL_COMMENT;
	}

	public J_Request execute(int dy_id, long dy_uid, int comment_id) {
		addParam("dy_id", dy_id + "");
		addParam("dy_uid", dy_uid + "");
		addParam("comment_id", comment_id + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
