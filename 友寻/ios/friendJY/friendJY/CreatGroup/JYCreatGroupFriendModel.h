//
//  JYCreatGroupFriendModel.h
//  friendJY
//
//  Created by 高斌 on 15/4/15.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYBaseModel.h"

@interface JYCreatGroupFriendModel : JYBaseModel

@property (nonatomic, assign) int mfriend_num;//共同好友数量
@property (nonatomic, copy) NSString *friendUid;
@property (nonatomic, copy) NSString *age;
@property (nonatomic, copy) NSString *avatar;
@property (nonatomic, copy) NSString *nick;
@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *gid;
@property (nonatomic, copy) NSString *mobile;
@property (nonatomic, copy) NSString *marriage; //1.单身
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, copy) NSString *mutualNums;
@property (nonatomic, copy) NSString *relation;
@property (nonatomic, copy) NSString *mark;
@property (nonatomic, copy) NSString *is_friend;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) UIImage * image; //头像image源，为了选中做头像合成使用

+(NSDictionary *)ModelToDict:(JYCreatGroupFriendModel *)model;

@end
