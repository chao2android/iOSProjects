//
//  JinghuaViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-10.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "TishiView.h"

#import "EKStreamView.h"
#import "EGORefreshTableHeaderView.h"

#import "MBProgressHUD.h"


@interface JinghuaViewController : UIViewController<AnalysisClassDelegate ,EKStreamViewDelegate,EGORefreshTableHeaderDelegate>
{
  NSMutableArray *_muArr;
    AnalysisClass * analysis;
  MBProgressHUD *myHUD;
  NSMutableArray *randomHeights;
  
  int page;
  
  EGORefreshTableHeaderView *RefreshHeaderView;

  UIButton *footlab;
  UIActivityIndicatorView *activityIndicator;
  BOOL isJiazai;


}
@property (nonatomic ,assign)UINavigationController *nav;
@property ( nonatomic ,retain)  EKStreamView *stream;

@end
