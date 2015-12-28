//
//  LightImageView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "LightImageView.h"

@implementation LightImageView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mLightView = [[UIView alloc] initWithFrame:self.bounds];
        mLightView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:mLightView];
        mAnimateView = [[UIView alloc] initWithFrame:self.bounds];
        mAnimateView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [self addSubview:mAnimateView];
        
        [self HideView];
    }
    return self;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    mLightView.backgroundColor = backgroundColor;
    mAnimateView.backgroundColor = backgroundColor;
}

- (void)StartAnimate {
    self.mbAnimating = YES;
    mLightView.hidden = YES;
    mAnimateView.hidden = NO;
}

- (void)StopAnimate {
    self.mbAnimating = NO;
    mLightView.hidden = NO;
    mAnimateView.hidden = YES;
}

- (void)HideView {
    [UIView animateWithDuration:0.3 animations:^{
        mAnimateView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self ShowView];
    }];
}

- (void)ShowView {
    [UIView animateWithDuration:0.3 animations:^{
        mAnimateView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self HideView];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
