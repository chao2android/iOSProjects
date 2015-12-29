package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.users.LoginUser;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.location.J_LocationPoint;
import com.iyouxun.utils.SharedPreUtil;

/**
 * @ClassName: LoginRequest
 * @Description: 登录请求
 * @author donglizhi
 * @date 2015年3月6日 上午11:28:39
 * 
 */
public class LoginRequest extends J_Request {

	public LoginRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.LOGIN_URL;// 请求地址
		this.REQUEST_TYPE = NetTaskIDs.TASKID_LOGIN;// 请求task的id
	}

	public J_Request execute(String name, String password) {
		// 设置坐标
		J_LocationPoint location = SharedPreUtil.getLocation();
		LoginUser user = SharedPreUtil.getLoginInfo();
		user.userName = name;
		SharedPreUtil.saveLoginInfo(user);
		addParam("lat", location.getLatitude());
		addParam("lng", location.getLongitude());
		addParam(UtilRequest.FORM_NAME, name);
		addParam(UtilRequest.FORM_PASSWORD, password);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
