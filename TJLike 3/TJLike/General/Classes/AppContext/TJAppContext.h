//
//  TJAppContext.h
//  TJLike
//
//  Created by IPTV_MAC on 15/3/29.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DeviceInfo.h"

@interface TJAppContext : NSObject
// device info
@property (nonatomic, strong) DeviceInfo * deviceInfo;

+ (instancetype)sharedContext;
- (void)initialConfig;

@end
