//
//  GerzxViewController.h
//  好妈妈
//
//  Created by iHope on 13-9-29.
//  Copyright (c) 2013年 iHope. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
@class TishiView;
#import "AnalysisClass.h"
@interface GerzxViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,AnalysisClassDelegate>
{
    UIButton * rightBut;
    UITableView * tableview;
    AnalysisClass * analysis;
    BOOL bianjiBool;
}
@property (retain,nonatomic)TishiView * tishiView;
@property (retain,nonatomic) NSMutableDictionary * oldDictionary;
@property (retain,nonatomic) AsyncImageView * touxiangImageView;
@property (retain,nonatomic) UILabel * nichengLabel;
@property (retain,nonatomic) UILabel * qianmingLabel;
@property (retain,nonatomic) UILabel * diquLabel;
@property (retain,nonatomic) UILabel * xinxiLabel;
@property (retain,nonatomic) UILabel * xingbieLabel;
@property (retain,nonatomic) UILabel * shengriLabel;
@end
