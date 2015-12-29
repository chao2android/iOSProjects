//
//  JYFeedDetailModel.h
//  friendJY
//
//  Created by ouyang on 4/7/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//
#import "JYBaseModel.h"

@interface JYFeedDetailModel : JYBaseModel
@property (nonatomic,strong) NSString * feedid;
@property (nonatomic,strong) NSString * feedUid;
@property (nonatomic,strong) NSDictionary * avatar;
@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * id;
@property (nonatomic,strong) NSString * nick;
@property (nonatomic,strong) NSDictionary * reply;
@property (nonatomic,strong) NSString * sex;
@property (nonatomic,strong) NSString * time;
@property (nonatomic,strong) NSString * uid;


@end
