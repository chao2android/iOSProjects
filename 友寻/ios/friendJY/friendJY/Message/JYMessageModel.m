//
//  JYMessageModel.m
//  friendJY
//
//  Created by 高斌 on 15/4/14.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYMessageModel.h"

@implementation JYMessageModel

- (NSDictionary*)attributeMapDictionary
{
    
    NSDictionary *mapAtt = @{
                             @"avatar"     : @"avatar",
                             @"content"    : @"content",
                             @"iid"        : @"iid",
                             @"msgtype"    : @"msgtype",
                             @"newcount"   : @"newcount",
                             @"nick"       : @"nick",
                             @"oid"        : @"oid",
                             @"sendtime"   : @"sendtime",
                             @"sex"        : @"sex",
                             @"status"     : @"status",
                             @"hint"       : @"hint",
                             @"logo"       : @"logo",
                             @"group_id"   : @"group_id",
                             @"title"   : @"title",
                             @"ext"        : @"ext"
                             };
    return mapAtt;
}

@end
