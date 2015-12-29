//
//  ZhidaoCell.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-27.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "ZhidaoCell.h"

@implementation ZhidaoCell
@synthesize reuseIdentifier;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      CGRect bgFrame = CGRectInset(self.bounds, 0.0f, 0.0f);
      
      
      _picView_ = [[AsyncImageView alloc] initWithFrame:bgFrame];
      [self addSubview: _picView_];
      _picView_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      [_picView_ release];
      
      _suoIV = [UIButton buttonWithType:UIButtonTypeCustom];
      _suoIV.frame = CGRectMake((Screen_Width - 20)/2-20, 0, 20, 20);
      [_suoIV setImage:[UIImage imageNamed:@"lock_1.png"] forState:UIControlStateNormal];
      [self addSubview:_suoIV];
      [_suoIV release];

      
      
      _timeLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (Screen_Width - 20)/2, 20)];
      if (ISIPAD) {
        _timeLab.frame =CGRectMake(0, 0, (Screen_Width - 20)/2, 50);
      }
      _timeLab.backgroundColor = [UIColor blackColor];
      _timeLab.textColor = [UIColor whiteColor];
      _timeLab.textAlignment = 1;
      _timeLab.alpha = 0.5f;
      if (ISIPAD) {
        _timeLab.font = [UIFont systemFontOfSize:23];

      }else{
        _timeLab.font = [UIFont systemFontOfSize:13];

      }
      _timeLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
      [self addSubview:_timeLab];
      [_timeLab release];
      
    }
    return self;
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
