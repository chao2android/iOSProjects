//
//  TuijianViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-10.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "tuijianCell.h"
#import "AnalysisClass.h"
#import "TishiView.h"

#import "PullingRefreshTableView.h"

#import "MBProgressHUD.h"

@interface TuijianViewController : UIViewController<UITableViewDataSource,UITableViewDelegate ,tuijianCellDelegate,AnalysisClassDelegate>
{
  PullingRefreshTableView *_uitable;

    AnalysisClass * analysis;

  NSMutableArray *_muArr;
  
  MBProgressHUD *myHUD;
  int page;
}

@property (nonatomic ,assign)UINavigationController *nav;

@end
