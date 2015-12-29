//
//  gdFenleiViewController.h
//  好妈妈
//
//  Created by liuguozhu on 13-10-20.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"

#import "MBProgressHUD.h"

@interface gdFenleiViewController : UIViewController
<AnalysisClassDelegate>
{
  AnalysisClass * analysis;

  MBProgressHUD *myHUD;
}
@property(nonatomic ,retain)NSDictionary *_muDic;
@property (nonatomic,retain )NSString *dtype;

@end
