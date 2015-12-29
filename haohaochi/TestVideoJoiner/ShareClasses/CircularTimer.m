//
//  CircularTimer.m
//
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CircularTimer.h"

typedef void(^CircularTimerBlock)(void);

@interface CircularTimer ()


@property (nonatomic, strong) NSDate *mStartTime;
@property (nonatomic, strong) NSDate *mEndTime;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) float percentageCompleted;
@property (nonatomic, assign) BOOL running;

@end

@implementation CircularTimer

@synthesize mfRunTime;

#define DEGREES_TO_RADIANS(degrees)((M_PI * degrees)/180)

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.radius = MIN(frame.size.width, frame.size.height)/2;
        self.interalRadius = self.radius*0.75;
        self.defaultColor = [UIColor darkGrayColor];
        self.activeColor = [UIColor redColor];
        self.minColor = [UIColor grayColor];
        self.miTotalTime = 10;
        self.miMinTime = 0;
        self.miSepTime = 0;
    }
    return self;
}

- (BOOL)IsTimeOut {
    if (self.mEndTime) {
        NSTimeInterval interval = [self.mEndTime timeIntervalSinceDate:[NSDate date]];
        if (interval > 0) {
            return NO;
        }
    }
    return YES;
}

- (void)drawRect:(CGRect)rect
{
    //General circle info
    CGPoint center = CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2);
    float strokeWidth = self.radius - self.interalRadius;
    float radius = self.interalRadius + strokeWidth / 2;
    
    //Background circle
    UIBezierPath *circle1 = [UIBezierPath bezierPathWithArcCenter:center
                                                           radius:radius
                                                       startAngle:DEGREES_TO_RADIANS(0.0f)
                                                         endAngle:DEGREES_TO_RADIANS(360.0f)
                                                        clockwise:YES];
    [self.defaultColor setStroke];
    circle1.lineWidth = strokeWidth;
    [circle1 stroke];
    
    //Min circle
    if (self.miMinTime > 0 && self.running) {
        float fValue = self.miMinTime;
        float fTotal = self.miTotalTime;
        fValue = (fValue*100) /fTotal;

        float startAngle = 270.0f;
        float tempDegrees = fValue * 360.0 / 100.f;
        float degrees = (tempDegrees < 90) ? 270 + tempDegrees : tempDegrees - 90;
        
        UIBezierPath *circle2 = [UIBezierPath bezierPathWithArcCenter:center
                                                               radius:radius
                                                           startAngle:DEGREES_TO_RADIANS(startAngle)
                                                             endAngle:DEGREES_TO_RADIANS(degrees)
                                                            clockwise:YES];
        [self.minColor setStroke];
        circle2.lineWidth = strokeWidth;
        [circle2 stroke];
    }
    
    //Active circle
    float startAngle = 0.0f;
    float degrees = 360.0f;
    if (![self IsTimeOut]) {
        [self updatePercentageCompleted];
        startAngle = 270.0f;
        float tempDegrees = self.percentageCompleted * 360.0 / 100.f;
        degrees = (tempDegrees < 90) ? 270 + tempDegrees : tempDegrees - 90;
    }
    else if (!self.mStartTime) {
        degrees = 0.0;
    }
    
    UIBezierPath *circle2 = [UIBezierPath bezierPathWithArcCenter:center
                                                           radius:radius
                                                       startAngle:DEGREES_TO_RADIANS(startAngle)
                                                         endAngle:DEGREES_TO_RADIANS(degrees)
                                                        clockwise:YES];
    [self.activeColor setStroke];
    circle2.lineWidth = strokeWidth;
    [circle2 stroke];
    
}

- (void)updateCircle:(NSTimer *)theTimer
{
    //NSLog(@"updateCircle");
    if ([self IsTimeOut]) {
        [self StopTimer];
        self.percentageCompleted = 100.0f;
        [self setNeedsDisplay];
        if (self.delegate && [self.delegate respondsToSelector:@selector(CircularTimerDidFinish:)]) {
            [self.delegate CircularTimerDidFinish:self];
        }
    }
    else {
        if (!self.running) {
            self.running = YES;
            if (self.delegate && [self.delegate respondsToSelector:@selector(CircularTimerDidStart:)]) {
                [self.delegate CircularTimerDidStart:self];
            }
        }
        [self setNeedsDisplay];
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
            if (self.delegate && [self.delegate respondsToSelector:@selector(CircularTimerOverMinTime:)]) {
                [self.delegate CircularTimerOverMinTime:self];
            }
        }
        if (self.miSepTime>0) {
            if (mfRunTime-mfStartTime>=self.miSepTime) {
                if (self.delegate && [self.delegate respondsToSelector:@selector(CircularTimerOverSepTime:)]) {
                    [self.delegate CircularTimerOverSepTime:self];
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
    
    [self RefreshTimeLabel];
    [self setNeedsDisplay];
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
    self.backgroundColor = [UIColor clearColor];
    if ([self IsTimeOut]) {
        NSLog(@"Final date is smaller than initial.");
    }
    else {
        self.percentageCompleted = 0.0f;
        self.running = NO;
        if (![self IsTimeOut]) {
            self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateCircle:) userInfo:nil repeats:YES];
        }
    }
}

- (BOOL)isRunning
{
    return self.running;
}

- (void)ResetTimer {
    mfRunTime = 0;
    mfStartTime = 0;
    self.mStartTime = nil;
    self.mEndTime = nil;
    self.percentageCompleted = 0.0f;
    [self StopTimer];
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
}

- (void)RefreshTimeLabel {
    if (self.mlbTime) {
        int iTime = mfRunTime;
        self.mlbTime.text = [NSString stringWithFormat:@"%d:%02d", iTime/60, iTime%60];
    }
}

@end
