package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * @ClassName: NewPasswordGetSecurityCodeRequest
 * @Description: 重置密码获取验证码
 * @author donglizhi
 * @date 2015年3月6日 上午10:18:11
 * 
 */
public class NewPasswordGetSecurityCodeRequest extends J_Request {

	public NewPasswordGetSecurityCodeRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.NEW_PASSWORD_GET_SECURITY_CODE_URL;// 请求地址
		this.REQUEST_TYPE = NetTaskIDs.TASKID_NEW_PASSWORD_GET_SECURITY_CODE;// 请求task的id
	}

	/**
	 * @Title: getCode
	 * @Description: 重置密码获取验证码验证码
	 * @return J_Request 返回类型
	 * @param @param formStr 手机号
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request getCode(String mobile) {
		addParam(UtilRequest.FORM_MOBILE, mobile);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
