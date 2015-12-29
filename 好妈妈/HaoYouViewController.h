//
//  HaoYouViewController.h
//  好妈妈
//
//  Created by iHope on 13-10-15.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TishiView;
#import "AnalysisClass.h"
#import "PullingRefreshTableView.h"

@interface HaoYouViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,AnalysisClassDelegate,UIAlertViewDelegate>
{
    int page;
    AnalysisClass * analysis;
    int guanzhuNum;
    PullingRefreshTableView *_uitable;

}
@property (retain,nonatomic) NSMutableArray * dataArray;
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@property (retain,nonatomic) TishiView * tishiView;
@property (retain,nonatomic) UITableView * myTableView;
@property (retain,nonatomic) UIButton * navigationButton;
@property (retain,nonatomic) UIImageView * tiaojianImageView;
@end
