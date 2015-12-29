package com.iyouxun.data.beans;

import java.io.Serializable;

import cn.sharesdk.framework.Platform;

/**
 * @ClassName: OpenPlatformBeans
 * @Description: 开放平台数据
 * @author donglizhi
 * @date 2015年3月3日 下午4:53:50
 * 
 */
public class OpenPlatformBeans implements Serializable {
	private long uid;// 非第三方平台的userId
	private String userNick = "";// 用户昵称
	private String userIcon = "";// 头像
	private String userId = "";// 用户id(openId)
	private String userGender = "";// 性别
	private int openType;// 微信1 新浪微博2 QQ3
	private String accessToken = "";
	private String imgPath = "";// 平台头像下载到本地的地址
	private Platform platform;
	/** 绑定状态：0：未绑定，1：已绑定 */
	private int status = 0;
	/** 过期时间 */
	private long expiresIn = 0;

	public void setExpiresIn(long expiresIn) {
		this.expiresIn = expiresIn;
	}

	public long getExpiresIn() {
		return expiresIn;
	}

	public void setStatus(int status) {
		this.status = status;
	}

	public int getStatus() {
		return status;
	}

	public void setUid(long uid) {
		this.uid = uid;
	}

	public long getUid() {
		return uid;
	}

	public String getUserNick() {
		return userNick;
	}

	public void setUserNick(String userNick) {
		this.userNick = userNick;
	}

	public String getUserIcon() {
		return userIcon;
	}

	public void setUserIcon(String userIcon) {
		this.userIcon = userIcon;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getUserGender() {
		return userGender;
	}

	public void setUserGender(String userGender) {
		this.userGender = userGender;
	}

	public int getOpenType() {
		return openType;
	}

	public void setOpenType(int openType) {
		this.openType = openType;
	}

	public String getAccessToken() {
		return accessToken;
	}

	public void setAccessToken(String accessToken) {
		this.accessToken = accessToken;
	}

	public String getImgPath() {
		return imgPath;
	}

	public void setImgPath(String imgPath) {
		this.imgPath = imgPath;
	}

	public void setPlatform(Platform platform) {
		this.platform = platform;
	}

	public Platform getPlatform() {
		return platform;
	}
}
