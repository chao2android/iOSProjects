package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * @ClassName: VaildMobileRequest
 * @Description: 验证手机号是否存在
 * @author donglizhi
 * @date 2015年3月6日 上午11:30:09
 * 
 */
public class VaildMobileRequest extends J_Request {

	public VaildMobileRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.VAILD_MOBILE_EXISTS_URL;// 请求地址
		this.REQUEST_TYPE = NetTaskIDs.TASKID_VAILD_MOBILE_EXISTS;// 请求task的id
	}

	/**
	 * @Title: vaildMobile
	 * @Description: 验证手机号是否存在
	 * @return J_Request 返回类型
	 * @param @param formStr
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request vaildMobile(String formStr) {
		addParam(UtilRequest.FORM_FORM, formStr);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
