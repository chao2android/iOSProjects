package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.utils.Util;

public class UpdateGroupRequest extends J_Request {

	public UpdateGroupRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_GROUP_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_GROUP;
	}

	/**
	 * @Title: update
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @return J_Request 修改群信息
	 * @param @param groupId 群组id
	 * @param @param title 组名
	 * @param @param intro 组简介
	 * @param @param privilege 权限
	 * @param @param status 0不公开，1公开（将推荐给好友）
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request update(int groupId, String intro, int privilege) {
		addParam(UtilRequest.FORM_GROUP_ID, groupId + "");
		if (!Util.isBlankString(intro)) {
			addParam(UtilRequest.FORM_INTRO, intro);
		}
		addParam(UtilRequest.FORM_PRIVILEGE, privilege + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
