package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.utils.SharedPreUtil;

/**
 * 更新签名
 * 
 * @ClassName: UpdateUserIntroRequest
 * @author likai
 * @date 2015-3-3 下午6:20:42
 * 
 */
public class UpdateUserIntroRequest extends J_Request {

	public UpdateUserIntroRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_USER_INTRO_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_USER_INTRO;
	}

	public J_Request execute(String value) {
		addParam("uid", SharedPreUtil.getLoginInfo().uid + "");
		addParam("intro", value);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
