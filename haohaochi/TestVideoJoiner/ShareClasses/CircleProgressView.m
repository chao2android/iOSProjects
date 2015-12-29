//
//  CircleProgressView.m
//  TestVideoJoiner
//
//  Created by Hepburn Alex on 14-11-12.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CircleProgressView.h"

#define degreesToRadians(x) (M_PI*(x)/180.0) //把角度转换成PI的方式
#define PROGRESS_LINE_WIDTH 10 //弧线的宽度

@implementation CircleProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        float fWidth = MIN(frame.size.width, frame.size.height);
        self.backgroundColor = [UIColor yellowColor];
        
        _trackLayer = [CAShapeLayer layer];//创建一个track shape layer
        _trackLayer.frame = self.bounds;
        [self.layer addSublayer:_trackLayer];
        _trackLayer.fillColor = [[UIColor clearColor] CGColor];
        _trackLayer.strokeColor = [[UIColor grayColor] CGColor];//指定path的渲染颜色
        _trackLayer.opacity = 0.25; //背景同学你就甘心做背景吧，不要太明显了，透明度小一点
        _trackLayer.lineCap = kCALineCapSquare;//指定线的边缘是方的
        _trackLayer.lineWidth = PROGRESS_LINE_WIDTH;//线的宽度
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width/2, frame.size.height/2) radius:(fWidth-PROGRESS_LINE_WIDTH)/2 startAngle:degreesToRadians(-90) endAngle:degreesToRadians(270) clockwise:YES];//上面说明过了用来构建圆形
        _trackLayer.path =[path CGPath]; //把path传递給layer，然后layer会处理相应的渲染，整个逻辑和CoreGraph是一致的。
        
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor =  [[UIColor clearColor] CGColor];
        _progressLayer.strokeColor  = [[UIColor grayColor] CGColor];
        _progressLayer.lineCap = kCALineCapSquare;
        _progressLayer.lineWidth = PROGRESS_LINE_WIDTH;
        _progressLayer.path = [path CGPath];
        _progressLayer.strokeEnd = 0;
        
        CALayer *gradientLayer = [CALayer layer];
        CAGradientLayer *gradientLayer1 =  [CAGradientLayer layer];
        gradientLayer1.frame = _progressLayer.bounds;
        [gradientLayer1 setColors:[NSArray arrayWithObjects:(id)[[UIColor greenColor] CGColor],(id)[UIColor blueColor].CGColor, nil]];
        //[gradientLayer1 setLocations:@[@0.5, @0.9, @1]];
        [gradientLayer1 setStartPoint:CGPointMake(0.5, 0)];
        [gradientLayer1 setEndPoint:CGPointMake(0, 1)];
        [gradientLayer addSublayer:gradientLayer1];

        [gradientLayer setMask:_progressLayer]; //用progressLayer来截取渐变层
        [self.layer addSublayer:gradientLayer];
    }
    return self;
}

-(void)setProgress:(float)value animated:(BOOL)animated
{
    //_progressLayer.strokeEnd = value;
    _progress = value;
    [self AnimateProgress];
}

- (void)AnimateProgress {
    NSLog(@"AnimateProgress");
    timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(OnTimeCheck) userInfo:nil repeats:YES];
}

- (void)OnTimeCheck {
    static float fTime = 0.0;
    
    _progressLayer.strokeEnd = fTime;
    fTime += 0.05;
    NSLog(@"OnTimeCheck:%f, %f", fTime, _progress);
    if (fTime >= _progress) {
        [timer invalidate];
    }
}

@end
