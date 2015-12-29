//
//  QuanZiChengYuan_ViewController.h
//  好妈妈
//
//  Created by liuguozhu on 17/9/13.
//  Copyright (c) 2013 1510Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "AnalysisClass.h"
#import "TishiView.h"
@interface QuanZiChengYuan_ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AnalysisClassDelegate,UIAlertViewDelegate>
{
    int guanzhuNum;
    int page;
    PullingRefreshTableView *_uitable;
    UIButton* memberSort;
    BOOL isSort;
    AnalysisClass * analysis;
}
@property (retain,nonatomic) TishiView * tishiView;
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@property (retain,nonatomic) NSMutableArray * dataArray;
@property (retain,nonatomic) NSMutableDictionary * dataDictionary;
@end
