//
//  CoolButton.m
//  TestRedCollar
//
//  Created by MC on 14-7-8.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "CoolButton.h"

@implementation CoolButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(23, (self.frame.size.height-18)/2, 50, 18);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, (self.frame.size.height-15)/2, 17, 15);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
