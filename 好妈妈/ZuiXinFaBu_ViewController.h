//
//  ZuiXinFaBu_ViewController.h
//  好妈妈
//
//  Created by liuguozhu on 17/9/13.
//  Copyright (c) 2013 1510Cloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "AnalysisClass.h"
#import "TishiView.h"
@class AsyncImageView;

@interface ZuiXinFaBu_ViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableHeaderDelegate,AnalysisClassDelegate,UIAlertViewDelegate>
{
    UIButton * gengduoButton;
    BOOL fenyeBool;
    int page;
    EGORefreshTableHeaderView * _refreshHeaderView;
    BOOL _reloading;
    BOOL isJoin;
    UIButton* join;
    AsyncImageView * headImage;
    UILabel* titleLabel;
    UILabel* huifu1;
    UILabel* chengyuanNUm;
    UILabel* join1;
    UIButton* mark;
    UILabel* markNum;
    int tagNum;
    AnalysisClass * analysis;
    UIScrollView * tagScrollView;
    UIActivityIndicatorView * activityView;
}
@property (retain,nonatomic)UIImageView * tiaojianImageView;
@property (retain,nonatomic)UIButton * navigationButton;
@property (retain,nonatomic) NSMutableDictionary * asiInfoDictionary;
@property (retain,nonatomic) TishiView * tishiView;
@property (retain,nonatomic) UIScrollView * mainScrollView;
@property (retain,nonatomic) UITableView * myTableview;
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@property (retain,nonatomic) NSMutableArray * dataArray;
@property (retain,nonatomic) UIImageView * biaoqianImageView;
@property (retain,nonatomic) NSMutableDictionary * quanziDintionary;
@property (retain,nonatomic) NSMutableArray * allDataArray;
@end
