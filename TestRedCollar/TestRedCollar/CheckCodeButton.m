//
//  CheckCodeButton.m
//  掌上社区
//
//  Created by Hepburn Alex on 14-4-2.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import "CheckCodeButton.h"

static NSDate *mLastDate = nil;

@implementation CheckCodeButton

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        mCheckBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mCheckBtn.frame = self.bounds;
        mCheckBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [mCheckBtn addTarget:self action:@selector(OnCheckBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [mCheckBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
        [mCheckBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [mCheckBtn setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
        mCheckBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:mCheckBtn];
        
        if (![self IsCheckCodeEnable]) {
            [self StartCheck];
        }
    }
    return self;
}

- (void)OnCheckBtnClick {
    if (delegate) {
        BOOL bCheck = [delegate GetCheckCode];
        if (bCheck) {
            mLastDate = [NSDate date];
            [self StartCheck];
        }
    }
}

- (void)dealloc {
    NSLog(@"checkcode dealloc");
    [self Cancel];
}

- (void)setMTitleColor:(UIColor *)color {
    [mCheckBtn setTitleColor:color forState:UIControlStateNormal];
}

- (UIColor *)mTitleColor {
    return mCheckBtn.titleLabel.textColor;
}

- (void)StartCheck {
    [self Cancel];
    mCheckBtn.enabled = NO;
    mTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(OnTimeCheck) userInfo:nil repeats:YES];
    [mTimer fire];
}

- (BOOL)IsCheckCodeEnable {
    if (!mLastDate) {
        return YES;
    }
    NSDate *curdate = [NSDate date];
    NSTimeInterval interval = [curdate timeIntervalSinceDate:mLastDate];
    if (interval>60 || interval<0) {
        return YES;
    }
    return NO;
}

- (void)OnTimeCheck {
    NSDate *curdate = [NSDate date];
    NSTimeInterval interval = [curdate timeIntervalSinceDate:mLastDate];
    if (interval>60 || interval < 0) {
        [self Cancel];
    }
    else {
        int iRest = round(60.0-interval);
        NSString *text = [NSString stringWithFormat:@"%d秒", iRest];
        [mCheckBtn setTitle:text forState:UIControlStateNormal];
    }
}

- (void)Cancel {
    [mCheckBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    mCheckBtn.enabled = YES;
    if (mTimer) {
        [mTimer invalidate];
        mTimer = nil;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
