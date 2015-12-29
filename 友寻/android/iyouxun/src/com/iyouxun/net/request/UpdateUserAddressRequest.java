package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.utils.SharedPreUtil;

/**
 * 更新用户常住地
 * 
 * @ClassName: UpdateUserAddressRequest
 * @author likai
 * @date 2015-3-4 下午3:20:07
 * 
 */
public class UpdateUserAddressRequest extends J_Request {

	public UpdateUserAddressRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.UPDATE_USER_ADDRESS_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_UPDATE_USER_ADDRESS;
	}

	public J_Request execute(String address) {
		addParam("uid", SharedPreUtil.getLoginInfo().uid + "");
		addParam("address", address);

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
