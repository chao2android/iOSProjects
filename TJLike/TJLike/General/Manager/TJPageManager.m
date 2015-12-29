//
//  TJPageManager.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJPageManager.h"

@implementation TJPageManager

+ (instancetype)sharePageManager
{
    static dispatch_once_t onceToken;
    static TJPageManager *manager;
    dispatch_once(&onceToken, ^{
       
        manager = [[self alloc] initPageManager];
        
    });
    return manager;
}
- (instancetype)init {
    NSAssert(NO, @"Singleton class, use shared method");
    return nil;
}

- (instancetype)initPageManager {
    self = [super init];
    if (!self) return nil;
    
    return self;
}


@end
