//
//  JYSysMsgModel.m
//  friendJY
//
//  Created by ouyang on 5/5/15.
//  Copyright (c) 2015 高斌. All rights reserved.
//

#import "JYSysMsgModel.h"

@implementation JYSysMsgModel

- (NSDictionary*)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"avatars"     : @"avatars",
                             @"city"        : @"city",
                             @"friendnick"  : @"friendnick",
                             @"group_id"    : @"group_id",
                             @"iid"         : @"iid",
                             @"logo"        : @"logo",
                             @"nick"        : @"nick",
                             @"privonce"    : @"privonce",
                             @"relation"    : @"relation",
                             @"sendtime"    : @"sendtime",
                             @"title"       : @"title",
                             @"status"      : @"status",
                             @"type"        : @"type",
                             @"uid"         : @"uid",
                             @"pid"         : @"pid",
                             @"photolists"  : @"photolists",
                             @"friendlists" : @"friendlists",
                             @"acceptType"  : @"acceptType",
                             @"name"  : @"name",
                             @"uname"  : @"uname"
                             };
    
    return mapAtt;
}

@end
