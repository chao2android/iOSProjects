//
//  NavTabBar.m
//  好妈妈
//
//  Created by Hepburn Alex on 14-5-16.
//  Copyright (c) 2014年 iHope. All rights reserved.
//

#import "NavTabBar.h"

@implementation NavTabBar

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _miIndex = 0;
        int iWidth = frame.size.width/2;
        for (int i = 0; i < 2; i ++) {
            NSString *imagename = [NSString stringWithFormat:@"navtab%02d.png", i+1];
            NSString *imagename1 = [NSString stringWithFormat:@"navtab%02d-1.png", i+1];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(iWidth*i, 0, iWidth, frame.size.height);
            btn.tag = i+1000;
            [btn setBackgroundImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:imagename1] forState:UIControlStateSelected];
            [btn addTarget:self action:@selector(OnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            if (i == 0) {
                mSelectBtn = btn;
            }
        }
        [mSelectBtn setSelected:YES];
    }
    return self;
}

- (void)OnButtonClick:(UIButton *)sender {
    self.miIndex = sender.tag-1000;
    mSelectBtn.selected = NO;
    mSelectBtn = sender;
    mSelectBtn.selected = YES;
    if (delegate && [delegate respondsToSelector:@selector(OnNavTabSelect:)]) {
        [delegate OnNavTabSelect:self];
    }
}

- (void)setMiIndex:(int)value {
    _miIndex = value;
    UIButton *btn = (UIButton *)[self viewWithTag:1000+value];
    mSelectBtn.selected = NO;
    mSelectBtn = btn;
    mSelectBtn.selected = YES;
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
