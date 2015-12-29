//
//  JYGroupInfoModel.m
//  friendJY
//
//  Created by 高斌 on 15/4/16.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYGroupInfoModel.h"

@implementation JYGroupInfoModel

- (NSDictionary*)attributeMapDictionary
{

    NSDictionary *mapAtt = @{
                             @"hint"        : @"hint",
                             @"intro"       : @"intro",
                             @"join"        : @"join",
                             @"logo"        : @"logo",
                             @"privilege"   : @"privilege",
                             @"show"        : @"show",
                             @"shownick"    : @"shownick",
                             @"status"      : @"status",
                             @"title"       : @"title",
                             @"uid"         : @"uid",
                             @"userlist"    : @"userlist"
                             };
    
    return mapAtt;
}



@end
