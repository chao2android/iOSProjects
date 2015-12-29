package com.iyouxun.utils;

import cn.sharesdk.framework.Platform;

import com.iyouxun.consts.J_Consts;
import com.iyouxun.data.beans.PhotoInfoBean;
import com.iyouxun.data.beans.users.LoginUser;
import com.iyouxun.j_libs.managers.J_FileManager;
import com.iyouxun.open.J_ShareParams;

/**
 * 第三方平台工具
 * 
 * @author likai
 * @date 2015-4-8 下午3:24:39
 * 
 */
public class OpenPlatformUtil {

	/**
	 * 获取“求脱单”分享内容参数
	 * 
	 * 参考
	 * http://wiki.mob.com/%E4%B8%8D%E5%90%8C%E5%B9%B3%E5%8F%B0%E5%88%86%E4%BA%
	 * AB%E5%86%85%E5%AE%B9%E7%9A%84%E8%AF%A6%E7%BB%86%E8%AF%B4%E6%98%8E/
	 * 
	 * @return J_ShareParams 返回类型
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static J_ShareParams getTuoDanParams() {
		J_ShareParams params = new J_ShareParams();
		// 分享类型
		params.shareType = 1;
		// title
		params.setTitle("求脱单-" + SharedPreUtil.getLoginInfo().nickName + "的资料-友寻");
		// 设置连接地址
		String url = J_Consts.SHARE_URL_USER + SharedPreUtil.getLoginInfo().uid;
		params.setTitleUrl(url);
		params.setUrl(url);
		// 根据性别区别分享内容
		String sexInfo = SharedPreUtil.getLoginInfo().sex == 0 ? "他们" : "她们";
		params.setText("给我介绍几个合适的对象吧，帮我把资料分享给" + sexInfo + "哦！我的资料：" + url);
		// 微信使用的分享类型
		params.setShareType(Platform.SHARE_WEBPAGE);
		// 分享图片（可以是imagePath,可以是imageUrl）,没有上传头像，就不传图片了
		if (SharedPreUtil.getLoginInfo().hasAvatar == 1) {
			params.setImagePath(J_FileManager.getInstance().getFileStore()
					.getFileSdcardAndRamPath(SharedPreUtil.getLoginInfo().avatarUrl200));
			params.setImageUrl(SharedPreUtil.getLoginInfo().avatarUrl600);
		}
		return params;
	}

	/**
	 * 分享给朋友|帮他脱单
	 * 
	 * @return J_ShareParams 返回类型
	 * @param @param currentUserInfo
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static J_ShareParams getShareFriendParams(LoginUser currentUserInfo) {
		J_ShareParams params = new J_ShareParams();
		// 分享类型
		params.shareType = 4;
		// 标题
		params.setTitle("友寻-" + currentUserInfo.nickName + "的资料");
		// 设置连接地址
		String url = J_Consts.SHARE_URL_USER + currentUserInfo.uid;
		params.setTitleUrl(url);
		params.setUrl(url);
		// 内容
		String sexInfo = currentUserInfo.sex == 0 ? "她" : "他";
		String shareInfo = "";
		if (currentUserInfo.marriage == 1) {
			// 单身状态
			shareInfo = currentUserInfo.nickName + "是单身，帮" + sexInfo + "脱单吧。" + sexInfo + "的资料：" + url;
		} else {
			// 非单身状态
			shareInfo = sexInfo + "正在友寻里交友，来认识" + sexInfo + "一下吧." + url;
		}
		params.setText(shareInfo);
		// 只有上传了头像的，才分享图片
		if (currentUserInfo.hasAvatar == 1) {
			// 图片url
			params.setImageUrl(currentUserInfo.avatarUrl600);
			// 图片path
			params.setImagePath(J_FileManager.getInstance().getFileStore().getFileSdcardAndRamPath(currentUserInfo.avatarUrl));
		}
		// 微信使用的分享类型
		params.setShareType(Platform.SHARE_WEBPAGE);
		return params;
	}

	/**
	 * 分享图片
	 * 
	 * http://wiki.mob.com/不同平台分享内容的详细说明/
	 * 
	 * @return J_ShareParams 返回类型
	 * @param @param photoInfo
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static J_ShareParams getSharePhotoParams(PhotoInfoBean photoInfo) {
		J_ShareParams params = new J_ShareParams();
		// 分享类型
		params.shareType = 3;
		// 标题
		params.setTitle("友寻-" + photoInfo.nick + "的资料");
		// 设置连接地址
		String url = J_Consts.SHARE_URL_USER + photoInfo.uid;
		params.setTitleUrl(url);
		params.setUrl(url);
		// 内容
		params.setText("来自" + photoInfo.nick + "的相册");
		// 图片
		params.setImagePath(J_FileManager.getInstance().getFileStore().getFileSdcardAndRamPath(photoInfo.url));
		params.setImageUrl(photoInfo.url);
		// 微信使用的分享类型
		params.setShareType(Platform.SHARE_IMAGE);

		return params;
	}

	/**
	 * 邀请好友帮我认证
	 * 
	 * @return J_ShareParams 返回类型
	 * @param @return 参数类型
	 * @author likai
	 * @throws
	 */
	public static J_ShareParams getFriendsHelpCertificate() {
		J_ShareParams params = new J_ShareParams();
		// 分享类型
		params.shareType = 2;
		// 标题
		params.setTitle("帮我认证一下单身吧-友寻");
		// 设置连接地址
		String url = J_Consts.SHARE_URL_USER + SharedPreUtil.getLoginInfo().uid;
		params.setTitleUrl(url);
		params.setUrl(url);
		// 内容
		params.setText("帮助确认我的单身状态，助我早日脱单 我的资料：" + url);
		// 图片,只有上传了头像的，才分享头像图片
		if (SharedPreUtil.getLoginInfo().hasAvatar == 1) {
			params.setImageUrl(SharedPreUtil.getLoginInfo().avatarUrl600);
			params.setImagePath(J_FileManager.getInstance().getFileStore()
					.getFileSdcardAndRamPath(SharedPreUtil.getLoginInfo().avatarUrl));
		}
		// 微信使用的分享类型
		params.setShareType(Platform.SHARE_WEBPAGE);
		return params;
	}

