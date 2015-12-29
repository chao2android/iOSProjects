//
//  CommentBottom.m
//  TJLike
//
//  Created by MC on 15-4-2.
//  Copyright (c) 2015年 IPTV_MAC. All rights reserved.
//

#import "CommentBottom.h"
@interface CommentBottom ()
{
    
}
@end

@implementation CommentBottom
@synthesize mDelegate,onGoComment,OnSendClick;
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        UILabel *mlbLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 8, SCREEN_WIDTH-40-115*0.5, 28)];
        mlbLabel.userInteractionEnabled = YES;
        mlbLabel.textColor = [UIColor colorWithWhite:0.16 alpha:1];
        mlbLabel.backgroundColor = [UIColor whiteColor];
        mlbLabel.font = [UIFont systemFontOfSize:13];
        mlbLabel.layer.masksToBounds = YES;
        mlbLabel.layer.cornerRadius = 5;
        mlbLabel.text = @"  说两句，转一下";
        [self addSubview:mlbLabel];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame  =mlbLabel.bounds;
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self action:@selector(CommentClick) forControlEvents:UIControlEventTouchUpInside];
        [mlbLabel addSubview:btn];
        
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightBtn.frame = CGRectMake(SCREEN_WIDTH-10-115*0.5, 8,115*0.5 , 28);
        _rightBtn.backgroundColor = [UIColor clearColor];
        [_rightBtn setBackgroundImage:[UIImage imageNamed:@"news_bottom_15_@2x.png"] forState:UIControlStateNormal];
        [_rightBtn addTarget:self action:@selector(BtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _rightBtn.selected = NO;
        [self addSubview:_rightBtn];
        
        _commentNum = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 115*0.5, 28)];
        _commentNum.backgroundColor = [UIColor clearColor];
        _commentNum.textAlignment = NSTextAlignmentCenter;
        _commentNum.font = [UIFont systemFontOfSize:13];
        _commentNum.textColor = [UIColor blueColor];
        [_rightBtn addSubview:_commentNum];
        
        _showContent = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 115*0.5, 28)];
        _showContent.backgroundColor = [UIColor clearColor];
        _showContent.textAlignment = NSTextAlignmentCenter;
        _showContent.font = [UIFont systemFontOfSize:13];
        _showContent.textColor = [UIColor blueColor];
        _showContent.text = @"原文";
        _showContent.hidden = YES;
        [_rightBtn addSubview:_showContent];
        
    }
    return self;
}
- (void)setComment:(int)num{
    _commentNum.text = [NSString stringWithFormat:@"%d评",num];
}

- (void)BtnClick:(UIButton *)sender{
    SafePerformSelector([mDelegate performSelector:onGoComment withObject:sender]);
    
}
- (void)CommentClick{
    SafePerformSelector([mDelegate performSelector:OnSendClick]);
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
