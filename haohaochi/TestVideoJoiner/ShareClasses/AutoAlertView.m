//
//  AutoAlertView.m
//  ManziDigest
//
//  Created by Hepburn Alex on 12-10-15.
//  Copyright (c) 2012年 Hepburn Alex. All rights reserved.
//

#import "AutoAlertView.h"
#import <QuartzCore/QuartzCore.h>

#if __has_feature(objc_arc)
#define MB_AUTORELEASE(exp) exp
#define MB_RELEASE(exp)
#define MB_DEALLOC()
#define MB_RETAIN(exp) exp
#else
#define MB_AUTORELEASE(exp) [exp autorelease]
#define MB_RELEASE(exp) [exp release]
#define MB_RETAIN(exp) [exp retain]
#define MB_DEALLOC() [super dealloc]
#endif

@implementation AutoAlertView

@synthesize mlbMsg, mBackView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;

        mBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 160, 160)];
        mBackView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        mBackView.layer.cornerRadius = 10;
        mBackView.layer.masksToBounds = YES;
        mBackView.center = CGPointMake(frame.size.width/2, frame.size.height/2);
        [self addSubview:mBackView];
        MB_RELEASE(mBackView);

        mlbMsg = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 140, 80)];
        mlbMsg.backgroundColor = [UIColor clearColor];
        mlbMsg.font = [UIFont systemFontOfSize:16];
        mlbMsg.textAlignment = NSTextAlignmentCenter;
        mlbMsg.textColor = [UIColor whiteColor];
        mlbMsg.numberOfLines = 0;
        [mBackView addSubview:mlbMsg];
        MB_RELEASE(mlbMsg);
    }
    return self;
}

- (void)DidAnimateHideEnd {
    [self removeFromSuperview];
}

- (void)AnimateHide {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationDelay:1.0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(DidAnimateHideEnd)];
    self.alpha = 0.0;
    [UIView commitAnimations];
}


+ (void)ShowMessage:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    AutoAlertView *alertView = [[AutoAlertView alloc] initWithFrame:window.bounds];
    [window addSubview:alertView];
    MB_RELEASE(alertView);
    alertView.mlbMsg.text = message;
    [alertView AnimateHide];
}

+ (void)ShowMessage:(NSString *)message :(int)iTop {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    AutoAlertView *alertView = [[AutoAlertView alloc] initWithFrame:window.bounds];
    [window addSubview:alertView];
    MB_RELEASE(alertView);
    CGRect rect = alertView.mBackView.frame;
    rect.origin.y = iTop;
    alertView.mBackView.frame = rect;
    alertView.mlbMsg.text = message;
    [alertView AnimateHide];
}

+ (void)ShowAlert:(NSString *)title message:(NSString *)message {
#ifdef LL
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:LL(@"确定") otherButtonTitles:nil];
#else
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
#endif
    [alertView show];
    MB_RELEASE(alertView);
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
