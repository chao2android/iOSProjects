//
//  WoViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-22.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableHeaderView.h"
#import "AnalysisClass.h"
@class TishiView;
@class AsyncImageView;
@interface WoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,EGORefreshTableHeaderDelegate,AnalysisClassDelegate,UIActionSheetDelegate,UIAlertViewDelegate>
{
    UILabel * tishiLabel;
    EGORefreshTableHeaderView * _refreshHeaderView;
    BOOL _reloading;
    AnalysisClass * analysis;
    UILabel * navigationLabel;
    UIButton * guanzhuButton;
    BOOL sixinBool;
    int quanziID;
    int arraycount;
    UITableView * dTableView;
//    NSString * baobaoJintianstring;
    NSString * titles;
    AsyncImageView* imageV;
    BOOL controllerBool;
    UITableView * myTableView;
}
@property (retain,nonatomic)TishiView * tishiView;
@property (retain,nonatomic)UIScrollView * imageScrollView;
@property (retain,nonatomic)NSMutableDictionary * oldDictionary;
@property (retain,nonatomic)UIScrollView * myScrollView;
@property (retain,nonatomic)NSMutableDictionary * dataDictionary;
@property (retain,nonatomic)NSMutableArray * dataArray;
@property (retain,nonatomic)NSMutableArray * dArray;
@property (retain,nonatomic)NSString * idString;
@end
