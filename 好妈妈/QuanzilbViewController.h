//
//  QuanzilbViewController.h
//  好妈妈
//
//  Created by iHope on 13-10-15.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "AnalysisClass.h"
@class TishiView;
@interface QuanzilbViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,AnalysisClassDelegate>
{
    EGORefreshTableHeaderView * _refreshHeaderView;
    BOOL _reloading;
    BOOL SelectBool;
    AnalysisClass * analysis;
}
@property (retain,nonatomic) TishiView * tishiView;
@property (retain,nonatomic) UITableView * myTableView;
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@property (retain,nonatomic) NSMutableArray * dataArray;

@end
