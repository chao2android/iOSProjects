//
//  QuanZiViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AnalysisClass.h"
#import "PullingRefreshTableView.h"
#import "TishiView.h"
@interface QuanZiViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AnalysisClassDelegate>
{
    int page;
    PullingRefreshTableView *_uitable;
    AnalysisClass * analysis;
}
@property (retain,nonatomic)TishiView * tishiView;
@property (retain,nonatomic)NSMutableArray * dataArray;
@end
