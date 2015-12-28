//
//  DeviceInfo.h
//  WiseTV
//
//  Created by Ran on 14-10-20.
//  Copyright (c) 2014年 tjgdMobilez. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, DeviceVersion){
    iPhone4 = 3,
    iPhone4S = 4,
    iPhone5 = 5,
    iPhone5C = 5,
    iPhone5S = 6,
    iPhone6 = 7,
    iPhone6Plus = 8,
    iPod = 9,
    Simulator = 0
};

@interface DeviceInfo : NSObject

+ (instancetype)info;

@property (nonatomic, assign) CGFloat screenWidth;
@property (nonatomic, assign) CGFloat screenHeight;
@property (nonatomic, assign) CGSize  screenSize;
@property (nonatomic, assign) CGRect  screenBounds;
@property (nonatomic, assign) CGFloat systemVersion;
@property (nonatomic, assign) DeviceVersion deviceVersion;
@property (nonatomic, strong) NSString *deviceName;
@property (nonatomic, strong) NSString *iphoneName;
@property (nonatomic, strong) NSString *model;

- (void)gatherDeviceInfomation;

@end
