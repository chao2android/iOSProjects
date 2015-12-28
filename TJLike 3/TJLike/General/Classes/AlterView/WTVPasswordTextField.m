//
//  WTVPasswordTextField.m
//  WiseTV
//
//  Created by DongRanRan on 15/3/30.
//  Copyright (c) 2015年 tjgdMobilez. All rights reserved.
//

#import "WTVPasswordTextField.h"

@implementation WTVPasswordTextField

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController)
    {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
