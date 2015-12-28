//
//  ImageProgressView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-15.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ImageProgressView.h"

@implementation ImageProgressView


- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        mBackView = [[UIImageView alloc] initWithFrame:CGRectMake((frame.size.width-164)/2, (frame.size.height-7)/2, 164, 7)];
        mBackView.image = [UIImage imageNamed:@"f_progressline"];
        [self addSubview:mBackView];
        
        mFlagView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
        mFlagView.image = [UIImage imageNamed:@"f_progressmark"];
        mFlagView.userInteractionEnabled = YES;
        [self addSubview:mFlagView];
        
        UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        leftBtn.frame = CGRectMake(mBackView.frame.origin.x-40, (frame.size.height-40)/2-2, 40, 40);
        [leftBtn setTitle:@"-" forState:UIControlStateNormal];
        [leftBtn setTitleColor:[UIColor colorWithRed:0.12 green:0.52 blue:0.57 alpha:1.0] forState:UIControlStateNormal];
        [leftBtn addTarget:self action:@selector(OnLeftClick) forControlEvents:UIControlEventTouchUpInside];
        leftBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
        [self addSubview:leftBtn];
        
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        rightBtn.frame = CGRectMake(mBackView.frame.origin.x+mBackView.frame.size.width, (frame.size.height-40)/2-2, 40, 40);
        [rightBtn setTitleColor:[UIColor colorWithRed:0.12 green:0.52 blue:0.57 alpha:1.0] forState:UIControlStateNormal];
        [rightBtn setTitle:@"+" forState:UIControlStateNormal];
        [rightBtn addTarget:self action:@selector(OnRightClick) forControlEvents:UIControlEventTouchUpInside];
        rightBtn.titleLabel.font = [UIFont boldSystemFontOfSize:25];
        [self addSubview:rightBtn];
        
        mStartPoint = mFlagView.center;
        
        mFlagView.center = mBackView.center;
        
        UIPanGestureRecognizer *pgr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
        pgr.delegate = self;
        [mFlagView addGestureRecognizer:pgr];
        
        self.miProgressIndex = 3;
    }
    return self;
}

- (void)OnLeftClick {
    if (self.miProgressIndex > 0) {
        self.miProgressIndex --;
    }
}

- (void)OnRightClick {
    if (self.miProgressIndex < 6) {
        self.miProgressIndex ++;
    }
}

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
//    CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
//    CGFloat panOffset = translation.x;
//    if (ABS(translation.x) > 0) {
//        CGFloat width = CGRectGetWidth(self.frame);
//        CGFloat offset = abs(translation.x);
//        panOffset = (offset * 0.55f * width) / (offset * 0.55f + width);
//        panOffset *= translation.x < 0 ? -1.0f : 1.0f;
//    }
//    CGPoint actualTranslation = CGPointMake(panOffset, translation.y);
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan && [panGestureRecognizer numberOfTouches] > 0) {
        mStartPoint = mFlagView.center;
        [self animateContentViewForPoint:translation];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged && [panGestureRecognizer numberOfTouches] > 0) {
        [self animateContentViewForPoint:translation];
    }
    else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        NSLog(@"UIGestureRecognizerStateEnded");
        [self ResetProgressIndex];
    }
}

- (void)animateContentViewForPoint:(CGPoint)point {
    float fXPos = mStartPoint.x+point.x;
    if (fXPos < mBackView.frame.origin.x) {
        fXPos = mBackView.frame.origin.x;
    }
    if (fXPos > mBackView.frame.origin.x+mBackView.frame.size.width) {
        fXPos = mBackView.frame.origin.x+mBackView.frame.size.width;
    }
    mFlagView.center = CGPointMake(fXPos, mBackView.center.y);
}

- (void)ResetProgressIndex {
    float fOffset = mFlagView.center.x-mBackView.frame.origin.x-5;
    float fWidth = 26;
    self.miProgressIndex = round(fOffset/fWidth);
}

- (void)setMiProgressIndex:(int)value {
    _miProgressIndex = value;
    float fWidth = 26;
    mFlagView.center = CGPointMake(fWidth*value+mBackView.frame.origin.x+5, mFlagView.center.y);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
