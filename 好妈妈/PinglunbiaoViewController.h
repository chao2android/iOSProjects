//
//  PinglunbiaoViewController.h
//  好妈妈
//
//  Created by iHope on 13-10-30.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "PullingRefreshTableView.h"
#import "TishiView.h"
@interface PinglunbiaoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AnalysisClassDelegate>
{
    int page;
    PullingRefreshTableView *_uitable;
    AnalysisClass * analysis;
    TishiView * tishiView;
}
@property (retain,nonatomic)NSMutableArray * dataArray;
@property (retain,nonatomic)NSMutableDictionary * oldDictionary;
@end
