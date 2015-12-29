/**
 * 
 * @Package com.iyouxun.net.request
 * @author likai
 * @date 2015-4-28 上午11:07:22
 * @version V1.0
 */
package com.iyouxun.net.request;

import java.util.HashMap;

import com.iyouxun.J_Application;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.utils.ToastUtil;

/**
 * 
 * @author likai
 * @date 2015-4-28 上午11:07:22
 * 
 */
public class J_OnDataBack implements OnDataBack {
	/**
	 * 
	 * @param result
	 */
	@Override
	public void onResponse(Object result) {
	}

	/**
	 * 
	 * @param errorMap
	 */
	@Override
	public void onError(HashMap<String, Object> errorMap) {
		int Error = (Integer) errorMap.get(OnDataBack.KEY_ERROR);
		String errInfo = J_NetManager.getInstance().getErrorMsg(Error);
		ToastUtil.showToast(J_Application.sCurrentActiviy, errInfo);
	}

}
