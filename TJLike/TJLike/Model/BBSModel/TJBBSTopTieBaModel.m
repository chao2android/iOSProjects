//
//  TJBBSTopTieBaModel.m
//  TJLike
//
//  Created by IPTV_MAC on 15/4/11.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJBBSTopTieBaModel.h"

@implementation TJBBSTopTieBaModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    [super setValue:value forUndefinedKey:key];
    if (StringEqual(key, @"id")) {
        self.topID = value;
    }
}

@end
