//
//  JYMessageModel.h
//  friendJY
//
//  Created by 高斌 on 15/4/14.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYMessageModel : JYBaseModel

@property (nonatomic, assign) BOOL isGroup;
@property (nonatomic, copy) NSString *avatar; //头像
@property (nonatomic, copy) NSString *content; //消息内容
@property (nonatomic, strong) NSString *hint; //是否开启消息屏蔽，数据只存本地数据库
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, copy) NSString *iid; //消息id
@property (nonatomic, copy) NSString *group_id; //群组id
@property (nonatomic, copy) NSString *msgtype; //(类型int,为聊天消息里的子消息类型 0 单聊普通聊天 1 群聊普通聊天 2 单聊上传声音 3 单聊上传图片 4 群聊上传声音 5 群聊上传图片
@property (nonatomic, strong) NSDictionary *ext;//ext传声音的结构: vid：声音id name:原始文件名 type：原始图片类型 voice：声音地址 playtime:声* * 音文件的时长 ext传图片的结构：pid：图片id name:原始文件名 type：图片类型 pic：图片地址 "0"为原始图片大* * 小
@property (nonatomic, copy) NSString *newcount; //未读消息数量
@property (nonatomic, copy) NSString *nick; //昵称
@property (nonatomic, copy) NSString *oid; //消息来自于哪个人
@property (nonatomic, copy) NSString *sex; //0:女 1:男
@property (nonatomic, copy) NSString *status; //阅读状态 0未读 1已读
@property (nonatomic, copy) NSString *type; //0全部 1收件 2发件
@property (nonatomic, strong) NSString *sendtime;//发送时间
@property (nonatomic, strong) NSString *title;//群组标题

@end
