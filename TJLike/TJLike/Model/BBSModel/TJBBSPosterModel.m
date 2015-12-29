//
//  TJBBSPosterModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/31.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBBSPosterModel.h"

@implementation TJBBSPosterModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [super setValue:value forUndefinedKey:key];
    if (StringEqual(key, @"id")) {
        self.bbsID = value;
    }
}

@end
