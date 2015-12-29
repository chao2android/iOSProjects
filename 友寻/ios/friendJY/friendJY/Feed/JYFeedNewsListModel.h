//
//  JYFeedNewsListModel.h
//  friendJY
//
//  Created by ouyang on 4/20/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JYBaseModel.h"

@interface JYFeedNewsListModel : JYBaseModel

@property (nonatomic,strong) NSString * avatars;
@property (nonatomic,strong) NSString * fcontent;
@property (nonatomic,strong) NSString * fid;
@property (nonatomic,strong) NSDictionary * fpids;
@property (nonatomic,strong) NSString * ftype;
@property (nonatomic,strong) NSString * iid;
@property (nonatomic,strong) NSString * nick;
@property (nonatomic,strong) NSString * sendtime;
@property (nonatomic,strong) NSString * title;
@property (nonatomic,strong) NSString * type;
@property (nonatomic,strong) NSString * uid;
@end
