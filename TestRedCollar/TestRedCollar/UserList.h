//
//  UserList.h
//  TestRedCollar
//
//  Created by miracle on 14-7-16.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserList : NSObject

@property (nonatomic, strong) NSDictionary *mDict;
@property (nonatomic, strong) NSString *portrait;
@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *signature;
@property (nonatomic, strong) NSString *follows;
@property (nonatomic, strong) NSString *fans;
@property (nonatomic, strong) NSString *def_addr;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *province;
@property (nonatomic, strong) NSString *coin;
@property (nonatomic, strong) NSString *point;
@property (nonatomic, assign) NSString *isfollow;
@property (nonatomic, assign) NSString *user_name;

+ (UserList *)CreateWithDict:(NSDictionary *)dict;
- (id)initWithDict:(NSDictionary *)dictionary;

@end
