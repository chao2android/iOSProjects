//
//  PhotoList.m
//  TestRedCollar
//
//  Created by miracle on 14-7-19.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PhotoList.h"

@implementation PhotoList

+ (PhotoList *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    return [[PhotoList alloc] initWithDict:dict];
}

- (NSDictionary *)GetFormatDict:(NSDictionary *)dictionary
{
    NSMutableDictionary *netDic = [NSMutableDictionary dictionaryWithDictionary:dictionary];
    for (NSString *key in netDic.allKeys)
    {
        id target = [netDic objectForKey:key];
        if ([target isKindOfClass:[NSNull class]])
        {
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
        self.title = [netDic objectForKey:@"title"];
        self.top_url = [netDic objectForKey:@"top_url"];
        self.pic_num = [netDic objectForKey:@"pic_num"];
        self.ID = [netDic objectForKey:@"id"];
        
    }
    return self;
}

- (void)dealloc{
    self.mDict = nil;
    self.title = nil;
    self.top_url = nil;
    self.pic_num = nil;
    self.ID = nil;
}


@end
