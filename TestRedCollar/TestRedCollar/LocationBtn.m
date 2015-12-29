//
//  LocationBtn.m
//  TestRedCollar
//
//  Created by MC on 14-8-5.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "LocationBtn.h"

@implementation LocationBtn

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    
    return CGRectMake(0, 2, 16, 16);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(20, 0, 120, 20);
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
