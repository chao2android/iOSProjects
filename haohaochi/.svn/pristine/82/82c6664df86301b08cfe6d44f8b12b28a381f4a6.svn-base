//
//  AnimateButton.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-12-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton(AnimateButton)

@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) SEL OnScaleFinish;
@property (nonatomic, assign) SEL OnImageFinish;

- (void)AddAnimates:(NSArray *)images :(float)duration;
- (void)StartScaleAnimate;
- (void)StartImageAnimate;
- (void)StartShakeAnimate;
- (void)StopShakeAnimate;

@end
