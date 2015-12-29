package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * @ClassName: SetNewPasswordRequest
 * @Description: 重置密码请求
 * @author donglizhi
 * @date 2015年3月6日 上午11:29:16
 * 
 */
public class SetNewPasswordRequest extends J_Request {

	public SetNewPasswordRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.SET_NEW_PASSWORD_URL;// 请求地址
		this.REQUEST_TYPE = NetTaskIDs.TASKID_SET_NEW_PASSWORD;// 请求task的id
	}

	/**
	 * @Title: execute
	 * @Description: 重置密码
	 * @return J_Request 返回类型
	 * @param @param mobile 手机号
	 * @param @param securityCode 验证码
	 * @param @param password 新密码
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request execute(String mobile, String securityCode, String password) {
		// 设置参数

		addParam(UtilRequest.FORM_MOBILE, mobile);
		addParam(UtilRequest.FORM_CODE, securityCode);
		addParam(UtilRequest.FORM_NEW, password);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
