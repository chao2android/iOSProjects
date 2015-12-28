//
//  CircleProgressView.h
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CircleProgressView : UIView {
    CAShapeLayer *_trackLayer;
    UIBezierPath *_trackPath;
    CAShapeLayer *_progressLayer;
    UIBezierPath *_progressPath;
    NSTimer *timer;
}

@property (nonatomic) float progress;//0~1之间的数

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
