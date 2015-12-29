package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * @ClassName: VaildMobileCodeRequest
 * @Description: 验证验证码是否正确
 * @author donglizhi
 * @date 2015年3月6日 上午11:29:53
 * 
 */
public class VaildMobileCodeRequest extends J_Request {

	public VaildMobileCodeRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.VAILD_MOBILE_CODE_URL;// 请求地址
		this.REQUEST_TYPE = NetTaskIDs.TASKID_VAILD_MOBILE_CODE;// 请求task的id
	}

	/**
	 * @Title: vaildMobile
	 * @Description: 验证验证码是否正确
	 * @return J_Request 返回类型
	 * @param @param formStr
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request vaildMobileCode(String formStr) {
		addParam(UtilRequest.FORM_FORM, formStr);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
