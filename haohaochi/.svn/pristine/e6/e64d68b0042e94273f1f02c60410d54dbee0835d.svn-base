//
//  SwitchImageView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "SwitchImageView.h"

@implementation SwitchImageView

@synthesize mbExpand, delegate, OnLightChange;

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        float fLeft = (self.frame.size.width-28)/2;
        UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(fLeft, fLeft, 28, 14)];
        topView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        topView.image = [UIImage imageNamed:@"f_lighttop"];
        [self addSubview:topView];
        
        UIImageView *botView = [[UIImageView alloc] initWithFrame:CGRectMake(fLeft, self.frame.size.height-fLeft-14, 28, 14)];
        botView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        botView.image = [UIImage imageNamed:@"f_lightbot"];
        [self addSubview:botView];
        
        UIImageView *midView = [[UIImageView alloc] initWithFrame:CGRectMake(fLeft, fLeft+14, 28, self.frame.size.height-fLeft*2-27)];
        midView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        midView.image = [UIImage imageNamed:@"f_lightcenter"];
        [self addSubview:midView];
        
        mbExpand = NO;
        for (int i = 0; i < 2; i ++) {
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake((frame.size.width-27)/2, (frame.size.height-27)/2, 27, 27);
            btn.tag = 1000+i;
            [btn addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if (i == 0) {
                [btn setImage:[UIImage imageNamed:@"p_lightbtn1"] forState:UIControlStateNormal];
                mOpenBtn = btn;
            }
            else {
                [btn setImage:[UIImage imageNamed:@"p_lightbtn2"] forState:UIControlStateNormal];
                mCloseBtn = btn;
            }
        }
    }
    return self;
}

- (void)setMbLightOn:(BOOL)value {
    _mbLightOn = value;
    if (_mbLightOn) {
        [self bringSubviewToFront:mOpenBtn];
        mCloseBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        mOpenBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        mCloseBtn.hidden = YES;
    }
    else {
        mOpenBtn.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
        mCloseBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        [self bringSubviewToFront:mCloseBtn];
        mOpenBtn.hidden = YES;
    }
}

- (void)OnButtonClick:(UIButton *)sender {
    self.userInteractionEnabled = NO;
    mbExpand = !mbExpand;
    if (mbExpand) {
        mOpenBtn.hidden = NO;
        mCloseBtn.hidden = NO;
        CGRect rect = self.frame;
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(rect.origin.x, rect.origin.y-50, rect.size.width, 90);
        } completion:^(BOOL bFinish) {
            self.userInteractionEnabled = YES;
        }];
    }
    else {
        [self bringSubviewToFront:sender];
        CGRect rect = self.frame;
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(rect.origin.x, rect.origin.y+50, rect.size.width, 40);
        } completion:^(BOOL bFinish) {
            self.userInteractionEnabled = YES;
            self.mbLightOn = (sender == mOpenBtn);
            if (delegate && OnLightChange) {
                SafePerformSelector([delegate performSelector:OnLightChange withObject:self]);
            }
        }];
    }
}

@end
