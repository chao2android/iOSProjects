package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;

/**
 * 获取系统消息提醒列表
 * 
 * type - sys 系统消息 group所有群消息 crgroup 建群消息 addgroup 申请加入群消息 qtgroup 退群消息 photo
 * 照片赞 reply 照片评论 reject 拒绝好友加入群 accept 接受好友加入群 del 群主踢人 invite 所有人可以邀请好友加入(一度)
 * like 动态被赞 rebroadcast 动态被转播 comment 动态被评论 reply 被回复评论
 * 
 * page - 页码 @default 1 @min 1
 * 
 * pageSize - 页码 @default 10 @min 1 @max 20
 * 
 * avatarSize - 图像尺寸 @default 50
 * 
 * status - 消息状态 0未读 1已读 -1全部 100全部含已删除
 * 
 * autostatus - 自动设置已读 0/1 @default 1
 * 
 * @author likai
 * @date 2015-3-25 上午10:42:16
 * 
 */
public class ListSystemRequest extends J_Request {

	public ListSystemRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.LIST_SYSTEM_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_LIST_SYSTEM;
	}

	public J_Request execute(String type, int page, int pageSize, int avatarSize, int status, int autostatus) {
		addParam("type", type);
		addParam("page", page + "");
		addParam("pageSize", pageSize + "");
		addParam("status", status + "");
		addParam("autostatus", autostatus + "");
		addParam("avatarSize", avatarSize + "");

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
