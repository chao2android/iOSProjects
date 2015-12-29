//
//  SelectTabBar.m
//  TestRedCollar
//
//  Created by iHope on 14-1-23.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import "SelectTabBar.h"

@implementation SelectTabBar

@synthesize miIndex, delegate, OnForumTabSelect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        miIndex = 0;
        self.userInteractionEnabled = YES;
        self.image = [UIImage imageNamed:@"22底"];

        NSArray *array = [NSArray arrayWithObjects:@"23", @"24", @"25", @"26", nil];
        int width = self.frame.size.width/array.count;
        int x = 0;
        for (int i = 0; i<array.count; i++) {
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(x, (self.frame.size.height-50)/2, width, 50);
            button.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin;
            button.backgroundColor = [UIColor clearColor];
            
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@",[array objectAtIndex:i]]] forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@_2",[array objectAtIndex:i]]]  forState:UIControlStateSelected];
            [button addTarget:self action:@selector(OnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            
            button.tag = i+1500;
            [self addSubview:button];
            
            x += width;
        }
        
        [self RefreshView];
    }
    return self;
}

- (void)OnBtnClick:(UIButton *)sender {
    int index = sender.tag-1500;
    if (delegate && [delegate respondsToSelector:@selector(CanSelectTab::)]) {
        if (![delegate CanSelectTab:self :index]) {
            return;
        }
    }
    self.miIndex = index;
 
    if (delegate && [delegate respondsToSelector:@selector(OnTabSelect:)]) {
        [delegate OnTabSelect:self];
    }
}

- (void)RefreshView {
    for (int i = 0; i < 4; i ++) {
        UIButton *button = (UIButton *)[self viewWithTag:i+1500];
        if (button) {
            button.selected = (i == miIndex);
        }
    }
}

- (void)setMiIndex:(int)index {
    miIndex = index;
    [self RefreshView];
}

@end
