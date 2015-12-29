package com.iyouxun.open;

import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.Platform.ShareParams;
import cn.sharesdk.onekeyshare.ShareContentCustomizeCallback;

/**
 * 修改不同平台分享的内容
 * 
 * @author likai
 * @date 2014年10月16日 下午5:15:07
 */
public class J_ShareContentRewrite implements ShareContentCustomizeCallback {

	@Override
	public void onShare(Platform platform, ShareParams paramsToShare) {
		// 改写twitter分享内容中的text字段，否则会超长，
		// 因为twitter会将图片地址当作文本的一部分去计算长度
		// if (QQ.NAME.equals(platform.getName())) {
		// String text = "修改内容";
		// paramsToShare.setText(text);
		// }
	}

}
