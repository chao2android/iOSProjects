//
//  LineTimer.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "LineTimer.h"
#import "LightImageView.h"

#define Line_Color [UIColor colorWithWhite:0.2 alpha:1.0]

@interface LineTimer () {
    LightImageView *mLightView;
}

@property (nonatomic, strong) NSDate *mStartTime;
@property (nonatomic, strong) NSDate *mEndTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) float percentageCompleted;
@property (nonatomic, assign) BOOL running;
@property (nonatomic, strong) NSMutableArray *mArray;

@end

@implementation LineTimer

@synthesize mfRunTime;

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.mArray = [[NSMutableArray alloc] initWithCapacity:10];
        self.backgroundColor = [UIColor clearColor];
        self.defaultColor = [UIColor darkGrayColor];
        self.activeColor = [UIColor redColor];
        self.minColor = [UIColor grayColor];
        self.miTotalTime = 10;
        self.miMinTime = 0;
        self.miSepTime = 0;
        
        mLightView = [[LightImageView alloc] initWithFrame:CGRectMake(0, frame.size.height-8, frame.size.width, 8)];
        mLightView.backgroundColor = [UIColor whiteColor];
        [self addSubview:mLightView];
        [mLightView StartAnimate];
//        
//        mLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//        [self addSubview:mLineView];
        
    }
    return self;
}

- (void)dealloc {
    if (mLightView) {
        [mLightView removeFromSuperview];
        mLightView = nil;
    }
    self.mStartTime = nil;
    self.mEndTime = nil;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self RefreshDisplay];
    [self RefreshBackView];
}

- (void)RefreshBackView {
    @autoreleasepool {
        if (mBackView) {
            [mBackView removeFromSuperview];
            mBackView = nil;
        }
    }
    mBackView = [[UIView alloc] initWithFrame:self.bounds];
    mBackView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    [self addSubview:mBackView];
    
    if (self.miSepTime > 0) {
        int iCount = self.miTotalTime/self.miSepTime;
        float fWidth = mBackView.frame.size.height/iCount;
        for (int i = 0; i < iCount; i ++) {
            UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, fWidth*(i+1), mBackView.frame.size.width, 1)];
            lineView.backgroundColor = Line_Color;
            [mBackView addSubview:lineView];
        }
    }
    else if (self.miMinTime > 0) {
        float fTop = mBackView.frame.size.height*(self.miTotalTime-self.miMinTime)/self.miTotalTime;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, fTop, mBackView.frame.size.width, 1)];
        lineView.backgroundColor = Line_Color;
        [mBackView addSubview:lineView];
    }
}

- (BOOL)IsTimeOut {
    if (self.mEndTime) {
        NSTimeInterval interval = [self.mEndTime timeIntervalSinceDate:[NSDate date]];
        if (interval >= 0) {
            return NO;
        }
    }
    return YES;
}

- (void)setMbEnableDel:(BOOL)value {
    if (value) {
        if (self.mArray.count>0) {
            UIView *backView = [self.mArray lastObject];
            backView.backgroundColor = [UIColor redColor];
        }
    }
    else {
        for (UIView *view in self.mArray) {
            view.backgroundColor = self.activeColor;
        }
    }
}

- (void)RefreshLines:(NSArray *)array {
    [self CleanLines];
    float fTotalTime = 0;
    for (NSDictionary *dict in array) {
        float fTime = [[dict objectForKey:@"time"] floatValue];
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        [self addSubview:lineView];
        [self.mArray addObject:lineView];
        [self RefreshDisplay];
        fTotalTime += fTime;
        
        self.mfRunTime = fTotalTime;
    }
    if (self.mArray.count == 0) {
        mLightView.frame = CGRectMake(0, self.frame.size.height-8, mLightView.frame.size.width, 8);
    }
    [self RefreshTimeLabel];
}

- (void)RefreshDisplay {
    //Active circle
    if (![self IsTimeOut]) {
        [self updatePercentageCompleted];
    }
    else {
        NSTimeInterval interval = [self.mEndTime timeIntervalSinceDate:[NSDate date]];
        if (interval < 0) {
            self.percentageCompleted = 100.0f;
        }
    }
    if (self.mArray.count == 0) {
        mLightView.frame = CGRectMake(0, self.frame.size.height-8, mLightView.frame.size.width, 8);
        return;
    }
    UIView *lineView = [self.mArray lastObject];
    float fStart = 0;
    if (self.mArray.count > 1) {
        UIView *lineView2 = [self.mArray objectAtIndex:self.mArray.count-2];
        fStart = (self.frame.size.height-lineView2.frame.origin.y+1);
    }
    
    lineView.backgroundColor = self.activeColor;
    float fHeight = self.frame.size.height*self.percentageCompleted/100;
    //NSLog(@"RefreshDisplay:%f, %f, %f", self.percentageCompleted, fHeight, fStart);
    lineView.frame = CGRectMake(0, self.frame.size.height-fHeight, self.frame.size.width, fHeight-fStart);
    mLightView.frame = CGRectMake(0, lineView.frame.origin.y-8, mLightView.frame.size.width, 8);
}

