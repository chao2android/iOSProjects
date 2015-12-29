package com.iyouxun.data.beans.users;

import java.io.Serializable;
import java.util.ArrayList;

import com.iyouxun.data.beans.PhotoInfoBean;

/**
 * 登陆用户信息
 * 
 */

public class LoginUser extends BaseUser implements Serializable {
	/**
	 * 
	 * @Fields serialVersionUID : TODO(用一句话描述这个变量表示什么)
	 */
	private static final long serialVersionUID = 8252662719433356963L;
	/** qq-openid */
	public String openID = "";
	/** 城市 */
	public int location;
	/** 城市 */
	public int subLocation;
	/** 省份名称 */
	public String locationName = "";
	/** 城市名称 */
	public String subLocationName = "";
	/** 出生年份 */
	public int birthYear;
	/** 出生月份 */
	public int birthMonth;
	/** 出生日期 */
	public int birthDay;
	/** 情感状况 1:单身2：恋爱中3:已婚4：保密 */
	public int marriage = 0;
	/** 身高 */
	public int height;
	/** 体重 */
	public int weight;
	/** 职业 学生:J_Consts.SCHOOL_CAREER_ID */
	public int career;
	/** 公司 */
	public String company = "";
	/** 学校 */
	public String school = "";
	/** 签名 */
	public String intro = "";
	/** 星座 */
	public int star;
	/** 生肖 */
	public int birthpet;
	/** 好友认证数量 */
	public int lonelyConfirm = 0;
	/** 图片数量 */
	public int photoCount = 0;
	/** 距离 */
	public int distance;
	/** 常住地 */
	public String address = "";
	/** 是否好友: -1：参数错误，0-不是好友，1-是1度好友， 2：二度好友 */
	public int isFriend = 0;
	/** 是否确认过单身 */
	public int isLonelyConfirm;
	/** 是否上传头像 0:未上传，1:上传 */
	public int hasAvatar = 0;
	/** 头像地址 50 */
	public String avatarUrl50 = "";
	/** 头像地址 100 */
	public String avatarUrl100 = "";
	/** 头像地址 150 */
	public String avatarUrl150 = "";
	/** 头像地址 200 */
	public String avatarUrl200 = "";
	/** 头像地址 600 */
	public String avatarUrl600 = "";
	/** 头像pid */
	public String avatarPid = "";
	/** 备注 */
	public String mark = "";
	/** 权限设置-是否显示二度好友动态 */
	public int show_second_friend_dync;
	/** 权限设置-是否允许二度好友查看我的动态 */
	public int allow_second_friend_look_my_dync;
	/** 权限设置-是否接受二度好友邀请加入群 */
	public int allow_accept_second_friend_invite;
	/** 权限设置-好友与聊天0:允许所有人加我为好友并发起聊天,1:只有二度好友可以加我为好友并发起聊天,2:禁止任何人加我为好友并发起聊天 */
	public int allow_add_with_chat;
	/** 权限设置-资料展示 0:允许所有人查看动态和相册,1:非好友不能查看动态和相册,2:非好友可以查看最新5条更新内容 */
	public int allow_my_profile_show;
	/** 通讯录是否上传0:未上传, 1:已上传 */
	public int callno_upload;
	/** 好友数量(1度) */
	public int friends_num;

	/** 最新的几张图 */
	public String photoDatasStr = "";
	public ArrayList<PhotoInfoBean> photoDatas = new ArrayList<PhotoInfoBean>();

	/** 最后登录时间 */
	public long lastLoginTime;

	/** 是否开启音乐 */
	public boolean is_music_on = true;
	/** 是否开启音效 */
	public boolean is_sound_effects_on = true;
	/** 是否开启振动 */
	public boolean is_vibration_on = true;
	/** 是否开启消息推送 */
	public boolean is_msg_push_on = true;

	/** 标识是否验证过手机号1为验证过 */
	public int is_mobile_verify;
	/** 标识是否绑定过手机号 */
	public boolean is_mobile_binded = false;

	/** 标识是否绑定过QQ */
	public boolean is_qq_binded = false;
}