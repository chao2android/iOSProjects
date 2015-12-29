//
//  TJAppContext.m
//  TJLike
//
//  Created by IPTV_MAC on 15/3/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "TJAppContext.h"

@implementation TJAppContext
#pragma mark - Singleton
+ (instancetype)sharedContext
{
    static dispatch_once_t onceToken;
    static TJAppContext *context = nil;
    dispatch_once(&onceToken, ^{
        context = [[self alloc] initAppContext];
    });
    return context;
}

- (instancetype)init
{
    NSAssert(NO, @"Singleton class, use shared method");
    return nil;
}

- (id)initAppContext
{
    self = [super init];
    if (!self) return nil;
    
    self.deviceInfo = [DeviceInfo info];
    [self.deviceInfo gatherDeviceInfomation];
    
    return self;
}

- (void)initialConfig
{
    
}

@end
