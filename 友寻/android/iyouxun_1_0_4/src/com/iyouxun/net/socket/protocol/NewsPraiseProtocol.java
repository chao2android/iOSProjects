package com.iyouxun.net.socket.protocol;

import java.util.HashMap;

import org.json.JSONException;
import org.json.JSONObject;

import com.iyouxun.J_Application;
import com.iyouxun.data.beans.socket.PushMsgInfo;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.response.J_Response;
import com.iyouxun.net.request.NoticeNewDynamicRequest;
import com.iyouxun.ui.activity.news.NewsMainActivity;
import com.iyouxun.utils.Util;

/**
 * 动态相关信息推送---赞动态：311
 * 
 * --：动态被赞 <br />
 * {"nick":"黑乎乎","from":2091950,"fid":19050,"cmd":311,
 * "timer":1427955814,"pushtype":"text"}
 * 
 * --：转播你的动态<br />
 * {"nick":"黑乎乎","from":2091950,"fid":19350,"cmd":312,
 * "timer":1427955993,"pushtype":"text"}
 * 
 * --：评论了你的动态<br />
 * {"nick":"黑乎乎","from":2091950,"fid":19350,"replay":"看空间","cmd":313,"timer":
 * 1427956017,"pushtype":"text"}
 * 
 * --：回复你的评论<br />
 * {"nick":"黑乎乎","from":2091950,"fid":19350,"replay":"JJ哦默默","cmd":314,"timer":
 * 1427956076,"pushtype":"text"}
 * 
 * @author likai
 * @date 2015-4-2 下午2:24:01
 * 
 */
public class NewsPraiseProtocol extends AbsPushProtocol {
	@Override
	public SocketProtocol getResponseObj(JSONObject json) throws JSONException {
		bean = new PushMsgInfo();
		bean.cmd = json.optInt(KEY_CMD);
		bean.nick = json.optString("nick");
		bean.from = json.optLong("from");
		bean.fid = json.optLong("fid");
		bean.time = json.optLong("timer");
		bean.pushtype = json.optString("pushtype");

		// 获取数字
		new NoticeNewDynamicRequest(new OnDataBack() {
			@Override
			public void onResponse(Object result) {
				J_Response response = (J_Response) result;
				int retcode = response.retcode;
				if (retcode == 1) {
					try {
						// 计算总数量
						bean.newsMsgcount = Util.getInteger(response.data);
						// 回调方法
						if (J_Application.pushActiviy.containsKey("NewsMainActivity")) {
							NewsMainActivity activity = (NewsMainActivity) J_Application.pushActiviy.get("NewsMainActivity");
							activity.receivePushMsg(bean);
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				}
			}

			@Override
			public void onError(HashMap<String, Object> errorMap) {
			}
		}).execute();

		return this;
	}
}
