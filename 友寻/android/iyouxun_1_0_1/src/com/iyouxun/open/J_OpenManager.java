package com.iyouxun.open;

import java.util.HashMap;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import cn.sharesdk.framework.Platform;
import cn.sharesdk.framework.Platform.ShareParams;
import cn.sharesdk.framework.PlatformActionListener;
import cn.sharesdk.framework.ShareSDK;
import cn.sharesdk.onekeyshare.OnekeyShare;
import cn.sharesdk.sina.weibo.SinaWeibo;
import cn.sharesdk.tencent.qq.QQ;
import cn.sharesdk.tencent.qzone.QZone;
import cn.sharesdk.wechat.friends.Wechat;
import cn.sharesdk.wechat.moments.WechatMoments;

import com.iyouxun.J_Application;
import com.iyouxun.R;
import com.iyouxun.consts.J_Consts;
import com.iyouxun.consts.NetConstans;
import com.iyouxun.data.beans.shareFriendsInfoBean;
import com.iyouxun.data.cache.J_Cache;
import com.iyouxun.j_libs.J_SDK;
import com.iyouxun.ui.activity.news.AddNewNewsActivity;
import com.iyouxun.ui.activity.open.ShareUserSelectActivity;
import com.iyouxun.utils.DialogUtils;
import com.iyouxun.utils.ToastUtil;
import com.iyouxun.utils.Util;

/**
 * 第三方平台操作（登录、分享）
 * 
 * @author likai
 * @date 2014年10月14日 下午3:27:46
 */
public class J_OpenManager {
	private static J_OpenManager self;
	private static Dialog shareDialog;
	// 分享回调
	public PlatformActionListener SharePlatformListener = new PlatformActionListener() {
		@Override
		public void onError(Platform platform, int arg1, Throwable arg2) {
			if (J_Application.sCurrentActiviy != null) {
				J_Application.sCurrentActiviy.runOnUiThread(new Runnable() {
					@Override
					public void run() {
						ToastUtil.showToast(J_Application.sCurrentActiviy, "分享失败");
						DialogUtils.dismissDialog();
					}
				});
			}
		}

		@Override
		public void onComplete(Platform platform, int arg1, HashMap<String, Object> arg2) {
			// 提示分享成功
			if (J_Application.sCurrentActiviy != null) {
				J_Application.sCurrentActiviy.runOnUiThread(new Runnable() {
					@Override
					public void run() {
						ToastUtil.showToast(J_Application.sCurrentActiviy, "分享成功");
						DialogUtils.dismissDialog();
					}
				});
			}
		}

		@Override
		public void onCancel(Platform platform, int arg1) {
			if (J_Application.sCurrentActiviy != null) {
				J_Application.sCurrentActiviy.runOnUiThread(new Runnable() {
					@Override
					public void run() {
						ToastUtil.showToast(J_Application.sCurrentActiviy, "取消分享");
						DialogUtils.dismissDialog();
					}
				});
			}
		}
	};

	public static J_OpenManager getInstance() {
		if (self == null) {
			self = new J_OpenManager();
		}
		return self;
	}

	/**
	 * 获取pk结果分享中的连接
	 * 
	 * @return String 返回类型
	 * @param shareId 分享连接中的shareid
	 * @param type quickGame:快速对战，timeGuess:限时竞猜，friendPk:好友pk
	 * @author likai
	 */
	public String getSharePkUrl(String shareId, String type) {
		StringBuilder sb = new StringBuilder();

		if (!Util.isBlankString(shareId) && !Util.isBlankString(type)) {
			String shareUrl = J_Consts.SITE_URL;
			if (!Util.isBlankString(shareUrl)) {
				sb.append(shareUrl).append("?uid=").append(J_Cache.sLoginUser.uid + "").append("&shareid=").append(shareId);
			}
		}
		return sb.toString();
	}

	/**
	 * 平台分享(弹出自定分享弹层)
	 * 
	 * @return void 返回类型
	 * @param @param platform
	 * @param @param params
	 * @param @param callBack
	 * @param @param silent 参数类型
	 * @author likai
	 */
	public void share(Activity mActivity, PlatformActionListener callBack, J_ShareParams params) {
		DialogUtils.showSharePopDialog(mActivity, callBack, params);
	}

	/**
	 * 平台分享操作
	 * 
	 * @return void 返回类型
	 * @param platform String 需要分享的平台（如果为null的话，则弹出选择分享平台的选择层）
	 * @param ShareParams 分享内容的参数
	 * @param callBack 回调方法
	 * @param silent boolean 是否直接分享（true则直接分享）
	 * @author likai
	 * 
	 *         http://wiki.mob.com/不同平台分享内容的详细说明/
	 * 
	 */
	public void share(Activity mActivity, String platform, J_ShareParams params, PlatformActionListener callBack, boolean silent) {
		ShareSDK.initSDK(mActivity);
		// 标记是否是app内的功能（不使用第三方平台）
		if (platform.equals(SinaWeibo.NAME) || platform.equals(QQ.NAME) || platform.equals(QZone.NAME)
				|| platform.equals(Wechat.NAME) || platform.equals(WechatMoments.NAME)) {
			// 如果是使用第三方平台去分享，调用sdk进行分享操作
			Platform pf = ShareSDK.getPlatform(platform);
			// true不使用SSO授权，false使用SSO授权
			pf.SSOSetting(false);
			// 设置回调监听
			pf.setPlatformActionListener(callBack);
			// 执行分享
			pf.share(params);
		} else if (platform.equals("news")) {
			// 转发为动态
			Intent newsIntent = new Intent(mActivity, AddNewNewsActivity.class);
			if (!Util.isBlankString(params.getText())) {
				if (params.shareType == 3 && Util.isBlankString(params.getText())) {
					params.setText("发表图片");
				}
				String content = params.getText();
				newsIntent.putExtra("shareContent", content);
			}
			if (!Util.isBlankString(params.getImagePath())) {
				newsIntent.putExtra("shareImagePath", params.getImagePath());
			}
			mActivity.startActivity(newsIntent);
		} else if (platform.equals("friend")) {
			// 转发给好友
			Intent userIntent = new Intent(mActivity, ShareUserSelectActivity.class);
			shareFriendsInfoBean bean = new shareFriendsInfoBean();
			String content = params.getText();
			bean.content = content;
			bean.shareType = params.shareType;
			bean.imagePath = params.getImagePath();
			bean.url = params.getUrl();
			userIntent.putExtra("shareInfo", bean);
			mActivity.startActivity(userIntent);
		}
	}

