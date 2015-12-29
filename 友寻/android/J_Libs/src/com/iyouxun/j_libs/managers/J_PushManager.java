package com.iyouxun.j_libs.managers;

import org.apache.mina.core.service.IoHandlerAdapter;
import org.apache.mina.core.session.IoSession;
import org.apache.mina.core.session.IoSessionConfig;
import org.apache.mina.filter.codec.ProtocolCodecFactory;
import org.apache.mina.transport.socket.SocketSessionConfig;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;

import com.iyouxun.j_libs.log.J_Log;
import com.iyouxun.j_libs.net.socket.J_NioSocketConnector;

public class J_PushManager {
	
	public static final int STATUS_BEGAIN_CONNECT = 0 ;
	public static final int STATUS_CONNEC_CLOSED = 1 ;
	public static final int STATUS_CONNECT_SUCCESS = 2 ;
	public static final int STATUS_RECEIVE_MSG = 3 ;
	public static final int STATUS_SEND_MSG_SUCCESS = 4 ;
	public static final int STATUS_SEND_MSG_FAIL = 5 ;
	public static final int STATUS_ERROR = 6 ;
	/**发送消息状态*/
	public static final String KEY_SEND_STATUS = "send_status";
	/**发送消息失败原因*/
	public static final String KEY_FAIL_TYPE = "fail_type";
	
	private J_NioSocketConnector nioConnection = null ;
	private static J_PushManager self = null;
	private IoHandlerAdapter ioHandlerAdapter = null ;
	private SocketStatusListener listener = null ;
	private Thread connThread = null ;
	
	private Handler handler = new Handler(){
		
		public void handleMessage(android.os.Message msg) {
			
			if(listener == null){
				J_Log.i("SocketStatusListener == null 无法进行回调");
			}
			
			switch (msg.what) {
			case STATUS_BEGAIN_CONNECT:
				listener.begainConnect();
				break;
			case STATUS_CONNEC_CLOSED:
				listener.connectClosed();
				break;
			case STATUS_CONNECT_SUCCESS:
				listener.connectSuccess();
				break;
			case STATUS_RECEIVE_MSG:
				listener.onMsgBack(msg.getData().getString("msg"));
				break;
			case STATUS_SEND_MSG_SUCCESS:
				listener.onSendMsgSuccess(msg.getData().getString("msg"));
				break;
			case STATUS_SEND_MSG_FAIL:
				listener.onSendMsgFail(msg.getData().getString("msg"),msg.getData().getInt(KEY_FAIL_TYPE));
				break;
			case STATUS_ERROR:
				listener.onError((Throwable)msg.getData().getSerializable("error"));
				break;

			default:
				break;
			}
			
		};
		
	};
	
	public interface SocketStatusListener{
		public void begainConnect();
		public void connectSuccess();
		public void connectClosed();
		public void onMsgBack(String str);
		public void onSendMsgSuccess(String str);
		public void onSendMsgFail(String str,int what);
		public void onError(Throwable cause);
	}
	
	private J_PushManager(){
	}
	
	public static J_PushManager getInstance(){
		if(self == null){
			self = new J_PushManager() ;
		}
		return self ;
	}
	
	
	public void createNioSocket(ProtocolCodecFactory codecFactory , SocketStatusListener listener){
		this.listener = listener ;
		J_Log.e("J_PushManager", "creat");
		nioConnection = null;
		nioConnection = new J_NioSocketConnector(codecFactory,getIOHandler());
	}
	
