//
//  CircularTimer.h
//
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CircularTimer;

@protocol CircularTimerDelegate <NSObject>

@optional

- (void)CircularTimerDidStart:(CircularTimer *)sender;
- (void)CircularTimerDidFinish:(CircularTimer *)sender;
- (void)CircularTimerOverMinTime:(CircularTimer *)sender;
- (void)CircularTimerOverSepTime:(CircularTimer *)sender;

@end

@interface CircularTimer : UIView {
    float mfRunTime;
    float mfStartTime;
}

@property (nonatomic, assign) id<CircularTimerDelegate> delegate;
@property (nonatomic, assign) float miTotalTime;
@property (nonatomic, assign) float miMinTime;
@property (nonatomic, assign) float miSepTime;
@property (nonatomic, assign) float mfRunTime;

@property (nonatomic, assign) float radius;
@property (nonatomic, assign) float interalRadius;
@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *activeColor;
@property (nonatomic, strong) UIColor *minColor;

@property (nonatomic, assign) UILabel *mlbTime;

- (void)StartTimer:(float)fTime;
- (void)StartTimer;
- (void)StopTimer;
- (BOOL)isRunning;
- (void)ResetTimer;

@end
