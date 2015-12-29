//
//  fenleiCell.m
//  好妈妈
//
//  Created by liuguozhu on 13-10-15.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import "fenleiCell.h"

@implementation fenleiCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
      
        
      UIImageView *xinIV = [[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 20, 20)];
      xinIV.image = [UIImage imageNamed:@"001_39.png"];
      [self addSubview:xinIV];
      [xinIV release];
      
      
      _lab = [[UILabel alloc]initWithFrame:CGRectMake(43, 5, 200, 20)];
      _lab.backgroundColor = [UIColor clearColor];
      _lab.textColor = [UIColor colorWithRed:223/255.0f green:47/255.0f blue:66/255.0f alpha:1];
      _lab.font = [UIFont systemFontOfSize:13];
      [self addSubview:_lab];
      [_lab release];
      
      
      UIImageView * bgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 34, 300, 122)];
      bgView.image = [UIImage imageNamed:@"001_40.png"];
      [self addSubview:bgView ];
      [bgView release];
      
      _but1 = [UIButton buttonWithType:UIButtonTypeCustom];
      _but1.frame = CGRectMake(10, 34, 144, 39) ;
      [_but1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
      [self addSubview:_but1];
      
      _but2 = [UIButton buttonWithType:UIButtonTypeCustom];
      _but2.frame = CGRectMake(156, 34, 144, 39) ;
      [_but2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
      [self addSubview:_but2];
      
      _but3 = [UIButton buttonWithType:UIButtonTypeCustom];
      _but3.frame = CGRectMake(10, 75, 144, 39) ;
      [_but3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
      [self addSubview:_but3];
      
      _but4 = [UIButton buttonWithType:UIButtonTypeCustom];
      _but4.frame = CGRectMake(156, 75, 144, 39) ;
      [_but4 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
      [self addSubview:_but4];
      
      _but5 = [UIButton buttonWithType:UIButtonTypeCustom];
      _but5.frame = CGRectMake(10, 117, 144, 39) ;
      [_but5 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
      [self addSubview:_but5];
      _gdBut = [UIButton buttonWithType:UIButtonTypeCustom];
      _gdBut.frame = CGRectMake(156, 117, 144, 39) ;
      [_gdBut setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
      [_gdBut setTitle:@"更多" forState:UIControlStateNormal];
      [self addSubview:_gdBut];
      
      _but1.titleLabel.font = [UIFont systemFontOfSize:15];
      _but2.titleLabel.font = [UIFont systemFontOfSize:15];
      _but3.titleLabel.font = [UIFont systemFontOfSize:15];
      _but4.titleLabel.font = [UIFont systemFontOfSize:15];
      _but5.titleLabel.font = [UIFont systemFontOfSize:15];
      _gdBut.titleLabel.font = [UIFont systemFontOfSize:15];
      

      
      if (ISIPAD) {
//        xinIV.frame = CGRectMake(20, 15, 50, 50);
//        _lab.frame = CGRectMake(90, 15, Screen_Width - 200, 50);
//        _lab.font = [UIFont systemFontOfSize:40];
//        
//        
//        bgView.frame = CGRectMake(20, 80, Screen_Width - 40, 300);
//        
//        _but1.frame = CGRectMake(20, 80, 350, 100) ;
//        _but2.frame = CGRectMake(380, 80, 350, 100) ;
//        _but3.frame = CGRectMake(20, 180, 350, 100) ;
//        _but4.frame = CGRectMake(380, 180, 350, 100) ;
//        _but5.frame = CGRectMake(20, 280, 350, 100) ;
//        _gdBut.frame = CGRectMake(380, 280, 350, 100) ;
//        
//        _but1.titleLabel.font = [UIFont systemFontOfSize:32];
//        _but2.titleLabel.font = [UIFont systemFontOfSize:32];
//        _but3.titleLabel.font = [UIFont systemFontOfSize:32];
//        _but4.titleLabel.font = [UIFont systemFontOfSize:32];
//        _but5.titleLabel.font = [UIFont systemFontOfSize:32];
//        _gdBut.titleLabel.font = [UIFont systemFontOfSize:32];



      }
      
      
      


        // Initialization code
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
