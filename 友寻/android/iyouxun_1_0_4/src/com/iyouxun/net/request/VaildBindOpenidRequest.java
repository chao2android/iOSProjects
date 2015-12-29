package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * @ClassName: VaildBindOpenidRequest
 * @Description: 查看第三方平台绑定状态
 * @author donglizhi
 * @date 2015年3月6日 下午7:06:01
 * 
 */
public class VaildBindOpenidRequest extends J_Request {

	public VaildBindOpenidRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.VAILD_BIND_OPENID_URL;// 请求地址
		this.REQUEST_TYPE = NetTaskIDs.TASKID_VAILD_BIND_OPENID;// 请求task的id
	}

	/**
	 * @Title: vaild
	 * @Description: 验证第三方平台绑定状态
	 * @return J_Request 返回类型
	 * @param @param openid
	 * @param @param type
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request vaild(String openid, String type) {
		addParam(UtilRequest.FORM_OPEN_ID, openid);
		addParam(UtilRequest.FORM_TYPE, type);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
