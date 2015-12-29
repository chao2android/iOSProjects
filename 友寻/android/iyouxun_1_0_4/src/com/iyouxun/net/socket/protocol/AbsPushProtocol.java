package com.iyouxun.net.socket.protocol;

import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.beans.socket.PushMsgInfo;
/***
 * 推送协议栈，所有关于推送的协议继承此类
 * @author Administrator
 *
 */
@SuppressWarnings("serial")
public abstract class AbsPushProtocol extends SocketProtocol {
	public PushMsgInfo bean;

	@Override
	public String getBroadcastAction() {
		return J_Consts.ACTION_PUSH;
	}

	@Override
	public String getRequestStr() {
		return null;
	}
}
