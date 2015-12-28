//
//  ShowWantGoView.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ShowWantGoView.h"

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

@implementation ShowWantGoView
{
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float fScale = KscreenWidth/320;

        UIImageView *botView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth, 174)];
        botView.image = [UIImage imageNamed:@"p_havegoback"];
        botView.userInteractionEnabled = YES;
        [self addSubview:botView];
        
        mBotView = botView;
        
        _mFlagView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
        _mFlagView.image = [UIImage imageNamed:@"f_havego"];
        _mFlagView.userInteractionEnabled = YES;
        [botView addSubview:_mFlagView];
        
        _titlePic = [[UIImageView alloc]initWithFrame:CGRectMake(36*fScale, (frame.size.height-30*fScale)/2, 38*fScale, 30*fScale)];
        _titlePic.backgroundColor = [UIColor clearColor];
        [botView addSubview:_titlePic];
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(90*fScale, 0, 220, self.bounds.size.height)];
        
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor grayColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:20];
        [botView addSubview:_titleLabel];
        
        mBotView.frame = CGRectMake(0, self.frame.size.height, mBotView.frame.size.width, mBotView.frame.size.height);
        [UIView animateWithDuration:0.3 animations:^{
            mBotView.frame = CGRectMake(0, 0, mBotView.frame.size.width, mBotView.frame.size.height);
        }];
    }
    return self;
}

- (void)AnimateHide {
    [UIView animateWithDuration:0.3 animations:^{
        mBotView.frame = CGRectMake(0, self.frame.size.height, mBotView.frame.size.width, mBotView.frame.size.height);
    } completion:^(BOOL bFinish) {
        [self removeFromSuperview];
    }];
}

+(void)ShowWantGo{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    ShowWantGoView *alertView = [[ShowWantGoView alloc] initWithFrame:CGRectMake(0, window.bounds.size.height-66, window.bounds.size.width, 66)];
    [window addSubview:alertView];
    alertView.mFlagView.image = [UIImage imageNamed:@"f_wantgo"];
    alertView.titleLabel.text = @"已经添加到要去列表";
    MB_RELEASE(alertView);
    [alertView performSelector:@selector(AnimateHide) withObject:nil afterDelay:2.0];
}

+(void)ShowHaveGo:(BOOL)love {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    ShowWantGoView *alertView = [[ShowWantGoView alloc] initWithFrame:CGRectMake(0, window.bounds.size.height-66, window.bounds.size.width, 66)];
    [window addSubview:alertView];
    alertView.mFlagView.image = [UIImage imageNamed:@"f_havego"];
    if (love) {
        alertView.titlePic.image = [UIImage imageNamed:@"f_havegolove"];
    }
    else {
        alertView.titlePic.image = [UIImage imageNamed:@"f_havegohate"];
    }
    alertView.titleLabel.text = @"已经添加到去过列表";
    MB_RELEASE(alertView);
    [alertView performSelector:@selector(AnimateHide) withObject:nil afterDelay:2.0];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
