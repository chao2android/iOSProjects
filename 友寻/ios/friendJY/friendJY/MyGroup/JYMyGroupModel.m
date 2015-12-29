//
//  JYMyGroupModel.m
//  friendJY
//
//  Created by 高斌 on 15/4/16.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYMyGroupModel.h"

@implementation JYMyGroupModel

- (NSDictionary*)attributeMapDictionary
{
    NSDictionary *mapAtt = @{
                             @"friend_num"   : @"friend_num",
                             @"group_id"     : @"group_id",
                             @"hint"        : @"hint",
                             @"intro"       : @"intro",
                             @"logo"        : @"logo",
                             @"show"        : @"show",
                             @"title"       : @"title",
                             @"total"       : @"total",
                             @"uid"       : @"uid"
                             };
    
    return mapAtt;
}

@end
