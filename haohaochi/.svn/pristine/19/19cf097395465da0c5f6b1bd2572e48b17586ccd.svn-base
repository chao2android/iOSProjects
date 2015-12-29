//
//  VideoUrlInfo.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-28.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "VideoUrlInfo.h"

@implementation VideoUrlInfo

- (id)init {
    self = [super init];
    if (self) {
        self.mDuration = kCMTimeZero;
        self.mStartTime = kCMTimeZero;
        self.mbSoundLow = NO;
    }
    return self;
}

- (void)setMfTime:(float)value {
    _mfTime = value;
    if (_mfTime > 0) {
        self.mDuration = CMTimeMake(_mfTime*600, 600);
    }
    else {
        self.mDuration = kCMTimeZero;
    }
}

- (void)setMfStartTime:(float)value {
    _mfStartTime = value;
    if (_mfStartTime > 0) {
        self.mStartTime = CMTimeMake(_mfStartTime*600, 600);
    }
    else {
        self.mStartTime = kCMTimeZero;
    }
}

@end
