package com.iyouxun.j_libs.net.socket;

import java.net.InetSocketAddress;

import org.apache.mina.core.future.ConnectFuture;
import org.apache.mina.core.service.IoHandlerAdapter;
import org.apache.mina.core.session.IoSession;
import org.apache.mina.filter.codec.ProtocolCodecFactory;
import org.apache.mina.filter.codec.ProtocolCodecFilter;
import org.apache.mina.transport.socket.nio.NioSocketConnector;

import android.content.Intent;

import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.j_libs.log.J_Log;
import com.iyouxun.j_libs.managers.J_PushManager;
import com.iyouxun.j_libs.utils.J_NetUtil;

public class J_NioSocketConnector {

	private NioSocketConnector socketConnector = null;
	private ConnectFuture connectFuture;
	private IoSession session;

	private ProtocolCodecFactory codecFactory = null;
	private IoHandlerAdapter ioHandlerAdapter = null;

	public J_NioSocketConnector(ProtocolCodecFactory codecFactory, IoHandlerAdapter ioHandlerAdapter) {
		this.codecFactory = codecFactory;
		this.ioHandlerAdapter = ioHandlerAdapter;
	}

	public boolean connect(String host, int port, long connTimeout) {

		if (J_SDK.getContext() == null) {
			J_Log.e("J_SDK.getContext() == null  框架没有被初始化");
			return false;
		}

		if (!J_NetUtil.isNetConnected(J_SDK.getContext())) {
			J_Log.e("当前网络不可用！无法建立Socket链接");
			return false;
		}

		if (socketConnector == null || socketConnector.isDisposed()) {
			socketConnector = new NioSocketConnector();
			socketConnector.setConnectTimeoutMillis(connTimeout);
			socketConnector.getSessionConfig().setBothIdleTime(60 * 5);
			socketConnector.getSessionConfig().setKeepAlive(true);
			socketConnector.getFilterChain().addLast("encode", new ProtocolCodecFilter(codecFactory));
			socketConnector.setHandler(ioHandlerAdapter);
		}

		connectFuture = socketConnector.connect(new InetSocketAddress(host, port));
		connectFuture.awaitUninterruptibly();
		try {
			session = connectFuture.getSession();
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}

		return true;
	}

	public boolean close() {
		if (session != null) {
			session.close(true);
		}

		if (socketConnector != null && !socketConnector.isDisposed()) {
			socketConnector.dispose();
		}
		return true;
	}

	public boolean isConnected() {
		if (session == null || socketConnector == null) {
			return false;
		}
		return session.isConnected();
	}

	public Intent send(String msg) {
		Intent intent = new Intent();
		if (session == null) {
			J_Log.i("session == null");
			intent.putExtra(J_PushManager.KEY_FAIL_TYPE, J_PushManager.STATUS_CONNEC_CLOSED);
			intent.putExtra(J_PushManager.KEY_SEND_STATUS, false);
			return intent;
		}
		if (msg == null) {
			J_Log.i("msg == null");
			intent.putExtra(J_PushManager.KEY_SEND_STATUS, false);
			return intent;
		}
		if (session.isClosing()) {
			J_Log.i("session.isClosing()");
			intent.putExtra(J_PushManager.KEY_FAIL_TYPE, J_PushManager.STATUS_CONNEC_CLOSED);
			intent.putExtra(J_PushManager.KEY_SEND_STATUS, false);
			return intent;
		}
		intent.putExtra(J_PushManager.KEY_SEND_STATUS, session.write(msg).awaitUninterruptibly().isWritten());
		return intent;
	}

}
