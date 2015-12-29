package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * @ClassName: DoRegisterRequest
 * @Description: 注册请求
 * @author donglizhi
 * @date 2015年3月6日 上午11:28:08
 * 
 */
public class DoRegisterRequest extends J_Request {

	public DoRegisterRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.DO_REGISTER_URL;// 请求地址
		this.REQUEST_TYPE = NetTaskIDs.TASKID_DO_REGISTER;// 请求task的id
	}

	/**
	 * @Title: doRegister
	 * @Description: TODO(这里用一句话描述这个方法的作用)
	 * @return J_Request 返回类型
	 * @param @param formStr
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request doRegister(String formStr) {
		// 设置参数

		addParam(UtilRequest.FORM_FORM, formStr);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
