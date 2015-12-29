//
//  FansList.m
//  TestRedCollar
//
//  Created by miracle on 14-7-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "FansList.h"

@implementation FansList

+ (FansList *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    return [[FansList alloc] initWithDict:dict];
}

- (NSDictionary *)GetFormatDict:(NSDictionary *)dictionary {
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
    if (self){
        NSDictionary *netDic = [self GetFormatDict:dictionary];
        self.mDict = netDic;
        self.headImageUrl = [netDic objectForKey:@"portrait"];
        self.nickName = [netDic objectForKey:@"nickname"];
        self.user_name = [netDic objectForKey:@"user_name"];
        self.signature = [netDic objectForKey:@"signature"];
        self.ID = [netDic objectForKey:@"uid"];
        self.mutually = [netDic objectForKey:@"mutually"];
        self.is_fans = [netDic objectForKey:@"is_fans"];
        
        if (self.headImageUrl && self.headImageUrl.length > 0){
            NSRange range = [self.headImageUrl rangeOfString:@"http://"];
            if (range.length == 0){
                self.headImageUrl = [NSString stringWithFormat:@"%@%@",URL_HEADER,self.headImageUrl];
            }
        }
    }
    return self;
}

- (void)dealloc{
    self.mDict = nil;
    self.headImageUrl = nil;
    self.nickName = nil;
    self.user_name = nil;
    self.signature = nil;
    self.ID = nil;
    self.mutually = nil;
    self.is_fans = nil;
}

@end
