package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class SetUserVoiceSwitch extends J_Request {

	public SetUserVoiceSwitch(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.SET_USER_VOICE_SWITCH_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_SET_USER_VOICE_SWITCH;
	}

	public J_Request set(int voiceSwitch) {
		addParam(UtilRequest.FORM_SWITCH, voiceSwitch + "");
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}

}
