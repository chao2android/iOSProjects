//
//  UIDevice+Orientation.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-16.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

@interface MDeviceOrientation : NSObject {
    double mfGravityX;
}

@property (nonatomic, strong) NSDate *mLastTime;
@property (nonatomic, strong) CMMotionManager *mMotionManager;

@property (nonatomic) UIInterfaceOrientation deviceOrientation;

+ (MDeviceOrientation *)Share;
- (BOOL)isLandscape;
- (BOOL)isPortrait;
- (void)GetDeviceRotation;

@end
