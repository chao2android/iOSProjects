//
//  FansList.h
//  TestRedCollar
//
//  Created by miracle on 14-7-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FansList : NSObject

@property (nonatomic, strong) NSDictionary *mDict;
@property (nonatomic, strong) NSString *headImageUrl;
@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *user_name;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *ID;
@property (nonatomic, strong) NSString *mutually;
@property (nonatomic, strong) NSString *is_fans;

+ (FansList *)CreateWithDict:(NSDictionary *)dict;
- (id)initWithDict:(NSDictionary *)dictionary;

@end