	/**
	 * 使用shareSDK一键分享框架处理
	 * 
	 * @return void 返回类型
	 * @param @param platform
	 * @param @param params
	 * @param @param callBack
	 * @param @param silent 参数类型
	 * @author likai
	 */
	public void shareByOks(String platform, ShareParams params, PlatformActionListener callBack, boolean silent) {
		OnekeyShare oks = new OnekeyShare();
		// address是接收人地址，仅在信息和邮件使用
		if (!Util.isBlankString(params.getAddress())) {
			oks.setAddress(params.getAddress());
		}
		if (!Util.isBlankString(params.getTitle())) {
			oks.setTitle(params.getTitle());
			if (platform.equals(WechatMoments.NAME)) {// 微信朋友圈
				oks.setTitle(params.getTitle() + params.getText());
			}
		} else {
			oks.setTitle(J_Application.context.getString(R.string.share));
		}
		// titleUrl是标题的网络链接，仅在人人网和QQ空间使用
		oks.setTitleUrl(NetConstans.SERVER_URL);
		// text是分享文本，所有平台都需要这个字段
		if (!Util.isBlankString(params.getText())) {
			oks.setText(params.getText());
		}
		// imagePath是图片的本地路径，Linked-In以外的平台都支持此参数
		if (!Util.isBlankString(params.getImagePath())) {
			oks.setImagePath(params.getImagePath());
		}
		// imageUrl是图片的网络路径，新浪微博、人人网、QQ空间、
		// 微信的两个平台、Linked-In支持此字段
		if (!Util.isBlankString(params.getImageUrl())) {
			oks.setImageUrl(params.getImageUrl());
		}
		// url仅在微信（包括好友和朋友圈）中使用
		if (!Util.isBlankString(params.getUrl())) {
			oks.setUrl(params.getUrl());
		}
		// comment是我对这条分享的评论，仅在人人网和QQ空间使用
		oks.setComment(J_Application.context.getString(R.string.share));
		// site是分享此内容的网站名称，仅在QQ空间使用
		oks.setSite(J_Application.context.getString(R.string.app_name));
		// siteUrl是分享此内容的网站地址，仅在QQ空间使用
		if (!Util.isBlankString(params.getSiteUrl())) {
			oks.setSiteUrl(params.getSiteUrl());
		}
		// latitude是维度数据，仅在新浪微博、腾讯微博和Foursquare使用
		oks.setLatitude(params.getLatitude());
		// longitude是经度数据，仅在新浪微博、腾讯微博和Foursquare使用
		oks.setLongitude(params.getLongitude());
		// 是否直接分享（true则直接分享）
		oks.setSilent(silent);
		// 指定分享平台，和slient一起使用可以直接分享到指定的平台
		if (platform != null) {
			oks.setPlatform(platform);
		}
		// 去除注释可通过J_OpenPlatformCallback来捕获快捷分享的处理结果
		oks.setCallback(callBack);
		oks.show(J_Application.context);
	}

	/**
	 * 平台登录
	 * 
	 * @return void 返回类型
	 * @param handler处理已授权状态
	 * @param platform平台名称，例如QQ.NAME
	 * @param callBack 回调方法（PlatformActionListener）
	 * @author likai
	 */
	public void login(Handler handler, String platform, PlatformActionListener callBack) {
		ShareSDK.initSDK(J_SDK.getContext());

		// 通过shareSDK执行登录操作
		Platform pf = ShareSDK.getPlatform(J_SDK.getContext(), platform);
		pf.setPlatformActionListener(callBack);
		// 判断指定平台是否已经完成授权
		if (pf.isValid()) {
			String userId = pf.getDb().getUserId();
			if (!TextUtils.isEmpty(userId)) {
				Message msg = new Message();
				msg.what = R.id.third_platform_is_valid;
				msg.obj = pf;
				handler.sendMessage(msg);
				return;
			}
		}
		// true不使用SSO授权，false使用SSO授权
		pf.SSOSetting(false);
		pf.showUser(null);
	}

	/**
	 * @Title: removeAccount
	 * @Description: 移除所有平台数据
	 * @return void 返回类型
	 * @param 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public void removeAccount(Context context) {
		ShareSDK.initSDK(context);
		String[] platforms = { SinaWeibo.NAME, QQ.NAME, Wechat.NAME, WechatMoments.NAME };
		for (int i = 0; i < platforms.length; i++) {
			Platform pf = ShareSDK.getPlatform(context, platforms[i]);
			pf.removeAccount(true);
		}
	}

}
