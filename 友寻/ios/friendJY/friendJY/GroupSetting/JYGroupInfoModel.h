//
//  JYGroupInfoModel.h
//  friendJY
//
//  Created by 高斌 on 15/4/16.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYGroupInfoModel : JYBaseModel

@property (nonatomic, strong) NSString *hint; //提醒 0接受 1不接受
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *join;
@property (nonatomic, strong) NSString *logo;
@property (nonatomic, strong) NSString *privilege; //权限设置
@property (nonatomic, strong) NSString *show; //在资料页是否显示 0显示 1不显示
@property (nonatomic, strong) NSString *status; //0不公开，1公开（将推荐给好友
@property (nonatomic, strong) NSString *shownick; //在群组聊天时显示昵称 0显示 1不显示
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSMutableArray *userlist; //用户列表


@end
