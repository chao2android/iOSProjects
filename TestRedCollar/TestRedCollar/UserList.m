//
//  UserList.m
//  TestRedCollar
//
//  Created by miracle on 14-7-16.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UserList.h"

@implementation UserList

+ (UserList *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[UserList alloc] initWithDict:dict];
}

- (NSDictionary *)GetFormatDict:(NSDictionary *)dictionary
{
    NSMutableDictionary *netDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    for (NSString *key in netDic.allKeys) {
        id target = [netDic objectForKey:key];
        if ([target isKindOfClass:[NSNull class]]) {
            [netDic removeObjectForKey:key];
        }
    }
    return netDic;
}

- (id)initWithDict:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        NSDictionary *netDic = [self GetFormatDict:dictionary];
        self.mDict = netDic;
        self.portrait = [netDic objectForKey:@"avatar"];
        self.nickname = [netDic objectForKey:@"nickname"];
        self.signature = [netDic objectForKey:@"signature"];
        self.follows = [netDic objectForKey:@"follows"];
        self.fans = [netDic objectForKey:@"fans"];
        self.def_addr = [netDic objectForKey:@"def_addr"];
        self.gender = [netDic objectForKey:@"gender"];
        self.city = [netDic objectForKey:@"city"];
        self.province = [netDic objectForKey:@"province"];
        self.coin = [netDic objectForKey:@"coin"];
        self.point = [netDic objectForKey:@"point"];
        self.isfollow = [netDic objectForKey:@"isfollow"];
        self.user_name = [netDic objectForKey:@"user_name"];
        
    }
    return self;
}

- (void)dealloc
{
    self.mDict = nil;
    self.portrait = nil;
    self.nickname = nil;
    self.signature = nil;
    self.follows = nil;
    self.fans = nil;
    self.def_addr = nil;
    self.gender = nil;
    self.city = nil;
    self.province = nil;
    self.coin = nil;
    self.point = nil;
    self.isfollow = nil;
    self.user_name = nil;
} 

@end
