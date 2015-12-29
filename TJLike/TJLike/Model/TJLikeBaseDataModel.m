//
//  TJLikeBaseDataModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/31.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJLikeBaseDataModel.h"

@implementation TJLikeBaseDataModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if (stuff==nil) {
        stuff=[[NSMutableDictionary alloc] init];
    }
    [stuff setValue:value forKey:key];
    TLog(@"WARNING : <%@> has undefined key: %@, value: %@", NSStringFromClass([self class]), key, value);
}

- (void)setNilValueForKey:(NSString *)key
{
    TLog(@"%@",key);
}

- (id)valueForUndefinedKey:(NSString *)key
{
    id value=[stuff valueForKey:key];
    TLog(@"WARNING : <%@> has undefined key: %@", NSStringFromClass([self class]), key);
    return value;
}

@end
