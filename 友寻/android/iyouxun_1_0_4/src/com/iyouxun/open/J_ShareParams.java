package com.iyouxun.open;

import cn.sharesdk.framework.Platform.ShareParams;

/**
 * 继承了shareSDK的shareParams
 * 
 * 可以自定义一些应用内的参数
 * 
 * @author likai
 * @date 2015-1-19 下午2:46:16
 */
public class J_ShareParams extends ShareParams {
	/** 分享类型1:求脱单，2：邀请好友认证，3：分享图片，4：分享给好友/帮他脱单 */
	public int shareType = -1;
}
