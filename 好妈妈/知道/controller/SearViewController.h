//
//  SearViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-20.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ss)
-(void)removeAllSubviewss;

@end

@implementation UIView (ss)

-(void)removeAllSubviewss{
  for (id cc in [self subviews]) {
    [cc removeFromSuperview];
  }
}
@end

#import "AnalysisClass.h"
#import "PullingRefreshTableView.h"
#import "TishiView.h"
#import "MBProgressHUD.h"

@interface SearViewController : UIViewController
<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,AnalysisClassDelegate,UITextFieldDelegate>
{
  MBProgressHUD *myHUD;
  
  int page;
  PullingRefreshTableView *_uitable;
  UISearchBar *search;
  UITextField * _myTextView;
  
  UIButton *removeBut;
  
  NSMutableArray *_muArr;
  
  AnalysisClass * analysis;
    UIImageView *typeBgView;

}

@property(nonatomic ,retain) NSString *sam_type;

@end
