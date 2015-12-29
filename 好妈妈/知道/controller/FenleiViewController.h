//
//  FenleiViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-10.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fenleiCell.h"
#import "AnalysisClass.h"
#import "MBProgressHUD.h"
@interface FenleiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate ,AnalysisClassDelegate>
{
  UITableView *_uitable;
  NSMutableArray *_muArr;
    AnalysisClass * analysis;
  MBProgressHUD *myHUD;
    NSArray *arr1;
}
@property (nonatomic ,assign)UINavigationController *nav;

@end
