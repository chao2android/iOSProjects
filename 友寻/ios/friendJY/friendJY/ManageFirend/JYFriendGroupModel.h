//
//  JYFriendGroupModel.h
//  friendJY
//
//  Created by chenxiangjing on 15/4/21.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYFriendGroupModel : JYBaseModel

@property (nonatomic, copy) NSString *group_id;

@property (nonatomic, copy) NSString *group_name;

@property (nonatomic, copy) NSString *member_nums;

@property (nonatomic, assign) BOOL selected;

+ (JYFriendGroupModel*)groupModelWithDataArr:(NSArray*)dataArr;

@end
