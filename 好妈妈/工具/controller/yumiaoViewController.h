//
//  yumiaoViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-14.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface yumiaoViewController : UIViewController
<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>
{
  UITableView *_uitable;
  
  UIView *dataBgView;
  UILabel *dataLab;
  UIView *bgL;
  
  NSMutableArray *_timeArr;
  NSMutableArray *_ageArr;
  NSMutableArray *_zlArr;
  NSMutableArray *_smArr;
    UIButton * tixingbutton;
}

@end
