//
//  JYProfileGroupDetailController.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseController.h"

@class JYGroupModel;

@interface JYProfileGroupDetailController : JYBaseController

@property (nonatomic, strong) JYGroupModel *group;

@property (nonatomic, copy) void (^HadJoinedGroup)(NSString *group_id);

@end