	/**
	 * @Title: inviteNewFriend
	 * @Description: 第三方平台邀请好友
	 * @return J_ShareParams 返回类型
	 * @param @param inviteName 微博邀请好友的名字
	 * @param @return 参数类型
	 * @author donglizhi
	 * @throws
	 */
	public static J_ShareParams inviteNewFriend(String inviteName) {
		J_ShareParams params = new J_ShareParams();
		// 设置连接地址
		String url = J_Consts.SHARE_URL_INVITE + SharedPreUtil.getLoginInfo().uid;
		String text = "快来【友寻】和我一起认识更多靠谱的朋友，朋友的朋友一秒变好友。和朋友的朋友谈恋爱，顺手解救身边的单身朋友，变身朋友圈丘比特！";
		String nick = SharedPreUtil.getLoginInfo().nickName;
		if (nick.length() > 4) {
			nick = nick.substring(0, 4) + "...";
		}
		String title = "我是" + nick + "，我在友寻";
		if (Util.isBlankString(inviteName)) {// 没有邀请好友的名字就是qq和微信
			params.setText(text);
			params.setTitle(title);
		} else {// 微博邀请
			params.setText(title + text + inviteName + url);
		}
		// 只有上传了头像的，才给传头像图片
		if (SharedPreUtil.getLoginInfo().hasAvatar == 1) {
			params.setImageUrl(SharedPreUtil.getLoginInfo().avatarUrl600);
		}
		params.setUrl(url);
		params.setTitleUrl(url);
		// 微信使用的分享类型
		params.setShareType(Platform.SHARE_WEBPAGE);
		return params;
	}
}
