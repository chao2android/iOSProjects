//
//  ZhaopianView.h
//  好妈妈
//
//  Created by iHope on 13-10-27.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "EKStreamView.h"
#import "EGORefreshTableHeaderView.h"
@interface ZhaopianView : UIView<AnalysisClassDelegate,EKStreamViewDelegate,EGORefreshTableHeaderDelegate>

{
  
  NSMutableArray * _muArr;

  AnalysisClass * analysis;
  
  int page;
  
  UIButton *footlab;
  UIActivityIndicatorView *activityIndicator;
  BOOL isJiazai;
  
  EGORefreshTableHeaderView *RefreshHeaderView;
  
  BOOL isSuo;
  
}
-(void)loadData;

@property ( nonatomic ,retain)  EKStreamView *stream;
@property ( nonatomic,  retain) NSString  *targetid;

@end
