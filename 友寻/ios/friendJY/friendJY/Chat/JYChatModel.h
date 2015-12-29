//
//  JYChatModel.h
//  friendJY
//
//  Created by 高斌 on 15/3/23.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYChatModel : JYBaseModel

@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, copy) NSString *groupId;
@property (nonatomic, copy) NSString *iid;          //消息id
@property (nonatomic, copy) NSString *msgType;      //消息类型 0 单聊普通聊天 1 群聊普通聊天 2 单聊上传声音 3 单聊上传图片 4 群聊上传声音 5 群聊上传图片
@property (nonatomic, copy) NSString *avatar;       //头像
@property (nonatomic, copy) NSString *logo;         //头像
@property (nonatomic, copy) NSString *chatMsg;      //消息内容
@property (nonatomic, copy) NSString *fromUid;      //消息来自于哪个人
@property (nonatomic, copy) NSString *nick;         //昵称
@property (nonatomic, copy) NSString *title;         //昵称
@property (nonatomic, copy) NSString *msgFrom;      //消息来自于哪种设备
@property (nonatomic, copy) NSString *sex;          //0:女 1:男
@property (nonatomic, copy) NSString *time;         //时间
@property (nonatomic, copy) NSString *sendStatus;   //发送状态 0发送失败 1发送中 2发送成功
@property (nonatomic, copy) NSString *readStatus;   //阅读状态 0未读 1已读
@property (nonatomic, copy) NSString *fileUrl;      //图片 或者语音链接
@property (nonatomic, strong) NSData *fileData;     //文件数据
@property (nonatomic, copy) NSString *voiceLength;  //语音消息长度
@property (nonatomic, copy) NSString *imgWidth;     //图片宽
@property (nonatomic, copy) NSString *imgHeight;    //图片高
@property (nonatomic, copy) NSString *sendType;     //0全部 1收件 2发件
@property (nonatomic, assign) BOOL isPlayying;      //正在播放，主要用于是否在播放的状态
@property (nonatomic, strong) NSDictionary *ext;    //ext是文本时为空
@property (nonatomic, strong) NSString * voiceId;    //暂时存放，当新上传的时候，还没有上传到服务器，保存的本地id
@property (nonatomic, strong) NSString * showSendTime; //是否显示发送的时间，并不是第个cell都显示
@property (nonatomic, strong) NSString * is_sys_tip; //是否-是信息提示消息，比如xx加入群，
@property (nonatomic, assign) BOOL voiceShowPlayStatus; //如果是语音消息，是否显示下面状态

@end
