package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * @ClassName: GetSecurityCodeRequest
 * @Description:获取验证码请求
 * @author donglizhi
 * @date 2015年3月6日 上午11:28:23
 * 
 */
public class GetSecurityCodeRequest extends J_Request {

	public GetSecurityCodeRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.GET_SECURITY_CODE_URL;// 请求地址
		this.REQUEST_TYPE = NetTaskIDs.TASKID_GET_SECURITY_CODE;// 请求task的id
	}

	/**
	 * @Title: getCode
	 * @Description: 获取注册验证码
	 * @return J_Request 返回类型
	 * @param @param formStr 手机号
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request getCode(String formStr) {
		addParam(UtilRequest.FORM_FORM, formStr);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
