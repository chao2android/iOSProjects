//
//  ShowChoiceView.m
//  TestVideoJoiner
//
//  Created by MC on 14-12-4.
//  Copyright (c) 2014年 Hepburn Alex. All rights reserved.
//

#import "ShowChoiceView.h"

@implementation ShowChoiceView

@synthesize delegate,OnChoose;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        
        float fScale = KscreenWidth/320;
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.backgroundColor = [UIColor clearColor];
        btn.frame = self.bounds;
        [btn addTarget:self action:@selector(AnimateHide) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        
        UIImageView *botView = [[UIImageView alloc]initWithFrame:CGRectMake(0, KscreenHeigh - 174, KscreenWidth, 174)];
        botView.image = [UIImage imageNamed:@"p_havegoback"];
        botView.userInteractionEnabled = YES;
        [self addSubview:botView];
        
        mBotView = botView;
        
        UIImageView *flagView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 15, 15)];
        flagView.image = [UIImage imageNamed:@"f_havego"];
        flagView.userInteractionEnabled = YES;
        [botView addSubview:flagView];
        
        UILabel *lbText = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, botView.frame.size.width, 30)];
        lbText.text = @"觉得这里好吃嘛？";
        lbText.textColor = [UIColor grayColor];
        lbText.textAlignment =NSTextAlignmentCenter;
        lbText.backgroundColor = [UIColor clearColor];
        lbText.font = [UIFont systemFontOfSize:22];
        [botView addSubview:lbText];
        
        UIButton *mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mBtn.frame = CGRectMake((KscreenWidth/4-46)*fScale, 60, 93*fScale, 93*fScale);
        [mBtn setBackgroundImage:[UIImage imageNamed:@"f_wantgono"] forState:UIControlStateNormal];
        [mBtn addTarget:self action:@selector(YesOrNo:) forControlEvents:UIControlEventTouchUpInside];
        mBtn.tag = 100;
        [botView addSubview:mBtn];
        
        mBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        mBtn.frame = CGRectMake(KscreenWidth - (KscreenWidth/4 + 46)*fScale, 60, 93, 93);
        [mBtn setBackgroundImage:[UIImage imageNamed:@"f_wantgoyes"] forState:UIControlStateNormal];
        [mBtn addTarget:self action:@selector(YesOrNo:) forControlEvents:UIControlEventTouchUpInside];
        mBtn.tag = 101;
        [botView addSubview:mBtn];
        
        botView.center = CGPointMake(KscreenWidth/2, KscreenHeigh+174/2);
        [UIView animateWithDuration:0.3 animations:^{
            botView.center = CGPointMake(KscreenWidth/2, KscreenHeigh - 174/2);
        }];
    }
    return self;
}
- (void)YesOrNo:(UIButton *)sender{
    [self AnimateHide];
    self.miIndex = (int)sender.tag-100;
    if (delegate && OnChoose){
        SafePerformSelector([delegate performSelector:OnChoose withObject:self]);
    }
}
- (void)AnimateHide {
    [UIView animateWithDuration:0.3 animations:^{
        mBotView.center = CGPointMake(KscreenWidth/2, KscreenHeigh+174/2);
    } completion:^(BOOL bFinish) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
