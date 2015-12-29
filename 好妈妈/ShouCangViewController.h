//
//  ShouCangViewController.h
//  好妈妈
//
//  Created by iHope on 13-10-15.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TishiView;
#import "AnalysisClass.h"
#import "PullingRefreshTableView.h"
@interface ShouCangViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AnalysisClassDelegate>
{
    int page;
    PullingRefreshTableView *_uitable;
    AnalysisClass * analysis;
}
@property (retain,nonatomic) NSMutableArray * dataArray;
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@property (retain,nonatomic) TishiView * tishiView;

@end
