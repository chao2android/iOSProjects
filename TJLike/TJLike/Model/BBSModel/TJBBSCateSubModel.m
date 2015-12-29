//
//  TJBBSCateSubModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/4.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBBSCateSubModel.h"

@implementation TJBBSCateSubModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [super setValue:value forUndefinedKey:key];
    if (StringEqual(key, @"id")) {
        self.subID = value;
    }
}


@end
