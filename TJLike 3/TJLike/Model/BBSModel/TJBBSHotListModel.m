//
//  TJBBSHotListModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/2.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBBSHotListModel.h"

@implementation TJBBSHotListModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [super setValue:value forUndefinedKey:key];
    if (StringEqual(key, @"id")) {
        self.bbsId = value;
    }
}

@end
