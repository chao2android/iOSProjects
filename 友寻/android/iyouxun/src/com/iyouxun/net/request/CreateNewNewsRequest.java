package com.iyouxun.net.request;

import com.iyouxun.consts.NetConstans;
import com.iyouxun.consts.NetTaskIDs;
import com.iyouxun.data.beans.UploadNewsInfoBean;
import com.iyouxun.j_libs.managers.J_NetManager;
import com.iyouxun.j_libs.managers.J_NetManager.OnDataBack;
import com.iyouxun.j_libs.net.request.J_Request;
import com.iyouxun.utils.Util;

/**
 * 添加新动态
 * 
 * @ClassName: CreateNewNewsRequest
 * @author likai
 * @date 2015-3-7 下午2:16:57
 * 
 */
public class CreateNewNewsRequest extends J_Request {

	public CreateNewNewsRequest(OnDataBack callBack) {
		super(callBack);
		this.URL = NetConstans.ADD_DYNAMIC_URL;
		this.REQUEST_TYPE = NetTaskIDs.TASKID_ADD_DYNAMIC;
	}

	public J_Request execute(UploadNewsInfoBean bean) {
		// 内容
		// String content = URLEncoder.encode(bean.content);
		String content = bean.content;
		// 图片
		StringBuilder sbPhoto = new StringBuilder();
		for (int i = 0; i < bean.photos.size(); i++) {
			if (!Util.isBlankString(bean.photos.get(i).pid)) {
				if (sbPhoto.length() > 0) {
					sbPhoto.append(",");
				}
				sbPhoto.append(bean.photos.get(i).pid);
			}
		}
		// 查看权限
		StringBuilder groupIds = new StringBuilder();
		if (bean.lookAuth.lookAuthType == 1) {
			// 所有人
			groupIds.append("1");
		} else {
			// 指定分组
			for (int i = 0; i < bean.lookAuth.lookAuth.size(); i++) {
				if (groupIds.length() > 0) {
					groupIds.append(",");
				}
				groupIds.append(bean.lookAuth.lookAuth.get(i));
			}
		}

		// 动态类型0-文字，1-图片
		String type = "0";
		if (sbPhoto.length() > 0) {
			type = "1";
		}
		addParam("type", type);
		addParam("content", content);
		if (type.equals("1")) {
			addParam("pids", sbPhoto.toString());
		}
		addParam("group_id", groupIds.toString());
		// 是否同步至相册
		if (bean.isSyncToAlbum == 1) {
			addParam("is_photo", "1");
		}

		J_NetManager.getInstance().sendRequest(this);
		return this;
	}
}
