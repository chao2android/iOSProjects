//
//  jinghuaCell.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-24.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "jinghuaCell.h"
#import <QuartzCore/QuartzCore.h>


@implementation jinghuaCell
@synthesize reuseIdentifier ,picView_;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      CGRect bgFrame = CGRectInset(self.bounds, 0.0f, 0.0f);
    
      picView_ = [[AsyncImageView alloc] initWithFrame:bgFrame];
      [self addSubview: picView_];
      picView_.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      [picView_ release];
      
      if (ISIPAD) {
//        _ipadLab = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, (Screen_Width-20)/2, 40)];
//        
//        _ipadLab.backgroundColor = [UIColor blackColor];
//        _ipadLab.textColor = [UIColor whiteColor];
//        _ipadLab.textAlignment = 1;
//        _ipadLab.alpha = 0.5f;
//        _ipadLab.font = [UIFont systemFontOfSize:26];
//        
//        
//        _ipadLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
//        
//        [self addSubview:_ipadLab];
//        [_ipadLab release];

      }
      
      
      _clickBut = [UIButton buttonWithType:UIButtonTypeCustom];
      _clickBut.frame = bgFrame;
      [self addSubview:_clickBut];
      _clickBut.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
      
      
      
      
    }
    return self;
}

-(void)remImageTextLab:(NSString *)text{
  
  if (_tLab) {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    [_tLab removeFromSuperview];
    _tLab = nil;
    [pool release];
  }
//  int height = [ImageTextLabel HeightOfContent:text :CGSizeMake(152, 100)];

    if (ISIPAD) {
        _tLab = [[ImageTextLabel alloc]initWithFrame:CGRectMake(0,self.frame.size.height -17*1.4, 152*1.4, 15*1.4)];
    }else{
        _tLab = [[ImageTextLabel alloc]initWithFrame:CGRectMake(0,self.frame.size.height -17, 152, 15)];
    
    }
//    _tLab.hangshu = YES;
  _tLab.backgroundColor = [UIColor blackColor];
  _tLab.textColor = [UIColor whiteColor];
  //      _tLab.textAlignment = 1;
  _tLab.alpha = 0.5f;
  _tLab.m_EmoWidth = 15;
  _tLab.m_EmoHeight = 15;
  _tLab.hangshu=YES;
  _tLab.m_Font = [UIFont systemFontOfSize:13];
  _tLab.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;

  [self addSubview:_tLab];
  [_tLab release];
  
  

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
