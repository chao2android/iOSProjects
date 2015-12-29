//
//  TabbarView.m
//  FansEnd
//
//  Created by iHope on 13-10-12.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "TabbarView.h"
#define TabbarButtonTag 100

@implementation TabbarView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame withImageArray:(NSArray*)array
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.92 alpha:1.0];;

        grayView = [[UIView alloc]initWithFrame:self.bounds];
        grayView.backgroundColor = [UIColor clearColor];
        [self addSubview:grayView];
        [grayView release];
        
        redView = [[UIView alloc]initWithFrame:self.bounds];
        redView.backgroundColor = [UIColor clearColor];
        [self addSubview:redView];
        [redView release];
        
        upView = [[UIView alloc]initWithFrame:self.bounds];
        upView.backgroundColor = [UIColor clearColor];
        [self addSubview:upView];
        [upView release];
        
        int iWidth = frame.size.width/array.count;
        int iLeft = iWidth/2;
        for (int i = 0; i<array.count; i++) {
            //添加背景灰色小球
            UIImageView *grayimageView = [[UIImageView alloc]initWithFrame:CGRectMake(iLeft, 0,iWidth, 49)];
            grayimageView.backgroundColor = [UIColor clearColor];
            //grayimageView.image = [UIImage imageNamed:@"tabbar_gray"];
            [grayView addSubview:grayimageView];
            [grayimageView release];
            
            NSString *imagename = [NSString stringWithFormat:@"%@_gray",[array objectAtIndex:i]];
            NSString *imagename2 = [NSString stringWithFormat:@"%@_red",[array objectAtIndex:i]];
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(iLeft, 0, 55, 49);
            button.center = CGPointMake(iLeft, 49/2);
            button.backgroundColor = [UIColor clearColor];
            [button setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
            [button setImage:[UIImage imageNamed:imagename2]  forState:UIControlStateSelected];
            [button addTarget:self action:@selector(tabBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = TabbarButtonTag+i;
            [upView addSubview:button];

            iLeft += iWidth;
        }
        
        UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        lineView.image = [UIImage imageNamed:@"f_tabline"];
        [self addSubview:lineView];
        
        [self selectNumber:0];
    }
    return self;
}

- (void)selectNumber:(int)number {
    _miIndex = number;
    self.selectBtn = (UIButton*)[self viewWithTag:number+TabbarButtonTag];
    self.selectBtn.selected = YES;

    //添加背景红色小球
    imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.selectBtn.frame.origin.x+5, 0,self.selectBtn.frame.size.width-10, 45)];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"tabbar_red"];
    [redView addSubview:imageView];
    [imageView release];
}

- (void)setMiIndex:(int)index {
    _miIndex = index;
    UIButton *btn = (UIButton *)[upView viewWithTag:TabbarButtonTag+index];
    if (btn) {
        [self tabBtnAction:btn];
    }
}

- (void)tabBtnAction:(UIButton*)btn {
    
    int index = btn.tag-TabbarButtonTag;
    if (delegate && [delegate respondsToSelector:@selector(CanSelectTab::)]) {
        if (![delegate CanSelectTab:self :index]) {
            return;
        }
    }
    _miIndex = index;
    if (self.selectBtn.tag != btn.tag) {
        self.selectBtn.selected = NO;
        self.selectBtn = btn;
        self.selectBtn.selected = YES;
        [imageView.layer removeAllAnimations];
        
        //移动位置
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
        animation.fromValue = [NSValue valueWithCGPoint:imageView.layer.position];
        CGPoint toPoint = imageView.layer.position;
        toPoint.x = self.selectBtn.frame.origin.x+imageView.frame.size.width/2;
        animation.toValue = [NSValue valueWithCGPoint:toPoint];
        animation.removedOnCompletion = YES;
        
        //缩小
        CABasicAnimation *scaoleAnimation  = [CABasicAnimation animationWithKeyPath:@"transform.scale.y"];
        scaoleAnimation.duration = 0.2;
        scaoleAnimation.fromValue = [NSNumber numberWithFloat:1];
        scaoleAnimation.toValue = [NSNumber numberWithFloat:0.2];
        scaoleAnimation.autoreverses = YES;
        scaoleAnimation.removedOnCompletion = YES;
        
        CAAnimationGroup *group = [CAAnimationGroup animation];
        group.duration = 0.3;
        group.repeatCount = 1;
        group.delegate = self;
        /* 动画的开始与结束的快慢*/
        group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        group.animations = [NSArray arrayWithObjects:animation,scaoleAnimation, nil];
        group.removedOnCompletion = YES;
        
        [imageView.layer addAnimation:group forKey:@"move"];
        imageView.frame = CGRectMake(self.selectBtn.frame.origin.x+5, imageView.frame.origin.y, imageView.frame.size.width, imageView.frame.size.height);
        
        if (delegate && [delegate respondsToSelector:@selector(OnTabSelect:)]) {
            [delegate OnTabSelect:self];
        }
    }
}

@end