	public void connecte(final String host,final int port,final long connTimeout){
		J_Log.e("J_PushManager", "connecte");
		if(connThread != null && connThread.isAlive()){
			connThread.stop() ;
		}
		
		connThread = new Thread(){
			@Override
			public void run() {
				if(nioConnection!=null){
					boolean b = nioConnection.connect(host, port, connTimeout);
					if(!b){
						handler.sendEmptyMessage(STATUS_ERROR);
					}
				}
			}
		};
		connThread.start();
		
	}
	
	
	public void sendNioMsg(String msg){
		boolean isSuccess = false ;
		if(isConnected()){
			Intent intent = nioConnection.send(msg);
			isSuccess = intent.getBooleanExtra(KEY_SEND_STATUS, false);
			Bundle bundle = new Bundle() ;
			bundle.putSerializable("msg", msg);
			Message message = handler.obtainMessage();
			if(isSuccess){
				message.what = STATUS_SEND_MSG_SUCCESS ;
			}else{
				bundle.putInt(KEY_FAIL_TYPE, intent.getIntExtra(KEY_FAIL_TYPE, 0));
				message.what = STATUS_SEND_MSG_FAIL ;
			}
			
			message.setData(bundle);
			handler.sendMessage(message);
		}else{
			J_Log.e("连接为空或没有创建完毕");
			Message message = handler.obtainMessage();
			Bundle bundle = new Bundle() ;
			bundle.putSerializable("msg", msg);
			bundle.putInt(KEY_FAIL_TYPE, STATUS_CONNEC_CLOSED);
			message.setData(bundle);
			message.what = STATUS_SEND_MSG_FAIL ;
			handler.sendMessage(message);
		}
		
	}
	
	
	public void closeNioSocket(){
		if(isConnected()){
			nioConnection.close();
		}
		J_Log.e("J_PushManager", "closeed");
		if(connThread != null && connThread.isAlive() && !connThread.isInterrupted()){
			connThread.interrupt() ;
		}
		J_Log.e("J_PushManager", "interrupt");
		connThread = null ;
		nioConnection = null ;
		J_Log.e("J_PushManager", listener == null?"listener is null":"listener not null");
		if(listener!=null){
			listener.connectClosed();
		}
	}
	
	private IoHandlerAdapter getIOHandler(){
		
		if(ioHandlerAdapter == null){
			ioHandlerAdapter = new IoHandlerAdapter(){

				@Override
				public void sessionCreated(IoSession session) throws Exception {
		 
					J_Log.i("sessionCreated");
					IoSessionConfig cfg = session.getConfig();
					if(cfg instanceof SocketSessionConfig){
						((SocketSessionConfig)cfg).setKeepAlive(true);
					}
					handler.sendEmptyMessage(STATUS_BEGAIN_CONNECT);
				}

				@Override
				public void sessionOpened(IoSession session) throws Exception {
					J_Log.i("sessionOpened");
					handler.sendEmptyMessage(STATUS_CONNECT_SUCCESS);
				}

				@Override
				public void sessionClosed(IoSession session) throws Exception {

					J_Log.i("sessionClosed");
					handler.sendEmptyMessage(STATUS_CONNEC_CLOSED);
				}


				@Override
				public void exceptionCaught(IoSession session, Throwable cause)
						throws Exception {
					J_Log.i("exceptionCaught");
//					cause.printStackTrace();
					Bundle bundle = new Bundle() ;
					bundle.putSerializable("error", cause);
					Message message = new Message();
					message.what = STATUS_ERROR ;
					message.setData(bundle);
					handler.sendMessage(message);
				}

				@Override
				public void messageReceived(IoSession session, Object obj)
						throws Exception {

						J_Log.i(obj.toString());
					Bundle bundle = new Bundle() ;
					bundle.putSerializable("msg", obj.toString());
					Message message = new Message();
					message.what = STATUS_RECEIVE_MSG ;
					message.setData(bundle);
					handler.sendMessage(message);

				}

				@Override
				public void messageSent(IoSession session, Object obj)
						throws Exception {
					J_Log.i("messageSent--->"+obj.toString());
				}
				
				
			};
		}
		return ioHandlerAdapter ;
	}
	public boolean isConnected(){
		return nioConnection!=null&&nioConnection.isConnected();
	}
}
