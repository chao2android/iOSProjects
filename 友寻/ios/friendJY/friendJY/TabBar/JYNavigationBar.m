//
//  JYNavigationBar.m
//  friendJY
//
//  Created by 高斌 on 15/2/28.
//  Copyright (c) 2015年 高斌. All rights reserved.
//

#import "JYNavigationBar.h"

@implementation JYNavigationBar

static CGFloat const kDefaultColorLayerOpacity = 1.0f;
static CGFloat const kSpaceToCoverStatusBars = 20.0f;

- (void)dealloc
{
    self.colorLayer = nil;
}

- (void)setBarTintColor:(UIColor *)barTintColor
{
    if (SYSTEM_VERSION >= 7.0) {
        [super setBarTintColor:barTintColor];
    } else {
        //do nothing
    }
    
    if (self.colorLayer == nil) {
        self.colorLayer = [CALayer layer];
        self.colorLayer.opacity = kDefaultColorLayerOpacity;
        [self.layer addSublayer:self.colorLayer];
    }
    
    self.colorLayer.backgroundColor = barTintColor.CGColor;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.colorLayer != nil) {
        self.colorLayer.frame = CGRectMake(0, 0 - kSpaceToCoverStatusBars, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) + kSpaceToCoverStatusBars);
        
        [self.layer insertSublayer:self.colorLayer atIndex:1];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
