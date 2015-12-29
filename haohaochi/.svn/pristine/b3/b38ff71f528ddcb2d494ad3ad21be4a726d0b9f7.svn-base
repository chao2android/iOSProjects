//
//  ReportActionView.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-11.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ReportActionView.h"

@implementation ReportActionView

@synthesize delegate,OnChoose;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = self.bounds;
        [btn addTarget:self action:@selector(AnimateHide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UIImageView *bView = [[UIImageView alloc]initWithFrame:CGRectMake(0, KscreenHeigh - 116, KscreenWidth, 116)];
        bView.userInteractionEnabled = YES;
        bView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.90];
        [self addSubview:bView];
        
        UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mBtn.frame = CGRectMake(0, 0, KscreenWidth, 58);
        [mBtn setTitle:@"黄赌毒！我要举报！" forState:UIControlStateNormal];
        [mBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        mBtn.backgroundColor = [UIColor clearColor];
        [mBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        mBtn.tag = 100;
        [bView addSubview:mBtn];
        
        UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 57.5, KscreenWidth, 1)];
        lineView.backgroundColor = [UIColor colorWithWhite:0.90 alpha:1];
        [bView addSubview:lineView];
        
        mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mBtn.frame = CGRectMake(0, 58, KscreenWidth, 58);
        [mBtn setTitle:@"算了" forState:UIControlStateNormal];
        [mBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        mBtn.backgroundColor = [UIColor clearColor];
        [mBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        mBtn.tag = 101;
        [bView addSubview:mBtn];
    }
    return self;
}
- (void)BtnClick:(UIButton *)sender{
    [self AnimateHide];
    NSNumber *ye = [NSNumber numberWithBool:(sender.tag-100)];
    NSDictionary *dict = [[NSDictionary alloc]initWithObjects:@[[NSNumber numberWithInt:self.tag],ye] forKeys:@[@"celltag",@"btntag"]];
    if (delegate && OnChoose){
        [delegate performSelector:OnChoose withObject:dict];
    }
}
- (void)AnimateHide {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelay:0];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(DidAnimateHideEnd)];
    self.alpha = 0.0;
    [UIView commitAnimations];
}
- (void)DidAnimateHideEnd {
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
