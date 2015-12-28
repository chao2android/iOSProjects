//
//  AnimateButton.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "AnimateButton.h"
#import <objc/runtime.h>

static int g_index = 0;
static int g_bStopShake = YES;
static const void * g_delegate = &g_delegate;
static const void * g_OnScaleFinish = &g_OnScaleFinish;
static const void * g_OnImageFinish = &g_OnImageFinish;

@implementation UIButton(AnimateButton)

@dynamic delegate, OnImageFinish, OnScaleFinish;

- (id)delegate {
    return objc_getAssociatedObject(self, g_delegate);
}

- (void)setDelegate:(id)value {
    objc_setAssociatedObject(self, g_delegate, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SEL)OnImageFinish {
    SEL action;
    NSValue *value = objc_getAssociatedObject(self, g_OnImageFinish);
    [value getValue:&action];
    return action;
}

- (void)setOnImageFinish:(SEL)action {
    NSValue *value = [NSValue value:&action withObjCType:@encode(SEL)];
    objc_setAssociatedObject(self, g_OnImageFinish, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (SEL)OnScaleFinish {
    SEL action;
    NSValue *value = objc_getAssociatedObject(self, g_OnScaleFinish);
    [value getValue:&action];
    return action;
}

- (void)setOnScaleFinish:(SEL)action {
    NSValue *value = [NSValue value:&action withObjCType:@encode(SEL)];
    objc_setAssociatedObject(self, g_OnScaleFinish, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)AddAnimates:(NSArray *)images :(float)duration {
    UIImageView *imageView = (UIImageView *)[self viewWithTag:1000];
    @autoreleasepool {
        if (imageView) {
            [imageView removeFromSuperview];
        }
    }
    imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    imageView.tag = 1000;
    imageView.animationImages = images;
    imageView.animationDuration = duration;
    imageView.animationRepeatCount = 1;
    [self addSubview:imageView];
}

- (void)StartScaleAnimate {
    NSLog(@"StartScaleAnimate");
    self.transform = CGAffineTransformMakeScale(0.7, 0.7);
    [UIView animateWithDuration:0.2 animations:^{
        self.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL bFinish) {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL bFinish) {
            NSLog(@"StartScaleAnimate Finish");
            if (self.delegate && self.OnScaleFinish) {
                SafePerformSelector([self.delegate performSelector:self.OnScaleFinish withObject:self]);
            }
        }];
    }];
}

- (void)StopShakeAnimate {
    NSLog(@"StopShakeAnimate:%d", g_index);
    g_bStopShake = YES;
    g_index = 0;
    
    [self.layer removeAllAnimations];
}

- (void)StartShakeAnimate {
    g_bStopShake = NO;
    [self OnShakeAnimate];
}

- (void)OnShakeAnimate {
    CABasicAnimation* rotation1 = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    if (g_index == 0) {
        rotation1.toValue = [NSNumber numberWithFloat: M_PI/12];
    }
    else {
        rotation1.toValue = [NSNumber numberWithFloat: -M_PI/12];
    }
    rotation1.duration = 0.03;
    rotation1.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotation1.cumulative = YES;
    rotation1.fillMode = kCAFillModeForwards;
    rotation1.removedOnCompletion = YES;
    rotation1.repeatCount = 1;
    rotation1.autoreverses = YES;
    rotation1.delegate = self;
    
    [self.layer addAnimation:rotation1 forKey:@"ShakeAnimate"];
    
    g_index = (g_index+1)%2;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if (!g_bStopShake) {
        [self OnShakeAnimate];
    }
}

- (void)StartImageAnimate {
    NSLog(@"StartImageAnimate");
    UIImageView *imageView = (UIImageView *)[self viewWithTag:1000];
    if (imageView) {
        [imageView startAnimating];
        [self performSelector:@selector(DelayShowNextImage) withObject:nil afterDelay:imageView.animationDuration];
    }
}

- (void)DelayShowNextImage {
    NSLog(@"StartImageAnimate End");
    if (self.delegate && self.OnImageFinish) {
        SafePerformSelector([self.delegate performSelector:self.OnImageFinish withObject:self]);
    }
}

@end
