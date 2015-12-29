//
//  JYGroupModel.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/8.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYGroupModel : JYBaseModel
//"群id","group_id":123123(类型int,群组的id)
//"群名","title":"我们的聊天群"(类型string)
//"群组简介","intro" (类型string)
//"群人数","total":123(类型int)
//"群icon","logo":"xxxx.png"(类型string,最近四人加入的缩略图，待定)
//"群中好友数","friend_num":28(类型int,好友数)
- (id)initWithDataDic:(NSDictionary *)data;

@property (nonatomic, copy) NSString *group_id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *intro;
@property (nonatomic, copy) NSString *total;
@property (nonatomic, copy) NSString *logo;
@property (nonatomic, copy) NSString *show;
@property (nonatomic, copy) NSString *hint;
@property (nonatomic, copy) NSString *friend_num;
@property (nonatomic, copy) NSString *join;
@property (nonatomic, copy) NSString *status;

@end
