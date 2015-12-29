//
//  NotificationMacro.h
//  imAZXiPhone
//
//  Created by GAO on 14-6-30.
//  Copyright (c) 2014年 GAO. All rights reserved.
//

//这个文件放通知相关的宏定义
#ifndef imJYPhone_NotificationMacro_h
#define imJYPhone_NotificationMacro_h


#define kLoginSuccessNotification @"loginSuccessNotification" //登录成功通知
#define kRegisterAndUpMobileListSuccessNotification @"registerAndUpMobileListSuccessNotification" //注册然后上传通信录成功后
#define kLocalImageGroupToCameraNotification @"localImageGroupToCameraNotification" //本地相册界面切换到拍照
#define kConfirmSelectedImagesNotification @"confirmSelectedImagesNotification" //多选照片上传确认选中的图片
#define kRefreshProfileInfoNotification @"refreshProfileInfo" //刷新个人资料的数据
#define kProfileEditTagsNotification @"profileEditTagsNotification" //个人资料的添加标签
#define kProfileDelTagsNotification @"profileDelTagsNotification" //个人资料的删除标签
#define kProfileDelLocalTagDicNotification @"profileDelLocalTagDicNotification"//删除当前数据源的标签字典
#define kProfileClickTagsNotification @"profileClickTagsNotification" //个人资料的点击标签
#define kFeedCellClickAvatarNotification @"feedCellClickAvatarNotification" //动态的cell里面点面头像
#define kDynamicSendCommentNotify @"dynamicSendCommentNotify"  //动态页点击评论
#define kDynamicSendReplyCommentNotify @"dynamicSendReplyCommentNotify" //动态页点击回复评论
#define kFeedCellClickImageNotification @"kFeedCellClickImageNotification"  //单身无好友未上传通讯录时点击图片
//#define kMyDynamicSendReplyCommentNotify @"kMyDynamicSendReplyCommentNotify" //我的动态页点击回复评论
#define kFeedDetailCellClickAvatarNotification @"feedDetailCellClickAvatarNotification" //动态详请点击头像
#define kDeleteDynamicCommentNotification @"deleteDynamicCommentNotification" //动态详情删除一条评论
#define kDynamicListRefreshTableNotify @"dynamicListRefreshTableNotify" //动态列表刷新ui
#define kExitGroupSuccessNotification @"exitGroupSuccessNotification" //退群成功通知
#define kChatAudioTapNotification @"chatAudioTapNotification" //语音点击
#define kChatStartPlayAudioNotification @"chatStartPlayAudioNotification" //开始播放语音通知
#define kChatStopPlayAudioNotification @"chatStopPlayAudioNotification" //停止播放语音通知
#define kSocketReceiveChatMsgNotification @"socketReceiveChatMsgNotification" //接收到一条文本消息
#define kPushServiceDealSocketNotification @"pushServiceDealSocketNotification" //服务器推送一条通知
#define kFeedSetPromissionNotification @"feedSetPromissionNotification" //发布动态时，权限设置
//#define kProfileHasEditGroupNotification @"profileHasEditGroupNotification" //对个人资料页群组进行编辑时
#define kRefreshTabBarUnreadNumberNotification @"refreshTabBarUnreadNumberNotification"
#define kMyGroupEnjoinSuccessNotification @"myGroupEnjoinSuccessNotification" //我的群组点击加入，成功
#define kLocationDidFinishedNotification @"locationDidFinishedNotification" //定位成功的通知
#define kChatCellClickAvatarNotification @"chatCellClickAvatarNotification" //点击聊天时头像
#define kStopPlayAudioNotiNotification @"stopPlayAudioNotiNotification" //聊天时停止播放语音
#define kRefreshMessageTableViewNotification @"refreshMessageTableViewNotification" //消息列表，刷新列表
#define kDeleteOneMessageUserNotification @"deleteOneMessageUserNotification" //消息列表，删除一个用户记录
#define kChatLogFailureResendNotification @"chatLogFailureResendNotification" //发送失败重新发送
#define kChatCellClickShareNotification @"chatCellClickShareNotification" //点击聊天时分享出来的链接
#define kGroupMemberAvatarClickNotification @"groupMemberAvatarClickNotification" //群组成员头像点击
#define kTabBarRedTipShowOrHideNotification @"tabBarRedTipShowOrHideNotification" //tabbar红点提示显示与隐藏
#define kGroupSettingRefreshAvatarNotification @"kGroupSettingRefreshAvatarNotification" //更新我的群组列表头像
#define kChatTableViewRefreshUiNotification @"chatTableViewRefreshUiNotification" //刷新群组聊天tableView

#endif
