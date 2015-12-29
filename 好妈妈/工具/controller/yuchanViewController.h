//
//  yuchanViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yuchanViewController : UIViewController

{
  UITextField *tf1;
  UITextField *tf2;
  UIButton *tuisuanBut;
  
  UILabel *dataLab;
  UIDatePicker * dataPicker;
  
  UIView *dataBgView;
  
  UIImageView *bgView;
  
  UIButton *jgBut;
  UILabel *jgLab;
  
  UIScrollView * _scrollView;
  
}
@property (nonatomic ,retain)  NSDate *olddate;


@end
