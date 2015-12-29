//
//  RijiXiangqingViewController.h
//  好妈妈
//
//  Created by iHope on 13-10-23.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "AsyncImageView.h"
@class TishiView;
@interface RijiXiangqingViewController : UIViewController<AnalysisClassDelegate,UIAlertViewDelegate>
{
    AnalysisClass * analysis;
   
    UIScrollView * mainScrollView;
    TishiView * _tishiView;
    
}
@property (retain,nonatomic)NSMutableArray * viewArray;
@property (retain,nonatomic)NSMutableDictionary * oldDictionary;
@property (retain,nonatomic)NSMutableArray * dataArray;
@end
