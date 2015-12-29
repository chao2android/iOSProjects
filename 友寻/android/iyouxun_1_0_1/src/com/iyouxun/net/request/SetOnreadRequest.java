package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 消息置为已读状态
 * 
 * switch($type){
 * 
 * case 'sys': $type = array(1); break; //系统
 * 
 * case 'group': $type = array(10,11,12,13,14,15,16); break;//所有群消息
 * 
 * case 'crgroup': $type = array(10); break;//建群消息
 * 
 * case 'addgroup': $type = array(11); break; //申请加入群消息
 * 
 * case 'qtgroup': $type = array(12); break; //退群消息
 * 
 * case 'accept': $type = array(13); break; //接受好友加入群
 * 
 * case 'reject': $type = array(14); break; //拒绝好友加入群
 * 
 * case 'del': $type = array(15); break; //群主踢人
 * 
 * case 'invite': $type = array(16); break; //所有人可以邀请好友加入(一度)
 * 
 * case 'like': $type = array(17); break; //动态被赞
 * 
 * case 'rebroadcast': $type = array(18); break; //动态被转播
 * 
 * case 'comment': $type = array(19); break; //动态被评论
 * 
 * case 'reply': $type = array(20); break; //被回复评论
 * 
 * case 'dynamic': $type = array(17,18,19,20); break; //所有动态的消息
 * 
 * case 'friendaddtags': $type = array(21); break; //给用户新的一度好友打标签
 * 
 * case 'ownaddtags': $type = array(22); break; //别人给我打标签
 * 
 * case 'all': default: $type = array(0); break; //全部
 * 
 * }
 * 
 * @author likai
 * @date 2015-3-25 下午1:40:49
 * 
 */
public class SetOnreadRequest extends J_Request {

	public SetOnreadRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.SET_ONREAD_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_SET_ONREAD;
	}

	public J_Request execute(String iid, String type) {
		addParam("iid", iid);
		addParam("type", type);
		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
