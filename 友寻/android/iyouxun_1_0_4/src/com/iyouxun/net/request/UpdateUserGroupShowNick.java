package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class UpdateUserGroupShowNick extends J_Request {

	public UpdateUserGroupShowNick(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_USER_GROUP_SHOW_NICK_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_USER_GROUP_SHOW_NICK;
	}

	/**
	 * @Title: update
	 * @Description: 更新是否展示群聊昵称
	 * @return J_Request 返回类型
	 * @param @param groupId 群组id
	 * @param @param showNick 0展示1不展示
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request update(String groupId, int showNick) {
		addParam(UtilRequest.FORM_GROUP_ID, groupId);
		addParam(UtilRequest.FORM_SHOW_NICK, showNick + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
