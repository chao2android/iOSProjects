//
//  MineCateButton.m
//  TJLike
//
//  Created by MC on 15/4/12.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "MineCateButton.h"

@implementation MineCateButton


- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return CGRectMake(50, 12, 19, 19);
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    return CGRectMake(80, 12, 45, 19);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
