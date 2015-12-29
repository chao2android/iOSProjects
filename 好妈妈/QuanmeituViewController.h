//
//  QuanmeituViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-27.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "TishiView.h"

#import "EKStreamView.h"
#import "EGORefreshTableHeaderView.h"


@interface QuanmeituViewController : UIViewController<AnalysisClassDelegate ,EKStreamViewDelegate,EGORefreshTableHeaderDelegate>
{
  NSMutableArray *_muArr;
  AnalysisClass * analysis;
  TishiView *_tsView;
  
  NSMutableArray *randomHeights;
  
  int page;
  
  UIButton *footlab;
  UIActivityIndicatorView *activityIndicator;
  BOOL isJiazai;

  EGORefreshTableHeaderView *RefreshHeaderView;

}
@property ( nonatomic ,retain)  EKStreamView *stream;

@property (nonatomic,retain) NSString *cid;
@end

