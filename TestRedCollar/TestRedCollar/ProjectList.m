//
//  ProjectList.m
//  TestRedCollar
//
//  Created by miracle on 14-7-27.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ProjectList.h"

@implementation ProjectList

+ (ProjectList *)CreateWithDict:(NSDictionary *)dict
{
    if (!dict || ![dict isKindOfClass:[NSDictionary class]])
    {
        return nil;
    }
    return [[ProjectList alloc] initWithDict:dict];
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
        self.add_time = [netDic objectForKey:@"add_time"];
        self.title = [netDic objectForKey:@"title"];
        self.comment_num = [netDic objectForKey:@"comment_num"];
        self.like_num = [netDic objectForKey:@"like_num"];
        self.url = [netDic objectForKey:@"url"];
        self.view = [netDic objectForKey:@"view"];
        self.ID = [netDic objectForKey:@"id"];
        
    }
    return self;
}

- (void)dealloc{
    self.mDict = nil;
    self.add_time = nil;
    self.title = nil;
    self.comment_num = nil;
    
    self.like_num = nil;
    self.url = nil;
    self.view = nil;
    self.ID = nil;
}

@end
