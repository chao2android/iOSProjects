//
//  ProximityMonitor.m
//  TestPinBang
//
//  Created by Hepburn Alex on 13-7-4.
//  Copyright (c) 2013年 Hepburn Alex. All rights reserved.
//

#import "ProximityMonitor.h"
#import <AVFoundation/AVFoundation.h>

static ProximityMonitor *gProximity = nil;

@implementation ProximityMonitor

+ (ProximityMonitor *)Share {
    if (!gProximity) {
        gProximity = [[ProximityMonitor alloc] init];
    }
    return gProximity;
}

- (id)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void)sensorStateChange:(NSNotificationCenter *)notification; {
    if ([[UIDevice currentDevice] proximityState] == YES) {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)StartMonitor {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:YES];
}

- (void)StopMonitor {
    [[UIDevice currentDevice] setProximityMonitoringEnabled:NO];
}

@end
