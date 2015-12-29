//
//  HtqbViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-30.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PullingRefreshTableView.h"
#import "AnalysisClass.h"
@class TishiView;
@interface HtqbViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AnalysisClassDelegate>
{
    int page;
    PullingRefreshTableView *_uitable;
    AnalysisClass * analysis;
    TishiView * tishiView;
    int selNum;
    UIButton* rightBut;
}
@property (retain,nonatomic)NSMutableDictionary * oldDictionary;
@property (retain,nonatomic)UITableView * myTableView;
@property (retain,nonatomic)NSMutableArray * dataArray;
@property (retain,nonatomic)UIButton * navigationButton;
@property (retain,nonatomic)UIImageView * tiaojianImageView;
@end
