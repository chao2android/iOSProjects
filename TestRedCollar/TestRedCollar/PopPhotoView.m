//
//  PopPhotoView.m
//  TestRedCollar
//
//  Created by Hepburn Alex on 14-5-6.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "PopPhotoView.h"

@implementation PopPhotoView

@synthesize delegate, OnPopSelect;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        backBtn.frame = self.bounds;
        backBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        [backBtn addTarget:self action:@selector(removeFromSuperview) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:backBtn];
        
        int iTop = IOS_7?55:35;
        
        UIImageView *popView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-90, iTop, 80, 80)];
        popView.image = [UIImage imageNamed:@"3.png"];
        popView.userInteractionEnabled = YES;
        [self addSubview:popView];
        
        for (int i = 0; i < 2; i ++) {
            NSString *imagename = (i == 0)?@"f_btnphoto":@"f_btnqrscan";
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(7, 6+35*i, 66, 35);
            btn.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
            btn.tag = i+1200;
            [btn setImage:[UIImage imageNamed:imagename] forState:UIControlStateNormal];
            [btn addTarget:self action:@selector(OnBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [popView addSubview:btn];
        }
    }
    return self;
}

- (void)OnBtnClick:(UIButton *)sender {
    int index = sender.tag-1200;
    if (delegate && OnPopSelect) {
        [delegate performSelector:OnPopSelect withObject:[NSNumber numberWithInt:index]];
    }
    [self removeFromSuperview];
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
