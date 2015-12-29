//
//  detailsViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-17.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "TishiView.h"
#import "PullingRefreshTableView.h"
#import "MBProgressHUD.h"

@interface detailsViewController : UIViewController<AnalysisClassDelegate ,UITableViewDataSource,UITableViewDelegate>
{
  int page;
  PullingRefreshTableView *_uitable;

  AnalysisClass * analysis;
  MBProgressHUD *myHUD;
  NSMutableArray *_muArr;
}
@property (nonatomic,retain)NSString *type;
@property (nonatomic ,retain)NSString *subType;
@property (retain,nonatomic)NSString * key;
@end