- (void)updateCircle:(NSTimer *)theTimer
{
    //NSLog(@"updateCircle");
    if ([self IsTimeOut]) {
        [self StopTimer];
        self.percentageCompleted = 100.0f;
        [self RefreshDisplay];
        mfRunTime = round(mfRunTime);
        [self RefreshTimeLabel];
        if (self.delegate && [self.delegate respondsToSelector:@selector(LineTimerDidFinish:)]) {
            [self.delegate LineTimerDidFinish:self];
        }
    }
    else {
        if (!self.running) {
            self.running = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(LineTimerDidStart:)]) {
                [self.delegate LineTimerDidStart:self];
            }
        }
        [self RefreshDisplay];
    }
}

- (void)updatePercentageCompleted
{
    if (![self IsTimeOut]) {
        NSTimeInterval fTime = [[NSDate date] timeIntervalSinceDate:self.mStartTime];
        mfRunTime = fTime;
        [self RefreshTimeLabel];
        
        float fTotal = self.miTotalTime;
        self.percentageCompleted = (fTime*100) /fTotal;
        if (self.miMinTime<mfRunTime) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(LineTimerOverMinTime:)]) {
                [self.delegate LineTimerOverMinTime:self];
            }
        }
        if (self.miSepTime>0) {
            if (mfRunTime-mfStartTime>=self.miSepTime) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(LineTimerOverSepTime:)]) {
                    [self.delegate LineTimerOverSepTime:self];
                }
            }
        }
    }
    else {
        self.percentageCompleted = 0.0f;
    }
    //NSLog(@"self.percentageCompleted:%f", self.percentageCompleted);
}

#pragma mark
#pragma mark Public
#pragma mark

- (void)setMfRunTime:(float)value {
    NSLog(@"setMfRunTime:%f", value);
    mfRunTime = value;
    self.mStartTime = [NSDate dateWithTimeIntervalSinceNow:-value];
    self.mEndTime = [NSDate dateWithTimeInterval:self.miTotalTime sinceDate:self.mStartTime];
    
    [self RefreshDisplay];
    [self RefreshTimeLabel];
}

- (void)StartTimer
{
    [self StartTimer:0];
}

- (void)StartTimer:(float)fTime {
    mfStartTime = fTime;
    mfRunTime = fTime;
    
    [self RefreshTimeLabel];
    
    self.mStartTime = [NSDate dateWithTimeIntervalSinceNow:-fTime];
    self.mEndTime = [NSDate dateWithTimeInterval:self.miTotalTime sinceDate:self.mStartTime];
    NSLog(@"StartTimer:%f", fTime);
    //self.backgroundColor = [UIColor clearColor];
    
    self.mbEnableDel = NO;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    [self addSubview:lineView];
    [self.mArray addObject:lineView];

    [mLightView StopAnimate];
    
    if ([self IsTimeOut]) {
        NSLog(@"Final date is smaller than initial.");
    }
    else {
        self.percentageCompleted = 0.0f;
        self.running = NO;
        if (![self IsTimeOut]) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateCircle:) userInfo:nil repeats:YES];
        }
    }
}

- (BOOL)isRunning
{
    return self.running;
}

- (void)CleanLines {
    @autoreleasepool {
        for (UIView *view in self.mArray) {
            [view removeFromSuperview];
        }
        [self.mArray removeAllObjects];
    }
}

- (void)ResetTimer {
    [self CleanLines];
    mfRunTime = 0;
    mfStartTime = 0;
    self.mStartTime = nil;
    self.mEndTime = nil;
    self.percentageCompleted = 0.0f;
    [self StopTimer];
    
    [mLightView StopAnimate];
    
    [self RefreshTimeLabel];
}

- (void)StopTimer
{
    self.running = NO;
    NSLog(@"StopTimer");
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
    [mLightView StartAnimate];
}

- (void)RefreshTimeLabel {
    if (self.mlbTime) {
        int iTime = mfRunTime;
        self.mlbTime.text = [NSString stringWithFormat:@"%d:%02d", iTime/60, iTime%60];
    }
}

@end
