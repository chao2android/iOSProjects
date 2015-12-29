//
//  JYGroupMemberModel.h
//  friendJY
//
//  Created by chenxiangjing on 15/5/6.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYGroupMemberModel : JYBaseModel

@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, assign) BOOL isOwner;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *marriage;
@property (nonatomic, copy) NSString *uid;

@end
