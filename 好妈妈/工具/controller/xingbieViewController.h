//
//  xingbieViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface xingbieViewController : UIViewController<UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate>{

  UIScrollView *_scrollView;
  
//  UITextField *tf1;
//  UITextField *tf2;
    UIButton * tf1;
    UIButton * tf2;
  UIButton *tuisuanBut;
  
  NSArray *_arr;
  
  UIImageView *xView;
  UILabel *xLab;
  
  UIButton *jgBut;
  UILabel *jgLab;
  UIImageView *jgView;
  UILabel *jgLabJg;
  
  UILabel *shuomingLab;
  
  UIImageView *bgView;
    BOOL xingbieBool;
    BOOL buttonTag;
    UIButton * woButton;
    UIButton * haoyouButton;
    NSDictionary * userDic;
    UIPickerView * myPickerView;
}

@end
