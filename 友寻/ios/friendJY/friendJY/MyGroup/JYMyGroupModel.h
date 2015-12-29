//
//  JYMyGroupModel.h
//  friendJY
//
//  Created by 高斌 on 15/4/16.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYMyGroupModel : JYBaseModel

@property (nonatomic, copy) NSString *friend_num; //群中好友数
@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *hint; //提醒 0:接受 1:不接受
@property (nonatomic, copy) NSString *intro; //介绍
@property (nonatomic, copy) NSString *logo; //logo
@property (nonatomic, copy) NSString *show; //在资料页是否显示 0显示 1不显示
@property (nonatomic, copy) NSString *title; //群名
@property (nonatomic, copy) NSString *total; //群人数
@property (nonatomic, strong) NSString *uid;
@property (nonatomic, strong) NSString *from; //来源，2-是从创建群组过来
@property (nonatomic, strong) NSString *isRecommand; //是否是，推荐 群组

//"friend_num" = 1;
//"group_id" = 27750;
//intro = "";
//logo = "http://p.friendly.dev/16/57/0f7335ed6fe1a6756954a54b834e738b/262350_100i.jpg?wh=100x100";
//title = "\U62dc\U62dc\U3001\U5927\U597d3\U3001\U4f1a\U54582183350\U3001\U6d4b\U8bd5";
//total = 5;
//uid = 2165750;


@end
