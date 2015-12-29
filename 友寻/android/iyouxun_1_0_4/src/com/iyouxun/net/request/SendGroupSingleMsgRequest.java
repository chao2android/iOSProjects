package com.iyouxun.net.request;

import org.json.JSONException;
import org.json.JSONObject;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

public class SendGroupSingleMsgRequest extends J_Request {

	public SendGroupSingleMsgRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.SEND_SINGLE_MSG_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_SEND_SINGLE_MSG;
	}

	/**
	 * @Title: send
	 * @Description: 群聊求脱单
	 * @return J_Request 返回类型
	 * @param @param groupId 接收的群组id
	 * @param @param avatar 分享用户的头像
	 * @param @param sex 分享用户的性别
	 * @param @param province 分享用户的省份
	 * @param @param city 分享用户的城市
	 * @param @param nick 分享用户昵称
	 * @param @param marriage 分享用户的情感状态
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public J_Request send(String groupId, String avatar, int sex, String province, String city, String nick, int marriage) {
		JSONObject object = new JSONObject();
		try {
			object.put(UtilRequest.FORM_GROUP_ID, groupId);
			object.put(UtilRequest.FORM_AVATAR, avatar);
			object.put(UtilRequest.FORM_SEX, sex + "");
			object.put(UtilRequest.FORM_PROVINCE, province);
			object.put(UtilRequest.FORM_CITY, city);
			object.put(UtilRequest.FORM_NICK, nick);
			object.put(UtilRequest.FORM_MARRIAGE, marriage + "");
			addParam(UtilRequest.FORM_FORM, object.toString());
			J_NetManager.getInstance().sendRequest(this);
		} catch (JSONException e) {
			e.printStackTrace();
		}
		return this;
	}

}
