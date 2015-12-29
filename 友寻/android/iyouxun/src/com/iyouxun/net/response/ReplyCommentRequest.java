package com.iyouxun.net.response;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 回复评论
 * 
 * @author likai
 * @date 2015-3-23 下午8:12:39
 * 
 */
public class ReplyCommentRequest extends J_Request {

	public ReplyCommentRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.REPLY_COMMENT_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_REPLY_COMMENT;
	}

	/**
	 * 
	 * @Title: execute
	 * @return J_Request 返回类型
	 * @param dy_uid 动态发起人的uid
	 * @param reply_uid 回复人的uid
	 * @param dy_id 动态id
	 * @param comment_id 评论id
	 * @param content 评论内容
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public J_Request execute(long dy_uid, long reply_uid, int dy_id, int comment_id, long comment_uid, String content) {
		addParam("dy_uid", dy_uid + "");
		addParam("reply_uid", reply_uid + "");
		addParam("dy_id", dy_id + "");
		addParam("comment_id", comment_id + "");
		addParam("content", content);
		addParam("comment_uid", comment_uid + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
