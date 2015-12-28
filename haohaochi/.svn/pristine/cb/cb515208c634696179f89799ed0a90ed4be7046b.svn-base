//
//  UIDevice+Orientation.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-16.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "UIDevice+Orientation.h"

static MDeviceOrientation *gDevOri = nil;

@implementation MDeviceOrientation

@synthesize deviceOrientation;

+ (MDeviceOrientation *)Share {
    if (!gDevOri) {
        gDevOri = [[MDeviceOrientation alloc] init];
    }
    return gDevOri;
}

- (void)GetDeviceRotation {
    self.mMotionManager = [[CMMotionManager alloc] init];
    if (!self.mMotionManager.accelerometerAvailable) {
        NSLog(@"没有加速计");
    }
    self.mMotionManager.accelerometerUpdateInterval = 0.1; // 告诉manager，更新频率是100Hz
    [self.mMotionManager startDeviceMotionUpdates];
    
    [self.mMotionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData *latestAcc, NSError *error)
     {
         float xx = -latestAcc.acceleration.x;
         float yy = latestAcc.acceleration.y;
         float angle = atan2(yy, xx);
         // Read my blog for more details on the angles. It should be obvious that you
         // could fire a custom shouldAutorotateToInterfaceOrientation-event here.
         if(angle >= -2.25 && angle <= -0.25) {
             NSNumber *number = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
             [self performSelectorOnMainThread:@selector(UpdateInterfaceOrientation:) withObject:number waitUntilDone:YES];
         }
         else if(angle >= -1.75 && angle <= 0.75) {
             NSNumber *number = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeRight];
             [self performSelectorOnMainThread:@selector(UpdateInterfaceOrientation:) withObject:number waitUntilDone:YES];
         }
         else if(angle >= 0.75 && angle <= 2.25) {
             NSNumber *number = [NSNumber numberWithInt:UIInterfaceOrientationPortraitUpsideDown];
             [self performSelectorOnMainThread:@selector(UpdateInterfaceOrientation:) withObject:number waitUntilDone:YES];
         }
         else if(angle <= -2.25 || angle >= 2.25) {
             NSNumber *number = [NSNumber numberWithInt:UIInterfaceOrientationLandscapeLeft];
             [self performSelectorOnMainThread:@selector(UpdateInterfaceOrientation:) withObject:number waitUntilDone:YES];
         }
     }];
}

- (void)UpdateInterfaceOrientation:(NSNumber *)value {
    UIInterfaceOrientation orientation = [value intValue];
    if (deviceOrientation != orientation) {
        //NSLog(@"UpdateInterfaceOrientation:%@", value);
        deviceOrientation = orientation;
        if (self.mLastTime) {
            NSTimeInterval interval = -[self.mLastTime timeIntervalSinceNow];
            if (interval>0.5 && self.isPortrait) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kMsg_OrientationError object:nil];
            }
        }
        self.mLastTime = [NSDate date];
    }
}

- (BOOL)isLandscape {
    return ((deviceOrientation == UIInterfaceOrientationLandscapeLeft) || (deviceOrientation == UIInterfaceOrientationLandscapeRight));
}

- (BOOL)isPortrait {
    NSLog(@"deviceOrientation:%ld", deviceOrientation);
    return ((deviceOrientation == UIInterfaceOrientationPortraitUpsideDown) || (deviceOrientation == UIInterfaceOrientationPortrait));
}

@end
