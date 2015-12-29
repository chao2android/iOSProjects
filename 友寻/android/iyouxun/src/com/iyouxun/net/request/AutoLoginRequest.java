package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 登录请求
 * 
 * @author likai
 * @date 2014年10月14日 下午2:43:54
 */
public class AutoLoginRequest extends J_Request {

	public AutoLoginRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.AUTO_LOGIN_URL;// 请求地址
		this.REQUEST_TYPE = NetTaskIDs.TASKID_AUTO_LOGIN;// 请求task的id
	}

	/**
	 * 发送请求
	 * 
	 * @return J_Request 返回类型
	 * @param $abnormal int 0-正常登陆，1-异常登陆
	 * @param @return 参数类型
	 * @author likai
	 */
	public J_Request login(String token, int abnormal) {
		// 设置参数
		addParam("abnormal", abnormal + "");
		addParam(UtilRequest.FORM_TOKEN, token);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
