//
//  LineTimer.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LineTimer;

@protocol LineTimerDelegate <NSObject>

@optional

- (void)LineTimerDidStart:(LineTimer *)sender;
- (void)LineTimerDidFinish:(LineTimer *)sender;
- (void)LineTimerOverMinTime:(LineTimer *)sender;
- (void)LineTimerOverSepTime:(LineTimer *)sender;

@end

@interface LineTimer : UIView {
    float mfRunTime;
    float mfStartTime;
    //UIView *mLineView;
    UIView *mLastView;
    UIView *mBackView;
}

@property (nonatomic, assign) BOOL mbEnableDel;
@property (nonatomic, assign) id<LineTimerDelegate> delegate;
@property (nonatomic, assign) float miTotalTime;
@property (nonatomic, assign) float miMinTime;
@property (nonatomic, assign) float miSepTime;
@property (nonatomic, assign) float mfRunTime;

@property (nonatomic, strong) UIColor *defaultColor;
@property (nonatomic, strong) UIColor *activeColor;
@property (nonatomic, strong) UIColor *minColor;

@property (nonatomic, assign) UILabel *mlbTime;

- (void)StartTimer:(float)fTime;
- (void)StartTimer;
- (void)StopTimer;
- (BOOL)isRunning;
- (void)ResetTimer;

- (void)RefreshBackView;

- (void)RefreshLines:(NSArray *)array;

@end
